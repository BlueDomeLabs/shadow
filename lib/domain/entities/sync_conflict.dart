// lib/domain/entities/sync_conflict.dart
// Implements 22_API_CONTRACTS.md Section 17.1

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_conflict.freezed.dart';
part 'sync_conflict.g.dart';

/// Represents a sync conflict between local and remote versions of an entity.
///
/// Created during applyChanges when a remote change arrives for an entity
/// that has unsynchronized local modifications (syncIsDirty == true).
@Freezed(toJson: true, fromJson: true)
class SyncConflict with _$SyncConflict {
  const SyncConflict._();

  const factory SyncConflict({
    required String id, // Unique conflict identifier (UUID v4)
    required String entityType, // Table name (e.g. 'supplements')
    required String entityId, // The conflicting entity's ID
    required String profileId,
    required int localVersion, // Local syncVersion at time of conflict
    required int remoteVersion, // Remote syncVersion at time of conflict
    required Map<String, dynamic> localData, // Full local entity JSON
    required Map<String, dynamic> remoteData, // Full remote entity JSON
    required int detectedAt, // Epoch ms when conflict was detected
    @Default(false) bool isResolved,
    ConflictResolutionType?
    resolution, // How it was resolved (null if unresolved)
    int? resolvedAt, // Epoch ms when resolved
  }) = _SyncConflict;

  factory SyncConflict.fromJson(Map<String, dynamic> json) =>
      _$SyncConflictFromJson(json);
}

/// How a sync conflict was resolved.
/// Explicit integer values per 02_CODING_STANDARDS.md Rule 9.1.1.
enum ConflictResolutionType {
  keepLocal(0), // Use local version, overwrite remote
  keepRemote(1), // Use remote version, overwrite local
  merge(2); // Merge both versions (for compatible changes)

  final int value;
  const ConflictResolutionType(this.value);

  static ConflictResolutionType fromValue(int value) => ConflictResolutionType
      .values
      .firstWhere((e) => e.value == value, orElse: () => keepLocal);
}
