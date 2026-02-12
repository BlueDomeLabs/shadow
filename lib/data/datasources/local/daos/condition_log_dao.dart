// lib/data/datasources/local/daos/condition_log_dao.dart
// Data Access Object for condition_logs table per 22_API_CONTRACTS.md Section 10.9

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/condition_logs_table.dart';
import 'package:shadow_app/domain/entities/condition_log.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';

part 'condition_log_dao.g.dart';

/// Data Access Object for the condition_logs table.
///
/// Implements all database operations for ConditionLog entities.
/// Returns Result types for all operations per 22_API_CONTRACTS.md.
@DriftAccessor(tables: [ConditionLogs])
class ConditionLogDao extends DatabaseAccessor<AppDatabase>
    with _$ConditionLogDaoMixin {
  ConditionLogDao(super.db);

  /// Get all condition logs, optionally filtered by profile.
  Future<Result<List<domain.ConditionLog>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(conditionLogs)
        ..where((c) => c.syncDeletedAt.isNull())
        ..orderBy([(c) => OrderingTerm.desc(c.timestamp)]);

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
        DatabaseError.queryFailed('condition_logs', e.toString(), stack),
      );
    }
  }

  /// Get a single condition log by ID.
  Future<Result<domain.ConditionLog, AppError>> getById(String id) async {
    try {
      final query = select(conditionLogs)
        ..where((c) => c.id.equals(id) & c.syncDeletedAt.isNull());

      final row = await query.getSingleOrNull();

      if (row == null) {
        return Failure(DatabaseError.notFound('ConditionLog', id));
      }

      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('condition_logs', e.toString(), stack),
      );
    }
  }

  /// Create a new condition log.
  Future<Result<domain.ConditionLog, AppError>> create(
    domain.ConditionLog entity,
  ) async {
    try {
      final companion = _entityToCompanion(entity);
      await into(conditionLogs).insert(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('condition_logs', e, stack));
    }
  }

  /// Update an existing condition log.
  Future<Result<domain.ConditionLog, AppError>> updateEntity(
    domain.ConditionLog entity, {
    bool markDirty = true,
  }) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) {
        return existsResult;
      }

      final companion = _entityToCompanion(entity);
      await (update(
        conditionLogs,
      )..where((c) => c.id.equals(entity.id))).write(companion);

      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('condition_logs', entity.id, e, stack),
      );
    }
  }

  /// Soft delete a condition log.
  Future<Result<void, AppError>> softDelete(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            conditionLogs,
          )..where((c) => c.id.equals(id) & c.syncDeletedAt.isNull())).write(
            ConditionLogsCompanion(
              syncDeletedAt: Value(now),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.deleted.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('ConditionLog', id));
      }

      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.deleteFailed('condition_logs', id, e, stack),
      );
    }
  }

  /// Hard delete a condition log (permanent removal).
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        conditionLogs,
      )..where((c) => c.id.equals(id))).go();

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('ConditionLog', id));
      }

      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.deleteFailed('condition_logs', id, e, stack),
      );
    }
  }

  /// Get condition logs modified since timestamp (for sync).
  Future<Result<List<domain.ConditionLog>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final query = select(conditionLogs)
        ..where((c) => c.syncUpdatedAt.isBiggerThanValue(since))
        ..orderBy([(c) => OrderingTerm.asc(c.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('condition_logs', e.toString(), stack),
      );
    }
  }

  /// Get condition logs pending sync.
  Future<Result<List<domain.ConditionLog>, AppError>> getPendingSync() async {
    try {
      final query = select(conditionLogs)
        ..where((c) => c.syncIsDirty.equals(true))
        ..orderBy([(c) => OrderingTerm.asc(c.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('condition_logs', e.toString(), stack),
      );
    }
  }

  /// Get condition logs by profile with optional filters.
  Future<Result<List<domain.ConditionLog>, AppError>> getByProfile(
    String profileId, {
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(conditionLogs)
        ..where((c) => c.profileId.equals(profileId) & c.syncDeletedAt.isNull())
        ..orderBy([(c) => OrderingTerm.desc(c.timestamp)]);

      if (startDate != null) {
        query = query
          ..where((c) => c.timestamp.isBiggerOrEqualValue(startDate));
      }

      if (endDate != null) {
        query = query..where((c) => c.timestamp.isSmallerOrEqualValue(endDate));
      }

      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('condition_logs', e.toString(), stack),
      );
    }
  }

  /// Get condition logs for a specific condition.
  Future<Result<List<domain.ConditionLog>, AppError>> getByCondition(
    String conditionId, {
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(conditionLogs)
        ..where(
          (c) => c.conditionId.equals(conditionId) & c.syncDeletedAt.isNull(),
        )
        ..orderBy([(c) => OrderingTerm.desc(c.timestamp)]);

      if (startDate != null) {
        query = query
          ..where((c) => c.timestamp.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query = query..where((c) => c.timestamp.isSmallerOrEqualValue(endDate));
      }
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('condition_logs', e.toString(), stack),
      );
    }
  }

  /// Get condition logs by date range.
  Future<Result<List<domain.ConditionLog>, AppError>> getByDateRange(
    String profileId,
    int start,
    int end,
  ) async {
    try {
      final query = select(conditionLogs)
        ..where(
          (c) =>
              c.profileId.equals(profileId) &
              c.syncDeletedAt.isNull() &
              c.timestamp.isBiggerOrEqualValue(start) &
              c.timestamp.isSmallerOrEqualValue(end),
        )
        ..orderBy([(c) => OrderingTerm.desc(c.timestamp)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('condition_logs', e.toString(), stack),
      );
    }
  }

  /// Get flare logs for a specific condition.
  Future<Result<List<domain.ConditionLog>, AppError>> getFlares(
    String conditionId, {
    int? limit,
  }) async {
    try {
      var query = select(conditionLogs)
        ..where(
          (c) =>
              c.conditionId.equals(conditionId) &
              c.syncDeletedAt.isNull() &
              c.isFlare.equals(true),
        )
        ..orderBy([(c) => OrderingTerm.desc(c.timestamp)]);

      if (limit != null) {
        query = query..limit(limit);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('condition_logs', e.toString(), stack),
      );
    }
  }

  /// Convert database row to domain ConditionLog entity.
  domain.ConditionLog _rowToEntity(ConditionLogRow row) {
    final flarePhotoIdsList = _parseJsonList(row.flarePhotoIds);

    return domain.ConditionLog(
      id: row.id,
      clientId: row.clientId,
      profileId: row.profileId,
      conditionId: row.conditionId,
      timestamp: row.timestamp,
      severity: row.severity,
      notes: row.notes,
      isFlare: row.isFlare,
      flarePhotoIds: flarePhotoIdsList,
      photoPath: row.photoPath,
      activityId: row.activityId,
      triggers: row.triggers,
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

  /// Convert domain ConditionLog entity to database companion.
  ConditionLogsCompanion _entityToCompanion(domain.ConditionLog entity) =>
      ConditionLogsCompanion(
        id: Value(entity.id),
        clientId: Value(entity.clientId),
        profileId: Value(entity.profileId),
        conditionId: Value(entity.conditionId),
        timestamp: Value(entity.timestamp),
        severity: Value(entity.severity),
        notes: Value(entity.notes),
        isFlare: Value(entity.isFlare),
        flarePhotoIds: Value(jsonEncode(entity.flarePhotoIds)),
        photoPath: Value(entity.photoPath),
        activityId: Value(entity.activityId),
        triggers: Value(entity.triggers),
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

  /// Parse JSON array string to list.
  List<String> _parseJsonList(String value) {
    if (value.isEmpty) return [];
    try {
      final list = jsonDecode(value) as List<dynamic>;
      return list.map((item) => item.toString()).toList();
    } on Exception catch (e) {
      debugPrint(
        'WARNING: Failed to parse JSON in ConditionLogDao._parseJsonList: $e',
      );
      return [];
    }
  }
}
