// lib/domain/services/notification_schedule_service.dart
// Per 57_NOTIFICATION_SYSTEM.md

import 'dart:convert';

import 'package:shadow_app/domain/entities/anchor_event_time.dart';
import 'package:shadow_app/domain/entities/notification_category_settings.dart';
import 'package:shadow_app/domain/entities/scheduled_notification.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';

/// Computes the complete set of notifications to schedule from current settings.
///
/// Pure domain logic — no platform dependencies, fully unit-testable.
/// Called by [ScheduleNotificationsUseCase] whenever settings change.
class NotificationScheduleService {
  /// Builds the full notification schedule from [anchorEvents] and [settings].
  ///
  /// Only categories with [NotificationCategorySettings.isEnabled] == true
  /// produce notifications. For Mode 1 (anchor events), disabled anchor
  /// events are silently skipped.
  List<ScheduledNotification> computeSchedule({
    required List<AnchorEventTime> anchorEvents,
    required List<NotificationCategorySettings> settings,
  }) {
    // Build a fast lookup: AnchorEventName → AnchorEventTime
    final anchorMap = {for (final e in anchorEvents) e.name: e};

    final result = <ScheduledNotification>[];
    for (final setting in settings) {
      if (!setting.isEnabled) continue;

      switch (setting.schedulingMode) {
        case NotificationSchedulingMode.anchorEvents:
          result.addAll(_buildAnchorNotifications(setting, anchorMap));
        case NotificationSchedulingMode.interval:
          result.addAll(_buildIntervalNotifications(setting));
        case NotificationSchedulingMode.specificTimes:
          result.addAll(_buildSpecificTimeNotifications(setting));
      }
    }
    return result;
  }

  /// Computes all notification times within [startTime]..[endTime] at [intervalHours].
  ///
  /// Both [startTime] and [endTime] are included when they fall exactly on
  /// an interval boundary. Returns times as "HH:mm" strings.
  List<String> computeIntervalTimes(
    String startTime,
    String endTime,
    int intervalHours,
  ) {
    final start = _parseMinutes(startTime);
    final end = _parseMinutes(endTime);
    final step = intervalHours * 60;

    if (step <= 0 || start > end) return [];

    final times = <String>[];
    for (var t = start; t <= end; t += step) {
      times.add(_formatMinutes(t));
    }
    return times;
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  List<ScheduledNotification> _buildAnchorNotifications(
    NotificationCategorySettings setting,
    Map<AnchorEventName, AnchorEventTime> anchorMap,
  ) {
    final notifications = <ScheduledNotification>[];
    for (final anchorValue in setting.anchorEventValues) {
      final name = AnchorEventName.fromValue(anchorValue);
      final anchor = anchorMap[name];
      // Skip if the anchor event record is missing or disabled
      if (anchor == null || !anchor.isEnabled) continue;

      notifications.add(
        _buildNotification(
          setting: setting,
          timeOfDay: anchor.timeOfDay,
          anchorEventName: name,
        ),
      );
    }
    return notifications;
  }

  List<ScheduledNotification> _buildIntervalNotifications(
    NotificationCategorySettings setting,
  ) {
    final startTime = setting.intervalStartTime;
    final endTime = setting.intervalEndTime;
    final hours = setting.intervalHours;
    if (startTime == null || endTime == null || hours == null) return [];

    return computeIntervalTimes(
      startTime,
      endTime,
      hours,
    ).map((t) => _buildNotification(setting: setting, timeOfDay: t)).toList();
  }

  List<ScheduledNotification> _buildSpecificTimeNotifications(
    NotificationCategorySettings setting,
  ) => setting.specificTimes
      .map((t) => _buildNotification(setting: setting, timeOfDay: t))
      .toList();

  ScheduledNotification _buildNotification({
    required NotificationCategorySettings setting,
    required String timeOfDay,
    AnchorEventName? anchorEventName,
  }) {
    final timeKey = timeOfDay.replaceAll(':', '');
    final id = 'shadow_notif_${setting.category.value}_$timeKey';

    return ScheduledNotification(
      id: id,
      category: setting.category,
      timeOfDay: timeOfDay,
      title: setting.category.displayName,
      body: _bodyText(setting.category, anchorEventName),
      payload: _buildPayload(setting.category, anchorEventName),
      expiresAfterMinutes: setting.expiresAfterMinutes,
    );
  }

  String _buildPayload(
    NotificationCategory category,
    AnchorEventName? anchorEventName,
  ) {
    final map = <String, dynamic>{'category': category.value};
    if (anchorEventName != null) {
      map['anchorEvent'] = anchorEventName.value;
    }
    return jsonEncode(map);
  }

  /// Returns the notification body text per 57_NOTIFICATION_SYSTEM.md.
  String _bodyText(
    NotificationCategory category,
    AnchorEventName? anchorEventName,
  ) => switch (category) {
    NotificationCategory.supplements => 'Time to take your supplements.',
    NotificationCategory.foodMeals =>
      anchorEventName != null
          ? 'What did you have for ${anchorEventName.displayName}?'
          : 'Time to log your meal.',
    NotificationCategory.fluids =>
      'Time to log your fluids. What have you had?',
    NotificationCategory.photos => 'Time for your photo check-in.',
    NotificationCategory.journalEntries =>
      'How was your day? Add a journal entry.',
    NotificationCategory.activities =>
      'Did you do any physical activity today?',
    NotificationCategory.conditionCheckIns =>
      'How are your conditions today? Time for your check-in.',
    NotificationCategory.bbtVitals =>
      'Good morning. Time to log your BBT and vitals.',
  };

  int _parseMinutes(String hhmm) {
    final parts = hhmm.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  String _formatMinutes(int totalMinutes) {
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }
}
