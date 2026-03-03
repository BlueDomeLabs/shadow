// test/unit/domain/usecases/fluids_entries/fluids_entry_usecases_test.dart
// AUDIT-07-002: Unit tests for all four fluids entry use cases.
// Pattern matches supplement_usecases_test.dart.

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/fluids_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/fluids_entries/delete_fluids_entry_use_case.dart';
import 'package:shadow_app/domain/usecases/fluids_entries/fluids_entry_inputs.dart';
import 'package:shadow_app/domain/usecases/fluids_entries/get_fluids_entries_use_case.dart';
import 'package:shadow_app/domain/usecases/fluids_entries/log_fluids_entry_use_case.dart';
import 'package:shadow_app/domain/usecases/fluids_entries/update_fluids_entry_use_case.dart';

@GenerateMocks([FluidsEntryRepository, ProfileAuthorizationService])
import 'fluids_entry_usecases_test.mocks.dart';

// =============================================================================
// Test helpers
// =============================================================================

void main() {
  // Register dummy values for sealed Result types
  provideDummy<Result<List<FluidsEntry>, AppError>>(const Success([]));
  provideDummy<Result<FluidsEntry, AppError>>(
    const Success(
      FluidsEntry(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        entryDate: 0,
        waterIntakeMl: 500,
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<FluidsEntry?, AppError>>(const Success(null));
  provideDummy<Result<void, AppError>>(const Success(null));

  const testProfileId = 'profile-001';
  const testEntryId = 'entry-001';
  const testEntryDate = 1700000000000;

  FluidsEntry createTestEntry({
    String id = testEntryId,
    String profileId = testProfileId,
    int waterIntakeMl = 500,
    SyncMetadata? syncMetadata,
  }) => FluidsEntry(
    id: id,
    clientId: id,
    profileId: profileId,
    entryDate: testEntryDate,
    waterIntakeMl: waterIntakeMl,
    syncMetadata:
        syncMetadata ??
        const SyncMetadata(
          syncCreatedAt: testEntryDate,
          syncUpdatedAt: testEntryDate,
          syncDeviceId: 'test-device',
        ),
  );

  // ===========================================================================
  // LogFluidsEntryUseCase
  // ===========================================================================

  group('LogFluidsEntryUseCase', () {
    late MockFluidsEntryRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late LogFluidsEntryUseCase useCase;

    setUp(() {
      mockRepository = MockFluidsEntryRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = LogFluidsEntryUseCase(mockRepository, mockAuthService);
    });

    test('happy path — creates entry and returns success', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.create(any),
      ).thenAnswer((_) async => Success(createTestEntry()));

      const input = LogFluidsEntryInput(
        profileId: testProfileId,
        clientId: 'client-001',
        entryDate: testEntryDate,
        waterIntakeMl: 500,
      );

      final result = await useCase(input);

      expect(result.isSuccess, isTrue);
      verify(mockRepository.create(any)).called(1);
    });

    test(
      'auth failure — returns profileAccessDenied without calling repository',
      () async {
        when(
          mockAuthService.canWrite(testProfileId),
        ).thenAnswer((_) async => false);

        const input = LogFluidsEntryInput(
          profileId: testProfileId,
          clientId: 'client-001',
          entryDate: testEntryDate,
          waterIntakeMl: 500,
        );

        final result = await useCase(input);

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<AuthError>());
        verifyNever(mockRepository.create(any));
      },
    );

    test('repository failure — propagates error', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.create(any)).thenAnswer(
        (_) async => Failure(
          DatabaseError.insertFailed('fluids_entries', Exception('db error')),
        ),
      );

      const input = LogFluidsEntryInput(
        profileId: testProfileId,
        clientId: 'client-001',
        entryDate: testEntryDate,
        waterIntakeMl: 500,
      );

      final result = await useCase(input);

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<DatabaseError>());
    });

    test(
      'validation failure — all measurements null returns ValidationError',
      () async {
        when(
          mockAuthService.canWrite(testProfileId),
        ).thenAnswer((_) async => true);

        // No measurements provided at all
        const input = LogFluidsEntryInput(
          profileId: testProfileId,
          clientId: 'client-001',
          entryDate: testEntryDate,
        );

        final result = await useCase(input);

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<ValidationError>());
        verifyNever(mockRepository.create(any));
      },
    );

    test('validation failure — BBT without recorded time fails', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      const input = LogFluidsEntryInput(
        profileId: testProfileId,
        clientId: 'client-001',
        entryDate: testEntryDate,
        basalBodyTemperature: 98.6, // BBT provided but no bbtRecordedTime
      );

      final result = await useCase(input);

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });
  });

  // ===========================================================================
  // UpdateFluidsEntryUseCase
  // ===========================================================================

  group('UpdateFluidsEntryUseCase', () {
    late MockFluidsEntryRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late UpdateFluidsEntryUseCase useCase;

    setUp(() {
      mockRepository = MockFluidsEntryRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = UpdateFluidsEntryUseCase(mockRepository, mockAuthService);
    });

    test('happy path — updates entry and returns success', () async {
      final existing = createTestEntry();
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById(testEntryId),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockRepository.update(any),
      ).thenAnswer((_) async => Success(createTestEntry(waterIntakeMl: 750)));

      const input = UpdateFluidsEntryInput(
        id: testEntryId,
        profileId: testProfileId,
        waterIntakeMl: 750,
      );

      final result = await useCase(input);

      expect(result.isSuccess, isTrue);
      verify(mockRepository.update(any)).called(1);
    });

    test('not found — getById failure propagates', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.getById(testEntryId)).thenAnswer(
        (_) async =>
            Failure(DatabaseError.notFound('FluidsEntry', testEntryId)),
      );

      const input = UpdateFluidsEntryInput(
        id: testEntryId,
        profileId: testProfileId,
        waterIntakeMl: 750,
      );

      final result = await useCase(input);

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<DatabaseError>());
      verifyNever(mockRepository.update(any));
    });

    test(
      'auth failure — returns profileAccessDenied without fetching entity',
      () async {
        when(
          mockAuthService.canWrite(testProfileId),
        ).thenAnswer((_) async => false);

        const input = UpdateFluidsEntryInput(
          id: testEntryId,
          profileId: testProfileId,
          waterIntakeMl: 750,
        );

        final result = await useCase(input);

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<AuthError>());
        verifyNever(mockRepository.getById(any));
      },
    );

    test(
      'wrong profile — returns auth error when entity belongs to different profile',
      () async {
        final existing = createTestEntry(profileId: 'profile-other');
        when(
          mockAuthService.canWrite(testProfileId),
        ).thenAnswer((_) async => true);
        when(
          mockRepository.getById(testEntryId),
        ).thenAnswer((_) async => Success(existing));

        const input = UpdateFluidsEntryInput(
          id: testEntryId,
          profileId: testProfileId,
          waterIntakeMl: 750,
        );

        final result = await useCase(input);

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<AuthError>());
      },
    );
  });

  // ===========================================================================
  // DeleteFluidsEntryUseCase
  // ===========================================================================

  group('DeleteFluidsEntryUseCase', () {
    late MockFluidsEntryRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late DeleteFluidsEntryUseCase useCase;

    setUp(() {
      mockRepository = MockFluidsEntryRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = DeleteFluidsEntryUseCase(mockRepository, mockAuthService);
    });

    test('happy path — soft deletes entry and returns success', () async {
      final existing = createTestEntry();
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById(testEntryId),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockRepository.delete(testEntryId),
      ).thenAnswer((_) async => const Success(null));

      const input = DeleteFluidsEntryInput(
        id: testEntryId,
        profileId: testProfileId,
      );

      final result = await useCase(input);

      expect(result.isSuccess, isTrue);
      verify(mockRepository.delete(testEntryId)).called(1);
    });

    test('not found — getById failure propagates', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.getById(testEntryId)).thenAnswer(
        (_) async =>
            Failure(DatabaseError.notFound('FluidsEntry', testEntryId)),
      );

      const input = DeleteFluidsEntryInput(
        id: testEntryId,
        profileId: testProfileId,
      );

      final result = await useCase(input);

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<DatabaseError>());
      verifyNever(mockRepository.delete(any));
    });

    test('auth failure — returns profileAccessDenied', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      const input = DeleteFluidsEntryInput(
        id: testEntryId,
        profileId: testProfileId,
      );

      final result = await useCase(input);

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.delete(any));
    });

    test('wrong profile — returns auth error', () async {
      final existing = createTestEntry(profileId: 'profile-other');
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById(testEntryId),
      ).thenAnswer((_) async => Success(existing));

      const input = DeleteFluidsEntryInput(
        id: testEntryId,
        profileId: testProfileId,
      );

      final result = await useCase(input);

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });
  });

  // ===========================================================================
  // GetFluidsEntriesUseCase
  // ===========================================================================

  group('GetFluidsEntriesUseCase', () {
    late MockFluidsEntryRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late GetFluidsEntriesUseCase useCase;

    const start = 1700000000000;
    const end = 1700086400000;

    setUp(() {
      mockRepository = MockFluidsEntryRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = GetFluidsEntriesUseCase(mockRepository, mockAuthService);
    });

    test('happy path — returns list of entries', () async {
      final entries = [createTestEntry(), createTestEntry(id: 'entry-002')];
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByDateRange(testProfileId, start, end),
      ).thenAnswer((_) async => Success(entries));

      const input = GetFluidsEntriesInput(
        profileId: testProfileId,
        startDate: start,
        endDate: end,
      );

      final result = await useCase(input);

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull!.length, 2);
    });

    test('empty result — returns empty list', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByDateRange(testProfileId, start, end),
      ).thenAnswer((_) async => const Success([]));

      final result = await useCase(
        const GetFluidsEntriesInput(
          profileId: testProfileId,
          startDate: start,
          endDate: end,
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, isEmpty);
    });

    test('repository failure — propagates error', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.getByDateRange(testProfileId, start, end)).thenAnswer(
        (_) async => Failure(
          DatabaseError.queryFailed('fluids_entries', Exception('db error')),
        ),
      );

      final result = await useCase(
        const GetFluidsEntriesInput(
          profileId: testProfileId,
          startDate: start,
          endDate: end,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<DatabaseError>());
    });

    test('auth failure — returns profileAccessDenied', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const GetFluidsEntriesInput(
          profileId: testProfileId,
          startDate: start,
          endDate: end,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.getByDateRange(any, any, any));
    });

    test(
      'validation failure — start after end returns ValidationError',
      () async {
        when(
          mockAuthService.canRead(testProfileId),
        ).thenAnswer((_) async => true);

        final result = await useCase(
          const GetFluidsEntriesInput(
            profileId: testProfileId,
            startDate: end, // swapped
            endDate: start,
          ),
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<ValidationError>());
        verifyNever(mockRepository.getByDateRange(any, any, any));
      },
    );
  });
}
