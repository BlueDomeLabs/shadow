// test/unit/data/repositories/bodily_output_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/repositories/bodily_output_repository_impl.dart';
import 'package:shadow_app/domain/entities/bodily_output_enums.dart';
import 'package:shadow_app/domain/entities/bodily_output_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:uuid/uuid.dart';

/// Integration-style test: uses a real in-memory database.
void main() {
  group('BodilyOutputRepositoryImpl', () {
    late AppDatabase database;
    late BodilyOutputRepositoryImpl repository;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
      repository = BodilyOutputRepositoryImpl(
        database.bodilyOutputDao,
        const Uuid(),
      );
    });

    tearDown(() async {
      await database.close();
    });

    const baseSync = SyncMetadata(
      syncCreatedAt: 1700000000000,
      syncUpdatedAt: 1700000000000,
      syncDeviceId: 'device-001',
    );

    BodilyOutputLog makeLog({
      String id = 'log-001',
      String profileId = 'profile-001',
      BodyOutputType outputType = BodyOutputType.urine,
    }) => BodilyOutputLog(
      id: id,
      clientId: 'client-001',
      profileId: profileId,
      occurredAt: 1700000000000,
      outputType: outputType,
      syncMetadata: baseSync,
    );

    group('log', () {
      test('log_validEntry_returnsSuccess', () async {
        final result = await repository.log(makeLog());
        expect(result.isSuccess, isTrue);
      });

      test('log_emptyId_assignsNewId', () async {
        const entry = BodilyOutputLog(
          id: '',
          clientId: 'c',
          profileId: 'p1',
          occurredAt: 1700000000000,
          outputType: BodyOutputType.bowel,
          syncMetadata: baseSync,
        );
        final result = await repository.log(entry);
        expect(result.isSuccess, isTrue);
      });

      test('log_entry_isRetrievableViaGetById', () async {
        await repository.log(makeLog());
        final result = await repository.getById('log-001');
        expect(result.isSuccess, isTrue);
        result.when(
          success: (log) => expect(log.id, 'log-001'),
          failure: (_) => fail('Expected success'),
        );
      });
    });

    group('getAll', () {
      test('getAll_emptyDatabase_returnsEmptyList', () async {
        final result = await repository.getAll('profile-001');
        result.when(
          success: (list) => expect(list, isEmpty),
          failure: (_) => fail('Expected success'),
        );
      });

      test('getAll_filtersByProfile', () async {
        await repository.log(makeLog(id: 'l1', profileId: 'p1'));
        await repository.log(makeLog(id: 'l2', profileId: 'p2'));
        final result = await repository.getAll('p1');
        result.when(
          success: (list) {
            expect(list.length, 1);
            expect(list.first.profileId, 'p1');
          },
          failure: (_) => fail('Expected success'),
        );
      });

      test('getAll_filtersByType', () async {
        await repository.log(makeLog(id: 'u1'));
        await repository.log(
          makeLog(id: 'b1', outputType: BodyOutputType.bowel),
        );
        final result = await repository.getAll(
          'profile-001',
          type: BodyOutputType.urine,
        );
        result.when(
          success: (list) {
            expect(list.length, 1);
            expect(list.first.outputType, BodyOutputType.urine);
          },
          failure: (_) => fail('Expected success'),
        );
      });
    });

    group('getById', () {
      test('getById_missingId_returnsFailure', () async {
        final result = await repository.getById('missing');
        expect(result.isFailure, isTrue);
      });

      test('getById_softDeleted_returnsFailure', () async {
        await repository.log(makeLog());
        await repository.delete('profile-001', 'log-001');
        final result = await repository.getById('log-001');
        expect(result.isFailure, isTrue);
      });
    });

    group('update', () {
      test('update_existingEntry_updatesNotes', () async {
        await repository.log(makeLog());
        final updated = makeLog().copyWith(notes: 'new note');
        await repository.update(updated);
        final result = await repository.getById('log-001');
        result.when(
          success: (log) => expect(log.notes, 'new note'),
          failure: (_) => fail('Expected success'),
        );
      });
    });

    group('delete', () {
      test('delete_existingEntry_marksAsDeleted', () async {
        await repository.log(makeLog());
        final result = await repository.delete('profile-001', 'log-001');
        expect(result.isSuccess, isTrue);
        final getResult = await repository.getById('log-001');
        expect(getResult.isFailure, isTrue);
      });

      test('delete_wrongProfileId_returnsFailure', () async {
        await repository.log(makeLog(profileId: 'p1'));
        final result = await repository.delete('p2', 'log-001');
        expect(result.isFailure, isTrue);
      });

      test('delete_missingEntry_returnsFailure', () async {
        final result = await repository.delete('profile-001', 'missing');
        expect(result.isFailure, isTrue);
      });
    });
  });
}
