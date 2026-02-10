// test/unit/data/repositories/photo_entry_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/photo_entry_dao.dart';
import 'package:shadow_app/data/repositories/photo_entry_repository_impl.dart';
import 'package:shadow_app/domain/entities/photo_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:uuid/uuid.dart';

@GenerateMocks([PhotoEntryDao, DeviceInfoService])
import 'photo_entry_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<PhotoEntry>, AppError>>(const Success([]));
  provideDummy<Result<PhotoEntry, AppError>>(
    const Success(
      PhotoEntry(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        photoAreaId: 'dummy',
        timestamp: 0,
        filePath: '/dummy.jpg',
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));

  group('PhotoEntryRepositoryImpl', () {
    late MockPhotoEntryDao mockDao;
    late MockDeviceInfoService mockDeviceInfoService;
    late Uuid uuid;
    late PhotoEntryRepositoryImpl repository;

    const testDeviceId = 'test-device-123';
    const testProfileId = 'profile-001';

    PhotoEntry createTestPhotoEntry({
      String id = 'photo-001',
      String clientId = 'client-001',
      String profileId = testProfileId,
      String photoAreaId = 'area-001',
      int timestamp = 1704067200000,
      String filePath = '/photos/test.jpg',
      SyncMetadata? syncMetadata,
    }) => PhotoEntry(
      id: id,
      clientId: clientId,
      profileId: profileId,
      photoAreaId: photoAreaId,
      timestamp: timestamp,
      filePath: filePath,
      syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'old-device'),
    );

    setUp(() {
      mockDao = MockPhotoEntryDao();
      mockDeviceInfoService = MockDeviceInfoService();
      uuid = const Uuid();
      repository = PhotoEntryRepositoryImpl(
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
        final entries = [createTestPhotoEntry()];
        when(mockDao.getAll()).thenAnswer((_) async => Success(entries));

        final result = await repository.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entries);
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
        final entry = createTestPhotoEntry();
        when(
          mockDao.getById('photo-001'),
        ).thenAnswer((_) async => Success(entry));

        final result = await repository.getById('photo-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entry);
        verify(mockDao.getById('photo-001')).called(1);
      });

      test('getById_returnsFailureWhenNotFound', () async {
        when(mockDao.getById('non-existent')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('PhotoEntry', 'non-existent')),
        );

        final result = await repository.getById('non-existent');

        expect(result.isFailure, isTrue);
      });
    });

    group('create', () {
      test('create_generatesIdWhenEmpty', () async {
        final entry = createTestPhotoEntry(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as PhotoEntry;
          return Success(created);
        });

        final result = await repository.create(entry);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.id, isNotEmpty);
        expect(created.id.length, 36);
      });

      test('create_usesExistingIdWhenProvided', () async {
        final entry = createTestPhotoEntry(id: 'my-custom-id');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as PhotoEntry;
          return Success(created);
        });

        final result = await repository.create(entry);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, 'my-custom-id');
      });

      test('create_setsSyncMetadataWithDeviceId', () async {
        final entry = createTestPhotoEntry(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as PhotoEntry;
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
        final entry = createTestPhotoEntry(
          syncMetadata: const SyncMetadata(
            syncCreatedAt: 1000,
            syncUpdatedAt: 1000,
            syncDeviceId: 'old-device',
            syncStatus: SyncStatus.synced,
          ),
        );
        when(mockDao.updateEntity(any)).thenAnswer((invocation) async {
          final updated = invocation.positionalArguments[0] as PhotoEntry;
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
        final entry = createTestPhotoEntry(syncMetadata: originalMetadata);
        when(mockDao.updateEntity(any, markDirty: false)).thenAnswer((
          invocation,
        ) async {
          final updated = invocation.positionalArguments[0] as PhotoEntry;
          return Success(updated);
        });

        final result = await repository.update(entry, markDirty: false);

        expect(result.isSuccess, isTrue);
        final updated = result.valueOrNull!;
        expect(updated.syncMetadata.syncVersion, 5);
        expect(updated.syncMetadata.syncStatus, SyncStatus.synced);
        verifyNever(mockDeviceInfoService.getDeviceId());
      });

      test('update_delegatesToDaoWithMarkDirtyFlag', () async {
        final entry = createTestPhotoEntry();
        when(
          mockDao.updateEntity(any, markDirty: false),
        ).thenAnswer((_) async => Success(entry));

        await repository.update(entry, markDirty: false);

        verify(mockDao.updateEntity(any, markDirty: false)).called(1);
      });
    });

    group('delete', () {
      test('delete_delegatesToDaoSoftDelete', () async {
        when(
          mockDao.softDelete('photo-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.delete('photo-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.softDelete('photo-001')).called(1);
      });
    });

    group('hardDelete', () {
      test('hardDelete_delegatesToDaoHardDelete', () async {
        when(
          mockDao.hardDelete('photo-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.hardDelete('photo-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.hardDelete('photo-001')).called(1);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_delegatesToDao', () async {
        final entries = [createTestPhotoEntry()];
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
        final entries = [createTestPhotoEntry()];
        when(
          mockDao.getPendingSync(),
        ).thenAnswer((_) async => Success(entries));

        final result = await repository.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entries);
        verify(mockDao.getPendingSync()).called(1);
      });
    });

    group('getByArea', () {
      test('getByArea_delegatesToDao', () async {
        final entries = [createTestPhotoEntry()];
        when(
          mockDao.getByArea('area-001'),
        ).thenAnswer((_) async => Success(entries));

        final result = await repository.getByArea('area-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entries);
        verify(mockDao.getByArea('area-001')).called(1);
      });

      test('getByArea_passesAllParametersToDao', () async {
        when(
          mockDao.getByArea(
            'area-001',
            startDate: 1000,
            endDate: 2000,
            limit: 10,
            offset: 5,
          ),
        ).thenAnswer((_) async => const Success([]));

        await repository.getByArea(
          'area-001',
          startDate: 1000,
          endDate: 2000,
          limit: 10,
          offset: 5,
        );

        verify(
          mockDao.getByArea(
            'area-001',
            startDate: 1000,
            endDate: 2000,
            limit: 10,
            offset: 5,
          ),
        ).called(1);
      });
    });

    group('getByProfile', () {
      test('getByProfile_delegatesToDao', () async {
        final entries = [createTestPhotoEntry()];
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

    group('getPendingUpload', () {
      test('getPendingUpload_delegatesToDao', () async {
        final entries = [createTestPhotoEntry()];
        when(
          mockDao.getPendingUpload(),
        ).thenAnswer((_) async => Success(entries));

        final result = await repository.getPendingUpload();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entries);
        verify(mockDao.getPendingUpload()).called(1);
      });
    });
  });
}
