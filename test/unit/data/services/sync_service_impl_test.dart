// test/unit/data/services/sync_service_impl_test.dart
// Tests for SyncServiceImpl - Phase 2 upload path.

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/encryption_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/remote/cloud_storage_provider.dart';
import 'package:shadow_app/data/services/sync_service_impl.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/entities/sync_conflict.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/supplement_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([SupplementRepository, EncryptionService, CloudStorageProvider])
import 'sync_service_impl_test.mocks.dart';

/// Helper to create a test Supplement entity with given sync state.
Supplement _testSupplement({
  String id = 'sup-1',
  String clientId = 'device-1',
  String profileId = 'profile-1',
  String name = 'Vitamin D',
  bool isDirty = true,
  int syncVersion = 1,
  int syncUpdatedAt = 1000,
}) => Supplement(
  id: id,
  clientId: clientId,
  profileId: profileId,
  name: name,
  form: SupplementForm.capsule,
  dosageQuantity: 1000,
  dosageUnit: DosageUnit.mg,
  syncMetadata: SyncMetadata(
    syncCreatedAt: 1000,
    syncUpdatedAt: syncUpdatedAt,
    syncDeviceId: clientId,
    syncIsDirty: isDirty,
    syncVersion: syncVersion,
  ),
);

void main() {
  late MockSupplementRepository mockRepo;
  late MockEncryptionService mockEncryption;
  late MockCloudStorageProvider mockCloud;
  late SharedPreferences prefs;
  late SyncServiceImpl syncService;

  setUpAll(() {
    // Register dummy values for sealed Result types
    provideDummy<Result<void, AppError>>(const Success(null));
    provideDummy<Result<List<Supplement>, AppError>>(const Success([]));
    provideDummy<Result<Supplement, AppError>>(Success(_testSupplement()));
    provideDummy<Result<Map<String, dynamic>?, AppError>>(const Success(null));
    provideDummy<Result<List<SyncChange>, AppError>>(const Success([]));
    provideDummy<Result<String, AppError>>(const Success(''));
  });

  setUp(() async {
    mockRepo = MockSupplementRepository();
    mockEncryption = MockEncryptionService();
    mockCloud = MockCloudStorageProvider();

    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();

    syncService = SyncServiceImpl(
      adapters: [
        SyncEntityAdapter<Supplement>(
          entityType: 'supplements',
          repository: mockRepo,
          withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
        ),
      ],
      encryptionService: mockEncryption,
      cloudProvider: mockCloud,
      prefs: prefs,
    );
  });

  // ===========================================================================
  // SyncEntityAdapter tests
  // ===========================================================================

  group('SyncEntityAdapter', () {
    test('getPendingSyncChanges filters by profileId', () async {
      final sup1 = _testSupplement();
      final sup2 = _testSupplement(id: 'sup-2', profileId: 'profile-2');
      when(
        mockRepo.getPendingSync(),
      ).thenAnswer((_) async => Success([sup1, sup2]));

      final adapter = SyncEntityAdapter<Supplement>(
        entityType: 'supplements',
        repository: mockRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
      );

      final result = await adapter.getPendingSyncChanges('profile-1');
      expect(result.isSuccess, true);

      final changes = result.valueOrNull!;
      expect(changes.length, 1);
      expect(changes.first.entityId, 'sup-1');
      expect(changes.first.profileId, 'profile-1');
    });

    test('getPendingSyncChanges maps fields correctly', () async {
      final sup = _testSupplement(syncVersion: 3, syncUpdatedAt: 5000);
      when(mockRepo.getPendingSync()).thenAnswer((_) async => Success([sup]));

      final adapter = SyncEntityAdapter<Supplement>(
        entityType: 'supplements',
        repository: mockRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
      );

      final result = await adapter.getPendingSyncChanges('profile-1');
      final change = result.valueOrNull!.first;

      expect(change.entityType, 'supplements');
      expect(change.entityId, 'sup-1');
      expect(change.clientId, 'device-1');
      expect(change.profileId, 'profile-1');
      expect(change.version, 3);
      expect(change.timestamp, 5000);
      expect(change.isDeleted, false);
      expect(change.data, isA<Map<String, dynamic>>());
    });

    test('getPendingSyncChanges returns failure on repository error', () async {
      when(mockRepo.getPendingSync()).thenAnswer(
        (_) async => Failure(DatabaseError.queryFailed('test error')),
      );

      final adapter = SyncEntityAdapter<Supplement>(
        entityType: 'supplements',
        repository: mockRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
      );

      final result = await adapter.getPendingSyncChanges('profile-1');
      expect(result.isFailure, true);
    });

    test('getPendingSyncCount returns count filtered by profileId', () async {
      final sup1 = _testSupplement();
      final sup2 = _testSupplement(id: 'sup-2');
      final sup3 = _testSupplement(id: 'sup-3', profileId: 'profile-2');
      when(
        mockRepo.getPendingSync(),
      ).thenAnswer((_) async => Success([sup1, sup2, sup3]));

      final adapter = SyncEntityAdapter<Supplement>(
        entityType: 'supplements',
        repository: mockRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
      );

      final result = await adapter.getPendingSyncCount('profile-1');
      expect(result.isSuccess, true);
      expect(result.valueOrNull, 2);
    });

    test(
      'markEntitySynced loads entity, applies markSynced, and saves',
      () async {
        final sup = _testSupplement();

        when(mockRepo.getById('sup-1')).thenAnswer((_) async => Success(sup));
        when(
          mockRepo.update(any, markDirty: false),
        ).thenAnswer((_) async => Success(sup));

        final adapter = SyncEntityAdapter<Supplement>(
          entityType: 'supplements',
          repository: mockRepo,
          withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
        );

        final result = await adapter.markEntitySynced('sup-1');
        expect(result.isSuccess, true);

        // Verify update was called with markDirty: false
        final captured = verify(
          mockRepo.update(captureAny, markDirty: false),
        ).captured;
        final savedEntity = captured.first as Supplement;
        expect(savedEntity.syncMetadata.syncIsDirty, false);
        expect(savedEntity.syncMetadata.syncStatus, SyncStatus.synced);
        expect(savedEntity.syncMetadata.syncLastSyncedAt, isNotNull);
      },
    );

    test('markEntitySynced returns failure if entity not found', () async {
      when(mockRepo.getById('missing')).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('supplement', 'missing')),
      );

      final adapter = SyncEntityAdapter<Supplement>(
        entityType: 'supplements',
        repository: mockRepo,
        withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
      );

      final result = await adapter.markEntitySynced('missing');
      expect(result.isFailure, true);
    });
  });

  // ===========================================================================
  // SyncServiceImpl.getPendingChanges
  // ===========================================================================

  group('getPendingChanges', () {
    test('returns changes from adapters sorted by timestamp', () async {
      final sup1 = _testSupplement(syncUpdatedAt: 3000);
      final sup2 = _testSupplement(id: 'sup-2');
      when(
        mockRepo.getPendingSync(),
      ).thenAnswer((_) async => Success([sup1, sup2]));

      final result = await syncService.getPendingChanges('profile-1');
      expect(result.isSuccess, true);

      final changes = result.valueOrNull!;
      expect(changes.length, 2);
      // Oldest first (1000 before 3000)
      expect(changes[0].entityId, 'sup-2');
      expect(changes[1].entityId, 'sup-1');
    });

    test('applies limit to results', () async {
      final sups = List.generate(
        10,
        (i) => _testSupplement(id: 'sup-$i', syncUpdatedAt: i * 1000),
      );
      when(mockRepo.getPendingSync()).thenAnswer((_) async => Success(sups));

      final result = await syncService.getPendingChanges('profile-1', limit: 3);
      expect(result.valueOrNull!.length, 3);
    });

    test('continues on adapter failure', () async {
      when(
        mockRepo.getPendingSync(),
      ).thenAnswer((_) async => Failure(DatabaseError.queryFailed('db error')));

      final result = await syncService.getPendingChanges('profile-1');
      // Should return empty list (continues past failure)
      expect(result.isSuccess, true);
      expect(result.valueOrNull, isEmpty);
    });

    test('returns empty list when no dirty records', () async {
      when(
        mockRepo.getPendingSync(),
      ).thenAnswer((_) async => const Success([]));

      final result = await syncService.getPendingChanges('profile-1');
      expect(result.isSuccess, true);
      expect(result.valueOrNull, isEmpty);
    });
  });

  // ===========================================================================
  // SyncServiceImpl.pushChanges
  // ===========================================================================

  group('pushChanges', () {
    test('returns zero counts for empty list', () async {
      final result = await syncService.pushChanges([]);
      expect(result.isSuccess, true);

      final pushResult = result.valueOrNull!;
      expect(pushResult.pushedCount, 0);
      expect(pushResult.failedCount, 0);
      expect(pushResult.conflicts, isEmpty);
    });

    test('encrypts data, uploads envelope, and marks entity synced', () async {
      final sup = _testSupplement();
      final change = SyncChange(
        entityType: 'supplements',
        entityId: 'sup-1',
        profileId: 'profile-1',
        clientId: 'device-1',
        data: sup.toJson(),
        version: 1,
        timestamp: 1000,
      );

      when(
        mockEncryption.encrypt(any),
      ).thenAnswer((_) async => 'nonce:ciphertext:tag');
      when(
        mockCloud.uploadEntity(any, any, any, any, any, any),
      ).thenAnswer((_) async => const Success(null));
      when(mockRepo.getById('sup-1')).thenAnswer((_) async => Success(sup));
      when(
        mockRepo.update(any, markDirty: false),
      ).thenAnswer((_) async => Success(sup));

      final result = await syncService.pushChanges([change]);
      expect(result.isSuccess, true);

      final pushResult = result.valueOrNull!;
      expect(pushResult.pushedCount, 1);
      expect(pushResult.failedCount, 0);

      // Verify encryption was called
      verify(mockEncryption.encrypt(any)).called(1);

      // Verify upload was called with envelope containing encryptedData
      final uploadCapture = verify(
        mockCloud.uploadEntity(
          captureAny,
          captureAny,
          captureAny,
          captureAny,
          captureAny,
          captureAny,
        ),
      ).captured;
      expect(uploadCapture[0], 'supplements');
      expect(uploadCapture[1], 'sup-1');
      expect(uploadCapture[2], 'profile-1');
      expect(uploadCapture[3], 'device-1');
      final envelope = uploadCapture[4] as Map<String, dynamic>;
      expect(envelope['encryptedData'], 'nonce:ciphertext:tag');
      expect(uploadCapture[5], 1);

      // Verify entity was marked synced
      verify(mockRepo.getById('sup-1')).called(1);
      verify(mockRepo.update(any, markDirty: false)).called(1);
    });

    test('increments failedCount on upload failure', () async {
      const change = SyncChange(
        entityType: 'supplements',
        entityId: 'sup-1',
        profileId: 'profile-1',
        clientId: 'device-1',
        data: {'id': 'sup-1'},
        version: 1,
        timestamp: 1000,
      );

      when(mockEncryption.encrypt(any)).thenAnswer((_) async => 'encrypted');
      when(mockCloud.uploadEntity(any, any, any, any, any, any)).thenAnswer(
        (_) async => Failure(
          SyncError.uploadFailed('supplements', 'sup-1', Exception('fail')),
        ),
      );

      final result = await syncService.pushChanges([change]);
      expect(result.isSuccess, true);

      final pushResult = result.valueOrNull!;
      expect(pushResult.pushedCount, 0);
      expect(pushResult.failedCount, 1);

      // Should NOT call markEntitySynced
      verifyNever(mockRepo.getById(any));
    });

    test('increments failedCount on encryption exception', () async {
      const change = SyncChange(
        entityType: 'supplements',
        entityId: 'sup-1',
        profileId: 'profile-1',
        clientId: 'device-1',
        data: {'id': 'sup-1'},
        version: 1,
        timestamp: 1000,
      );

      when(
        mockEncryption.encrypt(any),
      ).thenThrow(Exception('Encryption failed'));

      final result = await syncService.pushChanges([change]);
      expect(result.isSuccess, true);

      final pushResult = result.valueOrNull!;
      expect(pushResult.pushedCount, 0);
      expect(pushResult.failedCount, 1);
    });

    test('updates SharedPreferences sync time and version', () async {
      const change = SyncChange(
        entityType: 'supplements',
        entityId: 'sup-1',
        profileId: 'profile-1',
        clientId: 'device-1',
        data: {'id': 'sup-1'},
        version: 5,
        timestamp: 1000,
      );

      when(mockEncryption.encrypt(any)).thenAnswer((_) async => 'encrypted');
      when(
        mockCloud.uploadEntity(any, any, any, any, any, any),
      ).thenAnswer((_) async => const Success(null));

      final sup = _testSupplement();
      when(mockRepo.getById('sup-1')).thenAnswer((_) async => Success(sup));
      when(
        mockRepo.update(any, markDirty: false),
      ).thenAnswer((_) async => Success(sup));

      await syncService.pushChanges([change]);

      // Verify prefs were updated
      final syncTime = prefs.getInt('sync_last_sync_time_profile-1');
      expect(syncTime, isNotNull);

      final syncVersion = prefs.getInt('sync_last_sync_version_profile-1');
      expect(syncVersion, 5);
    });

    test('only updates version if higher than current', () async {
      // Pre-set a higher version
      await prefs.setInt('sync_last_sync_version_profile-1', 10);

      const change = SyncChange(
        entityType: 'supplements',
        entityId: 'sup-1',
        profileId: 'profile-1',
        clientId: 'device-1',
        data: {'id': 'sup-1'},
        version: 3, // Lower than current 10
        timestamp: 1000,
      );

      when(mockEncryption.encrypt(any)).thenAnswer((_) async => 'encrypted');
      when(
        mockCloud.uploadEntity(any, any, any, any, any, any),
      ).thenAnswer((_) async => const Success(null));

      final sup = _testSupplement();
      when(mockRepo.getById('sup-1')).thenAnswer((_) async => Success(sup));
      when(
        mockRepo.update(any, markDirty: false),
      ).thenAnswer((_) async => Success(sup));

      await syncService.pushChanges([change]);

      // Version should remain at 10 (not overwritten with 3)
      final syncVersion = prefs.getInt('sync_last_sync_version_profile-1');
      expect(syncVersion, 10);
    });

    test('pushes multiple changes and counts results', () async {
      const changes = [
        SyncChange(
          entityType: 'supplements',
          entityId: 'sup-1',
          profileId: 'profile-1',
          clientId: 'device-1',
          data: {'id': 'sup-1'},
          version: 1,
          timestamp: 1000,
        ),
        SyncChange(
          entityType: 'supplements',
          entityId: 'sup-2',
          profileId: 'profile-1',
          clientId: 'device-1',
          data: {'id': 'sup-2'},
          version: 2,
          timestamp: 2000,
        ),
      ];

      when(mockEncryption.encrypt(any)).thenAnswer((_) async => 'encrypted');
      // First upload succeeds, second fails
      var callCount = 0;
      when(mockCloud.uploadEntity(any, any, any, any, any, any)).thenAnswer((
        _,
      ) async {
        callCount++;
        if (callCount == 1) return const Success(null);
        return Failure(
          SyncError.uploadFailed('supplements', 'sup-2', Exception('fail')),
        );
      });

      final sup = _testSupplement();
      when(mockRepo.getById(any)).thenAnswer((_) async => Success(sup));
      when(
        mockRepo.update(any, markDirty: false),
      ).thenAnswer((_) async => Success(sup));

      final result = await syncService.pushChanges(changes);
      final pushResult = result.valueOrNull!;

      expect(pushResult.pushedCount, 1);
      expect(pushResult.failedCount, 1);
    });
  });

  // ===========================================================================
  // SyncServiceImpl.pushPendingChanges
  // ===========================================================================

  group('pushPendingChanges', () {
    test('pushes dirty records from all adapters', () async {
      final sup = _testSupplement();
      when(mockRepo.getPendingSync()).thenAnswer((_) async => Success([sup]));
      when(mockEncryption.encrypt(any)).thenAnswer((_) async => 'encrypted');
      when(
        mockCloud.uploadEntity(any, any, any, any, any, any),
      ).thenAnswer((_) async => const Success(null));
      when(mockRepo.getById('sup-1')).thenAnswer((_) async => Success(sup));
      when(
        mockRepo.update(any, markDirty: false),
      ).thenAnswer((_) async => Success(sup));

      // Should not throw
      await syncService.pushPendingChanges();

      verify(mockCloud.uploadEntity(any, any, any, any, any, any)).called(1);
    });

    test('swallows exceptions', () async {
      when(mockRepo.getPendingSync()).thenThrow(Exception('db crash'));

      // Should not throw
      await syncService.pushPendingChanges();
    });
  });

  // ===========================================================================
  // SyncServiceImpl.getPendingChangesCount
  // ===========================================================================

  group('getPendingChangesCount', () {
    test('sums counts from all adapters', () async {
      final sups = [_testSupplement(), _testSupplement(id: 'sup-2')];
      when(mockRepo.getPendingSync()).thenAnswer((_) async => Success(sups));

      final result = await syncService.getPendingChangesCount('profile-1');
      expect(result.isSuccess, true);
      expect(result.valueOrNull, 2);
    });

    test('returns zero when no pending changes', () async {
      when(
        mockRepo.getPendingSync(),
      ).thenAnswer((_) async => const Success([]));

      final result = await syncService.getPendingChangesCount('profile-1');
      expect(result.isSuccess, true);
      expect(result.valueOrNull, 0);
    });
  });

  // ===========================================================================
  // Status queries
  // ===========================================================================

  group('status queries', () {
    test('getLastSyncTime reads from SharedPreferences', () async {
      await prefs.setInt('sync_last_sync_time_profile-1', 999000);

      final result = await syncService.getLastSyncTime('profile-1');
      expect(result.isSuccess, true);
      expect(result.valueOrNull, 999000);
    });

    test('getLastSyncTime returns null when never synced', () async {
      final result = await syncService.getLastSyncTime('profile-1');
      expect(result.isSuccess, true);
      expect(result.valueOrNull, isNull);
    });

    test('getLastSyncVersion reads from SharedPreferences', () async {
      await prefs.setInt('sync_last_sync_version_profile-1', 42);

      final result = await syncService.getLastSyncVersion('profile-1');
      expect(result.isSuccess, true);
      expect(result.valueOrNull, 42);
    });

    test('getLastSyncVersion returns null when never synced', () async {
      final result = await syncService.getLastSyncVersion('profile-1');
      expect(result.isSuccess, true);
      expect(result.valueOrNull, isNull);
    });
  });

  // ===========================================================================
  // Phase 3/4 stubs
  // ===========================================================================

  group('Phase 3/4 stubs', () {
    test('pullChanges returns empty list', () async {
      final result = await syncService.pullChanges('profile-1');
      expect(result.isSuccess, true);
      expect(result.valueOrNull, isEmpty);
    });

    test('applyChanges returns zero counts', () async {
      final result = await syncService.applyChanges('profile-1', []);
      expect(result.isSuccess, true);

      final pullResult = result.valueOrNull!;
      expect(pullResult.pulledCount, 0);
      expect(pullResult.appliedCount, 0);
      expect(pullResult.conflictCount, 0);
      expect(pullResult.conflicts, isEmpty);
      expect(pullResult.latestVersion, 0);
    });

    test('resolveConflict returns success', () async {
      final result = await syncService.resolveConflict(
        'conflict-1',
        ConflictResolutionType.keepLocal,
      );
      expect(result.isSuccess, true);
    });

    test('getConflictCount returns zero', () async {
      final result = await syncService.getConflictCount('profile-1');
      expect(result.isSuccess, true);
      expect(result.valueOrNull, 0);
    });
  });
}
