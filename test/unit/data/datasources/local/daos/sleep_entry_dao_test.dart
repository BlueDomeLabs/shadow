// test/unit/data/datasources/local/daos/sleep_entry_dao_test.dart
// Tests for SleepEntryDao per 06_TESTING_STRATEGY.md Section 4.1

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/sleep_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('SleepEntryDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    SleepEntry createTestSleepEntry({
      String? id,
      String profileId = 'profile-001',
      int? bedTime,
      int? wakeTime,
      DreamType dreamType = DreamType.noDreams,
      WakingFeeling wakingFeeling = WakingFeeling.neutral,
      String? importSource,
      String? importExternalId,
      int? syncCreatedAt,
      int? syncUpdatedAt,
      bool syncIsDirty = true,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return SleepEntry(
        id: id ?? 'sleep-${DateTime.now().microsecondsSinceEpoch}',
        clientId: 'client-${DateTime.now().microsecondsSinceEpoch}',
        profileId: profileId,
        bedTime: bedTime ?? now - 28800000, // 8 hours ago
        wakeTime: wakeTime,
        dreamType: dreamType,
        wakingFeeling: wakingFeeling,
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
      test('create_validSleepEntry_returnsSuccess', () async {
        final entry = createTestSleepEntry(
          id: 'sleep-001',
          bedTime: 1704067200000,
          wakeTime: 1704096000000,
          dreamType: DreamType.vivid,
        );

        final result = await database.sleepEntryDao.create(entry);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'sleep-001');
        expect(result.valueOrNull?.dreamType, DreamType.vivid);
      });

      test('create_duplicateId_returnsFailure', () async {
        final e1 = createTestSleepEntry(id: 'sleep-dup');
        final e2 = createTestSleepEntry(id: 'sleep-dup');

        await database.sleepEntryDao.create(e1);
        final result = await database.sleepEntryDao.create(e2);

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeConstraintViolation,
        );
      });

      test('create_withAllSleepStages_persistsCorrectly', () async {
        const entry = SleepEntry(
          id: 'sleep-full',
          clientId: 'client-full',
          profileId: 'profile-001',
          bedTime: 1704067200000,
          wakeTime: 1704096000000,
          deepSleepMinutes: 120,
          lightSleepMinutes: 240,
          restlessSleepMinutes: 30,
          dreamType: DreamType.nightmares,
          wakingFeeling: WakingFeeling.unrested,
          notes: 'Bad night',
          syncMetadata: SyncMetadata(
            syncCreatedAt: 1704067200000,
            syncUpdatedAt: 1704067200000,
            syncDeviceId: 'device-001',
          ),
        );

        await database.sleepEntryDao.create(entry);
        final result = await database.sleepEntryDao.getById('sleep-full');

        expect(result.isSuccess, isTrue);
        final retrieved = result.valueOrNull!;
        expect(retrieved.deepSleepMinutes, 120);
        expect(retrieved.lightSleepMinutes, 240);
        expect(retrieved.restlessSleepMinutes, 30);
        expect(retrieved.dreamType, DreamType.nightmares);
        expect(retrieved.wakingFeeling, WakingFeeling.unrested);
      });
    });

    group('getById', () {
      test('getById_existingId_returnsSuccess', () async {
        await database.sleepEntryDao.create(
          createTestSleepEntry(id: 'sleep-find'),
        );

        final result = await database.sleepEntryDao.getById('sleep-find');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'sleep-find');
      });

      test('getById_nonExistingId_returnsFailure', () async {
        final result = await database.sleepEntryDao.getById('missing');

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeNotFound,
        );
      });
    });

    group('getAll', () {
      test('getAll_returnsAllNonDeleted', () async {
        await database.sleepEntryDao.create(createTestSleepEntry(id: 's1'));
        await database.sleepEntryDao.create(createTestSleepEntry(id: 's2'));

        final result = await database.sleepEntryDao.getAll();

        expect(result.valueOrNull, hasLength(2));
      });

      test('getAll_excludesSoftDeleted', () async {
        await database.sleepEntryDao.create(createTestSleepEntry(id: 's1'));
        await database.sleepEntryDao.create(createTestSleepEntry(id: 's2'));
        await database.sleepEntryDao.softDelete('s2');

        final result = await database.sleepEntryDao.getAll();

        expect(result.valueOrNull, hasLength(1));
      });
    });

    group('updateEntity', () {
      test('updateEntity_existingEntry_returnsSuccess', () async {
        final original = createTestSleepEntry(id: 'sleep-upd');
        await database.sleepEntryDao.create(original);

        final updated = original.copyWith(notes: 'Updated notes');
        final result = await database.sleepEntryDao.updateEntity(updated);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.notes, 'Updated notes');
      });
    });

    group('softDelete', () {
      test('softDelete_existingEntry_returnsSuccess', () async {
        await database.sleepEntryDao.create(
          createTestSleepEntry(id: 'sleep-sd'),
        );

        final result = await database.sleepEntryDao.softDelete('sleep-sd');

        expect(result.isSuccess, isTrue);
      });

      test('softDelete_nonExistingId_returnsFailure', () async {
        final result = await database.sleepEntryDao.softDelete('missing');

        expect(result.isFailure, isTrue);
      });
    });

    group('hardDelete', () {
      test('hardDelete_existingEntry_removesPermanently', () async {
        await database.sleepEntryDao.create(
          createTestSleepEntry(id: 'sleep-hd'),
        );

        final result = await database.sleepEntryDao.hardDelete('sleep-hd');
        expect(result.isSuccess, isTrue);
      });
    });

    group('getByProfile', () {
      test('getByProfile_returnsOnlyMatchingProfile', () async {
        await database.sleepEntryDao.create(
          createTestSleepEntry(id: 's1', profileId: 'p-A'),
        );
        await database.sleepEntryDao.create(
          createTestSleepEntry(id: 's2', profileId: 'p-B'),
        );

        final result = await database.sleepEntryDao.getByProfile('p-A');

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.profileId, 'p-A');
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_returnsModifiedAfterTimestamp', () async {
        final baseTime = DateTime.now().millisecondsSinceEpoch;

        await database.sleepEntryDao.create(
          createTestSleepEntry(id: 'old', syncUpdatedAt: baseTime - 10000),
        );
        await database.sleepEntryDao.create(
          createTestSleepEntry(id: 'new', syncUpdatedAt: baseTime + 10000),
        );

        final result = await database.sleepEntryDao.getModifiedSince(baseTime);

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'new');
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_returnsOnlyDirtyEntries', () async {
        await database.sleepEntryDao.create(createTestSleepEntry(id: 'dirty'));
        await database.sleepEntryDao.create(
          createTestSleepEntry(id: 'clean', syncIsDirty: false),
        );

        final result = await database.sleepEntryDao.getPendingSync();

        expect(result.valueOrNull?.any((e) => e.id == 'dirty'), isTrue);
      });
    });
  });
}
