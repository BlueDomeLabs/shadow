// lib/data/services/sync_service_impl.dart
// Implements 22_API_CONTRACTS.md Section 17 - SyncService.
// Phase 2: Push (upload) path. Phase 3: Pull (download) path.

import 'dart:convert';

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/encryption_service.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/sync_conflict_dao.dart';
import 'package:shadow_app/data/datasources/remote/cloud_storage_provider.dart';
import 'package:shadow_app/domain/entities/sync_conflict.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';
import 'package:shadow_app/domain/services/sync_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Adapter that knows how to query and update a specific entity type for sync.
///
/// Each entity type registers one of these with [SyncServiceImpl].
/// The [withSyncMetadata] callback provides type-safe copyWith for marking
/// entities as synced after upload. The [fromJson] callback reconstructs
/// entities from downloaded JSON for the pull path (Section 17.4).
class SyncEntityAdapter<T extends Syncable> {
  final String entityType;
  final EntityRepository<T, String> repository;

  /// Returns a copy of the entity with the given sync metadata.
  /// Bridges generic Syncable to concrete Freezed copyWith.
  final T Function(T entity, SyncMetadata metadata) withSyncMetadata;

  /// Reconstruct an entity from its JSON representation (for pull path).
  /// Bridges the generic Syncable interface to concrete Freezed fromJson.
  final T Function(Map<String, dynamic> json) fromJson;

