// lib/presentation/providers/journal_entries/journal_entry_list_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/usecases/journal_entries/journal_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'journal_entry_list_provider.g.dart';

/// Provider for managing journal entry list with profile scope.
@riverpod
class JournalEntryList extends _$JournalEntryList {
  static final _log = logger.scope('JournalEntryList');

  @override
  Future<List<JournalEntry>> build(String profileId) async {
    _log.debug('Loading journal entries for profile: $profileId');

    final useCase = ref.read(getJournalEntriesUseCaseProvider);
    final result = await useCase(GetJournalEntriesInput(profileId: profileId));

    return result.when(
      success: (entries) {
        _log.debug('Loaded ${entries.length} journal entries');
        return entries;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Creates a new journal entry.
  Future<void> create(CreateJournalEntryInput input) async {
    _log.debug('Creating journal entry');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(createJournalEntryUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Journal entry created successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Create failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Updates an existing journal entry.
  Future<void> updateEntry(UpdateJournalEntryInput input) async {
    _log.debug('Updating journal entry: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(updateJournalEntryUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Journal entry updated successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Update failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Deletes a journal entry.
  Future<void> delete(DeleteJournalEntryInput input) async {
    _log.debug('Deleting journal entry: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(deleteJournalEntryUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Journal entry deleted successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Delete failed: ${error.message}');
        throw error;
      },
    );
  }
}
