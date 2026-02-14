import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/services/encryption_service.dart';
import '../../core/services/device_info_service.dart';
import '../../core/services/logger_service.dart';
import '../../core/config/app_constants.dart';
import '../../domain/cloud/cloud_storage_provider.dart';
import '../../domain/sync/conflict_resolution.dart';
import '../../domain/sync/sync_metadata.dart';
import '../../domain/sync/syncable.dart';
import '../datasources/local/sync_preferences.dart';
import '../cloud/cloud_provider_factory.dart';

/// Result of a sync operation
class SyncResult {
  final bool success;
  final int entitiesSynced;
  final int conflicts;
  final int errors;
  final List<String> errorMessages;
  final DateTime timestamp;

  const SyncResult({
    required this.success,
    required this.entitiesSynced,
    this.conflicts = 0,
    this.errors = 0,
    this.errorMessages = const [],
    required this.timestamp,
  });

  @override
  String toString() {
    return 'SyncResult(success: $success, synced: $entitiesSynced, conflicts: $conflicts, errors: $errors)';
  }
}

/// Status of ongoing sync operation
enum SyncOperationStatus {
  idle,
  authenticating,
  uploadingData,
  downloadingData,
  resolvingConflicts,
  uploadingFiles,
  downloadingFiles,
  completed,
  error,
}

/// Service for orchestrating cloud synchronization
class SyncService {
  final _log = logger.scope('SyncService');
  final EncryptionService _encryptionService;
  final DeviceInfoService _deviceInfoService;
  final SyncPreferences _syncPreferences;
  final ConflictResolver _conflictResolver;
  final Connectivity _connectivity;

  // Callbacks for sync status updates
  final void Function(SyncOperationStatus status, String message)?
      onStatusUpdate;
  final void Function(double progress)? onProgress;

  // Current sync state
  SyncOperationStatus _currentStatus = SyncOperationStatus.idle;
  bool _isSyncing = false;

  // CONCURRENCY: Lock to prevent concurrent sync operations
  Completer<void>? _syncLock;

  // CONCURRENCY: Track entities currently being uploaded to prevent race conditions
  final Set<String> _uploadingEntities = {};

  SyncService({
    required EncryptionService encryptionService,
    required DeviceInfoService deviceInfoService,
    required SyncPreferences syncPreferences,
    ConflictResolver? conflictResolver,
    Connectivity? connectivity,
    this.onStatusUpdate,
    this.onProgress,
  })  : _encryptionService = encryptionService,
        _deviceInfoService = deviceInfoService,
        _syncPreferences = syncPreferences,
        _conflictResolver = conflictResolver ?? ConflictResolver(),
        _connectivity = connectivity ?? Connectivity();

  bool get isSyncing => _isSyncing;
  SyncOperationStatus get currentStatus => _currentStatus;

  /// Get the cloud provider dynamically from CloudProviderFactory
  /// This ensures we always use the latest instance with current OAuth tokens
  Future<CloudStorageProvider> _getCloudProvider() async {
    final providerType = _syncPreferences.getCloudProvider();
    if (providerType == CloudProvider.none) {
      throw Exception('No cloud provider configured');
    }
    final provider = CloudProviderFactory.getProvider(providerType);
    await provider.initialize();
    return provider;
  }

  /// Initialize the sync service
  Future<void> initialize() async {
    // Cloud provider is now retrieved dynamically when needed
    // No initialization needed here
  }

  /// Check if sync is currently possible
  Future<bool> canSync() async {
    _log.debug('canSync() - checking prerequisites...');

    // Check if cloud provider is configured
    final provider = _syncPreferences.getCloudProvider();
    _log.debug('- Cloud provider: $provider');
    if (provider == CloudProvider.none) {
      _log.debug('- FAIL: No cloud provider configured');
      return false;
    }

    // Check authentication
    final cloudProvider = await _getCloudProvider();
    final isAuth = await cloudProvider.isAuthenticated();
    _log.debug('- isAuthenticated(): $isAuth');
    if (!isAuth) {
      _log.debug('- FAIL: Not authenticated');
      return false;
    }

    // Check connectivity
    final hasConn = await _hasConnectivity();
    _log.debug('- hasConnectivity(): $hasConn');
    if (!hasConn) {
      _log.debug('- FAIL: No connectivity');
      return false;
    }

    // Check WiFi-only setting
    if (_syncPreferences.isWifiOnlySyncEnabled()) {
      // connectivity_plus v6.0+ returns List<ConnectivityResult>
      final List<ConnectivityResult> connectivityResults =
          await _connectivity.checkConnectivity();
      _log.debug('- WiFi-only enabled, connectivity: $connectivityResults');

      if (!connectivityResults.contains(ConnectivityResult.wifi)) {
        _log.debug('- FAIL: WiFi-only enabled but not on WiFi');
        return false;
      }
    }

    _log.debug('- SUCCESS: All checks passed');
    return true;
  }

