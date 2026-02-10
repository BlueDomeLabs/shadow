// lib/domain/repositories/intake_log_repository.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.10

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/intake_log.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Repository contract for IntakeLog entities.
///
/// Extends EntityRepository with intake log-specific query methods.
abstract class IntakeLogRepository
    implements EntityRepository<IntakeLog, String> {
  // Inherited from EntityRepository:
  // - getAll, getById, create, update, delete, hardDelete
  // - getModifiedSince, getPendingSync

  /// Get intake logs for a profile with optional filters.
  Future<Result<List<IntakeLog>, AppError>> getByProfile(
    String profileId, {
    IntakeLogStatus? status,
    int? startDate, // Epoch ms
    int? endDate, // Epoch ms
    int? limit,
    int? offset,
  });

  /// Get intake logs for a specific supplement.
  Future<Result<List<IntakeLog>, AppError>> getBySupplement(
    String supplementId, {
    int? startDate, // Epoch ms
    int? endDate, // Epoch ms
  });

  /// Get pending intake logs for a specific date.
  Future<Result<List<IntakeLog>, AppError>> getPendingForDate(
    String profileId,
    int date, // Epoch ms (start of day)
  );

  /// Mark an intake as taken.
  Future<Result<IntakeLog, AppError>> markTaken(
    String id,
    int actualTime, // Epoch ms
  );

  /// Mark an intake as skipped.
  Future<Result<IntakeLog, AppError>> markSkipped(String id, String? reason);

  /// Mark an intake as snoozed.
  Future<Result<IntakeLog, AppError>> markSnoozed(
    String id,
    int snoozeDurationMinutes,
  );
}
