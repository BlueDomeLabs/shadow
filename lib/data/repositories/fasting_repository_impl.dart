// lib/data/repositories/fasting_repository_impl.dart
// Phase 15b — Fasting repository implementation
// Per 59_DIET_TRACKING.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/repositories/base_repository.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/fasting_session_dao.dart';
import 'package:shadow_app/domain/entities/fasting_session.dart';
import 'package:shadow_app/domain/repositories/fasting_repository.dart';
import 'package:uuid/uuid.dart';

/// Repository implementation for FastingSession entities.
class FastingRepositoryImpl extends BaseRepository<FastingSession>
    implements FastingRepository {
  final FastingSessionDao _dao;

  FastingRepositoryImpl(
    this._dao,
    Uuid uuid,
    DeviceInfoService deviceInfoService,
  ) : super(uuid, deviceInfoService);

  @override
  Future<Result<List<FastingSession>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) async {
    if (profileId != null) {
      return _dao.getByProfile(profileId, limit: limit);
    }
    // Without profileId: not supported for fasting sessions
    return const Success([]);
  }

  @override
  Future<Result<FastingSession, AppError>> getById(String id) =>
      _dao.getById(id);

  @override
  Future<Result<List<FastingSession>, AppError>> getByProfile(
    String profileId, {
    int? limit,
  }) => _dao.getByProfile(profileId, limit: limit);

  @override
  Future<Result<FastingSession?, AppError>> getActiveFast(String profileId) =>
      _dao.getActiveFast(profileId);

  @override
  Future<Result<FastingSession, AppError>> create(FastingSession entity) async {
    final prepared = await prepareForCreate(
      entity,
      (id, syncMetadata) => entity.copyWith(id: id, syncMetadata: syncMetadata),
      existingId: entity.id.isEmpty ? null : entity.id,
    );
    return _dao.create(prepared);
  }

  @override
  Future<Result<FastingSession, AppError>> update(
    FastingSession entity, {
    bool markDirty = true,
  }) async {
    final prepared = await prepareForUpdate(
      entity,
      (syncMetadata) => entity.copyWith(syncMetadata: syncMetadata),
      markDirty: markDirty,
      getSyncMetadata: (e) => e.syncMetadata,
    );
    return _dao.updateEntity(prepared, markDirty: markDirty);
  }

  @override
  Future<Result<FastingSession, AppError>> endFast(
    String sessionId,
    int endedAt, {
    bool isManualEnd = false,
  }) async {
    final result = await _dao.getById(sessionId);
    if (result.isFailure) return result;
    final session = result.valueOrNull!;
    return update(session.copyWith(endedAt: endedAt, isManualEnd: isManualEnd));
  }

  @override
  Future<Result<void, AppError>> delete(String id) => _dao.softDelete(id);

  @override
  Future<Result<void, AppError>> hardDelete(String id) => _dao.hardDelete(id);

  @override
  Future<Result<List<FastingSession>, AppError>> getModifiedSince(int since) =>
      _dao.getModifiedSince(since);

  @override
  Future<Result<List<FastingSession>, AppError>> getPendingSync() =>
      _dao.getPendingSync();
}
