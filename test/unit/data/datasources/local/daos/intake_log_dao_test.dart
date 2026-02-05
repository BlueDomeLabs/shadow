// test/unit/data/datasources/local/daos/intake_log_dao_test.dart
// Tests for IntakeLogDao per 06_TESTING_STRATEGY.md Section 4.1

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/intake_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('IntakeLogDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    // Helper to create test intake logs
    IntakeLog createTestIntakeLog({
      String? id,
      String? clientId,
      String profileId = 'profile-001',
      String supplementId = 'supp-001',
      int scheduledTime = 1704067200000,
      int? actualTime,
      IntakeLogStatus status = IntakeLogStatus.pending,
      String? reason,
      String? note,
      int? syncCreatedAt,
      int? syncUpdatedAt,
      bool syncIsDirty = true,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return IntakeLog(
        id: id ?? 'log-${DateTime.now().microsecondsSinceEpoch}',
        clientId: clientId ?? 'client-${DateTime.now().microsecondsSinceEpoch}',
        profileId: profileId,
        supplementId: supplementId,
        scheduledTime: scheduledTime,
        actualTime: actualTime,
        status: status,
        reason: reason,
        note: note,
        syncMetadata: SyncMetadata(
          syncCreatedAt: syncCreatedAt ?? now,
          syncUpdatedAt: syncUpdatedAt ?? now,
          syncDeviceId: 'test-device',
          syncIsDirty: syncIsDirty,
        ),
      );
    }

    group('create', () {
      test('create_validIntakeLog_returnsSuccessWithCreatedEntity', () async {
        final intakeLog = createTestIntakeLog(id: 'log-001');

        final result = await database.intakeLogDao.create(intakeLog);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'log-001');
      });

      test(
        'create_duplicateId_returnsFailureWithConstraintViolation',
        () async {
          final log1 = createTestIntakeLog(id: 'log-duplicate');
          final log2 = createTestIntakeLog(id: 'log-duplicate');

          await database.intakeLogDao.create(log1);
          final result = await database.intakeLogDao.create(log2);

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
        const intakeLog = IntakeLog(
          id: 'log-full',
          clientId: 'client-full',
          profileId: 'profile-001',
          supplementId: 'supp-001',
          scheduledTime: 1704067200000,
          actualTime: 1704067500000,
          status: IntakeLogStatus.taken,
          reason: 'Test reason',
          note: 'Test note',
          syncMetadata: SyncMetadata(
            syncCreatedAt: 1704067200000,
            syncUpdatedAt: 1704067200000,
            syncDeviceId: 'device-001',
          ),
        );

        final createResult = await database.intakeLogDao.create(intakeLog);
        expect(createResult.isSuccess, isTrue);

        final getResult = await database.intakeLogDao.getById('log-full');
        expect(getResult.isSuccess, isTrue);

        final retrieved = getResult.valueOrNull!;
        expect(retrieved.id, 'log-full');
        expect(retrieved.clientId, 'client-full');
        expect(retrieved.profileId, 'profile-001');
        expect(retrieved.supplementId, 'supp-001');
        expect(retrieved.scheduledTime, 1704067200000);
        expect(retrieved.actualTime, 1704067500000);
        expect(retrieved.status, IntakeLogStatus.taken);
        expect(retrieved.reason, 'Test reason');
        expect(retrieved.note, 'Test note');
      });
    });

    group('getById', () {
      test('getById_existingId_returnsSuccessWithIntakeLog', () async {
        final intakeLog = createTestIntakeLog(id: 'log-find-me');
        await database.intakeLogDao.create(intakeLog);

        final result = await database.intakeLogDao.getById('log-find-me');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'log-find-me');
      });

      test('getById_nonExistingId_returnsFailureWithNotFound', () async {
        final result = await database.intakeLogDao.getById(
          'log-does-not-exist',
        );

        expect(result.isFailure, isTrue);
        final error = result.errorOrNull;
        expect(error, isA<DatabaseError>());
        expect((error! as DatabaseError).code, DatabaseError.codeNotFound);
      });

      test('getById_softDeletedIntakeLog_returnsFailureWithNotFound', () async {
        final intakeLog = createTestIntakeLog(id: 'log-deleted');
        await database.intakeLogDao.create(intakeLog);
        await database.intakeLogDao.softDelete('log-deleted');

        final result = await database.intakeLogDao.getById('log-deleted');

        expect(result.isFailure, isTrue);
        final error = result.errorOrNull;
        expect(error, isA<DatabaseError>());
        expect((error! as DatabaseError).code, DatabaseError.codeNotFound);
      });
    });

    group('getAll', () {
      test('getAll_noIntakeLogs_returnsEmptyList', () async {
        final result = await database.intakeLogDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });

      test('getAll_multipleIntakeLogs_returnsAllNonDeleted', () async {
        await database.intakeLogDao.create(createTestIntakeLog(id: 'log-1'));
        await database.intakeLogDao.create(createTestIntakeLog(id: 'log-2'));
        await database.intakeLogDao.create(createTestIntakeLog(id: 'log-3'));

        final result = await database.intakeLogDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(3));
      });

      test('getAll_excludesSoftDeletedIntakeLogs', () async {
        await database.intakeLogDao.create(createTestIntakeLog(id: 'log-1'));
        await database.intakeLogDao.create(createTestIntakeLog(id: 'log-2'));
        await database.intakeLogDao.softDelete('log-2');

        final result = await database.intakeLogDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'log-1');
      });

      test('getAll_withProfileIdFilter_returnsOnlyMatchingProfile', () async {
        await database.intakeLogDao.create(
          createTestIntakeLog(id: 'log-1', profileId: 'profile-A'),
        );
        await database.intakeLogDao.create(
          createTestIntakeLog(id: 'log-2', profileId: 'profile-A'),
        );
        await database.intakeLogDao.create(
          createTestIntakeLog(id: 'log-3', profileId: 'profile-B'),
        );

        final result = await database.intakeLogDao.getAll(
          profileId: 'profile-A',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(2));
        expect(
          result.valueOrNull?.every((l) => l.profileId == 'profile-A'),
          isTrue,
        );
      });

      test('getAll_withLimit_returnsLimitedResults', () async {
        for (var i = 0; i < 10; i++) {
          await database.intakeLogDao.create(createTestIntakeLog(id: 'log-$i'));
        }

        final result = await database.intakeLogDao.getAll(limit: 5);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(5));
      });
    });

    group('getByProfile', () {
      test('getByProfile_withStatusFilter_returnsOnlyMatchingStatus', () async {
        await database.intakeLogDao.create(
          createTestIntakeLog(id: 'log-1', profileId: 'profile-A'),
        );
        await database.intakeLogDao.create(
          createTestIntakeLog(
            id: 'log-2',
            profileId: 'profile-A',
            status: IntakeLogStatus.taken,
          ),
        );

        final result = await database.intakeLogDao.getByProfile(
          'profile-A',
          status: IntakeLogStatus.pending,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.status, IntakeLogStatus.pending);
      });

      test('getByProfile_withDateRange_returnsLogsInRange', () async {
        await database.intakeLogDao.create(
          createTestIntakeLog(id: 'log-1', profileId: 'profile-A'),
        );
        await database.intakeLogDao.create(
          createTestIntakeLog(
            id: 'log-2',
            profileId: 'profile-A',
            scheduledTime: 1704153600000, // Jan 2
          ),
        );
        await database.intakeLogDao.create(
          createTestIntakeLog(
            id: 'log-3',
            profileId: 'profile-A',
            scheduledTime: 1704240000000, // Jan 3
          ),
        );

        final result = await database.intakeLogDao.getByProfile(
          'profile-A',
          startDate: 1704067200000,
          endDate: 1704153600000,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(2));
      });
    });

    group('getBySupplement', () {
      test('getBySupplement_returnsLogsForSupplement', () async {
        await database.intakeLogDao.create(
          createTestIntakeLog(id: 'log-1', supplementId: 'supp-A'),
        );
        await database.intakeLogDao.create(
          createTestIntakeLog(id: 'log-2', supplementId: 'supp-A'),
        );
        await database.intakeLogDao.create(
          createTestIntakeLog(id: 'log-3', supplementId: 'supp-B'),
        );

        final result = await database.intakeLogDao.getBySupplement('supp-A');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(2));
        expect(
          result.valueOrNull?.every((l) => l.supplementId == 'supp-A'),
          isTrue,
        );
      });
    });

    group('getPendingForDate', () {
      test('getPendingForDate_returnsPendingLogsForDate', () async {
        const startOfDay = 1704067200000; // Jan 1, 2024 00:00:00 UTC
        await database.intakeLogDao.create(
          createTestIntakeLog(
            id: 'log-1',
            profileId: 'profile-A',
            scheduledTime: startOfDay + (8 * 60 * 60 * 1000), // 8 AM
          ),
        );
        await database.intakeLogDao.create(
          createTestIntakeLog(
            id: 'log-2',
            profileId: 'profile-A',
            scheduledTime: startOfDay + (12 * 60 * 60 * 1000), // 12 PM
            status: IntakeLogStatus.taken,
          ),
        );

        final result = await database.intakeLogDao.getPendingForDate(
          'profile-A',
          startOfDay,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.status, IntakeLogStatus.pending);
      });
    });

    group('markTaken', () {
      test('markTaken_updatesStatusAndActualTime', () async {
        await database.intakeLogDao.create(createTestIntakeLog(id: 'log-take'));

        final actualTime = DateTime.now().millisecondsSinceEpoch;
        final result = await database.intakeLogDao.markTaken(
          'log-take',
          actualTime,
        );

        expect(result.isSuccess, isTrue);

        final getResult = await database.intakeLogDao.getById('log-take');
        expect(getResult.valueOrNull?.status, IntakeLogStatus.taken);
        expect(getResult.valueOrNull?.actualTime, actualTime);
      });

      test('markTaken_nonExistingId_returnsFailure', () async {
        final result = await database.intakeLogDao.markTaken(
          'non-existent',
          DateTime.now().millisecondsSinceEpoch,
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<DatabaseError>());
      });
    });

    group('markSkipped', () {
      test('markSkipped_updatesStatusAndReason', () async {
        await database.intakeLogDao.create(createTestIntakeLog(id: 'log-skip'));

        final result = await database.intakeLogDao.markSkipped(
          'log-skip',
          'Felt sick',
        );

        expect(result.isSuccess, isTrue);

        final getResult = await database.intakeLogDao.getById('log-skip');
        expect(getResult.valueOrNull?.status, IntakeLogStatus.skipped);
        expect(getResult.valueOrNull?.reason, 'Felt sick');
      });

      test('markSkipped_withNullReason_updatesStatusOnly', () async {
        await database.intakeLogDao.create(
          createTestIntakeLog(id: 'log-skip-no-reason'),
        );

        final result = await database.intakeLogDao.markSkipped(
          'log-skip-no-reason',
          null,
        );

        expect(result.isSuccess, isTrue);

        final getResult = await database.intakeLogDao.getById(
          'log-skip-no-reason',
        );
        expect(getResult.valueOrNull?.status, IntakeLogStatus.skipped);
      });
    });

    group('softDelete', () {
      test('softDelete_existingIntakeLog_returnsSuccess', () async {
        await database.intakeLogDao.create(
          createTestIntakeLog(id: 'log-soft-delete'),
        );

        final result = await database.intakeLogDao.softDelete(
          'log-soft-delete',
        );

        expect(result.isSuccess, isTrue);
      });

      test('softDelete_makesIntakeLogInvisibleToGetById', () async {
        await database.intakeLogDao.create(
          createTestIntakeLog(id: 'log-invisible'),
        );
        await database.intakeLogDao.softDelete('log-invisible');

        final result = await database.intakeLogDao.getById('log-invisible');

        expect(result.isFailure, isTrue);
      });

      test('softDelete_nonExistingId_returnsFailureWithNotFound', () async {
        final result = await database.intakeLogDao.softDelete('log-not-exists');

        expect(result.isFailure, isTrue);
        final error = result.errorOrNull;
        expect(error, isA<DatabaseError>());
        expect((error! as DatabaseError).code, DatabaseError.codeNotFound);
      });
    });

    group('hardDelete', () {
      test(
        'hardDelete_existingIntakeLog_returnsSuccessAndRemovesPermanently',
        () async {
          await database.intakeLogDao.create(
            createTestIntakeLog(id: 'log-hard-delete'),
          );

          final deleteResult = await database.intakeLogDao.hardDelete(
            'log-hard-delete',
          );
          expect(deleteResult.isSuccess, isTrue);

          // Should not appear even in getModifiedSince
          final allResult = await database.intakeLogDao.getModifiedSince(0);
          expect(
            allResult.valueOrNull?.any((l) => l.id == 'log-hard-delete'),
            isFalse,
          );
        },
      );
    });

    group('getModifiedSince', () {
      test(
        'getModifiedSince_returnsIntakeLogsModifiedAfterTimestamp',
        () async {
          final baseTime = DateTime.now().millisecondsSinceEpoch;

          await database.intakeLogDao.create(
            createTestIntakeLog(id: 'log-old', syncUpdatedAt: baseTime - 10000),
          );
          await database.intakeLogDao.create(
            createTestIntakeLog(id: 'log-new', syncUpdatedAt: baseTime + 10000),
          );

          final result = await database.intakeLogDao.getModifiedSince(baseTime);

          expect(result.isSuccess, isTrue);
          expect(result.valueOrNull, hasLength(1));
          expect(result.valueOrNull?.first.id, 'log-new');
        },
      );
    });

    group('getPendingSync', () {
      test('getPendingSync_returnsOnlyDirtyIntakeLogs', () async {
        await database.intakeLogDao.create(
          createTestIntakeLog(id: 'log-dirty'),
        );
        // Create a clean log
        final clean = createTestIntakeLog(id: 'log-clean', syncIsDirty: false);
        await database.intakeLogDao.create(clean);

        final result = await database.intakeLogDao.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.any((l) => l.id == 'log-dirty'), isTrue);
      });
    });
  });
}
