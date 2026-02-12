// lib/data/datasources/local/daos/intake_log_dao.dart
// Data Access Object for intake_logs table per 22_API_CONTRACTS.md Section 10.10

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/intake_logs_table.dart';
import 'package:shadow_app/domain/entities/intake_log.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'intake_log_dao.g.dart';

/// Data Access Object for the intake_logs table.
///
/// Implements all database operations for IntakeLog entities.
/// Returns Result types for all operations per 22_API_CONTRACTS.md.
@DriftAccessor(tables: [IntakeLogs])
class IntakeLogDao extends DatabaseAccessor<AppDatabase>
    with _$IntakeLogDaoMixin {
  IntakeLogDao(super.db);

  /// Get all intake logs, optionally filtered by profile.
  Future<Result<List<domain.IntakeLog>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(intakeLogs)
        ..where((i) => i.syncDeletedAt.isNull())
        ..orderBy([(i) => OrderingTerm.desc(i.scheduledTime)]);

      if (profileId != null) {
        query = query..where((i) => i.profileId.equals(profileId));
      }

      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('intake_logs', e.toString(), stack),
      );
    }
  }

  /// Get a single intake log by ID.
  Future<Result<domain.IntakeLog, AppError>> getById(String id) async {
    try {
      final query = select(intakeLogs)
        ..where((i) => i.id.equals(id) & i.syncDeletedAt.isNull());

      final row = await query.getSingleOrNull();

      if (row == null) {
        return Failure(DatabaseError.notFound('IntakeLog', id));
      }

      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('intake_logs', e.toString(), stack),
      );
    }
  }

  /// Create a new intake log.
  Future<Result<domain.IntakeLog, AppError>> create(
    domain.IntakeLog entity,
  ) async {
    try {
      final companion = _entityToCompanion(entity);
      await into(intakeLogs).insert(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('intake_logs', e, stack));
    }
  }

  /// Update an existing intake log.
  Future<Result<domain.IntakeLog, AppError>> updateEntity(
    domain.IntakeLog entity, {
    bool markDirty = true,
  }) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) {
        return existsResult;
      }

      final companion = _entityToCompanion(entity);
      await (update(
        intakeLogs,
      )..where((i) => i.id.equals(entity.id))).write(companion);

      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('intake_logs', entity.id, e, stack),
      );
    }
  }

  /// Soft delete an intake log.
  Future<Result<void, AppError>> softDelete(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            intakeLogs,
          )..where((i) => i.id.equals(id) & i.syncDeletedAt.isNull())).write(
            IntakeLogsCompanion(
              syncDeletedAt: Value(now),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.deleted.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('IntakeLog', id));
      }

      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('intake_logs', id, e, stack));
    }
  }

  /// Hard delete an intake log (permanent removal).
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        intakeLogs,
      )..where((i) => i.id.equals(id))).go();

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('IntakeLog', id));
      }

      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('intake_logs', id, e, stack));
    }
  }

  /// Get intake logs modified since timestamp (for sync).
  Future<Result<List<domain.IntakeLog>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final query = select(intakeLogs)
        ..where((i) => i.syncUpdatedAt.isBiggerThanValue(since))
        ..orderBy([(i) => OrderingTerm.asc(i.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('intake_logs', e.toString(), stack),
      );
    }
  }

  /// Get intake logs pending sync.
  Future<Result<List<domain.IntakeLog>, AppError>> getPendingSync() async {
    try {
      final query = select(intakeLogs)
        ..where((i) => i.syncIsDirty.equals(true))
        ..orderBy([(i) => OrderingTerm.asc(i.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('intake_logs', e.toString(), stack),
      );
    }
  }

  /// Get intake logs by profile with optional filters.
  Future<Result<List<domain.IntakeLog>, AppError>> getByProfile(
    String profileId, {
    IntakeLogStatus? status,
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(intakeLogs)
        ..where((i) => i.profileId.equals(profileId) & i.syncDeletedAt.isNull())
        ..orderBy([(i) => OrderingTerm.desc(i.scheduledTime)]);

      if (status != null) {
        query = query..where((i) => i.status.equals(status.value));
      }

      if (startDate != null) {
        query = query
          ..where((i) => i.scheduledTime.isBiggerOrEqualValue(startDate));
      }

      if (endDate != null) {
        query = query
          ..where((i) => i.scheduledTime.isSmallerOrEqualValue(endDate));
      }

      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('intake_logs', e.toString(), stack),
      );
    }
  }

  /// Get intake logs for a specific supplement.
  Future<Result<List<domain.IntakeLog>, AppError>> getBySupplement(
    String supplementId, {
    int? startDate,
    int? endDate,
  }) async {
    try {
      var query = select(intakeLogs)
        ..where(
          (i) => i.supplementId.equals(supplementId) & i.syncDeletedAt.isNull(),
        )
        ..orderBy([(i) => OrderingTerm.desc(i.scheduledTime)]);

      if (startDate != null) {
        query = query
          ..where((i) => i.scheduledTime.isBiggerOrEqualValue(startDate));
      }

      if (endDate != null) {
        query = query
          ..where((i) => i.scheduledTime.isSmallerOrEqualValue(endDate));
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('intake_logs', e.toString(), stack),
      );
    }
  }

  /// Get pending intake logs for a specific date.
  Future<Result<List<domain.IntakeLog>, AppError>> getPendingForDate(
    String profileId,
    int date, // Start of day epoch ms
  ) async {
    try {
      final endOfDay = date + Duration.millisecondsPerDay - 1;
      final query = select(intakeLogs)
        ..where(
          (i) =>
              i.profileId.equals(profileId) &
              i.syncDeletedAt.isNull() &
              i.status.equals(IntakeLogStatus.pending.value) &
              i.scheduledTime.isBiggerOrEqualValue(date) &
              i.scheduledTime.isSmallerOrEqualValue(endOfDay),
        )
        ..orderBy([(i) => OrderingTerm.asc(i.scheduledTime)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('intake_logs', e.toString(), stack),
      );
    }
  }

  /// Mark an intake as taken.
  Future<Result<domain.IntakeLog, AppError>> markTaken(
    String id,
    int actualTime,
  ) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            intakeLogs,
          )..where((i) => i.id.equals(id) & i.syncDeletedAt.isNull())).write(
            IntakeLogsCompanion(
              status: Value(IntakeLogStatus.taken.value),
              actualTime: Value(actualTime),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.modified.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('IntakeLog', id));
      }

      return getById(id);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.updateFailed('intake_logs', id, e, stack));
    }
  }

  /// Mark an intake as skipped.
  Future<Result<domain.IntakeLog, AppError>> markSkipped(
    String id,
    String? reason,
  ) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            intakeLogs,
          )..where((i) => i.id.equals(id) & i.syncDeletedAt.isNull())).write(
            IntakeLogsCompanion(
              status: Value(IntakeLogStatus.skipped.value),
              reason: Value(reason),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.modified.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('IntakeLog', id));
      }

      return getById(id);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.updateFailed('intake_logs', id, e, stack));
    }
  }

  /// Mark an intake as snoozed.
  Future<Result<domain.IntakeLog, AppError>> markSnoozed(
    String id,
    int snoozeDurationMinutes,
  ) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            intakeLogs,
          )..where((i) => i.id.equals(id) & i.syncDeletedAt.isNull())).write(
            IntakeLogsCompanion(
              status: Value(IntakeLogStatus.snoozed.value),
              snoozeDurationMinutes: Value(snoozeDurationMinutes),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.modified.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('IntakeLog', id));
      }

      return getById(id);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.updateFailed('intake_logs', id, e, stack));
    }
  }

  /// Convert database row to domain IntakeLog entity.
  domain.IntakeLog _rowToEntity(IntakeLogRow row) => domain.IntakeLog(
    id: row.id,
    clientId: row.clientId,
    profileId: row.profileId,
    supplementId: row.supplementId,
    scheduledTime: row.scheduledTime,
    actualTime: row.actualTime,
    status: IntakeLogStatus.fromValue(row.status),
    reason: row.reason,
    note: row.note,
    snoozeDurationMinutes: row.snoozeDurationMinutes,
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

  /// Convert domain IntakeLog entity to database companion.
  IntakeLogsCompanion _entityToCompanion(domain.IntakeLog entity) =>
      IntakeLogsCompanion(
        id: Value(entity.id),
        clientId: Value(entity.clientId),
        profileId: Value(entity.profileId),
        supplementId: Value(entity.supplementId),
        scheduledTime: Value(entity.scheduledTime),
        actualTime: Value(entity.actualTime),
        status: Value(entity.status.value),
        reason: Value(entity.reason),
        note: Value(entity.note),
        snoozeDurationMinutes: Value(entity.snoozeDurationMinutes),
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
}
