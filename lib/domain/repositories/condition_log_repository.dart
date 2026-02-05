// lib/domain/repositories/condition_log_repository.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.9

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/condition_log.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Repository contract for ConditionLog entities.
///
/// Extends EntityRepository with condition log-specific query methods.
abstract class ConditionLogRepository
    implements EntityRepository<ConditionLog, String> {
  // Inherited from EntityRepository:
  // - getAll, getById, create, update, delete, hardDelete
  // - getModifiedSince, getPendingSync

  /// Get condition logs for a profile with optional filters.
  Future<Result<List<ConditionLog>, AppError>> getByProfile(
    String profileId, {
    int? startDate, // Epoch ms
    int? endDate, // Epoch ms
    int? limit,
    int? offset,
  });

  /// Get condition logs for a specific condition.
  Future<Result<List<ConditionLog>, AppError>> getByCondition(
    String conditionId, {
    int? limit,
    int? offset,
  });

  /// Get condition logs by date range.
  Future<Result<List<ConditionLog>, AppError>> getByDateRange(
    String profileId,
    int start, // Epoch ms
    int end, // Epoch ms
  );

  /// Get flare logs for a specific condition.
  Future<Result<List<ConditionLog>, AppError>> getFlares(
    String conditionId, {
    int? limit,
  });
}
