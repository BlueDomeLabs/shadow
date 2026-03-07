// test/unit/data/datasources/local/daos/bodily_output_dao_test.dart

import 'package:drift/drift.dart' hide DatabaseConnection, isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/datasources/local/database.dart';

void main() {
  group('BodilyOutputDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    const now = 1700000000000;

    BodilyOutputLogsCompanion makeCompanion({
      String id = 'log-001',
      String profileId = 'profile-001',
      int outputType = 0, // urine
    }) => BodilyOutputLogsCompanion(
      id: Value(id),
      clientId: const Value('client-001'),
      profileId: Value(profileId),
      occurredAt: const Value(now),
      outputType: Value(outputType),
      syncCreatedAt: const Value(now),
    );

    group('insert', () {
      test('insert_validCompanion_rowIsRetrievable', () async {
        await database.bodilyOutputDao.insert(makeCompanion());
        final row = await database.bodilyOutputDao.getById('log-001');
        expect(row, isNotNull);
        expect(row!.id, 'log-001');
        expect(row.outputType, 0);
      });

      test('insert_bowelRow_correctOutputType', () async {
        await database.bodilyOutputDao.insert(
          makeCompanion(id: 'log-002', outputType: 1),
        );
        final row = await database.bodilyOutputDao.getById('log-002');
        expect(row!.outputType, 1);
      });

      test('insert_multipleRows_allRetrievable', () async {
        for (var i = 0; i < 3; i++) {
          await database.bodilyOutputDao.insert(makeCompanion(id: 'log-$i'));
        }
        final rows = await database.bodilyOutputDao.getAll('profile-001');
        expect(rows.length, 3);
      });
    });

    group('getAll', () {
      test('getAll_emptyDatabase_returnsEmptyList', () async {
        final rows = await database.bodilyOutputDao.getAll('profile-001');
        expect(rows, isEmpty);
      });

      test('getAll_filtersByProfile', () async {
        await database.bodilyOutputDao.insert(makeCompanion(id: 'p1'));
        await database.bodilyOutputDao.insert(
          makeCompanion(id: 'p2', profileId: 'profile-002'),
        );
        final rows = await database.bodilyOutputDao.getAll('profile-001');
        expect(rows.length, 1);
        expect(rows.first.profileId, 'profile-001');
      });

      test('getAll_filtersByOutputType', () async {
        await database.bodilyOutputDao.insert(makeCompanion(id: 'u1'));
        await database.bodilyOutputDao.insert(
          makeCompanion(id: 'b1', outputType: 1),
        );
        final urineRows = await database.bodilyOutputDao.getAll(
          'profile-001',
          outputType: 0,
        );
        expect(urineRows.length, 1);
        expect(urineRows.first.outputType, 0);
      });

      test('getAll_filtersByDateRange', () async {
        await database.bodilyOutputDao.insert(
          const BodilyOutputLogsCompanion(
            id: Value('past'),
            clientId: Value('c'),
            profileId: Value('profile-001'),
            occurredAt: Value(now - 10000),
            outputType: Value(0),
            syncCreatedAt: Value(now),
          ),
        );
        await database.bodilyOutputDao.insert(
          const BodilyOutputLogsCompanion(
            id: Value('future'),
            clientId: Value('c'),
            profileId: Value('profile-001'),
            occurredAt: Value(now + 10000),
            outputType: Value(0),
            syncCreatedAt: Value(now),
          ),
        );
        final rows = await database.bodilyOutputDao.getAll(
          'profile-001',
          from: now - 5000,
          to: now + 5000,
        );
        expect(rows, isEmpty);
      });

      test('getAll_excludesSoftDeleted', () async {
        await database.bodilyOutputDao.insert(makeCompanion());
        await database.bodilyOutputDao.softDelete('log-001', now);
        final rows = await database.bodilyOutputDao.getAll('profile-001');
        expect(rows, isEmpty);
      });

      test('getAll_orderedByOccurredAtDescending', () async {
        await database.bodilyOutputDao.insert(
          const BodilyOutputLogsCompanion(
            id: Value('older'),
            clientId: Value('c'),
            profileId: Value('profile-001'),
            occurredAt: Value(now - 1000),
            outputType: Value(0),
            syncCreatedAt: Value(now),
          ),
        );
        await database.bodilyOutputDao.insert(
          const BodilyOutputLogsCompanion(
            id: Value('newer'),
            clientId: Value('c'),
            profileId: Value('profile-001'),
            occurredAt: Value(now),
            outputType: Value(0),
            syncCreatedAt: Value(now),
          ),
        );
        final rows = await database.bodilyOutputDao.getAll('profile-001');
        expect(rows.first.id, 'newer');
      });
    });

    group('getById', () {
      test('getById_existingId_returnsRow', () async {
        await database.bodilyOutputDao.insert(makeCompanion());
        final row = await database.bodilyOutputDao.getById('log-001');
        expect(row, isNotNull);
      });

      test('getById_missingId_returnsNull', () async {
        final row = await database.bodilyOutputDao.getById('missing');
        expect(row, isNull);
      });

      test('getById_softDeleted_returnsNull', () async {
        await database.bodilyOutputDao.insert(makeCompanion());
        await database.bodilyOutputDao.softDelete('log-001', now);
        final row = await database.bodilyOutputDao.getById('log-001');
        expect(row, isNull);
      });
    });

    group('updateEntry', () {
      test('updateEntry_validRow_updatesNotes', () async {
        await database.bodilyOutputDao.insert(makeCompanion());
        await database.bodilyOutputDao.updateEntry(
          const BodilyOutputLogsCompanion(
            id: Value('log-001'),
            notes: Value('updated'),
          ),
        );
        final row = await database.bodilyOutputDao.getById('log-001');
        expect(row!.notes, 'updated');
      });
    });

    group('softDelete', () {
      test('softDelete_existingRow_setsSyncDeletedAt', () async {
        await database.bodilyOutputDao.insert(makeCompanion());
        await database.bodilyOutputDao.softDelete('log-001', now + 1000);
        // After soft-delete, getById returns null (excludes deleted)
        final row = await database.bodilyOutputDao.getById('log-001');
        expect(row, isNull);
      });
    });

    group('getDirtyRecords', () {
      test('getDirtyRecords_dirtyRow_included', () async {
        await database.bodilyOutputDao.insert(
          const BodilyOutputLogsCompanion(
            id: Value('dirty'),
            clientId: Value('c'),
            profileId: Value('profile-001'),
            occurredAt: Value(now),
            outputType: Value(0),
            syncCreatedAt: Value(now),
            syncIsDirty: Value(true),
          ),
        );
        final rows = await database.bodilyOutputDao.getDirtyRecords(
          'profile-001',
        );
        expect(rows.length, 1);
        expect(rows.first.id, 'dirty');
      });

      test('getDirtyRecords_cleanRow_excluded', () async {
        await database.bodilyOutputDao.insert(
          const BodilyOutputLogsCompanion(
            id: Value('clean'),
            clientId: Value('c'),
            profileId: Value('profile-001'),
            occurredAt: Value(now),
            outputType: Value(0),
            syncCreatedAt: Value(now),
            syncIsDirty: Value(false),
          ),
        );
        final rows = await database.bodilyOutputDao.getDirtyRecords(
          'profile-001',
        );
        expect(rows, isEmpty);
      });
    });
  });
}
