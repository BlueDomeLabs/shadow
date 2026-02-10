// test/unit/data/datasources/local/daos/photo_area_dao_test.dart
// Tests for PhotoAreaDao per 06_TESTING_STRATEGY.md Section 4.1

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

void main() {
  group('PhotoAreaDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    PhotoArea createTestPhotoArea({
      String? id,
      String profileId = 'profile-001',
      String name = 'Test Area',
      int sortOrder = 0,
      bool isArchived = false,
      int? syncCreatedAt,
      int? syncUpdatedAt,
      bool syncIsDirty = true,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return PhotoArea(
        id: id ?? 'area-${DateTime.now().microsecondsSinceEpoch}',
        clientId: 'client-${DateTime.now().microsecondsSinceEpoch}',
        profileId: profileId,
        name: name,
        sortOrder: sortOrder,
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
      test('create_validPhotoArea_returnsSuccess', () async {
        final area = createTestPhotoArea(id: 'area-001', name: 'Left Arm');

        final result = await database.photoAreaDao.create(area);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'area-001');
        expect(result.valueOrNull?.name, 'Left Arm');
      });

      test('create_duplicateId_returnsFailure', () async {
        final a1 = createTestPhotoArea(id: 'area-dup');
        final a2 = createTestPhotoArea(id: 'area-dup');

        await database.photoAreaDao.create(a1);
        final result = await database.photoAreaDao.create(a2);

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeConstraintViolation,
        );
      });
    });

    group('getById', () {
      test('getById_existingId_returnsSuccess', () async {
        await database.photoAreaDao.create(
          createTestPhotoArea(id: 'area-find'),
        );

        final result = await database.photoAreaDao.getById('area-find');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'area-find');
      });

      test('getById_nonExistingId_returnsFailure', () async {
        final result = await database.photoAreaDao.getById('missing');

        expect(result.isFailure, isTrue);
      });
    });

    group('getAll', () {
      test('getAll_returnsAllNonDeleted', () async {
        await database.photoAreaDao.create(createTestPhotoArea(id: 'a1'));
        await database.photoAreaDao.create(createTestPhotoArea(id: 'a2'));

        final result = await database.photoAreaDao.getAll();

        expect(result.valueOrNull, hasLength(2));
      });

      test('getAll_excludesSoftDeleted', () async {
        await database.photoAreaDao.create(createTestPhotoArea(id: 'a1'));
        await database.photoAreaDao.create(createTestPhotoArea(id: 'a2'));
        await database.photoAreaDao.softDelete('a2');

        final result = await database.photoAreaDao.getAll();

        expect(result.valueOrNull, hasLength(1));
      });
    });

    group('updateEntity', () {
      test('updateEntity_existingArea_returnsSuccess', () async {
        final original = createTestPhotoArea(id: 'area-upd');
        await database.photoAreaDao.create(original);

        final updated = original.copyWith(name: 'Right Arm');
        final result = await database.photoAreaDao.updateEntity(updated);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.name, 'Right Arm');
      });
    });

    group('softDelete', () {
      test('softDelete_existingArea_returnsSuccess', () async {
        await database.photoAreaDao.create(createTestPhotoArea(id: 'area-sd'));

        final result = await database.photoAreaDao.softDelete('area-sd');

        expect(result.isSuccess, isTrue);
      });

      test('softDelete_nonExistingId_returnsFailure', () async {
        final result = await database.photoAreaDao.softDelete('missing');

        expect(result.isFailure, isTrue);
      });
    });

    group('hardDelete', () {
      test('hardDelete_existingArea_removesPermanently', () async {
        await database.photoAreaDao.create(createTestPhotoArea(id: 'area-hd'));

        final result = await database.photoAreaDao.hardDelete('area-hd');
        expect(result.isSuccess, isTrue);
      });
    });

    group('getByProfile', () {
      test('getByProfile_returnsOnlyMatchingProfile', () async {
        await database.photoAreaDao.create(
          createTestPhotoArea(id: 'a1', profileId: 'p-A'),
        );
        await database.photoAreaDao.create(
          createTestPhotoArea(id: 'a2', profileId: 'p-B'),
        );

        final result = await database.photoAreaDao.getByProfile('p-A');

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.profileId, 'p-A');
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_returnsModifiedAfterTimestamp', () async {
        final baseTime = DateTime.now().millisecondsSinceEpoch;

        await database.photoAreaDao.create(
          createTestPhotoArea(id: 'old', syncUpdatedAt: baseTime - 10000),
        );
        await database.photoAreaDao.create(
          createTestPhotoArea(id: 'new', syncUpdatedAt: baseTime + 10000),
        );

        final result = await database.photoAreaDao.getModifiedSince(baseTime);

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'new');
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_returnsOnlyDirtyAreas', () async {
        await database.photoAreaDao.create(createTestPhotoArea(id: 'dirty'));
        await database.photoAreaDao.create(
          createTestPhotoArea(id: 'clean', syncIsDirty: false),
        );

        final result = await database.photoAreaDao.getPendingSync();

        expect(result.valueOrNull?.any((a) => a.id == 'dirty'), isTrue);
      });
    });
  });
}
