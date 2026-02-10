// lib/data/repositories/condition_log_repository_impl.dart - EXACT IMPLEMENTATION FROM 02_CODING_STANDARDS.md Section 3.2

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/repositories/base_repository.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/condition_log_dao.dart';
import 'package:shadow_app/domain/entities/condition_log.dart';
import 'package:shadow_app/domain/repositories/condition_log_repository.dart';
import 'package:uuid/uuid.dart';

/// Repository implementation for ConditionLog entities.
///
/// Extends BaseRepository for sync support and implements ConditionLogRepository
/// interface per 02_CODING_STANDARDS.md Section 3.2.
class ConditionLogRepositoryImpl extends BaseRepository<ConditionLog>
    implements ConditionLogRepository {
  final ConditionLogDao _dao;

  ConditionLogRepositoryImpl(
    this._dao,
    Uuid uuid,
    DeviceInfoService deviceInfoService,
  ) : super(uuid, deviceInfoService);

  @override
  Future<Result<List<ConditionLog>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) => _dao.getAll(profileId: profileId, limit: limit, offset: offset);

  @override
  Future<Result<ConditionLog, AppError>> getById(String id) => _dao.getById(id);

  @override
  Future<Result<ConditionLog, AppError>> create(ConditionLog entity) async {
    // Prepare entity with ID and sync metadata if needed
    final preparedEntity = await prepareForCreate(
      entity,
      (id, syncMetadata) => entity.copyWith(id: id, syncMetadata: syncMetadata),
      existingId: entity.id.isEmpty ? null : entity.id,
    );

    return _dao.create(preparedEntity);
  }

  @override
  Future<Result<ConditionLog, AppError>> update(
    ConditionLog entity, {
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
  Future<Result<List<ConditionLog>, AppError>> getModifiedSince(int since) =>
      _dao.getModifiedSince(since);

  @override
  Future<Result<List<ConditionLog>, AppError>> getPendingSync() =>
      _dao.getPendingSync();

  @override
  Future<Result<List<ConditionLog>, AppError>> getByProfile(
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
  Future<Result<List<ConditionLog>, AppError>> getByCondition(
    String conditionId, {
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  }) => _dao.getByCondition(
    conditionId,
    startDate: startDate,
    endDate: endDate,
    limit: limit,
    offset: offset,
  );

  @override
  Future<Result<List<ConditionLog>, AppError>> getByDateRange(
    String profileId,
    int start,
    int end,
  ) => _dao.getByDateRange(profileId, start, end);

  @override
  Future<Result<List<ConditionLog>, AppError>> getFlares(
    String conditionId, {
    int? limit,
  }) => _dao.getFlares(conditionId, limit: limit);
}