  Future<bool> _hasConnectivity() async {
    // connectivity_plus v6.0+ returns List<ConnectivityResult>
    final List<ConnectivityResult> connectivityResults =
        await _connectivity.checkConnectivity();
    return !connectivityResults.contains(ConnectivityResult.none) &&
        connectivityResults.isNotEmpty;
  }

  /// Perform full synchronization
  ///
  /// TYPE SAFETY: Now uses generics to properly type entities throughout the sync process
  /// CONCURRENCY: Uses async lock to prevent race conditions from concurrent sync calls
  Future<SyncResult> performSync<T extends Syncable>({
    required List<T> localEntities,
    required String entityType,
    required Future<void> Function(List<T> entities) updateLocalEntities,
    required T Function(Map<String, dynamic> json) entityFactory,
    ConflictResolutionStrategy conflictStrategy =
        ConflictResolutionStrategy.lastWriteWins,
  }) async {
    _log.debug(
        'performSync called for entityType=$entityType, count=${localEntities.length}');

    // CONCURRENCY FIX: Wait for any ongoing sync to complete
    while (_syncLock != null) {
      _log.debug('Waiting for ongoing sync to complete...');
      await _syncLock!.future;
    }

    // CONCURRENCY FIX: Acquire lock before checking/setting _isSyncing
    _syncLock = Completer<void>();

    if (_isSyncing) {
      // This should not happen with the lock, but defensive check
      _log.warning(
          'Sync already in progress despite lock - this should not happen');
      _syncLock!.complete();
      _syncLock = null;
      return SyncResult(
        success: false,
        entitiesSynced: 0,
        errorMessages: ['Sync already in progress'],
        timestamp: DateTime.now(),
      );
    }

    _isSyncing = true;
    _updateStatus(
        SyncOperationStatus.authenticating, 'Checking authentication...');

    try {
      // Verify we can sync
      final canSyncResult = await canSync();
      _log.debug('canSync() returned: $canSyncResult');

      if (!canSyncResult) {
        _log.debug('Cannot sync - auth or connectivity issue');
        return SyncResult(
          success: false,
          entitiesSynced: 0,
          errorMessages: ['Cannot sync: check authentication and connectivity'],
          timestamp: DateTime.now(),
        );
      }

      _log.info('Starting sync process...');

      // Get cloud provider dynamically to ensure we have latest OAuth tokens
      final cloudProvider = await _getCloudProvider();

      final deviceId = await _deviceInfoService.getDeviceId();
      final errors = <String>[];
      int syncedCount = 0;
      int conflictCount = 0;

      // Step 1: Download cloud data
      _updateStatus(
          SyncOperationStatus.downloadingData, 'Downloading from cloud...');
      _log.debug('Step 1: Downloading cloud entities for type=$entityType');
      final cloudEntities =
          await _downloadEntities<T>(entityType, entityFactory);
      _log.debug('Step 1: Downloaded ${cloudEntities.length} cloud entities');

      // Step 2: Identify entities to sync
      _log.debug(
          'Step 2: Comparing ${localEntities.length} local entities with ${cloudEntities.length} cloud entities');
      final entitiesToUpload = <T>[];
      final entitiesToUpdate = <T>[];
      final cloudEntitiesById = {for (var e in cloudEntities) e.id: e};

      for (final localEntity in localEntities) {
        final meta = localEntity.syncMetadata;

        // Skip if deleted and already synced
        if (meta.deletedAt != null && meta.syncStatus == SyncStatus.synced) {
          continue;
        }

        // Check if exists in cloud
        final cloudEntity = cloudEntitiesById[localEntity.id];

        if (cloudEntity == null) {
          // New local entity - upload if dirty OR never synced before
          _log.debug(
              'Entity ${localEntity.id}: isDirty=${meta.isDirty}, version=${meta.version}, status=${meta.syncStatus}, needsSync=${meta.needsSync}');
          if (meta.isDirty ||
              meta.version == 0 ||
              meta.syncStatus == SyncStatus.pending) {
            entitiesToUpload.add(localEntity);
            _log.debug('-> Added to upload queue');
          } else {
            _log.debug('-> Skipped (not dirty and not pending)');
          }
        } else {
          // Entity exists in both places - check for conflicts
          if (_conflictResolver.hasConflict(localEntity, cloudEntity)) {
            conflictCount++;
            final resolution = _conflictResolver.resolveConflict(
              localEntity: localEntity,
              cloudEntity: cloudEntity,
              strategy: conflictStrategy,
            );

            if (resolution.requiresManualResolution) {
              errors.add(
                  'Conflict requires manual resolution: ${localEntity.id}');
              // Store conflict data for later resolution
              final updatedMeta = meta.copyWith(
                syncStatus: SyncStatus.conflict,
                conflictData: resolution.conflictDescription,
              );
              entitiesToUpdate.add(
                localEntity.copyWithSyncMetadata(updatedMeta) as T,
              );
            } else {
              // Auto-resolved - use resolved entity
              entitiesToUpload.add(resolution.resolvedEntity);
            }
          } else if (meta.isDirty) {
            // Local changes - upload
            entitiesToUpload.add(localEntity);
          } else if (cloudEntity.syncMetadata.version > meta.version) {
            // Cloud is newer - download
            entitiesToUpdate.add(cloudEntity);
          }
        }
      }

      // Step 3: Download new cloud entities not in local
      _log.debug('Step 3: Checking for new cloud entities to download');
      for (final cloudEntity in cloudEntities) {
        if (!localEntities.any((e) => e.id == cloudEntity.id)) {
          _log.debug(
              'Found new cloud entity ${cloudEntity.id}, adding to update queue');
          entitiesToUpdate.add(cloudEntity);
        }
      }
      _log.debug(
          'Step 3 complete: ${entitiesToUpdate.length} entities queued for local update');

      // Step 4: Upload dirty entities with batch processing
      _log.debug(
          'Step 4: Checking upload queue, size=${entitiesToUpload.length}');
      if (entitiesToUpload.isNotEmpty) {
        _log.info(
            'Starting batch upload of ${entitiesToUpload.length} entities...');
        _updateStatus(
          SyncOperationStatus.uploadingData,
          'Uploading ${entitiesToUpload.length} entities...',
        );

        // Upload in batches for optimal performance and memory usage
        for (var batchStart = 0;
            batchStart < entitiesToUpload.length;
            batchStart += SyncConfiguration.uploadBatchSize) {
          // Check if we're still authenticated (user might have signed out)
          final cloudProvider = await _getCloudProvider();
          if (!await cloudProvider.isAuthenticated()) {
            _log.warning('Authentication lost during sync, aborting...');
            errors.add('Sync aborted: user signed out or authentication lost');
            break;
          }

          final batchEnd = min(batchStart + SyncConfiguration.uploadBatchSize,
              entitiesToUpload.length);
          final batch = entitiesToUpload.sublist(batchStart, batchEnd);

          _log.debug(
              'Processing batch ${batchStart ~/ SyncConfiguration.uploadBatchSize + 1}: entities ${batchStart + 1}-${batchEnd}/${entitiesToUpload.length}');

          // Upload batch concurrently with race condition protection
          final uploadFutures = batch.map((entity) async {
            // CONCURRENCY: Skip if entity is already being uploaded
            if (_uploadingEntities.contains(entity.id)) {
              _log.warning(
                  'Skipping duplicate upload for entity ${entity.id} - already in progress');
              return null;
            }

            // CONCURRENCY: Mark entity as being uploaded
            _uploadingEntities.add(entity.id);
            try {
              _log.debug('Uploading entity: ${entity.id}');
              await _uploadEntity(entity, deviceId);
              _log.debug('✓ Entity ${entity.id} uploaded successfully');

              // Update local entity with synced status
              final updatedMeta = entity.syncMetadata.copyWith(
                lastSyncedAt: DateTime.now(),
                syncStatus: SyncStatus.synced,
                isDirty: false,
                version: entity.syncMetadata.version + 1,
              );
              return entity.copyWithSyncMetadata(updatedMeta);
            } catch (e, stackTrace) {
              _log.error('❌ Failed to upload entity ${entity.id}', e, stackTrace);
              errors.add('Failed to upload entity ${entity.id}: $e');
              return null;
            } finally {
              // CONCURRENCY: Always remove entity from tracking set
              _uploadingEntities.remove(entity.id);
            }
          }).toList();

          final results = await Future.wait(uploadFutures);

          // Add successful uploads to update queue
          for (final result in results) {
            if (result != null) {
              syncedCount++;
              entitiesToUpdate.add(result as T);
            }
          }

          onProgress?.call(batchEnd / entitiesToUpload.length);

          _log.debug(
              'Batch ${batchStart ~/ SyncConfiguration.uploadBatchSize + 1} complete: ${results.where((r) => r != null).length}/${batch.length} succeeded');
        }

        _log.info(
            'Upload complete: ${syncedCount} synced, ${errors.length} errors');
      } else {
        _log.debug('No entities to upload, skipping Step 4');
      }

      // Step 5: Update local database with changes
      _log.debug(
          'Step 5: Updating local database with ${entitiesToUpdate.length} entities');
      if (entitiesToUpdate.isNotEmpty) {
        _log.debug(
            'Calling updateLocalEntities with ${entitiesToUpdate.length} entities');
        await updateLocalEntities(entitiesToUpdate);
        _log.debug('✓ Local database updated successfully');
      } else {
        _log.debug('No entities to update in local database');
      }

      // Step 6: Update sync timestamp
      await _syncPreferences.setLastSyncTimestamp(DateTime.now());
      if (errors.isEmpty) {
        await _syncPreferences.setLastFullSyncTimestamp(DateTime.now());
      }

      _updateStatus(SyncOperationStatus.completed, 'Sync completed');

      return SyncResult(
        success: errors.isEmpty,
        entitiesSynced: syncedCount,
        conflicts: conflictCount,
        errors: errors.length,
        errorMessages: errors,
        timestamp: DateTime.now(),
      );
    } catch (e, stackTrace) {
      _log.error('Sync failed', e, stackTrace);
      _updateStatus(SyncOperationStatus.error, 'Sync failed: $e');
      await _syncPreferences.addSyncError(e.toString());

      return SyncResult(
        success: false,
        entitiesSynced: 0,
        errorMessages: [e.toString()],
        timestamp: DateTime.now(),
      );
    } finally {
      _isSyncing = false;

      // CONCURRENCY FIX: Always release lock, even if sync failed
      final lock = _syncLock;
      _syncLock = null;
      lock?.complete();
    }
  }

