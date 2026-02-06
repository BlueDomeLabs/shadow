// test/unit/domain/usecases/photo_entries/photo_entry_usecases_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/entities/photo_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/photo_area_repository.dart';
import 'package:shadow_app/domain/repositories/photo_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/photo_entries/create_photo_entry_use_case.dart';
import 'package:shadow_app/domain/usecases/photo_entries/delete_photo_entry_use_case.dart';
import 'package:shadow_app/domain/usecases/photo_entries/get_photo_entries_by_area_use_case.dart';
import 'package:shadow_app/domain/usecases/photo_entries/get_photo_entries_use_case.dart';
import 'package:shadow_app/domain/usecases/photo_entries/photo_entry_inputs.dart';

@GenerateMocks([
  PhotoEntryRepository,
  PhotoAreaRepository,
  ProfileAuthorizationService,
])
import 'photo_entry_usecases_test.mocks.dart';

void main() {
  provideDummy<Result<List<PhotoEntry>, AppError>>(const Success([]));
  provideDummy<Result<void, AppError>>(const Success(null));

  const testProfileId = 'profile-001';
  const testClientId = 'client-001';

  final now = DateTime.now().millisecondsSinceEpoch;
  final timestamp = now - (2 * 60 * 60 * 1000); // 2 hours ago

  PhotoArea createTestPhotoArea({
    String id = 'area-001',
    String profileId = testProfileId,
  }) => PhotoArea(
    id: id,
    clientId: testClientId,
    profileId: profileId,
    name: 'Face Left',
    syncMetadata: SyncMetadata.create(deviceId: 'test-device'),
  );

  PhotoEntry createTestPhotoEntry({
    String id = 'entry-001',
    String profileId = testProfileId,
    String photoAreaId = 'area-001',
    int? ts,
    String filePath = '/photos/test.jpg',
    String? notes,
    SyncMetadata? syncMetadata,
  }) => PhotoEntry(
    id: id,
    clientId: testClientId,
    profileId: profileId,
    photoAreaId: photoAreaId,
    timestamp: ts ?? timestamp,
    filePath: filePath,
    notes: notes,
    syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'test-device'),
  );

  provideDummy<Result<PhotoEntry, AppError>>(Success(createTestPhotoEntry()));
  provideDummy<Result<PhotoArea, AppError>>(Success(createTestPhotoArea()));

  group('CreatePhotoEntryUseCase', () {
    late MockPhotoEntryRepository mockRepository;
    late MockPhotoAreaRepository mockAreaRepository;
    late MockProfileAuthorizationService mockAuthService;
    late CreatePhotoEntryUseCase useCase;

    setUp(() {
      mockRepository = MockPhotoEntryRepository();
      mockAreaRepository = MockPhotoAreaRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = CreatePhotoEntryUseCase(
        mockRepository,
        mockAreaRepository,
        mockAuthService,
      );
    });

    test('call_whenAuthorized_createsPhotoEntry', () async {
      final area = createTestPhotoArea();
      final expectedEntry = createTestPhotoEntry();

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockAreaRepository.getById('area-001'),
      ).thenAnswer((_) async => Success(area));
      when(
        mockRepository.create(any),
      ).thenAnswer((_) async => Success(expectedEntry));

      final result = await useCase(
        CreatePhotoEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          photoAreaId: 'area-001',
          timestamp: timestamp,
          filePath: '/photos/test.jpg',
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
        CreatePhotoEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          photoAreaId: 'area-001',
          timestamp: timestamp,
          filePath: '/photos/test.jpg',
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenFilePathEmpty_returnsValidationError', () async {
      final area = createTestPhotoArea();

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockAreaRepository.getById('area-001'),
      ).thenAnswer((_) async => Success(area));

      final result = await useCase(
        CreatePhotoEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          photoAreaId: 'area-001',
          timestamp: timestamp,
          filePath: '', // Empty
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenPhotoAreaNotFound_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockAreaRepository.getById('area-001')).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('PhotoArea', 'area-001')),
      );

      final result = await useCase(
        CreatePhotoEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          photoAreaId: 'area-001',
          timestamp: timestamp,
          filePath: '/photos/test.jpg',
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });

    test(
      'call_whenPhotoAreaBelongsToDifferentProfile_returnsValidationError',
      () async {
        final area = createTestPhotoArea(profileId: 'other-profile');

        when(
          mockAuthService.canWrite(testProfileId),
        ).thenAnswer((_) async => true);
        when(
          mockAreaRepository.getById('area-001'),
        ).thenAnswer((_) async => Success(area));

        final result = await useCase(
          CreatePhotoEntryInput(
            profileId: testProfileId,
            clientId: testClientId,
            photoAreaId: 'area-001',
            timestamp: timestamp,
            filePath: '/photos/test.jpg',
          ),
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<ValidationError>());
        verifyNever(mockRepository.create(any));
      },
    );

    test('call_whenTimestampTooFarInFuture_returnsValidationError', () async {
      final area = createTestPhotoArea();
      final futureTimestamp =
          DateTime.now().millisecondsSinceEpoch +
          (2 * 60 * 60 * 1000); // 2 hours in future

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockAreaRepository.getById('area-001'),
      ).thenAnswer((_) async => Success(area));

      final result = await useCase(
        CreatePhotoEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          photoAreaId: 'area-001',
          timestamp: futureTimestamp,
          filePath: '/photos/test.jpg',
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenNotesTooLong_returnsValidationError', () async {
      final area = createTestPhotoArea();

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockAreaRepository.getById('area-001'),
      ).thenAnswer((_) async => Success(area));

      final result = await useCase(
        CreatePhotoEntryInput(
          profileId: testProfileId,
          clientId: testClientId,
          photoAreaId: 'area-001',
          timestamp: timestamp,
          filePath: '/photos/test.jpg',
          notes: 'A' * 2001, // Too long (> 2000 characters)
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });
  });

  group('GetPhotoEntriesByAreaUseCase', () {
    late MockPhotoEntryRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late GetPhotoEntriesByAreaUseCase useCase;

    setUp(() {
      mockRepository = MockPhotoEntryRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = GetPhotoEntriesByAreaUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_returnsPhotoEntries', () async {
      final entries = [createTestPhotoEntry()];

      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByArea('area-001'),
      ).thenAnswer((_) async => Success(entries));

      final result = await useCase(
        const GetPhotoEntriesByAreaInput(
          profileId: testProfileId,
          photoAreaId: 'area-001',
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, equals(entries));
      verify(mockAuthService.canRead(testProfileId)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const GetPhotoEntriesByAreaInput(
          profileId: testProfileId,
          photoAreaId: 'area-001',
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.getByArea(any));
    });
  });

  group('GetPhotoEntriesUseCase', () {
    late MockPhotoEntryRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late GetPhotoEntriesUseCase useCase;

    setUp(() {
      mockRepository = MockPhotoEntryRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = GetPhotoEntriesUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_returnsPhotoEntries', () async {
      final entries = [createTestPhotoEntry()];

      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success(entries));

      final result = await useCase(
        const GetPhotoEntriesInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, equals(entries));
      verify(mockAuthService.canRead(testProfileId)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const GetPhotoEntriesInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.getByProfile(any));
    });
  });

  group('DeletePhotoEntryUseCase', () {
    late MockPhotoEntryRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late DeletePhotoEntryUseCase useCase;

    setUp(() {
      mockRepository = MockPhotoEntryRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = DeletePhotoEntryUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_deletesPhotoEntry', () async {
      final existingEntry = createTestPhotoEntry();

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('entry-001'),
      ).thenAnswer((_) async => Success(existingEntry));
      when(
        mockRepository.delete('entry-001'),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase(
        const DeletePhotoEntryInput(id: 'entry-001', profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      verify(mockAuthService.canWrite(testProfileId)).called(1);
      verify(mockRepository.delete('entry-001')).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const DeletePhotoEntryInput(id: 'entry-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.delete(any));
    });

    test('call_whenEntryBelongsToDifferentProfile_returnsAuthError', () async {
      final existingEntry = createTestPhotoEntry(profileId: 'other-profile');

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('entry-001'),
      ).thenAnswer((_) async => Success(existingEntry));

      final result = await useCase(
        const DeletePhotoEntryInput(id: 'entry-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.delete(any));
    });
  });
}
