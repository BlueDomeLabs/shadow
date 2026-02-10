// test/unit/data/repositories/food_item_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/food_item_dao.dart';
import 'package:shadow_app/data/repositories/food_item_repository_impl.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:uuid/uuid.dart';

@GenerateMocks([FoodItemDao, DeviceInfoService])
import 'food_item_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<FoodItem>, AppError>>(const Success([]));
  provideDummy<Result<FoodItem, AppError>>(
    const Success(
      FoodItem(
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

  group('FoodItemRepositoryImpl', () {
    late MockFoodItemDao mockDao;
    late MockDeviceInfoService mockDeviceInfoService;
    late Uuid uuid;
    late FoodItemRepositoryImpl repository;

    const testDeviceId = 'test-device-123';
    const testProfileId = 'profile-001';

    FoodItem createTestFoodItem({
      String id = 'food-001',
      String clientId = 'client-001',
      String profileId = testProfileId,
      String name = 'Test Food',
      FoodItemType type = FoodItemType.simple,
      bool isArchived = false,
      SyncMetadata? syncMetadata,
    }) => FoodItem(
      id: id,
      clientId: clientId,
      profileId: profileId,
      name: name,
      type: type,
      isArchived: isArchived,
      syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'old-device'),
    );

    setUp(() {
      mockDao = MockFoodItemDao();
      mockDeviceInfoService = MockDeviceInfoService();
      uuid = const Uuid();
      repository = FoodItemRepositoryImpl(mockDao, uuid, mockDeviceInfoService);

      when(
        mockDeviceInfoService.getDeviceId(),
      ).thenAnswer((_) async => testDeviceId);
    });

    group('getAll', () {
      test('getAll_delegatesToDao', () async {
        final items = [createTestFoodItem()];
        when(mockDao.getAll()).thenAnswer((_) async => Success(items));

        final result = await repository.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, items);
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
        final item = createTestFoodItem();
        when(
          mockDao.getById('food-001'),
        ).thenAnswer((_) async => Success(item));

        final result = await repository.getById('food-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, item);
        verify(mockDao.getById('food-001')).called(1);
      });

      test('getById_returnsFailureWhenNotFound', () async {
        when(mockDao.getById('non-existent')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('FoodItem', 'non-existent')),
        );

        final result = await repository.getById('non-existent');

        expect(result.isFailure, isTrue);
      });
    });

    group('create', () {
      test('create_generatesIdWhenEmpty', () async {
        final item = createTestFoodItem(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as FoodItem;
          return Success(created);
        });

        final result = await repository.create(item);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.id, isNotEmpty);
        expect(created.id.length, 36);
      });

      test('create_usesExistingIdWhenProvided', () async {
        final item = createTestFoodItem(id: 'my-custom-id');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as FoodItem;
          return Success(created);
        });

        final result = await repository.create(item);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, 'my-custom-id');
      });

      test('create_setsSyncMetadataWithDeviceId', () async {
        final item = createTestFoodItem(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as FoodItem;
          return Success(created);
        });

        final result = await repository.create(item);

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
        final item = createTestFoodItem(
          syncMetadata: const SyncMetadata(
            syncCreatedAt: 1000,
            syncUpdatedAt: 1000,
            syncDeviceId: 'old-device',
            syncStatus: SyncStatus.synced,
          ),
        );
        when(mockDao.updateEntity(any)).thenAnswer((invocation) async {
          final updated = invocation.positionalArguments[0] as FoodItem;
          return Success(updated);
        });

        final result = await repository.update(item);

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
        final item = createTestFoodItem(syncMetadata: originalMetadata);
        when(mockDao.updateEntity(any, markDirty: false)).thenAnswer((
          invocation,
        ) async {
          final updated = invocation.positionalArguments[0] as FoodItem;
          return Success(updated);
        });

        final result = await repository.update(item, markDirty: false);

        expect(result.isSuccess, isTrue);
        final updated = result.valueOrNull!;
        expect(updated.syncMetadata.syncVersion, 5);
        expect(updated.syncMetadata.syncStatus, SyncStatus.synced);
        verifyNever(mockDeviceInfoService.getDeviceId());
      });

      test('update_delegatesToDaoWithMarkDirtyFlag', () async {
        final item = createTestFoodItem();
        when(
          mockDao.updateEntity(any, markDirty: false),
        ).thenAnswer((_) async => Success(item));

        await repository.update(item, markDirty: false);

        verify(mockDao.updateEntity(any, markDirty: false)).called(1);
      });
    });

    group('delete', () {
      test('delete_delegatesToDaoSoftDelete', () async {
        when(
          mockDao.softDelete('food-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.delete('food-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.softDelete('food-001')).called(1);
      });
    });

    group('hardDelete', () {
      test('hardDelete_delegatesToDaoHardDelete', () async {
        when(
          mockDao.hardDelete('food-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.hardDelete('food-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.hardDelete('food-001')).called(1);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_delegatesToDao', () async {
        final items = [createTestFoodItem()];
        when(
          mockDao.getModifiedSince(1000),
        ).thenAnswer((_) async => Success(items));

        final result = await repository.getModifiedSince(1000);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, items);
        verify(mockDao.getModifiedSince(1000)).called(1);
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_delegatesToDao', () async {
        final items = [createTestFoodItem()];
        when(mockDao.getPendingSync()).thenAnswer((_) async => Success(items));

        final result = await repository.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, items);
        verify(mockDao.getPendingSync()).called(1);
      });
    });

    group('getByProfile', () {
      test('getByProfile_delegatesToDao', () async {
        final items = [createTestFoodItem()];
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Success(items));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, items);
        verify(mockDao.getByProfile(testProfileId)).called(1);
      });

      test('getByProfile_passesAllParametersToDao', () async {
        when(
          mockDao.getByProfile(
            testProfileId,
            type: FoodItemType.complex,
            includeArchived: true,
          ),
        ).thenAnswer((_) async => const Success([]));

        await repository.getByProfile(
          testProfileId,
          type: FoodItemType.complex,
          includeArchived: true,
        );

        verify(
          mockDao.getByProfile(
            testProfileId,
            type: FoodItemType.complex,
            includeArchived: true,
          ),
        ).called(1);
      });
    });

    group('search', () {
      test('search_delegatesToDao', () async {
        final items = [createTestFoodItem(name: 'Apple')];
        when(
          mockDao.search(testProfileId, 'apple'),
        ).thenAnswer((_) async => Success(items));

        final result = await repository.search(testProfileId, 'apple');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, items);
        verify(mockDao.search(testProfileId, 'apple')).called(1);
      });

      test('search_passesCustomLimitToDao', () async {
        when(
          mockDao.search(testProfileId, 'apple', limit: 50),
        ).thenAnswer((_) async => const Success([]));

        await repository.search(testProfileId, 'apple', limit: 50);

        verify(mockDao.search(testProfileId, 'apple', limit: 50)).called(1);
      });
    });

    group('archive', () {
      test('archive_delegatesToDao', () async {
        when(
          mockDao.archive('food-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.archive('food-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.archive('food-001')).called(1);
      });
    });

    group('searchExcludingCategories', () {
      test('searchExcludingCategories_delegatesToDao', () async {
        final items = [createTestFoodItem(name: 'Apple')];
        when(
          mockDao.search(testProfileId, 'apple'),
        ).thenAnswer((_) async => Success(items));

        final result = await repository.searchExcludingCategories(
          testProfileId,
          'apple',
          excludeCategories: ['dairy'],
        );

        expect(result.isSuccess, isTrue);
        verify(mockDao.search(testProfileId, 'apple')).called(1);
      });
    });
  });
}
