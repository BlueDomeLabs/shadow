// test/unit/data/repositories/condition_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/condition_dao.dart';
import 'package:shadow_app/data/repositories/condition_repository_impl.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:uuid/uuid.dart';

@GenerateMocks([ConditionDao, DeviceInfoService])
import 'condition_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<Condition>, AppError>>(const Success([]));
  provideDummy<Result<Condition, AppError>>(
    const Success(
      Condition(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        name: 'Dummy',
        category: 'skin',
        bodyLocations: [],
        startTimeframe: 0,
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));

  group('ConditionRepositoryImpl', () {
    late MockConditionDao mockDao;
    late MockDeviceInfoService mockDeviceInfoService;
    late Uuid uuid;
    late ConditionRepositoryImpl repository;

    const testDeviceId = 'test-device-123';
    const testProfileId = 'profile-001';

    Condition createTestCondition({
      String id = 'cond-001',
      String clientId = 'client-001',
      String profileId = testProfileId,
      String name = 'Test Condition',
      String category = 'skin',
      List<String> bodyLocations = const ['arm'],
      int startTimeframe = 1704067200000,
      ConditionStatus status = ConditionStatus.active,
      bool isArchived = false,
      SyncMetadata? syncMetadata,
    }) => Condition(
      id: id,
      clientId: clientId,
      profileId: profileId,
      name: name,
      category: category,
      bodyLocations: bodyLocations,
      startTimeframe: startTimeframe,
      status: status,
      isArchived: isArchived,
      syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'old-device'),
    );

    setUp(() {
      mockDao = MockConditionDao();
      mockDeviceInfoService = MockDeviceInfoService();
      uuid = const Uuid();
      repository = ConditionRepositoryImpl(
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
        final conditions = [createTestCondition()];
        when(mockDao.getAll()).thenAnswer((_) async => Success(conditions));

        final result = await repository.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, conditions);
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
        final condition = createTestCondition();
        when(
          mockDao.getById('cond-001'),
        ).thenAnswer((_) async => Success(condition));

        final result = await repository.getById('cond-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, condition);
        verify(mockDao.getById('cond-001')).called(1);
      });

      test('getById_returnsFailureWhenNotFound', () async {
        when(mockDao.getById('non-existent')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('Condition', 'non-existent')),
        );

        final result = await repository.getById('non-existent');

        expect(result.isFailure, isTrue);
      });
    });

    group('create', () {
      test('create_generatesIdWhenEmpty', () async {
        final condition = createTestCondition(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as Condition;
          return Success(created);
        });

        final result = await repository.create(condition);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.id, isNotEmpty);
        expect(created.id.length, 36);
      });

      test('create_usesExistingIdWhenProvided', () async {
        final condition = createTestCondition(id: 'my-custom-id');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as Condition;
          return Success(created);
        });

        final result = await repository.create(condition);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, 'my-custom-id');
      });

      test('create_setsSyncMetadataWithDeviceId', () async {
        final condition = createTestCondition(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as Condition;
          return Success(created);
        });

        final result = await repository.create(condition);

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
        final condition = createTestCondition(
          syncMetadata: const SyncMetadata(
            syncCreatedAt: 1000,
            syncUpdatedAt: 1000,
            syncDeviceId: 'old-device',
            syncStatus: SyncStatus.synced,
          ),
        );
        when(mockDao.updateEntity(any)).thenAnswer((invocation) async {
          final updated = invocation.positionalArguments[0] as Condition;
          return Success(updated);
        });

        final result = await repository.update(condition);

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
        final condition = createTestCondition(syncMetadata: originalMetadata);
        when(mockDao.updateEntity(any, markDirty: false)).thenAnswer((
          invocation,
        ) async {
          final updated = invocation.positionalArguments[0] as Condition;
          return Success(updated);
        });

        final result = await repository.update(condition, markDirty: false);

        expect(result.isSuccess, isTrue);
        final updated = result.valueOrNull!;
        expect(updated.syncMetadata.syncVersion, 5);
        expect(updated.syncMetadata.syncStatus, SyncStatus.synced);
        verifyNever(mockDeviceInfoService.getDeviceId());
      });

      test('update_delegatesToDaoWithMarkDirtyFlag', () async {
        final condition = createTestCondition();
        when(
          mockDao.updateEntity(any, markDirty: false),
        ).thenAnswer((_) async => Success(condition));

        await repository.update(condition, markDirty: false);

        verify(mockDao.updateEntity(any, markDirty: false)).called(1);
      });
    });

    group('delete', () {
      test('delete_delegatesToDaoSoftDelete', () async {
        when(
          mockDao.softDelete('cond-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.delete('cond-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.softDelete('cond-001')).called(1);
      });
    });

    group('hardDelete', () {
      test('hardDelete_delegatesToDaoHardDelete', () async {
        when(
          mockDao.hardDelete('cond-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.hardDelete('cond-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.hardDelete('cond-001')).called(1);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_delegatesToDao', () async {
        final conditions = [createTestCondition()];
        when(
          mockDao.getModifiedSince(1000),
        ).thenAnswer((_) async => Success(conditions));

        final result = await repository.getModifiedSince(1000);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, conditions);
        verify(mockDao.getModifiedSince(1000)).called(1);
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_delegatesToDao', () async {
        final conditions = [createTestCondition()];
        when(
          mockDao.getPendingSync(),
        ).thenAnswer((_) async => Success(conditions));

        final result = await repository.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, conditions);
        verify(mockDao.getPendingSync()).called(1);
      });
    });

    group('getByProfile', () {
      test('getByProfile_delegatesToDao', () async {
        final conditions = [createTestCondition()];
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Success(conditions));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, conditions);
        verify(mockDao.getByProfile(testProfileId)).called(1);
      });

      test('getByProfile_passesAllParametersToDao', () async {
        when(
          mockDao.getByProfile(
            testProfileId,
            status: ConditionStatus.active,
            includeArchived: true,
          ),
        ).thenAnswer((_) async => const Success([]));

        await repository.getByProfile(
          testProfileId,
          status: ConditionStatus.active,
          includeArchived: true,
        );

        verify(
          mockDao.getByProfile(
            testProfileId,
            status: ConditionStatus.active,
            includeArchived: true,
          ),
        ).called(1);
      });
    });

    group('getActive', () {
      test('getActive_delegatesToDao', () async {
        final conditions = [createTestCondition()];
        when(
          mockDao.getActive(testProfileId),
        ).thenAnswer((_) async => Success(conditions));

        final result = await repository.getActive(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, conditions);
        verify(mockDao.getActive(testProfileId)).called(1);
      });
    });

    group('archive', () {
      test('archive_delegatesToDao', () async {
        when(
          mockDao.archive('cond-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.archive('cond-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.archive('cond-001')).called(1);
      });
    });

    group('resolve', () {
      test('resolve_delegatesToDao', () async {
        when(
          mockDao.resolve('cond-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.resolve('cond-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.resolve('cond-001')).called(1);
      });
    });
  });
}
