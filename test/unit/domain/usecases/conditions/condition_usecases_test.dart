// test/unit/domain/usecases/conditions/condition_usecases_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/condition_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/conditions/archive_condition_use_case.dart';
import 'package:shadow_app/domain/usecases/conditions/condition_inputs.dart';
import 'package:shadow_app/domain/usecases/conditions/create_condition_use_case.dart';
import 'package:shadow_app/domain/usecases/conditions/get_conditions_use_case.dart';
import 'package:shadow_app/domain/usecases/conditions/update_condition_use_case.dart';

@GenerateMocks([ConditionRepository, ProfileAuthorizationService])
import 'condition_usecases_test.mocks.dart';

void main() {
  // Provide dummy values for Result types
  provideDummy<Result<List<Condition>, AppError>>(const Success([]));
  provideDummy<Result<Condition, AppError>>(
    const Success(
      Condition(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        name: 'Dummy',
        category: 'skin',
        bodyLocations: [],
        startTimeframe: 0,
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));

  const testProfileId = 'profile-001';

  Condition createTestCondition({
    String id = 'cond-001',
    String clientId = 'client-001',
    String profileId = testProfileId,
    String name = 'Test Condition',
    String category = 'skin',
    List<String> bodyLocations = const ['arm'],
    String? description,
    String? baselinePhotoPath,
    int startTimeframe = 1704067200000,
    int? endDate,
    ConditionStatus status = ConditionStatus.active,
    bool isArchived = false,
    SyncMetadata? syncMetadata,
  }) => Condition(
    id: id,
    clientId: clientId,
    profileId: profileId,
    name: name,
    category: category,
    bodyLocations: bodyLocations,
    description: description,
    baselinePhotoPath: baselinePhotoPath,
    startTimeframe: startTimeframe,
    endDate: endDate,
    status: status,
    isArchived: isArchived,
    syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'test-device'),
  );

  group('GetConditionsUseCase', () {
    late MockConditionRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late GetConditionsUseCase useCase;

    setUp(() {
      mockRepository = MockConditionRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = GetConditionsUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_returnsConditions', () async {
      final conditions = [createTestCondition()];
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success(conditions));

      final result = await useCase(
        const GetConditionsInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, conditions);
      verify(mockAuthService.canRead(testProfileId)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const GetConditionsInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(
        mockRepository.getByProfile(
          any,
          status: anyNamed('status'),
          includeArchived: anyNamed('includeArchived'),
        ),
      );
    });

    test('call_withStatusFilter_passesToRepository', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(
          testProfileId,
          status: ConditionStatus.active,
        ),
      ).thenAnswer((_) async => const Success([]));

      await useCase(
        const GetConditionsInput(
          profileId: testProfileId,
          status: ConditionStatus.active,
        ),
      );

      verify(
        mockRepository.getByProfile(
          testProfileId,
          status: ConditionStatus.active,
        ),
      ).called(1);
    });

    test('call_withIncludeArchived_passesToRepository', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(testProfileId, includeArchived: true),
      ).thenAnswer((_) async => const Success([]));

      await useCase(
        const GetConditionsInput(
          profileId: testProfileId,
          includeArchived: true,
        ),
      );

      verify(
        mockRepository.getByProfile(testProfileId, includeArchived: true),
      ).called(1);
    });
  });

  group('CreateConditionUseCase', () {
    late MockConditionRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late CreateConditionUseCase useCase;

    setUp(() {
      mockRepository = MockConditionRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = CreateConditionUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorizedAndValid_createsCondition', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.create(any),
      ).thenAnswer((_) async => Success(createTestCondition()));

      final result = await useCase(
        const CreateConditionInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: 'Eczema',
          category: 'skin',
          startTimeframe: 1704067200000,
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepository.create(any)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const CreateConditionInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: 'Eczema',
          category: 'skin',
          startTimeframe: 1704067200000,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_withEmptyName_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        const CreateConditionInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: '',
          category: 'skin',
          startTimeframe: 1704067200000,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });

    test('call_withEmptyCategory_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        const CreateConditionInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: 'Eczema',
          category: '',
          startTimeframe: 1704067200000,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });

    test('call_withInvalidStartTimeframe_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        const CreateConditionInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: 'Eczema',
          category: 'skin',
          startTimeframe: 0,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });

    test('call_withEndDateBeforeStartDate_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        const CreateConditionInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: 'Eczema',
          category: 'skin',
          startTimeframe: 1704153600000,
          endDate: 1704067200000, // Before start
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });
  });

  group('ArchiveConditionUseCase', () {
    late MockConditionRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late ArchiveConditionUseCase useCase;

    setUp(() {
      mockRepository = MockConditionRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = ArchiveConditionUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorizedAndValid_archivesCondition', () async {
      final existing = createTestCondition();
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('cond-001'),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockRepository.update(any),
      ).thenAnswer((_) async => Success(existing.copyWith(isArchived: true)));

      final result = await useCase(
        const ArchiveConditionInput(
          id: 'cond-001',
          profileId: testProfileId,
          archive: true,
        ),
      );

      expect(result.isSuccess, isTrue);
      final captured = verify(
        mockRepository.update(captureAny),
      ).captured.single;
      expect((captured as Condition).isArchived, isTrue);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const ArchiveConditionInput(
          id: 'cond-001',
          profileId: testProfileId,
          archive: true,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.update(any));
    });

    test('call_whenConditionNotFound_returnsFailure', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.getById('cond-001')).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('Condition', 'cond-001')),
      );

      final result = await useCase(
        const ArchiveConditionInput(
          id: 'cond-001',
          profileId: testProfileId,
          archive: true,
        ),
      );

      expect(result.isFailure, isTrue);
    });

    test(
      'call_whenConditionBelongsToDifferentProfile_returnsAuthError',
      () async {
        final existing = createTestCondition(profileId: 'different-profile');
        when(
          mockAuthService.canWrite(testProfileId),
        ).thenAnswer((_) async => true);
        when(
          mockRepository.getById('cond-001'),
        ).thenAnswer((_) async => Success(existing));

        final result = await useCase(
          const ArchiveConditionInput(
            id: 'cond-001',
            profileId: testProfileId,
            archive: true,
          ),
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<AuthError>());
      },
    );
  });

  group('UpdateConditionUseCase', () {
    late MockConditionRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late UpdateConditionUseCase useCase;

    setUp(() {
      mockRepository = MockConditionRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = UpdateConditionUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorizedAndValid_updatesCondition', () async {
      final existing = createTestCondition();
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('cond-001'),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockRepository.update(any),
      ).thenAnswer((_) async => Success(existing));

      final result = await useCase(
        const UpdateConditionInput(
          id: 'cond-001',
          profileId: testProfileId,
          name: 'Updated Name',
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
        const UpdateConditionInput(id: 'cond-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.getById(any));
    });

    test('call_whenConditionBelongsToOtherProfile_returnsAuthError', () async {
      final existing = createTestCondition(profileId: 'other-profile');
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('cond-001'),
      ).thenAnswer((_) async => Success(existing));

      final result = await useCase(
        const UpdateConditionInput(id: 'cond-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.update(any));
    });

    test('call_withEmptyName_returnsValidationError', () async {
      final existing = createTestCondition();
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('cond-001'),
      ).thenAnswer((_) async => Success(existing));

      final result = await useCase(
        const UpdateConditionInput(
          id: 'cond-001',
          profileId: testProfileId,
          name: '',
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });

    test('call_mergesOnlyProvidedFields', () async {
      final existing = createTestCondition(name: 'Original');
      Condition? captured;
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('cond-001'),
      ).thenAnswer((_) async => Success(existing));
      when(mockRepository.update(any)).thenAnswer((inv) async {
        captured = inv.positionalArguments.first as Condition;
        return Success(captured!);
      });

      await useCase(
        const UpdateConditionInput(
          id: 'cond-001',
          profileId: testProfileId,
          name: 'New Name',
          // category not provided — should keep existing
        ),
      );

      expect(captured?.name, 'New Name');
      expect(captured?.category, 'skin');
    });
  });
}
