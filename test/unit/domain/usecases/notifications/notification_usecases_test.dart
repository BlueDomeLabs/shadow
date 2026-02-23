// test/unit/domain/usecases/notifications/notification_usecases_test.dart
// Tests for notification use cases per 57_NOTIFICATION_SYSTEM.md

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
import 'package:shadow_app/domain/usecases/notifications/get_anchor_event_times_use_case.dart';
import 'package:shadow_app/domain/usecases/notifications/get_notification_settings_use_case.dart';
import 'package:shadow_app/domain/usecases/notifications/notification_inputs.dart';
import 'package:shadow_app/domain/usecases/notifications/update_anchor_event_time_use_case.dart';
import 'package:shadow_app/domain/usecases/notifications/update_notification_category_settings_use_case.dart';

@GenerateMocks([
  AnchorEventTimeRepository,
  NotificationCategorySettingsRepository,
])
import 'notification_usecases_test.mocks.dart';

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

  const wakeEvent = AnchorEventTime(
    id: 'evt-wake',
    name: AnchorEventName.wake,
    timeOfDay: '07:00',
  );

  const suppSettings = NotificationCategorySettings(
    id: 'ncs-supp',
    category: NotificationCategory.supplements,
    schedulingMode: NotificationSchedulingMode.anchorEvents,
    anchorEventValues: [1, 3],
  );

  group('GetAnchorEventTimesUseCase', () {
    late MockAnchorEventTimeRepository mockRepository;
    late GetAnchorEventTimesUseCase useCase;

    setUp(() {
      mockRepository = MockAnchorEventTimeRepository();
      useCase = GetAnchorEventTimesUseCase(mockRepository);
    });

    test('call_returnsAllAnchorEvents', () async {
      when(
        mockRepository.getAll(),
      ).thenAnswer((_) async => const Success([wakeEvent]));

      final result = await useCase();

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.length, 1);
      expect(result.valueOrNull?.first.name, AnchorEventName.wake);
      verify(mockRepository.getAll()).called(1);
    });

    test('call_propagatesFailure', () async {
      when(mockRepository.getAll()).thenAnswer(
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
    });
  });

  group('UpdateAnchorEventTimeUseCase', () {
    late MockAnchorEventTimeRepository mockRepository;
    late UpdateAnchorEventTimeUseCase useCase;

    setUp(() {
      mockRepository = MockAnchorEventTimeRepository();
      useCase = UpdateAnchorEventTimeUseCase(mockRepository);
    });

    test('call_updatesTimeOfDay', () async {
      when(
        mockRepository.getById('evt-wake'),
      ).thenAnswer((_) async => const Success(wakeEvent));
      when(mockRepository.update(any)).thenAnswer(
        (invocation) async =>
            Success(invocation.positionalArguments[0] as AnchorEventTime),
      );

      final result = await useCase(
        const UpdateAnchorEventTimeInput(id: 'evt-wake', timeOfDay: '06:30'),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.timeOfDay, '06:30');
      expect(result.valueOrNull?.name, AnchorEventName.wake); // unchanged
    });

    test('call_updatesIsEnabled', () async {
      when(
        mockRepository.getById('evt-wake'),
      ).thenAnswer((_) async => const Success(wakeEvent));
      when(mockRepository.update(any)).thenAnswer(
        (invocation) async =>
            Success(invocation.positionalArguments[0] as AnchorEventTime),
      );

      final result = await useCase(
        const UpdateAnchorEventTimeInput(id: 'evt-wake', isEnabled: false),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.isEnabled, isFalse);
      expect(result.valueOrNull?.timeOfDay, '07:00'); // unchanged
    });

    test('call_preservesUnspecifiedFields', () async {
      when(
        mockRepository.getById('evt-wake'),
      ).thenAnswer((_) async => const Success(wakeEvent));
      when(mockRepository.update(any)).thenAnswer(
        (invocation) async =>
            Success(invocation.positionalArguments[0] as AnchorEventTime),
      );

      // No fields specified — nothing changes
      final result = await useCase(
        const UpdateAnchorEventTimeInput(id: 'evt-wake'),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.timeOfDay, '07:00');
      expect(result.valueOrNull?.isEnabled, isTrue);
    });

    test('call_nonExistentId_returnsFailure', () async {
      when(mockRepository.getById('no-such')).thenAnswer(
        (_) async =>
            Failure(DatabaseError.notFound('AnchorEventTime', 'no-such')),
      );

      final result = await useCase(
        const UpdateAnchorEventTimeInput(id: 'no-such', timeOfDay: '08:00'),
      );

      expect(result.isFailure, isTrue);
      verifyNever(mockRepository.update(any));
    });
  });

  group('GetNotificationSettingsUseCase', () {
    late MockNotificationCategorySettingsRepository mockRepository;
    late GetNotificationSettingsUseCase useCase;

    setUp(() {
      mockRepository = MockNotificationCategorySettingsRepository();
      useCase = GetNotificationSettingsUseCase(mockRepository);
    });

    test('call_returnsAllSettings', () async {
      when(
        mockRepository.getAll(),
      ).thenAnswer((_) async => const Success([suppSettings]));

      final result = await useCase();

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.length, 1);
      expect(
        result.valueOrNull?.first.category,
        NotificationCategory.supplements,
      );
      verify(mockRepository.getAll()).called(1);
    });

    test('call_propagatesFailure', () async {
      when(mockRepository.getAll()).thenAnswer(
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
    });
  });

  group('UpdateNotificationCategorySettingsUseCase', () {
    late MockNotificationCategorySettingsRepository mockRepository;
    late UpdateNotificationCategorySettingsUseCase useCase;

    setUp(() {
      mockRepository = MockNotificationCategorySettingsRepository();
      useCase = UpdateNotificationCategorySettingsUseCase(mockRepository);
    });

    test('call_updatesIsEnabled', () async {
      when(
        mockRepository.getById('ncs-supp'),
      ).thenAnswer((_) async => const Success(suppSettings));
      when(mockRepository.update(any)).thenAnswer(
        (invocation) async => Success(
          invocation.positionalArguments[0] as NotificationCategorySettings,
        ),
      );

      final result = await useCase(
        const UpdateNotificationCategorySettingsInput(
          id: 'ncs-supp',
          isEnabled: true,
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.isEnabled, isTrue);
      expect(
        result.valueOrNull?.category,
        NotificationCategory.supplements,
      ); // unchanged
    });

    test('call_updatesSchedulingMode', () async {
      when(
        mockRepository.getById('ncs-supp'),
      ).thenAnswer((_) async => const Success(suppSettings));
      when(mockRepository.update(any)).thenAnswer(
        (invocation) async => Success(
          invocation.positionalArguments[0] as NotificationCategorySettings,
        ),
      );

      final result = await useCase(
        const UpdateNotificationCategorySettingsInput(
          id: 'ncs-supp',
          schedulingMode: NotificationSchedulingMode.specificTimes,
          specificTimes: ['09:00'],
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(
        result.valueOrNull?.schedulingMode,
        NotificationSchedulingMode.specificTimes,
      );
      expect(result.valueOrNull?.specificTimes, ['09:00']);
    });

    test('call_updatesAnchorEventValues', () async {
      when(
        mockRepository.getById('ncs-supp'),
      ).thenAnswer((_) async => const Success(suppSettings));
      when(mockRepository.update(any)).thenAnswer(
        (invocation) async => Success(
          invocation.positionalArguments[0] as NotificationCategorySettings,
        ),
      );

      final result = await useCase(
        const UpdateNotificationCategorySettingsInput(
          id: 'ncs-supp',
          anchorEventValues: [1, 2, 3],
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.anchorEventValues, [1, 2, 3]);
    });

    test('call_updatesIntervalFields', () async {
      when(
        mockRepository.getById('ncs-supp'),
      ).thenAnswer((_) async => const Success(suppSettings));
      when(mockRepository.update(any)).thenAnswer(
        (invocation) async => Success(
          invocation.positionalArguments[0] as NotificationCategorySettings,
        ),
      );

      final result = await useCase(
        const UpdateNotificationCategorySettingsInput(
          id: 'ncs-supp',
          schedulingMode: NotificationSchedulingMode.interval,
          intervalHours: 4,
          intervalStartTime: '08:00',
          intervalEndTime: '20:00',
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(
        result.valueOrNull?.schedulingMode,
        NotificationSchedulingMode.interval,
      );
      expect(result.valueOrNull?.intervalHours, 4);
      expect(result.valueOrNull?.intervalStartTime, '08:00');
      expect(result.valueOrNull?.intervalEndTime, '20:00');
    });

    test('call_preservesUnspecifiedFields', () async {
      when(
        mockRepository.getById('ncs-supp'),
      ).thenAnswer((_) async => const Success(suppSettings));
      when(mockRepository.update(any)).thenAnswer(
        (invocation) async => Success(
          invocation.positionalArguments[0] as NotificationCategorySettings,
        ),
      );

      // Only update isEnabled — rest unchanged
      final result = await useCase(
        const UpdateNotificationCategorySettingsInput(
          id: 'ncs-supp',
          isEnabled: true,
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.anchorEventValues, [1, 3]); // unchanged
      expect(
        result.valueOrNull?.schedulingMode,
        NotificationSchedulingMode.anchorEvents,
      ); // unchanged
    });

    test('call_nonExistentId_returnsFailure', () async {
      when(mockRepository.getById('no-such')).thenAnswer(
        (_) async => Failure(
          DatabaseError.notFound('NotificationCategorySettings', 'no-such'),
        ),
      );

      final result = await useCase(
        const UpdateNotificationCategorySettingsInput(
          id: 'no-such',
          isEnabled: true,
        ),
      );

      expect(result.isFailure, isTrue);
      verifyNever(mockRepository.update(any));
    });
  });
}
