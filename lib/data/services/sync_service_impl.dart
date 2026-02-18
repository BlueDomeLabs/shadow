// lib/data/services/sync_service_impl.dart
// Implements 22_API_CONTRACTS.md Section 17 - SyncService upload path (Phase 2).
// Pull/apply/resolve operations stubbed for Phase 3/4.

import 'dart:convert';

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/encryption_service.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/remote/cloud_storage_provider.dart';
import 'package:shadow_app/domain/entities/sync_conflict.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';
import 'package:shadow_app/domain/services/sync_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// Adapter that knows how to query and update a specific entity type for sync.
///
/// Each entity type registers one of these with [SyncServiceImpl].
/// The adapter wraps an [EntityRepository] and provides entity-to-SyncChange
/// conversion using the [Syncable] interface.
/// Adapter that knows how to query and update a specific entity type for sync.
///
/// Each entity type registers one of these with [SyncServiceImpl].
/// The [withSyncMetadata] callback provides type-safe copyWith for marking
/// entities as synced after upload.
class SyncEntityAdapter<T extends Syncable> {
  final String entityType;
  final EntityRepository<T, String> repository;

  /// Returns a copy of the entity with the given sync metadata.
  /// Bridges generic Syncable to concrete Freezed copyWith.
  final T Function(T entity, SyncMetadata metadata) withSyncMetadata;

  const SyncEntityAdapter({
    required this.entityType,
    required this.repository,
    required this.withSyncMetadata,
  });

  /// Get dirty entities as SyncChanges, filtered by profileId.
  Future<Result<List<SyncChange>, AppError>> getPendingSyncChanges(
    String profileId,
  ) async {
    final result = await repository.getPendingSync();
    if (result.isFailure) return Failure(result.errorOrNull!);

    final changes = result.valueOrNull!
        .where((e) => e.profileId == profileId)
        .map(
          (e) => SyncChange(
            entityType: entityType,
            entityId: e.id,
            profileId: e.profileId,
            clientId: e.clientId,
            data: e.toJson(),
            version: e.syncMetadata.syncVersion,
            timestamp: e.syncMetadata.syncUpdatedAt,
            isDeleted: e.syncMetadata.isDeleted,
          ),
        )
        .toList();

    return Success(changes);
  }

  /// Count dirty entities for a profile.
  Future<Result<int, AppError>> getPendingSyncCount(String profileId) async {
    final result = await repository.getPendingSync();
    if (result.isFailure) return Failure(result.errorOrNull!);

    final count = result.valueOrNull!
        .where((e) => e.profileId == profileId)
        .length;

    return Success(count);
  }

  /// Mark an entity as synced after successful upload.
  ///
  /// Loads the entity, applies markSynced() to its sync metadata via
  /// the [withSyncMetadata] callback, then saves with markDirty: false.
  Future<Result<void, AppError>> markEntitySynced(String entityId) async {
    final getResult = await repository.getById(entityId);
    if (getResult.isFailure) return Failure(getResult.errorOrNull!);

    final entity = getResult.valueOrNull!;
    final syncedEntity = withSyncMetadata(
      entity,
      entity.syncMetadata.markSynced(),
    );

    final updateResult = await repository.update(
      syncedEntity,
      markDirty: false,
    );
    if (updateResult.isFailure) return Failure(updateResult.errorOrNull!);

    return const Success(null);
  }
}

/// Implementation of [SyncService] for Phase 2 (upload path).
///
/// Coordinates:
/// - [SyncEntityAdapter]s to query dirty records from all 14 entity repositories
/// - [EncryptionService] to encrypt entity data before upload
/// - [CloudStorageProvider] to upload encrypted data to Google Drive
/// - [SharedPreferences] to persist sync timestamps and versions
///
/// Pull and conflict resolution operations return stubs (Phase 3/4).
class SyncServiceImpl implements SyncService {
  static final _log = logger.scope('SyncService');

  static const String _lastSyncTimeKey = 'sync_last_sync_time_';
  static const String _lastSyncVersionKey = 'sync_last_sync_version_';

  final List<SyncEntityAdapter> _adapters;
  final EncryptionService _encryptionService;
  final CloudStorageProvider _cloudProvider;
  final SharedPreferences _prefs;

  SyncServiceImpl({
    required List<SyncEntityAdapter> adapters,
    required EncryptionService encryptionService,
    required CloudStorageProvider cloudProvider,
    required SharedPreferences prefs,
  }) : _adapters = adapters,
       _encryptionService = encryptionService,
       _cloudProvider = cloudProvider,
       _prefs = prefs;

  // === Push Operations ===

  @override
  Future<Result<List<SyncChange>, AppError>> getPendingChanges(
    String profileId, {
    int limit = 500,
  }) async {
    final allChanges = <SyncChange>[];

    for (final adapter in _adapters) {
      final result = await adapter.getPendingSyncChanges(profileId);
      if (result.isFailure) {
        _log.warning(
          'Failed to get pending changes for ${adapter.entityType}: '
          '${result.errorOrNull!.message}',
        );
        continue;
      }
      allChanges.addAll(result.valueOrNull!);
    }

    // Sort by timestamp ASC (oldest changes first)
    allChanges.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Apply limit
    if (allChanges.length > limit) {
      return Success(allChanges.sublist(0, limit));
    }

    return Success(allChanges);
  }

