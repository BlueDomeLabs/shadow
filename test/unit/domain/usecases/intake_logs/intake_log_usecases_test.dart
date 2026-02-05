// test/unit/domain/usecases/intake_logs/intake_log_usecases_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/intake_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/intake_log_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/intake_logs/get_intake_logs_use_case.dart';
import 'package:shadow_app/domain/usecases/intake_logs/intake_log_inputs.dart';
import 'package:shadow_app/domain/usecases/intake_logs/mark_skipped_use_case.dart';
import 'package:shadow_app/domain/usecases/intake_logs/mark_taken_use_case.dart';

@GenerateMocks([IntakeLogRepository, ProfileAuthorizationService])
import 'intake_log_usecases_test.mocks.dart';

void main() {
  // Provide dummy values for Result types
  provideDummy<Result<List<IntakeLog>, AppError>>(const Success([]));
  provideDummy<Result<IntakeLog, AppError>>(
    const Success(
      IntakeLog(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        supplementId: 'dummy',
        scheduledTime: 0,
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

  IntakeLog createTestIntakeLog({
    String id = 'log-001',
    String clientId = 'client-001',
    String profileId = testProfileId,
    String supplementId = 'supp-001',
    int scheduledTime = 1704067200000,
    int? actualTime,
    IntakeLogStatus status = IntakeLogStatus.pending,
    String? reason,
    String? note,
    SyncMetadata? syncMetadata,
  }) => IntakeLog(
    id: id,
    clientId: clientId,
    profileId: profileId,
    supplementId: supplementId,
    scheduledTime: scheduledTime,
    actualTime: actualTime,
    status: status,
    reason: reason,
    note: note,
    syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'test-device'),
  );

  group('GetIntakeLogsUseCase', () {
    late MockIntakeLogRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late GetIntakeLogsUseCase useCase;

    setUp(() {
      mockRepository = MockIntakeLogRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = GetIntakeLogsUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorized_returnsIntakeLogs', () async {
      final logs = [createTestIntakeLog()];
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success(logs));

      final result = await useCase(
        const GetIntakeLogsInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, logs);
      verify(mockAuthService.canRead(testProfileId)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const GetIntakeLogsInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(
        mockRepository.getByProfile(
          any,
          status: anyNamed('status'),
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
          limit: anyNamed('limit'),
          offset: anyNamed('offset'),
        ),
      );
    });

    test('call_passesStatusFilterToRepository', () async {
      when(
        mockAuthService.canRead(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getByProfile(
          testProfileId,
          status: IntakeLogStatus.pending,
        ),
      ).thenAnswer((_) async => const Success([]));

      await useCase(
        const GetIntakeLogsInput(
          profileId: testProfileId,
          status: IntakeLogStatus.pending,
        ),
      );

      verify(
        mockRepository.getByProfile(
          testProfileId,
          status: IntakeLogStatus.pending,
        ),
      ).called(1);
    });
  });

  group('MarkTakenUseCase', () {
    late MockIntakeLogRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late MarkTakenUseCase useCase;

    setUp(() {
      mockRepository = MockIntakeLogRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = MarkTakenUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorizedAndValid_marksAsTaken', () async {
      final existingLog = createTestIntakeLog();
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('log-001'),
      ).thenAnswer((_) async => Success(existingLog));
      when(
        mockRepository.markTaken('log-001', 1704067500000),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase(
        const MarkTakenInput(
          id: 'log-001',
          profileId: testProfileId,
          actualTime: 1704067500000,
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepository.markTaken('log-001', 1704067500000)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const MarkTakenInput(
          id: 'log-001',
          profileId: testProfileId,
          actualTime: 1704067500000,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.getById(any));
    });

    test('call_whenLogNotFound_returnsFailure', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(mockRepository.getById('log-001')).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('IntakeLog', 'log-001')),
      );

      final result = await useCase(
        const MarkTakenInput(
          id: 'log-001',
          profileId: testProfileId,
          actualTime: 1704067500000,
        ),
      );

      expect(result.isFailure, isTrue);
    });

    test('call_whenLogBelongsToDifferentProfile_returnsAuthError', () async {
      final existingLog = createTestIntakeLog(profileId: 'different-profile');
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('log-001'),
      ).thenAnswer((_) async => Success(existingLog));

      final result = await useCase(
        const MarkTakenInput(
          id: 'log-001',
          profileId: testProfileId,
          actualTime: 1704067500000,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_withInvalidActualTime_returnsValidationError', () async {
      final existingLog = createTestIntakeLog();
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('log-001'),
      ).thenAnswer((_) async => Success(existingLog));

      final result = await useCase(
        const MarkTakenInput(
          id: 'log-001',
          profileId: testProfileId,
          actualTime: 0,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });
  });

  group('MarkSkippedUseCase', () {
    late MockIntakeLogRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late MarkSkippedUseCase useCase;

    setUp(() {
      mockRepository = MockIntakeLogRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = MarkSkippedUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorizedAndValid_marksAsSkipped', () async {
      final existingLog = createTestIntakeLog();
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('log-001'),
      ).thenAnswer((_) async => Success(existingLog));
      when(
        mockRepository.markSkipped('log-001', 'Felt sick'),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase(
        const MarkSkippedInput(
          id: 'log-001',
          profileId: testProfileId,
          reason: 'Felt sick',
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepository.markSkipped('log-001', 'Felt sick')).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => false);

      final result = await useCase(
        const MarkSkippedInput(id: 'log-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_withNullReason_stillSucceeds', () async {
      final existingLog = createTestIntakeLog();
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('log-001'),
      ).thenAnswer((_) async => Success(existingLog));
      when(
        mockRepository.markSkipped('log-001', null),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase(
        const MarkSkippedInput(id: 'log-001', profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
    });
  });
}
