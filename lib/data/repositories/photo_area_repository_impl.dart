// lib/data/repositories/photo_area_repository_impl.dart
// EXACT IMPLEMENTATION FROM 02_CODING_STANDARDS.md Section 3.2

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/repositories/base_repository.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/photo_area_dao.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/repositories/photo_area_repository.dart';
import 'package:uuid/uuid.dart';

/// Repository implementation for PhotoArea entities.
class PhotoAreaRepositoryImpl extends BaseRepository<PhotoArea>
    implements PhotoAreaRepository {
  final PhotoAreaDao _dao;

  PhotoAreaRepositoryImpl(
    this._dao,
    Uuid uuid,
    DeviceInfoService deviceInfoService,
  ) : super(uuid, deviceInfoService);

  @override
  Future<Result<List<PhotoArea>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) => _dao.getAll(profileId: profileId, limit: limit, offset: offset);

  @override
  Future<Result<PhotoArea, AppError>> getById(String id) => _dao.getById(id);

  @override
  Future<Result<PhotoArea, AppError>> create(PhotoArea entity) async {
    final preparedEntity = await prepareForCreate(
      entity,
      (id, syncMetadata) => entity.copyWith(id: id, syncMetadata: syncMetadata),
      existingId: entity.id.isEmpty ? null : entity.id,
    );
    return _dao.create(preparedEntity);
  }

  @override
  Future<Result<PhotoArea, AppError>> update(
    PhotoArea entity, {
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
  Future<Result<List<PhotoArea>, AppError>> getModifiedSince(int since) =>
      _dao.getModifiedSince(since);

  @override
  Future<Result<List<PhotoArea>, AppError>> getPendingSync() =>
      _dao.getPendingSync();

  @override
  Future<Result<List<PhotoArea>, AppError>> getByProfile(
    String profileId, {
    bool includeArchived = false,
  }) => _dao.getByProfile(profileId, includeArchived: includeArchived);

  @override
  Future<Result<void, AppError>> reorder(
    String profileId,
    List<String> areaIds,
  ) => _dao.reorder(profileId, areaIds);

  @override
  Future<Result<void, AppError>> archive(String id) => _dao.archive(id);
}
