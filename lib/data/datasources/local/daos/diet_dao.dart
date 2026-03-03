// lib/data/datasources/local/daos/diet_dao.dart
// Phase 15b — DAO for diets table
// Per 59_DIET_TRACKING.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/diets_table.dart';
import 'package:shadow_app/domain/entities/diet.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'diet_dao.g.dart';

/// Data Access Object for the diets table.
@DriftAccessor(tables: [Diets])
class DietDao extends DatabaseAccessor<AppDatabase> with _$DietDaoMixin {
  DietDao(super.db);

  /// Get all diets for a profile.
  Future<Result<List<domain.Diet>, AppError>> getByProfile(
    String profileId,
  ) async {
    try {
      final rows =
          await (select(diets)
                ..where(
                  (d) =>
                      d.profileId.equals(profileId) & d.syncDeletedAt.isNull(),
                )
                ..orderBy([(d) => OrderingTerm.desc(d.syncCreatedAt)]))
              .get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.queryFailed('diets', e.toString(), stack));
    }
  }

  /// Get the active diet for a profile (the one with isActive=true).
  Future<Result<domain.Diet?, AppError>> getActiveDiet(String profileId) async {
    try {
      final row =
          await (select(diets)..where(
                (d) =>
                    d.profileId.equals(profileId) &
                    d.isActive.equals(true) &
                    d.syncDeletedAt.isNull(),
              ))
              .getSingleOrNull();
      return Success(row == null ? null : _rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.queryFailed('diets', e.toString(), stack));
    }
  }

  /// Get a single diet by ID.
  Future<Result<domain.Diet, AppError>> getById(String id) async {
    try {
      final row =
          await (select(diets)
                ..where((d) => d.id.equals(id) & d.syncDeletedAt.isNull()))
              .getSingleOrNull();
      if (row == null) {
        return Failure(DatabaseError.notFound('Diet', id));
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.queryFailed('diets', e.toString(), stack));
    }
  }

  /// Create a new diet.
  Future<Result<domain.Diet, AppError>> create(domain.Diet entity) async {
    try {
      await into(diets).insert(_entityToCompanion(entity));
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('diets', e, stack));
    }
  }

  /// Update an existing diet.
  Future<Result<domain.Diet, AppError>> updateEntity(domain.Diet entity) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) return existsResult;

      await (update(diets)..where((d) => d.id.equals(entity.id))).write(
        _entityToCompanion(entity),
      );
      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.updateFailed('diets', entity.id, e, stack));
    }
  }

  /// Deactivate all diets for a profile (used before activating a new one).
  ///
  /// Also marks deactivated diets dirty so the sync system picks up the
  /// isActive=false change (AUDIT-CB-001).
  Future<void> deactivateAll(String profileId) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await customUpdate(
      'UPDATE diets SET is_active = 0, sync_is_dirty = 1, '
      'sync_updated_at = ?, sync_status = 2, sync_version = sync_version + 1 '
      'WHERE profile_id = ? AND is_active = 1 AND sync_deleted_at IS NULL',
      variables: [Variable.withInt(now), Variable.withString(profileId)],
      updates: {diets},
    );
  }

  /// Soft delete a diet.
  ///
  /// [deviceId] is the current device identifier; used to set sync_device_id
  /// and increment sync_version so conflict detection works (AUDIT-03-002).
  Future<Result<void, AppError>> softDelete(
    String id, {
    String deviceId = '',
  }) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final row =
          await (select(diets)
                ..where((d) => d.id.equals(id) & d.syncDeletedAt.isNull()))
              .getSingleOrNull();
      if (row == null) return Failure(DatabaseError.notFound('Diet', id));
      await (update(diets)..where((d) => d.id.equals(id))).write(
        DietsCompanion(
          syncDeletedAt: Value(now),
          syncUpdatedAt: Value(now),
          syncIsDirty: const Value(true),
          syncStatus: Value(SyncStatus.deleted.value),
          syncVersion: Value(row.syncVersion + 1),
          syncDeviceId: Value(
            deviceId.isNotEmpty ? deviceId : (row.syncDeviceId ?? ''),
          ),
        ),
      );
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('diets', id, e, stack));
    }
  }

  /// Mark a diet as synced after successful cloud upload.
  ///
  /// Bypasses the soft-delete filter so deleted entities can be marked synced
  /// (AUDIT-03-001). Does not increment syncVersion — sync is not a local change.
  Future<Result<void, AppError>> markSynced(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      await (update(diets)..where((d) => d.id.equals(id))).write(
        DietsCompanion(
          syncIsDirty: const Value(false),
          syncStatus: Value(SyncStatus.synced.value),
          syncLastSyncedAt: Value(now),
        ),
      );
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.updateFailed('diets', id, e, stack));
    }
  }

  /// Hard delete a diet.
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        diets,
      )..where((d) => d.id.equals(id))).go();
      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('Diet', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('diets', id, e, stack));
    }
  }

  /// Get modified since timestamp (for sync).
  Future<Result<List<domain.Diet>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final rows =
          await (select(diets)
                ..where((d) => d.syncUpdatedAt.isBiggerThanValue(since))
                ..orderBy([(d) => OrderingTerm.asc(d.syncUpdatedAt)]))
              .get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.queryFailed('diets', e.toString(), stack));
    }
  }

  /// Get entries pending sync.
  Future<Result<List<domain.Diet>, AppError>> getPendingSync() async {
    try {
      final rows =
          await (select(diets)
                ..where((d) => d.syncIsDirty.equals(true))
                ..orderBy([(d) => OrderingTerm.asc(d.syncUpdatedAt)]))
              .get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.queryFailed('diets', e.toString(), stack));
    }
  }

  domain.Diet _rowToEntity(DietRow row) => domain.Diet(
    id: row.id,
    clientId: row.clientId,
    profileId: row.profileId,
    name: row.name,
    description: row.description,
    presetType: row.presetType != null
        ? DietPresetType.fromValue(row.presetType!)
        : null,
    isActive: row.isActive,
    startDate: row.startDate,
    endDate: row.endDate,
    isDraft: row.isDraft,
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

  DietsCompanion _entityToCompanion(domain.Diet entity) => DietsCompanion(
    id: Value(entity.id),
    clientId: Value(entity.clientId),
    profileId: Value(entity.profileId),
    name: Value(entity.name),
    description: Value(entity.description),
    presetType: Value(entity.presetType?.value),
    isActive: Value(entity.isActive),
    startDate: Value(entity.startDate),
    endDate: Value(entity.endDate),
    isDraft: Value(entity.isDraft),
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
