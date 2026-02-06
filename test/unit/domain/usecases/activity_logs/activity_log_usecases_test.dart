// test/unit/domain/usecases/activity_logs/activity_log_usecases_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/entities/activity_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/activity_log_repository.dart';
import 'package:shadow_app/domain/repositories/activity_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/activity_logs/activity_log_inputs.dart';
import 'package:shadow_app/domain/usecases/activity_logs/delete_activity_log_use_case.dart';
import 'package:shadow_app/domain/usecases/activity_logs/get_activity_logs_use_case.dart';
import 'package:shadow_app/domain/usecases/activity_logs/log_activity_use_case.dart';
import 'package:shadow_app/domain/usecases/activity_logs/update_activity_log_use_case.dart';

@GenerateMocks([
  ActivityLogRepository,
  ActivityRepository,
  ProfileAuthorizationService,
])
import 'activity_log_usecases_test.mocks.dart';

void main() {
  provideDummy<Result<List<ActivityLog>, AppError>>(const Success([]));
  provideDummy<Result<void, AppError>>(const Success(null));

  const testProfileId = 'profile-001';
  const testClientId = 'client-001';

  final now = DateTime.now().millisecondsSinceEpoch;
  final timestamp = now - (2 * 60 * 60 * 1000); // 2 hours ago

  Activity createTestActivity({
    String id = 'activity-001',
    String profileId = testProfileId,
  }) => Activity(
    id: id,
    clientId: testClientId,
    profileId: profileId,
    name: 'Morning Run',
    durationMinutes: 30,
    syncMetadata: SyncMetadata.create(deviceId: 'test-device'),
  );

  ActivityLog createTestActivityLog({
    String id = 'log-001',
    String clientId = testClientId,
    String profileId = testProfileId,
    int? ts,
    List<String> activityIds = const ['activity-001'],
    List<String> adHocActivities = const [],
    int? duration,
    String? notes,
    SyncMetadata? syncMetadata,
  }) => ActivityLog(
    id: id,
    clientId: clientId,
    profileId: profileId,
    timestamp: ts ?? timestamp,
    activityIds: activityIds,
    adHocActivities: adHocActivities,
    duration: duration,
    notes: notes,
    syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'test-device'),
  );

  provideDummy<Result<ActivityLog, AppError>>(Success(createTestActivityLog()));
  provideDummy<Result<Activity, AppError>>(Success(createTestActivity()));

  group('LogActivityUseCase', () {
    late MockActivityLogRepository mockLogRepository;
    late MockActivityRepository mockActivityRepository;
    late MockProfileAuthorizationService mockAuthService;
    late LogActivityUseCase useCase;

    setUp(() {
      mockLogRepository = MockActivityLogRepository();
      mockActivityRepository = MockActivityRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = LogActivityUseCase(
        mockLogRepository,
        mockActivityRepository,
        mockAuthService,
      );
    });

    test('call_whenAuthorized_createsActivityLog', () async {
      final activity = createTestActivity();
      final expectedLog = createTestActivityLog();

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockActivityRepository.getById('activity-001'),
      ).thenAnswer((_) async => Success(activity));
      when(
        mockLogRepository.create(any),
      ).thenAnswer((_) async => Success(expectedLog));

      final result = await useCase(
        LogActivityInput(
          profileId: testProfileId,
          clientId: testClientId,
          timestamp: timestamp,
          activityIds: const ['activity-001'],
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockAuthService.canWrite(testProfileId)).called(1);
      verify(mockLogRepository.create(any)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        LogActivityInput(
          profileId: testProfileId,
          clientId: testClientId,
          timestamp: timestamp,
          activityIds: const ['activity-001'],
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockLogRepository.create(any));
    });

    test('call_whenNoActivities_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        LogActivityInput(
          profileId: testProfileId,
          clientId: testClientId,
          timestamp: timestamp,
          // No activities provided
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockLogRepository.create(any));
    });

    test('call_withAdHocActivities_createsLog', () async {
      final expectedLog = createTestActivityLog(
        activityIds: [],
        adHocActivities: ['Custom Exercise'],
      );

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockLogRepository.create(any),
      ).thenAnswer((_) async => Success(expectedLog));

      final result = await useCase(
        LogActivityInput(
          profileId: testProfileId,
          clientId: testClientId,
          timestamp: timestamp,
          adHocActivities: const ['Custom Exercise'],
        ),
      );

      expect(result.isSuccess, isTrue);
    });

    test('call_whenTimestampTooFarInFuture_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);

      final futureTimestamp = now + (2 * 60 * 60 * 1000); // 2 hours from now

      final result = await useCase(
        LogActivityInput(
          profileId: testProfileId,
          clientId: testClientId,
          timestamp: futureTimestamp,
          adHocActivities: const ['Exercise'],
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });

    test('call_whenActivityNotFound_returnsValidationError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockActivityRepository.getById('activity-001')).thenAnswer(
        (_) async =>
            Failure(DatabaseError.notFound('Activity', 'activity-001')),
      );

      final result = await useCase(
        LogActivityInput(
          profileId: testProfileId,
          clientId: testClientId,
          timestamp: timestamp,
          activityIds: const ['activity-001'],
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });

    test(
      'call_whenActivityBelongsToDifferentProfile_returnsValidationError',
      () async {
        final otherProfileActivity = createTestActivity(
          profileId: 'other-profile',
        );

        when(
          mockAuthService.canWrite(testProfileId),
        ).thenAnswer((_) async => true);
        when(
          mockActivityRepository.getById('activity-001'),
        ).thenAnswer((_) async => Success(otherProfileActivity));

        final result = await useCase(
          LogActivityInput(
            profileId: testProfileId,
            clientId: testClientId,
            timestamp: timestamp,
            activityIds: const ['activity-001'],
          ),
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<ValidationError>());
      },
    );
  });

  group('GetActivityLogsUseCase', () {
    late MockActivityLogRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late GetActivityLogsUseCase useCase;

    setUp(() {
      mockRepository = MockActivityLogRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = GetActivityLogsUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_returnsLogs', () async {
      final logs = [createTestActivityLog()];
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success(logs));

      final result = await useCase(
        const GetActivityLogsInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, logs);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const GetActivityLogsInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_whenStartDateAfterEndDate_returnsValidationError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);

      final result = await useCase(
        GetActivityLogsInput(
          profileId: testProfileId,
          startDate: timestamp + 1000,
          endDate: timestamp,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });
  });

  group('UpdateActivityLogUseCase', () {
    late MockActivityLogRepository mockLogRepository;
    late MockActivityRepository mockActivityRepository;
    late MockProfileAuthorizationService mockAuthService;
    late UpdateActivityLogUseCase useCase;

    setUp(() {
      mockLogRepository = MockActivityLogRepository();
      mockActivityRepository = MockActivityRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = UpdateActivityLogUseCase(
        mockLogRepository,
        mockActivityRepository,
        mockAuthService,
      );
    });

    test('call_whenAuthorized_updatesLog', () async {
      final existing = createTestActivityLog();
      final activity = createTestActivity();
      final updated = existing.copyWith(notes: 'Updated notes');

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockLogRepository.getById('log-001'),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockActivityRepository.getById('activity-001'),
      ).thenAnswer((_) async => Success(activity));
      when(
        mockLogRepository.update(any),
      ).thenAnswer((_) async => Success(updated));

      final result = await useCase(
        const UpdateActivityLogInput(
          id: 'log-001',
          profileId: testProfileId,
          notes: 'Updated notes',
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockLogRepository.update(any)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const UpdateActivityLogInput(id: 'log-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_whenLogNotFound_returnsError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockLogRepository.getById('log-001')).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('ActivityLog', 'log-001')),
      );

      final result = await useCase(
        const UpdateActivityLogInput(id: 'log-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<DatabaseError>());
    });
  });

  group('DeleteActivityLogUseCase', () {
    late MockActivityLogRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late DeleteActivityLogUseCase useCase;

    setUp(() {
      mockRepository = MockActivityLogRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = DeleteActivityLogUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_deletesLog', () async {
      final existing = createTestActivityLog();

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('log-001'),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockRepository.delete('log-001'),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase(
        const DeleteActivityLogInput(id: 'log-001', profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepository.delete('log-001')).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const DeleteActivityLogInput(id: 'log-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_whenLogNotFound_returnsError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.getById('log-001')).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('ActivityLog', 'log-001')),
      );

      final result = await useCase(
        const DeleteActivityLogInput(id: 'log-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<DatabaseError>());
    });

    test('call_whenLogBelongsToDifferentProfile_returnsAuthError', () async {
      final existing = createTestActivityLog(profileId: 'other-profile');

      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('log-001'),
      ).thenAnswer((_) async => Success(existing));

      final result = await useCase(
        const DeleteActivityLogInput(id: 'log-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });
  });
}
