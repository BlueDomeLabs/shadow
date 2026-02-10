// test/unit/data/repositories/activity_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/activity_dao.dart';
import 'package:shadow_app/data/repositories/activity_repository_impl.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:uuid/uuid.dart';

@GenerateMocks([ActivityDao, DeviceInfoService])
import 'activity_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<Activity>, AppError>>(const Success([]));
  provideDummy<Result<Activity, AppError>>(
    const Success(
      Activity(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        name: 'Dummy',
        durationMinutes: 0,
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));

  group('ActivityRepositoryImpl', () {
    late MockActivityDao mockDao;
    late MockDeviceInfoService mockDeviceInfoService;
    late Uuid uuid;
    late ActivityRepositoryImpl repository;

    const testDeviceId = 'test-device-123';
    const testProfileId = 'profile-001';

    Activity createTestActivity({
      String id = 'act-001',
      String clientId = 'client-001',
      String profileId = testProfileId,
      String name = 'Test Activity',
      int durationMinutes = 30,
      bool isArchived = false,
      SyncMetadata? syncMetadata,
    }) => Activity(
      id: id,
      clientId: clientId,
      profileId: profileId,
      name: name,
      durationMinutes: durationMinutes,
      isArchived: isArchived,
      syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'old-device'),
    );

    setUp(() {
      mockDao = MockActivityDao();
      mockDeviceInfoService = MockDeviceInfoService();
      uuid = const Uuid();
      repository = ActivityRepositoryImpl(mockDao, uuid, mockDeviceInfoService);

      when(
        mockDeviceInfoService.getDeviceId(),
      ).thenAnswer((_) async => testDeviceId);
    });

    group('getAll', () {
      test('getAll_delegatesToDao', () async {
        final activities = [createTestActivity()];
        when(mockDao.getAll()).thenAnswer((_) async => Success(activities));

        final result = await repository.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, activities);
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

      test('getAll_returnsFailureFromDao', () async {
        when(mockDao.getAll()).thenAnswer(
          (_) async =>
              Failure(DatabaseError.queryFailed('activities', 'error')),
        );

        final result = await repository.getAll();

        expect(result.isFailure, isTrue);
      });
    });

    group('getById', () {
      test('getById_delegatesToDao', () async {
        final activity = createTestActivity();
        when(
          mockDao.getById('act-001'),
        ).thenAnswer((_) async => Success(activity));

        final result = await repository.getById('act-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, activity);
        verify(mockDao.getById('act-001')).called(1);
      });

      test('getById_returnsFailureWhenNotFound', () async {
        when(mockDao.getById('non-existent')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('Activity', 'non-existent')),
        );

        final result = await repository.getById('non-existent');

        expect(result.isFailure, isTrue);
      });
    });

    group('create', () {
      test('create_generatesIdWhenEmpty', () async {
        final activity = createTestActivity(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as Activity;
          return Success(created);
        });

        final result = await repository.create(activity);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.id, isNotEmpty);
        expect(created.id.length, 36);
      });

      test('create_usesExistingIdWhenProvided', () async {
        final activity = createTestActivity(id: 'my-custom-id');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as Activity;
          return Success(created);
        });

        final result = await repository.create(activity);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, 'my-custom-id');
      });

      test('create_setsSyncMetadataWithDeviceId', () async {
        final activity = createTestActivity(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as Activity;
          return Success(created);
        });

        final result = await repository.create(activity);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.syncMetadata.syncDeviceId, testDeviceId);
        expect(created.syncMetadata.syncStatus, SyncStatus.pending);
        expect(created.syncMetadata.syncVersion, 1);
        expect(created.syncMetadata.syncIsDirty, isTrue);
      });

      test('create_returnsFailureFromDao', () async {
        final activity = createTestActivity();
        when(mockDao.create(any)).thenAnswer(
          (_) async =>
              Failure(DatabaseError.constraintViolation('Duplicate ID')),
        );

        final result = await repository.create(activity);

        expect(result.isFailure, isTrue);
      });
    });

    group('update', () {
      test('update_marksDirtyByDefault', () async {
        final activity = createTestActivity(
          syncMetadata: const SyncMetadata(
            syncCreatedAt: 1000,
            syncUpdatedAt: 1000,
            syncDeviceId: 'old-device',
            syncStatus: SyncStatus.synced,
          ),
        );
        when(mockDao.updateEntity(any)).thenAnswer((invocation) async {
          final updated = invocation.positionalArguments[0] as Activity;
          return Success(updated);
        });

        final result = await repository.update(activity);

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
        final activity = createTestActivity(syncMetadata: originalMetadata);
        when(mockDao.updateEntity(any, markDirty: false)).thenAnswer((
          invocation,
        ) async {
          final updated = invocation.positionalArguments[0] as Activity;
          return Success(updated);
        });

        final result = await repository.update(activity, markDirty: false);

        expect(result.isSuccess, isTrue);
        final updated = result.valueOrNull!;
        expect(updated.syncMetadata.syncVersion, 5);
        expect(updated.syncMetadata.syncStatus, SyncStatus.synced);
        verifyNever(mockDeviceInfoService.getDeviceId());
      });

      test('update_delegatesToDaoWithMarkDirtyFlag', () async {
        final activity = createTestActivity();
        when(
          mockDao.updateEntity(any, markDirty: false),
        ).thenAnswer((_) async => Success(activity));

        await repository.update(activity, markDirty: false);

        verify(mockDao.updateEntity(any, markDirty: false)).called(1);
      });

      test('update_returnsFailureFromDao', () async {
        final activity = createTestActivity();
        when(mockDao.updateEntity(any)).thenAnswer(
          (_) async => Failure(DatabaseError.notFound('Activity', 'act-001')),
        );

        final result = await repository.update(activity);

        expect(result.isFailure, isTrue);
      });
    });

    group('delete', () {
      test('delete_delegatesToDaoSoftDelete', () async {
        when(
          mockDao.softDelete('act-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.delete('act-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.softDelete('act-001')).called(1);
      });

      test('delete_returnsFailureWhenNotFound', () async {
        when(mockDao.softDelete('non-existent')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('Activity', 'non-existent')),
        );

        final result = await repository.delete('non-existent');

        expect(result.isFailure, isTrue);
      });
    });

    group('hardDelete', () {
      test('hardDelete_delegatesToDaoHardDelete', () async {
        when(
          mockDao.hardDelete('act-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.hardDelete('act-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.hardDelete('act-001')).called(1);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_delegatesToDao', () async {
        final activities = [createTestActivity()];
        when(
          mockDao.getModifiedSince(1000),
        ).thenAnswer((_) async => Success(activities));

        final result = await repository.getModifiedSince(1000);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, activities);
        verify(mockDao.getModifiedSince(1000)).called(1);
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_delegatesToDao', () async {
        final activities = [createTestActivity()];
        when(
          mockDao.getPendingSync(),
        ).thenAnswer((_) async => Success(activities));

        final result = await repository.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, activities);
        verify(mockDao.getPendingSync()).called(1);
      });
    });

    group('getByProfile', () {
      test('getByProfile_delegatesToDao', () async {
        final activities = [createTestActivity()];
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Success(activities));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, activities);
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

    group('getActive', () {
      test('getActive_delegatesToDao', () async {
        final activities = [createTestActivity()];
        when(
          mockDao.getActive(testProfileId),
        ).thenAnswer((_) async => Success(activities));

        final result = await repository.getActive(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, activities);
        verify(mockDao.getActive(testProfileId)).called(1);
      });
    });

    group('archive', () {
      test('archive_delegatesToDao', () async {
        when(
          mockDao.archive('act-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.archive('act-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.archive('act-001')).called(1);
      });
    });

    group('unarchive', () {
      test('unarchive_delegatesToDao', () async {
        when(
          mockDao.unarchive('act-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.unarchive('act-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.unarchive('act-001')).called(1);
      });
    });
  });
}
