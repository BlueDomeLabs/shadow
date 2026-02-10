// test/unit/data/repositories/flare_up_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/flare_up_dao.dart';
import 'package:shadow_app/data/repositories/flare_up_repository_impl.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:uuid/uuid.dart';

@GenerateMocks([FlareUpDao, DeviceInfoService])
import 'flare_up_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<FlareUp>, AppError>>(const Success([]));
  provideDummy<Result<FlareUp, AppError>>(
    const Success(
      FlareUp(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        conditionId: 'dummy',
        startDate: 0,
        severity: 1,
        triggers: [],
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));
  provideDummy<Result<Map<String, int>, AppError>>(const Success({}));

  group('FlareUpRepositoryImpl', () {
    late MockFlareUpDao mockDao;
    late MockDeviceInfoService mockDeviceInfoService;
    late Uuid uuid;
    late FlareUpRepositoryImpl repository;

    const testDeviceId = 'test-device-123';
    const testProfileId = 'profile-001';

    FlareUp createTestFlareUp({
      String id = 'flare-001',
      String clientId = 'client-001',
      String profileId = testProfileId,
      String conditionId = 'cond-001',
      int startDate = 1704067200000,
      int? endDate,
      int severity = 5,
      List<String> triggers = const ['stress'],
      SyncMetadata? syncMetadata,
    }) => FlareUp(
      id: id,
      clientId: clientId,
      profileId: profileId,
      conditionId: conditionId,
      startDate: startDate,
      endDate: endDate,
      severity: severity,
      triggers: triggers,
      syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'old-device'),
    );

    setUp(() {
      mockDao = MockFlareUpDao();
      mockDeviceInfoService = MockDeviceInfoService();
      uuid = const Uuid();
      repository = FlareUpRepositoryImpl(mockDao, uuid, mockDeviceInfoService);

      when(
        mockDeviceInfoService.getDeviceId(),
      ).thenAnswer((_) async => testDeviceId);
    });

    group('getAll', () {
      test('getAll_delegatesToDao', () async {
        final flareUps = [createTestFlareUp()];
        when(mockDao.getAll()).thenAnswer((_) async => Success(flareUps));

        final result = await repository.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, flareUps);
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
        final flareUp = createTestFlareUp();
        when(
          mockDao.getById('flare-001'),
        ).thenAnswer((_) async => Success(flareUp));

        final result = await repository.getById('flare-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, flareUp);
        verify(mockDao.getById('flare-001')).called(1);
      });

      test('getById_returnsFailureWhenNotFound', () async {
        when(mockDao.getById('non-existent')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('FlareUp', 'non-existent')),
        );

        final result = await repository.getById('non-existent');

        expect(result.isFailure, isTrue);
      });
    });

    group('create', () {
      test('create_generatesIdWhenEmpty', () async {
        final flareUp = createTestFlareUp(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as FlareUp;
          return Success(created);
        });

        final result = await repository.create(flareUp);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.id, isNotEmpty);
        expect(created.id.length, 36);
      });

      test('create_usesExistingIdWhenProvided', () async {
        final flareUp = createTestFlareUp(id: 'my-custom-id');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as FlareUp;
          return Success(created);
        });

        final result = await repository.create(flareUp);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, 'my-custom-id');
      });

      test('create_setsSyncMetadataWithDeviceId', () async {
        final flareUp = createTestFlareUp(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as FlareUp;
          return Success(created);
        });

        final result = await repository.create(flareUp);

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
        final flareUp = createTestFlareUp(
          syncMetadata: const SyncMetadata(
            syncCreatedAt: 1000,
            syncUpdatedAt: 1000,
            syncDeviceId: 'old-device',
            syncStatus: SyncStatus.synced,
          ),
        );
        when(mockDao.updateEntity(any)).thenAnswer((invocation) async {
          final updated = invocation.positionalArguments[0] as FlareUp;
          return Success(updated);
        });

        final result = await repository.update(flareUp);

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
        final flareUp = createTestFlareUp(syncMetadata: originalMetadata);
        when(mockDao.updateEntity(any, markDirty: false)).thenAnswer((
          invocation,
        ) async {
          final updated = invocation.positionalArguments[0] as FlareUp;
          return Success(updated);
        });

        final result = await repository.update(flareUp, markDirty: false);

        expect(result.isSuccess, isTrue);
        final updated = result.valueOrNull!;
        expect(updated.syncMetadata.syncVersion, 5);
        expect(updated.syncMetadata.syncStatus, SyncStatus.synced);
        verifyNever(mockDeviceInfoService.getDeviceId());
      });

      test('update_delegatesToDaoWithMarkDirtyFlag', () async {
        final flareUp = createTestFlareUp();
        when(
          mockDao.updateEntity(any, markDirty: false),
        ).thenAnswer((_) async => Success(flareUp));

        await repository.update(flareUp, markDirty: false);

        verify(mockDao.updateEntity(any, markDirty: false)).called(1);
      });
    });

    group('delete', () {
      test('delete_delegatesToDaoSoftDelete', () async {
        when(
          mockDao.softDelete('flare-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.delete('flare-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.softDelete('flare-001')).called(1);
      });
    });

    group('hardDelete', () {
      test('hardDelete_delegatesToDaoHardDelete', () async {
        when(
          mockDao.hardDelete('flare-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.hardDelete('flare-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.hardDelete('flare-001')).called(1);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_delegatesToDao', () async {
        final flareUps = [createTestFlareUp()];
        when(
          mockDao.getModifiedSince(1000),
        ).thenAnswer((_) async => Success(flareUps));

        final result = await repository.getModifiedSince(1000);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, flareUps);
        verify(mockDao.getModifiedSince(1000)).called(1);
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_delegatesToDao', () async {
        final flareUps = [createTestFlareUp()];
        when(
          mockDao.getPendingSync(),
        ).thenAnswer((_) async => Success(flareUps));

        final result = await repository.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, flareUps);
        verify(mockDao.getPendingSync()).called(1);
      });
    });

    group('getByCondition', () {
      test('getByCondition_delegatesToDao', () async {
        final flareUps = [createTestFlareUp()];
        when(
          mockDao.getByCondition('cond-001'),
        ).thenAnswer((_) async => Success(flareUps));

        final result = await repository.getByCondition('cond-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, flareUps);
        verify(mockDao.getByCondition('cond-001')).called(1);
      });

      test('getByCondition_passesAllParametersToDao', () async {
        when(
          mockDao.getByCondition(
            'cond-001',
            startDate: 1000,
            endDate: 2000,
            ongoingOnly: true,
            limit: 10,
            offset: 5,
          ),
        ).thenAnswer((_) async => const Success([]));

        await repository.getByCondition(
          'cond-001',
          startDate: 1000,
          endDate: 2000,
          ongoingOnly: true,
          limit: 10,
          offset: 5,
        );

        verify(
          mockDao.getByCondition(
            'cond-001',
            startDate: 1000,
            endDate: 2000,
            ongoingOnly: true,
            limit: 10,
            offset: 5,
          ),
        ).called(1);
      });
    });

    group('getByProfile', () {
      test('getByProfile_delegatesToDao', () async {
        final flareUps = [createTestFlareUp()];
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Success(flareUps));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, flareUps);
        verify(mockDao.getByProfile(testProfileId)).called(1);
      });

      test('getByProfile_passesAllParametersToDao', () async {
        when(
          mockDao.getByProfile(
            testProfileId,
            startDate: 1000,
            endDate: 2000,
            ongoingOnly: true,
            limit: 10,
            offset: 5,
          ),
        ).thenAnswer((_) async => const Success([]));

        await repository.getByProfile(
          testProfileId,
          startDate: 1000,
          endDate: 2000,
          ongoingOnly: true,
          limit: 10,
          offset: 5,
        );

        verify(
          mockDao.getByProfile(
            testProfileId,
            startDate: 1000,
            endDate: 2000,
            ongoingOnly: true,
            limit: 10,
            offset: 5,
          ),
        ).called(1);
      });
    });

    group('getOngoing', () {
      test('getOngoing_delegatesToDao', () async {
        final flareUps = [createTestFlareUp()];
        when(
          mockDao.getOngoing(testProfileId),
        ).thenAnswer((_) async => Success(flareUps));

        final result = await repository.getOngoing(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, flareUps);
        verify(mockDao.getOngoing(testProfileId)).called(1);
      });
    });

    group('getTriggerCounts', () {
      test('getTriggerCounts_delegatesToDao', () async {
        const counts = {'stress': 5, 'lack_of_sleep': 3};
        when(
          mockDao.getTriggerCounts('cond-001', startDate: 1000, endDate: 2000),
        ).thenAnswer((_) async => const Success(counts));

        final result = await repository.getTriggerCounts(
          'cond-001',
          startDate: 1000,
          endDate: 2000,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, counts);
        verify(
          mockDao.getTriggerCounts('cond-001', startDate: 1000, endDate: 2000),
        ).called(1);
      });
    });

    group('endFlareUp', () {
      test('endFlareUp_delegatesToDao', () async {
        final flareUp = createTestFlareUp(endDate: 2000);
        when(
          mockDao.endFlareUp('flare-001', 2000),
        ).thenAnswer((_) async => Success(flareUp));

        final result = await repository.endFlareUp('flare-001', 2000);

        expect(result.isSuccess, isTrue);
        verify(mockDao.endFlareUp('flare-001', 2000)).called(1);
      });
    });
  });
}
