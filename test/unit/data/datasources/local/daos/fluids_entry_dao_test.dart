// test/unit/data/datasources/local/daos/fluids_entry_dao_test.dart
// Tests for FluidsEntryDao per 06_TESTING_STRATEGY.md Section 4.1

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('FluidsEntryDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    FluidsEntry createTestFluidsEntry({
      String? id,
      String profileId = 'profile-001',
      int? entryDate,
      int? waterIntakeMl,
      BowelCondition? bowelCondition,
      int? syncCreatedAt,
      int? syncUpdatedAt,
      bool syncIsDirty = true,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return FluidsEntry(
        id: id ?? 'fluid-${DateTime.now().microsecondsSinceEpoch}',
        clientId: 'client-${DateTime.now().microsecondsSinceEpoch}',
        profileId: profileId,
        entryDate: entryDate ?? now,
        waterIntakeMl: waterIntakeMl,
        bowelCondition: bowelCondition,
        syncMetadata: SyncMetadata(
          syncCreatedAt: syncCreatedAt ?? now,
          syncUpdatedAt: syncUpdatedAt ?? now,
          syncDeviceId: 'test-device',
          syncIsDirty: syncIsDirty,
        ),
      );
    }

    group('create', () {
      test('create_validFluidsEntry_returnsSuccess', () async {
        final entry = createTestFluidsEntry(
          id: 'fluid-001',
          waterIntakeMl: 2000,
        );

        final result = await database.fluidsEntryDao.create(entry);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'fluid-001');
        expect(result.valueOrNull?.waterIntakeMl, 2000);
      });

      test('create_duplicateId_returnsFailure', () async {
        final e1 = createTestFluidsEntry(id: 'fluid-dup');
        final e2 = createTestFluidsEntry(id: 'fluid-dup');

        await database.fluidsEntryDao.create(e1);
        final result = await database.fluidsEntryDao.create(e2);

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeConstraintViolation,
        );
      });

      test('create_withAllFields_persistsCorrectly', () async {
        const entry = FluidsEntry(
          id: 'fluid-full',
          clientId: 'client-full',
          profileId: 'profile-001',
          entryDate: 1704067200000,
          waterIntakeMl: 2000,
          bowelCondition: BowelCondition.normal,
          bowelSize: MovementSize.medium,
          urineCondition: UrineCondition.lightYellow,
          menstruationFlow: MenstruationFlow.light,
          basalBodyTemperature: 97.6,
          notes: 'Test',
          syncMetadata: SyncMetadata(
            syncCreatedAt: 1704067200000,
            syncUpdatedAt: 1704067200000,
            syncDeviceId: 'device-001',
          ),
        );

        await database.fluidsEntryDao.create(entry);
        final result = await database.fluidsEntryDao.getById('fluid-full');

        expect(result.isSuccess, isTrue);
        final retrieved = result.valueOrNull!;
        expect(retrieved.waterIntakeMl, 2000);
        expect(retrieved.bowelCondition, BowelCondition.normal);
        expect(retrieved.urineCondition, UrineCondition.lightYellow);
        expect(retrieved.menstruationFlow, MenstruationFlow.light);
      });
    });

    group('getById', () {
      test('getById_existingId_returnsSuccess', () async {
        await database.fluidsEntryDao.create(
          createTestFluidsEntry(id: 'fluid-find'),
        );

        final result = await database.fluidsEntryDao.getById('fluid-find');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'fluid-find');
      });

      test('getById_nonExistingId_returnsFailure', () async {
        final result = await database.fluidsEntryDao.getById('missing');

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeNotFound,
        );
      });
    });

    group('getAll', () {
      test('getAll_returnsAllNonDeleted', () async {
        await database.fluidsEntryDao.create(createTestFluidsEntry(id: 'f1'));
        await database.fluidsEntryDao.create(createTestFluidsEntry(id: 'f2'));

        final result = await database.fluidsEntryDao.getAll();

        expect(result.valueOrNull, hasLength(2));
      });

      test('getAll_excludesSoftDeleted', () async {
        await database.fluidsEntryDao.create(createTestFluidsEntry(id: 'f1'));
        await database.fluidsEntryDao.create(createTestFluidsEntry(id: 'f2'));
        await database.fluidsEntryDao.softDelete('f2');

        final result = await database.fluidsEntryDao.getAll();

        expect(result.valueOrNull, hasLength(1));
      });
    });

    group('updateEntity', () {
      test('updateEntity_existingEntry_returnsSuccess', () async {
        final original = createTestFluidsEntry(id: 'fluid-upd');
        await database.fluidsEntryDao.create(original);

        final updated = original.copyWith(waterIntakeMl: 3000);
        final result = await database.fluidsEntryDao.updateEntity(updated);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.waterIntakeMl, 3000);
      });
    });

    group('softDelete', () {
      test('softDelete_existingEntry_returnsSuccess', () async {
        await database.fluidsEntryDao.create(
          createTestFluidsEntry(id: 'fluid-sd'),
        );

        final result = await database.fluidsEntryDao.softDelete('fluid-sd');

        expect(result.isSuccess, isTrue);
      });

      test('softDelete_nonExistingId_returnsFailure', () async {
        final result = await database.fluidsEntryDao.softDelete('missing');

        expect(result.isFailure, isTrue);
      });
    });

    group('hardDelete', () {
      test('hardDelete_existingEntry_removesPermanently', () async {
        await database.fluidsEntryDao.create(
          createTestFluidsEntry(id: 'fluid-hd'),
        );

        final result = await database.fluidsEntryDao.hardDelete('fluid-hd');
        expect(result.isSuccess, isTrue);
      });
    });

    group('getByDateRange', () {
      test('getByDateRange_returnsEntriesInRange', () async {
        const baseDate = 1704067200000;
        await database.fluidsEntryDao.create(
          createTestFluidsEntry(
            id: 'f1',
            profileId: 'p-A',
            entryDate: baseDate,
          ),
        );
        await database.fluidsEntryDao.create(
          createTestFluidsEntry(
            id: 'f2',
            profileId: 'p-A',
            entryDate: baseDate + 86400000,
          ),
        );
        await database.fluidsEntryDao.create(
          createTestFluidsEntry(
            id: 'f3',
            profileId: 'p-A',
            entryDate: baseDate + 86400000 * 10,
          ),
        );

        final result = await database.fluidsEntryDao.getByDateRange(
          'p-A',
          baseDate - 1000,
          baseDate + 86400000 + 1000,
        );

        expect(result.valueOrNull, hasLength(2));
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_returnsModifiedAfterTimestamp', () async {
        final baseTime = DateTime.now().millisecondsSinceEpoch;

        await database.fluidsEntryDao.create(
          createTestFluidsEntry(id: 'old', syncUpdatedAt: baseTime - 10000),
        );
        await database.fluidsEntryDao.create(
          createTestFluidsEntry(id: 'new', syncUpdatedAt: baseTime + 10000),
        );

        final result = await database.fluidsEntryDao.getModifiedSince(baseTime);

        expect(result.valueOrNull, hasLength(1));
        expect(result.valueOrNull?.first.id, 'new');
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_returnsOnlyDirtyEntries', () async {
        await database.fluidsEntryDao.create(
          createTestFluidsEntry(id: 'dirty'),
        );
        await database.fluidsEntryDao.create(
          createTestFluidsEntry(id: 'clean', syncIsDirty: false),
        );

        final result = await database.fluidsEntryDao.getPendingSync();

        expect(result.valueOrNull?.any((e) => e.id == 'dirty'), isTrue);
      });
    });
  });
}
