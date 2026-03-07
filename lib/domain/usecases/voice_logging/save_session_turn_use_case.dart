// lib/domain/usecases/voice_logging/save_session_turn_use_case.dart
// Per VOICE_LOGGING_SPEC.md Section 4

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/voice_logging/voice_session_turn.dart';
import 'package:shadow_app/domain/repositories/voice_logging_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';

/// Persists a single conversation turn to session history.
class SaveSessionTurnUseCase {
  final VoiceLoggingRepository _repository;
  final ProfileAuthorizationService _authService;

  SaveSessionTurnUseCase(this._repository, this._authService);

  Future<Result<void, AppError>> execute(VoiceSessionTurn turn) async {
    if (!await _authService.canWrite(turn.profileId)) {
      return Failure(AuthError.profileAccessDenied(turn.profileId));
    }

    return _repository.saveTurn(turn);
  }
}
