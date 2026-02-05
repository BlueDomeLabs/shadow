// lib/domain/entities/activity.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.13

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

/// Activity entity for reusable activity definitions.
///
/// Per 22_API_CONTRACTS.md Section 10.13.
/// Activities can be archived (seasonal/paused) and reactivated later.
@Freezed(toJson: true, fromJson: true)
class Activity with _$Activity {
  const Activity._();

  @JsonSerializable(explicitToJson: true)
  const factory Activity({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    String? description,
    String? location,
    String? triggers, // Comma-separated trigger descriptions
    required int durationMinutes,
    @Default(false) bool isArchived,
    required SyncMetadata syncMetadata,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  /// Whether this activity is currently active (not archived).
  bool get isActive => !isArchived;
}
