// test/unit/data/repositories/photo_area_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/photo_area_dao.dart';
import 'package:shadow_app/data/repositories/photo_area_repository_impl.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:uuid/uuid.dart';

@GenerateMocks([PhotoAreaDao, DeviceInfoService])
import 'photo_area_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<PhotoArea>, AppError>>(const Success([]));
  provideDummy<Result<PhotoArea, AppError>>(
    const Success(
      PhotoArea(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        name: 'Dummy',
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));

  group('PhotoAreaRepositoryImpl', () {
    late MockPhotoAreaDao mockDao;
    late MockDeviceInfoService mockDeviceInfoService;
    late Uuid uuid;
    late PhotoAreaRepositoryImpl repository;

    const testDeviceId = 'test-device-123';
    const testProfileId = 'profile-001';

    PhotoArea createTestPhotoArea({
      String id = 'area-001',
      String clientId = 'client-001',
      String profileId = testProfileId,
      String name = 'Test Area',
      int sortOrder = 0,
      bool isArchived = false,
      SyncMetadata? syncMetadata,
    }) => PhotoArea(
      id: id,
      clientId: clientId,
      profileId: profileId,
      name: name,
      sortOrder: sortOrder,
      isArchived: isArchived,
      syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'old-device'),
    );

    setUp(() {
      mockDao = MockPhotoAreaDao();
      mockDeviceInfoService = MockDeviceInfoService();
      uuid = const Uuid();
      repository = PhotoAreaRepositoryImpl(
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
        final areas = [createTestPhotoArea()];
        when(mockDao.getAll()).thenAnswer((_) async => Success(areas));

        final result = await repository.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, areas);
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
        final area = createTestPhotoArea();
        when(
          mockDao.getById('area-001'),
        ).thenAnswer((_) async => Success(area));

        final result = await repository.getById('area-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, area);
        verify(mockDao.getById('area-001')).called(1);
      });

      test('getById_returnsFailureWhenNotFound', () async {
        when(mockDao.getById('non-existent')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('PhotoArea', 'non-existent')),
        );

        final result = await repository.getById('non-existent');

        expect(result.isFailure, isTrue);
      });
    });

    group('create', () {
      test('create_generatesIdWhenEmpty', () async {
        final area = createTestPhotoArea(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as PhotoArea;
          return Success(created);
        });

        final result = await repository.create(area);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.id, isNotEmpty);
        expect(created.id.length, 36);
      });

      test('create_usesExistingIdWhenProvided', () async {
        final area = createTestPhotoArea(id: 'my-custom-id');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as PhotoArea;
          return Success(created);
        });

        final result = await repository.create(area);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, 'my-custom-id');
      });

      test('create_setsSyncMetadataWithDeviceId', () async {
        final area = createTestPhotoArea(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as PhotoArea;
          return Success(created);
        });

        final result = await repository.create(area);

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
        final area = createTestPhotoArea(
          syncMetadata: const SyncMetadata(
            syncCreatedAt: 1000,
            syncUpdatedAt: 1000,
            syncDeviceId: 'old-device',
            syncStatus: SyncStatus.synced,
          ),
        );
        when(mockDao.updateEntity(any)).thenAnswer((invocation) async {
          final updated = invocation.positionalArguments[0] as PhotoArea;
          return Success(updated);
        });

        final result = await repository.update(area);

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
        final area = createTestPhotoArea(syncMetadata: originalMetadata);
        when(mockDao.updateEntity(any, markDirty: false)).thenAnswer((
          invocation,
        ) async {
          final updated = invocation.positionalArguments[0] as PhotoArea;
          return Success(updated);
        });

        final result = await repository.update(area, markDirty: false);

        expect(result.isSuccess, isTrue);
        final updated = result.valueOrNull!;
        expect(updated.syncMetadata.syncVersion, 5);
        expect(updated.syncMetadata.syncStatus, SyncStatus.synced);
        verifyNever(mockDeviceInfoService.getDeviceId());
      });

      test('update_delegatesToDaoWithMarkDirtyFlag', () async {
        final area = createTestPhotoArea();
        when(
          mockDao.updateEntity(any, markDirty: false),
        ).thenAnswer((_) async => Success(area));

        await repository.update(area, markDirty: false);

        verify(mockDao.updateEntity(any, markDirty: false)).called(1);
      });
    });

    group('delete', () {
      test('delete_delegatesToDaoSoftDelete', () async {
        when(
          mockDao.softDelete('area-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.delete('area-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.softDelete('area-001')).called(1);
      });
    });

    group('hardDelete', () {
      test('hardDelete_delegatesToDaoHardDelete', () async {
        when(
          mockDao.hardDelete('area-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.hardDelete('area-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.hardDelete('area-001')).called(1);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_delegatesToDao', () async {
        final areas = [createTestPhotoArea()];
        when(
          mockDao.getModifiedSince(1000),
        ).thenAnswer((_) async => Success(areas));

        final result = await repository.getModifiedSince(1000);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, areas);
        verify(mockDao.getModifiedSince(1000)).called(1);
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_delegatesToDao', () async {
        final areas = [createTestPhotoArea()];
        when(mockDao.getPendingSync()).thenAnswer((_) async => Success(areas));

        final result = await repository.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, areas);
        verify(mockDao.getPendingSync()).called(1);
      });
    });

    group('getByProfile', () {
      test('getByProfile_delegatesToDao', () async {
        final areas = [createTestPhotoArea()];
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Success(areas));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, areas);
        verify(mockDao.getByProfile(testProfileId)).called(1);
      });

      test('getByProfile_passesIncludeArchivedToDao', () async {
        when(
          mockDao.getByProfile(testProfileId, includeArchived: true),
        ).thenAnswer((_) async => const Success([]));

        await repository.getByProfile(testProfileId, includeArchived: true);

        verify(
          mockDao.getByProfile(testProfileId, includeArchived: true),
        ).called(1);
      });
    });

    group('reorder', () {
      test('reorder_delegatesToDao', () async {
        when(
          mockDao.reorder(testProfileId, ['a1', 'a2', 'a3']),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.reorder(testProfileId, [
          'a1',
          'a2',
          'a3',
        ]);

        expect(result.isSuccess, isTrue);
        verify(mockDao.reorder(testProfileId, ['a1', 'a2', 'a3'])).called(1);
      });
    });

    group('archive', () {
      test('archive_delegatesToDao', () async {
        when(
          mockDao.archive('area-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.archive('area-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.archive('area-001')).called(1);
      });
    });
  });
}
