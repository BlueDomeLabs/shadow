// test/unit/data/repositories/food_log_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/food_log_dao.dart';
import 'package:shadow_app/data/repositories/food_log_repository_impl.dart';
import 'package:shadow_app/domain/entities/food_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:uuid/uuid.dart';

@GenerateMocks([FoodLogDao, DeviceInfoService])
import 'food_log_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<FoodLog>, AppError>>(const Success([]));
  provideDummy<Result<FoodLog, AppError>>(
    const Success(
      FoodLog(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        timestamp: 0,
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));

  group('FoodLogRepositoryImpl', () {
    late MockFoodLogDao mockDao;
    late MockDeviceInfoService mockDeviceInfoService;
    late Uuid uuid;
    late FoodLogRepositoryImpl repository;

    const testDeviceId = 'test-device-123';
    const testProfileId = 'profile-001';

    FoodLog createTestFoodLog({
      String id = 'flog-001',
      String clientId = 'client-001',
      String profileId = testProfileId,
      int timestamp = 1704067200000,
      SyncMetadata? syncMetadata,
    }) => FoodLog(
      id: id,
      clientId: clientId,
      profileId: profileId,
      timestamp: timestamp,
      syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'old-device'),
    );

    setUp(() {
      mockDao = MockFoodLogDao();
      mockDeviceInfoService = MockDeviceInfoService();
      uuid = const Uuid();
      repository = FoodLogRepositoryImpl(mockDao, uuid, mockDeviceInfoService);

      when(
        mockDeviceInfoService.getDeviceId(),
      ).thenAnswer((_) async => testDeviceId);
    });

    group('getAll', () {
      test('getAll_delegatesToDao', () async {
        final logs = [createTestFoodLog()];
        when(mockDao.getAll()).thenAnswer((_) async => Success(logs));

        final result = await repository.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, logs);
        verify(mockDao.getAll()).called(1);
      });

      test('getAll_passesParametersToDao', () async {
        when(
          mockDao.getAll(profileId: testProfileId, limit: 10, offset: 5),
        ).thenAnswer((_) async => const Success([]));

        await repository.getAll(profileId: testProfileId, limit: 10, offset: 5);

        verify(
          mockDao.getAll(profileId: testProfileId, limit: 10, offset: 5),
        ).called(1);
      });
    });

    group('getById', () {
      test('getById_delegatesToDao', () async {
        final log = createTestFoodLog();
        when(mockDao.getById('flog-001')).thenAnswer((_) async => Success(log));

        final result = await repository.getById('flog-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, log);
        verify(mockDao.getById('flog-001')).called(1);
      });

      test('getById_returnsFailureWhenNotFound', () async {
        when(mockDao.getById('non-existent')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('FoodLog', 'non-existent')),
        );

        final result = await repository.getById('non-existent');

        expect(result.isFailure, isTrue);
      });
    });

    group('create', () {
      test('create_generatesIdWhenEmpty', () async {
        final log = createTestFoodLog(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as FoodLog;
          return Success(created);
        });

        final result = await repository.create(log);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.id, isNotEmpty);
        expect(created.id.length, 36);
      });

      test('create_usesExistingIdWhenProvided', () async {
        final log = createTestFoodLog(id: 'my-custom-id');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as FoodLog;
          return Success(created);
        });

        final result = await repository.create(log);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, 'my-custom-id');
      });

      test('create_setsSyncMetadataWithDeviceId', () async {
        final log = createTestFoodLog(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as FoodLog;
          return Success(created);
        });

        final result = await repository.create(log);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.syncMetadata.syncDeviceId, testDeviceId);
        expect(created.syncMetadata.syncStatus, SyncStatus.pending);
        expect(created.syncMetadata.syncVersion, 1);
        expect(created.syncMetadata.syncIsDirty, isTrue);
      });
    });

    group('update', () {
      test('update_marksDirtyByDefault', () async {
        final log = createTestFoodLog(
          syncMetadata: const SyncMetadata(
            syncCreatedAt: 1000,
            syncUpdatedAt: 1000,
            syncDeviceId: 'old-device',
            syncStatus: SyncStatus.synced,
          ),
        );
        when(mockDao.updateEntity(any)).thenAnswer((invocation) async {
          final updated = invocation.positionalArguments[0] as FoodLog;
          return Success(updated);
        });

        final result = await repository.update(log);

        expect(result.isSuccess, isTrue);
        final updated = result.valueOrNull!;
        expect(updated.syncMetadata.syncStatus, SyncStatus.modified);
        expect(updated.syncMetadata.syncVersion, 2);
        expect(updated.syncMetadata.syncIsDirty, isTrue);
        expect(updated.syncMetadata.syncDeviceId, testDeviceId);
      });

      test('update_preservesEntityWhenMarkDirtyFalse', () async {
        const originalMetadata = SyncMetadata(
          syncCreatedAt: 1000,
          syncUpdatedAt: 1000,
          syncDeviceId: 'old-device',
          syncStatus: SyncStatus.synced,
          syncVersion: 5,
          syncIsDirty: false,
        );
        final log = createTestFoodLog(syncMetadata: originalMetadata);
        when(mockDao.updateEntity(any)).thenAnswer((invocation) async {
          final updated = invocation.positionalArguments[0] as FoodLog;
          return Success(updated);
        });

        final result = await repository.update(log, markDirty: false);

        expect(result.isSuccess, isTrue);
        final updated = result.valueOrNull!;
        expect(updated.syncMetadata.syncVersion, 5);
        expect(updated.syncMetadata.syncStatus, SyncStatus.synced);
        verifyNever(mockDeviceInfoService.getDeviceId());
      });
    });

    group('delete', () {
      test('delete_delegatesToDaoSoftDelete', () async {
        when(
          mockDao.softDelete('flog-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.delete('flog-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.softDelete('flog-001')).called(1);
      });
    });

    group('hardDelete', () {
      test('hardDelete_delegatesToDaoHardDelete', () async {
        when(
          mockDao.hardDelete('flog-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.hardDelete('flog-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.hardDelete('flog-001')).called(1);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_delegatesToDao', () async {
        final logs = [createTestFoodLog()];
        when(
          mockDao.getModifiedSince(1000),
        ).thenAnswer((_) async => Success(logs));

        final result = await repository.getModifiedSince(1000);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, logs);
        verify(mockDao.getModifiedSince(1000)).called(1);
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_delegatesToDao', () async {
        final logs = [createTestFoodLog()];
        when(mockDao.getPendingSync()).thenAnswer((_) async => Success(logs));

        final result = await repository.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, logs);
        verify(mockDao.getPendingSync()).called(1);
      });
    });

    group('getByProfile', () {
      test('getByProfile_delegatesToDao', () async {
        final logs = [createTestFoodLog()];
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Success(logs));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, logs);
        verify(mockDao.getByProfile(testProfileId)).called(1);
      });

      test('getByProfile_passesAllParametersToDao', () async {
        when(
          mockDao.getByProfile(
            testProfileId,
            startDate: 1000,
            endDate: 2000,
            limit: 10,
            offset: 5,
          ),
        ).thenAnswer((_) async => const Success([]));

        await repository.getByProfile(
          testProfileId,
          startDate: 1000,
          endDate: 2000,
          limit: 10,
          offset: 5,
        );

        verify(
          mockDao.getByProfile(
            testProfileId,
            startDate: 1000,
            endDate: 2000,
            limit: 10,
            offset: 5,
          ),
        ).called(1);
      });
    });

    group('getForDate', () {
      test('getForDate_delegatesToDao', () async {
        final logs = [createTestFoodLog()];
        when(
          mockDao.getForDate(testProfileId, 1704067200000),
        ).thenAnswer((_) async => Success(logs));

        final result = await repository.getForDate(
          testProfileId,
          1704067200000,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, logs);
        verify(mockDao.getForDate(testProfileId, 1704067200000)).called(1);
      });
    });

    group('getByDateRange', () {
      test('getByDateRange_delegatesToDao', () async {
        final logs = [createTestFoodLog()];
        when(
          mockDao.getByDateRange(testProfileId, 1000, 2000),
        ).thenAnswer((_) async => Success(logs));

        final result = await repository.getByDateRange(
          testProfileId,
          1000,
          2000,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, logs);
        verify(mockDao.getByDateRange(testProfileId, 1000, 2000)).called(1);
      });
    });
  });
}
