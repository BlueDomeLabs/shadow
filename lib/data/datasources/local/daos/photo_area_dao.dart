// lib/data/datasources/local/daos/photo_area_dao.dart
// Data Access Object for photo_areas table per 22_API_CONTRACTS.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/photo_areas_table.dart';
import 'package:shadow_app/domain/entities/photo_area.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';

part 'photo_area_dao.g.dart';

/// Data Access Object for the photo_areas table.
@DriftAccessor(tables: [PhotoAreas])
class PhotoAreaDao extends DatabaseAccessor<AppDatabase>
    with _$PhotoAreaDaoMixin {
  PhotoAreaDao(super.db);

  /// Get all photo areas.
  Future<Result<List<domain.PhotoArea>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(photoAreas)
        ..where((p) => p.syncDeletedAt.isNull())
        ..orderBy([(p) => OrderingTerm.asc(p.sortOrder)]);

      if (profileId != null) {
        query = query..where((p) => p.profileId.equals(profileId));
      }
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('photo_areas', e.toString(), stack),
      );
    }
  }

  /// Get a single photo area by ID.
  Future<Result<domain.PhotoArea, AppError>> getById(String id) async {
    try {
      final query = select(photoAreas)
        ..where((p) => p.id.equals(id) & p.syncDeletedAt.isNull());

      final row = await query.getSingleOrNull();
      if (row == null) {
        return Failure(DatabaseError.notFound('PhotoArea', id));
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('photo_areas', e.toString(), stack),
      );
    }
  }

  /// Create a new photo area.
  Future<Result<domain.PhotoArea, AppError>> create(
    domain.PhotoArea entity,
  ) async {
    try {
      final companion = _entityToCompanion(entity);
      await into(photoAreas).insert(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('photo_areas', e, stack));
    }
  }

  /// Update an existing photo area.
  Future<Result<domain.PhotoArea, AppError>> updateEntity(
    domain.PhotoArea entity, {
    bool markDirty = true,
  }) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) return existsResult;

      final companion = _entityToCompanion(entity);
      await (update(
        photoAreas,
      )..where((p) => p.id.equals(entity.id))).write(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('photo_areas', entity.id, e, stack),
      );
    }
  }

  /// Soft delete a photo area.
  Future<Result<void, AppError>> softDelete(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            photoAreas,
          )..where((p) => p.id.equals(id) & p.syncDeletedAt.isNull())).write(
            PhotoAreasCompanion(
              syncDeletedAt: Value(now),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.deleted.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('PhotoArea', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('photo_areas', id, e, stack));
    }
  }

  /// Hard delete a photo area.
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        photoAreas,
      )..where((p) => p.id.equals(id))).go();
      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('PhotoArea', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('photo_areas', id, e, stack));
    }
  }

  /// Get photo areas by profile with optional archived filter.
  Future<Result<List<domain.PhotoArea>, AppError>> getByProfile(
    String profileId, {
    bool includeArchived = false,
  }) async {
    try {
      var query = select(photoAreas)
        ..where((p) => p.profileId.equals(profileId) & p.syncDeletedAt.isNull())
        ..orderBy([(p) => OrderingTerm.asc(p.sortOrder)]);

      if (!includeArchived) {
        query = query..where((p) => p.isArchived.equals(false));
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('photo_areas', e.toString(), stack),
      );
    }
  }

  /// Reorder photo areas by updating sort_order.
  Future<Result<void, AppError>> reorder(
    String profileId,
    List<String> areaIds,
  ) async {
    try {
      await transaction(() async {
        for (var i = 0; i < areaIds.length; i++) {
          await (update(
            photoAreas,
          )..where((p) => p.id.equals(areaIds[i]))).write(
            PhotoAreasCompanion(
              sortOrder: Value(i),
              syncUpdatedAt: Value(DateTime.now().millisecondsSinceEpoch),
              syncIsDirty: const Value(true),
            ),
          );
        }
      });
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('photo_areas', 'reorder', e, stack),
      );
    }
  }

  /// Archive a photo area.
  Future<Result<void, AppError>> archive(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            photoAreas,
          )..where((p) => p.id.equals(id) & p.syncDeletedAt.isNull())).write(
            PhotoAreasCompanion(
              isArchived: const Value(true),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.modified.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('PhotoArea', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.updateFailed('photo_areas', id, e, stack));
    }
  }

  /// Get modified since timestamp.
  Future<Result<List<domain.PhotoArea>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final query = select(photoAreas)
        ..where((p) => p.syncUpdatedAt.isBiggerThanValue(since))
        ..orderBy([(p) => OrderingTerm.asc(p.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('photo_areas', e.toString(), stack),
      );
    }
  }

  /// Get entries pending sync.
  Future<Result<List<domain.PhotoArea>, AppError>> getPendingSync() async {
    try {
      final query = select(photoAreas)
        ..where((p) => p.syncIsDirty.equals(true))
        ..orderBy([(p) => OrderingTerm.asc(p.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('photo_areas', e.toString(), stack),
      );
    }
  }

  /// Convert database row to domain entity.
  domain.PhotoArea _rowToEntity(PhotoAreaRow row) => domain.PhotoArea(
    id: row.id,
    clientId: row.clientId,
    profileId: row.profileId,
    name: row.name,
    description: row.description,
    consistencyNotes: row.consistencyNotes,
    sortOrder: row.sortOrder,
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
  PhotoAreasCompanion _entityToCompanion(domain.PhotoArea entity) =>
      PhotoAreasCompanion(
        id: Value(entity.id),
        clientId: Value(entity.clientId),
        profileId: Value(entity.profileId),
        name: Value(entity.name),
        description: Value(entity.description),
        consistencyNotes: Value(entity.consistencyNotes),
        sortOrder: Value(entity.sortOrder),
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
