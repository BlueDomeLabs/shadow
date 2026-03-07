// lib/domain/usecases/voice_logging/get_recent_session_turns_use_case.dart
// Per VOICE_LOGGING_SPEC.md Section 4

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/voice_logging/voice_session_turn.dart';
import 'package:shadow_app/domain/repositories/voice_logging_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';

/// Retrieves recent session turns for a profile within a rolling window.
class GetRecentSessionTurnsUseCase {
  final VoiceLoggingRepository _repository;
  final ProfileAuthorizationService _authService;

  GetRecentSessionTurnsUseCase(this._repository, this._authService);

  Future<Result<List<VoiceSessionTurn>, AppError>> execute(
    String profileId, {
    int daysBack = 14,
  }) async {
    if (!await _authService.canRead(profileId)) {
      return Failure(AuthError.profileAccessDenied(profileId));
    }

    return _repository.getRecentTurns(profileId, daysBack: daysBack);
  }
}
