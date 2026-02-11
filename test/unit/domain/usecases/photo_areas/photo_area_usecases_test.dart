// test/unit/domain/usecases/photo_areas/photo_area_usecases_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/photo_area_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/photo_areas/archive_photo_area_use_case.dart';
import 'package:shadow_app/domain/usecases/photo_areas/create_photo_area_use_case.dart';
import 'package:shadow_app/domain/usecases/photo_areas/get_photo_areas_use_case.dart';
import 'package:shadow_app/domain/usecases/photo_areas/photo_area_inputs.dart';
import 'package:shadow_app/domain/usecases/photo_areas/update_photo_area_use_case.dart';

@GenerateMocks([PhotoAreaRepository, ProfileAuthorizationService])
import 'photo_area_usecases_test.mocks.dart';

void main() {
  provideDummy<Result<List<PhotoArea>, AppError>>(const Success([]));
  provideDummy<Result<void, AppError>>(const Success(null));

  const testProfileId = 'profile-001';
  const testClientId = 'client-001';

  PhotoArea createTestPhotoArea({
    String id = 'area-001',
    String profileId = testProfileId,
    String name = 'Face Left',
    String? description,
    String? consistencyNotes,
    bool isArchived = false,
    SyncMetadata? syncMetadata,
  }) => PhotoArea(
    id: id,
    clientId: testClientId,
    profileId: profileId,
    name: name,
    description: description,
    consistencyNotes: consistencyNotes,
    isArchived: isArchived,
    syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'test-device'),
  );

  provideDummy<Result<PhotoArea, AppError>>(Success(createTestPhotoArea()));

  group('CreatePhotoAreaUseCase', () {
    late MockPhotoAreaRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late CreatePhotoAreaUseCase useCase;

    setUp(() {
      mockRepository = MockPhotoAreaRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = CreatePhotoAreaUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_createsPhotoArea', () async {
      final expectedArea = createTestPhotoArea();

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.create(any),
      ).thenAnswer((_) async => Success(expectedArea));

      final result = await useCase(
        const CreatePhotoAreaInput(
          profileId: testProfileId,
          clientId: testClientId,
          name: 'Face Left',
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
        const CreatePhotoAreaInput(
          profileId: testProfileId,
          clientId: testClientId,
          name: 'Face Left',
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenNameTooShort_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        const CreatePhotoAreaInput(
          profileId: testProfileId,
          clientId: testClientId,
          name: 'A', // Too short (< 2 characters)
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenNameTooLong_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        CreatePhotoAreaInput(
          profileId: testProfileId,
          clientId: testClientId,
          name:
              'A' * (ValidationRules.photoAreaNameMaxLength + 1), // Exceeds max
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenDescriptionTooLong_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        CreatePhotoAreaInput(
          profileId: testProfileId,
          clientId: testClientId,
          name: 'Face Left',
          description:
              'A' * (ValidationRules.descriptionMaxLength + 1), // Exceeds max
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });
  });

  group('GetPhotoAreasUseCase', () {
    late MockPhotoAreaRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late GetPhotoAreasUseCase useCase;

    setUp(() {
      mockRepository = MockPhotoAreaRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = GetPhotoAreasUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_returnsPhotoAreas', () async {
      final areas = [createTestPhotoArea()];

      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success(areas));

      final result = await useCase(
        const GetPhotoAreasInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, equals(areas));
      verify(mockAuthService.canRead(testProfileId)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const GetPhotoAreasInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.getByProfile(any));
    });

    test('call_withIncludeArchived_passesFlag', () async {
      final areas = [createTestPhotoArea()];

      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(testProfileId, includeArchived: true),
      ).thenAnswer((_) async => Success(areas));

      final result = await useCase(
        const GetPhotoAreasInput(
          profileId: testProfileId,
          includeArchived: true,
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(
        mockRepository.getByProfile(testProfileId, includeArchived: true),
      ).called(1);
    });
  });

  group('UpdatePhotoAreaUseCase', () {
    late MockPhotoAreaRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late UpdatePhotoAreaUseCase useCase;

    setUp(() {
      mockRepository = MockPhotoAreaRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = UpdatePhotoAreaUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_updatesPhotoArea', () async {
      final existingArea = createTestPhotoArea();
      final updatedArea = createTestPhotoArea(name: 'Face Right');

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('area-001'),
      ).thenAnswer((_) async => Success(existingArea));
      when(
        mockRepository.update(any),
      ).thenAnswer((_) async => Success(updatedArea));

      final result = await useCase(
        const UpdatePhotoAreaInput(
          id: 'area-001',
          profileId: testProfileId,
          name: 'Face Right',
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
        const UpdatePhotoAreaInput(
          id: 'area-001',
          profileId: testProfileId,
          name: 'Face Right',
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.update(any));
    });

    test('call_whenAreaNotFound_returnsError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.getById('area-001')).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('PhotoArea', 'area-001')),
      );

      final result = await useCase(
        const UpdatePhotoAreaInput(
          id: 'area-001',
          profileId: testProfileId,
          name: 'Face Right',
        ),
      );

      expect(result.isFailure, isTrue);
      verifyNever(mockRepository.update(any));
    });

    test('call_whenAreaBelongsToDifferentProfile_returnsAuthError', () async {
      final existingArea = createTestPhotoArea(profileId: 'other-profile');

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('area-001'),
      ).thenAnswer((_) async => Success(existingArea));

      final result = await useCase(
        const UpdatePhotoAreaInput(
          id: 'area-001',
          profileId: testProfileId,
          name: 'Face Right',
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.update(any));
    });
  });

  group('ArchivePhotoAreaUseCase', () {
    late MockPhotoAreaRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late ArchivePhotoAreaUseCase useCase;

    setUp(() {
      mockRepository = MockPhotoAreaRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = ArchivePhotoAreaUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_archivesPhotoArea', () async {
      final existingArea = createTestPhotoArea();
      final archivedArea = createTestPhotoArea(isArchived: true);

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('area-001'),
      ).thenAnswer((_) async => Success(existingArea));
      when(
        mockRepository.update(any),
      ).thenAnswer((_) async => Success(archivedArea));

      final result = await useCase(
        const ArchivePhotoAreaInput(id: 'area-001', profileId: testProfileId),
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
        const ArchivePhotoAreaInput(id: 'area-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.update(any));
    });

    test('call_whenAreaBelongsToDifferentProfile_returnsAuthError', () async {
      final existingArea = createTestPhotoArea(profileId: 'other-profile');

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('area-001'),
      ).thenAnswer((_) async => Success(existingArea));

      final result = await useCase(
        const ArchivePhotoAreaInput(id: 'area-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.update(any));
    });
  });
}
