// lib/domain/usecases/fasting/end_fast_use_case.dart
// Phase 15b-2 — End an active fasting session
// Per 59_DIET_TRACKING.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/fasting_session.dart';
import 'package:shadow_app/domain/repositories/fasting_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/fasting/fasting_types.dart';

/// Use case: end the current fasting session.
///
/// Sets [endedAt] and [isManualEnd] on the session and marks it as dirty.
class EndFastUseCase implements UseCase<EndFastInput, FastingSession> {
  final FastingRepository _repository;
  final ProfileAuthorizationService _authService;

  EndFastUseCase(this._repository, this._authService);

  @override
  Future<Result<FastingSession, AppError>> call(EndFastInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch session and verify ownership
    final sessionResult = await _repository.getById(input.sessionId);
    if (sessionResult.isFailure) return Failure(sessionResult.errorOrNull!);

    final session = sessionResult.valueOrNull!;
    if (session.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Already ended?
    if (!session.isActive) {
      return Success(session);
    }

    // 4. End the fast
    return _repository.endFast(
      input.sessionId,
      input.endedAt,
      isManualEnd: input.isManualEnd,
    );
  }
}
