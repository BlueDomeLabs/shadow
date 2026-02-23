// test/unit/domain/services/notification_schedule_service_test.dart
// Tests for NotificationScheduleService per 57_NOTIFICATION_SYSTEM.md

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/anchor_event_time.dart';
import 'package:shadow_app/domain/entities/notification_category_settings.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';
import 'package:shadow_app/domain/services/notification_schedule_service.dart';

void main() {
  late NotificationScheduleService service;

  setUp(() {
    service = NotificationScheduleService();
  });

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  AnchorEventTime makeAnchor(
    AnchorEventName name,
    String timeOfDay, {
    bool isEnabled = true,
  }) => AnchorEventTime(
    id: 'evt-${name.value}',
    name: name,
    timeOfDay: timeOfDay,
    isEnabled: isEnabled,
  );

  NotificationCategorySettings makeSettings({
    NotificationCategory category = NotificationCategory.supplements,
    bool isEnabled = true,
    NotificationSchedulingMode schedulingMode =
        NotificationSchedulingMode.anchorEvents,
    List<int> anchorEventValues = const [],
    int? intervalHours,
    String? intervalStartTime,
    String? intervalEndTime,
    List<String> specificTimes = const [],
    int expiresAfterMinutes = 60,
  }) => NotificationCategorySettings(
    id: 'ncs-${category.value}',
    category: category,
    isEnabled: isEnabled,
    schedulingMode: schedulingMode,
    anchorEventValues: anchorEventValues,
    intervalHours: intervalHours,
    intervalStartTime: intervalStartTime,
    intervalEndTime: intervalEndTime,
    specificTimes: specificTimes,
    expiresAfterMinutes: expiresAfterMinutes,
  );

  final wakeAnchor = makeAnchor(AnchorEventName.wake, '07:00');
  final breakfastAnchor = makeAnchor(AnchorEventName.breakfast, '08:00');
  final dinnerAnchor = makeAnchor(AnchorEventName.dinner, '18:00');

  // ---------------------------------------------------------------------------
  // Mode 1 — Anchor Events
  // ---------------------------------------------------------------------------

  group('computeSchedule — Mode 1 (anchorEvents)', () {
    test(
      'computeSchedule_anchorMode_disabledCategory_returnsNoNotifications',
      () {
        final settings = [
          makeSettings(
            isEnabled: false,
            anchorEventValues: [AnchorEventName.wake.value],
          ),
        ];

        final result = service.computeSchedule(
          anchorEvents: [wakeAnchor],
          settings: settings,
        );

        expect(result, isEmpty);
      },
    );

    test(
      'computeSchedule_anchorMode_enabledCategory_returnsOnePerAssignedEvent',
      () {
        final settings = [
          makeSettings(
            anchorEventValues: [
              AnchorEventName.breakfast.value,
              AnchorEventName.dinner.value,
            ],
          ),
        ];

        final result = service.computeSchedule(
          anchorEvents: [wakeAnchor, breakfastAnchor, dinnerAnchor],
          settings: settings,
        );

        expect(result.length, 2);
      },
    );

    test('computeSchedule_anchorMode_skipsDisabledAnchorEvents', () {
      final disabledBreakfast = makeAnchor(
        AnchorEventName.breakfast,
        '08:00',
        isEnabled: false,
      );
      final settings = [
        makeSettings(
          anchorEventValues: [
            AnchorEventName.breakfast.value,
            AnchorEventName.dinner.value,
          ],
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [disabledBreakfast, dinnerAnchor],
        settings: settings,
      );

      // Breakfast is disabled — only dinner fires
      expect(result.length, 1);
      expect(result.first.timeOfDay, '18:00');
    });

    test('computeSchedule_anchorMode_usesAnchorEventTime', () {
      final customWake = makeAnchor(AnchorEventName.wake, '06:30');
      final settings = [
        makeSettings(anchorEventValues: [AnchorEventName.wake.value]),
      ];

      final result = service.computeSchedule(
        anchorEvents: [customWake],
        settings: settings,
      );

      expect(result.length, 1);
      expect(result.first.timeOfDay, '06:30');
    });

    test('computeSchedule_anchorMode_skipsUnknownAnchorEventValues', () {
      // An anchor event value with no corresponding AnchorEventTime record
      final settings = [
        makeSettings(
          anchorEventValues: [
            AnchorEventName.lunch.value,
          ], // lunch not provided
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [wakeAnchor], // lunch is absent
        settings: settings,
      );

      expect(result, isEmpty);
    });

    test('computeSchedule_anchorMode_supplementsBodyText', () {
      final settings = [
        makeSettings(anchorEventValues: [AnchorEventName.wake.value]),
      ];

      final result = service.computeSchedule(
        anchorEvents: [wakeAnchor],
        settings: settings,
      );

      expect(result.first.body, 'Time to take your supplements.');
    });

    test('computeSchedule_anchorMode_foodMealsBodyIncludesAnchorName', () {
      final settings = [
        makeSettings(
          category: NotificationCategory.foodMeals,
          anchorEventValues: [AnchorEventName.breakfast.value],
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [breakfastAnchor],
        settings: settings,
      );

      expect(result.first.body, 'What did you have for Breakfast?');
    });

    test('computeSchedule_anchorMode_bbtVitalsBodyText', () {
      final settings = [
        makeSettings(
          category: NotificationCategory.bbtVitals,
          anchorEventValues: [AnchorEventName.wake.value],
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [wakeAnchor],
        settings: settings,
      );

      expect(
        result.first.body,
        'Good morning. Time to log your BBT and vitals.',
      );
    });

    test('computeSchedule_anchorMode_titleIsCategoryDisplayName', () {
      final settings = [
        makeSettings(anchorEventValues: [AnchorEventName.wake.value]),
      ];

      final result = service.computeSchedule(
        anchorEvents: [wakeAnchor],
        settings: settings,
      );

      expect(result.first.title, 'Supplements');
    });

    test('computeSchedule_anchorMode_idIncludesCategoryAndTime', () {
      final settings = [
        makeSettings(anchorEventValues: [AnchorEventName.wake.value]),
      ];

      final result = service.computeSchedule(
        anchorEvents: [wakeAnchor],
        settings: settings,
      );

      expect(result.first.id, 'shadow_notif_0_0700');
    });

    test(
      'computeSchedule_anchorMode_payloadContainsCategoryAndAnchorEvent',
      () {
        final settings = [
          makeSettings(anchorEventValues: [AnchorEventName.breakfast.value]),
        ];

        final result = service.computeSchedule(
          anchorEvents: [breakfastAnchor],
          settings: settings,
        );

        final payload =
            jsonDecode(result.first.payload) as Map<String, dynamic>;
        expect(payload['category'], NotificationCategory.supplements.value);
        expect(payload['anchorEvent'], AnchorEventName.breakfast.value);
      },
    );

    test('computeSchedule_anchorMode_expiresAfterMatchesSetting', () {
      final settings = [
        makeSettings(
          anchorEventValues: [AnchorEventName.wake.value],
          expiresAfterMinutes: 45,
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [wakeAnchor],
        settings: settings,
      );

      expect(result.first.expiresAfterMinutes, 45);
    });
  });

  // ---------------------------------------------------------------------------
  // Mode 2A — Interval
  // ---------------------------------------------------------------------------

  group('computeSchedule — Mode 2A (interval)', () {
    test('computeSchedule_intervalMode_returnsCorrectCount', () {
      // 08:00 to 22:00, every 2h → 8 times
      final settings = [
        makeSettings(
          category: NotificationCategory.fluids,
          schedulingMode: NotificationSchedulingMode.interval,
          intervalHours: 2,
          intervalStartTime: '08:00',
          intervalEndTime: '22:00',
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [],
        settings: settings,
      );

      expect(result.length, 8);
    });

    test('computeSchedule_intervalMode_includesStartTime', () {
      final settings = [
        makeSettings(
          category: NotificationCategory.fluids,
          schedulingMode: NotificationSchedulingMode.interval,
          intervalHours: 4,
          intervalStartTime: '08:00',
          intervalEndTime: '20:00',
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [],
        settings: settings,
      );

      expect(result.first.timeOfDay, '08:00');
    });

    test('computeSchedule_intervalMode_includesEndTime', () {
      final settings = [
        makeSettings(
          category: NotificationCategory.fluids,
          schedulingMode: NotificationSchedulingMode.interval,
          intervalHours: 4,
          intervalStartTime: '08:00',
          intervalEndTime: '20:00',
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [],
        settings: settings,
      );

      expect(result.last.timeOfDay, '20:00');
    });

    test('computeSchedule_intervalMode_doesNotExceedEndTime', () {
      // 08:00 to 21:00, every 4h → 08:00, 12:00, 16:00, 20:00 (21:00 not hit exactly)
      final settings = [
        makeSettings(
          category: NotificationCategory.fluids,
          schedulingMode: NotificationSchedulingMode.interval,
          intervalHours: 4,
          intervalStartTime: '08:00',
          intervalEndTime: '21:00',
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [],
        settings: settings,
      );

      expect(result.last.timeOfDay, '20:00');
      expect(result.length, 4); // 08, 12, 16, 20
    });

    test('computeSchedule_intervalMode_disabledCategory_returnsEmpty', () {
      final settings = [
        makeSettings(
          category: NotificationCategory.fluids,
          isEnabled: false,
          schedulingMode: NotificationSchedulingMode.interval,
          intervalHours: 2,
          intervalStartTime: '08:00',
          intervalEndTime: '22:00',
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [],
        settings: settings,
      );

      expect(result, isEmpty);
    });

    test('computeSchedule_intervalMode_missingFields_returnsEmpty', () {
      // Missing intervalStartTime — should produce no notifications
      final settings = [
        makeSettings(
          category: NotificationCategory.fluids,
          schedulingMode: NotificationSchedulingMode.interval,
          intervalHours: 2,
          // intervalStartTime and intervalEndTime are null
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [],
        settings: settings,
      );

      expect(result, isEmpty);
    });

    test('computeSchedule_intervalMode_payloadHasNoCategoryAnchorEvent', () {
      final settings = [
        makeSettings(
          category: NotificationCategory.fluids,
          schedulingMode: NotificationSchedulingMode.interval,
          intervalHours: 4,
          intervalStartTime: '08:00',
          intervalEndTime: '08:00',
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [],
        settings: settings,
      );

      final payload = jsonDecode(result.first.payload) as Map<String, dynamic>;
      expect(payload.containsKey('anchorEvent'), isFalse);
    });

    test('computeSchedule_intervalMode_fluidsBodyText', () {
      final settings = [
        makeSettings(
          category: NotificationCategory.fluids,
          schedulingMode: NotificationSchedulingMode.interval,
          intervalHours: 4,
          intervalStartTime: '08:00',
          intervalEndTime: '08:00',
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [],
        settings: settings,
      );

      expect(result.first.body, 'Time to log your fluids. What have you had?');
    });
  });

  // ---------------------------------------------------------------------------
  // Mode 2B — Specific Times
  // ---------------------------------------------------------------------------

  group('computeSchedule — Mode 2B (specificTimes)', () {
    test('computeSchedule_specificTimesMode_returnsOnePerTime', () {
      final settings = [
        makeSettings(
          category: NotificationCategory.journalEntries,
          schedulingMode: NotificationSchedulingMode.specificTimes,
          specificTimes: ['09:00', '21:00'],
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [],
        settings: settings,
      );

      expect(result.length, 2);
      expect(result.map((n) => n.timeOfDay), containsAll(['09:00', '21:00']));
    });

    test('computeSchedule_specificTimesMode_emptyList_returnsEmpty', () {
      final settings = [
        makeSettings(
          category: NotificationCategory.journalEntries,
          schedulingMode: NotificationSchedulingMode.specificTimes,
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [],
        settings: settings,
      );

      expect(result, isEmpty);
    });

    test('computeSchedule_specificTimesMode_journalBodyText', () {
      final settings = [
        makeSettings(
          category: NotificationCategory.journalEntries,
          schedulingMode: NotificationSchedulingMode.specificTimes,
          specificTimes: ['21:00'],
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [],
        settings: settings,
      );

      expect(result.first.body, 'How was your day? Add a journal entry.');
    });

    test('computeSchedule_specificTimesMode_idFormat', () {
      final settings = [
        makeSettings(
          category: NotificationCategory.journalEntries,
          schedulingMode: NotificationSchedulingMode.specificTimes,
          specificTimes: ['21:00'],
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [],
        settings: settings,
      );

      expect(result.first.id, 'shadow_notif_4_2100');
    });
  });

  // ---------------------------------------------------------------------------
  // Multi-category
  // ---------------------------------------------------------------------------

  group('computeSchedule — multi-category', () {
    test('computeSchedule_allDisabled_returnsEmptyList', () {
      final settings = NotificationCategory.values
          .map((cat) => makeSettings(category: cat, isEnabled: false))
          .toList();

      final result = service.computeSchedule(
        anchorEvents: [wakeAnchor, breakfastAnchor, dinnerAnchor],
        settings: settings,
      );

      expect(result, isEmpty);
    });

    test('computeSchedule_multipleCategories_returnsCombinedResults', () {
      final settings = [
        makeSettings(anchorEventValues: [AnchorEventName.wake.value]),
        makeSettings(
          category: NotificationCategory.fluids,
          schedulingMode: NotificationSchedulingMode.specificTimes,
          specificTimes: ['10:00', '14:00'],
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [wakeAnchor],
        settings: settings,
      );

      expect(result.length, 3); // 1 supplements + 2 fluids
    });

    test('computeSchedule_notificationIds_areUniqueAcrossCategories', () {
      final settings = [
        makeSettings(anchorEventValues: [AnchorEventName.wake.value]),
        makeSettings(
          category: NotificationCategory.bbtVitals,
          anchorEventValues: [AnchorEventName.wake.value],
        ),
      ];

      final result = service.computeSchedule(
        anchorEvents: [wakeAnchor],
        settings: settings,
      );

      final ids = result.map((n) => n.id).toList();
      expect(ids.toSet().length, ids.length); // all unique
    });
  });

  // ---------------------------------------------------------------------------
  // computeIntervalTimes
  // ---------------------------------------------------------------------------

  group('computeIntervalTimes', () {
    test('computeIntervalTimes_2h_08to22_returns8Times', () {
      final times = service.computeIntervalTimes('08:00', '22:00', 2);
      expect(times, [
        '08:00',
        '10:00',
        '12:00',
        '14:00',
        '16:00',
        '18:00',
        '20:00',
        '22:00',
      ]);
    });

    test('computeIntervalTimes_sameStartAndEnd_returnsSingleTime', () {
      final times = service.computeIntervalTimes('12:00', '12:00', 2);
      expect(times, ['12:00']);
    });

    test('computeIntervalTimes_unevenInterval_stopsBeforeEnd', () {
      // 08:00 to 11:00, every 4h → only 08:00 (12:00 exceeds end)
      final times = service.computeIntervalTimes('08:00', '11:00', 4);
      expect(times, ['08:00']);
    });

    test('computeIntervalTimes_startAfterEnd_returnsEmpty', () {
      final times = service.computeIntervalTimes('22:00', '08:00', 2);
      expect(times, isEmpty);
    });

    test('computeIntervalTimes_producesCorrectHHmmFormat', () {
      final times = service.computeIntervalTimes('08:00', '09:00', 1);
      for (final t in times) {
        expect(RegExp(r'^\d{2}:\d{2}$').hasMatch(t), isTrue);
      }
    });
  });

  // ---------------------------------------------------------------------------
  // All category body texts
  // ---------------------------------------------------------------------------

  group('notification body text per category', () {
    test('activities_bodyText', () {
      final settings = [
        makeSettings(
          category: NotificationCategory.activities,
          schedulingMode: NotificationSchedulingMode.specificTimes,
          specificTimes: ['18:00'],
        ),
      ];
      final result = service.computeSchedule(
        anchorEvents: [],
        settings: settings,
      );
      expect(result.first.body, 'Did you do any physical activity today?');
    });

    test('conditionCheckIns_bodyText', () {
      final settings = [
        makeSettings(
          category: NotificationCategory.conditionCheckIns,
          schedulingMode: NotificationSchedulingMode.specificTimes,
          specificTimes: ['20:00'],
        ),
      ];
      final result = service.computeSchedule(
        anchorEvents: [],
        settings: settings,
      );
      expect(
        result.first.body,
        'How are your conditions today? Time for your check-in.',
      );
    });

    test('photos_bodyText', () {
      final settings = [
        makeSettings(
          category: NotificationCategory.photos,
          schedulingMode: NotificationSchedulingMode.specificTimes,
          specificTimes: ['12:00'],
        ),
      ];
      final result = service.computeSchedule(
        anchorEvents: [],
        settings: settings,
      );
      expect(result.first.body, 'Time for your photo check-in.');
    });

    test('foodMeals_intervalMode_bodyText_noAnchorEvent', () {
      final settings = [
        makeSettings(
          category: NotificationCategory.foodMeals,
          schedulingMode: NotificationSchedulingMode.specificTimes,
          specificTimes: ['13:00'],
        ),
      ];
      final result = service.computeSchedule(
        anchorEvents: [],
        settings: settings,
      );
      expect(result.first.body, 'Time to log your meal.');
    });
  });
}
