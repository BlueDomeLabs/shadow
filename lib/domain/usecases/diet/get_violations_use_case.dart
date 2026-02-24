// lib/domain/usecases/diet/get_violations_use_case.dart
// Phase 15b-2 — Get diet violations for a profile
// Per 59_DIET_TRACKING.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/diet_violation.dart';
import 'package:shadow_app/domain/repositories/diet_violation_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/diet/diet_types.dart';

/// Use case: get diet violations for a profile, with optional date range.
class GetViolationsUseCase
    implements UseCase<GetViolationsInput, List<DietViolation>> {
  final DietViolationRepository _repository;
  final ProfileAuthorizationService _authService;

  GetViolationsUseCase(this._repository, this._authService);

  @override
  Future<Result<List<DietViolation>, AppError>> call(
    GetViolationsInput input,
  ) async {
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    return _repository.getByProfile(
      input.profileId,
      startDate: input.startDate,
      endDate: input.endDate,
      limit: input.limit,
    );
  }
}
