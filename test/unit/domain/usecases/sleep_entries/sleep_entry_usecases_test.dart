// test/unit/domain/usecases/sleep_entries/sleep_entry_usecases_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/sleep_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/sleep_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/sleep_entries/delete_sleep_entry_use_case.dart';
import 'package:shadow_app/domain/usecases/sleep_entries/get_sleep_entries_use_case.dart';
import 'package:shadow_app/domain/usecases/sleep_entries/log_sleep_entry_use_case.dart';
import 'package:shadow_app/domain/usecases/sleep_entries/sleep_entry_inputs.dart';
import 'package:shadow_app/domain/usecases/sleep_entries/update_sleep_entry_use_case.dart';

@GenerateMocks([SleepEntryRepository, ProfileAuthorizationService])
import 'sleep_entry_usecases_test.mocks.dart';

void main() {
  // Provide dummy values for Result types
  provideDummy<Result<List<SleepEntry>, AppError>>(const Success([]));
  provideDummy<Result<SleepEntry?, AppError>>(const Success(null));
  provideDummy<Result<Map<String, double>, AppError>>(const Success({}));
  provideDummy<Result<void, AppError>>(const Success(null));

  const testProfileId = 'profile-001';
  const testClientId = 'client-001';

  // Use dynamic times relative to now for validation to pass
  // Bed time: 10 hours ago, Wake time: 2 hours ago (8 hours of sleep)
  final now = DateTime.now().millisecondsSinceEpoch;
  final baseTime = now - (10 * 60 * 60 * 1000); // 10 hours ago
  final wakeTime = now - (2 * 60 * 60 * 1000); // 2 hours ago

  SleepEntry createTestSleepEntry({
    String id = 'sleep-001',
    String clientId = testClientId,
    String profileId = testProfileId,
    int? bedTime,
    int? wakeTimeValue,
    int deepSleepMinutes = 90,
    int lightSleepMinutes = 240,
    int restlessSleepMinutes = 30,
    DreamType dreamType = DreamType.noDreams,
    WakingFeeling wakingFeeling = WakingFeeling.neutral,
    String? notes,
    String? timeToFallAsleep,
    int? timesAwakened,
    String? timeAwakeDuringNight,
    String? importSource,
    String? importExternalId,
    SyncMetadata? syncMetadata,
  }) => SleepEntry(
    id: id,
    clientId: clientId,
    profileId: profileId,
    bedTime: bedTime ?? baseTime,
    wakeTime: wakeTimeValue ?? wakeTime,
    deepSleepMinutes: deepSleepMinutes,
    lightSleepMinutes: lightSleepMinutes,
    restlessSleepMinutes: restlessSleepMinutes,
    dreamType: dreamType,
    wakingFeeling: wakingFeeling,
    notes: notes,
    timeToFallAsleep: timeToFallAsleep,
    timesAwakened: timesAwakened,
    timeAwakeDuringNight: timeAwakeDuringNight,
    importSource: importSource,
    importExternalId: importExternalId,
    syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'test-device'),
  );

  // Provide dummy SleepEntry for Result types that need it
  provideDummy<Result<SleepEntry, AppError>>(Success(createTestSleepEntry()));

  group('LogSleepEntryUseCase', () {
    late MockSleepEntryRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late LogSleepEntryUseCase useCase;

    setUp(() {
      mockRepository = MockSleepEntryRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = LogSleepEntryUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_createsSleepEntry', () async {
      final expectedEntry = createTestSleepEntry();
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.create(any),
      ).thenAnswer((_) async => Success(expectedEntry));

      final result = await useCase(
        LogSleepEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          bedTime: baseTime,
          wakeTime: wakeTime,
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockAuthService.canWrite(testProfileId)).called(1);
      verify(mockRepository.create(any)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        LogSleepEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          bedTime: baseTime,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenWakeTimeBeforeBedTime_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        LogSleepEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          bedTime: wakeTime, // Swap times so wake is before bed
          wakeTime: baseTime,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenSleepExceeds24Hours_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        LogSleepEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          bedTime: baseTime,
          wakeTime: baseTime + (25 * 60 * 60 * 1000), // 25 hours later
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenNegativeSleepMinutes_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        LogSleepEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          bedTime: baseTime,
          deepSleepMinutes: -10,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenSleepStagesExceedTotal_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      // 8 hours = 480 minutes total sleep
      final result = await useCase(
        LogSleepEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          bedTime: baseTime,
          wakeTime: wakeTime, // 8 hours later
          deepSleepMinutes: 300,
          lightSleepMinutes: 300,
          restlessSleepMinutes: 100, // Total: 700 > 480
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_withSleepQualityFields_passesFieldsToEntity', () async {
      SleepEntry? captured;
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.create(any)).thenAnswer((inv) async {
        captured = inv.positionalArguments.first as SleepEntry;
        return Success(captured!);
      });

      await useCase(
        LogSleepEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          bedTime: baseTime,
          wakeTime: wakeTime,
          timeToFallAsleep: '15 min',
          timesAwakened: 2,
          timeAwakeDuringNight: '30 min',
        ),
      );

      expect(captured?.timeToFallAsleep, '15 min');
      expect(captured?.timesAwakened, 2);
      expect(captured?.timeAwakeDuringNight, '30 min');
    });
  });

  group('GetSleepEntriesUseCase', () {
    late MockSleepEntryRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late GetSleepEntriesUseCase useCase;

    setUp(() {
      mockRepository = MockSleepEntryRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = GetSleepEntriesUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_returnsEntries', () async {
      final entries = [createTestSleepEntry()];
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success(entries));

      final result = await useCase(
        const GetSleepEntriesInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, entries);
      verify(mockAuthService.canRead(testProfileId)).called(1);
      verify(mockRepository.getByProfile(testProfileId)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const GetSleepEntriesInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.getByProfile(any));
    });

    test('call_whenStartDateAfterEndDate_returnsValidationError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        GetSleepEntriesInput(
          profileId: testProfileId,
          startDate: wakeTime,
          endDate: baseTime,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.getByProfile(any));
    });

    test('call_passesDateRangeToRepository', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(
          testProfileId,
          startDate: baseTime,
          endDate: wakeTime,
        ),
      ).thenAnswer((_) async => const Success([]));

      await useCase(
        GetSleepEntriesInput(
          profileId: testProfileId,
          startDate: baseTime,
          endDate: wakeTime,
        ),
      );

      verify(
        mockRepository.getByProfile(
          testProfileId,
          startDate: baseTime,
          endDate: wakeTime,
        ),
      ).called(1);
    });
  });

  group('GetSleepEntryForNightUseCase', () {
    late MockSleepEntryRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late GetSleepEntryForNightUseCase useCase;

    setUp(() {
      mockRepository = MockSleepEntryRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = GetSleepEntryForNightUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_returnsEntry', () async {
      final entry = createTestSleepEntry();
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getForNight(testProfileId, baseTime),
      ).thenAnswer((_) async => Success(entry));

      final result = await useCase(
        GetSleepEntryForNightInput(profileId: testProfileId, date: baseTime),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, entry);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        GetSleepEntryForNightInput(profileId: testProfileId, date: baseTime),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });
  });

  group('GetSleepAveragesUseCase', () {
    late MockSleepEntryRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late GetSleepAveragesUseCase useCase;

    setUp(() {
      mockRepository = MockSleepEntryRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = GetSleepAveragesUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_returnsAverages', () async {
      final averages = {'totalSleep': 480.0, 'deepSleep': 90.0};
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getAverages(
          testProfileId,
          startDate: baseTime,
          endDate: wakeTime,
        ),
      ).thenAnswer((_) async => Success(averages));

      final result = await useCase(
        GetSleepAveragesInput(
          profileId: testProfileId,
          startDate: baseTime,
          endDate: wakeTime,
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, averages);
    });

    test('call_whenStartDateAfterEndDate_returnsValidationError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        GetSleepAveragesInput(
          profileId: testProfileId,
          startDate: wakeTime,
          endDate: baseTime,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });
  });

  group('UpdateSleepEntryUseCase', () {
    late MockSleepEntryRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late UpdateSleepEntryUseCase useCase;

    setUp(() {
      mockRepository = MockSleepEntryRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = UpdateSleepEntryUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_updatesEntry', () async {
      final existing = createTestSleepEntry();
      final updated = existing.copyWith(notes: 'Updated notes');

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('sleep-001'),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockRepository.update(any),
      ).thenAnswer((_) async => Success(updated));

      final result = await useCase(
        const UpdateSleepEntryInput(
          id: 'sleep-001',
          profileId: testProfileId,
          notes: 'Updated notes',
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepository.update(any)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const UpdateSleepEntryInput(id: 'sleep-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.getById(any));
    });

    test('call_whenEntryNotFound_returnsNotFoundError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.getById('sleep-001')).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('SleepEntry', 'sleep-001')),
      );

      final result = await useCase(
        const UpdateSleepEntryInput(id: 'sleep-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<DatabaseError>());
      verifyNever(mockRepository.update(any));
    });

    test('call_whenEntryBelongsToDifferentProfile_returnsAuthError', () async {
      final existing = createTestSleepEntry(profileId: 'other-profile');

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('sleep-001'),
      ).thenAnswer((_) async => Success(existing));

      final result = await useCase(
        const UpdateSleepEntryInput(id: 'sleep-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.update(any));
    });

    test('call_withSleepQualityFields_updatesFields', () async {
      final existing = createTestSleepEntry();
      SleepEntry? captured;
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('sleep-001'),
      ).thenAnswer((_) async => Success(existing));
      when(mockRepository.update(any)).thenAnswer((inv) async {
        captured = inv.positionalArguments.first as SleepEntry;
        return Success(captured!);
      });

      await useCase(
        const UpdateSleepEntryInput(
          id: 'sleep-001',
          profileId: testProfileId,
          timeToFallAsleep: '30 min',
          timesAwakened: 3,
          timeAwakeDuringNight: '1 hour',
        ),
      );

      expect(captured?.timeToFallAsleep, '30 min');
      expect(captured?.timesAwakened, 3);
      expect(captured?.timeAwakeDuringNight, '1 hour');
    });

    test('call_withNullTimeToFallAsleep_clearsField', () async {
      final existing = createTestSleepEntry(timeToFallAsleep: '15 min');
      SleepEntry? captured;
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('sleep-001'),
      ).thenAnswer((_) async => Success(existing));
      when(mockRepository.update(any)).thenAnswer((inv) async {
        captured = inv.positionalArguments.first as SleepEntry;
        return Success(captured!);
      });

      // Not providing timeToFallAsleep (defaults to null) clears the field
      await useCase(
        const UpdateSleepEntryInput(id: 'sleep-001', profileId: testProfileId),
      );

      expect(captured?.timeToFallAsleep, isNull);
    });
  });

  group('DeleteSleepEntryUseCase', () {
    late MockSleepEntryRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late DeleteSleepEntryUseCase useCase;

    setUp(() {
      mockRepository = MockSleepEntryRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = DeleteSleepEntryUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_deletesEntry', () async {
      final existing = createTestSleepEntry();

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('sleep-001'),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockRepository.delete('sleep-001'),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase(
        const DeleteSleepEntryInput(id: 'sleep-001', profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepository.delete('sleep-001')).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const DeleteSleepEntryInput(id: 'sleep-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.delete(any));
    });

    test('call_whenEntryNotFound_returnsNotFoundError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.getById('sleep-001')).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('SleepEntry', 'sleep-001')),
      );

      final result = await useCase(
        const DeleteSleepEntryInput(id: 'sleep-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<DatabaseError>());
      verifyNever(mockRepository.delete(any));
    });

    test('call_whenEntryBelongsToDifferentProfile_returnsAuthError', () async {
      final existing = createTestSleepEntry(profileId: 'other-profile');

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('sleep-001'),
      ).thenAnswer((_) async => Success(existing));

      final result = await useCase(
        const DeleteSleepEntryInput(id: 'sleep-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.delete(any));
    });
  });
}
