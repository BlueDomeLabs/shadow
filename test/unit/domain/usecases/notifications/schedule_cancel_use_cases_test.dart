// test/unit/domain/usecases/notifications/schedule_cancel_use_cases_test.dart
// Tests for ScheduleNotificationsUseCase and CancelNotificationsUseCase
// per 57_NOTIFICATION_SYSTEM.md

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/anchor_event_time.dart';
import 'package:shadow_app/domain/entities/notification_category_settings.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';
import 'package:shadow_app/domain/repositories/anchor_event_time_repository.dart';
import 'package:shadow_app/domain/repositories/notification_category_settings_repository.dart';
import 'package:shadow_app/domain/repositories/notification_scheduler.dart';
import 'package:shadow_app/domain/services/notification_schedule_service.dart';
import 'package:shadow_app/domain/usecases/notifications/cancel_notifications_use_case.dart';
import 'package:shadow_app/domain/usecases/notifications/schedule_notifications_use_case.dart';

@GenerateMocks([
  AnchorEventTimeRepository,
  NotificationCategorySettingsRepository,
  NotificationScheduler,
])
import 'schedule_cancel_use_cases_test.mocks.dart';

void main() {
  provideDummy<Result<List<AnchorEventTime>, AppError>>(const Success([]));
  provideDummy<Result<AnchorEventTime, AppError>>(
    const Success(
      AnchorEventTime(
        id: 'dummy',
        name: AnchorEventName.wake,
        timeOfDay: '07:00',
      ),
    ),
  );
  provideDummy<Result<AnchorEventTime?, AppError>>(const Success(null));
  provideDummy<Result<List<NotificationCategorySettings>, AppError>>(
    const Success([]),
  );
  provideDummy<Result<NotificationCategorySettings, AppError>>(
    const Success(
      NotificationCategorySettings(
        id: 'dummy',
        category: NotificationCategory.supplements,
        schedulingMode: NotificationSchedulingMode.anchorEvents,
      ),
    ),
  );
  provideDummy<Result<NotificationCategorySettings?, AppError>>(
    const Success(null),
  );
  provideDummy<Result<void, AppError>>(const Success(null));

  // ---------------------------------------------------------------------------
  // ScheduleNotificationsUseCase
  // ---------------------------------------------------------------------------

  group('ScheduleNotificationsUseCase', () {
    late MockAnchorEventTimeRepository mockAnchorRepo;
    late MockNotificationCategorySettingsRepository mockSettingsRepo;
    late MockNotificationScheduler mockScheduler;
    late ScheduleNotificationsUseCase useCase;

    setUp(() {
      mockAnchorRepo = MockAnchorEventTimeRepository();
      mockSettingsRepo = MockNotificationCategorySettingsRepository();
      mockScheduler = MockNotificationScheduler();
      useCase = ScheduleNotificationsUseCase(
        anchorRepository: mockAnchorRepo,
        settingsRepository: mockSettingsRepo,
        scheduleService: NotificationScheduleService(),
        scheduler: mockScheduler,
      );
    });

    test('call_emptySettings_callsSchedulerWithEmptyList', () async {
      when(mockAnchorRepo.getAll()).thenAnswer((_) async => const Success([]));
      when(
        mockSettingsRepo.getAll(),
      ).thenAnswer((_) async => const Success([]));
      when(
        mockScheduler.scheduleAll(any),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase();

      expect(result.isSuccess, isTrue);
      verify(mockScheduler.scheduleAll([])).called(1);
    });

    test(
      'call_withEnabledSettings_passesComputedScheduleToScheduler',
      () async {
        const wakeEvent = AnchorEventTime(
          id: 'evt-wake',
          name: AnchorEventName.wake,
          timeOfDay: '07:00',
        );
        const suppSettings = NotificationCategorySettings(
          id: 'ncs-supp',
          category: NotificationCategory.supplements,
          isEnabled: true,
          schedulingMode: NotificationSchedulingMode.anchorEvents,
          anchorEventValues: [0], // wake
        );

        when(
          mockAnchorRepo.getAll(),
        ).thenAnswer((_) async => const Success([wakeEvent]));
        when(
          mockSettingsRepo.getAll(),
        ).thenAnswer((_) async => const Success([suppSettings]));
        when(
          mockScheduler.scheduleAll(any),
        ).thenAnswer((_) async => const Success(null));

        final result = await useCase();

        expect(result.isSuccess, isTrue);
        final captured =
            verify(mockScheduler.scheduleAll(captureAny)).captured.single
                as List;
        expect(captured.length, 1);
      },
    );

    test(
      'call_anchorRepoFails_returnsFailureWithoutCallingScheduler',
      () async {
        when(mockAnchorRepo.getAll()).thenAnswer(
          (_) async => Failure(
            DatabaseError.queryFailed(
              'anchor_event_times',
              'error',
              StackTrace.empty,
            ),
          ),
        );

        final result = await useCase();

        expect(result.isFailure, isTrue);
        verifyNever(mockSettingsRepo.getAll());
        verifyNever(mockScheduler.scheduleAll(any));
      },
    );

    test(
      'call_settingsRepoFails_returnsFailureWithoutCallingScheduler',
      () async {
        when(
          mockAnchorRepo.getAll(),
        ).thenAnswer((_) async => const Success([]));
        when(mockSettingsRepo.getAll()).thenAnswer(
          (_) async => Failure(
            DatabaseError.queryFailed(
              'notification_category_settings',
              'error',
              StackTrace.empty,
            ),
          ),
        );

        final result = await useCase();

        expect(result.isFailure, isTrue);
        verifyNever(mockScheduler.scheduleAll(any));
      },
    );

    test('call_schedulerFails_returnsFailure', () async {
      when(mockAnchorRepo.getAll()).thenAnswer((_) async => const Success([]));
      when(
        mockSettingsRepo.getAll(),
      ).thenAnswer((_) async => const Success([]));
      when(mockScheduler.scheduleAll(any)).thenAnswer(
        (_) async => Failure(
          NotificationError.scheduleFailed(
            'test',
            'schedule error',
            StackTrace.empty,
          ),
        ),
      );

      final result = await useCase();

      expect(result.isFailure, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // CancelNotificationsUseCase
  // ---------------------------------------------------------------------------

  group('CancelNotificationsUseCase', () {
    late MockNotificationScheduler mockScheduler;
    late CancelNotificationsUseCase useCase;

    setUp(() {
      mockScheduler = MockNotificationScheduler();
      useCase = CancelNotificationsUseCase(mockScheduler);
    });

    test('call_callsCancelAll', () async {
      when(
        mockScheduler.cancelAll(),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase();

      expect(result.isSuccess, isTrue);
      verify(mockScheduler.cancelAll()).called(1);
    });

    test('call_schedulerFails_returnsFailure', () async {
      when(mockScheduler.cancelAll()).thenAnswer(
        (_) async => Failure(
          NotificationError.cancelFailed(
            'test',
            'cancel error',
            StackTrace.empty,
          ),
        ),
      );

      final result = await useCase();

      expect(result.isFailure, isTrue);
    });
  });
}
