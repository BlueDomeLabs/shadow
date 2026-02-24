// test/unit/data/repositories/imported_vital_repository_impl_test.dart
// Phase 16a — Tests for ImportedVitalRepositoryImpl
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/imported_vital_dao.dart';
import 'package:shadow_app/data/repositories/imported_vital_repository_impl.dart';
import 'package:shadow_app/domain/entities/imported_vital.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

@GenerateMocks([ImportedVitalDao])
import 'imported_vital_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<ImportedVital>, AppError>>(const Success([]));
  provideDummy<Result<ImportedVital, AppError>>(
    const Success(
      ImportedVital(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        dataType: HealthDataType.heartRate,
        value: 0,
        unit: 'bpm',
        recordedAt: 0,
        sourcePlatform: HealthSourcePlatform.appleHealth,
        importedAt: 0,
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));
  provideDummy<Result<int, AppError>>(const Success(0));
  provideDummy<Result<int?, AppError>>(const Success(null));

  group('ImportedVitalRepositoryImpl', () {
    late MockImportedVitalDao mockDao;
    late ImportedVitalRepositoryImpl repository;

    const testProfileId = 'profile-001';

    ImportedVital createVital({
      String id = 'vital-001',
      String profileId = testProfileId,
      HealthDataType dataType = HealthDataType.heartRate,
      double value = 72.0,
      int recordedAt = 1704067200000,
    }) => ImportedVital(
      id: id,
      clientId: 'client-001',
      profileId: profileId,
      dataType: dataType,
      value: value,
      unit: 'bpm',
      recordedAt: recordedAt,
      sourcePlatform: HealthSourcePlatform.appleHealth,
      importedAt: 1704067200000,
      syncMetadata: const SyncMetadata(
        syncCreatedAt: 1704067200000,
        syncUpdatedAt: 1704067200000,
        syncDeviceId: 'test-device',
      ),
    );

    final testAppError = DatabaseError.queryFailed(
      'imported_vitals',
      'test error',
      StackTrace.empty,
    );

    setUp(() {
      mockDao = MockImportedVitalDao();
      repository = ImportedVitalRepositoryImpl(mockDao);
    });

    group('getByProfile', () {
      test('delegates to DAO and returns success', () async {
        final vitals = [createVital()];
        when(
          mockDao.getByProfile(profileId: testProfileId),
        ).thenAnswer((_) async => Success(vitals));

        final result = await repository.getByProfile(profileId: testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, vitals);
      });

      test('passes all optional filters to DAO', () async {
        when(
          mockDao.getByProfile(
            profileId: testProfileId,
            startEpoch: 1000,
            endEpoch: 2000,
            dataType: HealthDataType.weight,
          ),
        ).thenAnswer((_) async => const Success([]));

        await repository.getByProfile(
          profileId: testProfileId,
          startEpoch: 1000,
          endEpoch: 2000,
          dataType: HealthDataType.weight,
        );

        verify(
          mockDao.getByProfile(
            profileId: testProfileId,
            startEpoch: 1000,
            endEpoch: 2000,
            dataType: HealthDataType.weight,
          ),
        ).called(1);
      });

      test('propagates DAO failure', () async {
        when(
          mockDao.getByProfile(
            profileId: anyNamed('profileId'),
            startEpoch: anyNamed('startEpoch'),
            endEpoch: anyNamed('endEpoch'),
            dataType: anyNamed('dataType'),
          ),
        ).thenAnswer((_) async => Failure(testAppError));

        final result = await repository.getByProfile(profileId: testProfileId);

        expect(result.isFailure, isTrue);
      });
    });

    group('importBatch', () {
      test('returns count of inserted vitals on success', () async {
        final vitals = [
          createVital(id: 'v1'),
          createVital(id: 'v2'),
          createVital(id: 'v3'),
        ];
        when(
          mockDao.insertIfNotDuplicate(any),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.importBatch(vitals);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, 3);
      });

      test('returns zero for empty batch', () async {
        final result = await repository.importBatch([]);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, 0);
        verifyNever(mockDao.insertIfNotDuplicate(any));
      });

      test('returns failure if any insert fails', () async {
        final vitals = [createVital(id: 'v1'), createVital(id: 'v2')];
        when(
          mockDao.insertIfNotDuplicate(
            argThat(predicate<ImportedVital>((v) => v.id == 'v1')),
          ),
        ).thenAnswer((_) async => const Success(null));
        when(
          mockDao.insertIfNotDuplicate(
            argThat(predicate<ImportedVital>((v) => v.id == 'v2')),
          ),
        ).thenAnswer((_) async => Failure(testAppError));

        final result = await repository.importBatch(vitals);

        expect(result.isFailure, isTrue);
      });

      test('stops on first failure and does not process remaining', () async {
        final vitals = [
          createVital(id: 'v1'),
          createVital(id: 'v2'),
          createVital(id: 'v3'),
        ];
        when(
          mockDao.insertIfNotDuplicate(any),
        ).thenAnswer((_) async => Failure(testAppError));

        await repository.importBatch(vitals);

        verify(mockDao.insertIfNotDuplicate(any)).called(1);
      });
    });

    group('getLastImportTime', () {
      test('delegates to DAO and returns success', () async {
        const ts = 1704067200000;
        when(
          mockDao.getLastImportTime(testProfileId, HealthDataType.heartRate),
        ).thenAnswer((_) async => const Success(ts));

        final result = await repository.getLastImportTime(
          testProfileId,
          HealthDataType.heartRate,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, ts);
      });

      test('returns null when no records exist', () async {
        when(
          mockDao.getLastImportTime(testProfileId, HealthDataType.heartRate),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.getLastImportTime(
          testProfileId,
          HealthDataType.heartRate,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });
    });

    group('getModifiedSince', () {
      test('delegates to DAO and returns success', () async {
        final vitals = [createVital()];
        const since = 1000000;
        when(
          mockDao.getModifiedSince(since),
        ).thenAnswer((_) async => Success(vitals));

        final result = await repository.getModifiedSince(since);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, vitals);
      });

      test('propagates DAO failure', () async {
        when(
          mockDao.getModifiedSince(any),
        ).thenAnswer((_) async => Failure(testAppError));

        final result = await repository.getModifiedSince(0);

        expect(result.isFailure, isTrue);
      });
    });
  });
}
