// test/unit/data/datasources/local/daos/journal_entry_dao_test.dart
// Tests for JournalEntryDao per 06_TESTING_STRATEGY.md Section 4.1

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

void main() {
  group('JournalEntryDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    JournalEntry createTestJournalEntry({
      String? id,
      String profileId = 'profile-001',
      int? timestamp,
      String content = 'Test journal content',
      String? title,
      int? mood,
      List<String>? tags,
      int? syncCreatedAt,
      int? syncUpdatedAt,
      bool syncIsDirty = true,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return JournalEntry(
        id: id ?? 'journal-${DateTime.now().microsecondsSinceEpoch}',
        clientId: 'client-${DateTime.now().microsecondsSinceEpoch}',
        profileId: profileId,
        timestamp: timestamp ?? now,
        content: content,
        title: title,
        mood: mood,
        tags: tags,
        syncMetadata: SyncMetadata(
          syncCreatedAt: syncCreatedAt ?? now,
          syncUpdatedAt: syncUpdatedAt ?? now,
          syncDeviceId: 'test-device',
          syncIsDirty: syncIsDirty,
        ),
      );
    }

    group('create', () {
      test('create_validJournalEntry_returnsSuccess', () async {
        final entry = createTestJournalEntry(
          id: 'journal-001',
          content: 'Test entry',
          mood: 7,
          tags: ['health', 'positive'],
        );

        final result = await database.journalEntryDao.create(entry);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'journal-001');
        expect(result.valueOrNull?.content, 'Test entry');
        expect(result.valueOrNull?.mood, 7);
        expect(result.valueOrNull?.tags, ['health', 'positive']);
      });

      test('create_duplicateId_returnsFailure', () async {
        final e1 = createTestJournalEntry(id: 'journal-dup');
        final e2 = createTestJournalEntry(id: 'journal-dup');

        await database.journalEntryDao.create(e1);
        final result = await database.journalEntryDao.create(e2);

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeConstraintViolation,
        );
      });
    });

    group('getById', () {
      test('getById_existingId_returnsSuccess', () async {
        await database.journalEntryDao.create(
          createTestJournalEntry(id: 'journal-find'),
        );

        final result = await database.journalEntryDao.getById('journal-find');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'journal-find');
      });

      test('getById_nonExistingId_returnsFailure', () async {
        final result = await database.journalEntryDao.getById('missing');

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeNotFound,
        );
      });
    });

    group('getAll', () {
      test('getAll_returnsAllNonDeleted', () async {
        await database.journalEntryDao.create(createTestJournalEntry(id: 'j1'));
        await database.journalEntryDao.create(createTestJournalEntry(id: 'j2'));

        final result = await database.journalEntryDao.getAll();

        expect(result.valueOrNull, hasLength(2));
      });

      test('getAll_excludesSoftDeleted', () async {
        await database.journalEntryDao.create(createTestJournalEntry(id: 'j1'));
        await database.journalEntryDao.create(createTestJournalEntry(id: 'j2'));
        await database.journalEntryDao.softDelete('j2');

        final result = await database.journalEntryDao.getAll();

        expect(result.valueOrNull, hasLength(1));
      });
    });

    group('updateEntity', () {
      test('updateEntity_existingEntry_returnsSuccess', () async {
        final original = createTestJournalEntry(id: 'journal-upd');
        await database.journalEntryDao.create(original);

        final updated = original.copyWith(content: 'Updated content');
        final result = await database.journalEntryDao.updateEntity(updated);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.content, 'Updated content');
      });
    });

    group('softDelete', () {
      test('softDelete_existingEntry_returnsSuccess', () async {
        await database.journalEntryDao.create(
          createTestJournalEntry(id: 'journal-sd'),
        );

        final result = await database.journalEntryDao.softDelete('journal-sd');

        expect(result.isSuccess, isTrue);
      });

      test('softDelete_nonExistingId_returnsFailure', () async {
        final result = await database.journalEntryDao.softDelete('missing');

        expect(result.isFailure, isTrue);
      });
    });

    group('hardDelete', () {
      test('hardDelete_existingEntry_removesPermanently', () async {
        await database.journalEntryDao.create(
          createTestJournalEntry(id: 'journal-hd'),
        );

        final result = await database.journalEntryDao.hardDelete('journal-hd');
        expect(result.isSuccess, isTrue);
      });
    });

    group('getByProfile', () {
      test('getByProfile_returnsOnlyMatchingProfile', () async {
        await database.journalEntryDao.create(
          createTestJournalEntry(id: 'j1', profileId: 'p-A'),
        );
        await database.journalEntryDao.create(
          createTestJournalEntry(id: 'j2', profileId: 'p-B'),
        );

        final result = await database.journalEntryDao.getByProfile('p-A');

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.profileId, 'p-A');
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_returnsModifiedAfterTimestamp', () async {
        final baseTime = DateTime.now().millisecondsSinceEpoch;

        await database.journalEntryDao.create(
          createTestJournalEntry(id: 'old', syncUpdatedAt: baseTime - 10000),
        );
        await database.journalEntryDao.create(
          createTestJournalEntry(id: 'new', syncUpdatedAt: baseTime + 10000),
        );

        final result = await database.journalEntryDao.getModifiedSince(
          baseTime,
        );

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'new');
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_returnsOnlyDirtyEntries', () async {
        await database.journalEntryDao.create(
          createTestJournalEntry(id: 'dirty'),
        );
        await database.journalEntryDao.create(
          createTestJournalEntry(id: 'clean', syncIsDirty: false),
        );

        final result = await database.journalEntryDao.getPendingSync();

        expect(result.valueOrNull?.any((e) => e.id == 'dirty'), isTrue);
      });
    });
  });
}
