// lib/data/cloud/icloud_provider.dart
// iCloud implementation of CloudStorageProvider.
//
// Authentication is OS-managed — no explicit sign-in required from the app.
//
// Folder structure mirrors GoogleDriveProvider:
//   shadow_app/data/{entityType}/{entityId}.json   (entity envelopes)
//   shadow_app/files/{remotePath}                  (binary files)
//
// NOTE: iOS/macOS entitlements required for iCloud to work on device:
//   - iCloud capability enabled in Xcode
//   - iCloud Documents entitlement
//   - Container ID: iCloud.com.bluedomecolorado.shadowApp
//   These are manual Xcode steps NOT included in this session.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:icloud_storage/icloud_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/remote/cloud_storage_provider.dart';

/// Thin wrapper around the static [ICloudStorage] API to allow injection
/// and mocking in unit tests.
class ICloudStorageWrapper {
  Future<List<ICloudFile>> gather({required String containerId}) =>
      ICloudStorage.gather(containerId: containerId);

  Future<void> upload({
    required String containerId,
    required String filePath,
    required String destinationRelativePath,
    void Function(Stream<double>)? onProgress,
  }) => ICloudStorage.upload(
    containerId: containerId,
    filePath: filePath,
    destinationRelativePath: destinationRelativePath,
    onProgress: onProgress,
  );

  Future<void> download({
    required String containerId,
    required String relativePath,
    required String destinationFilePath,
    void Function(Stream<double>)? onProgress,
  }) => ICloudStorage.download(
    containerId: containerId,
    relativePath: relativePath,
    destinationFilePath: destinationFilePath,
    onProgress: onProgress,
  );

  Future<void> delete({
    required String containerId,
    required String relativePath,
  }) => ICloudStorage.delete(
    containerId: containerId,
    relativePath: relativePath,
  );
}

/// iCloud implementation of [CloudStorageProvider].
///
/// Uses [icloud_storage] plugin for file operations via iCloud Drive.
/// Authentication is OS-managed — no explicit sign-in required.
///
/// ICloudProvider does NOT encrypt data. Envelopes arrive pre-encrypted
/// from SyncServiceImpl, identical contract to GoogleDriveProvider.
///
/// icloud_storage 2.x has no change query API, but [gather()] returns
/// [ICloudFile] objects that include [ICloudFile.contentChangeDate].
/// [getChangesSince] uses this metadata to filter and download only
/// changed envelopes.
class ICloudProvider implements CloudStorageProvider {
  /// iCloud container ID — must match the entitlement in Xcode.
  static const String _containerId = 'iCloud.com.bluedomecolorado.shadowApp';

  /// Override for [isAvailable] platform check in unit tests.
  ///
  /// Set to `true` to simulate Apple platform; `false` to simulate non-Apple.
  /// Reset to `null` after each test.
  @visibleForTesting
  static bool? testIsApplePlatform;

  /// Override for the temp directory used by upload/download helpers.
  ///
  /// Set to a writable directory path in unit tests to avoid calling
  /// [getTemporaryDirectory()] which requires a platform plugin.
  /// Reset to `null` after each test.
  @visibleForTesting
  static String? testTempDirectory;

  static const String _dataFolder = 'shadow_app/data';
  static const String _filesFolder = 'shadow_app/files';

  final ICloudStorageWrapper _storage;
  final ScopedLogger _log;

  ICloudProvider({ICloudStorageWrapper? storage})
    : _storage = storage ?? ICloudStorageWrapper(),
      _log = logger.scope('ICloudProvider');

  @override
  CloudProviderType get providerType => CloudProviderType.icloud;

  // ==========================================================================
  // Authentication — iCloud auth is OS-managed
  // ==========================================================================

  /// Returns false immediately on non-Apple platforms.
  ///
  /// On iOS/macOS, probes the iCloud container via [gather()].
  /// A [PlatformException] with code [PlatformExceptionCode.iCloudConnectionOrPermission]
  /// indicates the user is not signed in to iCloud or has not granted permission.
  @override
  Future<bool> isAvailable() async {
    final isApple = testIsApplePlatform ?? (Platform.isIOS || Platform.isMacOS);
    if (!isApple) return false;
    try {
      // icloud_storage 2.x has no isICloudAvailable() API.
      // Probe the container: E_CTR = not signed in / no permission.
      await _storage.gather(containerId: _containerId);
      return true;
    } on PlatformException catch (e) {
      _log.debug('iCloud not available: ${e.code} — ${e.message}');
      return false;
    } on Exception catch (e) {
      _log.debug('iCloud availability check failed: $e');
      return false;
    }
  }

