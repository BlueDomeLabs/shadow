// lib/domain/usecases/fluids_entries/delete_fluids_entry_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 4.5.1

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/repositories/fluids_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/fluids_entries/fluids_entry_inputs.dart';

/// Use case to delete a fluids entry.
///
/// Follows the standard pattern:
/// 1. Authorization - Check profile access FIRST
/// 2. Fetch existing - Verify entity exists and belongs to profile
/// 3. Repository Call - Execute soft delete
class DeleteFluidsEntryUseCase
    implements UseCase<DeleteFluidsEntryInput, void> {
  final FluidsEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  DeleteFluidsEntryUseCase(this._repository, this._authService);

  @override
  Future<Result<void, AppError>> call(DeleteFluidsEntryInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch existing entity to verify ownership
    final existingResult = await _repository.getById(input.id);
    if (existingResult.isFailure) {
      return Failure(existingResult.errorOrNull!);
    }

    final existing = existingResult.valueOrNull!;

    // Verify entity belongs to the profile
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Soft delete
    return _repository.delete(input.id);
  }
}
