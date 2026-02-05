// lib/data/datasources/local/daos/flare_up_dao.dart
// Data Access Object for flare_ups table per 22_API_CONTRACTS.md

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/flare_ups_table.dart';
import 'package:shadow_app/domain/entities/flare_up.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';

part 'flare_up_dao.g.dart';

/// Data Access Object for the flare_ups table.
@DriftAccessor(tables: [FlareUps])
class FlareUpDao extends DatabaseAccessor<AppDatabase> with _$FlareUpDaoMixin {
  FlareUpDao(super.db);

  /// Get all flare-ups.
  Future<Result<List<domain.FlareUp>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(flareUps)
        ..where((f) => f.syncDeletedAt.isNull())
        ..orderBy([(f) => OrderingTerm.desc(f.startDate)]);

      if (profileId != null) {
        query = query..where((f) => f.profileId.equals(profileId));
      }
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('flare_ups', e.toString(), stack),
      );
    }
  }

  /// Get a single flare-up by ID.
  Future<Result<domain.FlareUp, AppError>> getById(String id) async {
    try {
      final query = select(flareUps)
        ..where((f) => f.id.equals(id) & f.syncDeletedAt.isNull());

      final row = await query.getSingleOrNull();
      if (row == null) {
        return Failure(DatabaseError.notFound('FlareUp', id));
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('flare_ups', e.toString(), stack),
      );
    }
  }

  /// Create a new flare-up.
  Future<Result<domain.FlareUp, AppError>> create(domain.FlareUp entity) async {
    try {
      final companion = _entityToCompanion(entity);
      await into(flareUps).insert(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('flare_ups', e, stack));
    }
  }

  /// Update an existing flare-up.
  Future<Result<domain.FlareUp, AppError>> updateEntity(
    domain.FlareUp entity, {
    bool markDirty = true,
  }) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) return existsResult;

      final companion = _entityToCompanion(entity);
      await (update(
        flareUps,
      )..where((f) => f.id.equals(entity.id))).write(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('flare_ups', entity.id, e, stack),
      );
    }
  }

  /// Soft delete a flare-up.
  Future<Result<void, AppError>> softDelete(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            flareUps,
          )..where((f) => f.id.equals(id) & f.syncDeletedAt.isNull())).write(
            FlareUpsCompanion(
              syncDeletedAt: Value(now),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.deleted.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('FlareUp', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('flare_ups', id, e, stack));
    }
  }

  /// Hard delete a flare-up.
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        flareUps,
      )..where((f) => f.id.equals(id))).go();
      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('FlareUp', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('flare_ups', id, e, stack));
    }
  }

  /// Get flare-ups by condition with filtering.
  Future<Result<List<domain.FlareUp>, AppError>> getByCondition(
    String conditionId, {
    int? startDate,
    int? endDate,
    bool? ongoingOnly,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(flareUps)
        ..where(
          (f) => f.conditionId.equals(conditionId) & f.syncDeletedAt.isNull(),
        )
        ..orderBy([(f) => OrderingTerm.desc(f.startDate)]);

      if (startDate != null) {
        query = query
          ..where((f) => f.startDate.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query = query..where((f) => f.startDate.isSmallerOrEqualValue(endDate));
      }
      if (ongoingOnly ?? false) {
        query = query..where((f) => f.endDate.isNull());
      }
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('flare_ups', e.toString(), stack),
      );
    }
  }

  /// Get flare-ups by profile with filtering.
  Future<Result<List<domain.FlareUp>, AppError>> getByProfile(
    String profileId, {
    int? startDate,
    int? endDate,
    bool? ongoingOnly,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(flareUps)
        ..where((f) => f.profileId.equals(profileId) & f.syncDeletedAt.isNull())
        ..orderBy([(f) => OrderingTerm.desc(f.startDate)]);

      if (startDate != null) {
        query = query
          ..where((f) => f.startDate.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query = query..where((f) => f.startDate.isSmallerOrEqualValue(endDate));
      }
      if (ongoingOnly ?? false) {
        query = query..where((f) => f.endDate.isNull());
      }
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('flare_ups', e.toString(), stack),
      );
    }
  }

  /// Get ongoing flare-ups for a profile.
  Future<Result<List<domain.FlareUp>, AppError>> getOngoing(
    String profileId,
  ) async {
    try {
      final query = select(flareUps)
        ..where(
          (f) =>
              f.profileId.equals(profileId) &
              f.endDate.isNull() &
              f.syncDeletedAt.isNull(),
        )
        ..orderBy([(f) => OrderingTerm.desc(f.startDate)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('flare_ups', e.toString(), stack),
      );
    }
  }

  /// End a flare-up by setting the endDate.
  Future<Result<domain.FlareUp, AppError>> endFlareUp(
    String id,
    int endDate,
  ) async {
    try {
      final existsResult = await getById(id);
      if (existsResult.isFailure) return existsResult;

      final now = DateTime.now().millisecondsSinceEpoch;
      await (update(flareUps)..where((f) => f.id.equals(id))).write(
        FlareUpsCompanion(
          endDate: Value(endDate),
          syncUpdatedAt: Value(now),
          syncIsDirty: const Value(true),
        ),
      );
      return getById(id);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.updateFailed('flare_ups', id, e, stack));
    }
  }

  /// Get modified since timestamp.
  Future<Result<List<domain.FlareUp>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final query = select(flareUps)
        ..where((f) => f.syncUpdatedAt.isBiggerThanValue(since))
        ..orderBy([(f) => OrderingTerm.asc(f.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('flare_ups', e.toString(), stack),
      );
    }
  }

  /// Get entries pending sync.
  Future<Result<List<domain.FlareUp>, AppError>> getPendingSync() async {
    try {
      final query = select(flareUps)
        ..where((f) => f.syncIsDirty.equals(true))
        ..orderBy([(f) => OrderingTerm.asc(f.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('flare_ups', e.toString(), stack),
      );
    }
  }

  /// Convert database row to domain entity.
  domain.FlareUp _rowToEntity(FlareUpRow row) => domain.FlareUp(
    id: row.id,
    clientId: row.clientId,
    profileId: row.profileId,
    conditionId: row.conditionId,
    startDate: row.startDate,
    endDate: row.endDate,
    severity: row.severity,
    notes: row.notes,
    triggers: _parseJsonList(row.triggers),
    activityId: row.activityId,
    photoPath: row.photoPath,
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

  /// Convert domain entity to database companion.
  FlareUpsCompanion _entityToCompanion(domain.FlareUp entity) =>
      FlareUpsCompanion(
        id: Value(entity.id),
        clientId: Value(entity.clientId),
        profileId: Value(entity.profileId),
        conditionId: Value(entity.conditionId),
        startDate: Value(entity.startDate),
        endDate: Value(entity.endDate),
        severity: Value(entity.severity),
        notes: Value(entity.notes),
        triggers: Value(jsonEncode(entity.triggers)),
        activityId: Value(entity.activityId),
        photoPath: Value(entity.photoPath),
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

  /// Parse JSON array string to list.
  List<String> _parseJsonList(String value) {
    try {
      final decoded = jsonDecode(value) as List<dynamic>;
      return decoded.map((e) => e.toString()).toList();
    } on Exception {
      return [];
    }
  }
}
