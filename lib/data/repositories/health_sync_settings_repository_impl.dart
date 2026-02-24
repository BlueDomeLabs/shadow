// lib/data/repositories/health_sync_settings_repository_impl.dart
// Phase 16 — Repository implementation for health sync settings
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/health_sync_settings_dao.dart';
import 'package:shadow_app/domain/entities/health_sync_settings.dart';
import 'package:shadow_app/domain/repositories/health_sync_settings_repository.dart';

class HealthSyncSettingsRepositoryImpl implements HealthSyncSettingsRepository {
  HealthSyncSettingsRepositoryImpl(this._dao);

  final HealthSyncSettingsDao _dao;

  @override
  Future<Result<HealthSyncSettings?, AppError>> getByProfile(
    String profileId,
  ) => _dao.getByProfile(profileId);

  @override
  Future<Result<HealthSyncSettings, AppError>> save(
    HealthSyncSettings settings,
  ) => _dao.save(settings);
}
