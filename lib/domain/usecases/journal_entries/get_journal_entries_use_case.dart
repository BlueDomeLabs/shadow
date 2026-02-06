// lib/domain/usecases/journal_entries/get_journal_entries_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/repositories/journal_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/journal_entries/journal_entry_inputs.dart';

/// Use case to get journal entries for a profile.
class GetJournalEntriesUseCase
    implements UseCase<GetJournalEntriesInput, List<JournalEntry>> {
  final JournalEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  GetJournalEntriesUseCase(this._repository, this._authService);

  @override
  Future<Result<List<JournalEntry>, AppError>> call(
    GetJournalEntriesInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation - start date must be before end date
    if (input.startDate != null &&
        input.endDate != null &&
        input.startDate! > input.endDate!) {
      return Failure(
        ValidationError.fromFieldErrors({
          'dateRange': ['Start date must be before end date'],
        }),
      );
    }

    // 3. Fetch from repository
    return _repository.getByProfile(
      input.profileId,
      startDate: input.startDate,
      endDate: input.endDate,
      tags: input.tags,
      mood: input.mood,
      limit: input.limit,
      offset: input.offset,
    );
  }
}
