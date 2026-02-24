// lib/domain/repositories/health_sync_status_repository.dart
// Phase 16 — Repository interface for health sync status tracking
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/health_sync_status.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

/// Repository for tracking the last sync result per data type.
///
/// Enables incremental sync — subsequent syncs only fetch records newer than
/// the last successful sync timestamp. One record per (profileId, dataType).
/// Local only — not synced to Google Drive.
abstract class HealthSyncStatusRepository {
  /// Returns all sync status records for a profile.
  Future<Result<List<HealthSyncStatus>, AppError>> getByProfile(
    String profileId,
  );

  /// Returns the sync status for a specific data type, or null if never synced.
  Future<Result<HealthSyncStatus?, AppError>> getByDataType(
    String profileId,
    HealthDataType dataType,
  );

  /// Creates or updates the sync status for a (profileId, dataType) pair.
  Future<Result<HealthSyncStatus, AppError>> upsert(HealthSyncStatus status);
}