  /// Upload a single entity to cloud
  Future<void> _uploadEntity(Syncable entity, String deviceId) async {
    final cloudProvider = await _getCloudProvider();
    final remotePath = _getEntityPath(entity.entityType, entity.id);

    // Convert to JSON
    final jsonData = entity.toCloudJson();

    // Encrypt the data
    final encryptedData = _encryptionService.encryptJson(jsonData);

    // Wrap in envelope with metadata
    final envelope = {
      'entityType': entity.entityType,
      'entityId': entity.id,
      'version': entity.syncMetadata.version,
      'deviceId': deviceId,
      'updatedAt': entity.syncMetadata.updatedAt.millisecondsSinceEpoch,
      'encryptedData': encryptedData,
    };

    // Upload to cloud
    await cloudProvider.uploadJson(
      remotePath: remotePath,
      data: envelope,
    );
  }

  /// Download entities from cloud
  Future<List<T>> _downloadEntities<T extends Syncable>(
    String entityType,
    T Function(Map<String, dynamic> json) entityFactory,
  ) async {
    try {
      final cloudProvider = await _getCloudProvider();
      final folderPath = 'shadow_app/data/$entityType';
      final cloudFiles = await cloudProvider.listFiles(folderPath);

      final entities = <T>[];
      final errors = <String>[];

      for (final file in cloudFiles) {
        if (file.isFolder) continue;

        try {
          final envelope = await cloudProvider.downloadJson(file.path);
          final encryptedData = envelope['encryptedData'] as String;

          // Decrypt the data
          final jsonData = _encryptionService.decryptJson(encryptedData);

          // Convert back to entity using the provided factory
          final entity = entityFactory(jsonData);
          entities.add(entity);
        } catch (e, stackTrace) {
          // Log error but continue processing other files
          _log.error('Failed to download/decrypt file ${file.path}', e, stackTrace);
          errors.add('Failed to download entity from ${file.path}: $e');
          continue;
        }
      }

      if (errors.isNotEmpty) {
        _log.warning('Download completed with ${errors.length} errors');
      }

      return entities;
    } catch (e, stackTrace) {
      // Folder doesn't exist or other error - return empty list
      _log.error('Failed to list files for $entityType', e, stackTrace);
      return [];
    }
  }

