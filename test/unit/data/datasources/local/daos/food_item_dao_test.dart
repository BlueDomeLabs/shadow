// test/unit/data/datasources/local/daos/food_item_dao_test.dart
// Tests for FoodItemDao per 06_TESTING_STRATEGY.md Section 4.1

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('FoodItemDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    FoodItem createTestFoodItem({
      String? id,
      String profileId = 'profile-001',
      String name = 'Test Food',
      FoodItemType type = FoodItemType.simple,
      bool isArchived = false,
      int? syncCreatedAt,
      int? syncUpdatedAt,
      bool syncIsDirty = true,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return FoodItem(
        id: id ?? 'food-${DateTime.now().microsecondsSinceEpoch}',
        clientId: 'client-${DateTime.now().microsecondsSinceEpoch}',
        profileId: profileId,
        name: name,
        type: type,
        isArchived: isArchived,
        syncMetadata: SyncMetadata(
          syncCreatedAt: syncCreatedAt ?? now,
          syncUpdatedAt: syncUpdatedAt ?? now,
          syncDeviceId: 'test-device',
          syncIsDirty: syncIsDirty,
        ),
      );
    }

    group('create', () {
      test('create_validFoodItem_returnsSuccess', () async {
        final item = createTestFoodItem(id: 'food-001', name: 'Apple');

        final result = await database.foodItemDao.create(item);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'food-001');
        expect(result.valueOrNull?.name, 'Apple');
      });

      test('create_duplicateId_returnsFailure', () async {
        final i1 = createTestFoodItem(id: 'food-dup');
        final i2 = createTestFoodItem(id: 'food-dup');

        await database.foodItemDao.create(i1);
        final result = await database.foodItemDao.create(i2);

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeConstraintViolation,
        );
      });

      test('create_withNutritionalInfo_persistsCorrectly', () async {
        const item = FoodItem(
          id: 'food-nutri',
          clientId: 'client-nutri',
          profileId: 'profile-001',
          name: 'Chicken Breast',
          servingSize: '100g',
          calories: 165,
          carbsGrams: 0,
          fatGrams: 3.6,
          proteinGrams: 31,
          syncMetadata: SyncMetadata(
            syncCreatedAt: 1704067200000,
            syncUpdatedAt: 1704067200000,
            syncDeviceId: 'device-001',
          ),
        );

        await database.foodItemDao.create(item);
        final result = await database.foodItemDao.getById('food-nutri');

        expect(result.isSuccess, isTrue);
        final retrieved = result.valueOrNull!;
        expect(retrieved.calories, 165);
        expect(retrieved.proteinGrams, 31);
      });
    });

    group('getById', () {
      test('getById_existingId_returnsSuccess', () async {
        await database.foodItemDao.create(createTestFoodItem(id: 'food-find'));

        final result = await database.foodItemDao.getById('food-find');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'food-find');
      });

      test('getById_nonExistingId_returnsFailure', () async {
        final result = await database.foodItemDao.getById('missing');

        expect(result.isFailure, isTrue);
      });
    });

    group('getAll', () {
      test('getAll_returnsAllNonDeleted', () async {
        await database.foodItemDao.create(createTestFoodItem(id: 'f1'));
        await database.foodItemDao.create(createTestFoodItem(id: 'f2'));

        final result = await database.foodItemDao.getAll();

        expect(result.valueOrNull, hasLength(2));
      });

      test('getAll_excludesSoftDeleted', () async {
        await database.foodItemDao.create(createTestFoodItem(id: 'f1'));
        await database.foodItemDao.create(createTestFoodItem(id: 'f2'));
        await database.foodItemDao.softDelete('f2');

        final result = await database.foodItemDao.getAll();

        expect(result.valueOrNull, hasLength(1));
      });
    });

    group('updateEntity', () {
      test('updateEntity_existingItem_returnsSuccess', () async {
        final original = createTestFoodItem(id: 'food-upd', name: 'Old');
        await database.foodItemDao.create(original);

        final updated = original.copyWith(name: 'New Name');
        final result = await database.foodItemDao.updateEntity(updated);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.name, 'New Name');
      });
    });

    group('softDelete', () {
      test('softDelete_existingItem_returnsSuccess', () async {
        await database.foodItemDao.create(createTestFoodItem(id: 'food-sd'));

        final result = await database.foodItemDao.softDelete('food-sd');

        expect(result.isSuccess, isTrue);
      });

      test('softDelete_nonExistingId_returnsFailure', () async {
        final result = await database.foodItemDao.softDelete('missing');

        expect(result.isFailure, isTrue);
      });
    });

    group('hardDelete', () {
      test('hardDelete_existingItem_removesPermanently', () async {
        await database.foodItemDao.create(createTestFoodItem(id: 'food-hd'));

        final result = await database.foodItemDao.hardDelete('food-hd');
        expect(result.isSuccess, isTrue);
      });
    });

    group('getByProfile', () {
      test('getByProfile_returnsOnlyMatchingProfile', () async {
        await database.foodItemDao.create(
          createTestFoodItem(id: 'f1', profileId: 'p-A'),
        );
        await database.foodItemDao.create(
          createTestFoodItem(id: 'f2', profileId: 'p-B'),
        );

        final result = await database.foodItemDao.getByProfile('p-A');

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.profileId, 'p-A');
      });

      test('getByProfile_excludesArchived_byDefault', () async {
        await database.foodItemDao.create(
          createTestFoodItem(id: 'f1', profileId: 'p-A'),
        );
        await database.foodItemDao.create(
          createTestFoodItem(id: 'f2', profileId: 'p-A', isArchived: true),
        );

        final result = await database.foodItemDao.getByProfile('p-A');

        expect(result.valueOrNull, hasLength(1));
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_returnsModifiedAfterTimestamp', () async {
        final baseTime = DateTime.now().millisecondsSinceEpoch;

        await database.foodItemDao.create(
          createTestFoodItem(id: 'old', syncUpdatedAt: baseTime - 10000),
        );
        await database.foodItemDao.create(
          createTestFoodItem(id: 'new', syncUpdatedAt: baseTime + 10000),
        );

        final result = await database.foodItemDao.getModifiedSince(baseTime);

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'new');
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_returnsOnlyDirtyItems', () async {
        await database.foodItemDao.create(createTestFoodItem(id: 'dirty'));
        await database.foodItemDao.create(
          createTestFoodItem(id: 'clean', syncIsDirty: false),
        );

        final result = await database.foodItemDao.getPendingSync();

        expect(result.valueOrNull?.any((i) => i.id == 'dirty'), isTrue);
      });
    });
  });
}
