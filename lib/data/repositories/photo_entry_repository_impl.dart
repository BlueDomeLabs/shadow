// lib/data/repositories/photo_entry_repository_impl.dart
// EXACT IMPLEMENTATION FROM 02_CODING_STANDARDS.md Section 3.2

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/repositories/base_repository.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/photo_entry_dao.dart';
import 'package:shadow_app/domain/entities/photo_entry.dart';
import 'package:shadow_app/domain/repositories/photo_entry_repository.dart';
import 'package:uuid/uuid.dart';

/// Repository implementation for PhotoEntry entities.
class PhotoEntryRepositoryImpl extends BaseRepository<PhotoEntry>
    implements PhotoEntryRepository {
  final PhotoEntryDao _dao;

  PhotoEntryRepositoryImpl(
    this._dao,
    Uuid uuid,
    DeviceInfoService deviceInfoService,
  ) : super(uuid, deviceInfoService);

  @override
  Future<Result<List<PhotoEntry>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) => _dao.getAll(profileId: profileId, limit: limit, offset: offset);

  @override
  Future<Result<PhotoEntry, AppError>> getById(String id) => _dao.getById(id);

  @override
  Future<Result<PhotoEntry, AppError>> create(PhotoEntry entity) async {
    final preparedEntity = await prepareForCreate(
      entity,
      (id, syncMetadata) => entity.copyWith(id: id, syncMetadata: syncMetadata),
      existingId: entity.id.isEmpty ? null : entity.id,
    );
    return _dao.create(preparedEntity);
  }

  @override
  Future<Result<PhotoEntry, AppError>> update(
    PhotoEntry entity, {
    bool markDirty = true,
  }) async {
    final preparedEntity = await prepareForUpdate(
      entity,
      (syncMetadata) => entity.copyWith(syncMetadata: syncMetadata),
      markDirty: markDirty,
      getSyncMetadata: (e) => e.syncMetadata,
    );
    return _dao.updateEntity(preparedEntity, markDirty: markDirty);
  }

  @override
  Future<Result<void, AppError>> delete(String id) => _dao.softDelete(id);

  @override
  Future<Result<void, AppError>> hardDelete(String id) => _dao.hardDelete(id);

  @override
  Future<Result<List<PhotoEntry>, AppError>> getModifiedSince(int since) =>
      _dao.getModifiedSince(since);

  @override
  Future<Result<List<PhotoEntry>, AppError>> getPendingSync() =>
      _dao.getPendingSync();

  @override
  Future<Result<List<PhotoEntry>, AppError>> getByArea(
    String photoAreaId, {
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  }) => _dao.getByArea(
    photoAreaId,
    startDate: startDate,
    endDate: endDate,
    limit: limit,
    offset: offset,
  );

  @override
  Future<Result<List<PhotoEntry>, AppError>> getByProfile(
    String profileId, {
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  }) => _dao.getByProfile(
    profileId,
    startDate: startDate,
    endDate: endDate,
    limit: limit,
    offset: offset,
  );

  @override
  Future<Result<List<PhotoEntry>, AppError>> getPendingUpload() =>
      _dao.getPendingUpload();
}
