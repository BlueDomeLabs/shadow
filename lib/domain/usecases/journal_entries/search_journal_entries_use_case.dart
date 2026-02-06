// lib/domain/usecases/journal_entries/search_journal_entries_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/repositories/journal_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/journal_entries/journal_entry_inputs.dart';

/// Use case to search journal entries.
class SearchJournalEntriesUseCase
    implements UseCase<SearchJournalEntriesInput, List<JournalEntry>> {
  final JournalEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  SearchJournalEntriesUseCase(this._repository, this._authService);

  @override
  Future<Result<List<JournalEntry>, AppError>> call(
    SearchJournalEntriesInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    if (input.query.trim().isEmpty) {
      return Failure(
        ValidationError.fromFieldErrors({
          'query': ['Search query cannot be empty'],
        }),
      );
    }

    // 3. Search from repository
    return _repository.search(input.profileId, input.query);
  }
}
