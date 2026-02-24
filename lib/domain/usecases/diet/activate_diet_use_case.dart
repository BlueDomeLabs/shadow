// lib/domain/usecases/diet/activate_diet_use_case.dart
// Phase 15b-2 — Activate a diet (deactivates any currently active diet)
// Per 22_API_CONTRACTS.md Section 4.5.4

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/diet.dart';
import 'package:shadow_app/domain/repositories/diet_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/diet/diet_types.dart';

/// Use case: activate a diet.
///
/// Deactivates the currently active diet (if any), then activates the
/// specified diet. Returns the newly activated diet.
class ActivateDietUseCase implements UseCase<ActivateDietInput, Diet> {
  final DietRepository _repository;
  final ProfileAuthorizationService _authService;

  ActivateDietUseCase(this._repository, this._authService);

  @override
  Future<Result<Diet, AppError>> call(ActivateDietInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch the diet to activate
    final dietResult = await _repository.getById(input.dietId);
    if (dietResult.isFailure) return Failure(dietResult.errorOrNull!);

    final diet = dietResult.valueOrNull!;

    // 3. Verify ownership
    if (diet.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 4. Already active — return immediately
    if (diet.isActive) return Success(diet);

    // 5. Delegate to repository (deactivates others + activates this one)
    return _repository.setActive(input.dietId, input.profileId);
  }
}
