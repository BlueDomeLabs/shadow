// lib/domain/entities/anchor_event_time.dart
// Per 57_NOTIFICATION_SYSTEM.md — AnchorEventTime entity

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';

part 'anchor_event_time.freezed.dart';
part 'anchor_event_time.g.dart';

/// A named daily anchor event with a user-configurable clock time.
///
/// The 8 anchor events (Wake, Breakfast, Morning, Lunch, Afternoon,
/// Dinner, Evening, Bedtime) are pre-populated at first run with spec
/// defaults. Users can adjust times and enable/disable individual events.
///
/// See 57_NOTIFICATION_SYSTEM.md for anchor event scheduling behaviour.
@Freezed(toJson: true, fromJson: true)
class AnchorEventTime with _$AnchorEventTime {
  const AnchorEventTime._();

  @JsonSerializable(explicitToJson: true)
  const factory AnchorEventTime({
    required String id,
    required AnchorEventName
    name, // wake / breakfast / lunch / dinner / bedtime
    required String timeOfDay, // "HH:mm" 24-hour format, e.g. "07:00"
    @Default(true) bool isEnabled,
  }) = _AnchorEventTime;

  factory AnchorEventTime.fromJson(Map<String, dynamic> json) =>
      _$AnchorEventTimeFromJson(json);

  /// Human-readable display name for this anchor event.
  String get displayName => name.displayName;
}
