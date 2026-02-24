// lib/domain/entities/health_sync_status.dart
// Phase 16 — Per-data-type sync status (local only)
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'health_sync_status.freezed.dart';
part 'health_sync_status.g.dart';

/// Tracks the last sync result for one data type on this device.
///
/// One record per (profileId, dataType) pair. Local only — not synced to
/// Google Drive. Used to implement incremental sync (only fetch records newer
/// than lastSyncedAt on subsequent syncs).
///
/// See 61_HEALTH_PLATFORM_INTEGRATION.md Incremental Sync section.
@freezed
class HealthSyncStatus with _$HealthSyncStatus {
  const HealthSyncStatus._();

  const factory HealthSyncStatus({
    /// Composite key: "${profileId}_${dataType.value}"
    required String id,
    required String profileId,
    required HealthDataType dataType,

    /// When this data type was last successfully synced (epoch ms UTC).
    /// Null if never synced.
    int? lastSyncedAt,

    /// Number of records imported in the last sync.
    @Default(0) int recordCount,

    /// Error message from the last failed sync, if any.
    String? lastError,
  }) = _HealthSyncStatus;

  factory HealthSyncStatus.fromJson(Map<String, dynamic> json) =>
      _$HealthSyncStatusFromJson(json);

  /// Creates a status ID from profileId and dataType.
  static String makeId(String profileId, HealthDataType dataType) =>
      '${profileId}_${dataType.value}';
}
