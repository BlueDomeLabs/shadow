// lib/domain/services/sync_service.dart
// Implements 22_API_CONTRACTS.md Section 17.2

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/remote/cloud_storage_provider.dart';
import 'package:shadow_app/domain/entities/sync_conflict.dart';

/// Domain-layer sync orchestration service.
///
/// Coordinates local dirty-record queries with CloudStorageProvider
/// remote operations. Injected into sync use cases and providers.
///
/// All methods return `Result<T, AppError>` per Section 1.
abstract class SyncService {
  // === Push Operations ===

  /// Get locally-modified records awaiting sync upload.
  ///
  /// Queries all entity tables for records where sync_is_dirty = true.
  /// Includes tombstones (soft-deleted records) that need to propagate
  /// per Section 15.1.
  ///
  /// Returns at most [limit] changes, ordered by sync_updated_at ASC.
  Future<Result<List<SyncChange>, AppError>> getPendingChanges(
    String profileId, {
    int limit = 500,
  });

  /// Push local changes to the cloud provider.
  ///
  /// For each SyncChange: encrypts entity data with AES-256-GCM,
  /// then calls CloudStorageProvider.uploadEntity. Returns aggregate result
  /// with count of pushed/failed and any conflicts detected.
  Future<Result<PushChangesResult, AppError>> pushChanges(
    List<SyncChange> changes,
  );

  /// Convenience: push ALL pending changes for sign-out cleanup.
  ///
  /// Best-effort - errors are logged but do not fail sign-out.
  Future<void> pushPendingChanges();

  // === Pull Operations (Phase 3) ===

  /// Pull remote changes from the cloud provider since [sinceVersion].
  Future<Result<List<SyncChange>, AppError>> pullChanges(
    String profileId, {
    int? sinceVersion,
    int limit = 500,
  });

  /// Apply pulled remote changes to local database.
  Future<Result<PullChangesResult, AppError>> applyChanges(
    String profileId,
    List<SyncChange> changes,
  );

  // === Conflict Resolution (Phase 4) ===

  /// Resolve a sync conflict by applying the chosen resolution strategy.
  Future<Result<void, AppError>> resolveConflict(
    String conflictId,
    ConflictResolutionType resolution,
  );

  // === Status Queries ===

  /// Get count of locally-modified records awaiting sync.
  Future<Result<int, AppError>> getPendingChangesCount(String profileId);

  /// Get count of unresolved sync conflicts for a profile.
  Future<Result<int, AppError>> getConflictCount(String profileId);

  /// Get all unresolved sync conflicts for a profile.
  Future<Result<List<SyncConflict>, AppError>> getUnresolvedConflicts(
    String profileId,
  );

  /// Get last successful sync time (epoch milliseconds) for a profile.
  Future<Result<int?, AppError>> getLastSyncTime(String profileId);

  /// Get last successfully synced version number for a profile.
  /// Returns null if never synced.
  Future<Result<int?, AppError>> getLastSyncVersion(String profileId);
}

/// Result of a push operation.
class PushChangesResult {
  final int pushedCount;
  final int failedCount;
  final List<SyncConflict> conflicts;

  const PushChangesResult({
    required this.pushedCount,
    required this.failedCount,
    required this.conflicts,
  });
}

/// Result of a pull operation.
class PullChangesResult {
  final int pulledCount;
  final int appliedCount;
  final int conflictCount;
  final List<SyncConflict> conflicts;
  final int latestVersion;

  const PullChangesResult({
    required this.pulledCount,
    required this.appliedCount,
    required this.conflictCount,
    required this.conflicts,
    required this.latestVersion,
  });
}
