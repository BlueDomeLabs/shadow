// test/unit/data/datasources/local/daos/flare_up_dao_test.dart
// Tests for FlareUpDao per 06_TESTING_STRATEGY.md Section 4.1

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

void main() {
  group('FlareUpDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    FlareUp createTestFlareUp({
      String? id,
      String profileId = 'profile-001',
      String conditionId = 'cond-001',
      int? startDate,
      int? endDate,
      int severity = 5,
      List<String> triggers = const [],
      int? syncCreatedAt,
      int? syncUpdatedAt,
      bool syncIsDirty = true,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return FlareUp(
        id: id ?? 'flare-${DateTime.now().microsecondsSinceEpoch}',
        clientId: 'client-${DateTime.now().microsecondsSinceEpoch}',
        profileId: profileId,
        conditionId: conditionId,
        startDate: startDate ?? now,
        endDate: endDate,
        severity: severity,
        triggers: triggers,
        syncMetadata: SyncMetadata(
          syncCreatedAt: syncCreatedAt ?? now,
          syncUpdatedAt: syncUpdatedAt ?? now,
          syncDeviceId: 'test-device',
          syncIsDirty: syncIsDirty,
        ),
      );
    }

    group('create', () {
      test('create_validFlareUp_returnsSuccess', () async {
        final flareUp = createTestFlareUp(
          id: 'flare-001',
          triggers: ['stress', 'food'],
        );

        final result = await database.flareUpDao.create(flareUp);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'flare-001');
        expect(result.valueOrNull?.triggers, ['stress', 'food']);
      });

      test('create_duplicateId_returnsFailure', () async {
        final f1 = createTestFlareUp(id: 'flare-dup');
        final f2 = createTestFlareUp(id: 'flare-dup');

        await database.flareUpDao.create(f1);
        final result = await database.flareUpDao.create(f2);

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeConstraintViolation,
        );
      });
    });

    group('getById', () {
      test('getById_existingId_returnsSuccess', () async {
        await database.flareUpDao.create(createTestFlareUp(id: 'flare-find'));

        final result = await database.flareUpDao.getById('flare-find');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'flare-find');
      });

      test('getById_nonExistingId_returnsFailure', () async {
        final result = await database.flareUpDao.getById('missing');

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeNotFound,
        );
      });
    });

    group('getAll', () {
      test('getAll_returnsAllNonDeleted', () async {
        await database.flareUpDao.create(createTestFlareUp(id: 'f1'));
        await database.flareUpDao.create(createTestFlareUp(id: 'f2'));

        final result = await database.flareUpDao.getAll();

        expect(result.valueOrNull, hasLength(2));
      });

      test('getAll_excludesSoftDeleted', () async {
        await database.flareUpDao.create(createTestFlareUp(id: 'f1'));
        await database.flareUpDao.create(createTestFlareUp(id: 'f2'));
        await database.flareUpDao.softDelete('f2');

        final result = await database.flareUpDao.getAll();

        expect(result.valueOrNull, hasLength(1));
      });
    });

    group('updateEntity', () {
      test('updateEntity_existingFlareUp_returnsSuccess', () async {
        final original = createTestFlareUp(id: 'flare-upd');
        await database.flareUpDao.create(original);

        final updated = original.copyWith(severity: 8);
        final result = await database.flareUpDao.updateEntity(updated);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.severity, 8);
      });
    });

    group('softDelete', () {
      test('softDelete_existingFlareUp_returnsSuccess', () async {
        await database.flareUpDao.create(createTestFlareUp(id: 'flare-sd'));

        final result = await database.flareUpDao.softDelete('flare-sd');

        expect(result.isSuccess, isTrue);
      });

      test('softDelete_nonExistingId_returnsFailure', () async {
        final result = await database.flareUpDao.softDelete('missing');

        expect(result.isFailure, isTrue);
      });

      test('softDelete_setsSyncStatusToDeleted', () async {
        await database.flareUpDao.create(createTestFlareUp(id: 'flare-status'));
        await database.flareUpDao.softDelete('flare-status');

        final result = await database.flareUpDao.getModifiedSince(0);
        final deleted = result.valueOrNull?.firstWhere(
          (f) => f.id == 'flare-status',
        );

        expect(deleted?.syncMetadata.syncStatus, SyncStatus.deleted);
      });
    });

    group('hardDelete', () {
      test('hardDelete_existingFlareUp_removesPermanently', () async {
        await database.flareUpDao.create(createTestFlareUp(id: 'flare-hd'));

        final result = await database.flareUpDao.hardDelete('flare-hd');
        expect(result.isSuccess, isTrue);
      });
    });

    group('getByCondition', () {
      test('getByCondition_returnsOnlyMatchingCondition', () async {
        await database.flareUpDao.create(
          createTestFlareUp(id: 'f1', conditionId: 'c-A'),
        );
        await database.flareUpDao.create(
          createTestFlareUp(id: 'f2', conditionId: 'c-B'),
        );

        final result = await database.flareUpDao.getByCondition('c-A');

        expect(result.valueOrNull, hasLength(1));
      });

      test('getByCondition_ongoingOnly_filtersCorrectly', () async {
        await database.flareUpDao.create(
          createTestFlareUp(id: 'f1', conditionId: 'c-A'), // ongoing
        );
        await database.flareUpDao.create(
          createTestFlareUp(
            id: 'f2',
            conditionId: 'c-A',
            endDate: DateTime.now().millisecondsSinceEpoch,
          ), // ended
        );

        final result = await database.flareUpDao.getByCondition(
          'c-A',
          ongoingOnly: true,
        );

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'f1');
      });
    });

    group('getOngoing', () {
      test('getOngoing_returnsOnlyFlareUpsWithoutEndDate', () async {
        await database.flareUpDao.create(
          createTestFlareUp(id: 'f1', profileId: 'p-A'),
        );
        await database.flareUpDao.create(
          createTestFlareUp(
            id: 'f2',
            profileId: 'p-A',
            endDate: DateTime.now().millisecondsSinceEpoch,
          ),
        );

        final result = await database.flareUpDao.getOngoing('p-A');

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'f1');
      });
    });

    group('endFlareUp', () {
      test('endFlareUp_setsEndDateCorrectly', () async {
        await database.flareUpDao.create(createTestFlareUp(id: 'flare-end'));

        final endTime = DateTime.now().millisecondsSinceEpoch;
        final result = await database.flareUpDao.endFlareUp(
          'flare-end',
          endTime,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.endDate, endTime);
      });
    });

    group('getTriggerCounts', () {
      test('getTriggerCounts_countsTriggersCorrectly', () async {
        const baseTime = 1704067200000;
        await database.flareUpDao.create(
          createTestFlareUp(
            id: 'f1',
            conditionId: 'c-A',
            startDate: baseTime,
            triggers: ['stress', 'food'],
          ),
        );
        await database.flareUpDao.create(
          createTestFlareUp(
            id: 'f2',
            conditionId: 'c-A',
            startDate: baseTime + 1000,
            triggers: ['stress', 'weather'],
          ),
        );

        final result = await database.flareUpDao.getTriggerCounts(
          'c-A',
          startDate: baseTime - 1000,
          endDate: baseTime + 100000,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?['stress'], 2);
        expect(result.valueOrNull?['food'], 1);
        expect(result.valueOrNull?['weather'], 1);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_returnsModifiedAfterTimestamp', () async {
        final baseTime = DateTime.now().millisecondsSinceEpoch;

        await database.flareUpDao.create(
          createTestFlareUp(id: 'old', syncUpdatedAt: baseTime - 10000),
        );
        await database.flareUpDao.create(
          createTestFlareUp(id: 'new', syncUpdatedAt: baseTime + 10000),
        );

        final result = await database.flareUpDao.getModifiedSince(baseTime);

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'new');
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_returnsOnlyDirtyFlareUps', () async {
        await database.flareUpDao.create(createTestFlareUp(id: 'dirty'));
        await database.flareUpDao.create(
          createTestFlareUp(id: 'clean', syncIsDirty: false),
        );

        final result = await database.flareUpDao.getPendingSync();

        expect(result.valueOrNull?.any((f) => f.id == 'dirty'), isTrue);
      });
    });
  });
}
