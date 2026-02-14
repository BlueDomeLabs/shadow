import 'dart:typed_data';

/// Abstract interface for cloud storage providers (Google Drive, iCloud, etc.)
abstract class CloudStorageProvider {
  /// Initialize the provider
  Future<void> initialize();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Sign in to cloud provider
  Future<void> signIn();

  /// Sign out from cloud provider
  Future<void> signOut();

  /// Get current user's email/identifier
  Future<String?> getCurrentUserIdentifier();

  /// Upload a file to cloud storage
  /// Returns the cloud URL/path of the uploaded file
  Future<String> uploadFile({
    required String localPath,
    required String remotePath,
    void Function(double progress)? onProgress,
  });

  /// Download a file from cloud storage
  /// Returns the local path where file was saved
  Future<String> downloadFile({
    required String remotePath,
    required String localPath,
    void Function(double progress)? onProgress,
  });

  /// Delete a file from cloud storage
  Future<void> deleteFile(String remotePath);

  /// Check if a file exists in cloud storage
  Future<bool> fileExists(String remotePath);

  /// List files in a folder
  Future<List<CloudFile>> listFiles(String folderPath);

  /// Upload JSON data to cloud storage
  /// Returns the cloud URL/path
  Future<String> uploadJson({
    required String remotePath,
    required Map<String, dynamic> data,
  });

  /// Download JSON data from cloud storage
  Future<Map<String, dynamic>> downloadJson(String remotePath);

  /// Delete JSON data from cloud storage
  Future<void> deleteJson(String remotePath);

  /// Get available storage space (in bytes, null if unlimited/unknown)
  Future<int?> getAvailableSpace();

  /// Upload bytes directly
  Future<String> uploadBytes({
    required Uint8List bytes,
    required String remotePath,
    String? mimeType,
  });

  /// Download bytes directly
  Future<Uint8List> downloadBytes(String remotePath);
}

/// Represents a file in cloud storage
class CloudFile {
  final String name;
  final String path;
  final int? sizeBytes;
  final DateTime? modifiedTime;
  final bool isFolder;

  const CloudFile({
    required this.name,
    required this.path,
    this.sizeBytes,
    this.modifiedTime,
    this.isFolder = false,
  });

  @override
  String toString() =>
      'CloudFile(name: $name, path: $path, size: $sizeBytes, modified: $modifiedTime)';
}

/// Exception thrown when cloud storage operations fail
class CloudStorageException implements Exception {
  final String message;
  final dynamic originalError;

  CloudStorageException(this.message, [this.originalError]);

  @override
  String toString() =>
      'CloudStorageException: $message${originalError != null ? ' ($originalError)' : ''}';
}
