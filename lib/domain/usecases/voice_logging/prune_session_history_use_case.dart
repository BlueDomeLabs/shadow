// lib/domain/usecases/voice_logging/prune_session_history_use_case.dart
// Per VOICE_LOGGING_SPEC.md Section 4

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/repositories/voice_logging_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';

/// Deletes voice session turns older than 90 days for a profile.
///
/// Should be called at the start of each session.
class PruneSessionHistoryUseCase {
  final VoiceLoggingRepository _repository;
  final ProfileAuthorizationService _authService;

  PruneSessionHistoryUseCase(this._repository, this._authService);

  Future<Result<void, AppError>> execute(String profileId) async {
    if (!await _authService.canWrite(profileId)) {
      return Failure(AuthError.profileAccessDenied(profileId));
    }

    return _repository.pruneOldTurns(profileId);
  }
}
