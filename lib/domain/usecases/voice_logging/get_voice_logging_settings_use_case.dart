// lib/domain/usecases/voice_logging/get_voice_logging_settings_use_case.dart
// Per VOICE_LOGGING_SPEC.md Section 4

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/voice_logging/voice_logging_settings.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/voice_logging_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';

/// Returns voice logging settings for a profile.
///
/// If no row exists, returns default settings (closingStyle=random,
/// categoryPriorityOrder=null) without writing to the database.
class GetVoiceLoggingSettingsUseCase {
  final VoiceLoggingRepository _repository;
  final ProfileAuthorizationService _authService;

  GetVoiceLoggingSettingsUseCase(this._repository, this._authService);

  Future<Result<VoiceLoggingSettings, AppError>> execute(
    String profileId,
  ) async {
    if (!await _authService.canRead(profileId)) {
      return Failure(AuthError.profileAccessDenied(profileId));
    }

    final result = await _repository.getSettings(profileId);
    return result.when(
      success: (settings) {
        if (settings != null) return Success(settings);
        // Return in-memory default — no DB write.
        final now = DateTime.now().millisecondsSinceEpoch;
        return Success(
          VoiceLoggingSettings(
            id: profileId,
            profileId: profileId,
            closingStyle: ClosingStyle.random,
            createdAt: now,
          ),
        );
      },
      failure: Failure.new,
    );
  }
}
