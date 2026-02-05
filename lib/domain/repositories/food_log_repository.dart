// lib/domain/repositories/food_log_repository.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.12

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/food_log.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Repository contract for FoodLog entities.
///
/// Extends EntityRepository with food-log-specific query methods.
abstract class FoodLogRepository implements EntityRepository<FoodLog, String> {
  // Inherited from EntityRepository:
  // - getAll, getById, create, update, delete, hardDelete
  // - getModifiedSince, getPendingSync

  /// Get food logs for a profile with optional date filters.
  Future<Result<List<FoodLog>, AppError>> getByProfile(
    String profileId, {
    int? startDate, // Epoch ms
    int? endDate, // Epoch ms
    int? limit,
    int? offset,
  });

  /// Get food logs for a specific date.
  Future<Result<List<FoodLog>, AppError>> getForDate(
    String profileId,
    int date, // Epoch ms (start of day)
  );

  /// Get food logs within a date range.
  Future<Result<List<FoodLog>, AppError>> getByDateRange(
    String profileId,
    int startDate, // Epoch ms
    int endDate, // Epoch ms
  );
}
