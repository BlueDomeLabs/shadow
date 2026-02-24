// lib/domain/repositories/fasting_repository.dart
// Phase 15b — Repository contract for FastingSession entities
// Per 59_DIET_TRACKING.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/fasting_session.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Repository contract for FastingSession entities.
///
/// Manages intermittent fasting sessions — when a fast started,
/// ended, and which protocol was used.
abstract class FastingRepository
    implements EntityRepository<FastingSession, String> {
  // Inherited: getAll, getById, create, update, delete, hardDelete,
  //            getModifiedSince, getPendingSync

  /// Get all fasting sessions for a profile, most recent first.
  Future<Result<List<FastingSession>, AppError>> getByProfile(
    String profileId, {
    int? limit,
  });

  /// Get the currently active fast (endedAt is null), or null if none.
  Future<Result<FastingSession?, AppError>> getActiveFast(String profileId);

  /// End the current active fast.
  Future<Result<FastingSession, AppError>> endFast(
    String sessionId,
    int endedAt, {
    bool isManualEnd = false,
  });
}
