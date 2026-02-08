// lib/data/datasources/local/daos/condition_dao.dart
// Data Access Object for conditions table per 22_API_CONTRACTS.md Section 10.8

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/conditions_table.dart';
import 'package:shadow_app/domain/entities/condition.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'condition_dao.g.dart';

/// Data Access Object for the conditions table.
///
/// Implements all database operations for Condition entities.
/// Returns Result types for all operations per 22_API_CONTRACTS.md.
@DriftAccessor(tables: [Conditions])
class ConditionDao extends DatabaseAccessor<AppDatabase>
    with _$ConditionDaoMixin {
  ConditionDao(super.db);

  /// Get all conditions, optionally filtered by profile.
  Future<Result<List<domain.Condition>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(conditions)
        ..where((c) => c.syncDeletedAt.isNull())
        ..orderBy([(c) => OrderingTerm.desc(c.syncCreatedAt)]);

      if (profileId != null) {
        query = query..where((c) => c.profileId.equals(profileId));
      }

      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('conditions', e.toString(), stack),
      );
    }
  }

  /// Get a single condition by ID.
  Future<Result<domain.Condition, AppError>> getById(String id) async {
    try {
      final query = select(conditions)
        ..where((c) => c.id.equals(id) & c.syncDeletedAt.isNull());

      final row = await query.getSingleOrNull();

      if (row == null) {
        return Failure(DatabaseError.notFound('Condition', id));
      }

      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('conditions', e.toString(), stack),
      );
    }
  }

  /// Create a new condition.
  Future<Result<domain.Condition, AppError>> create(
    domain.Condition entity,
  ) async {
    try {
      final companion = _entityToCompanion(entity);
      await into(conditions).insert(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('conditions', e, stack));
    }
  }

  /// Update an existing condition.
  Future<Result<domain.Condition, AppError>> updateEntity(
    domain.Condition entity, {
    bool markDirty = true,
  }) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) {
        return existsResult;
      }

      final companion = _entityToCompanion(entity);
      await (update(
        conditions,
      )..where((c) => c.id.equals(entity.id))).write(companion);

      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('conditions', entity.id, e, stack),
      );
    }
  }

  /// Soft delete a condition.
  Future<Result<void, AppError>> softDelete(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            conditions,
          )..where((c) => c.id.equals(id) & c.syncDeletedAt.isNull())).write(
            ConditionsCompanion(
              syncDeletedAt: Value(now),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.deleted.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('Condition', id));
      }

      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('conditions', id, e, stack));
    }
  }

  /// Hard delete a condition (permanent removal).
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        conditions,
      )..where((c) => c.id.equals(id))).go();

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('Condition', id));
      }

      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('conditions', id, e, stack));
    }
  }

  /// Get conditions modified since timestamp (for sync).
  Future<Result<List<domain.Condition>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final query = select(conditions)
        ..where((c) => c.syncUpdatedAt.isBiggerThanValue(since))
        ..orderBy([(c) => OrderingTerm.asc(c.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('conditions', e.toString(), stack),
      );
    }
  }

  /// Get conditions pending sync.
  Future<Result<List<domain.Condition>, AppError>> getPendingSync() async {
    try {
      final query = select(conditions)
        ..where((c) => c.syncIsDirty.equals(true))
        ..orderBy([(c) => OrderingTerm.asc(c.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('conditions', e.toString(), stack),
      );
    }
  }

  /// Get conditions by profile with optional filters.
  Future<Result<List<domain.Condition>, AppError>> getByProfile(
    String profileId, {
    ConditionStatus? status,
    bool includeArchived = false,
  }) async {
    try {
      var query = select(conditions)
        ..where((c) => c.profileId.equals(profileId) & c.syncDeletedAt.isNull())
        ..orderBy([(c) => OrderingTerm.asc(c.name)]);

      if (status != null) {
        query = query..where((c) => c.status.equals(status.value));
      }

      if (!includeArchived) {
        query = query..where((c) => c.isArchived.equals(false));
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('conditions', e.toString(), stack),
      );
    }
  }

  /// Get active (non-archived) conditions for a profile.
  Future<Result<List<domain.Condition>, AppError>> getActive(
    String profileId,
  ) async {
    try {
      final query = select(conditions)
        ..where(
          (c) =>
              c.profileId.equals(profileId) &
              c.syncDeletedAt.isNull() &
              c.isArchived.equals(false) &
              c.status.equals(ConditionStatus.active.value),
        )
        ..orderBy([(c) => OrderingTerm.asc(c.name)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('conditions', e.toString(), stack),
      );
    }
  }

  /// Archive a condition.
  Future<Result<void, AppError>> archive(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            conditions,
          )..where((c) => c.id.equals(id) & c.syncDeletedAt.isNull())).write(
            ConditionsCompanion(
              isArchived: const Value(true),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.modified.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('Condition', id));
      }

      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.updateFailed('conditions', id, e, stack));
    }
  }

  /// Resolve a condition (mark as resolved status).
  Future<Result<void, AppError>> resolve(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            conditions,
          )..where((c) => c.id.equals(id) & c.syncDeletedAt.isNull())).write(
            ConditionsCompanion(
              status: Value(ConditionStatus.resolved.value),
              endDate: Value(now),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.modified.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('Condition', id));
      }

      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.updateFailed('conditions', id, e, stack));
    }
  }

  /// Convert database row to domain Condition entity.
  domain.Condition _rowToEntity(ConditionRow row) {
    final bodyLocationsList = _parseBodyLocations(row.bodyLocations);
    final triggersList = _parseJsonList(row.triggers);

    return domain.Condition(
      id: row.id,
      clientId: row.clientId,
      profileId: row.profileId,
      name: row.name,
      category: row.category,
      bodyLocations: bodyLocationsList,
      triggers: triggersList,
      description: row.description,
      baselinePhotoPath: row.baselinePhotoPath,
      startTimeframe: row.startTimeframe,
      endDate: row.endDate,
      status: ConditionStatus.fromValue(row.status),
      isArchived: row.isArchived,
      activityId: row.activityId,
      cloudStorageUrl: row.cloudStorageUrl,
      fileHash: row.fileHash,
      fileSizeBytes: row.fileSizeBytes,
      isFileUploaded: row.isFileUploaded,
      syncMetadata: SyncMetadata(
        syncCreatedAt: row.syncCreatedAt,
        syncUpdatedAt: row.syncUpdatedAt ?? row.syncCreatedAt,
        syncDeletedAt: row.syncDeletedAt,
        syncLastSyncedAt: row.syncLastSyncedAt,
        syncStatus: SyncStatus.fromValue(row.syncStatus),
        syncVersion: row.syncVersion,
        syncDeviceId: row.syncDeviceId ?? '',
        syncIsDirty: row.syncIsDirty,
        conflictData: row.conflictData,
      ),
    );
  }

  /// Convert domain Condition entity to database companion.
  ConditionsCompanion _entityToCompanion(domain.Condition entity) =>
      ConditionsCompanion(
        id: Value(entity.id),
        clientId: Value(entity.clientId),
        profileId: Value(entity.profileId),
        name: Value(entity.name),
        category: Value(entity.category),
        bodyLocations: Value(jsonEncode(entity.bodyLocations)),
        triggers: Value(jsonEncode(entity.triggers)),
        description: Value(entity.description),
        baselinePhotoPath: Value(entity.baselinePhotoPath),
        startTimeframe: Value(entity.startTimeframe),
        endDate: Value(entity.endDate),
        status: Value(entity.status.value),
        isArchived: Value(entity.isArchived),
        activityId: Value(entity.activityId),
        cloudStorageUrl: Value(entity.cloudStorageUrl),
        fileHash: Value(entity.fileHash),
        fileSizeBytes: Value(entity.fileSizeBytes),
        isFileUploaded: Value(entity.isFileUploaded),
        syncCreatedAt: Value(entity.syncMetadata.syncCreatedAt),
        syncUpdatedAt: Value(entity.syncMetadata.syncUpdatedAt),
        syncDeletedAt: Value(entity.syncMetadata.syncDeletedAt),
        syncLastSyncedAt: Value(entity.syncMetadata.syncLastSyncedAt),
        syncStatus: Value(entity.syncMetadata.syncStatus.value),
        syncVersion: Value(entity.syncMetadata.syncVersion),
        syncDeviceId: Value(entity.syncMetadata.syncDeviceId),
        syncIsDirty: Value(entity.syncMetadata.syncIsDirty),
        conflictData: Value(entity.syncMetadata.conflictData),
      );

  List<String> _parseBodyLocations(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list.map((item) => item.toString()).toList();
    } on Exception {
      return [];
    }
  }

  List<String> _parseJsonList(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list.map((item) => item.toString()).toList();
    } on Exception {
      return [];
    }
  }
}
