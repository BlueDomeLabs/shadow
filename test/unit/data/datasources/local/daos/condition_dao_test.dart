// test/unit/data/datasources/local/daos/condition_dao_test.dart
// Tests for ConditionDao per 06_TESTING_STRATEGY.md Section 4.1

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('ConditionDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    // Helper to create test conditions
    Condition createTestCondition({
      String? id,
      String? clientId,
      String profileId = 'profile-001',
      String name = 'Test Condition',
      String category = 'skin',
      List<String> bodyLocations = const ['arm', 'leg'],
      String? description,
      String? baselinePhotoPath,
      int startTimeframe = 1704067200000,
      int? endDate,
      ConditionStatus status = ConditionStatus.active,
      bool isArchived = false,
      int? syncCreatedAt,
      int? syncUpdatedAt,
      bool syncIsDirty = true,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return Condition(
        id: id ?? 'cond-${DateTime.now().microsecondsSinceEpoch}',
        clientId: clientId ?? 'client-${DateTime.now().microsecondsSinceEpoch}',
        profileId: profileId,
        name: name,
        category: category,
        bodyLocations: bodyLocations,
        description: description,
        baselinePhotoPath: baselinePhotoPath,
        startTimeframe: startTimeframe,
        endDate: endDate,
        status: status,
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
      test('create_validCondition_returnsSuccessWithCreatedEntity', () async {
        final condition = createTestCondition(id: 'cond-001', name: 'Eczema');

        final result = await database.conditionDao.create(condition);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'cond-001');
        expect(result.valueOrNull?.name, 'Eczema');
      });

      test(
        'create_duplicateId_returnsFailureWithConstraintViolation',
        () async {
          final cond1 = createTestCondition(id: 'cond-duplicate');
          final cond2 = createTestCondition(id: 'cond-duplicate');

          await database.conditionDao.create(cond1);
          final result = await database.conditionDao.create(cond2);

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
        const condition = Condition(
          id: 'cond-full',
          clientId: 'client-full',
          profileId: 'profile-001',
          name: 'Complete Condition',
          category: 'skin',
          bodyLocations: ['arm', 'leg', 'back'],
          description: 'Detailed description',
          baselinePhotoPath: '/photos/baseline.jpg',
          startTimeframe: 1704067200000,
          endDate: 1704153600000,
          status: ConditionStatus.resolved,
          isArchived: true,
          syncMetadata: SyncMetadata(
            syncCreatedAt: 1704067200000,
            syncUpdatedAt: 1704067200000,
            syncDeviceId: 'device-001',
          ),
        );

        final createResult = await database.conditionDao.create(condition);
        expect(createResult.isSuccess, isTrue);

        final getResult = await database.conditionDao.getById('cond-full');
        expect(getResult.isSuccess, isTrue);

        final retrieved = getResult.valueOrNull!;
        expect(retrieved.id, 'cond-full');
        expect(retrieved.name, 'Complete Condition');
        expect(retrieved.bodyLocations, ['arm', 'leg', 'back']);
        expect(retrieved.description, 'Detailed description');
        expect(retrieved.baselinePhotoPath, '/photos/baseline.jpg');
        expect(retrieved.status, ConditionStatus.resolved);
        expect(retrieved.isArchived, isTrue);
      });
    });

    group('getById', () {
      test('getById_existingId_returnsSuccessWithCondition', () async {
        final condition = createTestCondition(id: 'cond-find-me');
        await database.conditionDao.create(condition);

        final result = await database.conditionDao.getById('cond-find-me');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'cond-find-me');
      });

      test('getById_nonExistingId_returnsFailureWithNotFound', () async {
        final result = await database.conditionDao.getById(
          'cond-does-not-exist',
        );

        expect(result.isFailure, isTrue);
        final error = result.errorOrNull;
        expect(error, isA<DatabaseError>());
        expect((error! as DatabaseError).code, DatabaseError.codeNotFound);
      });

      test('getById_softDeletedCondition_returnsFailureWithNotFound', () async {
        final condition = createTestCondition(id: 'cond-deleted');
        await database.conditionDao.create(condition);
        await database.conditionDao.softDelete('cond-deleted');

        final result = await database.conditionDao.getById('cond-deleted');

        expect(result.isFailure, isTrue);
      });
    });

    group('getAll', () {
      test('getAll_noConditions_returnsEmptyList', () async {
        final result = await database.conditionDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });

      test('getAll_multipleConditions_returnsAllNonDeleted', () async {
        await database.conditionDao.create(createTestCondition(id: 'cond-1'));
        await database.conditionDao.create(createTestCondition(id: 'cond-2'));
        await database.conditionDao.create(createTestCondition(id: 'cond-3'));

        final result = await database.conditionDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(3));
      });

      test('getAll_excludesSoftDeletedConditions', () async {
        await database.conditionDao.create(createTestCondition(id: 'cond-1'));
        await database.conditionDao.create(createTestCondition(id: 'cond-2'));
        await database.conditionDao.softDelete('cond-2');

        final result = await database.conditionDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'cond-1');
      });
    });

    group('getByProfile', () {
      test('getByProfile_returnsOnlyConditionsForProfile', () async {
        await database.conditionDao.create(
          createTestCondition(id: 'cond-1', profileId: 'profile-A'),
        );
        await database.conditionDao.create(
          createTestCondition(id: 'cond-2', profileId: 'profile-B'),
        );

        final result = await database.conditionDao.getByProfile('profile-A');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.profileId, 'profile-A');
      });

      test('getByProfile_withStatusFilter_returnsOnlyMatchingStatus', () async {
        await database.conditionDao.create(
          createTestCondition(id: 'cond-1', profileId: 'profile-A'),
        );
        await database.conditionDao.create(
          createTestCondition(
            id: 'cond-2',
            profileId: 'profile-A',
            status: ConditionStatus.resolved,
          ),
        );

        final result = await database.conditionDao.getByProfile(
          'profile-A',
          status: ConditionStatus.active,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.status, ConditionStatus.active);
      });

      test('getByProfile_excludesArchivedByDefault', () async {
        await database.conditionDao.create(
          createTestCondition(id: 'cond-active', profileId: 'profile-A'),
        );
        await database.conditionDao.create(
          createTestCondition(
            id: 'cond-archived',
            profileId: 'profile-A',
            isArchived: true,
          ),
        );

        final result = await database.conditionDao.getByProfile('profile-A');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'cond-active');
      });

      test('getByProfile_includeArchivedTrue_includesAllConditions', () async {
        await database.conditionDao.create(
          createTestCondition(id: 'cond-active', profileId: 'profile-A'),
        );
        await database.conditionDao.create(
          createTestCondition(
            id: 'cond-archived',
            profileId: 'profile-A',
            isArchived: true,
          ),
        );

        final result = await database.conditionDao.getByProfile(
          'profile-A',
          includeArchived: true,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(2));
      });

      test('getByProfile_ordersAlphabeticallyByName', () async {
        await database.conditionDao.create(
          createTestCondition(
            id: 'cond-z',
            profileId: 'profile-A',
            name: 'Zoster',
          ),
        );
        await database.conditionDao.create(
          createTestCondition(
            id: 'cond-a',
            profileId: 'profile-A',
            name: 'Acne',
          ),
        );
        await database.conditionDao.create(
          createTestCondition(
            id: 'cond-e',
            profileId: 'profile-A',
            name: 'Eczema',
          ),
        );

        final result = await database.conditionDao.getByProfile('profile-A');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?[0].name, 'Acne');
        expect(result.valueOrNull?[1].name, 'Eczema');
        expect(result.valueOrNull?[2].name, 'Zoster');
      });
    });

    group('getActive', () {
      test('getActive_returnsOnlyActiveNonArchivedConditions', () async {
        await database.conditionDao.create(
          createTestCondition(id: 'cond-1', profileId: 'profile-A'),
        );
        await database.conditionDao.create(
          createTestCondition(
            id: 'cond-2',
            profileId: 'profile-A',
            status: ConditionStatus.resolved,
          ),
        );
        await database.conditionDao.create(
          createTestCondition(
            id: 'cond-3',
            profileId: 'profile-A',
            isArchived: true,
          ),
        );

        final result = await database.conditionDao.getActive('profile-A');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'cond-1');
      });
    });

    group('archive', () {
      test('archive_setsIsArchivedTrue', () async {
        await database.conditionDao.create(
          createTestCondition(id: 'cond-archive'),
        );

        final result = await database.conditionDao.archive('cond-archive');
        expect(result.isSuccess, isTrue);

        final getResult = await database.conditionDao.getByProfile(
          'profile-001',
          includeArchived: true,
        );
        final archived = getResult.valueOrNull?.firstWhere(
          (c) => c.id == 'cond-archive',
        );
        expect(archived?.isArchived, isTrue);
      });

      test('archive_nonExistingId_returnsFailure', () async {
        final result = await database.conditionDao.archive('non-existent');

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<DatabaseError>());
      });
    });

    group('resolve', () {
      test('resolve_setsStatusToResolvedAndSetsEndDate', () async {
        await database.conditionDao.create(
          createTestCondition(id: 'cond-resolve'),
        );

        final result = await database.conditionDao.resolve('cond-resolve');
        expect(result.isSuccess, isTrue);

        final getResult = await database.conditionDao.getById('cond-resolve');
        expect(getResult.valueOrNull?.status, ConditionStatus.resolved);
        expect(getResult.valueOrNull?.endDate, isNotNull);
      });

      test('resolve_nonExistingId_returnsFailure', () async {
        final result = await database.conditionDao.resolve('non-existent');

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<DatabaseError>());
      });
    });

    group('softDelete', () {
      test('softDelete_existingCondition_returnsSuccess', () async {
        await database.conditionDao.create(
          createTestCondition(id: 'cond-soft-delete'),
        );

        final result = await database.conditionDao.softDelete(
          'cond-soft-delete',
        );

        expect(result.isSuccess, isTrue);
      });

      test('softDelete_nonExistingId_returnsFailureWithNotFound', () async {
        final result = await database.conditionDao.softDelete(
          'cond-not-exists',
        );

        expect(result.isFailure, isTrue);
        final error = result.errorOrNull;
        expect(error, isA<DatabaseError>());
        expect((error! as DatabaseError).code, DatabaseError.codeNotFound);
      });
    });

    group('hardDelete', () {
      test(
        'hardDelete_existingCondition_returnsSuccessAndRemovesPermanently',
        () async {
          await database.conditionDao.create(
            createTestCondition(id: 'cond-hard-delete'),
          );

          final deleteResult = await database.conditionDao.hardDelete(
            'cond-hard-delete',
          );
          expect(deleteResult.isSuccess, isTrue);

          final allResult = await database.conditionDao.getModifiedSince(0);
          expect(
            allResult.valueOrNull?.any((c) => c.id == 'cond-hard-delete'),
            isFalse,
          );
        },
      );
    });

    group('getModifiedSince', () {
      test(
        'getModifiedSince_returnsConditionsModifiedAfterTimestamp',
        () async {
          final baseTime = DateTime.now().millisecondsSinceEpoch;

          await database.conditionDao.create(
            createTestCondition(
              id: 'cond-old',
              syncUpdatedAt: baseTime - 10000,
            ),
          );
          await database.conditionDao.create(
            createTestCondition(
              id: 'cond-new',
              syncUpdatedAt: baseTime + 10000,
            ),
          );

          final result = await database.conditionDao.getModifiedSince(baseTime);

          expect(result.isSuccess, isTrue);
          expect(result.valueOrNull, hasLength(1));
          expect(result.valueOrNull?.first.id, 'cond-new');
        },
      );
    });

    group('getPendingSync', () {
      test('getPendingSync_returnsOnlyDirtyConditions', () async {
        await database.conditionDao.create(
          createTestCondition(id: 'cond-dirty'),
        );
        final clean = createTestCondition(id: 'cond-clean', syncIsDirty: false);
        await database.conditionDao.create(clean);

        final result = await database.conditionDao.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.any((c) => c.id == 'cond-dirty'), isTrue);
      });
    });
  });
}
