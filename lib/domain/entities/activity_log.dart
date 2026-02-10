// lib/domain/entities/activity_log.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.14

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

part 'activity_log.freezed.dart';
part 'activity_log.g.dart';

/// ActivityLog entity for tracking when activities were performed.
///
/// Per 22_API_CONTRACTS.md Section 10.14.
/// Supports both predefined activities (by ID) and ad-hoc activities.
@Freezed(toJson: true, fromJson: true)
class ActivityLog with _$ActivityLog implements Syncable {
  const ActivityLog._();

  @JsonSerializable(explicitToJson: true)
  const factory ActivityLog({
    required String id,
    required String clientId,
    required String profileId,
    required int timestamp, // Epoch milliseconds
    @Default([]) List<String> activityIds, // References to Activity entities
    @Default([]) List<String> adHocActivities, // Free-form activity names
    int? duration, // Actual duration if different from planned
    String? notes,
    // Import tracking (for wearable data - HealthKit/Google Fit)
    String? importSource, // 'healthkit', 'googlefit', etc.
    String? importExternalId, // External record ID for deduplication
    required SyncMetadata syncMetadata,
  }) = _ActivityLog;

  factory ActivityLog.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogFromJson(json);

  /// Whether this log has any activities (predefined or ad-hoc).
  bool get hasActivities =>
      activityIds.isNotEmpty || adHocActivities.isNotEmpty;

  /// Whether this log was imported from a wearable device.
  bool get isImported => importSource != null;
}
