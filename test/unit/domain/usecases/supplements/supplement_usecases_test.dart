// test/unit/domain/usecases/supplements/supplement_usecases_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/supplement_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/supplements/archive_supplement_use_case.dart';
import 'package:shadow_app/domain/usecases/supplements/create_supplement_use_case.dart';
import 'package:shadow_app/domain/usecases/supplements/get_supplements_use_case.dart';
import 'package:shadow_app/domain/usecases/supplements/supplement_inputs.dart';
import 'package:shadow_app/domain/usecases/supplements/update_supplement_use_case.dart';

@GenerateMocks([SupplementRepository, ProfileAuthorizationService])
import 'supplement_usecases_test.mocks.dart';

void main() {
  // Provide dummy values for Result types
  provideDummy<Result<List<Supplement>, AppError>>(const Success([]));
  provideDummy<Result<Supplement, AppError>>(
    const Success(
      Supplement(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        name: 'Dummy',
        form: SupplementForm.capsule,
        dosageQuantity: 1,
        dosageUnit: DosageUnit.mg,
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

  Supplement createTestSupplement({
    String id = 'supp-001',
    String clientId = 'client-001',
    String profileId = testProfileId,
    String name = 'Test Supplement',
    SupplementForm form = SupplementForm.capsule,
    int dosageQuantity = 1,
    DosageUnit dosageUnit = DosageUnit.mg,
    String brand = '',
    String notes = '',
    bool isArchived = false,
    SyncMetadata? syncMetadata,
  }) => Supplement(
    id: id,
    clientId: clientId,
    profileId: profileId,
    name: name,
    form: form,
    dosageQuantity: dosageQuantity,
    dosageUnit: dosageUnit,
    brand: brand,
    notes: notes,
    isArchived: isArchived,
    syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'test-device'),
  );

  group('GetSupplementsUseCase', () {
    late MockSupplementRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late GetSupplementsUseCase useCase;

    setUp(() {
      mockRepository = MockSupplementRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = GetSupplementsUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_returnsSupplements', () async {
      final supplements = [createTestSupplement()];
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success(supplements));

      final result = await useCase(
        const GetSupplementsInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, supplements);
      verify(mockAuthService.canRead(testProfileId)).called(1);
      verify(mockRepository.getByProfile(testProfileId)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const GetSupplementsInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.getByProfile(any));
    });

    test('call_passesActiveOnlyToRepository', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(testProfileId, activeOnly: true),
      ).thenAnswer((_) async => const Success([]));

      await useCase(
        const GetSupplementsInput(profileId: testProfileId, activeOnly: true),
      );

      verify(
        mockRepository.getByProfile(testProfileId, activeOnly: true),
      ).called(1);
    });

    test('call_passesLimitAndOffsetToRepository', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(testProfileId, limit: 10, offset: 5),
      ).thenAnswer((_) async => const Success([]));

      await useCase(
        const GetSupplementsInput(
          profileId: testProfileId,
          limit: 10,
          offset: 5,
        ),
      );

      verify(
        mockRepository.getByProfile(testProfileId, limit: 10, offset: 5),
      ).called(1);
    });

    test('call_returnsRepositoryFailure', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.getByProfile(testProfileId)).thenAnswer(
        (_) async => Failure(DatabaseError.queryFailed('supplements', 'error')),
      );

      final result = await useCase(
        const GetSupplementsInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<DatabaseError>());
    });
  });

  group('CreateSupplementUseCase', () {
    late MockSupplementRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late CreateSupplementUseCase useCase;

    setUp(() {
      mockRepository = MockSupplementRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = CreateSupplementUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_createsAndReturnsSupplement', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.create(any)).thenAnswer((invocation) async {
        final supplement = invocation.positionalArguments[0] as Supplement;
        return Success(supplement.copyWith(id: 'generated-id'));
      });

      final result = await useCase(
        const CreateSupplementInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: 'New Supplement',
          form: SupplementForm.tablet,
          dosageQuantity: 1,
          dosageUnit: DosageUnit.mg,
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
        const CreateSupplementInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: 'New Supplement',
          form: SupplementForm.tablet,
          dosageQuantity: 1,
          dosageUnit: DosageUnit.mg,
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
        const CreateSupplementInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: '',
          form: SupplementForm.tablet,
          dosageQuantity: 1,
          dosageUnit: DosageUnit.mg,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_withShortName_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        const CreateSupplementInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: 'A', // Too short (min 2)
          form: SupplementForm.tablet,
          dosageQuantity: 1,
          dosageUnit: DosageUnit.mg,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });

    test('call_withOtherFormButNoCustomForm_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        const CreateSupplementInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: 'Custom Supplement',
          form: SupplementForm.other,
          dosageQuantity: 1,
          dosageUnit: DosageUnit.mg,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });

    test('call_withZeroDosageQuantity_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        const CreateSupplementInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: 'Test Supplement',
          form: SupplementForm.tablet,
          dosageQuantity: 0,
          dosageUnit: DosageUnit.mg,
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
        CreateSupplementInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: 'Test Supplement',
          form: SupplementForm.tablet,
          dosageQuantity: 1,
          dosageUnit: DosageUnit.mg,
          startDate: DateTime.utc(2026, 2, 10).millisecondsSinceEpoch,
          endDate: DateTime.utc(2026, 2).millisecondsSinceEpoch,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });

    test('call_setsCorrectFieldsOnSupplement', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      Supplement? capturedSupplement;
      when(mockRepository.create(any)).thenAnswer((invocation) async {
        capturedSupplement = invocation.positionalArguments[0] as Supplement;
        return Success(capturedSupplement!);
      });

      await useCase(
        const CreateSupplementInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: 'Vitamin D',
          form: SupplementForm.liquid,
          dosageQuantity: 2,
          dosageUnit: DosageUnit.iu,
          brand: 'Nature Made',
          notes: 'Take with food',
        ),
      );

      expect(capturedSupplement, isNotNull);
      expect(capturedSupplement!.profileId, testProfileId);
      expect(capturedSupplement!.clientId, 'client-001');
      expect(capturedSupplement!.name, 'Vitamin D');
      expect(capturedSupplement!.form, SupplementForm.liquid);
      expect(capturedSupplement!.dosageQuantity, 2);
      expect(capturedSupplement!.dosageUnit, DosageUnit.iu);
      expect(capturedSupplement!.brand, 'Nature Made');
      expect(capturedSupplement!.notes, 'Take with food');
      expect(capturedSupplement!.isArchived, isFalse);
    });
  });

  group('UpdateSupplementUseCase', () {
    late MockSupplementRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late UpdateSupplementUseCase useCase;

    setUp(() {
      mockRepository = MockSupplementRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = UpdateSupplementUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_updatesAndReturnsSupplement', () async {
      final existing = createTestSupplement();
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('supp-001'),
      ).thenAnswer((_) async => Success(existing));
      when(mockRepository.update(any)).thenAnswer((invocation) async {
        final updated = invocation.positionalArguments[0] as Supplement;
        return Success(updated);
      });

      final result = await useCase(
        const UpdateSupplementInput(
          id: 'supp-001',
          profileId: testProfileId,
          name: 'Updated Name',
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull!.name, 'Updated Name');
      verify(mockAuthService.canWrite(testProfileId)).called(1);
      verify(mockRepository.getById('supp-001')).called(1);
      verify(mockRepository.update(any)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const UpdateSupplementInput(
          id: 'supp-001',
          profileId: testProfileId,
          name: 'Updated Name',
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.getById(any));
    });

    test('call_whenSupplementNotFound_returnsFailure', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.getById('non-existent')).thenAnswer(
        (_) async =>
            Failure(DatabaseError.notFound('Supplement', 'non-existent')),
      );

      final result = await useCase(
        const UpdateSupplementInput(
          id: 'non-existent',
          profileId: testProfileId,
        ),
      );

      expect(result.isFailure, isTrue);
      verifyNever(mockRepository.update(any));
    });

    test('call_whenWrongProfile_returnsAuthError', () async {
      final existing = createTestSupplement(profileId: 'other-profile');
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('supp-001'),
      ).thenAnswer((_) async => Success(existing));

      final result = await useCase(
        const UpdateSupplementInput(id: 'supp-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.update(any));
    });

    test('call_withInvalidName_returnsValidationError', () async {
      final existing = createTestSupplement();
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('supp-001'),
      ).thenAnswer((_) async => Success(existing));

      final result = await useCase(
        const UpdateSupplementInput(
          id: 'supp-001',
          profileId: testProfileId,
          name: '', // Invalid
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.update(any));
    });

    test('call_preservesUnchangedFields', () async {
      final existing = createTestSupplement(
        name: 'Original Name',
        brand: 'Original Brand',
        notes: 'Original Notes',
      );
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('supp-001'),
      ).thenAnswer((_) async => Success(existing));

      Supplement? capturedSupplement;
      when(mockRepository.update(any)).thenAnswer((invocation) async {
        capturedSupplement = invocation.positionalArguments[0] as Supplement;
        return Success(capturedSupplement!);
      });

      await useCase(
        const UpdateSupplementInput(
          id: 'supp-001',
          profileId: testProfileId,
          name: 'New Name', // Only changing name
        ),
      );

      expect(capturedSupplement!.name, 'New Name');
      expect(capturedSupplement!.brand, 'Original Brand'); // Preserved
      expect(capturedSupplement!.notes, 'Original Notes'); // Preserved
    });
  });

  group('ArchiveSupplementUseCase', () {
    late MockSupplementRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late ArchiveSupplementUseCase useCase;

    setUp(() {
      mockRepository = MockSupplementRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = ArchiveSupplementUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_archivesSupplement', () async {
      final existing = createTestSupplement();
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('supp-001'),
      ).thenAnswer((_) async => Success(existing));
      when(mockRepository.update(any)).thenAnswer((invocation) async {
        final updated = invocation.positionalArguments[0] as Supplement;
        return Success(updated);
      });

      final result = await useCase(
        const ArchiveSupplementInput(
          id: 'supp-001',
          profileId: testProfileId,
          archive: true,
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull!.isArchived, isTrue);
    });

    test('call_whenAuthorized_unarchivesSupplement', () async {
      final existing = createTestSupplement(isArchived: true);
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('supp-001'),
      ).thenAnswer((_) async => Success(existing));
      when(mockRepository.update(any)).thenAnswer((invocation) async {
        final updated = invocation.positionalArguments[0] as Supplement;
        return Success(updated);
      });

      final result = await useCase(
        const ArchiveSupplementInput(
          id: 'supp-001',
          profileId: testProfileId,
          archive: false,
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull!.isArchived, isFalse);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const ArchiveSupplementInput(
          id: 'supp-001',
          profileId: testProfileId,
          archive: true,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.getById(any));
    });

    test('call_whenSupplementNotFound_returnsFailure', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.getById('non-existent')).thenAnswer(
        (_) async =>
            Failure(DatabaseError.notFound('Supplement', 'non-existent')),
      );

      final result = await useCase(
        const ArchiveSupplementInput(
          id: 'non-existent',
          profileId: testProfileId,
          archive: true,
        ),
      );

      expect(result.isFailure, isTrue);
      verifyNever(mockRepository.update(any));
    });

    test('call_whenWrongProfile_returnsAuthError', () async {
      final existing = createTestSupplement(profileId: 'other-profile');
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('supp-001'),
      ).thenAnswer((_) async => Success(existing));

      final result = await useCase(
        const ArchiveSupplementInput(
          id: 'supp-001',
          profileId: testProfileId,
          archive: true,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.update(any));
    });
  });
}
