// test/unit/data/repositories/condition_log_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/condition_log_dao.dart';
import 'package:shadow_app/data/repositories/condition_log_repository_impl.dart';
import 'package:shadow_app/domain/entities/condition_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:uuid/uuid.dart';

@GenerateMocks([ConditionLogDao, DeviceInfoService])
import 'condition_log_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<ConditionLog>, AppError>>(const Success([]));
  provideDummy<Result<ConditionLog, AppError>>(
    const Success(
      ConditionLog(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        conditionId: 'dummy',
        timestamp: 0,
        severity: 1,
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));

  group('ConditionLogRepositoryImpl', () {
    late MockConditionLogDao mockDao;
    late MockDeviceInfoService mockDeviceInfoService;
    late Uuid uuid;
    late ConditionLogRepositoryImpl repository;

    const testDeviceId = 'test-device-123';
    const testProfileId = 'profile-001';

    ConditionLog createTestConditionLog({
      String id = 'clog-001',
      String clientId = 'client-001',
      String profileId = testProfileId,
      String conditionId = 'cond-001',
      int timestamp = 1704067200000,
      int severity = 5,
      SyncMetadata? syncMetadata,
    }) => ConditionLog(
      id: id,
      clientId: clientId,
      profileId: profileId,
      conditionId: conditionId,
      timestamp: timestamp,
      severity: severity,
      syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'old-device'),
    );

    setUp(() {
      mockDao = MockConditionLogDao();
      mockDeviceInfoService = MockDeviceInfoService();
      uuid = const Uuid();
      repository = ConditionLogRepositoryImpl(
        mockDao,
        uuid,
        mockDeviceInfoService,
      );

      when(
        mockDeviceInfoService.getDeviceId(),
      ).thenAnswer((_) async => testDeviceId);
    });

    group('getAll', () {
      test('getAll_delegatesToDao', () async {
        final logs = [createTestConditionLog()];
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
        final log = createTestConditionLog();
        when(mockDao.getById('clog-001')).thenAnswer((_) async => Success(log));

        final result = await repository.getById('clog-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, log);
        verify(mockDao.getById('clog-001')).called(1);
      });

      test('getById_returnsFailureWhenNotFound', () async {
        when(mockDao.getById('non-existent')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('ConditionLog', 'non-existent')),
        );

        final result = await repository.getById('non-existent');

        expect(result.isFailure, isTrue);
      });
    });

    group('create', () {
      test('create_generatesIdWhenEmpty', () async {
        final log = createTestConditionLog(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as ConditionLog;
          return Success(created);
        });

        final result = await repository.create(log);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.id, isNotEmpty);
        expect(created.id.length, 36);
      });

      test('create_usesExistingIdWhenProvided', () async {
        final log = createTestConditionLog(id: 'my-custom-id');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as ConditionLog;
          return Success(created);
        });

        final result = await repository.create(log);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, 'my-custom-id');
      });

      test('create_setsSyncMetadataWithDeviceId', () async {
        final log = createTestConditionLog(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as ConditionLog;
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
        final log = createTestConditionLog(
          syncMetadata: const SyncMetadata(
            syncCreatedAt: 1000,
            syncUpdatedAt: 1000,
            syncDeviceId: 'old-device',
            syncStatus: SyncStatus.synced,
          ),
        );
        when(mockDao.updateEntity(any)).thenAnswer((invocation) async {
          final updated = invocation.positionalArguments[0] as ConditionLog;
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
        final log = createTestConditionLog(syncMetadata: originalMetadata);
        when(mockDao.updateEntity(any, markDirty: false)).thenAnswer((
          invocation,
        ) async {
          final updated = invocation.positionalArguments[0] as ConditionLog;
          return Success(updated);
        });

        final result = await repository.update(log, markDirty: false);

        expect(result.isSuccess, isTrue);
        final updated = result.valueOrNull!;
        expect(updated.syncMetadata.syncVersion, 5);
        expect(updated.syncMetadata.syncStatus, SyncStatus.synced);
        verifyNever(mockDeviceInfoService.getDeviceId());
      });

      test('update_delegatesToDaoWithMarkDirtyFlag', () async {
        final log = createTestConditionLog();
        when(
          mockDao.updateEntity(any, markDirty: false),
        ).thenAnswer((_) async => Success(log));

        await repository.update(log, markDirty: false);

        verify(mockDao.updateEntity(any, markDirty: false)).called(1);
      });
    });

    group('delete', () {
      test('delete_delegatesToDaoSoftDelete', () async {
        when(
          mockDao.softDelete('clog-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.delete('clog-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.softDelete('clog-001')).called(1);
      });
    });

    group('hardDelete', () {
      test('hardDelete_delegatesToDaoHardDelete', () async {
        when(
          mockDao.hardDelete('clog-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.hardDelete('clog-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.hardDelete('clog-001')).called(1);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_delegatesToDao', () async {
        final logs = [createTestConditionLog()];
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
        final logs = [createTestConditionLog()];
        when(mockDao.getPendingSync()).thenAnswer((_) async => Success(logs));

        final result = await repository.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, logs);
        verify(mockDao.getPendingSync()).called(1);
      });
    });

    group('getByProfile', () {
      test('getByProfile_delegatesToDao', () async {
        final logs = [createTestConditionLog()];
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

    group('getByCondition', () {
      test('getByCondition_delegatesToDao', () async {
        final logs = [createTestConditionLog()];
        when(
          mockDao.getByCondition('cond-001'),
        ).thenAnswer((_) async => Success(logs));

        final result = await repository.getByCondition('cond-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, logs);
        verify(mockDao.getByCondition('cond-001')).called(1);
      });

      test('getByCondition_passesAllParametersToDao', () async {
        when(
          mockDao.getByCondition(
            'cond-001',
            startDate: 1000,
            endDate: 2000,
            limit: 10,
            offset: 5,
          ),
        ).thenAnswer((_) async => const Success([]));

        await repository.getByCondition(
          'cond-001',
          startDate: 1000,
          endDate: 2000,
          limit: 10,
          offset: 5,
        );

        verify(
          mockDao.getByCondition(
            'cond-001',
            startDate: 1000,
            endDate: 2000,
            limit: 10,
            offset: 5,
          ),
        ).called(1);
      });
    });

    group('getByDateRange', () {
      test('getByDateRange_delegatesToDao', () async {
        final logs = [createTestConditionLog()];
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

    group('getFlares', () {
      test('getFlares_delegatesToDao', () async {
        final logs = [createTestConditionLog()];
        when(
          mockDao.getFlares('cond-001'),
        ).thenAnswer((_) async => Success(logs));

        final result = await repository.getFlares('cond-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, logs);
        verify(mockDao.getFlares('cond-001')).called(1);
      });

      test('getFlares_passesLimitToDao', () async {
        when(
          mockDao.getFlares('cond-001', limit: 5),
        ).thenAnswer((_) async => const Success([]));

        await repository.getFlares('cond-001', limit: 5);

        verify(mockDao.getFlares('cond-001', limit: 5)).called(1);
      });
    });
  });
}
