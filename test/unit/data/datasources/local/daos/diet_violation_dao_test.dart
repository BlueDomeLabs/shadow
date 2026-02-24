// test/unit/data/datasources/local/daos/diet_violation_dao_test.dart
// Phase 15b-1 — Tests for DietViolationDao
// Per 59_DIET_TRACKING.md

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/diet_violation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

void main() {
  group('DietViolationDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    DietViolation createTestViolation({
      String? id,
      String profileId = 'profile-001',
      String dietId = 'diet-001',
      String ruleId = 'rule-001',
      String? foodLogId,
      String foodName = 'Cheese',
      String ruleDescription = 'No dairy allowed',
      bool wasOverridden = true,
      int? timestamp,
      int? syncCreatedAt,
      bool syncIsDirty = true,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return DietViolation(
        id: id ?? 'viol-${DateTime.now().microsecondsSinceEpoch}',
        clientId: 'client-001',
        profileId: profileId,
        dietId: dietId,
        ruleId: ruleId,
        foodLogId: foodLogId,
        foodName: foodName,
        ruleDescription: ruleDescription,
        wasOverridden: wasOverridden,
        timestamp: timestamp ?? now,
        syncMetadata: SyncMetadata(
          syncCreatedAt: syncCreatedAt ?? now,
          syncUpdatedAt: syncCreatedAt ?? now,
          syncDeviceId: 'test-device',
          syncIsDirty: syncIsDirty,
        ),
      );
    }

    group('create', () {
      test('create_validViolation_returnsSuccess', () async {
        final violation = createTestViolation(id: 'viol-001');

        final result = await database.dietViolationDao.create(violation);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'viol-001');
        expect(result.valueOrNull?.foodName, 'Cheese');
        expect(result.valueOrNull?.wasOverridden, isTrue);
      });

      test('create_duplicateId_returnsFailure', () async {
        final v1 = createTestViolation(id: 'viol-dup');
        final v2 = createTestViolation(id: 'viol-dup');

        await database.dietViolationDao.create(v1);
        final result = await database.dietViolationDao.create(v2);

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeConstraintViolation,
        );
      });

      test('create_cancelledViolation_storesNullFoodLogId', () async {
        final violation = createTestViolation(
          id: 'viol-cancel',
          wasOverridden: false,
        );

        final result = await database.dietViolationDao.create(violation);

        expect(result.valueOrNull?.foodLogId, isNull);
        expect(result.valueOrNull?.wasOverridden, isFalse);
      });

      test('create_overriddenViolation_storesFoodLogId', () async {
        final violation = createTestViolation(
          id: 'viol-over',
          foodLogId: 'food-log-123',
        );

        final result = await database.dietViolationDao.create(violation);

        expect(result.valueOrNull?.foodLogId, 'food-log-123');
      });
    });

    group('getById', () {
      test('getById_existingViolation_returnsSuccess', () async {
        final violation = createTestViolation(id: 'viol-get');
        await database.dietViolationDao.create(violation);

        final result = await database.dietViolationDao.getById('viol-get');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'viol-get');
      });

      test('getById_notFound_returnsFailure', () async {
        final result = await database.dietViolationDao.getById('nonexistent');

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeNotFound,
        );
      });
    });

    group('getByProfile', () {
      test('getByProfile_returnsViolationsForProfile', () async {
        final v1 = createTestViolation(id: 'viol-p1a');
        final v2 = createTestViolation(id: 'viol-p1b');
        final v3 = createTestViolation(id: 'viol-p2', profileId: 'profile-002');

        await database.dietViolationDao.create(v1);
        await database.dietViolationDao.create(v2);
        await database.dietViolationDao.create(v3);

        final result = await database.dietViolationDao.getByProfile(
          'profile-001',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.length, 2);
      });

      test('getByProfile_withDateFilter_returnsFilteredViolations', () async {
        final past = DateTime.now().millisecondsSinceEpoch - 100000;
        final recent = DateTime.now().millisecondsSinceEpoch;
        final v1 = createTestViolation(id: 'viol-past', timestamp: past);
        final v2 = createTestViolation(id: 'viol-recent', timestamp: recent);

        await database.dietViolationDao.create(v1);
        await database.dietViolationDao.create(v2);

        final result = await database.dietViolationDao.getByProfile(
          'profile-001',
          startDate: past + 50000,
        );

        expect(result.valueOrNull?.any((v) => v.id == 'viol-recent'), isTrue);
        expect(result.valueOrNull?.any((v) => v.id == 'viol-past'), isFalse);
      });
    });

    group('getByDiet', () {
      test('getByDiet_returnsViolationsForDiet', () async {
        final v1 = createTestViolation(id: 'viol-d1');
        final v2 = createTestViolation(id: 'viol-d2', dietId: 'diet-002');
        await database.dietViolationDao.create(v1);
        await database.dietViolationDao.create(v2);

        final result = await database.dietViolationDao.getByDiet('diet-001');

        expect(result.valueOrNull?.length, 1);
        expect(result.valueOrNull?.first.id, 'viol-d1');
      });
    });

    group('softDelete', () {
      test('softDelete_existingViolation_hidesFromQueries', () async {
        final violation = createTestViolation(id: 'viol-del');
        await database.dietViolationDao.create(violation);

        await database.dietViolationDao.softDelete('viol-del');

        final result = await database.dietViolationDao.getById('viol-del');
        expect(result.isFailure, isTrue);
      });

      test('softDelete_notFound_returnsFailure', () async {
        final result = await database.dietViolationDao.softDelete(
          'nonexistent',
        );

        expect(result.isFailure, isTrue);
      });
    });

    group('hardDelete', () {
      test('hardDelete_existingViolation_returnsSuccess', () async {
        final violation = createTestViolation(id: 'viol-hard');
        await database.dietViolationDao.create(violation);

        final result = await database.dietViolationDao.hardDelete('viol-hard');

        expect(result.isSuccess, isTrue);
      });

      test('hardDelete_notFound_returnsFailure', () async {
        final result = await database.dietViolationDao.hardDelete(
          'nonexistent',
        );

        expect(result.isFailure, isTrue);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_returnsModifiedAfterTimestamp', () async {
        final past = DateTime.now().millisecondsSinceEpoch - 10000;
        final old = createTestViolation(id: 'viol-old', syncCreatedAt: past);
        final fresh = createTestViolation(
          id: 'viol-fresh',
          syncCreatedAt: DateTime.now().millisecondsSinceEpoch,
        );
        await database.dietViolationDao.create(old);
        await database.dietViolationDao.create(fresh);

        final result = await database.dietViolationDao.getModifiedSince(
          past + 5000,
        );

        expect(result.valueOrNull?.any((v) => v.id == 'viol-fresh'), isTrue);
        expect(result.valueOrNull?.any((v) => v.id == 'viol-old'), isFalse);
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_returnsOnlyDirtyViolations', () async {
        final dirty = createTestViolation(id: 'viol-dirty');
        final clean = createTestViolation(id: 'viol-clean', syncIsDirty: false);
        await database.dietViolationDao.create(dirty);
        await database.dietViolationDao.create(clean);

        final result = await database.dietViolationDao.getPendingSync();

        expect(result.valueOrNull?.any((v) => v.id == 'viol-dirty'), isTrue);
        expect(result.valueOrNull?.any((v) => v.id == 'viol-clean'), isFalse);
      });
    });
  });
}
