// test/unit/data/repositories/journal_entry_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/journal_entry_dao.dart';
import 'package:shadow_app/data/repositories/journal_entry_repository_impl.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:uuid/uuid.dart';

@GenerateMocks([JournalEntryDao, DeviceInfoService])
import 'journal_entry_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<JournalEntry>, AppError>>(const Success([]));
  provideDummy<Result<JournalEntry, AppError>>(
    const Success(
      JournalEntry(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        timestamp: 0,
        content: 'dummy',
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));
  provideDummy<Result<Map<int, int>, AppError>>(const Success({}));

  group('JournalEntryRepositoryImpl', () {
    late MockJournalEntryDao mockDao;
    late MockDeviceInfoService mockDeviceInfoService;
    late Uuid uuid;
    late JournalEntryRepositoryImpl repository;

    const testDeviceId = 'test-device-123';
    const testProfileId = 'profile-001';

    JournalEntry createTestJournalEntry({
      String id = 'journal-001',
      String clientId = 'client-001',
      String profileId = testProfileId,
      int timestamp = 1704067200000,
      String content = 'Test content',
      SyncMetadata? syncMetadata,
    }) => JournalEntry(
      id: id,
      clientId: clientId,
      profileId: profileId,
      timestamp: timestamp,
      content: content,
      syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'old-device'),
    );

    setUp(() {
      mockDao = MockJournalEntryDao();
      mockDeviceInfoService = MockDeviceInfoService();
      uuid = const Uuid();
      repository = JournalEntryRepositoryImpl(
        mockDao,
        uuid,
        mockDeviceInfoService,
      );

      when(
        mockDeviceInfoService.getDeviceId(),
      ).thenAnswer((_) async => testDeviceId);
    });

    group('getAll', () {
      test('getAll_delegatesToDao', () async {
        final entries = [createTestJournalEntry()];
        when(mockDao.getAll()).thenAnswer((_) async => Success(entries));

        final result = await repository.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entries);
        verify(mockDao.getAll()).called(1);
      });

      test('getAll_passesParametersToDao', () async {
        when(
          mockDao.getAll(profileId: testProfileId, limit: 10, offset: 5),
        ).thenAnswer((_) async => const Success([]));

        await repository.getAll(profileId: testProfileId, limit: 10, offset: 5);

        verify(
          mockDao.getAll(profileId: testProfileId, limit: 10, offset: 5),
        ).called(1);
      });
    });

    group('getById', () {
      test('getById_delegatesToDao', () async {
        final entry = createTestJournalEntry();
        when(
          mockDao.getById('journal-001'),
        ).thenAnswer((_) async => Success(entry));

        final result = await repository.getById('journal-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entry);
        verify(mockDao.getById('journal-001')).called(1);
      });

      test('getById_returnsFailureWhenNotFound', () async {
        when(mockDao.getById('non-existent')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('JournalEntry', 'non-existent')),
        );

        final result = await repository.getById('non-existent');

        expect(result.isFailure, isTrue);
      });
    });

    group('create', () {
      test('create_generatesIdWhenEmpty', () async {
        final entry = createTestJournalEntry(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as JournalEntry;
          return Success(created);
        });

        final result = await repository.create(entry);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.id, isNotEmpty);
        expect(created.id.length, 36);
      });

      test('create_usesExistingIdWhenProvided', () async {
        final entry = createTestJournalEntry(id: 'my-custom-id');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as JournalEntry;
          return Success(created);
        });

        final result = await repository.create(entry);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, 'my-custom-id');
      });

      test('create_setsSyncMetadataWithDeviceId', () async {
        final entry = createTestJournalEntry(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as JournalEntry;
          return Success(created);
        });

        final result = await repository.create(entry);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.syncMetadata.syncDeviceId, testDeviceId);
        expect(created.syncMetadata.syncStatus, SyncStatus.pending);
        expect(created.syncMetadata.syncVersion, 1);
        expect(created.syncMetadata.syncIsDirty, isTrue);
      });
    });

    group('update', () {
      test('update_marksDirtyByDefault', () async {
        final entry = createTestJournalEntry(
          syncMetadata: const SyncMetadata(
            syncCreatedAt: 1000,
            syncUpdatedAt: 1000,
            syncDeviceId: 'old-device',
            syncStatus: SyncStatus.synced,
          ),
        );
        when(mockDao.updateEntity(any)).thenAnswer((invocation) async {
          final updated = invocation.positionalArguments[0] as JournalEntry;
          return Success(updated);
        });

        final result = await repository.update(entry);

        expect(result.isSuccess, isTrue);
        final updated = result.valueOrNull!;
        expect(updated.syncMetadata.syncStatus, SyncStatus.modified);
        expect(updated.syncMetadata.syncVersion, 2);
        expect(updated.syncMetadata.syncIsDirty, isTrue);
        expect(updated.syncMetadata.syncDeviceId, testDeviceId);
      });

      test('update_preservesEntityWhenMarkDirtyFalse', () async {
        const originalMetadata = SyncMetadata(
          syncCreatedAt: 1000,
          syncUpdatedAt: 1000,
          syncDeviceId: 'old-device',
          syncStatus: SyncStatus.synced,
          syncVersion: 5,
          syncIsDirty: false,
        );
        final entry = createTestJournalEntry(syncMetadata: originalMetadata);
        when(mockDao.updateEntity(any, markDirty: false)).thenAnswer((
          invocation,
        ) async {
          final updated = invocation.positionalArguments[0] as JournalEntry;
          return Success(updated);
        });

        final result = await repository.update(entry, markDirty: false);

        expect(result.isSuccess, isTrue);
        final updated = result.valueOrNull!;
        expect(updated.syncMetadata.syncVersion, 5);
        expect(updated.syncMetadata.syncStatus, SyncStatus.synced);
        verifyNever(mockDeviceInfoService.getDeviceId());
      });

      test('update_delegatesToDaoWithMarkDirtyFlag', () async {
        final entry = createTestJournalEntry();
        when(
          mockDao.updateEntity(any, markDirty: false),
        ).thenAnswer((_) async => Success(entry));

        await repository.update(entry, markDirty: false);

        verify(mockDao.updateEntity(any, markDirty: false)).called(1);
      });
    });

    group('delete', () {
      test('delete_delegatesToDaoSoftDelete', () async {
        when(
          mockDao.softDelete('journal-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.delete('journal-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.softDelete('journal-001')).called(1);
      });
    });

    group('hardDelete', () {
      test('hardDelete_delegatesToDaoHardDelete', () async {
        when(
          mockDao.hardDelete('journal-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.hardDelete('journal-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.hardDelete('journal-001')).called(1);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_delegatesToDao', () async {
        final entries = [createTestJournalEntry()];
        when(
          mockDao.getModifiedSince(1000),
        ).thenAnswer((_) async => Success(entries));

        final result = await repository.getModifiedSince(1000);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entries);
        verify(mockDao.getModifiedSince(1000)).called(1);
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_delegatesToDao', () async {
        final entries = [createTestJournalEntry()];
        when(
          mockDao.getPendingSync(),
        ).thenAnswer((_) async => Success(entries));

        final result = await repository.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entries);
        verify(mockDao.getPendingSync()).called(1);
      });
    });

    group('getByProfile', () {
      test('getByProfile_delegatesToDao', () async {
        final entries = [createTestJournalEntry()];
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Success(entries));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entries);
        verify(mockDao.getByProfile(testProfileId)).called(1);
      });

      test('getByProfile_passesAllParametersToDao', () async {
        when(
          mockDao.getByProfile(
            testProfileId,
            startDate: 1000,
            endDate: 2000,
            tags: const ['health'],
            mood: 7,
            limit: 10,
            offset: 5,
          ),
        ).thenAnswer((_) async => const Success([]));

        await repository.getByProfile(
          testProfileId,
          startDate: 1000,
          endDate: 2000,
          tags: const ['health'],
          mood: 7,
          limit: 10,
          offset: 5,
        );

        verify(
          mockDao.getByProfile(
            testProfileId,
            startDate: 1000,
            endDate: 2000,
            tags: const ['health'],
            mood: 7,
            limit: 10,
            offset: 5,
          ),
        ).called(1);
      });
    });

    group('search', () {
      test('search_delegatesToDao', () async {
        final entries = [createTestJournalEntry()];
        when(
          mockDao.search(testProfileId, 'test'),
        ).thenAnswer((_) async => Success(entries));

        final result = await repository.search(testProfileId, 'test');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, entries);
        verify(mockDao.search(testProfileId, 'test')).called(1);
      });
    });

    group('getMoodDistribution', () {
      test('getMoodDistribution_delegatesToDao', () async {
        const distribution = {7: 5, 8: 3, 5: 2};
        when(
          mockDao.getMoodDistribution(
            testProfileId,
            startDate: 1000,
            endDate: 2000,
          ),
        ).thenAnswer((_) async => const Success(distribution));

        final result = await repository.getMoodDistribution(
          testProfileId,
          startDate: 1000,
          endDate: 2000,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, distribution);
        verify(
          mockDao.getMoodDistribution(
            testProfileId,
            startDate: 1000,
            endDate: 2000,
          ),
        ).called(1);
      });
    });
  });
}
