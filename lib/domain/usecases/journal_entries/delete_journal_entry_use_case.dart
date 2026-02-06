// lib/domain/usecases/journal_entries/delete_journal_entry_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/repositories/journal_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/journal_entries/journal_entry_inputs.dart';

/// Use case to delete (soft delete) a journal entry.
class DeleteJournalEntryUseCase
    implements UseCase<DeleteJournalEntryInput, void> {
  final JournalEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  DeleteJournalEntryUseCase(this._repository, this._authService);

  @override
  Future<Result<void, AppError>> call(DeleteJournalEntryInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Verify entity exists and belongs to profile
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
