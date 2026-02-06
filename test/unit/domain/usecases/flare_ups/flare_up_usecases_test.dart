// test/unit/domain/usecases/flare_ups/flare_up_usecases_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/condition_repository.dart';
import 'package:shadow_app/domain/repositories/flare_up_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/flare_ups/delete_flare_up_use_case.dart';
import 'package:shadow_app/domain/usecases/flare_ups/end_flare_up_use_case.dart';
import 'package:shadow_app/domain/usecases/flare_ups/flare_up_inputs.dart';
import 'package:shadow_app/domain/usecases/flare_ups/get_flare_ups_use_case.dart';
import 'package:shadow_app/domain/usecases/flare_ups/log_flare_up_use_case.dart';
import 'package:shadow_app/domain/usecases/flare_ups/update_flare_up_use_case.dart';

@GenerateMocks([
  FlareUpRepository,
  ConditionRepository,
  ProfileAuthorizationService,
])
import 'flare_up_usecases_test.mocks.dart';

void main() {
  provideDummy<Result<List<FlareUp>, AppError>>(const Success([]));
  provideDummy<Result<void, AppError>>(const Success(null));

  const testProfileId = 'profile-001';
  const testClientId = 'client-001';

  final now = DateTime.now().millisecondsSinceEpoch;
  final startDate = now - (2 * 60 * 60 * 1000); // 2 hours ago

  Condition createTestCondition({
    String id = 'condition-001',
    String profileId = testProfileId,
  }) => Condition(
    id: id,
    clientId: testClientId,
    profileId: profileId,
    name: 'Eczema',
    category: 'Skin',
    bodyLocations: const ['arm'],
    startTimeframe: now - (30 * 24 * 60 * 60 * 1000), // 30 days ago
    syncMetadata: SyncMetadata.create(deviceId: 'test-device'),
  );

  FlareUp createTestFlareUp({
    String id = 'flareup-001',
    String profileId = testProfileId,
    String conditionId = 'condition-001',
    int? start,
    int? end,
    int severity = 5,
    String? notes,
    List<String> triggers = const [],
    SyncMetadata? syncMetadata,
  }) => FlareUp(
    id: id,
    clientId: testClientId,
    profileId: profileId,
    conditionId: conditionId,
    startDate: start ?? startDate,
    endDate: end,
    severity: severity,
    notes: notes,
    triggers: triggers,
    syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'test-device'),
  );

  provideDummy<Result<FlareUp, AppError>>(Success(createTestFlareUp()));
  provideDummy<Result<Condition, AppError>>(Success(createTestCondition()));

  group('LogFlareUpUseCase', () {
    late MockFlareUpRepository mockRepository;
    late MockConditionRepository mockConditionRepository;
    late MockProfileAuthorizationService mockAuthService;
    late LogFlareUpUseCase useCase;

    setUp(() {
      mockRepository = MockFlareUpRepository();
      mockConditionRepository = MockConditionRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = LogFlareUpUseCase(
        mockRepository,
        mockConditionRepository,
        mockAuthService,
      );
    });

    test('call_whenAuthorized_createsFlareUp', () async {
      final condition = createTestCondition();
      final expectedFlareUp = createTestFlareUp();

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockConditionRepository.getById('condition-001'),
      ).thenAnswer((_) async => Success(condition));
      when(
        mockRepository.create(any),
      ).thenAnswer((_) async => Success(expectedFlareUp));

      final result = await useCase(
        LogFlareUpInput(
          profileId: testProfileId,
          clientId: testClientId,
          conditionId: 'condition-001',
          startDate: startDate,
          severity: 5,
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
        LogFlareUpInput(
          profileId: testProfileId,
          clientId: testClientId,
          conditionId: 'condition-001',
          startDate: startDate,
          severity: 5,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenSeverityTooLow_returnsValidationError', () async {
      final condition = createTestCondition();

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockConditionRepository.getById('condition-001'),
      ).thenAnswer((_) async => Success(condition));

      final result = await useCase(
        LogFlareUpInput(
          profileId: testProfileId,
          clientId: testClientId,
          conditionId: 'condition-001',
          startDate: startDate,
          severity: 0, // Invalid (< 1)
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenSeverityTooHigh_returnsValidationError', () async {
      final condition = createTestCondition();

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockConditionRepository.getById('condition-001'),
      ).thenAnswer((_) async => Success(condition));

      final result = await useCase(
        LogFlareUpInput(
          profileId: testProfileId,
          clientId: testClientId,
          conditionId: 'condition-001',
          startDate: startDate,
          severity: 11, // Invalid (> 10)
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenConditionNotFound_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockConditionRepository.getById('condition-001')).thenAnswer(
        (_) async =>
            Failure(DatabaseError.notFound('Condition', 'condition-001')),
      );

      final result = await useCase(
        LogFlareUpInput(
          profileId: testProfileId,
          clientId: testClientId,
          conditionId: 'condition-001',
          startDate: startDate,
          severity: 5,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });

    test(
      'call_whenConditionBelongsToDifferentProfile_returnsValidationError',
      () async {
        final condition = createTestCondition(profileId: 'other-profile');

        when(
          mockAuthService.canWrite(testProfileId),
        ).thenAnswer((_) async => true);
        when(
          mockConditionRepository.getById('condition-001'),
        ).thenAnswer((_) async => Success(condition));

        final result = await useCase(
          LogFlareUpInput(
            profileId: testProfileId,
            clientId: testClientId,
            conditionId: 'condition-001',
            startDate: startDate,
            severity: 5,
          ),
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<ValidationError>());
        verifyNever(mockRepository.create(any));
      },
    );

    test('call_whenStartDateTooFarInFuture_returnsValidationError', () async {
      final condition = createTestCondition();
      final futureDate =
          DateTime.now().millisecondsSinceEpoch +
          (2 * 60 * 60 * 1000); // 2 hours in future

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockConditionRepository.getById('condition-001'),
      ).thenAnswer((_) async => Success(condition));

      final result = await useCase(
        LogFlareUpInput(
          profileId: testProfileId,
          clientId: testClientId,
          conditionId: 'condition-001',
          startDate: futureDate,
          severity: 5,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenEndDateBeforeStartDate_returnsValidationError', () async {
      final condition = createTestCondition();

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockConditionRepository.getById('condition-001'),
      ).thenAnswer((_) async => Success(condition));

      final result = await useCase(
        LogFlareUpInput(
          profileId: testProfileId,
          clientId: testClientId,
          conditionId: 'condition-001',
          startDate: startDate,
          endDate: startDate - (60 * 60 * 1000), // 1 hour before start
          severity: 5,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenTriggerTooLong_returnsValidationError', () async {
      final condition = createTestCondition();

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockConditionRepository.getById('condition-001'),
      ).thenAnswer((_) async => Success(condition));

      final result = await useCase(
        LogFlareUpInput(
          profileId: testProfileId,
          clientId: testClientId,
          conditionId: 'condition-001',
          startDate: startDate,
          severity: 5,
          triggers: ['A' * 101], // Too long (> 100 characters)
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });
  });

  group('GetFlareUpsUseCase', () {
    late MockFlareUpRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late GetFlareUpsUseCase useCase;

    setUp(() {
      mockRepository = MockFlareUpRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = GetFlareUpsUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_returnsFlareUps', () async {
      final flareUps = [createTestFlareUp()];

      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success(flareUps));

      final result = await useCase(
        const GetFlareUpsInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, equals(flareUps));
      verify(mockAuthService.canRead(testProfileId)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const GetFlareUpsInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.getByProfile(any));
    });

    test('call_withConditionId_callsGetByCondition', () async {
      final flareUps = [createTestFlareUp()];

      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByCondition('condition-001'),
      ).thenAnswer((_) async => Success(flareUps));

      final result = await useCase(
        const GetFlareUpsInput(
          profileId: testProfileId,
          conditionId: 'condition-001',
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepository.getByCondition('condition-001')).called(1);
      verifyNever(mockRepository.getByProfile(any));
    });
  });

  group('UpdateFlareUpUseCase', () {
    late MockFlareUpRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late UpdateFlareUpUseCase useCase;

    setUp(() {
      mockRepository = MockFlareUpRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = UpdateFlareUpUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_updatesFlareUp', () async {
      final existingFlareUp = createTestFlareUp();
      final updatedFlareUp = createTestFlareUp(severity: 7);

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('flareup-001'),
      ).thenAnswer((_) async => Success(existingFlareUp));
      when(
        mockRepository.update(any),
      ).thenAnswer((_) async => Success(updatedFlareUp));

      final result = await useCase(
        const UpdateFlareUpInput(
          id: 'flareup-001',
          profileId: testProfileId,
          severity: 7,
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockAuthService.canWrite(testProfileId)).called(1);
      verify(mockRepository.update(any)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const UpdateFlareUpInput(
          id: 'flareup-001',
          profileId: testProfileId,
          severity: 7,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.update(any));
    });

    test(
      'call_whenFlareUpBelongsToDifferentProfile_returnsAuthError',
      () async {
        final existingFlareUp = createTestFlareUp(profileId: 'other-profile');

        when(
          mockAuthService.canWrite(testProfileId),
        ).thenAnswer((_) async => true);
        when(
          mockRepository.getById('flareup-001'),
        ).thenAnswer((_) async => Success(existingFlareUp));

        final result = await useCase(
          const UpdateFlareUpInput(
            id: 'flareup-001',
            profileId: testProfileId,
            severity: 7,
          ),
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<AuthError>());
        verifyNever(mockRepository.update(any));
      },
    );
  });

  group('EndFlareUpUseCase', () {
    late MockFlareUpRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late EndFlareUpUseCase useCase;

    setUp(() {
      mockRepository = MockFlareUpRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = EndFlareUpUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_endsFlareUp', () async {
      final existingFlareUp = createTestFlareUp(); // No end date (ongoing)
      final endedFlareUp = createTestFlareUp(end: now);

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('flareup-001'),
      ).thenAnswer((_) async => Success(existingFlareUp));
      when(
        mockRepository.endFlareUp('flareup-001', now),
      ).thenAnswer((_) async => Success(endedFlareUp));

      final result = await useCase(
        EndFlareUpInput(
          id: 'flareup-001',
          profileId: testProfileId,
          endDate: now,
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockAuthService.canWrite(testProfileId)).called(1);
      verify(mockRepository.endFlareUp('flareup-001', now)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        EndFlareUpInput(
          id: 'flareup-001',
          profileId: testProfileId,
          endDate: now,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.endFlareUp(any, any));
    });

    test('call_whenFlareUpAlreadyEnded_returnsValidationError', () async {
      final existingFlareUp = createTestFlareUp(
        end: now - (60 * 60 * 1000),
      ); // Already ended

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('flareup-001'),
      ).thenAnswer((_) async => Success(existingFlareUp));

      final result = await useCase(
        EndFlareUpInput(
          id: 'flareup-001',
          profileId: testProfileId,
          endDate: now,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.endFlareUp(any, any));
    });

    test('call_whenEndDateBeforeStartDate_returnsValidationError', () async {
      final existingFlareUp = createTestFlareUp(); // No end date (ongoing)

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('flareup-001'),
      ).thenAnswer((_) async => Success(existingFlareUp));

      final result = await useCase(
        EndFlareUpInput(
          id: 'flareup-001',
          profileId: testProfileId,
          endDate: startDate - (60 * 60 * 1000), // Before start
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.endFlareUp(any, any));
    });
  });

  group('DeleteFlareUpUseCase', () {
    late MockFlareUpRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late DeleteFlareUpUseCase useCase;

    setUp(() {
      mockRepository = MockFlareUpRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = DeleteFlareUpUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_deletesFlareUp', () async {
      final existingFlareUp = createTestFlareUp();

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('flareup-001'),
      ).thenAnswer((_) async => Success(existingFlareUp));
      when(
        mockRepository.delete('flareup-001'),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase(
        const DeleteFlareUpInput(id: 'flareup-001', profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      verify(mockAuthService.canWrite(testProfileId)).called(1);
      verify(mockRepository.delete('flareup-001')).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const DeleteFlareUpInput(id: 'flareup-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.delete(any));
    });

    test(
      'call_whenFlareUpBelongsToDifferentProfile_returnsAuthError',
      () async {
        final existingFlareUp = createTestFlareUp(profileId: 'other-profile');

        when(
          mockAuthService.canWrite(testProfileId),
        ).thenAnswer((_) async => true);
        when(
          mockRepository.getById('flareup-001'),
        ).thenAnswer((_) async => Success(existingFlareUp));

        final result = await useCase(
          const DeleteFlareUpInput(id: 'flareup-001', profileId: testProfileId),
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<AuthError>());
        verifyNever(mockRepository.delete(any));
      },
    );
  });
}
