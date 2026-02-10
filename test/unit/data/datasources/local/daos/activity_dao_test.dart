// test/unit/data/datasources/local/daos/activity_dao_test.dart
// Tests for ActivityDao per 06_TESTING_STRATEGY.md Section 4.1

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

void main() {
  group('ActivityDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    Activity createTestActivity({
      String? id,
      String profileId = 'profile-001',
      String name = 'Test Activity',
      int durationMinutes = 30,
      bool isArchived = false,
      int? syncCreatedAt,
      int? syncUpdatedAt,
      bool syncIsDirty = true,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return Activity(
        id: id ?? 'act-${DateTime.now().microsecondsSinceEpoch}',
        clientId: 'client-${DateTime.now().microsecondsSinceEpoch}',
        profileId: profileId,
        name: name,
        durationMinutes: durationMinutes,
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
      test('create_validActivity_returnsSuccessWithCreatedEntity', () async {
        final activity = createTestActivity(id: 'act-001', name: 'Walking');

        final result = await database.activityDao.create(activity);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'act-001');
        expect(result.valueOrNull?.name, 'Walking');
      });

      test(
        'create_duplicateId_returnsFailureWithConstraintViolation',
        () async {
          final a1 = createTestActivity(id: 'act-dup');
          final a2 = createTestActivity(id: 'act-dup');

          await database.activityDao.create(a1);
          final result = await database.activityDao.create(a2);

          expect(result.isFailure, isTrue);
          expect(result.errorOrNull, isA<DatabaseError>());
          expect(
            (result.errorOrNull! as DatabaseError).code,
            DatabaseError.codeConstraintViolation,
          );
        },
      );

      test('create_withAllFields_persistsAllFieldsCorrectly', () async {
        const activity = Activity(
          id: 'act-full',
          clientId: 'client-full',
          profileId: 'profile-001',
          name: 'Morning Walk',
          description: 'A brisk walk',
          location: 'Park',
          triggers: 'daylight',
          durationMinutes: 45,
          syncMetadata: SyncMetadata(
            syncCreatedAt: 1704067200000,
            syncUpdatedAt: 1704067200000,
            syncDeviceId: 'device-001',
          ),
        );

        await database.activityDao.create(activity);
        final result = await database.activityDao.getById('act-full');

        expect(result.isSuccess, isTrue);
        final retrieved = result.valueOrNull!;
        expect(retrieved.name, 'Morning Walk');
        expect(retrieved.description, 'A brisk walk');
        expect(retrieved.location, 'Park');
        expect(retrieved.triggers, 'daylight');
        expect(retrieved.durationMinutes, 45);
        expect(retrieved.isArchived, isFalse);
      });
    });

    group('getById', () {
      test('getById_existingId_returnsSuccess', () async {
        await database.activityDao.create(createTestActivity(id: 'act-find'));

        final result = await database.activityDao.getById('act-find');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'act-find');
      });

      test('getById_nonExistingId_returnsFailureWithNotFound', () async {
        final result = await database.activityDao.getById('act-missing');

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<DatabaseError>());
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeNotFound,
        );
      });

      test('getById_softDeletedActivity_returnsFailureWithNotFound', () async {
        await database.activityDao.create(
          createTestActivity(id: 'act-deleted'),
        );
        await database.activityDao.softDelete('act-deleted');

        final result = await database.activityDao.getById('act-deleted');

        expect(result.isFailure, isTrue);
      });
    });

    group('getAll', () {
      test('getAll_noActivities_returnsEmptyList', () async {
        final result = await database.activityDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });

      test('getAll_multipleActivities_returnsAllNonDeleted', () async {
        await database.activityDao.create(createTestActivity(id: 'act-1'));
        await database.activityDao.create(createTestActivity(id: 'act-2'));
        await database.activityDao.create(createTestActivity(id: 'act-3'));

        final result = await database.activityDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(3));
      });

      test('getAll_excludesSoftDeletedActivities', () async {
        await database.activityDao.create(createTestActivity(id: 'act-1'));
        await database.activityDao.create(createTestActivity(id: 'act-2'));
        await database.activityDao.softDelete('act-2');

        final result = await database.activityDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
      });

      test('getAll_ordersAlphabeticallyByName', () async {
        await database.activityDao.create(
          createTestActivity(id: 'a3', name: 'Yoga'),
        );
        await database.activityDao.create(
          createTestActivity(id: 'a1', name: 'Cycling'),
        );
        await database.activityDao.create(
          createTestActivity(id: 'a2', name: 'Running'),
        );

        final result = await database.activityDao.getAll();

        expect(result.valueOrNull?[0].name, 'Cycling');
        expect(result.valueOrNull?[1].name, 'Running');
        expect(result.valueOrNull?[2].name, 'Yoga');
      });

      test('getAll_withProfileIdFilter_returnsOnlyMatchingProfile', () async {
        await database.activityDao.create(
          createTestActivity(id: 'a1', profileId: 'profile-A'),
        );
        await database.activityDao.create(
          createTestActivity(id: 'a2', profileId: 'profile-B'),
        );

        final result = await database.activityDao.getAll(
          profileId: 'profile-A',
        );

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.profileId, 'profile-A');
      });

      test('getAll_withLimit_returnsLimitedResults', () async {
        for (var i = 0; i < 10; i++) {
          await database.activityDao.create(createTestActivity(id: 'act-$i'));
        }

        final result = await database.activityDao.getAll(limit: 5);

        expect(result.valueOrNull, hasLength(5));
      });
    });

    group('updateEntity', () {
      test('updateEntity_existingActivity_returnsSuccess', () async {
        final original = createTestActivity(id: 'act-upd', name: 'Old');
        await database.activityDao.create(original);

        final updated = original.copyWith(name: 'New Name');
        final result = await database.activityDao.updateEntity(updated);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.name, 'New Name');
      });

      test('updateEntity_nonExistingActivity_returnsFailure', () async {
        final activity = createTestActivity(id: 'act-missing');

        final result = await database.activityDao.updateEntity(activity);

        expect(result.isFailure, isTrue);
      });
    });

    group('softDelete', () {
      test('softDelete_existingActivity_returnsSuccess', () async {
        await database.activityDao.create(createTestActivity(id: 'act-sd'));

        final result = await database.activityDao.softDelete('act-sd');

        expect(result.isSuccess, isTrue);
      });

      test('softDelete_nonExistingId_returnsFailure', () async {
        final result = await database.activityDao.softDelete('act-missing');

        expect(result.isFailure, isTrue);
      });

      test('softDelete_setsSyncStatusToDeleted', () async {
        await database.activityDao.create(createTestActivity(id: 'act-status'));
        await database.activityDao.softDelete('act-status');

        final result = await database.activityDao.getModifiedSince(0);
        final deleted = result.valueOrNull?.firstWhere(
          (a) => a.id == 'act-status',
        );

        expect(deleted?.syncMetadata.syncStatus, SyncStatus.deleted);
        expect(deleted?.syncMetadata.syncDeletedAt, isNotNull);
      });
    });

    group('hardDelete', () {
      test('hardDelete_existingActivity_removesPermanently', () async {
        await database.activityDao.create(createTestActivity(id: 'act-hd'));

        final result = await database.activityDao.hardDelete('act-hd');
        expect(result.isSuccess, isTrue);

        final allResult = await database.activityDao.getModifiedSince(0);
        expect(allResult.valueOrNull?.any((a) => a.id == 'act-hd'), isFalse);
      });

      test('hardDelete_nonExistingId_returnsFailure', () async {
        final result = await database.activityDao.hardDelete('act-missing');
        expect(result.isFailure, isTrue);
      });
    });

    group('getByProfile', () {
      test('getByProfile_returnsOnlyMatchingProfile', () async {
        await database.activityDao.create(
          createTestActivity(id: 'a1', profileId: 'p-A'),
        );
        await database.activityDao.create(
          createTestActivity(id: 'a2', profileId: 'p-B'),
        );

        final result = await database.activityDao.getByProfile('p-A');

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.profileId, 'p-A');
      });

      test('getByProfile_excludesArchived_byDefault', () async {
        await database.activityDao.create(
          createTestActivity(id: 'a1', profileId: 'p-A'),
        );
        await database.activityDao.create(
          createTestActivity(id: 'a2', profileId: 'p-A', isArchived: true),
        );

        final result = await database.activityDao.getByProfile('p-A');

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'a1');
      });

      test('getByProfile_includeArchived_returnsAll', () async {
        await database.activityDao.create(
          createTestActivity(id: 'a1', profileId: 'p-A'),
        );
        await database.activityDao.create(
          createTestActivity(id: 'a2', profileId: 'p-A', isArchived: true),
        );

        final result = await database.activityDao.getByProfile(
          'p-A',
          includeArchived: true,
        );

        expect(result.valueOrNull, hasLength(2));
      });
    });

    group('archive and unarchive', () {
      test('archive_setsIsArchivedTrue', () async {
        await database.activityDao.create(createTestActivity(id: 'act-arch'));

        await database.activityDao.archive('act-arch');
        final result = await database.activityDao.getAll();
        final activity = result.valueOrNull?.firstWhere(
          (a) => a.id == 'act-arch',
        );

        expect(activity?.isArchived, isTrue);
      });

      test('unarchive_setsIsArchivedFalse', () async {
        await database.activityDao.create(
          createTestActivity(id: 'act-unarch', isArchived: true),
        );

        await database.activityDao.unarchive('act-unarch');
        final result = await database.activityDao.getAll();
        final activity = result.valueOrNull?.firstWhere(
          (a) => a.id == 'act-unarch',
        );

        expect(activity?.isArchived, isFalse);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_returnsOnlyModifiedAfterTimestamp', () async {
        final baseTime = DateTime.now().millisecondsSinceEpoch;

        await database.activityDao.create(
          createTestActivity(id: 'old', syncUpdatedAt: baseTime - 10000),
        );
        await database.activityDao.create(
          createTestActivity(id: 'new', syncUpdatedAt: baseTime + 10000),
        );

        final result = await database.activityDao.getModifiedSince(baseTime);

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'new');
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_returnsOnlyDirtyActivities', () async {
        await database.activityDao.create(createTestActivity(id: 'dirty'));
        await database.activityDao.create(
          createTestActivity(id: 'clean', syncIsDirty: false),
        );

        final result = await database.activityDao.getPendingSync();

        expect(result.valueOrNull?.any((a) => a.id == 'dirty'), isTrue);
      });
    });

    group('getActive', () {
      test('getActive_returnsOnlyNonArchivedActivities', () async {
        await database.activityDao.create(
          createTestActivity(id: 'a1', profileId: 'p-A'),
        );
        await database.activityDao.create(
          createTestActivity(id: 'a2', profileId: 'p-A', isArchived: true),
        );

        final result = await database.activityDao.getActive('p-A');

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'a1');
      });
    });
  });
}
