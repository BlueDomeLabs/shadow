// test/unit/data/datasources/local/daos/diet_dao_test.dart
// Phase 15b-1 — Tests for DietDao
// Per 59_DIET_TRACKING.md

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/diet.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('DietDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    Diet createTestDiet({
      String? id,
      String profileId = 'profile-001',
      String name = 'Test Diet',
      DietPresetType? presetType,
      bool isActive = false,
      bool isDraft = false,
      int? syncCreatedAt,
      bool syncIsDirty = true,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return Diet(
        id: id ?? 'diet-${DateTime.now().microsecondsSinceEpoch}',
        clientId: 'client-001',
        profileId: profileId,
        name: name,
        presetType: presetType,
        isActive: isActive,
        isDraft: isDraft,
        startDate: now,
        syncMetadata: SyncMetadata(
          syncCreatedAt: syncCreatedAt ?? now,
          syncUpdatedAt: syncCreatedAt ?? now,
          syncDeviceId: 'test-device',
          syncIsDirty: syncIsDirty,
        ),
      );
    }

    group('create', () {
      test('create_validDiet_returnsSuccess', () async {
        final diet = createTestDiet(id: 'diet-001', name: 'Keto');

        final result = await database.dietDao.create(diet);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'diet-001');
        expect(result.valueOrNull?.name, 'Keto');
      });

      test('create_duplicateId_returnsFailure', () async {
        final d1 = createTestDiet(id: 'diet-dup');
        final d2 = createTestDiet(id: 'diet-dup');

        await database.dietDao.create(d1);
        final result = await database.dietDao.create(d2);

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeConstraintViolation,
        );
      });

      test('create_presetDiet_storesPresetType', () async {
        final diet = createTestDiet(
          id: 'diet-keto',
          presetType: DietPresetType.keto,
        );

        final result = await database.dietDao.create(diet);

        expect(result.valueOrNull?.presetType, DietPresetType.keto);
      });

      test('create_customDiet_storesNullPresetType', () async {
        final diet = createTestDiet(id: 'diet-custom');

        final result = await database.dietDao.create(diet);

        expect(result.valueOrNull?.presetType, isNull);
      });
    });

    group('getById', () {
      test('getById_existingDiet_returnsSuccess', () async {
        final diet = createTestDiet(id: 'diet-get');
        await database.dietDao.create(diet);

        final result = await database.dietDao.getById('diet-get');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'diet-get');
      });

      test('getById_notFound_returnsFailure', () async {
        final result = await database.dietDao.getById('nonexistent');

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeNotFound,
        );
      });
    });

    group('getByProfile', () {
      test('getByProfile_returnsDietsForProfile', () async {
        final d1 = createTestDiet(id: 'diet-p1a');
        final d2 = createTestDiet(id: 'diet-p1b');
        final d3 = createTestDiet(id: 'diet-p2', profileId: 'profile-002');

        await database.dietDao.create(d1);
        await database.dietDao.create(d2);
        await database.dietDao.create(d3);

        final result = await database.dietDao.getByProfile('profile-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.length, 2);
        expect(
          result.valueOrNull?.every((d) => d.profileId == 'profile-001'),
          isTrue,
        );
      });

      test('getByProfile_emptyProfile_returnsEmptyList', () async {
        final result = await database.dietDao.getByProfile('empty-profile');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });
    });

    group('getActiveDiet', () {
      test('getActiveDiet_activeDietExists_returnsIt', () async {
        final inactive = createTestDiet(id: 'diet-inactive');
        final active = createTestDiet(id: 'diet-active', isActive: true);

        await database.dietDao.create(inactive);
        await database.dietDao.create(active);

        final result = await database.dietDao.getActiveDiet('profile-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'diet-active');
      });

      test('getActiveDiet_noActiveDiet_returnsNull', () async {
        final diet = createTestDiet(id: 'diet-notactive');
        await database.dietDao.create(diet);

        final result = await database.dietDao.getActiveDiet('profile-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });
    });

    group('updateEntity', () {
      test('updateEntity_existingDiet_updatesFields', () async {
        final diet = createTestDiet(id: 'diet-upd', name: 'Old Name');
        await database.dietDao.create(diet);

        final updated = diet.copyWith(name: 'New Name', isActive: true);
        final result = await database.dietDao.updateEntity(updated);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.name, 'New Name');
        expect(result.valueOrNull?.isActive, isTrue);
      });

      test('updateEntity_notFound_returnsFailure', () async {
        final diet = createTestDiet(id: 'nonexistent');

        final result = await database.dietDao.updateEntity(diet);

        expect(result.isFailure, isTrue);
      });
    });

    group('deactivateAll', () {
      test('deactivateAll_setsAllDietsInactive', () async {
        final d1 = createTestDiet(id: 'diet-da1', isActive: true);
        final d2 = createTestDiet(id: 'diet-da2', isActive: true);
        await database.dietDao.create(d1);
        await database.dietDao.create(d2);

        await database.dietDao.deactivateAll('profile-001');

        final result = await database.dietDao.getByProfile('profile-001');
        expect(result.valueOrNull?.every((d) => !d.isActive), isTrue);
      });
    });

    group('softDelete', () {
      test('softDelete_existingDiet_hidesFromQueries', () async {
        final diet = createTestDiet(id: 'diet-del');
        await database.dietDao.create(diet);

        final deleteResult = await database.dietDao.softDelete('diet-del');
        expect(deleteResult.isSuccess, isTrue);

        final getResult = await database.dietDao.getById('diet-del');
        expect(getResult.isFailure, isTrue);
      });

      test('softDelete_notFound_returnsFailure', () async {
        final result = await database.dietDao.softDelete('nonexistent');

        expect(result.isFailure, isTrue);
      });
    });

    group('hardDelete', () {
      test('hardDelete_existingDiet_returnsSuccess', () async {
        final diet = createTestDiet(id: 'diet-hard');
        await database.dietDao.create(diet);

        final result = await database.dietDao.hardDelete('diet-hard');

        expect(result.isSuccess, isTrue);
      });

      test('hardDelete_notFound_returnsFailure', () async {
        final result = await database.dietDao.hardDelete('nonexistent');

        expect(result.isFailure, isTrue);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_returnsModifiedAfterTimestamp', () async {
        final past = DateTime.now().millisecondsSinceEpoch - 10000;
        final d1 = createTestDiet(id: 'diet-m1', syncCreatedAt: past);
        final d2 = createTestDiet(
          id: 'diet-m2',
          syncCreatedAt: DateTime.now().millisecondsSinceEpoch,
        );
        await database.dietDao.create(d1);
        await database.dietDao.create(d2);

        final result = await database.dietDao.getModifiedSince(past + 5000);

        expect(result.valueOrNull?.any((d) => d.id == 'diet-m2'), isTrue);
        expect(result.valueOrNull?.any((d) => d.id == 'diet-m1'), isFalse);
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_returnsOnlyDirtyDiets', () async {
        final dirty = createTestDiet(id: 'diet-dirty');
        final clean = createTestDiet(id: 'diet-clean', syncIsDirty: false);
        await database.dietDao.create(dirty);
        await database.dietDao.create(clean);

        final result = await database.dietDao.getPendingSync();

        expect(result.valueOrNull?.any((d) => d.id == 'diet-dirty'), isTrue);
        expect(result.valueOrNull?.any((d) => d.id == 'diet-clean'), isFalse);
      });
    });
  });
}
