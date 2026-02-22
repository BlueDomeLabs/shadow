// lib/data/repositories/profile_repository_impl.dart - EXACT IMPLEMENTATION FROM 02_CODING_STANDARDS.md Section 3.2

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/repositories/base_repository.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/profile_dao.dart';
import 'package:shadow_app/domain/entities/profile.dart';
import 'package:shadow_app/domain/repositories/profile_repository.dart';
import 'package:uuid/uuid.dart';

/// Repository implementation for Profile entities.
///
/// Extends BaseRepository for sync support and implements ProfileRepository
/// interface per 02_CODING_STANDARDS.md Section 3.2.
class ProfileRepositoryImpl extends BaseRepository<Profile>
    implements ProfileRepository {
  final ProfileDao _dao;

  ProfileRepositoryImpl(
    this._dao,
    Uuid uuid,
    DeviceInfoService deviceInfoService,
  ) : super(uuid, deviceInfoService);

  @override
  Future<Result<List<Profile>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) => _dao.getAll(limit: limit, offset: offset);

  @override
  Future<Result<Profile, AppError>> getById(String id) => _dao.getById(id);

  @override
  Future<Result<Profile, AppError>> create(Profile entity) async {
    final preparedEntity = await prepareForCreate(
      entity,
      (id, syncMetadata) => entity.copyWith(id: id, syncMetadata: syncMetadata),
      existingId: entity.id.isEmpty ? null : entity.id,
    );

    return _dao.create(preparedEntity);
  }

  @override
  Future<Result<Profile, AppError>> update(
    Profile entity, {
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
  Future<Result<List<Profile>, AppError>> getModifiedSince(int since) =>
      _dao.getModifiedSince(since);

  @override
  Future<Result<List<Profile>, AppError>> getPendingSync() =>
      _dao.getPendingSync();

  @override
  Future<Result<List<Profile>, AppError>> getByOwner(String ownerId) =>
      _dao.getByOwner(ownerId);

  @override
  Future<Result<Profile?, AppError>> getDefault(String ownerId) =>
      _dao.getDefault(ownerId);

  @override
  Future<Result<List<Profile>, AppError>> getByUser(String userId) =>
      _dao.getByOwner(userId);
}
