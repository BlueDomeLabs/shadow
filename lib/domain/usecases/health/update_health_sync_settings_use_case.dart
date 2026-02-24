// lib/domain/usecases/health/update_health_sync_settings_use_case.dart
// Phase 16 — Save health platform sync preferences for a profile
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/health_sync_settings.dart';
import 'package:shadow_app/domain/repositories/health_sync_settings_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/health/health_types.dart';

/// Saves health platform sync preferences for a profile.
///
/// Performs an upsert — creates settings if none exist, or updates the
/// specific fields provided in the input (null fields are not changed).
class UpdateHealthSyncSettingsUseCase
    implements UseCase<UpdateHealthSyncSettingsInput, HealthSyncSettings> {
  final HealthSyncSettingsRepository _repository;
  final ProfileAuthorizationService _authService;

  UpdateHealthSyncSettingsUseCase(this._repository, this._authService);

  @override
  Future<Result<HealthSyncSettings, AppError>> call(
    UpdateHealthSyncSettingsInput input,
  ) async {
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // Load existing settings or create defaults
    final existingResult = await _repository.getByProfile(input.profileId);
    if (existingResult.isFailure) {
      return Failure(existingResult.errorOrNull!);
    }

    final existing =
        existingResult.valueOrNull ??
        HealthSyncSettings.defaultsForProfile(input.profileId);

    // Apply partial updates
    final updated = existing.copyWith(
      enabledDataTypes: input.enabledDataTypes ?? existing.enabledDataTypes,
      dateRangeDays: input.dateRangeDays ?? existing.dateRangeDays,
    );

    return _repository.save(updated);
  }
}
