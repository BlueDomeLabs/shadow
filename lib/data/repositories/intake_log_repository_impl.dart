// lib/data/repositories/intake_log_repository_impl.dart - EXACT IMPLEMENTATION FROM 02_CODING_STANDARDS.md Section 3.2

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/repositories/base_repository.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/intake_log_dao.dart';
import 'package:shadow_app/domain/entities/intake_log.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/intake_log_repository.dart';
import 'package:uuid/uuid.dart';

/// Repository implementation for IntakeLog entities.
///
/// Extends BaseRepository for sync support and implements IntakeLogRepository
/// interface per 02_CODING_STANDARDS.md Section 3.2.
class IntakeLogRepositoryImpl extends BaseRepository<IntakeLog>
    implements IntakeLogRepository {
  final IntakeLogDao _dao;

  IntakeLogRepositoryImpl(
    this._dao,
    Uuid uuid,
    DeviceInfoService deviceInfoService,
  ) : super(uuid, deviceInfoService);

  @override
  Future<Result<List<IntakeLog>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) => _dao.getAll(profileId: profileId, limit: limit, offset: offset);

  @override
  Future<Result<IntakeLog, AppError>> getById(String id) => _dao.getById(id);

  @override
  Future<Result<IntakeLog, AppError>> create(IntakeLog entity) async {
    // Prepare entity with ID and sync metadata if needed
    final preparedEntity = await prepareForCreate(
      entity,
      (id, syncMetadata) => entity.copyWith(id: id, syncMetadata: syncMetadata),
      existingId: entity.id.isEmpty ? null : entity.id,
    );

    return _dao.create(preparedEntity);
  }

  @override
  Future<Result<IntakeLog, AppError>> update(
    IntakeLog entity, {
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
  Future<Result<List<IntakeLog>, AppError>> getModifiedSince(int since) =>
      _dao.getModifiedSince(since);

  @override
  Future<Result<List<IntakeLog>, AppError>> getPendingSync() =>
      _dao.getPendingSync();

  @override
  Future<Result<List<IntakeLog>, AppError>> getByProfile(
    String profileId, {
    IntakeLogStatus? status,
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  }) => _dao.getByProfile(
    profileId,
    status: status,
    startDate: startDate,
    endDate: endDate,
    limit: limit,
    offset: offset,
  );

  @override
  Future<Result<List<IntakeLog>, AppError>> getBySupplement(
    String supplementId, {
    int? startDate,
    int? endDate,
  }) => _dao.getBySupplement(
    supplementId,
    startDate: startDate,
    endDate: endDate,
  );

  @override
  Future<Result<List<IntakeLog>, AppError>> getPendingForDate(
    String profileId,
    int date,
  ) => _dao.getPendingForDate(profileId, date);

  @override
  Future<Result<void, AppError>> markTaken(String id, int actualTime) =>
      _dao.markTaken(id, actualTime);

  @override
  Future<Result<void, AppError>> markSkipped(String id, String? reason) =>
      _dao.markSkipped(id, reason);
}