  @override
  Future<Result<PushChangesResult, AppError>> pushChanges(
    List<SyncChange> changes,
  ) async {
    if (changes.isEmpty) {
      return const Success(
        PushChangesResult(pushedCount: 0, failedCount: 0, conflicts: []),
      );
    }

    _log.info('Pushing ${changes.length} changes to cloud...');

    var pushedCount = 0;
    var failedCount = 0;
    final conflicts = <SyncConflict>[];

    for (final change in changes) {
      try {
        // 1. Encrypt entity data
        final jsonString = jsonEncode(change.data);
        final encryptedData = await _encryptionService.encrypt(jsonString);

        // 2. Build envelope with encrypted data
        final envelope = <String, dynamic>{
          'entityType': change.entityType,
          'entityId': change.entityId,
          'profileId': change.profileId,
          'clientId': change.clientId,
          'version': change.version,
          'timestamp': change.timestamp,
          'isDeleted': change.isDeleted,
          'encryptedData': encryptedData,
        };

        // 3. Upload to cloud
        final uploadResult = await _cloudProvider.uploadEntity(
          change.entityType,
          change.entityId,
          change.profileId,
          change.clientId,
          envelope,
          change.version,
        );

        if (uploadResult.isFailure) {
          _log.warning(
            'Failed to upload ${change.entityType}/${change.entityId}: '
            '${uploadResult.errorOrNull!.message}',
          );
          failedCount++;
          continue;
        }

        // 4. Mark entity as synced locally
        final adapter = _adapterFor(change.entityType);
        if (adapter != null) {
          await adapter.markEntitySynced(change.entityId);
        }

        pushedCount++;
      } on Exception catch (e, stack) {
        _log.error(
          'Error pushing ${change.entityType}/${change.entityId}',
          e,
          stack,
        );
        failedCount++;
      }
    }

    // 5. Update last sync time
    final now = DateTime.now().millisecondsSinceEpoch;
    if (pushedCount > 0 && changes.isNotEmpty) {
      final profileId = changes.first.profileId;
      await _prefs.setInt('$_lastSyncTimeKey$profileId', now);

      // Update version to max version pushed
      final maxVersion = changes
          .map((c) => c.version)
          .reduce((a, b) => a > b ? a : b);
      final currentVersion =
          _prefs.getInt('$_lastSyncVersionKey$profileId') ?? 0;
      if (maxVersion > currentVersion) {
        await _prefs.setInt('$_lastSyncVersionKey$profileId', maxVersion);
      }
    }

    _log.info(
      'Push complete: $pushedCount pushed, $failedCount failed, '
      '${conflicts.length} conflicts',
    );

    return Success(
      PushChangesResult(
        pushedCount: pushedCount,
        failedCount: failedCount,
        conflicts: conflicts,
      ),
    );
  }

  @override
  Future<void> pushPendingChanges() async {
    // Best-effort push for sign-out cleanup.
    // We don't know which profile, so push for all adapters.
    try {
      for (final adapter in _adapters) {
        final result = await adapter.repository.getPendingSync();
        if (result.isFailure) continue;

        final entities = result.valueOrNull!;
        if (entities.isEmpty) continue;

        final changes = entities
            .map(
              (e) => SyncChange(
                entityType: adapter.entityType,
                entityId: e.id,
                profileId: e.profileId,
                clientId: e.clientId,
                data: e.toJson(),
                version: e.syncMetadata.syncVersion,
                timestamp: e.syncMetadata.syncUpdatedAt,
                isDeleted: e.syncMetadata.isDeleted,
              ),
            )
            .toList();

        await pushChanges(changes);
      }
    } on Exception catch (e, stack) {
      // Best-effort: log but don't propagate
      _log.warning('pushPendingChanges failed (best-effort)', e, stack);
    }
  }

  // === Pull Operations (Phase 3 stubs) ===

  @override
  Future<Result<List<SyncChange>, AppError>> pullChanges(
    String profileId, {
    int? sinceVersion,
    int limit = 500,
  }) async =>
      // Phase 3: Will call _cloudProvider.getChangesSince()
      const Success([]);

  @override
  Future<Result<PullChangesResult, AppError>> applyChanges(
    String profileId,
    List<SyncChange> changes,
  ) async =>
      // Phase 3: Will detect conflicts and apply remote changes
      const Success(
        PullChangesResult(
          pulledCount: 0,
          appliedCount: 0,
          conflictCount: 0,
          conflicts: [],
          latestVersion: 0,
        ),
      );

  // === Conflict Resolution (Phase 4 stub) ===

  @override
  Future<Result<void, AppError>> resolveConflict(
    String conflictId,
    ConflictResolutionType resolution,
  ) async =>
      // Phase 4: Will look up conflict and apply resolution
      const Success(null);

  // === Status Queries ===

  @override
  Future<Result<int, AppError>> getPendingChangesCount(String profileId) async {
    var total = 0;

    for (final adapter in _adapters) {
      final result = await adapter.getPendingSyncCount(profileId);
      if (result.isSuccess) {
        total += result.valueOrNull!;
      }
    }

    return Success(total);
  }

  @override
  Future<Result<int, AppError>> getConflictCount(String profileId) async =>
      // Phase 4: Will query conflict storage
      const Success(0);

  @override
  Future<Result<int?, AppError>> getLastSyncTime(String profileId) async {
    final time = _prefs.getInt('$_lastSyncTimeKey$profileId');
    return Success(time);
  }

  @override
  Future<Result<int?, AppError>> getLastSyncVersion(String profileId) async {
    final version = _prefs.getInt('$_lastSyncVersionKey$profileId');
    return Success(version);
  }

  // === Private Helpers ===

  SyncEntityAdapter? _adapterFor(String entityType) {
    for (final adapter in _adapters) {
      if (adapter.entityType == entityType) return adapter;
    }
    _log.warning('No adapter registered for entity type: $entityType');
    return null;
  }
}
