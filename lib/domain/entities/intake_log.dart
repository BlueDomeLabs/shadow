// lib/domain/entities/intake_log.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.10

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'intake_log.freezed.dart';
part 'intake_log.g.dart';

/// An intake log entry tracking when a supplement was taken.
///
/// Records scheduled vs actual intake times, status (taken/skipped/missed),
/// and optional reason/notes.
@Freezed(toJson: true, fromJson: true)
class IntakeLog with _$IntakeLog implements Syncable {
  const IntakeLog._();

  @JsonSerializable(explicitToJson: true)
  const factory IntakeLog({
    required String id,
    required String clientId,
    required String profileId,
    required String supplementId,
    required int scheduledTime, // Epoch milliseconds
    int? actualTime, // Epoch milliseconds
    @Default(IntakeLogStatus.pending) IntakeLogStatus status,
    String? reason, // Why skipped/missed
    String? note,
    int?
    snoozeDurationMinutes, // Duration in minutes when snoozed (5/10/15/30/60)
    required SyncMetadata syncMetadata,
  }) = _IntakeLog;

  factory IntakeLog.fromJson(Map<String, dynamic> json) =>
      _$IntakeLogFromJson(json);

  /// Whether the intake was taken
  bool get isTaken => status == IntakeLogStatus.taken;

  /// Whether the intake is still pending
  bool get isPending => status == IntakeLogStatus.pending;

  /// Whether the intake was skipped
  bool get isSkipped => status == IntakeLogStatus.skipped;

  /// Whether the intake was missed
  bool get isMissed => status == IntakeLogStatus.missed;

  /// Whether the intake was snoozed
  bool get isSnoozed => status == IntakeLogStatus.snoozed;

  /// Calculate delay from scheduled time (if actually taken)
  Duration? get delayFromScheduled {
    if (actualTime == null) return null;
    return Duration(milliseconds: actualTime! - scheduledTime);
  }
}
