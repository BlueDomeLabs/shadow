// lib/domain/entities/condition_log.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.9

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

part 'condition_log.freezed.dart';
part 'condition_log.g.dart';

/// A log entry for a health condition.
///
/// Records severity, notes, photos, triggers, and flare status for a condition
/// at a specific point in time.
@Freezed(toJson: true, fromJson: true)
class ConditionLog with _$ConditionLog {
  const ConditionLog._();

  @JsonSerializable(explicitToJson: true)
  const factory ConditionLog({
    required String id,
    required String clientId,
    required String profileId,
    required String conditionId,
    required int timestamp, // Epoch milliseconds
    required int severity, // 1-10 scale
    String? notes,
    @Default(false) bool isFlare,
    @Default([]) List<String> flarePhotoIds, // Comma-separated in DB
    String? photoPath,
    String? activityId,
    String? triggers, // Comma-separated
    // File sync metadata
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    @Default(false) bool isFileUploaded,
    required SyncMetadata syncMetadata,
  }) = _ConditionLog;

  factory ConditionLog.fromJson(Map<String, dynamic> json) =>
      _$ConditionLogFromJson(json);

  /// Whether the log has a photo
  bool get hasPhoto => photoPath != null;

  /// Get triggers as a list
  List<String> get triggerList =>
      triggers
          ?.split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList() ??
      [];
}
