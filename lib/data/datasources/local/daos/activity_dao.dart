// lib/data/datasources/local/daos/activity_dao.dart
// Data Access Object for activities table per 22_API_CONTRACTS.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/activities_table.dart';
import 'package:shadow_app/domain/entities/activity.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';

part 'activity_dao.g.dart';

/// Data Access Object for the activities table.
@DriftAccessor(tables: [Activities])
class ActivityDao extends DatabaseAccessor<AppDatabase>
    with _$ActivityDaoMixin {
  ActivityDao(super.db);

  /// Get all activities.
  Future<Result<List<domain.Activity>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(activities)
        ..where((a) => a.syncDeletedAt.isNull())
        ..orderBy([(a) => OrderingTerm.asc(a.name)]);

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
        DatabaseError.queryFailed('activities', e.toString(), stack),
      );
    }
  }

  /// Get a single activity by ID.
  Future<Result<domain.Activity, AppError>> getById(String id) async {
    try {
      final query = select(activities)
        ..where((a) => a.id.equals(id) & a.syncDeletedAt.isNull());

      final row = await query.getSingleOrNull();
      if (row == null) {
        return Failure(DatabaseError.notFound('Activity', id));
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('activities', e.toString(), stack),
      );
    }
  }

  /// Create a new activity.
  Future<Result<domain.Activity, AppError>> create(
    domain.Activity entity,
  ) async {
    try {
      final companion = _entityToCompanion(entity);
      await into(activities).insert(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('activities', e, stack));
    }
  }

  /// Update an existing activity.
  Future<Result<domain.Activity, AppError>> updateEntity(
    domain.Activity entity, {
    bool markDirty = true,
  }) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) return existsResult;

      final companion = _entityToCompanion(entity);
      await (update(
        activities,
      )..where((a) => a.id.equals(entity.id))).write(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('activities', entity.id, e, stack),
      );
    }
  }

  /// Soft delete an activity.
  Future<Result<void, AppError>> softDelete(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            activities,
          )..where((a) => a.id.equals(id) & a.syncDeletedAt.isNull())).write(
            ActivitiesCompanion(
              syncDeletedAt: Value(now),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.deleted.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('Activity', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('activities', id, e, stack));
    }
  }

  /// Hard delete an activity.
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        activities,
      )..where((a) => a.id.equals(id))).go();
      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('Activity', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('activities', id, e, stack));
    }
  }

  /// Get activities by profile with optional archive filter.
  Future<Result<List<domain.Activity>, AppError>> getByProfile(
    String profileId, {
    bool includeArchived = false,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(activities)
        ..where((a) => a.profileId.equals(profileId) & a.syncDeletedAt.isNull())
        ..orderBy([(a) => OrderingTerm.asc(a.name)]);

      if (!includeArchived) {
        query = query..where((a) => a.isArchived.equals(false));
      }
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('activities', e.toString(), stack),
      );
    }
  }

  /// Get only active activities for a profile.
  Future<Result<List<domain.Activity>, AppError>> getActive(
    String profileId,
  ) async {
    try {
      final query = select(activities)
        ..where(
          (a) =>
              a.profileId.equals(profileId) &
              a.syncDeletedAt.isNull() &
              a.isArchived.equals(false),
        )
        ..orderBy([(a) => OrderingTerm.asc(a.name)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('activities', e.toString(), stack),
      );
    }
  }

  /// Archive an activity.
  Future<Result<void, AppError>> archive(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            activities,
          )..where((a) => a.id.equals(id) & a.syncDeletedAt.isNull())).write(
            ActivitiesCompanion(
              isArchived: const Value(true),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.modified.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('Activity', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.updateFailed('activities', id, e, stack));
    }
  }

  /// Unarchive an activity.
  Future<Result<void, AppError>> unarchive(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            activities,
          )..where((a) => a.id.equals(id) & a.syncDeletedAt.isNull())).write(
            ActivitiesCompanion(
              isArchived: const Value(false),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.modified.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('Activity', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.updateFailed('activities', id, e, stack));
    }
  }

  /// Get modified since timestamp.
  Future<Result<List<domain.Activity>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final query = select(activities)
        ..where((a) => a.syncUpdatedAt.isBiggerThanValue(since))
        ..orderBy([(a) => OrderingTerm.asc(a.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('activities', e.toString(), stack),
      );
    }
  }

  /// Get entries pending sync.
  Future<Result<List<domain.Activity>, AppError>> getPendingSync() async {
    try {
      final query = select(activities)
        ..where((a) => a.syncIsDirty.equals(true))
        ..orderBy([(a) => OrderingTerm.asc(a.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('activities', e.toString(), stack),
      );
    }
  }

  /// Convert database row to domain entity.
  domain.Activity _rowToEntity(ActivityRow row) => domain.Activity(
    id: row.id,
    clientId: row.clientId,
    profileId: row.profileId,
    name: row.name,
    description: row.description,
    location: row.location,
    triggers: row.triggers,
    durationMinutes: row.durationMinutes,
    isArchived: row.isArchived,
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
  ActivitiesCompanion _entityToCompanion(domain.Activity entity) =>
      ActivitiesCompanion(
        id: Value(entity.id),
        clientId: Value(entity.clientId),
        profileId: Value(entity.profileId),
        name: Value(entity.name),
        description: Value(entity.description),
        location: Value(entity.location),
        triggers: Value(entity.triggers),
        durationMinutes: Value(entity.durationMinutes),
        isArchived: Value(entity.isArchived),
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