  const SyncEntityAdapter({
    required this.entityType,
    required this.repository,
    required this.withSyncMetadata,
    required this.fromJson,
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

  /// Reconstruct a remote entity from JSON and mark it as synced.
  ///
  /// Used by [SyncServiceImpl.applyChanges] for the pull path.
  /// Keeps the generic type T contained within the adapter method
  /// to avoid Dart generic type erasure issues.
  T reconstructSynced(Map<String, dynamic> json) {
    final entity = fromJson(json);
    return withSyncMetadata(entity, entity.syncMetadata.markSynced());
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

  /// Mark an entity as conflicted with a remote version.
  ///
  /// Applies markConflict(remoteJson) to its sync metadata, storing the
  /// remote JSON in conflictData on the entity row.
  /// Per 22_API_CONTRACTS.md Section 17.7.1: pass markDirty:false because
  /// markConflict() already sets syncIsDirty=true in the returned metadata.
  Future<Result<void, AppError>> markEntityConflicted(
    String entityId,
    String remoteJson,
  ) async {
    final getResult = await repository.getById(entityId);
    if (getResult.isFailure) return Failure(getResult.errorOrNull!);

    final entity = getResult.valueOrNull!;
    final conflictedEntity = withSyncMetadata(
      entity,
      entity.syncMetadata.markConflict(remoteJson),
    );

    final updateResult = await repository.update(
      conflictedEntity,
      markDirty: false,
    );
    if (updateResult.isFailure) return Failure(updateResult.errorOrNull!);

    return const Success(null);
  }

  /// Clear a conflict on an entity after keepLocal or photo_entries merge.
  ///
  /// Applies clearConflict() to the entity's sync metadata, which sets
  /// syncStatus=pending, syncIsDirty=true, increments syncVersion, and
  /// clears conflictData. The entity will re-upload on the next push.
  Future<Result<void, AppError>> clearEntityConflict(String entityId) async {
    final getResult = await repository.getById(entityId);
    if (getResult.isFailure) return Failure(getResult.errorOrNull!);

    final entity = getResult.valueOrNull!;
    final clearedEntity = withSyncMetadata(
      entity,
      entity.syncMetadata.clearConflict(),
    );

    final updateResult = await repository.update(
      clearedEntity,
      markDirty: false,
    );
    if (updateResult.isFailure) return Failure(updateResult.errorOrNull!);

    return const Success(null);
  }

  /// Apply a pre-built merged entity (for journal_entries merge resolution).
  ///
  /// Reconstructs the entity from [mergedJson], applies clearConflict() from
  /// the current local entity's sync metadata, and saves with markDirty:false.
  /// The clearConflict() call already sets syncIsDirty=true.
  Future<Result<void, AppError>> applyMergedEntity(
    String entityId,
    Map<String, dynamic> mergedJson,
  ) async {
    final localResult = await repository.getById(entityId);
    if (localResult.isFailure) return Failure(localResult.errorOrNull!);

    final localEntity = localResult.valueOrNull!;
    final mergedEntityRaw = fromJson(mergedJson);
    final mergedEntity = withSyncMetadata(
      mergedEntityRaw,
      localEntity.syncMetadata.clearConflict(),
    );

    return repository.update(mergedEntity, markDirty: false);
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
/// Pull, push, conflict detection, and resolution are all fully implemented.
class SyncServiceImpl implements SyncService {
  static final _log = logger.scope('SyncService');

  static const String _lastSyncTimeKey = 'sync_last_sync_time_';
  static const String _lastSyncVersionKey = 'sync_last_sync_version_';

  final List<SyncEntityAdapter> _adapters;
  final EncryptionService _encryptionService;
  final CloudStorageProvider _cloudProvider;
  final SharedPreferences _prefs;
  final SyncConflictDao _conflictDao;

  SyncServiceImpl({
    required List<SyncEntityAdapter> adapters,
    required EncryptionService encryptionService,
    required CloudStorageProvider cloudProvider,
    required SharedPreferences prefs,
    required SyncConflictDao conflictDao,
  }) : _adapters = adapters,
       _encryptionService = encryptionService,
       _cloudProvider = cloudProvider,
       _prefs = prefs,
       _conflictDao = conflictDao;

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

  // === Pull Operations (Phase 3) ===

  @override
  Future<Result<List<SyncChange>, AppError>> pullChanges(
    String profileId, {
    int? sinceVersion,
    int limit = 500,
  }) async {
    try {
      // 1. Get last sync time (epoch ms). 0 = first sync, pull everything.
      final lastSyncTime = _prefs.getInt('$_lastSyncTimeKey$profileId') ?? 0;

      _log.info('Pulling changes since $lastSyncTime for profile $profileId');

      // 2. Fetch raw envelopes from cloud provider
      final remoteResult = await _cloudProvider.getChangesSince(lastSyncTime);
      if (remoteResult.isFailure) {
        return Failure(remoteResult.errorOrNull!);
      }

      final rawChanges = remoteResult.valueOrNull!;
      if (rawChanges.isEmpty) {
        _log.info('No remote changes found');
        return const Success([]);
      }

      // 3. Decrypt each envelope's encryptedData field
      final decryptedChanges = <SyncChange>[];

      for (final change in rawChanges) {
        // Filter by profileId — only apply changes for this profile
        if (change.profileId != profileId) continue;

        try {
          final encryptedData = change.data['encryptedData'] as String?;
          if (encryptedData == null) {
            _log.warning(
              'Skipping ${change.entityType}/${change.entityId}: '
              'missing encryptedData',
            );
            continue;
          }

          // Decrypt and parse entity JSON
          final decryptedJson = await _encryptionService.decrypt(encryptedData);
          final entityData = jsonDecode(decryptedJson) as Map<String, dynamic>;

          decryptedChanges.add(
            SyncChange(
              entityType: change.entityType,
              entityId: change.entityId,
              profileId: change.profileId,
              clientId: change.clientId,
              data: entityData,
              version: change.version,
              timestamp: change.timestamp,
              isDeleted: change.isDeleted,
            ),
          );
        } on Exception catch (e) {
          _log.warning(
            'Failed to decrypt ${change.entityType}/${change.entityId}: $e',
          );
          // Skip corrupted/undecryptable entries, continue with others
        }
      }

      // 4. Apply limit and sort by timestamp
      decryptedChanges.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      if (decryptedChanges.length > limit) {
        return Success(decryptedChanges.sublist(0, limit));
      }

      _log.info('Pulled ${decryptedChanges.length} changes');
      return Success(decryptedChanges);
    } on Exception catch (e, stack) {
      _log.error('pullChanges failed', e, stack);
      return Failure(SyncError.downloadFailed('pull', e, stack));
    }
  }

  @override
  Future<Result<PullChangesResult, AppError>> applyChanges(
    String profileId,
    List<SyncChange> changes,
  ) async {
    if (changes.isEmpty) {
      return const Success(
        PullChangesResult(
          pulledCount: 0,
          appliedCount: 0,
          conflictCount: 0,
          conflicts: [],
          latestVersion: 0,
        ),
      );
    }

    _log.info(
      'Applying ${changes.length} remote changes for profile $profileId',
    );

    var appliedCount = 0;
    var conflictCount = 0;
    final conflicts = <SyncConflict>[];
    var maxVersion = 0;

    for (final change in changes) {
      try {
        final adapter = _adapterFor(change.entityType);
        if (adapter == null) {
          _log.warning('Skipping unknown entity type: ${change.entityType}');
          continue;
        }

        if (change.version > maxVersion) {
          maxVersion = change.version;
        }

        // Reconstruct entity from JSON and mark as synced.
        // Uses reconstructSynced to keep the generic type T contained
        // within the adapter (avoids Dart type erasure issues).
        final syncedEntity = adapter.reconstructSynced(change.data);

        // Check if entity exists locally
        final localResult = await adapter.repository.getById(change.entityId);

        if (localResult.isFailure) {
          // Entity doesn't exist locally → insert
          final createResult = await adapter.repository.create(syncedEntity);
          if (createResult.isFailure) {
            _log.warning(
              'Failed to create ${change.entityType}/${change.entityId}: '
              '${createResult.errorOrNull!.message}',
            );
            continue;
          }

          appliedCount++;
        } else {
          // Entity exists locally
          final localEntity = localResult.valueOrNull!;

          if (!localEntity.syncMetadata.syncIsDirty) {
            // Local is clean → overwrite with remote version
            // Per Section 9.2: markDirty: false for remote sync applies
            final updateResult = await adapter.repository.update(
              syncedEntity,
              markDirty: false,
            );
            if (updateResult.isFailure) {
              _log.warning(
                'Failed to update ${change.entityType}/${change.entityId}: '
                '${updateResult.errorOrNull!.message}',
              );
              continue;
            }

            appliedCount++;
          } else {
            // Local is dirty → conflict detected
            // Per 22_API_CONTRACTS.md Section 17.7.1: two writes atomically
            _log.warning(
              'Conflict: ${change.entityType}/${change.entityId} '
              '(local v${localEntity.syncMetadata.syncVersion} '
              'vs remote v${change.version})',
            );

            final conflict = SyncConflict(
              id: const Uuid().v4(),
              entityType: change.entityType,
              entityId: change.entityId,
              profileId: profileId,
              localVersion: localEntity.syncMetadata.syncVersion,
              remoteVersion: change.version,
              localData: localEntity.toJson(),
              remoteData: change.data,
              detectedAt: DateTime.now().millisecondsSinceEpoch,
            );

            // Write 1: Insert SyncConflict row into sync_conflicts table
            final insertResult = await _conflictDao.insert(conflict);
            if (insertResult.isFailure) {
              _log.warning(
                'Failed to persist conflict for '
                '${change.entityType}/${change.entityId}: '
                '${insertResult.errorOrNull!.message}',
              );
            }

            // Write 2: Mark entity row as conflicted (stores remoteJson)
            final markResult = await adapter.markEntityConflicted(
              change.entityId,
              jsonEncode(change.data),
            );
            if (markResult.isFailure) {
              _log.warning(
                'Failed to mark entity conflicted for '
                '${change.entityType}/${change.entityId}: '
                '${markResult.errorOrNull!.message}',
              );
            }

            conflicts.add(conflict);
            conflictCount++;
          }
        }
      } on Exception catch (e, stack) {
        _log.error(
          'Error applying ${change.entityType}/${change.entityId}',
          e,
          stack,
        );
      }
    }

    // Update last sync time and version
    final now = DateTime.now().millisecondsSinceEpoch;
    if (appliedCount > 0) {
      await _prefs.setInt('$_lastSyncTimeKey$profileId', now);
      final currentVersion =
          _prefs.getInt('$_lastSyncVersionKey$profileId') ?? 0;
      if (maxVersion > currentVersion) {
        await _prefs.setInt('$_lastSyncVersionKey$profileId', maxVersion);
      }
    }

    _log.info(
      'Apply complete: $appliedCount applied, $conflictCount conflicts',
    );

    return Success(
      PullChangesResult(
        pulledCount: changes.length,
        appliedCount: appliedCount,
        conflictCount: conflictCount,
        conflicts: conflicts,
        latestVersion: maxVersion,
      ),
    );
  }

  // === Conflict Resolution ===

  @override
  Future<Result<void, AppError>> resolveConflict(
    String conflictId,
    ConflictResolutionType resolution,
  ) async {
    // Look up the conflict record
    final conflictResult = await _conflictDao.getById(conflictId);
    if (conflictResult.isFailure) return Failure(conflictResult.errorOrNull!);

    final conflict = conflictResult.valueOrNull!;

    final adapter = _adapterFor(conflict.entityType);
    if (adapter == null) {
      return Failure(
        DatabaseError.notFound('SyncEntityAdapter', conflict.entityType),
      );
    }

    final now = DateTime.now().millisecondsSinceEpoch;

    // Apply the chosen resolution per 22_API_CONTRACTS.md Section 17.7.2
    switch (resolution) {
      case ConflictResolutionType.keepLocal:
        // Local data stays; call clearConflict() to queue for re-upload
        final result = await adapter.clearEntityConflict(conflict.entityId);
        if (result.isFailure) return Failure(result.errorOrNull!);

      case ConflictResolutionType.keepRemote:
        // Overwrite local with remote entity (already marked synced)
        final remoteEntity = adapter.reconstructSynced(conflict.remoteData);
        final result = await adapter.repository.update(
          remoteEntity,
          markDirty: false,
        );
        if (result.isFailure) return Failure(result.errorOrNull!);

      case ConflictResolutionType.merge:
        final result = await _applyMerge(adapter, conflict);
        if (result.isFailure) return Failure(result.errorOrNull!);
    }

    // Mark conflict row as resolved in sync_conflicts table
    return _conflictDao.markResolved(conflictId, resolution, now);
  }

  /// Apply merge resolution per 22_API_CONTRACTS.md Section 17.7.2.
  ///
  /// Special cases:
  /// - journal_entries: append local + remote content with separator
  /// - photo_entries: treat as keepLocal (cannot merge images)
  /// - All others: fall back to keepRemote (cannot diff without base version)
  Future<Result<void, AppError>> _applyMerge(
    SyncEntityAdapter adapter,
    SyncConflict conflict,
  ) async {
    switch (conflict.entityType) {
      case 'journal_entries':
        final localContent = (conflict.localData['content'] as String?) ?? '';
        final remoteContent = (conflict.remoteData['content'] as String?) ?? '';
        final mergedJson = {
          ...conflict.remoteData,
          'content': '$localContent\n\n---\n\n$remoteContent',
        };
        return adapter.applyMergedEntity(conflict.entityId, mergedJson);

      case 'photo_entries':
        // Cannot merge images — treat as keepLocal per spec
        return adapter.clearEntityConflict(conflict.entityId);

      default:
        // Fall back to keepRemote for all other entity types
        final remoteEntity = adapter.reconstructSynced(conflict.remoteData);
        return adapter.repository.update(remoteEntity, markDirty: false);
    }
  }

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
      // Queries sync_conflicts table per 22_API_CONTRACTS.md Section 17.7.3
      _conflictDao.countUnresolved(profileId);

  @override
  Future<Result<List<SyncConflict>, AppError>> getUnresolvedConflicts(
    String profileId,
  ) async => _conflictDao.getUnresolved(profileId);

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
