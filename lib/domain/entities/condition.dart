// lib/domain/entities/condition.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.8

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'condition.freezed.dart';
part 'condition.g.dart';

/// A health condition being tracked by the user.
///
/// Conditions can be skin conditions, chronic issues, symptoms, etc.
/// They can have baseline photos and be linked to activities.
@Freezed(toJson: true, fromJson: true)
class Condition with _$Condition implements Syncable {
  const Condition._();

  @JsonSerializable(explicitToJson: true)
  const factory Condition({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    required String category,
    required List<String> bodyLocations, // JSON array in DB
    @Default([])
    List<String> triggers, // Predefined trigger list for condition logs
    String? description,
    String? baselinePhotoPath,
    required int startTimeframe, // Epoch milliseconds
    int? endDate, // Epoch milliseconds
    @Default(ConditionStatus.active) ConditionStatus status,
    @Default(false) bool isArchived,
    String? activityId, // FK to activities
    // File sync metadata
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    @Default(false) bool isFileUploaded,
    required SyncMetadata syncMetadata,
  }) = _Condition;

  factory Condition.fromJson(Map<String, dynamic> json) =>
      _$ConditionFromJson(json);

  /// Whether the condition has a baseline photo
  bool get hasBaselinePhoto => baselinePhotoPath != null;

  /// Whether the condition is resolved
  bool get isResolved => status == ConditionStatus.resolved;

  /// Whether the condition is currently active (not archived, not resolved)
  bool get isActive =>
      !isArchived &&
      status == ConditionStatus.active &&
      syncMetadata.syncDeletedAt == null;
}
