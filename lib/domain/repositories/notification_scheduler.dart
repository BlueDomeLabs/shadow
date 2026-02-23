// lib/domain/repositories/notification_scheduler.dart
// Per 57_NOTIFICATION_SYSTEM.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/scheduled_notification.dart';

/// Abstract port for the platform notification scheduler.
///
/// Implemented in Phase 13c by [NotificationSchedulerImpl] using
/// `flutter_local_notifications`. The domain layer depends only on
/// this interface, keeping scheduling logic fully testable without
/// platform dependencies.
abstract interface class NotificationScheduler {
  /// Replaces all currently scheduled notifications with [notifications].
  ///
  /// Implementations MUST cancel all existing notifications before
  /// scheduling the new set so that stale entries are not left behind
  /// after a settings change.
  Future<Result<void, AppError>> scheduleAll(
    List<ScheduledNotification> notifications,
  );

  /// Cancels all scheduled notifications.
  ///
  /// Called when the user globally disables notifications or signs out.
  Future<Result<void, AppError>> cancelAll();
}
