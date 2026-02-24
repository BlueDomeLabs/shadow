// test/unit/data/repositories/health_sync_status_repository_impl_test.dart
// Phase 16a — Tests for HealthSyncStatusRepositoryImpl
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/health_sync_status_dao.dart';
import 'package:shadow_app/data/repositories/health_sync_status_repository_impl.dart';
import 'package:shadow_app/domain/entities/health_sync_status.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

@GenerateMocks([HealthSyncStatusDao])
import 'health_sync_status_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<HealthSyncStatus>, AppError>>(const Success([]));
  provideDummy<Result<HealthSyncStatus?, AppError>>(const Success(null));
  provideDummy<Result<HealthSyncStatus, AppError>>(
    const Success(
      HealthSyncStatus(
        id: 'dummy_0',
        profileId: 'dummy',
        dataType: HealthDataType.heartRate,
      ),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));

  group('HealthSyncStatusRepositoryImpl', () {
    late MockHealthSyncStatusDao mockDao;
    late HealthSyncStatusRepositoryImpl repository;

    const testProfileId = 'profile-001';

    HealthSyncStatus createStatus({
      String profileId = testProfileId,
      HealthDataType dataType = HealthDataType.heartRate,
      int? lastSyncedAt,
      int recordCount = 0,
      String? lastError,
    }) => HealthSyncStatus(
      id: HealthSyncStatus.makeId(profileId, dataType),
      profileId: profileId,
      dataType: dataType,
      lastSyncedAt: lastSyncedAt,
      recordCount: recordCount,
      lastError: lastError,
    );

    final testAppError = DatabaseError.queryFailed(
      'health_sync_status',
      'test error',
      StackTrace.empty,
    );

    setUp(() {
      mockDao = MockHealthSyncStatusDao();
      repository = HealthSyncStatusRepositoryImpl(mockDao);
    });

    group('getByProfile', () {
      test('delegates to DAO and returns list', () async {
        final statuses = [
          createStatus(),
          createStatus(dataType: HealthDataType.weight),
        ];
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Success(statuses));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.length, 2);
      });

      test('returns empty list when no rows', () async {
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => const Success([]));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });

      test('propagates DAO failure', () async {
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Failure(testAppError));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isFailure, isTrue);
      });
    });

    group('getByDataType', () {
      test('delegates to DAO and returns status when found', () async {
        final status = createStatus();
        when(
          mockDao.getByDataType(testProfileId, HealthDataType.heartRate),
        ).thenAnswer((_) async => Success(status));

        final result = await repository.getByDataType(
          testProfileId,
          HealthDataType.heartRate,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.dataType, HealthDataType.heartRate);
      });

      test('returns null when not found', () async {
        when(
          mockDao.getByDataType(testProfileId, HealthDataType.heartRate),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.getByDataType(
          testProfileId,
          HealthDataType.heartRate,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });

      test('propagates DAO failure', () async {
        when(
          mockDao.getByDataType(any, any),
        ).thenAnswer((_) async => Failure(testAppError));

        final result = await repository.getByDataType(
          testProfileId,
          HealthDataType.heartRate,
        );

        expect(result.isFailure, isTrue);
      });
    });

    group('upsert', () {
      test('saves via DAO and returns the input entity', () async {
        final status = createStatus(
          lastSyncedAt: 1704067200000,
          recordCount: 12,
        );
        when(
          mockDao.upsert(status),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.upsert(status);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, status);
      });

      test('propagates DAO failure without returning entity', () async {
        final status = createStatus();
        when(
          mockDao.upsert(status),
        ).thenAnswer((_) async => Failure(testAppError));

        final result = await repository.upsert(status);

        expect(result.isFailure, isTrue);
      });

      test('calls DAO upsert with the provided entity', () async {
        final status = createStatus(recordCount: 99);
        when(
          mockDao.upsert(status),
        ).thenAnswer((_) async => const Success(null));

        await repository.upsert(status);

        verify(mockDao.upsert(status)).called(1);
      });
    });
  });
}
