// lib/data/datasources/remote/cloud_storage_provider.dart
// Abstract interface for cloud storage operations.
// Implements 22_API_CONTRACTS.md cloud sync contracts.

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';

/// Type of cloud storage provider.
enum CloudProviderType {
  googleDrive(0),
  icloud(1),
  offline(2);

  final int value;
  const CloudProviderType(this.value);

  static CloudProviderType fromValue(int value) => CloudProviderType.values
      .firstWhere((e) => e.value == value, orElse: () => offline);
}

/// Represents a change from the cloud that needs to be applied locally.
class SyncChange {
  /// The entity type string (e.g. 'supplements', 'intake_logs').
  final String entityType;

  /// The entity's unique identifier.
  final String entityId;

  /// The profile this entity belongs to.
  final String profileId;

  /// The client/device that last modified this entity.
  final String clientId;

  /// The serialized entity data as JSON.
  final Map<String, dynamic> data;

  /// The sync version of this change.
  final int version;

  /// Epoch milliseconds when this change was made.
  final int timestamp;

  /// Whether this change represents a deletion.
  final bool isDeleted;

  const SyncChange({
    required this.entityType,
    required this.entityId,
    required this.profileId,
    required this.clientId,
    required this.data,
    required this.version,
    required this.timestamp,
    this.isDeleted = false,
  });
}

/// Abstract interface for cloud storage providers.
///
/// Implementations must handle authentication, file upload/download,
/// and change tracking for cloud synchronization.
abstract class CloudStorageProvider {
  /// The type of this cloud provider.
  CloudProviderType get providerType;

  /// Authenticate with the cloud provider.
  ///
  /// Returns [AuthError.signInFailed] on failure.
  Future<Result<void, AppError>> authenticate();

  /// Sign out from the cloud provider.
  ///
  /// Returns [AuthError.signOutFailed] on failure.
  Future<Result<void, AppError>> signOut();

  /// Check if currently authenticated with the provider.
  Future<bool> isAuthenticated();

  /// Check if the provider is available on this platform.
  Future<bool> isAvailable();

  /// Upload an entity to cloud storage.
  ///
  /// The [json] data will be encrypted before upload.
  /// [version] is used for conflict detection.
  Future<Result<void, AppError>> uploadEntity(
    String entityType,
    String entityId,
    String profileId,
    String clientId,
    Map<String, dynamic> json,
    int version,
  );

  /// Download an entity from cloud storage.
  ///
  /// Returns null if the entity does not exist in the cloud.
  Future<Result<Map<String, dynamic>?, AppError>> downloadEntity(
    String entityType,
    String entityId,
  );

  /// Get all changes since [sinceTimestamp] (epoch milliseconds).
  ///
  /// Returns a list of [SyncChange] objects representing remote modifications.
  Future<Result<List<SyncChange>, AppError>> getChangesSince(
    int sinceTimestamp,
  );

  /// Delete an entity from cloud storage.
  Future<Result<void, AppError>> deleteEntity(
    String entityType,
    String entityId,
  );

  /// Upload a file (e.g. photo) to cloud storage.
  Future<Result<void, AppError>> uploadFile(
    String localPath,
    String remotePath,
  );

  /// Download a file from cloud storage.
  ///
  /// Returns the local path where the file was saved.
  Future<Result<String, AppError>> downloadFile(
    String remotePath,
    String localPath,
  );
}
