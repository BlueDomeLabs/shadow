// test/unit/domain/services/notification_seed_service_test.dart
// Tests for NotificationSeedService per 57_NOTIFICATION_SYSTEM.md

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
import 'package:shadow_app/domain/services/notification_seed_service.dart';

@GenerateMocks([
  AnchorEventTimeRepository,
  NotificationCategorySettingsRepository,
])
import 'notification_seed_service_test.mocks.dart';

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

  group('NotificationSeedService', () {
    late MockAnchorEventTimeRepository mockAnchorRepo;
    late MockNotificationCategorySettingsRepository mockSettingsRepo;
    late NotificationSeedService service;

    setUp(() {
      mockAnchorRepo = MockAnchorEventTimeRepository();
      mockSettingsRepo = MockNotificationCategorySettingsRepository();
      service = NotificationSeedService(
        anchorRepository: mockAnchorRepo,
        settingsRepository: mockSettingsRepo,
      );
    });

    group('seedDefaults', () {
      test('seedDefaults_emptyDatabase_insertsAll8AnchorEvents', () async {
        when(
          mockAnchorRepo.getAll(),
        ).thenAnswer((_) async => const Success([]));
        when(mockAnchorRepo.create(any)).thenAnswer(
          (invocation) async =>
              Success(invocation.positionalArguments[0] as AnchorEventTime),
        );
        when(
          mockSettingsRepo.getAll(),
        ).thenAnswer((_) async => const Success([]));
        when(mockSettingsRepo.create(any)).thenAnswer(
          (invocation) async => Success(
            invocation.positionalArguments[0] as NotificationCategorySettings,
          ),
        );

        final result = await service.seedDefaults();

        expect(result.isSuccess, isTrue);
        // 8 anchor events created (wake, breakfast, morning, lunch, afternoon, dinner, evening, bedtime)
        verify(mockAnchorRepo.create(any)).called(8);
      });

      test('seedDefaults_emptyDatabase_insertsAll8CategorySettings', () async {
        when(
          mockAnchorRepo.getAll(),
        ).thenAnswer((_) async => const Success([]));
        when(mockAnchorRepo.create(any)).thenAnswer(
          (invocation) async =>
              Success(invocation.positionalArguments[0] as AnchorEventTime),
        );
        when(
          mockSettingsRepo.getAll(),
        ).thenAnswer((_) async => const Success([]));
        when(mockSettingsRepo.create(any)).thenAnswer(
          (invocation) async => Success(
            invocation.positionalArguments[0] as NotificationCategorySettings,
          ),
        );

        await service.seedDefaults();

        // 8 category settings created
        verify(mockSettingsRepo.create(any)).called(8);
      });

      test(
        'seedDefaults_anchorsAlreadyExist_skipsExistingAnchorEvents',
        () async {
          // All 5 anchor events already exist
          final existingAnchors = AnchorEventName.values
              .map(
                (name) => AnchorEventTime(
                  id: 'evt-${name.value}',
                  name: name,
                  timeOfDay: name.defaultTime,
                ),
              )
              .toList();

          when(
            mockAnchorRepo.getAll(),
          ).thenAnswer((_) async => Success(existingAnchors));
          when(
            mockSettingsRepo.getAll(),
          ).thenAnswer((_) async => const Success([]));
          when(mockSettingsRepo.create(any)).thenAnswer(
            (invocation) async => Success(
              invocation.positionalArguments[0] as NotificationCategorySettings,
            ),
          );

          await service.seedDefaults();

          // No anchor events created since all exist
          verifyNever(mockAnchorRepo.create(any));
          // Settings still created
          verify(mockSettingsRepo.create(any)).called(8);
        },
      );

      test('seedDefaults_settingsAlreadyExist_skipsExistingSettings', () async {
        when(
          mockAnchorRepo.getAll(),
        ).thenAnswer((_) async => const Success([]));
        when(mockAnchorRepo.create(any)).thenAnswer(
          (invocation) async =>
              Success(invocation.positionalArguments[0] as AnchorEventTime),
        );

        // All 8 category settings already exist
        final existingSettings = NotificationCategory.values
            .map(
              (cat) => NotificationCategorySettings(
                id: 'ncs-${cat.value}',
                category: cat,
                schedulingMode: NotificationSchedulingMode.anchorEvents,
              ),
            )
            .toList();

        when(
          mockSettingsRepo.getAll(),
        ).thenAnswer((_) async => Success(existingSettings));

        await service.seedDefaults();

        // No settings created since all exist
        verifyNever(mockSettingsRepo.create(any));
        // Anchors still created (8 anchor events)
        verify(mockAnchorRepo.create(any)).called(8);
      });

      test('seedDefaults_fullyPopulated_insertsNothing', () async {
        final existingAnchors = AnchorEventName.values
            .map(
              (name) => AnchorEventTime(
                id: 'evt-${name.value}',
                name: name,
                timeOfDay: name.defaultTime,
              ),
            )
            .toList();
        final existingSettings = NotificationCategory.values
            .map(
              (cat) => NotificationCategorySettings(
                id: 'ncs-${cat.value}',
                category: cat,
                schedulingMode: NotificationSchedulingMode.anchorEvents,
              ),
            )
            .toList();

        when(
          mockAnchorRepo.getAll(),
        ).thenAnswer((_) async => Success(existingAnchors));
        when(
          mockSettingsRepo.getAll(),
        ).thenAnswer((_) async => Success(existingSettings));

        final result = await service.seedDefaults();

        expect(result.isSuccess, isTrue);
        verifyNever(mockAnchorRepo.create(any));
        verifyNever(mockSettingsRepo.create(any));
      });

      test('seedDefaults_anchorGetAllFails_returnsFailure', () async {
        when(mockAnchorRepo.getAll()).thenAnswer(
          (_) async => Failure(
            DatabaseError.queryFailed(
              'anchor_event_times',
              'error',
              StackTrace.empty,
            ),
          ),
        );

        final result = await service.seedDefaults();

        expect(result.isFailure, isTrue);
        verifyNever(mockSettingsRepo.getAll());
      });

      test('seedDefaults_settingsGetAllFails_returnsFailure', () async {
        when(
          mockAnchorRepo.getAll(),
        ).thenAnswer((_) async => const Success([]));
        when(mockAnchorRepo.create(any)).thenAnswer(
          (invocation) async =>
              Success(invocation.positionalArguments[0] as AnchorEventTime),
        );
        when(mockSettingsRepo.getAll()).thenAnswer(
          (_) async => Failure(
            DatabaseError.queryFailed(
              'notification_category_settings',
              'error',
              StackTrace.empty,
            ),
          ),
        );

        final result = await service.seedDefaults();

        expect(result.isFailure, isTrue);
      });

      test('seedDefaults_seedsCorrectDefaultTimesForAnchorEvents', () async {
        final capturedEvents = <AnchorEventTime>[];

        when(
          mockAnchorRepo.getAll(),
        ).thenAnswer((_) async => const Success([]));
        when(mockAnchorRepo.create(any)).thenAnswer((invocation) async {
          final event = invocation.positionalArguments[0] as AnchorEventTime;
          capturedEvents.add(event);
          return Success(event);
        });
        when(
          mockSettingsRepo.getAll(),
        ).thenAnswer((_) async => const Success([]));
        when(mockSettingsRepo.create(any)).thenAnswer(
          (invocation) async => Success(
            invocation.positionalArguments[0] as NotificationCategorySettings,
          ),
        );

        await service.seedDefaults();

        // Verify default times match spec
        final byName = {for (final e in capturedEvents) e.name: e.timeOfDay};
        expect(byName[AnchorEventName.wake], '07:00');
        expect(byName[AnchorEventName.breakfast], '08:00');
        expect(byName[AnchorEventName.morning], '09:00');
        expect(byName[AnchorEventName.lunch], '12:00');
        expect(byName[AnchorEventName.afternoon], '15:00');
        expect(byName[AnchorEventName.dinner], '18:00');
        expect(byName[AnchorEventName.evening], '20:00');
        expect(byName[AnchorEventName.bedtime], '22:00');
      });

      test('seedDefaults_seedsCorrectDefaultModesForCategories', () async {
        final capturedSettings = <NotificationCategorySettings>[];

        when(
          mockAnchorRepo.getAll(),
        ).thenAnswer((_) async => const Success([]));
        when(mockAnchorRepo.create(any)).thenAnswer(
          (invocation) async =>
              Success(invocation.positionalArguments[0] as AnchorEventTime),
        );
        when(
          mockSettingsRepo.getAll(),
        ).thenAnswer((_) async => const Success([]));
        when(mockSettingsRepo.create(any)).thenAnswer((invocation) async {
          final s =
              invocation.positionalArguments[0] as NotificationCategorySettings;
          capturedSettings.add(s);
          return Success(s);
        });

        await service.seedDefaults();

        final byCategory = {for (final s in capturedSettings) s.category: s};

        // Supplements: Mode 1, Breakfast + Dinner
        expect(
          byCategory[NotificationCategory.supplements]?.schedulingMode,
          NotificationSchedulingMode.anchorEvents,
        );
        expect(
          byCategory[NotificationCategory.supplements]?.anchorEventValues,
          contains(AnchorEventName.breakfast.value),
        );
        expect(
          byCategory[NotificationCategory.supplements]?.anchorEventValues,
          contains(AnchorEventName.dinner.value),
        );

        // Fluids: Mode 2A, 2h interval
        expect(
          byCategory[NotificationCategory.fluids]?.schedulingMode,
          NotificationSchedulingMode.interval,
        );
        expect(byCategory[NotificationCategory.fluids]?.intervalHours, 2);

        // Journal: Mode 2B, 21:00
        expect(
          byCategory[NotificationCategory.journalEntries]?.schedulingMode,
          NotificationSchedulingMode.specificTimes,
        );
        expect(byCategory[NotificationCategory.journalEntries]?.specificTimes, [
          '21:00',
        ]);

        // BBT: Mode 1, Wake only
        expect(
          byCategory[NotificationCategory.bbtVitals]?.schedulingMode,
          NotificationSchedulingMode.anchorEvents,
        );
        expect(byCategory[NotificationCategory.bbtVitals]?.anchorEventValues, [
          AnchorEventName.wake.value,
        ]);
      });
    });
  });
}
