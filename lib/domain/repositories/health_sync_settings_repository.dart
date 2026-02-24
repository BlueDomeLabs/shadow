// lib/domain/repositories/health_sync_settings_repository.dart
// Phase 16 — Repository interface for health sync settings
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/health_sync_settings.dart';

/// Repository for managing per-profile health sync preferences.
///
/// One settings record per profile. Settings are local-only (not synced to
/// Google Drive) since they control device-level health platform access.
abstract class HealthSyncSettingsRepository {
  /// Returns the sync settings for a profile, or null if never configured.
  Future<Result<HealthSyncSettings?, AppError>> getByProfile(String profileId);

  /// Creates or updates the sync settings for a profile.
  Future<Result<HealthSyncSettings, AppError>> save(
    HealthSyncSettings settings,
  );
}
