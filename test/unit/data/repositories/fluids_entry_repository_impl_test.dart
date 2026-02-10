// test/unit/data/repositories/fluids_entry_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/fluids_entry_dao.dart';
import 'package:shadow_app/data/repositories/fluids_entry_repository_impl.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:uuid/uuid.dart';

@GenerateMocks([FluidsEntryDao, DeviceInfoService])
import 'fluids_entry_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<FluidsEntry>, AppError>>(const Success([]));
  provideDummy<Result<FluidsEntry, AppError>>(
    const Success(
      FluidsEntry(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        entryDate: 0,
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<FluidsEntry?, AppError>>(const Success(null));
  provideDummy<Result<void, AppError>>(const Success(null));

  group('FluidsEntryRepositoryImpl', () {
    late MockFluidsEntryDao mockDao;
    late MockDeviceInfoService mockDeviceInfoService;
    late Uuid uuid;
    late FluidsEntryRepositoryImpl repository;

    const testDeviceId = 'test-device-123';
    const testProfileId = 'profile-001';

    FluidsEntry createTestFluidsEntry({
      String id = 'fluid-001',
      String clientId = 'client-001',
      String profileId = testProfileId,
      int entryDate = 1704067200000,
      int? waterIntakeMl,
      SyncMetadata? syncMetadata,
    }) => FluidsEntry(
      id: id,
      clientId: clientId,
      profileId: profileId,
      entryDate: entryDate,
      waterIntakeMl: waterIntakeMl,
      syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'old-device'),
    );

    setUp(() {
      mockDao = MockFluidsEntryDao();
      mockDeviceInfoService = MockDeviceInfoService();
      uuid = const Uuid();
      repository = FluidsEntryRepositoryImpl(
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
        final entries = [createTestFluidsEntry()];
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
        final entry = createTestFluidsEntry();
        when(
          mockDao.getById('fluid-001'),
        ).thenAnswer((_) async => Success(entry));

        final result = await repository.getById('fluid-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entry);
        verify(mockDao.getById('fluid-001')).called(1);
      });

      test('getById_returnsFailureWhenNotFound', () async {
        when(mockDao.getById('non-existent')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('FluidsEntry', 'non-existent')),
        );

        final result = await repository.getById('non-existent');

        expect(result.isFailure, isTrue);
      });
    });

    group('create', () {
      test('create_generatesIdWhenEmpty', () async {
        final entry = createTestFluidsEntry(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as FluidsEntry;
          return Success(created);
        });

        final result = await repository.create(entry);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.id, isNotEmpty);
        expect(created.id.length, 36);
      });

      test('create_usesExistingIdWhenProvided', () async {
        final entry = createTestFluidsEntry(id: 'my-custom-id');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as FluidsEntry;
          return Success(created);
        });

        final result = await repository.create(entry);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, 'my-custom-id');
      });

      test('create_setsSyncMetadataWithDeviceId', () async {
        final entry = createTestFluidsEntry(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as FluidsEntry;
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
        final entry = createTestFluidsEntry(
          syncMetadata: const SyncMetadata(
            syncCreatedAt: 1000,
            syncUpdatedAt: 1000,
            syncDeviceId: 'old-device',
            syncStatus: SyncStatus.synced,
          ),
        );
        when(mockDao.updateEntity(any)).thenAnswer((invocation) async {
          final updated = invocation.positionalArguments[0] as FluidsEntry;
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
        final entry = createTestFluidsEntry(syncMetadata: originalMetadata);
        when(mockDao.updateEntity(any)).thenAnswer((invocation) async {
          final updated = invocation.positionalArguments[0] as FluidsEntry;
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
          mockDao.softDelete('fluid-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.delete('fluid-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.softDelete('fluid-001')).called(1);
      });
    });

    group('hardDelete', () {
      test('hardDelete_delegatesToDaoHardDelete', () async {
        when(
          mockDao.hardDelete('fluid-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.hardDelete('fluid-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.hardDelete('fluid-001')).called(1);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_delegatesToDao', () async {
        final entries = [createTestFluidsEntry()];
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
        final entries = [createTestFluidsEntry()];
        when(
          mockDao.getPendingSync(),
        ).thenAnswer((_) async => Success(entries));

        final result = await repository.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entries);
        verify(mockDao.getPendingSync()).called(1);
      });
    });

    group('getByDateRange', () {
      test('getByDateRange_delegatesToDao', () async {
        final entries = [createTestFluidsEntry()];
        when(
          mockDao.getByDateRange(testProfileId, 1000, 2000),
        ).thenAnswer((_) async => Success(entries));

        final result = await repository.getByDateRange(
          testProfileId,
          1000,
          2000,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entries);
        verify(mockDao.getByDateRange(testProfileId, 1000, 2000)).called(1);
      });
    });

    group('getBBTEntries', () {
      test('getBBTEntries_delegatesToDao', () async {
        final entries = [createTestFluidsEntry()];
        when(
          mockDao.getBBTEntries(testProfileId, 1000, 2000),
        ).thenAnswer((_) async => Success(entries));

        final result = await repository.getBBTEntries(
          testProfileId,
          1000,
          2000,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entries);
        verify(mockDao.getBBTEntries(testProfileId, 1000, 2000)).called(1);
      });
    });

    group('getMenstruationEntries', () {
      test('getMenstruationEntries_delegatesToDao', () async {
        final entries = [createTestFluidsEntry()];
        when(
          mockDao.getMenstruationEntries(testProfileId, 1000, 2000),
        ).thenAnswer((_) async => Success(entries));

        final result = await repository.getMenstruationEntries(
          testProfileId,
          1000,
          2000,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entries);
        verify(
          mockDao.getMenstruationEntries(testProfileId, 1000, 2000),
        ).called(1);
      });
    });

    group('getTodayEntry', () {
      test('getTodayEntry_returnsFirstEntryForToday', () async {
        final entry = createTestFluidsEntry();
        when(
          mockDao.getByDateRange(testProfileId, any, any),
        ).thenAnswer((_) async => Success([entry]));

        final result = await repository.getTodayEntry(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entry);
      });

      test('getTodayEntry_returnsNullWhenNoEntryForToday', () async {
        when(
          mockDao.getByDateRange(testProfileId, any, any),
        ).thenAnswer((_) async => const Success([]));

        final result = await repository.getTodayEntry(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });

      test('getTodayEntry_returnsFailureFromDao', () async {
        when(mockDao.getByDateRange(testProfileId, any, any)).thenAnswer(
          (_) async =>
              Failure(DatabaseError.queryFailed('fluids_entries', 'error')),
        );

        final result = await repository.getTodayEntry(testProfileId);

        expect(result.isFailure, isTrue);
      });
    });
  });
}
