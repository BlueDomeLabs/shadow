// lib/domain/repositories/diet_repository.dart
// Phase 15b — Repository contract for Diet entities
// Per 59_DIET_TRACKING.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/diet.dart';
import 'package:shadow_app/domain/entities/diet_exception.dart';
import 'package:shadow_app/domain/entities/diet_rule.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Repository contract for Diet entities.
///
/// Manages diet configurations (preset and custom), including their
/// associated DietRule and DietException child records.
abstract class DietRepository implements EntityRepository<Diet, String> {
  // Inherited: getAll, getById, create, update, delete, hardDelete,
  //            getModifiedSince, getPendingSync

  /// Get all diets for a profile.
  Future<Result<List<Diet>, AppError>> getByProfile(String profileId);

  /// Get the currently active diet for a profile (null if none active).
  Future<Result<Diet?, AppError>> getActiveDiet(String profileId);

  /// Set a diet as the active diet for the profile.
  /// Deactivates any previously active diet first.
  Future<Result<Diet, AppError>> setActive(String dietId, String profileId);

  /// Deactivate the current diet (set isActive=false, do not delete).
  Future<Result<void, AppError>> deactivate(String profileId);

  // ---- Rules ----

  /// Get all rules for a diet.
  Future<Result<List<DietRule>, AppError>> getRules(String dietId);

  /// Add a rule to a diet.
  Future<Result<DietRule, AppError>> addRule(DietRule rule);

  /// Update a rule.
  Future<Result<DietRule, AppError>> updateRule(DietRule rule);

  /// Delete a rule (and all its exceptions).
  Future<Result<void, AppError>> deleteRule(String ruleId);

  // ---- Exceptions ----

  /// Get all exceptions for a rule.
  Future<Result<List<DietException>, AppError>> getExceptions(String ruleId);

  /// Add an exception to a rule.
  Future<Result<DietException, AppError>> addException(DietException exception);

  /// Delete an exception.
  Future<Result<void, AppError>> deleteException(String exceptionId);
}
