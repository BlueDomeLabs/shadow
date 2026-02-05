// lib/domain/repositories/journal_entry_repository.dart
// Repository interface per 22_API_CONTRACTS.md Section 10.16

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Repository interface for JournalEntry entities.
///
/// Per 22_API_CONTRACTS.md Section 10.16:
/// - Extends EntityRepository for standard CRUD and sync operations
/// - All methods return `Result<T, AppError>`
/// - All timestamps are int (epoch milliseconds)
abstract class JournalEntryRepository
    implements EntityRepository<JournalEntry, String> {
  /// Get journal entries for a profile with optional filtering.
  ///
  /// [startDate] and [endDate] are epoch milliseconds.
  Future<Result<List<JournalEntry>, AppError>> getByProfile(
    String profileId, {
    int? startDate,
    int? endDate,
    List<String>? tags,
    int? mood,
    int? limit,
    int? offset,
  });

  /// Search journal entries by content/title.
  Future<Result<List<JournalEntry>, AppError>> search(
    String profileId,
    String query,
  );

  /// Get mood distribution for a date range.
  ///
  /// Returns a map of mood value (1-10) to count.
  Future<Result<Map<int, int>, AppError>> getMoodDistribution(
    String profileId, {
    required int startDate,
    required int endDate,
  });
}
