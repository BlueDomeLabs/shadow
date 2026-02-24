// lib/domain/entities/fasting_session.dart
// Phase 15b — Intermittent fasting session
// Per 59_DIET_TRACKING.md

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'fasting_session.freezed.dart';
part 'fasting_session.g.dart';

/// A single intermittent fasting session.
///
/// Per 59_DIET_TRACKING.md — records when the user started and ended
/// a fast, along with the protocol used and target duration.
@Freezed(toJson: true, fromJson: true)
class FastingSession with _$FastingSession implements Syncable {
  const FastingSession._();

  @JsonSerializable(explicitToJson: true)
  const factory FastingSession({
    required String id,
    required String clientId,
    required String profileId,
    required DietPresetType protocol, // if168, if186, if204, omad, etc.
    required int startedAt, // Epoch ms — when fast began
    int? endedAt, // Epoch ms — null if fast is still active
    required double targetHours, // e.g. 16.0 for 16:8
    @Default(false) bool isManualEnd, // true if user stopped early
    required SyncMetadata syncMetadata,
  }) = _FastingSession;

  factory FastingSession.fromJson(Map<String, dynamic> json) =>
      _$FastingSessionFromJson(json);

  /// Whether this fasting session is still in progress.
  bool get isActive => endedAt == null;

  /// Actual hours fasted (null if still active).
  double? get actualHours =>
      endedAt == null ? null : (endedAt! - startedAt) / 3600000;
}
