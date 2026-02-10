// lib/data/repositories/flare_up_repository_impl.dart
// EXACT IMPLEMENTATION FROM 02_CODING_STANDARDS.md Section 3.2

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/repositories/base_repository.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/flare_up_dao.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/domain/repositories/flare_up_repository.dart';
import 'package:uuid/uuid.dart';

/// Repository implementation for FlareUp entities.
class FlareUpRepositoryImpl extends BaseRepository<FlareUp>
    implements FlareUpRepository {
  final FlareUpDao _dao;

  FlareUpRepositoryImpl(
    this._dao,
    Uuid uuid,
    DeviceInfoService deviceInfoService,
  ) : super(uuid, deviceInfoService);

  @override
  Future<Result<List<FlareUp>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) => _dao.getAll(profileId: profileId, limit: limit, offset: offset);

  @override
  Future<Result<FlareUp, AppError>> getById(String id) => _dao.getById(id);

  @override
  Future<Result<FlareUp, AppError>> create(FlareUp entity) async {
    final preparedEntity = await prepareForCreate(
      entity,
      (id, syncMetadata) => entity.copyWith(id: id, syncMetadata: syncMetadata),
      existingId: entity.id.isEmpty ? null : entity.id,
    );
    return _dao.create(preparedEntity);
  }

  @override
  Future<Result<FlareUp, AppError>> update(
    FlareUp entity, {
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
  Future<Result<List<FlareUp>, AppError>> getModifiedSince(int since) =>
      _dao.getModifiedSince(since);

  @override
  Future<Result<List<FlareUp>, AppError>> getPendingSync() =>
      _dao.getPendingSync();

  @override
  Future<Result<List<FlareUp>, AppError>> getByCondition(
    String conditionId, {
    int? startDate,
    int? endDate,
    bool? ongoingOnly,
    int? limit,
    int? offset,
  }) => _dao.getByCondition(
    conditionId,
    startDate: startDate,
    endDate: endDate,
    ongoingOnly: ongoingOnly,
    limit: limit,
    offset: offset,
  );

  @override
  Future<Result<List<FlareUp>, AppError>> getByProfile(
    String profileId, {
    int? startDate,
    int? endDate,
    bool? ongoingOnly,
    int? limit,
    int? offset,
  }) => _dao.getByProfile(
    profileId,
    startDate: startDate,
    endDate: endDate,
    ongoingOnly: ongoingOnly,
    limit: limit,
    offset: offset,
  );

  @override
  Future<Result<List<FlareUp>, AppError>> getOngoing(String profileId) =>
      _dao.getOngoing(profileId);

  @override
  Future<Result<Map<String, int>, AppError>> getTriggerCounts(
    String conditionId, {
    required int startDate,
    required int endDate,
  }) => _dao.getTriggerCounts(
    conditionId,
    startDate: startDate,
    endDate: endDate,
  );

  @override
  Future<Result<FlareUp, AppError>> endFlareUp(String id, int endDate) =>
      _dao.endFlareUp(id, endDate);
}
