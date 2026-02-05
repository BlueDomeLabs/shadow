// lib/domain/repositories/fluids_entry_repository.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Repository contract for FluidsEntry entities.
///
/// Extends EntityRepository with fluids-specific query methods.
abstract class FluidsEntryRepository
    implements EntityRepository<FluidsEntry, String> {
  // Inherited from EntityRepository:
  // - getAll, getById, create, update, delete, hardDelete
  // - getModifiedSince, getPendingSync

  /// Get entries for a profile within a date range.
  Future<Result<List<FluidsEntry>, AppError>> getByDateRange(
    String profileId,
    int start, // Epoch ms
    int end, // Epoch ms
  );

  /// Get entries with BBT data for chart.
  Future<Result<List<FluidsEntry>, AppError>> getBBTEntries(
    String profileId,
    int start, // Epoch ms
    int end, // Epoch ms
  );

  /// Get entries with menstruation data.
  Future<Result<List<FluidsEntry>, AppError>> getMenstruationEntries(
    String profileId,
    int start, // Epoch ms
    int end, // Epoch ms
  );

  /// Get most recent entry for today.
  Future<Result<FluidsEntry?, AppError>> getTodayEntry(String profileId);
}
