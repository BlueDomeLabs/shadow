// lib/domain/repositories/sleep_entry_repository.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/sleep_entry.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Repository contract for SleepEntry entities.
///
/// Extends EntityRepository with sleep-specific query methods.
abstract class SleepEntryRepository
    implements EntityRepository<SleepEntry, String> {
  // Inherited from EntityRepository:
  // - getAll, getById, create, update, delete, hardDelete
  // - getModifiedSince, getPendingSync

  /// Get sleep entries for a profile with optional date filters.
  Future<Result<List<SleepEntry>, AppError>> getByProfile(
    String profileId, {
    int? startDate, // Epoch ms
    int? endDate, // Epoch ms
    int? limit,
    int? offset,
  });

  /// Get sleep entry for a specific night.
  Future<Result<SleepEntry?, AppError>> getForNight(
    String profileId,
    int date, // Epoch ms (start of day)
  );

  /// Get sleep averages for a date range.
  Future<Result<Map<String, double>, AppError>> getAverages(
    String profileId, {
    required int startDate, // Epoch ms
    required int endDate, // Epoch ms
  });
}
