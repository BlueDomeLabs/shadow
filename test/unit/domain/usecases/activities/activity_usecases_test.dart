// test/unit/domain/usecases/activities/activity_usecases_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/activity_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/activities/activity_inputs.dart';
import 'package:shadow_app/domain/usecases/activities/archive_activity_use_case.dart';
import 'package:shadow_app/domain/usecases/activities/create_activity_use_case.dart';
import 'package:shadow_app/domain/usecases/activities/get_activities_use_case.dart';
import 'package:shadow_app/domain/usecases/activities/update_activity_use_case.dart';

@GenerateMocks([ActivityRepository, ProfileAuthorizationService])
import 'activity_usecases_test.mocks.dart';

void main() {
  provideDummy<Result<List<Activity>, AppError>>(const Success([]));
  provideDummy<Result<void, AppError>>(const Success(null));

  const testProfileId = 'profile-001';
  const testClientId = 'client-001';

  Activity createTestActivity({
    String id = 'activity-001',
    String clientId = testClientId,
    String profileId = testProfileId,
    String name = 'Morning Run',
    String? description,
    String? location,
    String? triggers,
    int durationMinutes = 30,
    bool isArchived = false,
    SyncMetadata? syncMetadata,
  }) => Activity(
    id: id,
    clientId: clientId,
    profileId: profileId,
    name: name,
    description: description,
    location: location,
    triggers: triggers,
    durationMinutes: durationMinutes,
    isArchived: isArchived,
    syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'test-device'),
  );

  provideDummy<Result<Activity, AppError>>(Success(createTestActivity()));

  group('CreateActivityUseCase', () {
    late MockActivityRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late CreateActivityUseCase useCase;

    setUp(() {
      mockRepository = MockActivityRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = CreateActivityUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_createsActivity', () async {
      final expectedActivity = createTestActivity();
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.create(any),
      ).thenAnswer((_) async => Success(expectedActivity));

      final result = await useCase(
        const CreateActivityInput(
          profileId: testProfileId,
          clientId: testClientId,
          name: 'Morning Run',
          durationMinutes: 30,
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
        const CreateActivityInput(
          profileId: testProfileId,
          clientId: testClientId,
          name: 'Morning Run',
          durationMinutes: 30,
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
        const CreateActivityInput(
          profileId: testProfileId,
          clientId: testClientId,
          name: 'A', // Too short
          durationMinutes: 30,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });

    test('call_whenDurationInvalid_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        const CreateActivityInput(
          profileId: testProfileId,
          clientId: testClientId,
          name: 'Morning Run',
          durationMinutes: 0, // Invalid
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.create(any));
    });
  });

  group('GetActivitiesUseCase', () {
    late MockActivityRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late GetActivitiesUseCase useCase;

    setUp(() {
      mockRepository = MockActivityRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = GetActivitiesUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_returnsActivities', () async {
      final activities = [createTestActivity()];
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success(activities));

      final result = await useCase(
        const GetActivitiesInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, activities);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const GetActivitiesInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_passesIncludeArchivedToRepository', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(testProfileId, includeArchived: true),
      ).thenAnswer((_) async => const Success([]));

      await useCase(
        const GetActivitiesInput(
          profileId: testProfileId,
          includeArchived: true,
        ),
      );

      verify(
        mockRepository.getByProfile(testProfileId, includeArchived: true),
      ).called(1);
    });
  });

  group('UpdateActivityUseCase', () {
    late MockActivityRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late UpdateActivityUseCase useCase;

    setUp(() {
      mockRepository = MockActivityRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = UpdateActivityUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_updatesActivity', () async {
      final existing = createTestActivity();
      final updated = existing.copyWith(name: 'Evening Run');

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('activity-001'),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockRepository.update(any),
      ).thenAnswer((_) async => Success(updated));

      final result = await useCase(
        const UpdateActivityInput(
          id: 'activity-001',
          profileId: testProfileId,
          name: 'Evening Run',
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
        const UpdateActivityInput(id: 'activity-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_whenActivityNotFound_returnsError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.getById('activity-001')).thenAnswer(
        (_) async =>
            Failure(DatabaseError.notFound('Activity', 'activity-001')),
      );

      final result = await useCase(
        const UpdateActivityInput(id: 'activity-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<DatabaseError>());
    });

    test(
      'call_whenActivityBelongsToDifferentProfile_returnsAuthError',
      () async {
        final existing = createTestActivity(profileId: 'other-profile');

        when(
          mockAuthService.canWrite(testProfileId),
        ).thenAnswer((_) async => true);
        when(
          mockRepository.getById('activity-001'),
        ).thenAnswer((_) async => Success(existing));

        final result = await useCase(
          const UpdateActivityInput(
            id: 'activity-001',
            profileId: testProfileId,
          ),
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<AuthError>());
      },
    );
  });

  group('ArchiveActivityUseCase', () {
    late MockActivityRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late ArchiveActivityUseCase useCase;

    setUp(() {
      mockRepository = MockActivityRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = ArchiveActivityUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_archivesActivity', () async {
      final existing = createTestActivity();
      final archived = existing.copyWith(isArchived: true);

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('activity-001'),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockRepository.update(any),
      ).thenAnswer((_) async => Success(archived));

      final result = await useCase(
        const ArchiveActivityInput(
          id: 'activity-001',
          profileId: testProfileId,
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
        const ArchiveActivityInput(
          id: 'activity-001',
          profileId: testProfileId,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_withArchiveFalse_unarchivesActivity', () async {
      final existing = createTestActivity(isArchived: true);
      final unarchived = existing.copyWith(isArchived: false);

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('activity-001'),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockRepository.update(any),
      ).thenAnswer((_) async => Success(unarchived));

      final result = await useCase(
        const ArchiveActivityInput(
          id: 'activity-001',
          profileId: testProfileId,
          archive: false,
        ),
      );

      expect(result.isSuccess, isTrue);
    });
  });
}
