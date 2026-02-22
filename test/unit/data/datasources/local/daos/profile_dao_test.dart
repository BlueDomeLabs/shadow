// test/unit/data/datasources/local/daos/profile_dao_test.dart
// Tests for ProfileDao per 06_TESTING_STRATEGY.md Section 4.1

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/profile.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('ProfileDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    // Helper to create test profiles
    Profile createTestProfile({
      String? id,
      String? clientId,
      String name = 'Test Profile',
      String? ownerId = 'owner-001',
      int? birthDate,
      BiologicalSex? biologicalSex,
      String? ethnicity,
      String? notes,
      ProfileDietType dietType = ProfileDietType.none,
      String? dietDescription,
      int? syncCreatedAt,
      int? syncUpdatedAt,
      bool syncIsDirty = true,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return Profile(
        id: id ?? 'profile-${DateTime.now().microsecondsSinceEpoch}',
        clientId: clientId ?? 'client-${DateTime.now().microsecondsSinceEpoch}',
        name: name,
        ownerId: ownerId,
        birthDate: birthDate,
        biologicalSex: biologicalSex,
        ethnicity: ethnicity,
        notes: notes,
        dietType: dietType,
        dietDescription: dietDescription,
        syncMetadata: SyncMetadata(
          syncCreatedAt: syncCreatedAt ?? now,
          syncUpdatedAt: syncUpdatedAt ?? now,
          syncDeviceId: 'test-device',
          syncIsDirty: syncIsDirty,
        ),
      );
    }

    group('create', () {
      test('create_validProfile_returnsSuccessWithCreatedEntity', () async {
        final profile = createTestProfile(id: 'profile-001', name: 'Reid');

        final result = await database.profileDao.create(profile);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'profile-001');
        expect(result.valueOrNull?.name, 'Reid');
      });

      test(
        'create_duplicateId_returnsFailureWithConstraintViolation',
        () async {
          final profile1 = createTestProfile(id: 'profile-dup');
          final profile2 = createTestProfile(id: 'profile-dup');

          await database.profileDao.create(profile1);
          final result = await database.profileDao.create(profile2);

          expect(result.isFailure, isTrue);
          final error = result.errorOrNull;
          expect(error, isA<DatabaseError>());
        },
      );

      test('create_withAllFields_preservesAllData', () async {
        final profile = createTestProfile(
          id: 'profile-full',
          name: 'Full Profile',
          ownerId: 'owner-full',
          birthDate: DateTime(1990, 6, 15).millisecondsSinceEpoch,
          biologicalSex: BiologicalSex.male,
          ethnicity: 'Caucasian',
          notes: 'Test notes',
          dietType: ProfileDietType.keto,
          dietDescription: 'Strict keto',
        );

        final result = await database.profileDao.create(profile);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.name, 'Full Profile');
        expect(created.ownerId, 'owner-full');
        expect(created.birthDate, profile.birthDate);
        expect(created.biologicalSex, BiologicalSex.male);
        expect(created.ethnicity, 'Caucasian');
        expect(created.notes, 'Test notes');
        expect(created.dietType, ProfileDietType.keto);
        expect(created.dietDescription, 'Strict keto');
      });

      test('create_withNullOptionalFields_preservesNulls', () async {
        final profile = createTestProfile(
          id: 'profile-minimal',
          name: 'Minimal',
          ownerId: null,
        );

        final result = await database.profileDao.create(profile);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.ownerId, isNull);
        expect(created.birthDate, isNull);
        expect(created.biologicalSex, isNull);
        expect(created.ethnicity, isNull);
        expect(created.notes, isNull);
        expect(created.dietDescription, isNull);
      });
    });

    group('getById', () {
      test('getById_existingProfile_returnsSuccess', () async {
        final profile = createTestProfile(id: 'profile-get');
        await database.profileDao.create(profile);

        final result = await database.profileDao.getById('profile-get');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'profile-get');
      });

      test('getById_nonExistent_returnsNotFoundError', () async {
        final result = await database.profileDao.getById('nonexistent');

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<DatabaseError>());
      });

      test('getById_softDeletedProfile_returnsNotFoundError', () async {
        final profile = createTestProfile(id: 'profile-deleted');
        await database.profileDao.create(profile);
        await database.profileDao.softDelete('profile-deleted');

        final result = await database.profileDao.getById('profile-deleted');

        expect(result.isFailure, isTrue);
      });
    });

    group('getAll', () {
      test('getAll_returnsAllNonDeletedProfiles', () async {
        await database.profileDao.create(
          createTestProfile(id: 'p1', name: 'Alpha'),
        );
        await database.profileDao.create(
          createTestProfile(id: 'p2', name: 'Beta'),
        );
        await database.profileDao.create(
          createTestProfile(id: 'p3', name: 'Gamma'),
        );
        await database.profileDao.softDelete('p2');

        final result = await database.profileDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.length, 2);
      });

      test('getAll_orderedByNameAscending', () async {
        await database.profileDao.create(
          createTestProfile(id: 'p1', name: 'Charlie'),
        );
        await database.profileDao.create(
          createTestProfile(id: 'p2', name: 'Alpha'),
        );
        await database.profileDao.create(
          createTestProfile(id: 'p3', name: 'Beta'),
        );

        final result = await database.profileDao.getAll();

        expect(result.isSuccess, isTrue);
        final profiles = result.valueOrNull!;
        expect(profiles[0].name, 'Alpha');
        expect(profiles[1].name, 'Beta');
        expect(profiles[2].name, 'Charlie');
      });

      test('getAll_withLimit_respectsLimit', () async {
        await database.profileDao.create(
          createTestProfile(id: 'p1', name: 'A'),
        );
        await database.profileDao.create(
          createTestProfile(id: 'p2', name: 'B'),
        );
        await database.profileDao.create(
          createTestProfile(id: 'p3', name: 'C'),
        );

        final result = await database.profileDao.getAll(limit: 2);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.length, 2);
      });

      test('getAll_emptyDatabase_returnsEmptyList', () async {
        final result = await database.profileDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });
    });

    group('updateEntity', () {
      test('updateEntity_existingProfile_returnsUpdatedEntity', () async {
        final profile = createTestProfile(id: 'p-update', name: 'Original');
        await database.profileDao.create(profile);

        final updated = profile.copyWith(name: 'Updated Name');
        final result = await database.profileDao.updateEntity(updated);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.name, 'Updated Name');
      });

      test('updateEntity_nonExistent_returnsNotFoundError', () async {
        final profile = createTestProfile(id: 'nonexistent');

        final result = await database.profileDao.updateEntity(profile);

        expect(result.isFailure, isTrue);
      });

      test('updateEntity_changesMultipleFields', () async {
        final profile = createTestProfile(id: 'p-multi', name: 'Original');
        await database.profileDao.create(profile);

        final updated = profile.copyWith(
          name: 'New Name',
          dietType: ProfileDietType.vegan,
          notes: 'Updated notes',
          biologicalSex: BiologicalSex.female,
        );
        final result = await database.profileDao.updateEntity(updated);

        expect(result.isSuccess, isTrue);
        final entity = result.valueOrNull!;
        expect(entity.name, 'New Name');
        expect(entity.dietType, ProfileDietType.vegan);
        expect(entity.notes, 'Updated notes');
        expect(entity.biologicalSex, BiologicalSex.female);
      });
    });

    group('softDelete', () {
      test('softDelete_existingProfile_returnsSuccess', () async {
        final profile = createTestProfile(id: 'p-del');
        await database.profileDao.create(profile);

        final result = await database.profileDao.softDelete('p-del');

        expect(result.isSuccess, isTrue);
      });

      test('softDelete_nonExistent_returnsNotFoundError', () async {
        final result = await database.profileDao.softDelete('nonexistent');

        expect(result.isFailure, isTrue);
      });

      test('softDelete_excludesFromGetAll', () async {
        final profile = createTestProfile(id: 'p-soft');
        await database.profileDao.create(profile);

        await database.profileDao.softDelete('p-soft');
        final result = await database.profileDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });
    });

    group('hardDelete', () {
      test('hardDelete_existingProfile_returnsSuccess', () async {
        final profile = createTestProfile(id: 'p-hard');
        await database.profileDao.create(profile);

        final result = await database.profileDao.hardDelete('p-hard');

        expect(result.isSuccess, isTrue);
      });

      test('hardDelete_nonExistent_returnsNotFoundError', () async {
        final result = await database.profileDao.hardDelete('nonexistent');

        expect(result.isFailure, isTrue);
      });
    });

    group('getByOwner', () {
      test('getByOwner_returnsOnlyProfilesForOwner', () async {
        await database.profileDao.create(
          createTestProfile(id: 'p1', ownerId: 'owner-A', name: 'ProfileA'),
        );
        await database.profileDao.create(
          createTestProfile(id: 'p2', ownerId: 'owner-B', name: 'ProfileB'),
        );
        await database.profileDao.create(
          createTestProfile(id: 'p3', ownerId: 'owner-A', name: 'ProfileC'),
        );

        final result = await database.profileDao.getByOwner('owner-A');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.length, 2);
        expect(
          result.valueOrNull?.every((p) => p.ownerId == 'owner-A'),
          isTrue,
        );
      });

      test('getByOwner_excludesSoftDeleted', () async {
        await database.profileDao.create(
          createTestProfile(id: 'p1', ownerId: 'owner-X'),
        );
        await database.profileDao.create(
          createTestProfile(id: 'p2', ownerId: 'owner-X'),
        );
        await database.profileDao.softDelete('p1');

        final result = await database.profileDao.getByOwner('owner-X');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.length, 1);
      });

      test('getByOwner_noProfiles_returnsEmptyList', () async {
        final result = await database.profileDao.getByOwner('owner-none');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });
    });

    group('getDefault', () {
      test('getDefault_returnsFirstCreatedProfile', () async {
        final earlyTime = DateTime(2020).millisecondsSinceEpoch;
        final lateTime = DateTime(2025).millisecondsSinceEpoch;

        await database.profileDao.create(
          createTestProfile(
            id: 'p-late',
            ownerId: 'owner-def',
            name: 'Late',
            syncCreatedAt: lateTime,
          ),
        );
        await database.profileDao.create(
          createTestProfile(
            id: 'p-early',
            ownerId: 'owner-def',
            name: 'Early',
            syncCreatedAt: earlyTime,
          ),
        );

        final result = await database.profileDao.getDefault('owner-def');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.name, 'Early');
      });

      test('getDefault_noProfiles_returnsNull', () async {
        final result = await database.profileDao.getDefault('owner-empty');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_returnsOnlyModifiedProfiles', () async {
        await database.profileDao.create(
          createTestProfile(id: 'p-old', syncUpdatedAt: 1000),
        );
        await database.profileDao.create(
          createTestProfile(id: 'p-new', syncUpdatedAt: 3000),
        );

        final result = await database.profileDao.getModifiedSince(2000);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.length, 1);
        expect(result.valueOrNull?.first.id, 'p-new');
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_returnsOnlyDirtyProfiles', () async {
        await database.profileDao.create(createTestProfile(id: 'p-dirty'));
        await database.profileDao.create(
          createTestProfile(id: 'p-clean', syncIsDirty: false),
        );

        final result = await database.profileDao.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.length, 1);
        expect(result.valueOrNull?.first.id, 'p-dirty');
      });
    });

    group('syncMetadata mapping', () {
      test('syncMetadata_roundTripsCorrectly', () async {
        final profile = createTestProfile(
          id: 'p-sync',
          syncCreatedAt: 1000,
          syncUpdatedAt: 2000,
        );

        await database.profileDao.create(profile);
        final result = await database.profileDao.getById('p-sync');

        expect(result.isSuccess, isTrue);
        final entity = result.valueOrNull!;
        expect(entity.syncMetadata.syncCreatedAt, 1000);
        expect(entity.syncMetadata.syncUpdatedAt, 2000);
        expect(entity.syncMetadata.syncDeviceId, 'test-device');
        expect(entity.syncMetadata.syncIsDirty, isTrue);
      });
    });

    group('enum mapping', () {
      test('biologicalSex_roundTripsCorrectly', () async {
        for (final sex in BiologicalSex.values) {
          final profile = createTestProfile(
            id: 'p-sex-${sex.value}',
            biologicalSex: sex,
          );
          await database.profileDao.create(profile);
          final result = await database.profileDao.getById(
            'p-sex-${sex.value}',
          );

          expect(result.isSuccess, isTrue);
          expect(result.valueOrNull?.biologicalSex, sex);
        }
      });

      test('profileDietType_roundTripsCorrectly', () async {
        for (final diet in ProfileDietType.values) {
          final profile = createTestProfile(
            id: 'p-diet-${diet.value}',
            dietType: diet,
          );
          await database.profileDao.create(profile);
          final result = await database.profileDao.getById(
            'p-diet-${diet.value}',
          );

          expect(result.isSuccess, isTrue);
          expect(result.valueOrNull?.dietType, diet);
        }
      });

      test('nullBiologicalSex_roundTripsAsNull', () async {
        final profile = createTestProfile(id: 'p-null-sex');
        await database.profileDao.create(profile);
        final result = await database.profileDao.getById('p-null-sex');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.biologicalSex, isNull);
      });
    });
  });
}
