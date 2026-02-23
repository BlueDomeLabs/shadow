// test/data/notifications/notification_scheduler_impl_test.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/notifications/notification_scheduler_impl.dart';
import 'package:shadow_app/domain/entities/scheduled_notification.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'notification_scheduler_impl_test.mocks.dart';

@GenerateMocks([FlutterLocalNotificationsPlugin])
void main() {
  setUpAll(() {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('UTC'));
  });

  group('NotificationSchedulerImpl', () {
    late MockFlutterLocalNotificationsPlugin mockPlugin;
    late NotificationSchedulerImpl scheduler;

    setUp(() {
      mockPlugin = MockFlutterLocalNotificationsPlugin();
      scheduler = NotificationSchedulerImpl(mockPlugin);
    });

    ScheduledNotification makeNotification({
      String id = 'shadow_notif_0_0700',
      NotificationCategory category = NotificationCategory.supplements,
      String timeOfDay = '07:00',
      String title = 'Supplements',
      String body = 'Time to take your supplements.',
      String payload = '{"category": 0}',
      int expiresAfterMinutes = 60,
    }) => ScheduledNotification(
      id: id,
      category: category,
      timeOfDay: timeOfDay,
      title: title,
      body: body,
      payload: payload,
      expiresAfterMinutes: expiresAfterMinutes,
    );

    test('scheduleAll cancels existing notifications first', () async {
      when(mockPlugin.cancelAll()).thenAnswer((_) async {});
      when(
        mockPlugin.zonedSchedule(
          any,
          any,
          any,
          any,
          any,
          payload: anyNamed('payload'),
          androidScheduleMode: anyNamed('androidScheduleMode'),
          matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          uiLocalNotificationDateInterpretation: anyNamed(
            'uiLocalNotificationDateInterpretation',
          ),
        ),
      ).thenAnswer((_) async {});

      await scheduler.scheduleAll([makeNotification()]);

      verify(mockPlugin.cancelAll()).called(1);
    });

    test('scheduleAll calls zonedSchedule for each notification', () async {
      when(mockPlugin.cancelAll()).thenAnswer((_) async {});
      when(
        mockPlugin.zonedSchedule(
          any,
          any,
          any,
          any,
          any,
          payload: anyNamed('payload'),
          androidScheduleMode: anyNamed('androidScheduleMode'),
          matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          uiLocalNotificationDateInterpretation: anyNamed(
            'uiLocalNotificationDateInterpretation',
          ),
        ),
      ).thenAnswer((_) async {});

      await scheduler.scheduleAll([
        makeNotification(id: 'notif-1'),
        makeNotification(id: 'notif-2'),
      ]);

      verify(
        mockPlugin.zonedSchedule(
          any,
          any,
          any,
          any,
          any,
          payload: anyNamed('payload'),
          androidScheduleMode: anyNamed('androidScheduleMode'),
          matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          uiLocalNotificationDateInterpretation: anyNamed(
            'uiLocalNotificationDateInterpretation',
          ),
        ),
      ).called(2);
    });

    test('scheduleAll returns Success on completion', () async {
      when(mockPlugin.cancelAll()).thenAnswer((_) async {});
      when(
        mockPlugin.zonedSchedule(
          any,
          any,
          any,
          any,
          any,
          payload: anyNamed('payload'),
          androidScheduleMode: anyNamed('androidScheduleMode'),
          matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          uiLocalNotificationDateInterpretation: anyNamed(
            'uiLocalNotificationDateInterpretation',
          ),
        ),
      ).thenAnswer((_) async {});

      final result = await scheduler.scheduleAll([makeNotification()]);

      expect(result, isA<Success<void, dynamic>>());
    });

    test('scheduleAll with empty list just cancels all', () async {
      when(mockPlugin.cancelAll()).thenAnswer((_) async {});

      final result = await scheduler.scheduleAll([]);

      verify(mockPlugin.cancelAll()).called(1);
      expect(result, isA<Success<void, dynamic>>());
    });

    test('scheduleAll returns Failure on plugin exception', () async {
      when(mockPlugin.cancelAll()).thenThrow(Exception('platform error'));

      final result = await scheduler.scheduleAll([makeNotification()]);

      expect(result, isA<Failure<void, dynamic>>());
    });

    test('cancelAll delegates to plugin.cancelAll', () async {
      when(mockPlugin.cancelAll()).thenAnswer((_) async {});

      await scheduler.cancelAll();

      verify(mockPlugin.cancelAll()).called(1);
    });

    test('cancelAll returns Success', () async {
      when(mockPlugin.cancelAll()).thenAnswer((_) async {});

      final result = await scheduler.cancelAll();

      expect(result, isA<Success<void, dynamic>>());
    });

    test('cancelAll returns Failure on plugin exception', () async {
      when(mockPlugin.cancelAll()).thenThrow(Exception('platform error'));

      final result = await scheduler.cancelAll();

      expect(result, isA<Failure<void, dynamic>>());
    });

    test('passes title and body to zonedSchedule', () async {
      when(mockPlugin.cancelAll()).thenAnswer((_) async {});
      when(
        mockPlugin.zonedSchedule(
          any,
          any,
          any,
          any,
          any,
          payload: anyNamed('payload'),
          androidScheduleMode: anyNamed('androidScheduleMode'),
          matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          uiLocalNotificationDateInterpretation: anyNamed(
            'uiLocalNotificationDateInterpretation',
          ),
        ),
      ).thenAnswer((_) async {});

      await scheduler.scheduleAll([
        makeNotification(title: 'My Title', body: 'My Body'),
      ]);

      verify(
        mockPlugin.zonedSchedule(
          any,
          'My Title',
          'My Body',
          any,
          any,
          payload: anyNamed('payload'),
          androidScheduleMode: anyNamed('androidScheduleMode'),
          matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          uiLocalNotificationDateInterpretation: anyNamed(
            'uiLocalNotificationDateInterpretation',
          ),
        ),
      ).called(1);
    });

    test('passes payload to zonedSchedule', () async {
      when(mockPlugin.cancelAll()).thenAnswer((_) async {});
      when(
        mockPlugin.zonedSchedule(
          any,
          any,
          any,
          any,
          any,
          payload: anyNamed('payload'),
          androidScheduleMode: anyNamed('androidScheduleMode'),
          matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          uiLocalNotificationDateInterpretation: anyNamed(
            'uiLocalNotificationDateInterpretation',
          ),
        ),
      ).thenAnswer((_) async {});

      await scheduler.scheduleAll([
        makeNotification(payload: '{"category": 3}'),
      ]);

      verify(
        mockPlugin.zonedSchedule(
          any,
          any,
          any,
          any,
          any,
          payload: '{"category": 3}',
          androidScheduleMode: anyNamed('androidScheduleMode'),
          matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
          uiLocalNotificationDateInterpretation: anyNamed(
            'uiLocalNotificationDateInterpretation',
          ),
        ),
      ).called(1);
    });

    test(
      'createAndroidChannels is no-op when android impl not available',
      () async {
        when(
          mockPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >(),
        ).thenReturn(null);

        await expectLater(
          NotificationSchedulerImpl.createAndroidChannels(mockPlugin),
          completes,
        );
      },
    );
  });
}
