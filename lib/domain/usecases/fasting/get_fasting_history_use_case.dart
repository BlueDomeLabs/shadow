// lib/domain/usecases/fasting/get_fasting_history_use_case.dart
// Phase 15b-2 — Get fasting session history for a profile
// Per 59_DIET_TRACKING.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/fasting_session.dart';
import 'package:shadow_app/domain/repositories/fasting_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/fasting/fasting_types.dart';

/// Use case: get recent fasting sessions for a profile (most recent first).
class GetFastingHistoryUseCase
    implements UseCase<GetFastingHistoryInput, List<FastingSession>> {
  final FastingRepository _repository;
  final ProfileAuthorizationService _authService;

  GetFastingHistoryUseCase(this._repository, this._authService);

  @override
  Future<Result<List<FastingSession>, AppError>> call(
    GetFastingHistoryInput input,
  ) async {
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    return _repository.getByProfile(input.profileId, limit: input.limit);
  }
}