  /// Sync files (photos, attachments) for an entity with batch concurrent upload
  Future<void> syncFiles(
    SyncableWithFiles entity,
    String deviceId,
  ) async {
    _updateStatus(SyncOperationStatus.uploadingFiles, 'Syncing files...');
    final cloudProvider = await _getCloudProvider();

    final photoStrategy = _syncPreferences.getPhotoStorageStrategy();

    // Identify files needing upload
    final filesToUpload = <int>[];
    for (var i = 0; i < entity.fileSyncMetadata.length; i++) {
      final fileMeta = entity.fileSyncMetadata[i];
      if (fileMeta.localFilePath != null && !fileMeta.isFileUploaded) {
        final localFile = File(fileMeta.localFilePath!);
        if (await localFile.exists()) {
          filesToUpload.add(i);
        }
      }
    }

    // Upload in batches for optimal performance with larger file payloads
    final updatedMetadata =
        List<FileSyncMetadata>.from(entity.fileSyncMetadata);
    int uploadedCount = 0;

    for (var batchStart = 0;
        batchStart < filesToUpload.length;
        batchStart += SyncConfiguration.fileBatchSize) {
      final batchEnd = min(
          batchStart + SyncConfiguration.fileBatchSize, filesToUpload.length);
      final batch = filesToUpload.sublist(batchStart, batchEnd);

      // Upload batch concurrently
      final uploadFutures = batch.map((fileIndex) async {
        final fileMeta = entity.fileSyncMetadata[fileIndex];
        try {
          final remotePath = _getFilePath(
            entity.entityType,
            entity.id,
            fileMeta.localFilePath!,
          );

          await cloudProvider.uploadFile(
            localPath: fileMeta.localFilePath!,
            remotePath: remotePath,
          );

          // Compute hash
          final fileBytes = await File(fileMeta.localFilePath!).readAsBytes();
          final hash = _encryptionService.hashBytes(fileBytes);

          // Update metadata
          updatedMetadata[fileIndex] = fileMeta.copyWith(
            cloudStorageUrl: remotePath,
            fileHash: hash,
            fileSizeBytes: fileBytes.length,
            isFileUploaded: true,
          );
          return true;
        } catch (e, stackTrace) {
          _log.error(
              'Failed to upload file $fileIndex for entity ${entity.id}', e, stackTrace);
          return false;
        }
      });

      final results = await Future.wait(uploadFutures);
      uploadedCount += results.where((success) => success).length;
    }

    // Handle cloud-only strategy deletions
    for (var i = 0; i < updatedMetadata.length; i++) {
      final fileMeta = updatedMetadata[i];
      if (photoStrategy == PhotoStorageStrategy.cloudOnly &&
          fileMeta.isFileUploaded &&
          fileMeta.localFilePath != null) {
        try {
          final localFile = File(fileMeta.localFilePath!);
          if (await localFile.exists()) {
            await localFile.delete();
          }
        } catch (e, stackTrace) {
          // Deletion failed - log but don't fail the operation
          _log.warning('Failed to delete local file after cloud upload', e, stackTrace);
        }
      }
    }

    _log.info(
        'Uploaded $uploadedCount/${filesToUpload.length} files for entity ${entity.id}');
  }

