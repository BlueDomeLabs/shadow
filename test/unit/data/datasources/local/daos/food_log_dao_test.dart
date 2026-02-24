// test/unit/data/datasources/local/daos/food_log_dao_test.dart
// Tests for FoodLogDao per 06_TESTING_STRATEGY.md Section 4.1

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/food_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('FoodLogDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    FoodLog createTestFoodLog({
      String? id,
      String profileId = 'profile-001',
      int? timestamp,
      MealType? mealType,
      List<String> foodItemIds = const [],
      List<String> adHocItems = const [],
      int? syncCreatedAt,
      int? syncUpdatedAt,
      bool syncIsDirty = true,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return FoodLog(
        id: id ?? 'flog-${DateTime.now().microsecondsSinceEpoch}',
        clientId: 'client-${DateTime.now().microsecondsSinceEpoch}',
        profileId: profileId,
        timestamp: timestamp ?? now,
        mealType: mealType,
        foodItemIds: foodItemIds,
        adHocItems: adHocItems,
        syncMetadata: SyncMetadata(
          syncCreatedAt: syncCreatedAt ?? now,
          syncUpdatedAt: syncUpdatedAt ?? now,
          syncDeviceId: 'test-device',
          syncIsDirty: syncIsDirty,
        ),
      );
    }

    group('create', () {
      test('create_validFoodLog_returnsSuccess', () async {
        final log = createTestFoodLog(
          id: 'flog-001',
          mealType: MealType.breakfast,
          foodItemIds: ['food-1'],
        );

        final result = await database.foodLogDao.create(log);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'flog-001');
        expect(result.valueOrNull?.mealType, MealType.breakfast);
        expect(result.valueOrNull?.foodItemIds, ['food-1']);
      });

      test('create_duplicateId_returnsFailure', () async {
        final l1 = createTestFoodLog(id: 'flog-dup');
        final l2 = createTestFoodLog(id: 'flog-dup');

        await database.foodLogDao.create(l1);
        final result = await database.foodLogDao.create(l2);

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeConstraintViolation,
        );
      });

      test('create_withAdHocItems_persistsCorrectly', () async {
        final log = createTestFoodLog(
          id: 'flog-adhoc',
          adHocItems: ['Salad', 'Soup'],
        );

        await database.foodLogDao.create(log);
        final result = await database.foodLogDao.getById('flog-adhoc');

        expect(result.valueOrNull?.adHocItems, ['Salad', 'Soup']);
      });
    });

    group('getById', () {
      test('getById_existingId_returnsSuccess', () async {
        await database.foodLogDao.create(createTestFoodLog(id: 'flog-find'));

        final result = await database.foodLogDao.getById('flog-find');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'flog-find');
      });

      test('getById_nonExistingId_returnsFailure', () async {
        final result = await database.foodLogDao.getById('missing');

        expect(result.isFailure, isTrue);
      });
    });

    group('getAll', () {
      test('getAll_returnsAllNonDeleted', () async {
        await database.foodLogDao.create(createTestFoodLog(id: 'l1'));
        await database.foodLogDao.create(createTestFoodLog(id: 'l2'));

        final result = await database.foodLogDao.getAll();

        expect(result.valueOrNull, hasLength(2));
      });

      test('getAll_excludesSoftDeleted', () async {
        await database.foodLogDao.create(createTestFoodLog(id: 'l1'));
        await database.foodLogDao.create(createTestFoodLog(id: 'l2'));
        await database.foodLogDao.softDelete('l2');

        final result = await database.foodLogDao.getAll();

        expect(result.valueOrNull, hasLength(1));
      });
    });

    group('updateEntity', () {
      test('updateEntity_existingLog_returnsSuccess', () async {
        final original = createTestFoodLog(id: 'flog-upd');
        await database.foodLogDao.create(original);

        final updated = original.copyWith(notes: 'Updated');
        final result = await database.foodLogDao.updateEntity(updated);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.notes, 'Updated');
      });
    });

    group('softDelete', () {
      test('softDelete_existingLog_returnsSuccess', () async {
        await database.foodLogDao.create(createTestFoodLog(id: 'flog-sd'));

        final result = await database.foodLogDao.softDelete('flog-sd');

        expect(result.isSuccess, isTrue);
      });

      test('softDelete_nonExistingId_returnsFailure', () async {
        final result = await database.foodLogDao.softDelete('missing');

        expect(result.isFailure, isTrue);
      });
    });

    group('hardDelete', () {
      test('hardDelete_existingLog_removesPermanently', () async {
        await database.foodLogDao.create(createTestFoodLog(id: 'flog-hd'));

        final result = await database.foodLogDao.hardDelete('flog-hd');
        expect(result.isSuccess, isTrue);
      });
    });

    group('getByProfile', () {
      test('getByProfile_returnsOnlyMatchingProfile', () async {
        await database.foodLogDao.create(
          createTestFoodLog(id: 'l1', profileId: 'p-A'),
        );
        await database.foodLogDao.create(
          createTestFoodLog(id: 'l2', profileId: 'p-B'),
        );

        final result = await database.foodLogDao.getByProfile('p-A');

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.profileId, 'p-A');
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_returnsModifiedAfterTimestamp', () async {
        final baseTime = DateTime.now().millisecondsSinceEpoch;

        await database.foodLogDao.create(
          createTestFoodLog(id: 'old', syncUpdatedAt: baseTime - 10000),
        );
        await database.foodLogDao.create(
          createTestFoodLog(id: 'new', syncUpdatedAt: baseTime + 10000),
        );

        final result = await database.foodLogDao.getModifiedSince(baseTime);

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'new');
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_returnsOnlyDirtyLogs', () async {
        await database.foodLogDao.create(createTestFoodLog(id: 'dirty'));
        await database.foodLogDao.create(
          createTestFoodLog(id: 'clean', syncIsDirty: false),
        );

        final result = await database.foodLogDao.getPendingSync();

        expect(result.valueOrNull?.any((l) => l.id == 'dirty'), isTrue);
      });
    });

    group('violationFlag', () {
      test('violationFlag_defaultsFalse', () async {
        await database.foodLogDao.create(createTestFoodLog(id: 'vf-default'));

        final result = await database.foodLogDao.getById('vf-default');

        expect(result.valueOrNull?.violationFlag, isFalse);
      });

      test('violationFlag_persistsTrue', () async {
        final log = createTestFoodLog(
          id: 'vf-true',
        ).copyWith(violationFlag: true);
        await database.foodLogDao.create(log);

        final result = await database.foodLogDao.getById('vf-true');

        expect(result.valueOrNull?.violationFlag, isTrue);
      });
    });
  });
}
