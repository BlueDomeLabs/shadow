// lib/data/datasources/local/daos/fasting_session_dao.dart
// Phase 15b — DAO for fasting_sessions table
// Per 59_DIET_TRACKING.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/fasting_sessions_table.dart';
import 'package:shadow_app/domain/entities/fasting_session.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'fasting_session_dao.g.dart';

/// Data Access Object for the fasting_sessions table.
@DriftAccessor(tables: [FastingSessions])
class FastingSessionDao extends DatabaseAccessor<AppDatabase>
    with _$FastingSessionDaoMixin {
  FastingSessionDao(super.db);

  /// Get all fasting sessions for a profile, most recent first.
  Future<Result<List<domain.FastingSession>, AppError>> getByProfile(
    String profileId, {
    int? limit,
  }) async {
    try {
      var query = select(fastingSessions)
        ..where((s) => s.profileId.equals(profileId) & s.syncDeletedAt.isNull())
        ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]);
      if (limit != null) {
        query = query..limit(limit);
      }
      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('fasting_sessions', e.toString(), stack),
      );
    }
  }

  /// Get the currently active fasting session (endedAt is null).
  Future<Result<domain.FastingSession?, AppError>> getActiveFast(
    String profileId,
  ) async {
    try {
      final row =
          await (select(fastingSessions)..where(
                (s) =>
                    s.profileId.equals(profileId) &
                    s.endedAt.isNull() &
                    s.syncDeletedAt.isNull(),
              ))
              .getSingleOrNull();
      return Success(row == null ? null : _rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('fasting_sessions', e.toString(), stack),
      );
    }
  }

  /// Get a single fasting session by ID.
  Future<Result<domain.FastingSession, AppError>> getById(String id) async {
    try {
      final row =
          await (select(fastingSessions)
                ..where((s) => s.id.equals(id) & s.syncDeletedAt.isNull()))
              .getSingleOrNull();
      if (row == null) {
        return Failure(DatabaseError.notFound('FastingSession', id));
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('fasting_sessions', e.toString(), stack),
      );
    }
  }

  /// Create a new fasting session.
  Future<Result<domain.FastingSession, AppError>> create(
    domain.FastingSession entity,
  ) async {
    try {
      await into(fastingSessions).insert(_entityToCompanion(entity));
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('fasting_sessions', e, stack));
    }
  }

  /// Update a fasting session (e.g. set endedAt when fast ends).
  Future<Result<domain.FastingSession, AppError>> updateEntity(
    domain.FastingSession entity,
  ) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) return existsResult;

      await (update(fastingSessions)..where((s) => s.id.equals(entity.id)))
          .write(_entityToCompanion(entity));
      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('fasting_sessions', entity.id, e, stack),
      );
    }
  }

  /// Soft delete a fasting session.
  Future<Result<void, AppError>> softDelete(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            fastingSessions,
          )..where((s) => s.id.equals(id) & s.syncDeletedAt.isNull())).write(
            FastingSessionsCompanion(
              syncDeletedAt: Value(now),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.deleted.value),
            ),
          );
      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('FastingSession', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.deleteFailed('fasting_sessions', id, e, stack),
      );
    }
  }

  /// Hard delete a fasting session.
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        fastingSessions,
      )..where((s) => s.id.equals(id))).go();
      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('FastingSession', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.deleteFailed('fasting_sessions', id, e, stack),
      );
    }
  }

  /// Get modified since timestamp (for sync).
  Future<Result<List<domain.FastingSession>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final rows =
          await (select(fastingSessions)
                ..where((s) => s.syncUpdatedAt.isBiggerThanValue(since))
                ..orderBy([(s) => OrderingTerm.asc(s.syncUpdatedAt)]))
              .get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('fasting_sessions', e.toString(), stack),
      );
    }
  }

  /// Get entries pending sync.
  Future<Result<List<domain.FastingSession>, AppError>> getPendingSync() async {
    try {
      final rows =
          await (select(fastingSessions)
                ..where((s) => s.syncIsDirty.equals(true))
                ..orderBy([(s) => OrderingTerm.asc(s.syncUpdatedAt)]))
              .get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('fasting_sessions', e.toString(), stack),
      );
    }
  }

  domain.FastingSession _rowToEntity(FastingSessionRow row) =>
      domain.FastingSession(
        id: row.id,
        clientId: row.clientId,
        profileId: row.profileId,
        protocol: DietPresetType.fromValue(row.protocol),
        startedAt: row.startedAt,
        endedAt: row.endedAt,
        targetHours: row.targetHours,
        isManualEnd: row.isManualEnd,
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

  FastingSessionsCompanion _entityToCompanion(domain.FastingSession entity) =>
      FastingSessionsCompanion(
        id: Value(entity.id),
        clientId: Value(entity.clientId),
        profileId: Value(entity.profileId),
        protocol: Value(entity.protocol.value),
        startedAt: Value(entity.startedAt),
        endedAt: Value(entity.endedAt),
        targetHours: Value(entity.targetHours),
        isManualEnd: Value(entity.isManualEnd),
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