  /// Download a file from cloud storage
  Future<String> downloadFile(String cloudUrl, String localPath) async {
    final cloudProvider = await _getCloudProvider();
    return await cloudProvider.downloadFile(
      remotePath: cloudUrl,
      localPath: localPath,
    );
  }

  /// Sign in to cloud provider
  Future<void> signIn() async {
    _updateStatus(SyncOperationStatus.authenticating, 'Signing in...');

    // Get cloud provider dynamically
    final cloudProvider = await _getCloudProvider();
    await cloudProvider.signIn();

    // Store user identifier
    final userId = await cloudProvider.getCurrentUserIdentifier();
    if (userId != null) {
      await _syncPreferences.setCloudUserIdentifier(userId);
    }
  }

  /// Sign out from cloud provider
  Future<void> signOut() async {
    final currentProvider = _syncPreferences.getCloudProvider();
    if (currentProvider != CloudProvider.none) {
      final provider = CloudProviderFactory.getProvider(currentProvider);
      await provider.signOut();
    }
    await _syncPreferences.clearAllSyncSettings();
    CloudProviderFactory.reset();
  }

  /// Get path for entity in cloud storage
  String _getEntityPath(String entityType, String entityId) {
    return 'shadow_app/data/$entityType/$entityId.json';
  }

  /// Get path for file in cloud storage
  String _getFilePath(String entityType, String entityId, String localPath) {
    final fileName = localPath.split('/').last;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'shadow_app/files/$entityType/$entityId/${timestamp}_$fileName';
  }

  void _updateStatus(SyncOperationStatus status, String message) {
    _currentStatus = status;
    onStatusUpdate?.call(status, message);
  }
}
