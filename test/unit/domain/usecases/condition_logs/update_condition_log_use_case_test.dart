// test/unit/domain/usecases/condition_logs/update_condition_log_use_case_test.dart
// Phase 17b — B1: UpdateConditionLogUseCase tests

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/condition_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/condition_log_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/condition_logs/condition_log_inputs.dart';
import 'package:shadow_app/domain/usecases/condition_logs/update_condition_log_use_case.dart';

@GenerateMocks([ConditionLogRepository, ProfileAuthorizationService])
import 'update_condition_log_use_case_test.mocks.dart';

void main() {
  provideDummy<Result<ConditionLog, AppError>>(
    const Success(
      ConditionLog(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        conditionId: 'dummy',
        timestamp: 0,
        severity: 5,
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

  ConditionLog createTestLog({
    String id = 'log-001',
    String profileId = testProfileId,
    String conditionId = 'cond-001',
    int timestamp = 1704067200000,
    int severity = 5,
    String? notes,
  }) => ConditionLog(
    id: id,
    clientId: 'client-001',
    profileId: profileId,
    conditionId: conditionId,
    timestamp: timestamp,
    severity: severity,
    notes: notes,
    syncMetadata: SyncMetadata.create(deviceId: 'test-device'),
  );

  group('UpdateConditionLogUseCase', () {
    late MockConditionLogRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late UpdateConditionLogUseCase useCase;

    setUp(() {
      mockRepository = MockConditionLogRepository();
      mockAuthService = MockProfileAuthorizationService();
      useCase = UpdateConditionLogUseCase(mockRepository, mockAuthService);
    });

    test('call_whenAuthorizedAndValid_updatesLog', () async {
      final existing = createTestLog();
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('log-001'),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockRepository.update(any),
      ).thenAnswer((_) async => Success(existing));

      final result = await useCase(
        const UpdateConditionLogInput(
          id: 'log-001',
          profileId: testProfileId,
          severity: 7,
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
        const UpdateConditionLogInput(id: 'log-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.getById(any));
    });

    test('call_whenLogBelongsToOtherProfile_returnsAuthError', () async {
      final existing = createTestLog(profileId: 'other-profile');
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('log-001'),
      ).thenAnswer((_) async => Success(existing));

      final result = await useCase(
        const UpdateConditionLogInput(id: 'log-001', profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepository.update(any));
    });

    test('call_withSeverityOutOfRange_returnsValidationError', () async {
      final existing = createTestLog();
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('log-001'),
      ).thenAnswer((_) async => Success(existing));

      final result = await useCase(
        const UpdateConditionLogInput(
          id: 'log-001',
          profileId: testProfileId,
          severity: 11, // out of range (max is 10)
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      verifyNever(mockRepository.update(any));
    });

    test('call_mergesOnlyProvidedFields', () async {
      final existing = createTestLog(notes: 'Original note');
      ConditionLog? captured;
      when(
        mockAuthService.canWrite(testProfileId),
      ).thenAnswer((_) async => true);
      when(
        mockRepository.getById('log-001'),
      ).thenAnswer((_) async => Success(existing));
      when(mockRepository.update(any)).thenAnswer((inv) async {
        captured = inv.positionalArguments.first as ConditionLog;
        return Success(captured!);
      });

      await useCase(
        const UpdateConditionLogInput(
          id: 'log-001',
          profileId: testProfileId,
          severity: 8,
          // notes not provided — should keep existing
        ),
      );

      expect(captured?.severity, 8);
      expect(captured?.notes, 'Original note');
    });
  });
}
