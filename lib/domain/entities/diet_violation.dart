// lib/domain/entities/diet_violation.dart
// Phase 15b — Diet rule violation event
// Per 59_DIET_TRACKING.md

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

part 'diet_violation.freezed.dart';
part 'diet_violation.g.dart';

/// A diet rule violation event.
///
/// Per 59_DIET_TRACKING.md — recorded whenever a compliance check
/// fires. If the user chose "Add Anyway", wasOverridden=true and
/// foodLogId references the saved food log. If the user chose
/// "Cancel", wasOverridden=false and foodLogId is null.
@Freezed(toJson: true, fromJson: true)
class DietViolation with _$DietViolation implements Syncable {
  const DietViolation._();

  @JsonSerializable(explicitToJson: true)
  const factory DietViolation({
    required String id,
    required String clientId,
    required String profileId,
    required String dietId,
    required String ruleId,
    String? foodLogId, // null if user cancelled (wasOverridden=false)
    required String foodName, // Human-readable name of the food
    required String ruleDescription, // Plain-English rule that was violated
    @Default(false) bool wasOverridden, // true = "Add Anyway", false = "Cancel"
    required int timestamp, // Epoch ms
    required SyncMetadata syncMetadata,
  }) = _DietViolation;

  factory DietViolation.fromJson(Map<String, dynamic> json) =>
      _$DietViolationFromJson(json);
}
