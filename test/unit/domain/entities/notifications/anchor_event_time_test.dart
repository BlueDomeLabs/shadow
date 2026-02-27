// test/unit/domain/entities/notifications/anchor_event_time_test.dart
// Tests for AnchorEventTime entity per 57_NOTIFICATION_SYSTEM.md

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/anchor_event_time.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';

void main() {
  group('AnchorEventTime entity', () {
    test('creates with required fields', () {
      const event = AnchorEventTime(
        id: 'evt-1',
        name: AnchorEventName.wake,
        timeOfDay: '07:00',
      );

      expect(event.id, 'evt-1');
      expect(event.name, AnchorEventName.wake);
      expect(event.timeOfDay, '07:00');
      expect(event.isEnabled, isTrue); // default
    });

    test('creates with isEnabled false', () {
      const event = AnchorEventTime(
        id: 'evt-2',
        name: AnchorEventName.breakfast,
        timeOfDay: '08:30',
        isEnabled: false,
      );

      expect(event.isEnabled, isFalse);
    });

    test('displayName returns human-readable name', () {
      expect(
        const AnchorEventTime(
          id: 'e',
          name: AnchorEventName.wake,
          timeOfDay: '07:00',
        ).displayName,
        'Wake',
      );
      expect(
        const AnchorEventTime(
          id: 'e',
          name: AnchorEventName.breakfast,
          timeOfDay: '08:00',
        ).displayName,
        'Breakfast',
      );
      expect(
        const AnchorEventTime(
          id: 'e',
          name: AnchorEventName.lunch,
          timeOfDay: '12:00',
        ).displayName,
        'Lunch',
      );
      expect(
        const AnchorEventTime(
          id: 'e',
          name: AnchorEventName.dinner,
          timeOfDay: '18:00',
        ).displayName,
        'Dinner',
      );
      expect(
        const AnchorEventTime(
          id: 'e',
          name: AnchorEventName.bedtime,
          timeOfDay: '22:00',
        ).displayName,
        'Bedtime',
      );
    });

    test('serializes to and from JSON', () {
      const event = AnchorEventTime(
        id: 'evt-3',
        name: AnchorEventName.dinner,
        timeOfDay: '19:00',
        isEnabled: false,
      );

      final json = event.toJson();
      final restored = AnchorEventTime.fromJson(json);

      expect(restored.id, event.id);
      expect(restored.name, event.name);
      expect(restored.timeOfDay, event.timeOfDay);
      expect(restored.isEnabled, event.isEnabled);
    });

    test('copyWith updates fields', () {
      const event = AnchorEventTime(
        id: 'evt-4',
        name: AnchorEventName.bedtime,
        timeOfDay: '22:00',
      );

      final updated = event.copyWith(timeOfDay: '23:00', isEnabled: false);

      expect(updated.timeOfDay, '23:00');
      expect(updated.isEnabled, isFalse);
      expect(updated.name, AnchorEventName.bedtime); // unchanged
    });
  });

  group('AnchorEventName enum', () {
    test('has correct values', () {
      expect(AnchorEventName.wake.value, 0);
      expect(AnchorEventName.breakfast.value, 1);
      expect(AnchorEventName.morning.value, 2);
      expect(AnchorEventName.lunch.value, 3);
      expect(AnchorEventName.afternoon.value, 4);
      expect(AnchorEventName.dinner.value, 5);
      expect(AnchorEventName.evening.value, 6);
      expect(AnchorEventName.bedtime.value, 7);
    });

    test('fromValue round-trips all names', () {
      for (final name in AnchorEventName.values) {
        expect(AnchorEventName.fromValue(name.value), name);
      }
    });

    test('defaultTime returns spec values', () {
      expect(AnchorEventName.wake.defaultTime, '07:00');
      expect(AnchorEventName.breakfast.defaultTime, '08:00');
      expect(AnchorEventName.morning.defaultTime, '09:00');
      expect(AnchorEventName.lunch.defaultTime, '12:00');
      expect(AnchorEventName.afternoon.defaultTime, '15:00');
      expect(AnchorEventName.dinner.defaultTime, '18:00');
      expect(AnchorEventName.evening.defaultTime, '20:00');
      expect(AnchorEventName.bedtime.defaultTime, '22:00');
    });
  });
}
