// lib/domain/entities/sync_metadata.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 3.1

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_metadata.freezed.dart';
part 'sync_metadata.g.dart';

/// SyncMetadata handles cloud synchronization state for all entities.
///
/// DATABASE MAPPING: Field names use camelCase in Dart but map to snake_case
/// columns in the database via @JsonKey annotations. The JSON key names
/// match the database column names exactly.
@freezed
class SyncMetadata with _$SyncMetadata {
  const SyncMetadata._();

  const factory SyncMetadata({
    // Dart field: syncCreatedAt → DB column: sync_created_at
    @JsonKey(name: 'sync_created_at')
    required int syncCreatedAt, // Epoch milliseconds
    // Dart field: syncUpdatedAt → DB column: sync_updated_at
    @JsonKey(name: 'sync_updated_at')
    required int syncUpdatedAt, // Epoch milliseconds
    // Dart field: syncDeletedAt → DB column: sync_deleted_at
    @JsonKey(name: 'sync_deleted_at') int? syncDeletedAt, // Null = not deleted
    // Dart field: syncLastSyncedAt → DB column: sync_last_synced_at
    @JsonKey(name: 'sync_last_synced_at')
    int? syncLastSyncedAt, // Last cloud sync
    // Dart field: syncStatus → DB column: sync_status
    @JsonKey(name: 'sync_status')
    @Default(SyncStatus.pending)
    SyncStatus syncStatus,
    // Dart field: syncVersion → DB column: sync_version
    @JsonKey(name: 'sync_version')
    @Default(1)
    int syncVersion, // Optimistic concurrency
    // Dart field: syncDeviceId → DB column: sync_device_id
    @JsonKey(name: 'sync_device_id')
    required String syncDeviceId, // Last modifying device
    // Dart field: syncIsDirty → DB column: sync_is_dirty
    @JsonKey(name: 'sync_is_dirty')
    @Default(true)
    bool syncIsDirty, // Unsynchronized changes
    // Dart field: conflictData → DB column: conflict_data
    @JsonKey(name: 'conflict_data')
    String? conflictData, // JSON of conflicting record
  }) = _SyncMetadata;

  factory SyncMetadata.fromJson(Map<String, dynamic> json) =>
      _$SyncMetadataFromJson(json);

  /// Create new sync metadata for a fresh entity
  factory SyncMetadata.create({required String deviceId}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return SyncMetadata(
      syncCreatedAt: now,
      syncUpdatedAt: now,
      syncDeviceId: deviceId,
    );
  }

  /// Create empty sync metadata (for entity construction before persisting)
  /// IMPORTANT: Must call create() with deviceId before saving to database
  factory SyncMetadata.empty() =>
      const SyncMetadata(syncCreatedAt: 0, syncUpdatedAt: 0, syncDeviceId: '');

  /// Mark as modified (updates timestamp, dirty flag, AND increments version)
  /// IMPORTANT: syncVersion is incremented to detect conflicts during sync
  SyncMetadata markModified(String deviceId) => copyWith(
    syncUpdatedAt: DateTime.now().millisecondsSinceEpoch,
    syncDeviceId: deviceId,
    syncIsDirty: true,
    syncStatus: SyncStatus.modified,
    syncVersion: syncVersion + 1, // REQUIRED: Increment for conflict detection
  );

  /// Mark as synced (clears dirty flag, updates last synced time, does NOT increment version)
  /// Called after successful cloud sync - version stays same since no local change
  SyncMetadata markSynced() => copyWith(
    syncIsDirty: false,
    syncStatus: SyncStatus.synced,
    syncLastSyncedAt: DateTime.now().millisecondsSinceEpoch,
    // NOTE: syncVersion NOT incremented - no local change occurred
  );

  /// Mark as soft deleted (updates timestamp, dirty flag, AND increments version)
  /// IMPORTANT: Delete is a local change, so version must increment
  SyncMetadata markDeleted(String deviceId) => copyWith(
    syncDeletedAt: DateTime.now().millisecondsSinceEpoch,
    syncUpdatedAt: DateTime.now().millisecondsSinceEpoch,
    syncDeviceId: deviceId,
    syncIsDirty: true,
    syncStatus: SyncStatus.deleted,
    syncVersion: syncVersion + 1, // REQUIRED: Delete is a local change
  );

  /// Mark as conflicted when a remote version cannot be auto-merged.
  ///
  /// Sets syncStatus=conflict, syncIsDirty=true, conflictData=[remoteJson].
  /// Per 22_API_CONTRACTS.md: syncVersion is NOT incremented — the local
  /// data has not changed, only its conflict state has been flagged.
  SyncMetadata markConflict(String remoteJson) => copyWith(
    syncStatus: SyncStatus.conflict,
    syncIsDirty: true,
    conflictData: remoteJson,
    // NOTE: syncVersion NOT incremented — no local data change occurred
  );

  /// Clear a conflict after resolution and queue the record for re-upload.
  ///
  /// Sets syncStatus=pending, syncIsDirty=true, syncVersion+1, conflictData=null.
  /// Per 22_API_CONTRACTS.md: version IS incremented because resolution
  /// constitutes a local change that must win the next sync.
  SyncMetadata clearConflict() => copyWith(
    syncStatus: SyncStatus.pending,
    syncIsDirty: true,
    syncVersion: syncVersion + 1, // REQUIRED: resolution is a local change
    conflictData: null,
  );

  bool get isDeleted => syncDeletedAt != null;

  /// Check if this metadata was created with empty() and needs initialization
  bool get needsInitialization => syncDeviceId.isEmpty;
}

/// Interface for entities that support cloud synchronization.
/// ALL syncable entities MUST implement this interface.
///
/// Per 02_CODING_STANDARDS.md, all syncable entities have id, clientId,
/// profileId, syncMetadata, and toJson(). These are formalized here
/// so SyncService can operate generically across all entity types.
abstract interface class Syncable {
  String get id;
  String get clientId;
  String get profileId;
  SyncMetadata get syncMetadata;
  Map<String, dynamic> toJson();
}

enum SyncStatus {
  pending(0), // Never synced
  synced(1), // Successfully synced
  modified(2), // Modified since last sync
  conflict(3), // Conflict detected, needs resolution
  deleted(4); // Marked for deletion

  final int value;
  const SyncStatus(this.value);

  static SyncStatus fromValue(int value) => SyncStatus.values.firstWhere(
    (e) => e.value == value,
    orElse: () => pending,
  );
}
