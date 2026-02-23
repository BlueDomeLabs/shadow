// lib/domain/usecases/notifications/cancel_notifications_use_case.dart
// Per 57_NOTIFICATION_SYSTEM.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/repositories/notification_scheduler.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';

/// Cancels all currently scheduled notifications.
///
/// Called when the user disables all notifications globally or signs out.
class CancelNotificationsUseCase implements UseCaseNoInput<void> {
  final NotificationScheduler _scheduler;

  CancelNotificationsUseCase(this._scheduler);

  @override
  Future<Result<void, AppError>> call() => _scheduler.cancelAll();
}
