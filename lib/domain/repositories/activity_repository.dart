// lib/domain/repositories/activity_repository.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.13

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Repository contract for Activity entities.
///
/// Extends EntityRepository with activity-specific query methods.
abstract class ActivityRepository
    implements EntityRepository<Activity, String> {
  // Inherited from EntityRepository:
  // - getAll, getById, create, update, delete, hardDelete
  // - getModifiedSince, getPendingSync

  /// Get activities for a profile with optional archive filter.
  Future<Result<List<Activity>, AppError>> getByProfile(
    String profileId, {
    bool includeArchived = false,
    int? limit,
    int? offset,
  });

  /// Get only active (non-archived) activities for a profile.
  Future<Result<List<Activity>, AppError>> getActive(String profileId);

  /// Archive an activity (seasonal/paused, can reactivate later).
  Future<Result<void, AppError>> archive(String id);

  /// Unarchive an activity (reactivate).
  Future<Result<void, AppError>> unarchive(String id);
}
