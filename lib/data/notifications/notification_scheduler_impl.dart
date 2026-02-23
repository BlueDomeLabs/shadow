// lib/data/notifications/notification_scheduler_impl.dart
// Per 57_NOTIFICATION_SYSTEM.md — platform implementation of NotificationScheduler

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/scheduled_notification.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';
import 'package:shadow_app/domain/repositories/notification_scheduler.dart';
import 'package:timezone/timezone.dart' as tz;

/// Maps [NotificationCategory] to the Android notification channel ID.
String _channelId(NotificationCategory category) => switch (category) {
  NotificationCategory.supplements => 'supplements',
  NotificationCategory.foodMeals => 'meals',
  NotificationCategory.fluids => 'water',
  _ => 'health',
};

/// Android importance level per [NotificationCategory].
Importance _importance(NotificationCategory category) => switch (category) {
  NotificationCategory.supplements => Importance.high,
  NotificationCategory.fluids => Importance.low,
  _ => Importance.defaultImportance,
};

/// Android notification channel definitions per 57_NOTIFICATION_SYSTEM.md §11.2.
const _androidChannels = [
  AndroidNotificationChannel(
    'supplements',
    'Supplements',
    description: 'Supplement intake reminders',
    importance: Importance.high,
  ),
  AndroidNotificationChannel(
    'meals',
    'Food & Meals',
    description: 'Meal logging reminders',
  ),
  AndroidNotificationChannel(
    'water',
    'Fluids',
    description: 'Hydration tracking reminders',
    importance: Importance.low,
    playSound: false,
  ),
  AndroidNotificationChannel(
    'health',
    'Health Tracking',
    description: 'General health tracking reminders',
  ),
  AndroidNotificationChannel(
    'sleep',
    'Sleep',
    description: 'Sleep tracking reminders',
    importance: Importance.high,
  ),
];

/// Platform implementation of [NotificationScheduler] using
/// `flutter_local_notifications`.
///
/// Call [createAndroidChannels] once after initializing the plugin to register
/// Android notification channels. Inject [plugin] for testing.
class NotificationSchedulerImpl implements NotificationScheduler {
  final FlutterLocalNotificationsPlugin _plugin;

  NotificationSchedulerImpl(this._plugin);

  /// Creates all Android notification channels.
  ///
  /// No-op on non-Android platforms. Safe to call on every startup.
  static Future<void> createAndroidChannels(
    FlutterLocalNotificationsPlugin plugin,
  ) async {
    final android = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return;
    for (final channel in _androidChannels) {
      await android.createNotificationChannel(channel);
    }
  }

  @override
  Future<Result<void, AppError>> scheduleAll(
    List<ScheduledNotification> notifications,
  ) async {
    try {
      await _plugin.cancelAll();
      for (final n in notifications) {
        final channelId = _channelId(n.category);
        await _plugin.zonedSchedule(
          _notifId(n.id),
          n.title,
          n.body,
          _nextOccurrence(n.timeOfDay),
          NotificationDetails(
            android: AndroidNotificationDetails(
              channelId,
              channelId,
              importance: _importance(n.category),
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
            macOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: n.payload,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
      return const Success(null);
    } on Exception catch (e, st) {
      return Failure(NotificationError.scheduleFailed('scheduleAll', e, st));
    }
  }

  @override
  Future<Result<void, AppError>> cancelAll() async {
    try {
      await _plugin.cancelAll();
      return const Success(null);
    } on Exception catch (e, st) {
      return Failure(NotificationError.cancelFailed('all', e, st));
    }
  }

  /// Converts a deterministic string ID into a stable non-negative integer.
  static int _notifId(String id) => id.hashCode & 0x7FFFFFFF;

  /// Returns the next [TZDateTime] matching [timeOfDay] (HH:mm).
  ///
  /// If the time has already passed today, returns tomorrow's occurrence.
  static tz.TZDateTime _nextOccurrence(String timeOfDay) {
    final parts = timeOfDay.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
