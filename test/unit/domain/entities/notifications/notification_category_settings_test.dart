// test/unit/domain/entities/notifications/notification_category_settings_test.dart
// Tests for NotificationCategorySettings entity per 57_NOTIFICATION_SYSTEM.md

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/notification_category_settings.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';

void main() {
  group('NotificationCategorySettings entity', () {
    test('creates with required fields and correct defaults', () {
      const settings = NotificationCategorySettings(
        id: 'cat-1',
        category: NotificationCategory.supplements,
        schedulingMode: NotificationSchedulingMode.anchorEvents,
      );

      expect(settings.id, 'cat-1');
      expect(settings.category, NotificationCategory.supplements);
      expect(settings.schedulingMode, NotificationSchedulingMode.anchorEvents);
      expect(settings.isEnabled, isFalse); // default
      expect(settings.anchorEventValues, isEmpty); // default
      expect(settings.specificTimes, isEmpty); // default
      expect(settings.expiresAfterMinutes, 60); // default
      expect(settings.intervalHours, isNull);
      expect(settings.intervalStartTime, isNull);
      expect(settings.intervalEndTime, isNull);
    });

    test('creates Mode 1 (anchor events) with anchor values', () {
      const settings = NotificationCategorySettings(
        id: 'cat-2',
        category: NotificationCategory.supplements,
        isEnabled: true,
        schedulingMode: NotificationSchedulingMode.anchorEvents,
        anchorEventValues: [1, 3], // breakfast + dinner
      );

      expect(settings.isEnabled, isTrue);
      expect(settings.anchorEventValues, [1, 3]);
    });

    test('creates Mode 2A (interval) with interval fields', () {
      const settings = NotificationCategorySettings(
        id: 'cat-3',
        category: NotificationCategory.fluids,
        schedulingMode: NotificationSchedulingMode.interval,
        intervalHours: 2,
        intervalStartTime: '08:00',
        intervalEndTime: '22:00',
      );

      expect(settings.schedulingMode, NotificationSchedulingMode.interval);
      expect(settings.intervalHours, 2);
      expect(settings.intervalStartTime, '08:00');
      expect(settings.intervalEndTime, '22:00');
    });

    test('creates Mode 2B (specific times) with times list', () {
      const settings = NotificationCategorySettings(
        id: 'cat-4',
        category: NotificationCategory.journalEntries,
        schedulingMode: NotificationSchedulingMode.specificTimes,
        specificTimes: ['09:00', '21:00'],
      );

      expect(settings.schedulingMode, NotificationSchedulingMode.specificTimes);
      expect(settings.specificTimes, ['09:00', '21:00']);
    });

    test('anchorEvents getter maps values to AnchorEventName', () {
      const settings = NotificationCategorySettings(
        id: 'cat-5',
        category: NotificationCategory.supplements,
        schedulingMode: NotificationSchedulingMode.anchorEvents,
        anchorEventValues: [1, 5], // breakfast=1, dinner=5
      );

      final events = settings.anchorEvents;
      expect(events, [AnchorEventName.breakfast, AnchorEventName.dinner]);
    });

    test('anchorEvents returns empty list when anchorEventValues is empty', () {
      const settings = NotificationCategorySettings(
        id: 'cat-6',
        category: NotificationCategory.photos,
        schedulingMode: NotificationSchedulingMode.specificTimes,
      );

      expect(settings.anchorEvents, isEmpty);
    });

    test('serializes to and from JSON', () {
      const settings = NotificationCategorySettings(
        id: 'cat-7',
        category: NotificationCategory.fluids,
        isEnabled: true,
        schedulingMode: NotificationSchedulingMode.interval,
        intervalHours: 4,
        intervalStartTime: '08:00',
        intervalEndTime: '20:00',
        expiresAfterMinutes: 30,
      );

      final json = settings.toJson();
      final restored = NotificationCategorySettings.fromJson(json);

      expect(restored.id, settings.id);
      expect(restored.category, settings.category);
      expect(restored.isEnabled, settings.isEnabled);
      expect(restored.schedulingMode, settings.schedulingMode);
      expect(restored.intervalHours, settings.intervalHours);
      expect(restored.intervalStartTime, settings.intervalStartTime);
      expect(restored.intervalEndTime, settings.intervalEndTime);
      expect(restored.expiresAfterMinutes, settings.expiresAfterMinutes);
    });

    test('serializes anchor event values correctly', () {
      const settings = NotificationCategorySettings(
        id: 'cat-8',
        category: NotificationCategory.supplements,
        schedulingMode: NotificationSchedulingMode.anchorEvents,
        anchorEventValues: [1, 3],
      );

      final json = settings.toJson();
      final restored = NotificationCategorySettings.fromJson(json);

      expect(restored.anchorEventValues, [1, 3]);
    });

    test('serializes specific times correctly', () {
      const settings = NotificationCategorySettings(
        id: 'cat-9',
        category: NotificationCategory.journalEntries,
        schedulingMode: NotificationSchedulingMode.specificTimes,
        specificTimes: ['09:00', '21:00'],
      );

      final json = settings.toJson();
      final restored = NotificationCategorySettings.fromJson(json);

      expect(restored.specificTimes, ['09:00', '21:00']);
    });

    test('copyWith updates fields', () {
      const settings = NotificationCategorySettings(
        id: 'cat-10',
        category: NotificationCategory.activities,
        schedulingMode: NotificationSchedulingMode.specificTimes,
      );

      final updated = settings.copyWith(
        isEnabled: true,
        specificTimes: ['07:00'],
      );

      expect(updated.isEnabled, isTrue);
      expect(updated.specificTimes, ['07:00']);
      expect(updated.category, NotificationCategory.activities); // unchanged
      expect(
        updated.schedulingMode,
        NotificationSchedulingMode.specificTimes,
      ); // unchanged
    });
  });

  group('NotificationCategory enum', () {
    test('has correct values', () {
      expect(NotificationCategory.supplements.value, 0);
      expect(NotificationCategory.foodMeals.value, 1);
      expect(NotificationCategory.fluids.value, 2);
      expect(NotificationCategory.photos.value, 3);
      expect(NotificationCategory.journalEntries.value, 4);
      expect(NotificationCategory.activities.value, 5);
      expect(NotificationCategory.conditionCheckIns.value, 6);
      expect(NotificationCategory.bbtVitals.value, 7);
    });

    test('fromValue round-trips all categories', () {
      for (final category in NotificationCategory.values) {
        expect(NotificationCategory.fromValue(category.value), category);
      }
    });

    test('displayName returns human-readable names', () {
      expect(NotificationCategory.supplements.displayName, 'Supplements');
      expect(NotificationCategory.foodMeals.displayName, 'Food & Meals');
      expect(NotificationCategory.fluids.displayName, 'Fluids');
      expect(NotificationCategory.photos.displayName, 'Photos');
      expect(
        NotificationCategory.journalEntries.displayName,
        'Journal Entries',
      );
      expect(NotificationCategory.activities.displayName, 'Activities');
      expect(
        NotificationCategory.conditionCheckIns.displayName,
        'Condition Check-ins',
      );
      expect(NotificationCategory.bbtVitals.displayName, 'BBT & Vitals');
    });

    test('fromValue returns supplements for unknown value', () {
      expect(
        NotificationCategory.fromValue(99),
        NotificationCategory.supplements,
      );
    });
  });

  group('NotificationSchedulingMode enum', () {
    test('has correct values', () {
      expect(NotificationSchedulingMode.anchorEvents.value, 0);
      expect(NotificationSchedulingMode.interval.value, 1);
      expect(NotificationSchedulingMode.specificTimes.value, 2);
    });

    test('fromValue round-trips all modes', () {
      for (final mode in NotificationSchedulingMode.values) {
        expect(NotificationSchedulingMode.fromValue(mode.value), mode);
      }
    });

    test('fromValue returns anchorEvents for unknown value', () {
      expect(
        NotificationSchedulingMode.fromValue(99),
        NotificationSchedulingMode.anchorEvents,
      );
    });
  });
}
