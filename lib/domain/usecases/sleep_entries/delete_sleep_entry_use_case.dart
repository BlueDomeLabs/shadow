// lib/domain/usecases/sleep_entries/delete_sleep_entry_use_case.dart
// Following 22_API_CONTRACTS.md Section 4.5 CRUD Use Case Templates

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/repositories/sleep_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/sleep_entries/sleep_entry_inputs.dart';

/// Use case to delete (soft delete) a sleep entry.
///
/// Follows the standard pattern:
/// 1. Authorization - Check profile access FIRST
/// 2. Verify entity exists and belongs to profile
/// 3. Repository Call - Execute soft delete
class DeleteSleepEntryUseCase implements UseCase<DeleteSleepEntryInput, void> {
  final SleepEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  DeleteSleepEntryUseCase(this._repository, this._authService);

  @override
  Future<Result<void, AppError>> call(DeleteSleepEntryInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Verify entity exists and belongs to profile (returns Failure if not found)
    final existingResult = await _repository.getById(input.id);
    if (existingResult.isFailure) {
      return Failure(existingResult.errorOrNull!);
    }

    final existing = existingResult.valueOrNull!;

    // Verify the entry belongs to the profile
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Soft delete
    return _repository.delete(input.id);
  }
}
