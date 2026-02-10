// lib/data/datasources/local/daos/photo_entry_dao.dart
// Data Access Object for photo_entries table per 22_API_CONTRACTS.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/photo_entries_table.dart';
import 'package:shadow_app/domain/entities/photo_entry.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';

part 'photo_entry_dao.g.dart';

/// Data Access Object for the photo_entries table.
@DriftAccessor(tables: [PhotoEntries])
class PhotoEntryDao extends DatabaseAccessor<AppDatabase>
    with _$PhotoEntryDaoMixin {
  PhotoEntryDao(super.db);

  /// Get all photo entries.
  Future<Result<List<domain.PhotoEntry>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(photoEntries)
        ..where((p) => p.syncDeletedAt.isNull())
        ..orderBy([(p) => OrderingTerm.desc(p.timestamp)]);

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
        DatabaseError.queryFailed('photo_entries', e.toString(), stack),
      );
    }
  }

  /// Get a single photo entry by ID.
  Future<Result<domain.PhotoEntry, AppError>> getById(String id) async {
    try {
      final query = select(photoEntries)
        ..where((p) => p.id.equals(id) & p.syncDeletedAt.isNull());

      final row = await query.getSingleOrNull();
      if (row == null) {
        return Failure(DatabaseError.notFound('PhotoEntry', id));
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('photo_entries', e.toString(), stack),
      );
    }
  }

  /// Create a new photo entry.
  Future<Result<domain.PhotoEntry, AppError>> create(
    domain.PhotoEntry entity,
  ) async {
    try {
      final companion = _entityToCompanion(entity);
      await into(photoEntries).insert(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('photo_entries', e, stack));
    }
  }

  /// Update an existing photo entry.
  Future<Result<domain.PhotoEntry, AppError>> updateEntity(
    domain.PhotoEntry entity, {
    bool markDirty = true,
  }) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) return existsResult;

      final companion = _entityToCompanion(entity);
      await (update(
        photoEntries,
      )..where((p) => p.id.equals(entity.id))).write(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('photo_entries', entity.id, e, stack),
      );
    }
  }

  /// Soft delete a photo entry.
  Future<Result<void, AppError>> softDelete(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            photoEntries,
          )..where((p) => p.id.equals(id) & p.syncDeletedAt.isNull())).write(
            PhotoEntriesCompanion(
              syncDeletedAt: Value(now),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.deleted.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('PhotoEntry', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('photo_entries', id, e, stack));
    }
  }

  /// Hard delete a photo entry.
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        photoEntries,
      )..where((p) => p.id.equals(id))).go();
      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('PhotoEntry', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('photo_entries', id, e, stack));
    }
  }

  /// Get photo entries by area with date filtering.
  Future<Result<List<domain.PhotoEntry>, AppError>> getByArea(
    String photoAreaId, {
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(photoEntries)
        ..where(
          (p) => p.photoAreaId.equals(photoAreaId) & p.syncDeletedAt.isNull(),
        )
        ..orderBy([(p) => OrderingTerm.desc(p.timestamp)]);

      if (startDate != null) {
        query = query
          ..where((p) => p.timestamp.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query = query..where((p) => p.timestamp.isSmallerOrEqualValue(endDate));
      }
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('photo_entries', e.toString(), stack),
      );
    }
  }

  /// Get photo entries by profile with date filtering.
  Future<Result<List<domain.PhotoEntry>, AppError>> getByProfile(
    String profileId, {
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(photoEntries)
        ..where((p) => p.profileId.equals(profileId) & p.syncDeletedAt.isNull())
        ..orderBy([(p) => OrderingTerm.desc(p.timestamp)]);

      if (startDate != null) {
        query = query
          ..where((p) => p.timestamp.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query = query..where((p) => p.timestamp.isSmallerOrEqualValue(endDate));
      }
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('photo_entries', e.toString(), stack),
      );
    }
  }

  /// Get entries pending upload to cloud.
  Future<Result<List<domain.PhotoEntry>, AppError>> getPendingUpload() async {
    try {
      final query = select(photoEntries)
        ..where(
          (p) => p.isFileUploaded.equals(false) & p.syncDeletedAt.isNull(),
        )
        ..orderBy([(p) => OrderingTerm.asc(p.timestamp)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('photo_entries', e.toString(), stack),
      );
    }
  }

  /// Get modified since timestamp.
  Future<Result<List<domain.PhotoEntry>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final query = select(photoEntries)
        ..where((p) => p.syncUpdatedAt.isBiggerThanValue(since))
        ..orderBy([(p) => OrderingTerm.asc(p.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('photo_entries', e.toString(), stack),
      );
    }
  }

  /// Get entries pending sync.
  Future<Result<List<domain.PhotoEntry>, AppError>> getPendingSync() async {
    try {
      final query = select(photoEntries)
        ..where((p) => p.syncIsDirty.equals(true))
        ..orderBy([(p) => OrderingTerm.asc(p.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('photo_entries', e.toString(), stack),
      );
    }
  }

  /// Convert database row to domain entity.
  domain.PhotoEntry _rowToEntity(PhotoEntryRow row) => domain.PhotoEntry(
    id: row.id,
    clientId: row.clientId,
    profileId: row.profileId,
    photoAreaId: row.photoAreaId,
    timestamp: row.timestamp,
    filePath: row.filePath,
    notes: row.notes,
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

  /// Convert domain entity to database companion.
  PhotoEntriesCompanion _entityToCompanion(domain.PhotoEntry entity) =>
      PhotoEntriesCompanion(
        id: Value(entity.id),
        clientId: Value(entity.clientId),
        profileId: Value(entity.profileId),
        photoAreaId: Value(entity.photoAreaId),
        timestamp: Value(entity.timestamp),
        filePath: Value(entity.filePath),
        notes: Value(entity.notes),
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
}
