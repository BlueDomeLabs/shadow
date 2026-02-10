// test/unit/data/datasources/local/daos/activity_log_dao_test.dart
// Tests for ActivityLogDao per 06_TESTING_STRATEGY.md Section 4.1

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/activity_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

void main() {
  group('ActivityLogDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    ActivityLog createTestActivityLog({
      String? id,
      String profileId = 'profile-001',
      int? timestamp,
      List<String> activityIds = const [],
      List<String> adHocActivities = const [],
      String? importSource,
      String? importExternalId,
      int? syncCreatedAt,
      int? syncUpdatedAt,
      bool syncIsDirty = true,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return ActivityLog(
        id: id ?? 'alog-${DateTime.now().microsecondsSinceEpoch}',
        clientId: 'client-${DateTime.now().microsecondsSinceEpoch}',
        profileId: profileId,
        timestamp: timestamp ?? now,
        activityIds: activityIds,
        adHocActivities: adHocActivities,
        importSource: importSource,
        importExternalId: importExternalId,
        syncMetadata: SyncMetadata(
          syncCreatedAt: syncCreatedAt ?? now,
          syncUpdatedAt: syncUpdatedAt ?? now,
          syncDeviceId: 'test-device',
          syncIsDirty: syncIsDirty,
        ),
      );
    }

    group('create', () {
      test('create_validActivityLog_returnsSuccess', () async {
        final log = createTestActivityLog(
          id: 'alog-001',
          activityIds: ['act-1', 'act-2'],
        );

        final result = await database.activityLogDao.create(log);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'alog-001');
        expect(result.valueOrNull?.activityIds, ['act-1', 'act-2']);
      });

      test('create_duplicateId_returnsFailure', () async {
        final l1 = createTestActivityLog(id: 'alog-dup');
        final l2 = createTestActivityLog(id: 'alog-dup');

        await database.activityLogDao.create(l1);
        final result = await database.activityLogDao.create(l2);

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeConstraintViolation,
        );
      });

      test('create_withAdHocActivities_persistsCorrectly', () async {
        final log = createTestActivityLog(
          id: 'alog-adhoc',
          adHocActivities: ['Gardening', 'Swimming'],
        );

        await database.activityLogDao.create(log);
        final result = await database.activityLogDao.getById('alog-adhoc');

        expect(result.valueOrNull?.adHocActivities, ['Gardening', 'Swimming']);
      });
    });

    group('getById', () {
      test('getById_existingId_returnsSuccess', () async {
        await database.activityLogDao.create(
          createTestActivityLog(id: 'alog-find'),
        );

        final result = await database.activityLogDao.getById('alog-find');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'alog-find');
      });

      test('getById_nonExistingId_returnsFailure', () async {
        final result = await database.activityLogDao.getById('missing');

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeNotFound,
        );
      });
    });

    group('getAll', () {
      test('getAll_returnsAllNonDeleted', () async {
        await database.activityLogDao.create(createTestActivityLog(id: 'l1'));
        await database.activityLogDao.create(createTestActivityLog(id: 'l2'));
        await database.activityLogDao.create(createTestActivityLog(id: 'l3'));

        final result = await database.activityLogDao.getAll();

        expect(result.valueOrNull, hasLength(3));
      });

      test('getAll_excludesSoftDeleted', () async {
        await database.activityLogDao.create(createTestActivityLog(id: 'l1'));
        await database.activityLogDao.create(createTestActivityLog(id: 'l2'));
        await database.activityLogDao.softDelete('l2');

        final result = await database.activityLogDao.getAll();

        expect(result.valueOrNull, hasLength(1));
      });
    });

    group('updateEntity', () {
      test('updateEntity_existingLog_returnsSuccess', () async {
        final original = createTestActivityLog(id: 'alog-upd');
        await database.activityLogDao.create(original);

        final updated = original.copyWith(notes: 'Updated notes');
        final result = await database.activityLogDao.updateEntity(updated);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.notes, 'Updated notes');
      });
    });

    group('softDelete', () {
      test('softDelete_existingLog_returnsSuccess', () async {
        await database.activityLogDao.create(
          createTestActivityLog(id: 'alog-sd'),
        );

        final result = await database.activityLogDao.softDelete('alog-sd');

        expect(result.isSuccess, isTrue);
      });

      test('softDelete_nonExistingId_returnsFailure', () async {
        final result = await database.activityLogDao.softDelete('missing');

        expect(result.isFailure, isTrue);
      });
    });

    group('hardDelete', () {
      test('hardDelete_existingLog_removesPermanently', () async {
        await database.activityLogDao.create(
          createTestActivityLog(id: 'alog-hd'),
        );

        final result = await database.activityLogDao.hardDelete('alog-hd');
        expect(result.isSuccess, isTrue);

        final allResult = await database.activityLogDao.getModifiedSince(0);
        expect(allResult.valueOrNull?.any((a) => a.id == 'alog-hd'), isFalse);
      });
    });

    group('getByProfile', () {
      test('getByProfile_returnsOnlyMatchingProfile', () async {
        await database.activityLogDao.create(
          createTestActivityLog(id: 'l1', profileId: 'p-A'),
        );
        await database.activityLogDao.create(
          createTestActivityLog(id: 'l2', profileId: 'p-B'),
        );

        final result = await database.activityLogDao.getByProfile('p-A');

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.profileId, 'p-A');
      });
    });

    group('getByExternalId', () {
      test('getByExternalId_findsImportedLog', () async {
        await database.activityLogDao.create(
          createTestActivityLog(
            id: 'alog-import',
            profileId: 'p-A',
            importSource: 'healthkit',
            importExternalId: 'hk-123',
          ),
        );

        final result = await database.activityLogDao.getByExternalId(
          'p-A',
          'healthkit',
          'hk-123',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'alog-import');
      });

      test('getByExternalId_returnsNullWhenNotFound', () async {
        final result = await database.activityLogDao.getByExternalId(
          'p-A',
          'healthkit',
          'missing',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_returnsOnlyModifiedAfterTimestamp', () async {
        final baseTime = DateTime.now().millisecondsSinceEpoch;

        await database.activityLogDao.create(
          createTestActivityLog(id: 'old', syncUpdatedAt: baseTime - 10000),
        );
        await database.activityLogDao.create(
          createTestActivityLog(id: 'new', syncUpdatedAt: baseTime + 10000),
        );

        final result = await database.activityLogDao.getModifiedSince(baseTime);

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'new');
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_returnsOnlyDirtyLogs', () async {
        await database.activityLogDao.create(
          createTestActivityLog(id: 'dirty'),
        );
        await database.activityLogDao.create(
          createTestActivityLog(id: 'clean', syncIsDirty: false),
        );

        final result = await database.activityLogDao.getPendingSync();

        expect(result.valueOrNull?.any((l) => l.id == 'dirty'), isTrue);
      });
    });
  });
}
