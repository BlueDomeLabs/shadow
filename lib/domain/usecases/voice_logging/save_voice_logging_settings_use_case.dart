// lib/domain/usecases/voice_logging/save_voice_logging_settings_use_case.dart
// Per VOICE_LOGGING_SPEC.md Section 4

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/voice_logging/voice_logging_settings.dart';
import 'package:shadow_app/domain/repositories/voice_logging_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';

/// Persists voice logging settings for a profile.
class SaveVoiceLoggingSettingsUseCase {
  final VoiceLoggingRepository _repository;
  final ProfileAuthorizationService _authService;

  SaveVoiceLoggingSettingsUseCase(this._repository, this._authService);

  Future<Result<void, AppError>> execute(VoiceLoggingSettings settings) async {
    if (!await _authService.canWrite(settings.profileId)) {
      return Failure(AuthError.profileAccessDenied(settings.profileId));
    }

    return _repository.saveSettings(settings);
  }
}
