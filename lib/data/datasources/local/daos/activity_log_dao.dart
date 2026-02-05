// lib/data/datasources/local/daos/activity_log_dao.dart
// Data Access Object for activity_logs table per 22_API_CONTRACTS.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/activity_logs_table.dart';
import 'package:shadow_app/domain/entities/activity_log.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';

part 'activity_log_dao.g.dart';

/// Data Access Object for the activity_logs table.
@DriftAccessor(tables: [ActivityLogs])
class ActivityLogDao extends DatabaseAccessor<AppDatabase>
    with _$ActivityLogDaoMixin {
  ActivityLogDao(super.db);

  /// Get all activity logs.
  Future<Result<List<domain.ActivityLog>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(activityLogs)
        ..where((a) => a.syncDeletedAt.isNull())
        ..orderBy([(a) => OrderingTerm.desc(a.timestamp)]);

      if (profileId != null) {
        query = query..where((a) => a.profileId.equals(profileId));
      }
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('activity_logs', e.toString(), stack),
      );
    }
  }

  /// Get a single activity log by ID.
  Future<Result<domain.ActivityLog, AppError>> getById(String id) async {
    try {
      final query = select(activityLogs)
        ..where((a) => a.id.equals(id) & a.syncDeletedAt.isNull());

      final row = await query.getSingleOrNull();
      if (row == null) {
        return Failure(DatabaseError.notFound('ActivityLog', id));
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('activity_logs', e.toString(), stack),
      );
    }
  }

  /// Create a new activity log.
  Future<Result<domain.ActivityLog, AppError>> create(
    domain.ActivityLog entity,
  ) async {
    try {
      final companion = _entityToCompanion(entity);
      await into(activityLogs).insert(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('activity_logs', e, stack));
    }
  }

  /// Update an existing activity log.
  Future<Result<domain.ActivityLog, AppError>> updateEntity(
    domain.ActivityLog entity,
  ) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) return existsResult;

      final companion = _entityToCompanion(entity);
      await (update(
        activityLogs,
      )..where((a) => a.id.equals(entity.id))).write(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('activity_logs', entity.id, e, stack),
      );
    }
  }

  /// Soft delete an activity log.
  Future<Result<void, AppError>> softDelete(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            activityLogs,
          )..where((a) => a.id.equals(id) & a.syncDeletedAt.isNull())).write(
            ActivityLogsCompanion(
              syncDeletedAt: Value(now),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.deleted.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('ActivityLog', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('activity_logs', id, e, stack));
    }
  }

  /// Hard delete an activity log.
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        activityLogs,
      )..where((a) => a.id.equals(id))).go();
      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('ActivityLog', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('activity_logs', id, e, stack));
    }
  }

  /// Get activity logs by profile with optional date filters.
  Future<Result<List<domain.ActivityLog>, AppError>> getByProfile(
    String profileId, {
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(activityLogs)
        ..where((a) => a.profileId.equals(profileId) & a.syncDeletedAt.isNull())
        ..orderBy([(a) => OrderingTerm.desc(a.timestamp)]);

      if (startDate != null) {
        query = query
          ..where((a) => a.timestamp.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query = query..where((a) => a.timestamp.isSmallerOrEqualValue(endDate));
      }
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('activity_logs', e.toString(), stack),
      );
    }
  }

  /// Get activity logs for a specific date.
  Future<Result<List<domain.ActivityLog>, AppError>> getForDate(
    String profileId,
    int date,
  ) async {
    try {
      // Get entries within the day (date to date + 24 hours)
      final endOfDay = date + 86400000; // 24 hours in ms
      final query = select(activityLogs)
        ..where(
          (a) =>
              a.profileId.equals(profileId) &
              a.syncDeletedAt.isNull() &
              a.timestamp.isBiggerOrEqualValue(date) &
              a.timestamp.isSmallerThanValue(endOfDay),
        )
        ..orderBy([(a) => OrderingTerm.desc(a.timestamp)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('activity_logs', e.toString(), stack),
      );
    }
  }

  /// Get activity log by external import ID (for deduplication).
  Future<Result<domain.ActivityLog?, AppError>> getByExternalId(
    String profileId,
    String importSource,
    String importExternalId,
  ) async {
    try {
      final query = select(activityLogs)
        ..where(
          (a) =>
              a.profileId.equals(profileId) &
              a.syncDeletedAt.isNull() &
              a.importSource.equals(importSource) &
              a.importExternalId.equals(importExternalId),
        )
        ..limit(1);

      final row = await query.getSingleOrNull();
      return Success(row != null ? _rowToEntity(row) : null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('activity_logs', e.toString(), stack),
      );
    }
  }

  /// Get modified since timestamp.
  Future<Result<List<domain.ActivityLog>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final query = select(activityLogs)
        ..where((a) => a.syncUpdatedAt.isBiggerThanValue(since))
        ..orderBy([(a) => OrderingTerm.asc(a.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('activity_logs', e.toString(), stack),
      );
    }
  }

  /// Get entries pending sync.
  Future<Result<List<domain.ActivityLog>, AppError>> getPendingSync() async {
    try {
      final query = select(activityLogs)
        ..where((a) => a.syncIsDirty.equals(true))
        ..orderBy([(a) => OrderingTerm.asc(a.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('activity_logs', e.toString(), stack),
      );
    }
  }

  /// Convert database row to domain entity.
  domain.ActivityLog _rowToEntity(ActivityLogRow row) => domain.ActivityLog(
    id: row.id,
    clientId: row.clientId,
    profileId: row.profileId,
    timestamp: row.timestamp,
    activityIds: _parseList(row.activityIds),
    adHocActivities: _parseList(row.adHocActivities),
    duration: row.duration,
    notes: row.notes,
    importSource: row.importSource,
    importExternalId: row.importExternalId,
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
  ActivityLogsCompanion _entityToCompanion(domain.ActivityLog entity) =>
      ActivityLogsCompanion(
        id: Value(entity.id),
        clientId: Value(entity.clientId),
        profileId: Value(entity.profileId),
        timestamp: Value(entity.timestamp),
        activityIds: Value(entity.activityIds.join(',')),
        adHocActivities: Value(entity.adHocActivities.join(',')),
        duration: Value(entity.duration),
        notes: Value(entity.notes),
        importSource: Value(entity.importSource),
        importExternalId: Value(entity.importExternalId),
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

  /// Parse comma-separated string to list.
  List<String> _parseList(String value) {
    if (value.isEmpty) return [];
    return value.split(',').where((s) => s.isNotEmpty).toList();
  }
}
