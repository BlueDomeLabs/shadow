// lib/domain/repositories/supplement_repository.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 4.3

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Repository contract for Supplement entities.
///
/// Extends EntityRepository with supplement-specific query methods.
abstract class SupplementRepository
    implements EntityRepository<Supplement, String> {
  // Inherited from EntityRepository:
  // - getAll, getById, create, update, delete, hardDelete
  // - getModifiedSince, getPendingSync

  /// Get supplements for a profile with optional active filter.
  Future<Result<List<Supplement>, AppError>> getByProfile(
    String profileId, {
    bool? activeOnly,
    int? limit,
    int? offset,
  });

  /// Get supplements due at a specific time.
  Future<Result<List<Supplement>, AppError>> getDueAt(
    String profileId,
    int time, // Epoch ms
  );

  /// Search supplements by name.
  Future<Result<List<Supplement>, AppError>> search(
    String profileId,
    String query, {
    int limit = ValidationRules.defaultSearchLimit,
  });
}
