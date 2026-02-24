// lib/data/repositories/diet_repository_impl.dart
// Phase 15b — Diet repository implementation
// Per 59_DIET_TRACKING.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/repositories/base_repository.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/diet_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/diet_exception_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/diet_rule_dao.dart';
import 'package:shadow_app/domain/entities/diet.dart';
import 'package:shadow_app/domain/entities/diet_exception.dart';
import 'package:shadow_app/domain/entities/diet_rule.dart';
import 'package:shadow_app/domain/repositories/diet_repository.dart';
import 'package:uuid/uuid.dart';

/// Repository implementation for Diet entities.
class DietRepositoryImpl extends BaseRepository<Diet>
    implements DietRepository {
  final DietDao _dao;
  final DietRuleDao _ruleDao;
  final DietExceptionDao _exceptionDao;

  DietRepositoryImpl(
    this._dao,
    this._ruleDao,
    this._exceptionDao,
    Uuid uuid,
    DeviceInfoService deviceInfoService,
  ) : super(uuid, deviceInfoService);

  @override
  Future<Result<List<Diet>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) async {
    if (profileId != null) {
      return _dao.getByProfile(profileId);
    }
    return const Success([]);
  }

  @override
  Future<Result<Diet, AppError>> getById(String id) => _dao.getById(id);

  @override
  Future<Result<List<Diet>, AppError>> getByProfile(String profileId) =>
      _dao.getByProfile(profileId);

  @override
  Future<Result<Diet?, AppError>> getActiveDiet(String profileId) =>
      _dao.getActiveDiet(profileId);

  @override
  Future<Result<Diet, AppError>> create(Diet entity) async {
    final prepared = await prepareForCreate(
      entity,
      (id, syncMetadata) => entity.copyWith(id: id, syncMetadata: syncMetadata),
      existingId: entity.id.isEmpty ? null : entity.id,
    );
    return _dao.create(prepared);
  }

  @override
  Future<Result<Diet, AppError>> update(
    Diet entity, {
    bool markDirty = true,
  }) async {
    final prepared = await prepareForUpdate(
      entity,
      (syncMetadata) => entity.copyWith(syncMetadata: syncMetadata),
      markDirty: markDirty,
      getSyncMetadata: (e) => e.syncMetadata,
    );
    return _dao.updateEntity(prepared);
  }

  @override
  Future<Result<Diet, AppError>> setActive(
    String dietId,
    String profileId,
  ) async {
    // Deactivate all first
    await _dao.deactivateAll(profileId);
    // Get the diet and set it active
    final result = await _dao.getById(dietId);
    if (result.isFailure) return result;
    final diet = result.valueOrNull!;
    return update(diet.copyWith(isActive: true, isDraft: false));
  }

  @override
  Future<Result<void, AppError>> deactivate(String profileId) async {
    await _dao.deactivateAll(profileId);
    return const Success(null);
  }

  @override
  Future<Result<void, AppError>> delete(String id) => _dao.softDelete(id);

  @override
  Future<Result<void, AppError>> hardDelete(String id) => _dao.hardDelete(id);

  @override
  Future<Result<List<Diet>, AppError>> getModifiedSince(int since) =>
      _dao.getModifiedSince(since);

  @override
  Future<Result<List<Diet>, AppError>> getPendingSync() =>
      _dao.getPendingSync();

  // ---- Rules ----

  @override
  Future<Result<List<DietRule>, AppError>> getRules(String dietId) =>
      _ruleDao.getForDiet(dietId);

  @override
  Future<Result<DietRule, AppError>> addRule(DietRule rule) async {
    final id = generateId(rule.id.isEmpty ? null : rule.id);
    return _ruleDao.insert(rule.copyWith(id: id));
  }

  @override
  Future<Result<DietRule, AppError>> updateRule(DietRule rule) =>
      _ruleDao.updateEntity(rule);

  @override
  Future<Result<void, AppError>> deleteRule(String ruleId) async {
    // Delete exceptions first
    await _exceptionDao.deleteForRule(ruleId);
    return _ruleDao.deleteById(ruleId);
  }

  // ---- Exceptions ----

  @override
  Future<Result<List<DietException>, AppError>> getExceptions(String ruleId) =>
      _exceptionDao.getForRule(ruleId);

  @override
  Future<Result<DietException, AppError>> addException(
    DietException exception,
  ) async {
    final id = generateId(exception.id.isEmpty ? null : exception.id);
    return _exceptionDao.insert(exception.copyWith(id: id));
  }

  @override
  Future<Result<void, AppError>> deleteException(String exceptionId) =>
      _exceptionDao.deleteById(exceptionId);
}
