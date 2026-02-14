import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import '../../domain/cloud/cloud_storage_provider.dart';

/// iCloud implementation of cloud storage provider for iOS and macOS
class ICloudStorageProvider implements CloudStorageProvider {
  static const MethodChannel _channel = MethodChannel('com.shadow.app/icloud');

  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final result = await _channel.invokeMethod<bool>('initialize');
      _isInitialized = result == true;

      if (!_isInitialized) {
        throw CloudStorageException('Failed to initialize iCloud');
      }
    } on PlatformException catch (e, stackTrace) {
      throw CloudStorageException('iCloud initialization failed (stackTrace: $stackTrace)', e);
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final result = await _channel.invokeMethod<bool>('isAuthenticated');
      return result ?? false;
    } on PlatformException catch (e, stackTrace) {
      throw CloudStorageException('Failed to check iCloud authentication (stackTrace: $stackTrace)', e);
    }
  }

  @override
  Future<void> signIn() async {
    // iCloud doesn't require separate sign-in - it uses system account
    // Just check if iCloud is available
    if (!await isAuthenticated()) {
      throw CloudStorageException(
        'iCloud is not available. Please sign in to iCloud in System Settings.',
      );
    }
  }

  @override
  Future<void> signOut() async {
    // iCloud doesn't support programmatic sign-out
    // User must sign out from System Settings
    throw CloudStorageException(
      'Cannot sign out of iCloud programmatically. Please use System Settings.',
    );
  }

  @override
  Future<String?> getCurrentUserIdentifier() async {
    try {
      final result =
          await _channel.invokeMethod<String>('getCurrentUserIdentifier');
      return result;
    } on PlatformException catch (e, stackTrace) {
      throw CloudStorageException('Failed to get iCloud user identifier (stackTrace: $stackTrace)', e);
    }
  }

  @override
  Future<String> uploadFile({
    required String localPath,
    required String remotePath,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final result = await _channel.invokeMethod<String>('uploadFile', {
        'localPath': localPath,
        'remotePath': remotePath,
      });

      if (result == null) {
        throw CloudStorageException('Upload failed: no result returned');
      }

      return result;
    } on PlatformException catch (e, stackTrace) {
      throw CloudStorageException('Failed to upload file to iCloud (stackTrace: $stackTrace)', e);
    }
  }

  @override
  Future<String> downloadFile({
    required String remotePath,
    required String localPath,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final result = await _channel.invokeMethod<String>('downloadFile', {
        'remotePath': remotePath,
        'localPath': localPath,
      });

      if (result == null) {
        throw CloudStorageException('Download failed: no result returned');
      }

      return result;
    } on PlatformException catch (e, stackTrace) {
      throw CloudStorageException('Failed to download file from iCloud (stackTrace: $stackTrace)', e);
    }
  }

  @override
  Future<void> deleteFile(String remotePath) async {
    try {
      await _channel.invokeMethod('deleteFile', {'remotePath': remotePath});
    } on PlatformException catch (e, stackTrace) {
      throw CloudStorageException('Failed to delete file from iCloud (stackTrace: $stackTrace)', e);
    }
  }

  @override
  Future<bool> fileExists(String remotePath) async {
    try {
      final result = await _channel.invokeMethod<bool>('fileExists', {
        'remotePath': remotePath,
      });
      return result ?? false;
    } on PlatformException catch (e, stackTrace) {
      throw CloudStorageException(
          'Failed to check if file exists in iCloud (stackTrace: $stackTrace)', e);
    }
  }

  @override
  Future<List<CloudFile>> listFiles(String folderPath) async {
    try {
      final result = await _channel.invokeMethod<List>('listFiles', {
        'folderPath': folderPath,
      });

      if (result == null) return [];

      return result.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return CloudFile(
          name: map['name'] as String,
          path: map['path'] as String,
          sizeBytes: map['sizeBytes'] as int?,
          modifiedTime: map['modifiedTime'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['modifiedTime'] as int)
              : null,
          isFolder: map['isFolder'] as bool? ?? false,
        );
      }).toList();
    } on PlatformException catch (e, stackTrace) {
      throw CloudStorageException('Failed to list files in iCloud (stackTrace: $stackTrace)', e);
    }
  }

  @override
  Future<String> uploadJson({
    required String remotePath,
    required Map<String, dynamic> data,
  }) async {
    try {
      final jsonString = jsonEncode(data);
      final bytes = utf8.encode(jsonString);

      return await uploadBytes(
        bytes: Uint8List.fromList(bytes),
        remotePath: remotePath,
        mimeType: 'application/json',
      );
    } catch (e, stackTrace) {
      throw CloudStorageException('Failed to upload JSON to iCloud (stackTrace: $stackTrace)', e);
    }
  }

  @override
  Future<Map<String, dynamic>> downloadJson(String remotePath) async {
    try {
      final bytes = await downloadBytes(remotePath);
      final jsonString = utf8.decode(bytes);
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e, stackTrace) {
      throw CloudStorageException('Failed to download JSON from iCloud (stackTrace: $stackTrace)', e);
    }
  }

  @override
  Future<void> deleteJson(String remotePath) async {
    await deleteFile(remotePath);
  }

  @override
  Future<int?> getAvailableSpace() async {
    try {
      final result = await _channel.invokeMethod<int>('getAvailableSpace');
      return result;
    } on PlatformException catch (e, stackTrace) {
      throw CloudStorageException('Failed to get available iCloud space (stackTrace: $stackTrace)', e);
    }
  }

  @override
  Future<String> uploadBytes({
    required Uint8List bytes,
    required String remotePath,
    String? mimeType,
  }) async {
    try {
      final result = await _channel.invokeMethod<String>('uploadBytes', {
        'bytes': bytes,
        'remotePath': remotePath,
        'mimeType': mimeType,
      });

      if (result == null) {
        throw CloudStorageException('Upload bytes failed: no result returned');
      }

      return result;
    } on PlatformException catch (e, stackTrace) {
      throw CloudStorageException('Failed to upload bytes to iCloud (stackTrace: $stackTrace)', e);
    }
  }

  @override
  Future<Uint8List> downloadBytes(String remotePath) async {
    try {
      final result = await _channel.invokeMethod('downloadBytes', {
        'remotePath': remotePath,
      });

      if (result == null) {
        throw CloudStorageException(
            'Download bytes failed: no result returned');
      }

      return result as Uint8List;
    } on PlatformException catch (e, stackTrace) {
      throw CloudStorageException('Failed to download bytes from iCloud (stackTrace: $stackTrace)', e);
    }
  }
}
