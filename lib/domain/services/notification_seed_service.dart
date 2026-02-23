// lib/domain/services/notification_seed_service.dart
// Seeds default anchor event times and notification category settings on first run.
// Per 57_NOTIFICATION_SYSTEM.md defaults.

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/anchor_event_time.dart';
import 'package:shadow_app/domain/entities/notification_category_settings.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';
import 'package:shadow_app/domain/repositories/anchor_event_time_repository.dart';
import 'package:shadow_app/domain/repositories/notification_category_settings_repository.dart';
import 'package:uuid/uuid.dart';

/// Seeds default notification data when the database is first created or upgraded to v12.
///
/// Inserts the 5 anchor events and 8 category settings with spec-recommended defaults.
/// Safe to call multiple times — skips rows that already exist.
class NotificationSeedService {
  final AnchorEventTimeRepository _anchorRepository;
  final NotificationCategorySettingsRepository _settingsRepository;
  static const _uuid = Uuid();

  NotificationSeedService({
    required AnchorEventTimeRepository anchorRepository,
    required NotificationCategorySettingsRepository settingsRepository,
  }) : _anchorRepository = anchorRepository,
       _settingsRepository = settingsRepository;

  /// Seeds all defaults. Skips individual rows that already exist.
  Future<Result<void, AppError>> seedDefaults() async {
    final anchorResult = await _seedAnchorEvents();
    if (anchorResult.isFailure) return anchorResult;

    return _seedCategorySettings();
  }

  /// Seeds the 5 anchor events with spec defaults if not already present.
  Future<Result<void, AppError>> _seedAnchorEvents() async {
    final allResult = await _anchorRepository.getAll();
    if (allResult.isFailure) return allResult;

    final existing = allResult.valueOrNull!;
    final existingNames = existing.map((e) => e.name).toSet();

    for (final name in AnchorEventName.values) {
      if (existingNames.contains(name)) continue;

      final event = AnchorEventTime(
        id: _uuid.v4(),
        name: name,
        timeOfDay: name.defaultTime,
      );
      final insertResult = await _anchorRepository.create(event);
      if (insertResult.isFailure) return insertResult;
    }

    return const Success(null);
  }

  /// Seeds the 8 category settings with spec-recommended defaults if not already present.
  Future<Result<void, AppError>> _seedCategorySettings() async {
    final allResult = await _settingsRepository.getAll();
    if (allResult.isFailure) return allResult;

    final existing = allResult.valueOrNull!;
    final existingCategories = existing.map((e) => e.category).toSet();

    for (final settings in _defaultSettings()) {
      if (existingCategories.contains(settings.category)) continue;

      final insertResult = await _settingsRepository.create(settings);
      if (insertResult.isFailure) return insertResult;
    }

    return const Success(null);
  }

  /// Returns the 8 default category settings per 57_NOTIFICATION_SYSTEM.md.
  List<NotificationCategorySettings> _defaultSettings() => [
    // Supplements — Mode 1, Breakfast + Dinner anchor events
    NotificationCategorySettings(
      id: _uuid.v4(),
      category: NotificationCategory.supplements,
      schedulingMode: NotificationSchedulingMode.anchorEvents,
      anchorEventValues: [
        AnchorEventName.breakfast.value,
        AnchorEventName.dinner.value,
      ],
    ),

    // Food/Meals — Mode 1, Breakfast + Lunch + Dinner
    NotificationCategorySettings(
      id: _uuid.v4(),
      category: NotificationCategory.foodMeals,
      schedulingMode: NotificationSchedulingMode.anchorEvents,
      anchorEventValues: [
        AnchorEventName.breakfast.value,
        AnchorEventName.lunch.value,
        AnchorEventName.dinner.value,
      ],
    ),

    // Fluids — Mode 2A, every 2 hours between 8:00 and 22:00
    NotificationCategorySettings(
      id: _uuid.v4(),
      category: NotificationCategory.fluids,
      schedulingMode: NotificationSchedulingMode.interval,
      intervalHours: 2,
      intervalStartTime: '08:00',
      intervalEndTime: '22:00',
    ),

    // Photos — Mode 2B, no times pre-set (user defines)
    NotificationCategorySettings(
      id: _uuid.v4(),
      category: NotificationCategory.photos,
      schedulingMode: NotificationSchedulingMode.specificTimes,
    ),

    // Journal Entries — Mode 2B, 21:00 default
    NotificationCategorySettings(
      id: _uuid.v4(),
      category: NotificationCategory.journalEntries,
      schedulingMode: NotificationSchedulingMode.specificTimes,
      specificTimes: ['21:00'],
    ),

    // Activities — Mode 2B, no times pre-set (user defines)
    NotificationCategorySettings(
      id: _uuid.v4(),
      category: NotificationCategory.activities,
      schedulingMode: NotificationSchedulingMode.specificTimes,
    ),

    // Condition Check-ins — Mode 1, Bedtime anchor event
    NotificationCategorySettings(
      id: _uuid.v4(),
      category: NotificationCategory.conditionCheckIns,
      schedulingMode: NotificationSchedulingMode.anchorEvents,
      anchorEventValues: [AnchorEventName.bedtime.value],
    ),

    // BBT/Vitals — Mode 1, Wake anchor event only (BBT must be before getting out of bed)
    NotificationCategorySettings(
      id: _uuid.v4(),
      category: NotificationCategory.bbtVitals,
      schedulingMode: NotificationSchedulingMode.anchorEvents,
      anchorEventValues: [AnchorEventName.wake.value],
    ),
  ];
}
