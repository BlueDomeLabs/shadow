// lib/domain/repositories/condition_repository.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.8

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Repository contract for Condition entities.
///
/// Extends EntityRepository with condition-specific query methods.
abstract class ConditionRepository
    implements EntityRepository<Condition, String> {
  // Inherited from EntityRepository:
  // - getAll, getById, create, update, delete, hardDelete
  // - getModifiedSince, getPendingSync

  /// Get conditions for a profile with optional filters.
  Future<Result<List<Condition>, AppError>> getByProfile(
    String profileId, {
    ConditionStatus? status,
    bool includeArchived = false,
  });

  /// Get active (non-archived) conditions for a profile.
  Future<Result<List<Condition>, AppError>> getActive(String profileId);

  /// Archive a condition.
  Future<Result<void, AppError>> archive(String id);

  /// Resolve a condition (mark as resolved status).
  Future<Result<void, AppError>> resolve(String id);
}