  /// iCloud authentication is OS-managed — delegates to [isAvailable].
  @override
  Future<bool> isAuthenticated() async => isAvailable();

  /// Returns [Success] if iCloud is available; [AuthError.signInFailed] otherwise.
  @override
  Future<Result<void, AppError>> authenticate() async {
    if (await isAvailable()) return const Success(null);
    return Failure(AuthError.signInFailed('iCloud not available'));
  }

  /// No-op — iCloud sign-out is OS-level, not app-level.
  @override
  Future<Result<void, AppError>> signOut() async => const Success(null);

  // ==========================================================================
  // Entity Operations
  // ==========================================================================

  @override
  Future<Result<void, AppError>> uploadEntity(
    String entityType,
    String entityId,
    String profileId,
    String clientId,
    Map<String, dynamic> json,
    int version,
  ) async {
    File? tempFile;
    try {
      tempFile = await _writeTempJson(json, entityId);
      final remotePath = '$_dataFolder/$entityType/$entityId.json';
      await _storage.upload(
        containerId: _containerId,
        filePath: tempFile.path,
        destinationRelativePath: remotePath,
      );
      _log.info('Uploaded entity: $entityType/$entityId (v$version)');
      return const Success(null);
    } on Exception catch (e, stack) {
      _log.error('Failed to upload entity: $entityType/$entityId', e, stack);
      return Failure(SyncError.uploadFailed(entityType, entityId, e, stack));
    } finally {
      await _deleteTempFile(tempFile);
    }
  }

  @override
  Future<Result<Map<String, dynamic>?, AppError>> downloadEntity(
    String entityType,
    String entityId,
  ) async {
    File? tempFile;
    try {
      final remotePath = '$_dataFolder/$entityType/$entityId.json';
      final tempDirPath =
          testTempDirectory ?? (await getTemporaryDirectory()).path;
      final tempPath = '$tempDirPath/icloud_dl_$entityId.json';
      tempFile = File(tempPath);

      await _downloadAndWait(remotePath, tempPath);

      if (!await tempFile.exists()) {
        // Download initiated but file not materialised — treat as not found
        return const Success(null);
      }

      final content = await tempFile.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      return Success(json);
    } on PlatformException catch (e, stack) {
      if (e.code == PlatformExceptionCode.fileNotFound) {
        return const Success(null); // Entity doesn't exist in cloud
      }
      _log.error('Failed to download entity: $entityType/$entityId', e, stack);
      return Failure(SyncError.downloadFailed(entityType, e, stack));
    } on Exception catch (e, stack) {
      _log.error('Failed to download entity: $entityType/$entityId', e, stack);
      return Failure(SyncError.downloadFailed(entityType, e, stack));
    } finally {
      await _deleteTempFile(tempFile);
    }
  }

  /// List all changed files using [gather()] and download changed envelopes.
  ///
  /// icloud_storage 2.x does not have a server-side change query API.
  /// Instead, we use [ICloudFile.contentChangeDate] from [gather()] to filter
  /// files modified after [sinceTimestamp], then download and parse each one.
  ///
  /// This is a full-list approach and may be slow for large datasets.
  /// A manifest-file approach (Phase 31c) would be more efficient.
  @override
  Future<Result<List<SyncChange>, AppError>> getChangesSince(
    int sinceTimestamp,
  ) async {
    try {
      final allFiles = await _storage.gather(containerId: _containerId);
      final changes = <SyncChange>[];

      for (final file in allFiles) {
        // Only process data envelopes under shadow_app/data/
        if (!file.relativePath.startsWith('$_dataFolder/')) continue;
        if (!file.relativePath.endsWith('.json')) continue;

        final fileMs = file.contentChangeDate.millisecondsSinceEpoch;
        if (fileMs <= sinceTimestamp) continue;

        // Parse: shadow_app/data/{entityType}/{entityId}.json
        final segments = file.relativePath.split('/');
        if (segments.length < 4) continue;
        final entityType = segments[2];
        final entityId = segments[3].replaceFirst('.json', '');

        final downloadResult = await downloadEntity(entityType, entityId);
        if (downloadResult.isFailure) continue;

        final envelope = downloadResult.valueOrNull;
        if (envelope == null || envelope['encryptedData'] == null) continue;

        changes.add(
          SyncChange(
            entityType: entityType,
            entityId: envelope['entityId'] as String? ?? entityId,
            profileId: envelope['profileId'] as String? ?? '',
            clientId: envelope['clientId'] as String? ?? '',
            data: envelope,
            version: envelope['version'] as int? ?? 0,
            timestamp: envelope['timestamp'] as int? ?? 0,
            isDeleted: envelope['isDeleted'] as bool? ?? false,
          ),
        );
      }

      _log.info('Found ${changes.length} changes since $sinceTimestamp');
      return Success(changes);
    } on Exception catch (e, stack) {
      _log.error('Failed to get changes since $sinceTimestamp', e, stack);
      return Failure(SyncError.downloadFailed('changes', e, stack));
    }
  }

