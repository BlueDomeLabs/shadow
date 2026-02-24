// lib/data/repositories/diet_violation_repository_impl.dart
// Phase 15b — DietViolation repository implementation
// Per 59_DIET_TRACKING.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/repositories/base_repository.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/diet_violation_dao.dart';
import 'package:shadow_app/domain/entities/diet_violation.dart';
import 'package:shadow_app/domain/repositories/diet_violation_repository.dart';
import 'package:uuid/uuid.dart';

/// Repository implementation for DietViolation entities.
class DietViolationRepositoryImpl extends BaseRepository<DietViolation>
    implements DietViolationRepository {
  final DietViolationDao _dao;

  DietViolationRepositoryImpl(
    this._dao,
    Uuid uuid,
    DeviceInfoService deviceInfoService,
  ) : super(uuid, deviceInfoService);

  @override
  Future<Result<List<DietViolation>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) async {
    if (profileId != null) {
      return _dao.getByProfile(profileId, limit: limit);
    }
    return const Success([]);
  }

  @override
  Future<Result<DietViolation, AppError>> getById(String id) =>
      _dao.getById(id);

  @override
  Future<Result<List<DietViolation>, AppError>> getByProfile(
    String profileId, {
    int? startDate,
    int? endDate,
    int? limit,
  }) => _dao.getByProfile(
    profileId,
    startDate: startDate,
    endDate: endDate,
    limit: limit,
  );

  @override
  Future<Result<List<DietViolation>, AppError>> getByDiet(String dietId) =>
      _dao.getByDiet(dietId);

  @override
  Future<Result<DietViolation, AppError>> create(DietViolation entity) async {
    final prepared = await prepareForCreate(
      entity,
      (id, syncMetadata) => entity.copyWith(id: id, syncMetadata: syncMetadata),
      existingId: entity.id.isEmpty ? null : entity.id,
    );
    return _dao.create(prepared);
  }

  @override
  Future<Result<DietViolation, AppError>> update(
    DietViolation entity, {
    bool markDirty = true,
  }) =>
      // Violations are append-only — once created they are not updated.
      // This method exists to satisfy the EntityRepository contract.
      getById(entity.id);

  @override
  Future<Result<void, AppError>> delete(String id) => _dao.softDelete(id);

  @override
  Future<Result<void, AppError>> hardDelete(String id) => _dao.hardDelete(id);

  @override
  Future<Result<List<DietViolation>, AppError>> getModifiedSince(int since) =>
      _dao.getModifiedSince(since);

  @override
  Future<Result<List<DietViolation>, AppError>> getPendingSync() =>
      _dao.getPendingSync();
}
