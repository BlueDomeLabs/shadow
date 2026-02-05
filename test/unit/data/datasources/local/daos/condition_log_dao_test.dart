// test/unit/data/datasources/local/daos/condition_log_dao_test.dart
// Tests for ConditionLogDao per 06_TESTING_STRATEGY.md Section 4.1

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/condition_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

void main() {
  group('ConditionLogDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    // Helper to create test condition logs
    ConditionLog createTestConditionLog({
      String? id,
      String? clientId,
      String profileId = 'profile-001',
      String conditionId = 'cond-001',
      int timestamp = 1704067200000,
      int severity = 5,
      String? notes,
      bool isFlare = false,
      List<String> flarePhotoIds = const [],
      String? photoPath,
      String? activityId,
      String? triggers,
      int? syncCreatedAt,
      int? syncUpdatedAt,
      bool syncIsDirty = true,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return ConditionLog(
        id: id ?? 'log-${DateTime.now().microsecondsSinceEpoch}',
        clientId: clientId ?? 'client-${DateTime.now().microsecondsSinceEpoch}',
        profileId: profileId,
        conditionId: conditionId,
        timestamp: timestamp,
        severity: severity,
        notes: notes,
        isFlare: isFlare,
        flarePhotoIds: flarePhotoIds,
        photoPath: photoPath,
        activityId: activityId,
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
      test(
        'create_validConditionLog_returnsSuccessWithCreatedEntity',
        () async {
          final log = createTestConditionLog(id: 'log-001', severity: 7);

          final result = await database.conditionLogDao.create(log);

          expect(result.isSuccess, isTrue);
          expect(result.valueOrNull?.id, 'log-001');
          expect(result.valueOrNull?.severity, 7);
        },
      );

      test(
        'create_duplicateId_returnsFailureWithConstraintViolation',
        () async {
          final log1 = createTestConditionLog(id: 'log-duplicate');
          final log2 = createTestConditionLog(id: 'log-duplicate');

          await database.conditionLogDao.create(log1);
          final result = await database.conditionLogDao.create(log2);

          expect(result.isFailure, isTrue);
          final error = result.errorOrNull;
          expect(error, isA<DatabaseError>());
          expect(
            (error! as DatabaseError).code,
            DatabaseError.codeConstraintViolation,
          );
        },
      );

      test('create_withAllFields_persistsAllFieldsCorrectly', () async {
        const log = ConditionLog(
          id: 'log-full',
          clientId: 'client-full',
          profileId: 'profile-001',
          conditionId: 'cond-001',
          timestamp: 1704067200000,
          severity: 8,
          notes: 'Detailed notes',
          isFlare: true,
          flarePhotoIds: ['photo-1', 'photo-2'],
          photoPath: '/photos/log.jpg',
          activityId: 'activity-001',
          triggers: 'stress,food',
          syncMetadata: SyncMetadata(
            syncCreatedAt: 1704067200000,
            syncUpdatedAt: 1704067200000,
            syncDeviceId: 'device-001',
          ),
        );

        final createResult = await database.conditionLogDao.create(log);
        expect(createResult.isSuccess, isTrue);

        final getResult = await database.conditionLogDao.getById('log-full');
        expect(getResult.isSuccess, isTrue);

        final retrieved = getResult.valueOrNull!;
        expect(retrieved.id, 'log-full');
        expect(retrieved.severity, 8);
        expect(retrieved.notes, 'Detailed notes');
        expect(retrieved.isFlare, isTrue);
        expect(retrieved.flarePhotoIds, ['photo-1', 'photo-2']);
        expect(retrieved.photoPath, '/photos/log.jpg');
        expect(retrieved.triggers, 'stress,food');
      });
    });

    group('getById', () {
      test('getById_existingId_returnsSuccessWithConditionLog', () async {
        final log = createTestConditionLog(id: 'log-find-me');
        await database.conditionLogDao.create(log);

        final result = await database.conditionLogDao.getById('log-find-me');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'log-find-me');
      });

      test('getById_nonExistingId_returnsFailureWithNotFound', () async {
        final result = await database.conditionLogDao.getById(
          'log-does-not-exist',
        );

        expect(result.isFailure, isTrue);
        final error = result.errorOrNull;
        expect(error, isA<DatabaseError>());
        expect((error! as DatabaseError).code, DatabaseError.codeNotFound);
      });

      test(
        'getById_softDeletedConditionLog_returnsFailureWithNotFound',
        () async {
          final log = createTestConditionLog(id: 'log-deleted');
          await database.conditionLogDao.create(log);
          await database.conditionLogDao.softDelete('log-deleted');

          final result = await database.conditionLogDao.getById('log-deleted');

          expect(result.isFailure, isTrue);
        },
      );
    });

    group('getAll', () {
      test('getAll_noConditionLogs_returnsEmptyList', () async {
        final result = await database.conditionLogDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });

      test('getAll_multipleConditionLogs_returnsAllNonDeleted', () async {
        await database.conditionLogDao.create(
          createTestConditionLog(id: 'log-1'),
        );
        await database.conditionLogDao.create(
          createTestConditionLog(id: 'log-2'),
        );
        await database.conditionLogDao.create(
          createTestConditionLog(id: 'log-3'),
        );

        final result = await database.conditionLogDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(3));
      });

      test('getAll_excludesSoftDeletedConditionLogs', () async {
        await database.conditionLogDao.create(
          createTestConditionLog(id: 'log-1'),
        );
        await database.conditionLogDao.create(
          createTestConditionLog(id: 'log-2'),
        );
        await database.conditionLogDao.softDelete('log-2');

        final result = await database.conditionLogDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'log-1');
      });
    });

    group('getByCondition', () {
      test('getByCondition_returnsOnlyLogsForCondition', () async {
        await database.conditionLogDao.create(
          createTestConditionLog(id: 'log-1', conditionId: 'cond-A'),
        );
        await database.conditionLogDao.create(
          createTestConditionLog(id: 'log-2', conditionId: 'cond-B'),
        );

        final result = await database.conditionLogDao.getByCondition('cond-A');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.conditionId, 'cond-A');
      });
    });

    group('getByProfile', () {
      test('getByProfile_returnsOnlyLogsForProfile', () async {
        await database.conditionLogDao.create(
          createTestConditionLog(id: 'log-1', profileId: 'profile-A'),
        );
        await database.conditionLogDao.create(
          createTestConditionLog(id: 'log-2', profileId: 'profile-B'),
        );

        final result = await database.conditionLogDao.getByProfile('profile-A');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.profileId, 'profile-A');
      });
    });

    group('getFlares', () {
      test('getFlares_returnsOnlyFlareEntries', () async {
        await database.conditionLogDao.create(
          createTestConditionLog(id: 'log-1', conditionId: 'cond-A'),
        );
        await database.conditionLogDao.create(
          createTestConditionLog(
            id: 'log-2',
            conditionId: 'cond-A',
            isFlare: true,
          ),
        );

        final result = await database.conditionLogDao.getFlares('cond-A');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.isFlare, isTrue);
      });
    });

    group('getByDateRange', () {
      test('getByDateRange_returnsLogsInRange', () async {
        await database.conditionLogDao.create(
          createTestConditionLog(id: 'log-1', profileId: 'profile-A'),
        );
        await database.conditionLogDao.create(
          createTestConditionLog(
            id: 'log-2',
            profileId: 'profile-A',
            timestamp: 1704153600000,
          ),
        );
        await database.conditionLogDao.create(
          createTestConditionLog(
            id: 'log-3',
            profileId: 'profile-A',
            timestamp: 1704240000000,
          ),
        );

        final result = await database.conditionLogDao.getByDateRange(
          'profile-A',
          1704067200000,
          1704153600000,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(2));
      });
    });

    group('softDelete', () {
      test('softDelete_existingConditionLog_returnsSuccess', () async {
        await database.conditionLogDao.create(
          createTestConditionLog(id: 'log-soft-delete'),
        );

        final result = await database.conditionLogDao.softDelete(
          'log-soft-delete',
        );

        expect(result.isSuccess, isTrue);
      });

      test('softDelete_nonExistingId_returnsFailureWithNotFound', () async {
        final result = await database.conditionLogDao.softDelete(
          'log-not-exists',
        );

        expect(result.isFailure, isTrue);
        final error = result.errorOrNull;
        expect(error, isA<DatabaseError>());
        expect((error! as DatabaseError).code, DatabaseError.codeNotFound);
      });
    });

    group('hardDelete', () {
      test(
        'hardDelete_existingConditionLog_returnsSuccessAndRemovesPermanently',
        () async {
          await database.conditionLogDao.create(
            createTestConditionLog(id: 'log-hard-delete'),
          );

          final deleteResult = await database.conditionLogDao.hardDelete(
            'log-hard-delete',
          );
          expect(deleteResult.isSuccess, isTrue);

          final allResult = await database.conditionLogDao.getModifiedSince(0);
          expect(
            allResult.valueOrNull?.any((l) => l.id == 'log-hard-delete'),
            isFalse,
          );
        },
      );
    });

    group('getModifiedSince', () {
      test(
        'getModifiedSince_returnsConditionLogsModifiedAfterTimestamp',
        () async {
          final baseTime = DateTime.now().millisecondsSinceEpoch;

          await database.conditionLogDao.create(
            createTestConditionLog(
              id: 'log-old',
              syncUpdatedAt: baseTime - 10000,
            ),
          );
          await database.conditionLogDao.create(
            createTestConditionLog(
              id: 'log-new',
              syncUpdatedAt: baseTime + 10000,
            ),
          );

          final result = await database.conditionLogDao.getModifiedSince(
            baseTime,
          );

          expect(result.isSuccess, isTrue);
          expect(result.valueOrNull, hasLength(1));
          expect(result.valueOrNull?.first.id, 'log-new');
        },
      );
    });

    group('getPendingSync', () {
      test('getPendingSync_returnsOnlyDirtyConditionLogs', () async {
        await database.conditionLogDao.create(
          createTestConditionLog(id: 'log-dirty'),
        );
        final clean = createTestConditionLog(
          id: 'log-clean',
          syncIsDirty: false,
        );
        await database.conditionLogDao.create(clean);

        final result = await database.conditionLogDao.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.any((l) => l.id == 'log-dirty'), isTrue);
      });
    });
  });
}
