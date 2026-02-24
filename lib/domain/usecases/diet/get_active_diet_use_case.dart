// lib/domain/usecases/diet/get_active_diet_use_case.dart
// Phase 15b-2 — Get the currently active diet for a profile
// Per 59_DIET_TRACKING.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/diet.dart';
import 'package:shadow_app/domain/repositories/diet_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/diet/diet_types.dart';

/// Use case: get the currently active diet for a profile (null if none).
class GetActiveDietUseCase implements UseCase<GetActiveDietInput, Diet?> {
  final DietRepository _repository;
  final ProfileAuthorizationService _authService;

  GetActiveDietUseCase(this._repository, this._authService);

  @override
  Future<Result<Diet?, AppError>> call(GetActiveDietInput input) async {
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    return _repository.getActiveDiet(input.profileId);
  }
}