  @override
  Future<Result<void, AppError>> deleteEntity(
    String entityType,
    String entityId,
  ) async {
    try {
      final remotePath = '$_dataFolder/$entityType/$entityId.json';
      await _storage.delete(
        containerId: _containerId,
        relativePath: remotePath,
      );
      _log.info('Deleted entity: $entityType/$entityId');
      return const Success(null);
    } on PlatformException catch (e, stack) {
      if (e.code == PlatformExceptionCode.fileNotFound) {
        // Already gone — treat as success
        return const Success(null);
      }
      _log.error('Failed to delete entity: $entityType/$entityId', e, stack);
      return Failure(SyncError.uploadFailed(entityType, entityId, e, stack));
    } on Exception catch (e, stack) {
      _log.error('Failed to delete entity: $entityType/$entityId', e, stack);
      return Failure(SyncError.uploadFailed(entityType, entityId, e, stack));
    }
  }

  // ==========================================================================
  // File Operations
  // ==========================================================================

  @override
  Future<Result<void, AppError>> uploadFile(
    String localPath,
    String remotePath,
  ) async {
    try {
      final fullRemotePath = '$_filesFolder/$remotePath';
      await _storage.upload(
        containerId: _containerId,
        filePath: localPath,
        destinationRelativePath: fullRemotePath,
      );
      _log.info('Uploaded file: $remotePath');
      return const Success(null);
    } on Exception catch (e, stack) {
      _log.error('Failed to upload file: $remotePath', e, stack);
      return Failure(SyncError.uploadFailed('file', remotePath, e, stack));
    }
  }

  @override
  Future<Result<String, AppError>> downloadFile(
    String remotePath,
    String localPath,
  ) async {
    try {
      final fullRemotePath = '$_filesFolder/$remotePath';
      await _downloadAndWait(fullRemotePath, localPath);
      _log.info('Downloaded file: $remotePath');
      return Success(localPath);
    } on PlatformException catch (e, stack) {
      if (e.code == PlatformExceptionCode.fileNotFound) {
        return Failure(
          SyncError.downloadFailed(
            'file',
            Exception('File not found: $remotePath'),
            stack,
          ),
        );
      }
      _log.error('Failed to download file: $remotePath', e, stack);
      return Failure(SyncError.downloadFailed('file', e, stack));
    } on Exception catch (e, stack) {
      _log.error('Failed to download file: $remotePath', e, stack);
      return Failure(SyncError.downloadFailed('file', e, stack));
    }
  }

  // ==========================================================================
  // Private Helpers
  // ==========================================================================

  /// Write a JSON map to a temp file and return the [File].
  Future<File> _writeTempJson(Map<String, dynamic> json, String name) async {
    final tempPath = testTempDirectory ?? (await getTemporaryDirectory()).path;
    final file = File('$tempPath/icloud_ul_$name.json');
    await file.writeAsString(jsonEncode(json));
    return file;
  }

  /// Delete a temp file, ignoring errors.
  Future<void> _deleteTempFile(File? file) async {
    if (file == null) return;
    try {
      if (await file.exists()) await file.delete();
    } on Exception catch (e) {
      _log.debug('Failed to delete temp file: $e');
    }
  }

  /// Initiate a download and wait for it to complete via [onProgress].
  ///
  /// icloud_storage's [download()] future completes when the download is
  /// *initiated*, not when it finishes. We use a [Completer] with the
  /// [onProgress] stream's [onDone] callback to detect actual completion.
  Future<void> _downloadAndWait(String remotePath, String destPath) async {
    final completer = Completer<void>();
    await _storage.download(
      containerId: _containerId,
      relativePath: remotePath,
      destinationFilePath: destPath,
      onProgress: (stream) {
        stream.listen(
          (_) {},
          onDone: () {
            if (!completer.isCompleted) completer.complete();
          },
          onError: (Object e) {
            if (!completer.isCompleted) completer.completeError(e);
          },
          cancelOnError: true,
        );
      },
    );
    await completer.future;
  }
}
