// lib/domain/repositories/diet_violation_repository.dart
// Phase 15b — Repository contract for DietViolation entities
// Per 59_DIET_TRACKING.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/diet_violation.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Repository contract for DietViolation entities.
///
/// Records when a user's food log triggered a diet compliance check failure,
/// whether they added the food anyway (wasOverridden=true) or cancelled.
abstract class DietViolationRepository
    implements EntityRepository<DietViolation, String> {
  // Inherited: getAll, getById, create, update, delete, hardDelete,
  //            getModifiedSince, getPendingSync

  /// Get violations for a profile within an optional date range.
  Future<Result<List<DietViolation>, AppError>> getByProfile(
    String profileId, {
    int? startDate, // Epoch ms
    int? endDate, // Epoch ms
    int? limit,
  });

  /// Get all violations for a specific diet.
  Future<Result<List<DietViolation>, AppError>> getByDiet(String dietId);
}
