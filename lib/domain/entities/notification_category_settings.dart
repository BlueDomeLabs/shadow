// lib/domain/entities/notification_category_settings.dart
// Per 57_NOTIFICATION_SYSTEM.md — NotificationCategorySettings entity

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';

part 'notification_category_settings.freezed.dart';
part 'notification_category_settings.g.dart';

/// Per-category notification configuration.
///
/// One row exists per [NotificationCategory]. Stores:
/// - Whether the category is enabled
/// - Which scheduling mode is active (anchorEvents / interval / specificTimes)
/// - Mode-specific configuration (anchor event assignments, interval, times)
/// - How long after scheduled time a notification expires
///
/// See 57_NOTIFICATION_SYSTEM.md for full scheduling behaviour.
@Freezed(toJson: true, fromJson: true)
class NotificationCategorySettings with _$NotificationCategorySettings {
  const NotificationCategorySettings._();

  @JsonSerializable(explicitToJson: true)
  const factory NotificationCategorySettings({
    required String id,
    required NotificationCategory category,
    @Default(false) bool isEnabled,
    required NotificationSchedulingMode schedulingMode,

    // Mode 1 — Anchor Events
    // JSON array of AnchorEventName.value ints, e.g. [1, 2, 3] for Breakfast/Lunch/Dinner
    @Default([]) List<int> anchorEventValues,

    // Mode 2A — Interval
    // Interval in whole hours: 1, 2, 3, 4, 6, 8, or 12
    int? intervalHours,
    // Active window times as "HH:mm" 24-hour strings, e.g. "08:00"
    String? intervalStartTime,
    String? intervalEndTime,

    // Mode 2B — Specific Times
    // "HH:mm" 24-hour strings, up to 12 per category
    @Default([]) List<String> specificTimes,

    // How long (minutes) after scheduled time the notification expires
    @Default(60) int expiresAfterMinutes,
  }) = _NotificationCategorySettings;

  factory NotificationCategorySettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationCategorySettingsFromJson(json);

  /// The anchor events assigned to this category (Mode 1).
  List<AnchorEventName> get anchorEvents =>
      anchorEventValues.map(AnchorEventName.fromValue).toList();
}
