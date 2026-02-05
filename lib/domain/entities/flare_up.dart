// lib/domain/entities/flare_up.dart
// FlareUp entity per 22_API_CONTRACTS.md Section 10.19

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

part 'flare_up.freezed.dart';
part 'flare_up.g.dart';

/// FlareUp entity for acute condition episodes.
///
/// Per 22_API_CONTRACTS.md Section 10.19:
/// - startDate/endDate: Epoch milliseconds (endDate null = ongoing)
/// - severity: 1-10 scale
/// - triggers: List of trigger descriptions
@Freezed(toJson: true, fromJson: true)
class FlareUp with _$FlareUp {
  const FlareUp._();

  @JsonSerializable(explicitToJson: true)
  const factory FlareUp({
    required String id,
    required String clientId,
    required String profileId,
    required String conditionId,
    required int startDate, // Epoch milliseconds - flare-up start
    int? endDate, // Epoch milliseconds - flare-up end (null = ongoing)
    required int severity, // 1-10 scale
    String? notes,
    required List<String> triggers, // Trigger descriptions
    String? activityId, // Activity that may have triggered flare-up
    String? photoPath,
    required SyncMetadata syncMetadata,
  }) = _FlareUp;

  factory FlareUp.fromJson(Map<String, dynamic> json) =>
      _$FlareUpFromJson(json);

  /// Duration in milliseconds, null if ongoing
  int? get durationMs => endDate != null ? endDate! - startDate : null;

  /// Whether the flare-up is currently active
  bool get isOngoing => endDate == null;
}
