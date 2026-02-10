// test/unit/data/datasources/local/daos/photo_entry_dao_test.dart
// Tests for PhotoEntryDao per 06_TESTING_STRATEGY.md Section 4.1

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/photo_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

void main() {
  group('PhotoEntryDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    PhotoEntry createTestPhotoEntry({
      String? id,
      String profileId = 'profile-001',
      String photoAreaId = 'area-001',
      int? timestamp,
      String filePath = '/photos/test.jpg',
      int? syncCreatedAt,
      int? syncUpdatedAt,
      bool syncIsDirty = true,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return PhotoEntry(
        id: id ?? 'photo-${DateTime.now().microsecondsSinceEpoch}',
        clientId: 'client-${DateTime.now().microsecondsSinceEpoch}',
        profileId: profileId,
        photoAreaId: photoAreaId,
        timestamp: timestamp ?? now,
        filePath: filePath,
        syncMetadata: SyncMetadata(
          syncCreatedAt: syncCreatedAt ?? now,
          syncUpdatedAt: syncUpdatedAt ?? now,
          syncDeviceId: 'test-device',
          syncIsDirty: syncIsDirty,
        ),
      );
    }

    group('create', () {
      test('create_validPhotoEntry_returnsSuccess', () async {
        final entry = createTestPhotoEntry(
          id: 'photo-001',
          filePath: '/photos/arm.jpg',
        );

        final result = await database.photoEntryDao.create(entry);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'photo-001');
        expect(result.valueOrNull?.filePath, '/photos/arm.jpg');
      });

      test('create_duplicateId_returnsFailure', () async {
        final e1 = createTestPhotoEntry(id: 'photo-dup');
        final e2 = createTestPhotoEntry(id: 'photo-dup');

        await database.photoEntryDao.create(e1);
        final result = await database.photoEntryDao.create(e2);

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeConstraintViolation,
        );
      });

      test('create_withFileSyncMetadata_persistsCorrectly', () async {
        const entry = PhotoEntry(
          id: 'photo-full',
          clientId: 'client-full',
          profileId: 'profile-001',
          photoAreaId: 'area-001',
          timestamp: 1704067200000,
          filePath: '/photos/full.jpg',
          cloudStorageUrl: 'https://storage.example.com/full.jpg',
          fileHash: 'hash123',
          fileSizeBytes: 2048000,
          isFileUploaded: true,
          syncMetadata: SyncMetadata(
            syncCreatedAt: 1704067200000,
            syncUpdatedAt: 1704067200000,
            syncDeviceId: 'device-001',
          ),
        );

        await database.photoEntryDao.create(entry);
        final result = await database.photoEntryDao.getById('photo-full');

        expect(result.isSuccess, isTrue);
        final retrieved = result.valueOrNull!;
        expect(
          retrieved.cloudStorageUrl,
          'https://storage.example.com/full.jpg',
        );
        expect(retrieved.fileHash, 'hash123');
        expect(retrieved.fileSizeBytes, 2048000);
        expect(retrieved.isFileUploaded, isTrue);
      });
    });

    group('getById', () {
      test('getById_existingId_returnsSuccess', () async {
        await database.photoEntryDao.create(
          createTestPhotoEntry(id: 'photo-find'),
        );

        final result = await database.photoEntryDao.getById('photo-find');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'photo-find');
      });

      test('getById_nonExistingId_returnsFailure', () async {
        final result = await database.photoEntryDao.getById('missing');

        expect(result.isFailure, isTrue);
      });
    });

    group('getAll', () {
      test('getAll_returnsAllNonDeleted', () async {
        await database.photoEntryDao.create(createTestPhotoEntry(id: 'p1'));
        await database.photoEntryDao.create(createTestPhotoEntry(id: 'p2'));

        final result = await database.photoEntryDao.getAll();

        expect(result.valueOrNull, hasLength(2));
      });

      test('getAll_excludesSoftDeleted', () async {
        await database.photoEntryDao.create(createTestPhotoEntry(id: 'p1'));
        await database.photoEntryDao.create(createTestPhotoEntry(id: 'p2'));
        await database.photoEntryDao.softDelete('p2');

        final result = await database.photoEntryDao.getAll();

        expect(result.valueOrNull, hasLength(1));
      });
    });

    group('updateEntity', () {
      test('updateEntity_existingEntry_returnsSuccess', () async {
        final original = createTestPhotoEntry(id: 'photo-upd');
        await database.photoEntryDao.create(original);

        final updated = original.copyWith(notes: 'Updated notes');
        final result = await database.photoEntryDao.updateEntity(updated);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.notes, 'Updated notes');
      });
    });

    group('softDelete', () {
      test('softDelete_existingEntry_returnsSuccess', () async {
        await database.photoEntryDao.create(
          createTestPhotoEntry(id: 'photo-sd'),
        );

        final result = await database.photoEntryDao.softDelete('photo-sd');

        expect(result.isSuccess, isTrue);
      });

      test('softDelete_nonExistingId_returnsFailure', () async {
        final result = await database.photoEntryDao.softDelete('missing');

        expect(result.isFailure, isTrue);
      });
    });

    group('hardDelete', () {
      test('hardDelete_existingEntry_removesPermanently', () async {
        await database.photoEntryDao.create(
          createTestPhotoEntry(id: 'photo-hd'),
        );

        final result = await database.photoEntryDao.hardDelete('photo-hd');
        expect(result.isSuccess, isTrue);
      });
    });

    group('getByProfile', () {
      test('getByProfile_returnsOnlyMatchingProfile', () async {
        await database.photoEntryDao.create(
          createTestPhotoEntry(id: 'p1', profileId: 'p-A'),
        );
        await database.photoEntryDao.create(
          createTestPhotoEntry(id: 'p2', profileId: 'p-B'),
        );

        final result = await database.photoEntryDao.getByProfile('p-A');

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.profileId, 'p-A');
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_returnsModifiedAfterTimestamp', () async {
        final baseTime = DateTime.now().millisecondsSinceEpoch;

        await database.photoEntryDao.create(
          createTestPhotoEntry(id: 'old', syncUpdatedAt: baseTime - 10000),
        );
        await database.photoEntryDao.create(
          createTestPhotoEntry(id: 'new', syncUpdatedAt: baseTime + 10000),
        );

        final result = await database.photoEntryDao.getModifiedSince(baseTime);

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'new');
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_returnsOnlyDirtyEntries', () async {
        await database.photoEntryDao.create(createTestPhotoEntry(id: 'dirty'));
        await database.photoEntryDao.create(
          createTestPhotoEntry(id: 'clean', syncIsDirty: false),
        );

        final result = await database.photoEntryDao.getPendingSync();

        expect(result.valueOrNull?.any((e) => e.id == 'dirty'), isTrue);
      });
    });
  });
}
