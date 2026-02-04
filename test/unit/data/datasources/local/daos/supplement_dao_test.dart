// test/unit/data/datasources/local/daos/supplement_dao_test.dart
// Tests for SupplementDao per 06_TESTING_STRATEGY.md Section 4.1

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('SupplementDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    // Helper to create test supplements
    Supplement createTestSupplement({
      String? id,
      String? clientId,
      String profileId = 'profile-001',
      String name = 'Test Vitamin',
      SupplementForm form = SupplementForm.capsule,
      int dosageQuantity = 1,
      DosageUnit dosageUnit = DosageUnit.mg,
      bool isArchived = false,
      int? syncCreatedAt,
      int? syncUpdatedAt,
      bool syncIsDirty = true,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return Supplement(
        id: id ?? 'supp-${DateTime.now().microsecondsSinceEpoch}',
        clientId: clientId ?? 'client-${DateTime.now().microsecondsSinceEpoch}',
        profileId: profileId,
        name: name,
        form: form,
        dosageQuantity: dosageQuantity,
        dosageUnit: dosageUnit,
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
      test('create_validSupplement_returnsSuccessWithCreatedEntity', () async {
        final supplement = createTestSupplement(
          id: 'supp-001',
          name: 'Vitamin D',
        );

        final result = await database.supplementDao.create(supplement);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'supp-001');
        expect(result.valueOrNull?.name, 'Vitamin D');
      });

      test(
        'create_duplicateId_returnsFailureWithConstraintViolation',
        () async {
          final supplement1 = createTestSupplement(id: 'supp-duplicate');
          final supplement2 = createTestSupplement(id: 'supp-duplicate');

          await database.supplementDao.create(supplement1);
          final result = await database.supplementDao.create(supplement2);

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
        const supplement = Supplement(
          id: 'supp-full',
          clientId: 'client-full',
          profileId: 'profile-001',
          name: 'Complete Supplement',
          form: SupplementForm.tablet,
          dosageQuantity: 2,
          dosageUnit: DosageUnit.mg,
          brand: 'TestBrand',
          notes: 'Take with food',
          ingredients: [SupplementIngredient(name: 'Vitamin C', quantity: 500)],
          schedules: [
            SupplementSchedule(
              anchorEvent: SupplementAnchorEvent.breakfast,
              timingType: SupplementTimingType.withEvent,
              frequencyType: SupplementFrequencyType.daily,
            ),
          ],
          startDate: 1704067200000,
          endDate: 1735689600000,
          syncMetadata: SyncMetadata(
            syncCreatedAt: 1704067200000,
            syncUpdatedAt: 1704067200000,
            syncDeviceId: 'device-001',
          ),
        );

        final createResult = await database.supplementDao.create(supplement);
        expect(createResult.isSuccess, isTrue);

        final getResult = await database.supplementDao.getById('supp-full');
        expect(getResult.isSuccess, isTrue);

        final retrieved = getResult.valueOrNull!;
        expect(retrieved.id, 'supp-full');
        expect(retrieved.clientId, 'client-full');
        expect(retrieved.profileId, 'profile-001');
        expect(retrieved.name, 'Complete Supplement');
        expect(retrieved.form, SupplementForm.tablet);
        expect(retrieved.dosageQuantity, 2);
        expect(retrieved.dosageUnit, DosageUnit.mg);
        expect(retrieved.brand, 'TestBrand');
        expect(retrieved.notes, 'Take with food');
        expect(retrieved.ingredients, hasLength(1));
        expect(retrieved.ingredients.first.name, 'Vitamin C');
        expect(retrieved.schedules, hasLength(1));
        expect(
          retrieved.schedules.first.anchorEvent,
          SupplementAnchorEvent.breakfast,
        );
        expect(retrieved.startDate, 1704067200000);
        expect(retrieved.endDate, 1735689600000);
        expect(retrieved.isArchived, isFalse);
        expect(retrieved.syncMetadata.syncCreatedAt, 1704067200000);
        expect(retrieved.syncMetadata.syncDeviceId, 'device-001');
      });
    });

    group('getById', () {
      test('getById_existingId_returnsSuccessWithSupplement', () async {
        final supplement = createTestSupplement(id: 'supp-find-me');
        await database.supplementDao.create(supplement);

        final result = await database.supplementDao.getById('supp-find-me');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'supp-find-me');
      });

      test('getById_nonExistingId_returnsFailureWithNotFound', () async {
        final result = await database.supplementDao.getById(
          'supp-does-not-exist',
        );

        expect(result.isFailure, isTrue);
        final error = result.errorOrNull;
        expect(error, isA<DatabaseError>());
        expect((error! as DatabaseError).code, DatabaseError.codeNotFound);
      });

      test(
        'getById_softDeletedSupplement_returnsFailureWithNotFound',
        () async {
          final supplement = createTestSupplement(id: 'supp-deleted');
          await database.supplementDao.create(supplement);
          await database.supplementDao.softDelete('supp-deleted');

          final result = await database.supplementDao.getById('supp-deleted');

          expect(result.isFailure, isTrue);
          final error = result.errorOrNull;
          expect(error, isA<DatabaseError>());
          expect((error! as DatabaseError).code, DatabaseError.codeNotFound);
        },
      );
    });

    group('getAll', () {
      test('getAll_noSupplements_returnsEmptyList', () async {
        final result = await database.supplementDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });

      test('getAll_multipleSupplements_returnsAllNonDeleted', () async {
        await database.supplementDao.create(createTestSupplement(id: 'supp-1'));
        await database.supplementDao.create(createTestSupplement(id: 'supp-2'));
        await database.supplementDao.create(createTestSupplement(id: 'supp-3'));

        final result = await database.supplementDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(3));
      });

      test('getAll_excludesSoftDeletedSupplements', () async {
        await database.supplementDao.create(createTestSupplement(id: 'supp-1'));
        await database.supplementDao.create(createTestSupplement(id: 'supp-2'));
        await database.supplementDao.softDelete('supp-2');

        final result = await database.supplementDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'supp-1');
      });

      test('getAll_withProfileIdFilter_returnsOnlyMatchingProfile', () async {
        await database.supplementDao.create(
          createTestSupplement(id: 'supp-1', profileId: 'profile-A'),
        );
        await database.supplementDao.create(
          createTestSupplement(id: 'supp-2', profileId: 'profile-A'),
        );
        await database.supplementDao.create(
          createTestSupplement(id: 'supp-3', profileId: 'profile-B'),
        );

        final result = await database.supplementDao.getAll(
          profileId: 'profile-A',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(2));
        expect(
          result.valueOrNull?.every((s) => s.profileId == 'profile-A'),
          isTrue,
        );
      });

      test('getAll_withLimit_returnsLimitedResults', () async {
        for (var i = 0; i < 10; i++) {
          await database.supplementDao.create(
            createTestSupplement(id: 'supp-$i'),
          );
        }

        final result = await database.supplementDao.getAll(limit: 5);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(5));
      });

      test('getAll_withLimitAndOffset_returnsPaginatedResults', () async {
        for (var i = 0; i < 10; i++) {
          await database.supplementDao.create(
            createTestSupplement(
              id: 'supp-$i',
              syncCreatedAt: 1704067200000 + (i * 1000),
            ),
          );
        }

        final result = await database.supplementDao.getAll(limit: 3, offset: 2);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(3));
      });
    });

    group('updateEntity', () {
      test(
        'updateEntity_existingSupplement_returnsSuccessWithUpdatedEntity',
        () async {
          final original = createTestSupplement(id: 'supp-update', name: 'Old');
          await database.supplementDao.create(original);

          final updated = original.copyWith(name: 'New Name');
          final result = await database.supplementDao.updateEntity(updated);

          expect(result.isSuccess, isTrue);
          expect(result.valueOrNull?.name, 'New Name');
        },
      );

      test(
        'updateEntity_nonExistingSupplement_returnsFailureWithNotFound',
        () async {
          final supplement = createTestSupplement(
            id: 'supp-not-exists',
            name: 'Test',
          );

          final result = await database.supplementDao.updateEntity(supplement);

          expect(result.isFailure, isTrue);
          final error = result.errorOrNull;
          expect(error, isA<DatabaseError>());
          expect((error! as DatabaseError).code, DatabaseError.codeNotFound);
        },
      );

      test('updateEntity_persistsAllChangedFields', () async {
        final original = createTestSupplement(
          id: 'supp-update-all',
          name: 'Original',
        );
        await database.supplementDao.create(original);

        final updated = original.copyWith(
          name: 'Updated Name',
          dosageQuantity: 3,
          brand: 'New Brand',
          notes: 'Updated notes',
          isArchived: true,
        );
        await database.supplementDao.updateEntity(updated);

        final result = await database.supplementDao.getById('supp-update-all');
        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.name, 'Updated Name');
        expect(result.valueOrNull?.dosageQuantity, 3);
        expect(result.valueOrNull?.brand, 'New Brand');
        expect(result.valueOrNull?.notes, 'Updated notes');
        expect(result.valueOrNull?.isArchived, isTrue);
      });
    });

    group('softDelete', () {
      test('softDelete_existingSupplement_returnsSuccess', () async {
        await database.supplementDao.create(
          createTestSupplement(id: 'supp-soft-delete'),
        );

        final result = await database.supplementDao.softDelete(
          'supp-soft-delete',
        );

        expect(result.isSuccess, isTrue);
      });

      test('softDelete_makesSupplementInvisibleToGetById', () async {
        await database.supplementDao.create(
          createTestSupplement(id: 'supp-invisible'),
        );
        await database.supplementDao.softDelete('supp-invisible');

        final result = await database.supplementDao.getById('supp-invisible');

        expect(result.isFailure, isTrue);
      });

      test('softDelete_nonExistingId_returnsFailureWithNotFound', () async {
        final result = await database.supplementDao.softDelete(
          'supp-not-exists',
        );

        expect(result.isFailure, isTrue);
        final error = result.errorOrNull;
        expect(error, isA<DatabaseError>());
        expect((error! as DatabaseError).code, DatabaseError.codeNotFound);
      });

      test(
        'softDelete_alreadyDeletedSupplement_returnsFailureWithNotFound',
        () async {
          await database.supplementDao.create(
            createTestSupplement(id: 'supp-double-delete'),
          );
          await database.supplementDao.softDelete('supp-double-delete');

          final result = await database.supplementDao.softDelete(
            'supp-double-delete',
          );

          expect(result.isFailure, isTrue);
          final error = result.errorOrNull;
          expect(error, isA<DatabaseError>());
          expect((error! as DatabaseError).code, DatabaseError.codeNotFound);
        },
      );

      test('softDelete_setsSyncStatusToDeleted', () async {
        await database.supplementDao.create(
          createTestSupplement(id: 'supp-status-check'),
        );
        await database.supplementDao.softDelete('supp-status-check');

        // Get via getModifiedSince to see deleted items
        final result = await database.supplementDao.getModifiedSince(0);
        final deleted = result.valueOrNull?.firstWhere(
          (s) => s.id == 'supp-status-check',
        );

        expect(deleted?.syncMetadata.syncStatus, SyncStatus.deleted);
        expect(deleted?.syncMetadata.syncDeletedAt, isNotNull);
      });
    });

    group('hardDelete', () {
      test(
        'hardDelete_existingSupplement_returnsSuccessAndRemovesPermanently',
        () async {
          await database.supplementDao.create(
            createTestSupplement(id: 'supp-hard-delete'),
          );

          final deleteResult = await database.supplementDao.hardDelete(
            'supp-hard-delete',
          );
          expect(deleteResult.isSuccess, isTrue);

          // Should not appear even in getModifiedSince
          final allResult = await database.supplementDao.getModifiedSince(0);
          expect(
            allResult.valueOrNull?.any((s) => s.id == 'supp-hard-delete'),
            isFalse,
          );
        },
      );

      test('hardDelete_nonExistingId_returnsFailureWithNotFound', () async {
        final result = await database.supplementDao.hardDelete(
          'supp-not-exists',
        );

        expect(result.isFailure, isTrue);
        final error = result.errorOrNull;
        expect(error, isA<DatabaseError>());
        expect((error! as DatabaseError).code, DatabaseError.codeNotFound);
      });

      test('hardDelete_softDeletedSupplement_removesCompletely', () async {
        await database.supplementDao.create(
          createTestSupplement(id: 'supp-soft-then-hard'),
        );
        await database.supplementDao.softDelete('supp-soft-then-hard');

        final hardResult = await database.supplementDao.hardDelete(
          'supp-soft-then-hard',
        );

        expect(hardResult.isSuccess, isTrue);
      });
    });

    group('getModifiedSince', () {
      test(
        'getModifiedSince_returnsSupplementsModifiedAfterTimestamp',
        () async {
          final baseTime = DateTime.now().millisecondsSinceEpoch;

          await database.supplementDao.create(
            createTestSupplement(
              id: 'supp-old',
              syncUpdatedAt: baseTime - 10000,
            ),
          );
          await database.supplementDao.create(
            createTestSupplement(
              id: 'supp-new',
              syncUpdatedAt: baseTime + 10000,
            ),
          );

          final result = await database.supplementDao.getModifiedSince(
            baseTime,
          );

          expect(result.isSuccess, isTrue);
          expect(result.valueOrNull, hasLength(1));
          expect(result.valueOrNull?.first.id, 'supp-new');
        },
      );

      test('getModifiedSince_includesSoftDeletedSupplements', () async {
        final baseTime = DateTime.now().millisecondsSinceEpoch;

        await database.supplementDao.create(
          createTestSupplement(id: 'supp-to-delete', syncUpdatedAt: baseTime),
        );
        await database.supplementDao.softDelete('supp-to-delete');

        final result = await database.supplementDao.getModifiedSince(
          baseTime - 1000,
        );

        expect(result.isSuccess, isTrue);
        expect(
          result.valueOrNull?.any((s) => s.id == 'supp-to-delete'),
          isTrue,
        );
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_returnsOnlyDirtySupplements', () async {
        await database.supplementDao.create(
          createTestSupplement(id: 'supp-dirty'),
        );
        // Create a clean supplement
        final clean = createTestSupplement(
          id: 'supp-clean',
          syncIsDirty: false,
        );
        await database.supplementDao.create(clean);

        final result = await database.supplementDao.getPendingSync();

        expect(result.isSuccess, isTrue);
        // At least the dirty one should be there
        expect(result.valueOrNull?.any((s) => s.id == 'supp-dirty'), isTrue);
      });
    });

    group('getByProfile', () {
      test('getByProfile_returnsOnlySupplementsForProfile', () async {
        await database.supplementDao.create(
          createTestSupplement(id: 'supp-1', profileId: 'profile-A'),
        );
        await database.supplementDao.create(
          createTestSupplement(id: 'supp-2', profileId: 'profile-B'),
        );

        final result = await database.supplementDao.getByProfile('profile-A');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.profileId, 'profile-A');
      });

      test(
        'getByProfile_withActiveOnlyTrue_excludesArchivedSupplements',
        () async {
          await database.supplementDao.create(
            createTestSupplement(id: 'supp-active', profileId: 'profile-A'),
          );
          await database.supplementDao.create(
            createTestSupplement(
              id: 'supp-archived',
              profileId: 'profile-A',
              isArchived: true,
            ),
          );

          final result = await database.supplementDao.getByProfile(
            'profile-A',
            activeOnly: true,
          );

          expect(result.isSuccess, isTrue);
          expect(result.valueOrNull, hasLength(1));
          expect(result.valueOrNull?.first.id, 'supp-active');
        },
      );

      test('getByProfile_withActiveOnlyFalse_includesAllSupplements', () async {
        await database.supplementDao.create(
          createTestSupplement(id: 'supp-active', profileId: 'profile-A'),
        );
        await database.supplementDao.create(
          createTestSupplement(
            id: 'supp-archived',
            profileId: 'profile-A',
            isArchived: true,
          ),
        );

        final result = await database.supplementDao.getByProfile(
          'profile-A',
          activeOnly: false,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(2));
      });

      test('getByProfile_ordersAlphabeticallyByName', () async {
        await database.supplementDao.create(
          createTestSupplement(
            id: 'supp-z',
            profileId: 'profile-A',
            name: 'Zinc',
          ),
        );
        await database.supplementDao.create(
          createTestSupplement(
            id: 'supp-a',
            profileId: 'profile-A',
            name: 'Vitamin A',
          ),
        );
        await database.supplementDao.create(
          createTestSupplement(
            id: 'supp-c',
            profileId: 'profile-A',
            name: 'Vitamin C',
          ),
        );

        final result = await database.supplementDao.getByProfile('profile-A');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?[0].name, 'Vitamin A');
        expect(result.valueOrNull?[1].name, 'Vitamin C');
        expect(result.valueOrNull?[2].name, 'Zinc');
      });

      test('getByProfile_withLimitAndOffset_returnsPaginatedResults', () async {
        for (var i = 0; i < 10; i++) {
          await database.supplementDao.create(
            createTestSupplement(
              id: 'supp-$i',
              profileId: 'profile-A',
              name: 'Supplement ${i.toString().padLeft(2, '0')}',
            ),
          );
        }

        final result = await database.supplementDao.getByProfile(
          'profile-A',
          limit: 3,
          offset: 2,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(3));
      });
    });

    group('search', () {
      test('search_matchingName_returnsMatchingSupplements', () async {
        await database.supplementDao.create(
          createTestSupplement(
            id: 'supp-vd',
            profileId: 'profile-A',
            name: 'Vitamin D3',
          ),
        );
        await database.supplementDao.create(
          createTestSupplement(
            id: 'supp-vc',
            profileId: 'profile-A',
            name: 'Vitamin C',
          ),
        );
        await database.supplementDao.create(
          createTestSupplement(
            id: 'supp-mg',
            profileId: 'profile-A',
            name: 'Magnesium',
          ),
        );

        final result = await database.supplementDao.search(
          'profile-A',
          'Vitamin',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(2));
      });

      test('search_caseInsensitive_matchesRegardlessOfCase', () async {
        await database.supplementDao.create(
          createTestSupplement(
            id: 'supp-1',
            profileId: 'profile-A',
            name: 'VITAMIN D',
          ),
        );

        final result = await database.supplementDao.search(
          'profile-A',
          'vitamin',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
      });

      test('search_partialMatch_findsSubstrings', () async {
        await database.supplementDao.create(
          createTestSupplement(
            id: 'supp-1',
            profileId: 'profile-A',
            name: 'Omega-3 Fish Oil',
          ),
        );

        final result = await database.supplementDao.search('profile-A', 'Fish');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
      });

      test('search_noMatches_returnsEmptyList', () async {
        await database.supplementDao.create(
          createTestSupplement(
            id: 'supp-1',
            profileId: 'profile-A',
            name: 'Vitamin D',
          ),
        );

        final result = await database.supplementDao.search('profile-A', 'Zinc');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });

      test('search_respectsProfileFilter', () async {
        await database.supplementDao.create(
          createTestSupplement(
            id: 'supp-1',
            profileId: 'profile-A',
            name: 'Vitamin D',
          ),
        );
        await database.supplementDao.create(
          createTestSupplement(
            id: 'supp-2',
            profileId: 'profile-B',
            name: 'Vitamin D',
          ),
        );

        final result = await database.supplementDao.search(
          'profile-A',
          'Vitamin',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.profileId, 'profile-A');
      });

      test('search_excludesSoftDeletedSupplements', () async {
        await database.supplementDao.create(
          createTestSupplement(
            id: 'supp-active',
            profileId: 'profile-A',
            name: 'Vitamin Active',
          ),
        );
        await database.supplementDao.create(
          createTestSupplement(
            id: 'supp-deleted',
            profileId: 'profile-A',
            name: 'Vitamin Deleted',
          ),
        );
        await database.supplementDao.softDelete('supp-deleted');

        final result = await database.supplementDao.search(
          'profile-A',
          'Vitamin',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'supp-active');
      });

      test('search_respectsLimitParameter', () async {
        for (var i = 0; i < 10; i++) {
          await database.supplementDao.create(
            createTestSupplement(
              id: 'supp-$i',
              profileId: 'profile-A',
              name: 'Vitamin $i',
            ),
          );
        }

        final result = await database.supplementDao.search(
          'profile-A',
          'Vitamin',
          limit: 5,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, hasLength(5));
      });
    });
  });
}
