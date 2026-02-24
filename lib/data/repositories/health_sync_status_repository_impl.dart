// lib/data/repositories/health_sync_status_repository_impl.dart
// Phase 16 — Repository implementation for health sync status
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/health_sync_status_dao.dart';
import 'package:shadow_app/domain/entities/health_sync_status.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/health_sync_status_repository.dart';

class HealthSyncStatusRepositoryImpl implements HealthSyncStatusRepository {
  HealthSyncStatusRepositoryImpl(this._dao);

  final HealthSyncStatusDao _dao;

  @override
  Future<Result<List<HealthSyncStatus>, AppError>> getByProfile(
    String profileId,
  ) => _dao.getByProfile(profileId);

  @override
  Future<Result<HealthSyncStatus?, AppError>> getByDataType(
    String profileId,
    HealthDataType dataType,
  ) => _dao.getByDataType(profileId, dataType);

  @override
  Future<Result<HealthSyncStatus, AppError>> upsert(
    HealthSyncStatus status,
  ) async {
    final result = await _dao.upsert(status);
    if (result.isFailure) return Failure(result.errorOrNull!);
    return Success(status);
  }
}
