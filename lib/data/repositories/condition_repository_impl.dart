// lib/data/repositories/condition_repository_impl.dart - EXACT IMPLEMENTATION FROM 02_CODING_STANDARDS.md Section 3.2

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/repositories/base_repository.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/condition_dao.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/condition_repository.dart';
import 'package:uuid/uuid.dart';

/// Repository implementation for Condition entities.
///
/// Extends BaseRepository for sync support and implements ConditionRepository
/// interface per 02_CODING_STANDARDS.md Section 3.2.
class ConditionRepositoryImpl extends BaseRepository<Condition>
    implements ConditionRepository {
  final ConditionDao _dao;

  ConditionRepositoryImpl(
    this._dao,
    Uuid uuid,
    DeviceInfoService deviceInfoService,
  ) : super(uuid, deviceInfoService);

  @override
  Future<Result<List<Condition>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) => _dao.getAll(profileId: profileId, limit: limit, offset: offset);

  @override
  Future<Result<Condition, AppError>> getById(String id) => _dao.getById(id);

  @override
  Future<Result<Condition, AppError>> create(Condition entity) async {
    // Prepare entity with ID and sync metadata if needed
    final preparedEntity = await prepareForCreate(
      entity,
      (id, syncMetadata) => entity.copyWith(id: id, syncMetadata: syncMetadata),
      existingId: entity.id.isEmpty ? null : entity.id,
    );

    return _dao.create(preparedEntity);
  }

  @override
  Future<Result<Condition, AppError>> update(
    Condition entity, {
    bool markDirty = true,
  }) async {
    // Prepare entity with updated sync metadata
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
  Future<Result<List<Condition>, AppError>> getModifiedSince(int since) =>
      _dao.getModifiedSince(since);

  @override
  Future<Result<List<Condition>, AppError>> getPendingSync() =>
      _dao.getPendingSync();

  @override
  Future<Result<List<Condition>, AppError>> getByProfile(
    String profileId, {
    ConditionStatus? status,
    bool includeArchived = false,
  }) => _dao.getByProfile(
    profileId,
    status: status,
    includeArchived: includeArchived,
  );

  @override
  Future<Result<List<Condition>, AppError>> getActive(String profileId) =>
      _dao.getActive(profileId);

  @override
  Future<Result<void, AppError>> archive(String id) => _dao.archive(id);

  @override
  Future<Result<void, AppError>> resolve(String id) => _dao.resolve(id);
}
