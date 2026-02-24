// lib/domain/usecases/fasting/get_active_fast_use_case.dart
// Phase 15b-2 — Get the currently active fasting session
// Per 59_DIET_TRACKING.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/fasting_session.dart';
import 'package:shadow_app/domain/repositories/fasting_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/fasting/fasting_types.dart';

/// Use case: get the currently active fasting session (null if none).
class GetActiveFastUseCase
    implements UseCase<GetActiveFastInput, FastingSession?> {
  final FastingRepository _repository;
  final ProfileAuthorizationService _authService;

  GetActiveFastUseCase(this._repository, this._authService);

  @override
  Future<Result<FastingSession?, AppError>> call(
    GetActiveFastInput input,
  ) async {
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    return _repository.getActiveFast(input.profileId);
  }
}
