// lib/domain/repositories/activity_log_repository.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.14

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/activity_log.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Repository contract for ActivityLog entities.
///
/// Extends EntityRepository with activity-log-specific query methods.
abstract class ActivityLogRepository
    implements EntityRepository<ActivityLog, String> {
  // Inherited from EntityRepository:
  // - getAll, getById, create, update, delete, hardDelete
  // - getModifiedSince, getPendingSync

  /// Get activity logs for a profile with optional date filters.
  Future<Result<List<ActivityLog>, AppError>> getByProfile(
    String profileId, {
    int? startDate, // Epoch ms
    int? endDate, // Epoch ms
    int? limit,
    int? offset,
  });

  /// Get activity logs for a specific date.
  Future<Result<List<ActivityLog>, AppError>> getForDate(
    String profileId,
    int date, // Epoch ms (start of day)
  );

  /// Get activity log by external import ID (for deduplication of wearable data).
  Future<Result<ActivityLog?, AppError>> getByExternalId(
    String profileId,
    String importSource,
    String importExternalId,
  );
}
