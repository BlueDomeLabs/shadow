// lib/presentation/providers/journal_entries/journal_entry_search_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/usecases/journal_entries/journal_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'journal_entry_search_provider.g.dart';

/// Provider for searching journal entries with profile scope.
///
/// Takes both profileId and query as build parameters.
@riverpod
class JournalEntrySearch extends _$JournalEntrySearch {
  static final _log = logger.scope('JournalEntrySearch');

  @override
  Future<List<JournalEntry>> build(String profileId, String query) async {
    // Return empty list for empty query
    if (query.isEmpty) {
      return [];
    }

    _log.debug('Searching journal entries for query: $query');

    final useCase = ref.read(searchJournalEntriesUseCaseProvider);
    final result = await useCase(
      SearchJournalEntriesInput(profileId: profileId, query: query),
    );

    return result.when(
      success: (entries) {
        _log.debug('Found ${entries.length} journal entries matching query');
        return entries;
      },
      failure: (error) {
        _log.error('Search failed: ${error.message}');
        throw error;
      },
    );
  }
}
