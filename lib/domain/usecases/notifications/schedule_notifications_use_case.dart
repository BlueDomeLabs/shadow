// lib/domain/usecases/notifications/schedule_notifications_use_case.dart
// Per 57_NOTIFICATION_SYSTEM.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/repositories/anchor_event_time_repository.dart';
import 'package:shadow_app/domain/repositories/notification_category_settings_repository.dart';
import 'package:shadow_app/domain/repositories/notification_scheduler.dart';
import 'package:shadow_app/domain/services/notification_schedule_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';

/// Reads current anchor events and category settings, computes the full
/// notification schedule, and hands it to the platform scheduler.
///
/// Should be called whenever any notification setting changes, and once
/// on app startup after the user grants notification permission.
class ScheduleNotificationsUseCase implements UseCaseNoInput<void> {
  final AnchorEventTimeRepository _anchorRepository;
  final NotificationCategorySettingsRepository _settingsRepository;
  final NotificationScheduleService _scheduleService;
  final NotificationScheduler _scheduler;

  ScheduleNotificationsUseCase({
    required AnchorEventTimeRepository anchorRepository,
    required NotificationCategorySettingsRepository settingsRepository,
    required NotificationScheduleService scheduleService,
    required NotificationScheduler scheduler,
  }) : _anchorRepository = anchorRepository,
       _settingsRepository = settingsRepository,
       _scheduleService = scheduleService,
       _scheduler = scheduler;

  @override
  Future<Result<void, AppError>> call() async {
    final anchorsResult = await _anchorRepository.getAll();
    if (anchorsResult.isFailure) return Failure(anchorsResult.errorOrNull!);

    final settingsResult = await _settingsRepository.getAll();
    if (settingsResult.isFailure) return Failure(settingsResult.errorOrNull!);

    final schedule = _scheduleService.computeSchedule(
      anchorEvents: anchorsResult.valueOrNull!,
      settings: settingsResult.valueOrNull!,
    );

    return _scheduler.scheduleAll(schedule);
  }
}
