// test/unit/data/repositories/sleep_entry_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/sleep_entry_dao.dart';
import 'package:shadow_app/data/repositories/sleep_entry_repository_impl.dart';
import 'package:shadow_app/domain/entities/sleep_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:uuid/uuid.dart';

@GenerateMocks([SleepEntryDao, DeviceInfoService])
import 'sleep_entry_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<SleepEntry>, AppError>>(const Success([]));
  provideDummy<Result<SleepEntry, AppError>>(
    const Success(
      SleepEntry(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        bedTime: 0,
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<SleepEntry?, AppError>>(const Success(null));
  provideDummy<Result<void, AppError>>(const Success(null));
  provideDummy<Result<Map<String, double>, AppError>>(const Success({}));

  group('SleepEntryRepositoryImpl', () {
    late MockSleepEntryDao mockDao;
    late MockDeviceInfoService mockDeviceInfoService;
    late Uuid uuid;
    late SleepEntryRepositoryImpl repository;

    const testDeviceId = 'test-device-123';
    const testProfileId = 'profile-001';

    SleepEntry createTestSleepEntry({
      String id = 'sleep-001',
      String clientId = 'client-001',
      String profileId = testProfileId,
      int bedTime = 1704067200000,
      int? wakeTime,
      int deepSleepMinutes = 0,
      int lightSleepMinutes = 0,
      int restlessSleepMinutes = 0,
      SyncMetadata? syncMetadata,
    }) => SleepEntry(
      id: id,
      clientId: clientId,
      profileId: profileId,
      bedTime: bedTime,
      wakeTime: wakeTime,
      deepSleepMinutes: deepSleepMinutes,
      lightSleepMinutes: lightSleepMinutes,
      restlessSleepMinutes: restlessSleepMinutes,
      syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'old-device'),
    );

    setUp(() {
      mockDao = MockSleepEntryDao();
      mockDeviceInfoService = MockDeviceInfoService();
      uuid = const Uuid();
      repository = SleepEntryRepositoryImpl(
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
        final entries = [createTestSleepEntry()];
        when(mockDao.getAll()).thenAnswer((_) async => Success(entries));

        final result = await repository.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entries);
        verify(mockDao.getAll()).called(1);
      });

      test('getAll_passesProfileIdToDao', () async {
        when(
          mockDao.getAll(profileId: testProfileId),
        ).thenAnswer((_) async => const Success([]));

        await repository.getAll(profileId: testProfileId);

        verify(mockDao.getAll(profileId: testProfileId)).called(1);
      });
    });

    group('getById', () {
      test('getById_delegatesToDao', () async {
        final entry = createTestSleepEntry();
        when(
          mockDao.getById('sleep-001'),
        ).thenAnswer((_) async => Success(entry));

        final result = await repository.getById('sleep-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entry);
        verify(mockDao.getById('sleep-001')).called(1);
      });

      test('getById_returnsFailureWhenNotFound', () async {
        when(mockDao.getById('non-existent')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('SleepEntry', 'non-existent')),
        );

        final result = await repository.getById('non-existent');

        expect(result.isFailure, isTrue);
      });
    });

    group('create', () {
      test('create_generatesIdWhenEmpty', () async {
        final entry = createTestSleepEntry(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as SleepEntry;
          return Success(created);
        });

        final result = await repository.create(entry);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.id, isNotEmpty);
        expect(created.id.length, 36);
      });

      test('create_usesExistingIdWhenProvided', () async {
        final entry = createTestSleepEntry(id: 'my-custom-id');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as SleepEntry;
          return Success(created);
        });

        final result = await repository.create(entry);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, 'my-custom-id');
      });

      test('create_setsSyncMetadataWithDeviceId', () async {
        final entry = createTestSleepEntry(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as SleepEntry;
          return Success(created);
        });

        final result = await repository.create(entry);

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
        final entry = createTestSleepEntry(
          syncMetadata: const SyncMetadata(
            syncCreatedAt: 1000,
            syncUpdatedAt: 1000,
            syncDeviceId: 'old-device',
            syncStatus: SyncStatus.synced,
          ),
        );
        when(mockDao.updateEntity(any)).thenAnswer((invocation) async {
          final updated = invocation.positionalArguments[0] as SleepEntry;
          return Success(updated);
        });

        final result = await repository.update(entry);

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
        final entry = createTestSleepEntry(syncMetadata: originalMetadata);
        when(mockDao.updateEntity(any)).thenAnswer((invocation) async {
          final updated = invocation.positionalArguments[0] as SleepEntry;
          return Success(updated);
        });

        final result = await repository.update(entry, markDirty: false);

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
          mockDao.softDelete('sleep-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.delete('sleep-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.softDelete('sleep-001')).called(1);
      });
    });

    group('hardDelete', () {
      test('hardDelete_delegatesToDaoHardDelete', () async {
        when(
          mockDao.hardDelete('sleep-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.hardDelete('sleep-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.hardDelete('sleep-001')).called(1);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_delegatesToDao', () async {
        final entries = [createTestSleepEntry()];
        when(
          mockDao.getModifiedSince(1000),
        ).thenAnswer((_) async => Success(entries));

        final result = await repository.getModifiedSince(1000);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entries);
        verify(mockDao.getModifiedSince(1000)).called(1);
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_delegatesToDao', () async {
        final entries = [createTestSleepEntry()];
        when(
          mockDao.getPendingSync(),
        ).thenAnswer((_) async => Success(entries));

        final result = await repository.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entries);
        verify(mockDao.getPendingSync()).called(1);
      });
    });

    group('getByProfile', () {
      test('getByProfile_delegatesToDao', () async {
        final entries = [createTestSleepEntry()];
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Success(entries));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entries);
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

    group('getForNight', () {
      test('getForNight_delegatesToDao', () async {
        final entry = createTestSleepEntry();
        when(
          mockDao.getForNight(testProfileId, 1704067200000),
        ).thenAnswer((_) async => Success(entry));

        final result = await repository.getForNight(
          testProfileId,
          1704067200000,
        );

        expect(result.isSuccess, isTrue);
        verify(mockDao.getForNight(testProfileId, 1704067200000)).called(1);
      });
    });

    group('getAverages', () {
      test('getAverages_returnsAveragesFromEntries', () async {
        final entries = [
          createTestSleepEntry(
            id: 's1',
            bedTime: 1000,
            wakeTime: 1000 + 480 * 60000, // 8 hours
            deepSleepMinutes: 120,
            lightSleepMinutes: 240,
            restlessSleepMinutes: 30,
          ),
          createTestSleepEntry(
            id: 's2',
            bedTime: 2000,
            wakeTime: 2000 + 420 * 60000, // 7 hours
            deepSleepMinutes: 100,
            lightSleepMinutes: 200,
            restlessSleepMinutes: 20,
          ),
        ];
        when(
          mockDao.getByProfile(testProfileId, startDate: 1000, endDate: 2000),
        ).thenAnswer((_) async => Success(entries));

        final result = await repository.getAverages(
          testProfileId,
          startDate: 1000,
          endDate: 2000,
        );

        expect(result.isSuccess, isTrue);
        final averages = result.valueOrNull!;
        expect(averages['avgDeepSleepMinutes'], 110.0);
        expect(averages['avgLightSleepMinutes'], 220.0);
        expect(averages['avgRestlessSleepMinutes'], 25.0);
      });

      test('getAverages_returnsZerosWhenNoEntries', () async {
        when(
          mockDao.getByProfile(testProfileId, startDate: 1000, endDate: 2000),
        ).thenAnswer((_) async => const Success([]));

        final result = await repository.getAverages(
          testProfileId,
          startDate: 1000,
          endDate: 2000,
        );

        expect(result.isSuccess, isTrue);
        final averages = result.valueOrNull!;
        expect(averages['avgTotalSleepMinutes'], 0.0);
        expect(averages['avgDeepSleepMinutes'], 0.0);
        expect(averages['avgLightSleepMinutes'], 0.0);
        expect(averages['avgRestlessSleepMinutes'], 0.0);
      });

      test('getAverages_returnsFailureFromDao', () async {
        when(
          mockDao.getByProfile(testProfileId, startDate: 1000, endDate: 2000),
        ).thenAnswer(
          (_) async =>
              Failure(DatabaseError.queryFailed('sleep_entries', 'error')),
        );

        final result = await repository.getAverages(
          testProfileId,
          startDate: 1000,
          endDate: 2000,
        );

        expect(result.isFailure, isTrue);
      });
    });
  });
}
