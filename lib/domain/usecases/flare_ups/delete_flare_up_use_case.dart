// lib/domain/usecases/flare_ups/delete_flare_up_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/repositories/flare_up_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/flare_ups/flare_up_inputs.dart';

/// Use case to delete a flare-up (soft delete).
class DeleteFlareUpUseCase implements UseCase<DeleteFlareUpInput, void> {
  final FlareUpRepository _repository;
  final ProfileAuthorizationService _authService;

  DeleteFlareUpUseCase(this._repository, this._authService);

  @override
  Future<Result<void, AppError>> call(DeleteFlareUpInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch existing entity
    final existingResult = await _repository.getById(input.id);
    if (existingResult.isFailure) {
      return Failure(existingResult.errorOrNull!);
    }

    final existing = existingResult.valueOrNull!;

    // Verify the flare-up belongs to the profile
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Soft delete
    return _repository.delete(input.id);
  }
}
