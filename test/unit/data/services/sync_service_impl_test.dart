// test/unit/data/services/sync_service_impl_test.dart
// Tests for SyncServiceImpl - Phase 2 upload path + Phase 3 pull path.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/encryption_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/sync_conflict_dao.dart';
import 'package:shadow_app/data/datasources/remote/cloud_storage_provider.dart';
import 'package:shadow_app/data/services/sync_service_impl.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/entities/sync_conflict.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/supplement_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([
  SupplementRepository,
  EncryptionService,
  CloudStorageProvider,
  SyncConflictDao,
])
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
  late MockSyncConflictDao mockConflictDao;
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
    provideDummy<Result<int, AppError>>(const Success(0));
    provideDummy<Result<SyncConflict, AppError>>(
      const Success(
        SyncConflict(
          id: 'conflict-1',
          entityType: 'supplements',
          entityId: 'sup-1',
          profileId: 'profile-1',
          localVersion: 1,
          remoteVersion: 2,
          localData: {},
          remoteData: {},
          detectedAt: 1000,
        ),
      ),
    );
  });

  setUp(() async {
    mockRepo = MockSupplementRepository();
    mockEncryption = MockEncryptionService();
    mockCloud = MockCloudStorageProvider();
    mockConflictDao = MockSyncConflictDao();

    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();

    syncService = SyncServiceImpl(
      adapters: [
        SyncEntityAdapter<Supplement>(
          entityType: 'supplements',
          repository: mockRepo,
          withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
          fromJson: Supplement.fromJson,
        ),
      ],
      encryptionService: mockEncryption,
      cloudProvider: mockCloud,
      prefs: prefs,
      conflictDao: mockConflictDao,
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
        fromJson: Supplement.fromJson,
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
        fromJson: Supplement.fromJson,
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
        fromJson: Supplement.fromJson,
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
        fromJson: Supplement.fromJson,
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
          fromJson: Supplement.fromJson,
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
        fromJson: Supplement.fromJson,
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
  // SyncServiceImpl.pullChanges (Phase 3)
  // ===========================================================================

  group('pullChanges', () {
    test('returns empty list when cloud has no changes', () async {
      when(
        mockCloud.getChangesSince(0),
      ).thenAnswer((_) async => const Success(<SyncChange>[]));

      final result = await syncService.pullChanges('profile-1');
      expect(result.isSuccess, true);
      expect(result.valueOrNull, isEmpty);
    });

    test('uses lastSyncTime from SharedPreferences', () async {
      // Pre-set a sync time
      await prefs.setInt('sync_last_sync_time_profile-1', 50000);

      when(
        mockCloud.getChangesSince(50000),
      ).thenAnswer((_) async => const Success(<SyncChange>[]));

      final result = await syncService.pullChanges('profile-1');
      expect(result.isSuccess, true);

      // Verify it called getChangesSince with the stored time, not 0
      verify(mockCloud.getChangesSince(50000)).called(1);
      verifyNever(mockCloud.getChangesSince(0));
    });

    test('decrypts encryptedData from each envelope', () async {
      final sup = _testSupplement();
      final supJson = jsonEncode(sup.toJson());

      // Simulate a raw envelope from the cloud (encryptedData is AES string)
      final envelope = <String, dynamic>{
        'entityType': 'supplements',
        'entityId': 'sup-1',
        'profileId': 'profile-1',
        'clientId': 'device-1',
        'version': 1,
        'timestamp': 1000,
        'isDeleted': false,
        'encryptedData': 'nonce:ciphertext:tag',
      };

      final rawChange = SyncChange(
        entityType: 'supplements',
        entityId: 'sup-1',
        profileId: 'profile-1',
        clientId: 'device-1',
        data: envelope,
        version: 1,
        timestamp: 1000,
      );

      when(
        mockCloud.getChangesSince(0),
      ).thenAnswer((_) async => Success([rawChange]));
      when(
        mockEncryption.decrypt('nonce:ciphertext:tag'),
      ).thenAnswer((_) async => supJson);

      final result = await syncService.pullChanges('profile-1');
      expect(result.isSuccess, true);

      final changes = result.valueOrNull!;
      expect(changes.length, 1);

      // Verify decryption was called
      verify(mockEncryption.decrypt('nonce:ciphertext:tag')).called(1);

      // Verify the data was replaced with decrypted entity JSON
      expect(changes.first.data['id'], 'sup-1');
      expect(changes.first.data['name'], 'Vitamin D');
      expect(changes.first.entityType, 'supplements');
      expect(changes.first.entityId, 'sup-1');
      expect(changes.first.profileId, 'profile-1');
    });

    test('filters changes by profileId', () async {
      // Two envelopes: one for profile-1, one for profile-2
      final sup = _testSupplement();
      final supJson = jsonEncode(sup.toJson());

      final envelope1 = <String, dynamic>{
        'entityType': 'supplements',
        'entityId': 'sup-1',
        'profileId': 'profile-1',
        'clientId': 'device-1',
        'version': 1,
        'timestamp': 1000,
        'isDeleted': false,
        'encryptedData': 'encrypted-1',
      };

      final envelope2 = <String, dynamic>{
        'entityType': 'supplements',
        'entityId': 'sup-2',
        'profileId': 'profile-2',
        'clientId': 'device-1',
        'version': 1,
        'timestamp': 2000,
        'isDeleted': false,
        'encryptedData': 'encrypted-2',
      };

      final changes = [
        SyncChange(
          entityType: 'supplements',
          entityId: 'sup-1',
          profileId: 'profile-1',
          clientId: 'device-1',
          data: envelope1,
          version: 1,
          timestamp: 1000,
        ),
        SyncChange(
          entityType: 'supplements',
          entityId: 'sup-2',
          profileId: 'profile-2',
          clientId: 'device-1',
          data: envelope2,
          version: 1,
          timestamp: 2000,
        ),
      ];

      when(
        mockCloud.getChangesSince(0),
      ).thenAnswer((_) async => Success(changes));
      when(
        mockEncryption.decrypt('encrypted-1'),
      ).thenAnswer((_) async => supJson);

      final result = await syncService.pullChanges('profile-1');
      expect(result.isSuccess, true);
      expect(result.valueOrNull!.length, 1);
      expect(result.valueOrNull!.first.entityId, 'sup-1');

      // encrypted-2 should NOT have been decrypted (filtered out)
      verifyNever(mockEncryption.decrypt('encrypted-2'));
    });

    test('skips entries with missing encryptedData', () async {
      final envelope = <String, dynamic>{
        'entityType': 'supplements',
        'entityId': 'sup-1',
        'profileId': 'profile-1',
        'clientId': 'device-1',
        'version': 1,
        'timestamp': 1000,
        'isDeleted': false,
        // no encryptedData field
      };

      final rawChange = SyncChange(
        entityType: 'supplements',
        entityId: 'sup-1',
        profileId: 'profile-1',
        clientId: 'device-1',
        data: envelope,
        version: 1,
        timestamp: 1000,
      );

      when(
        mockCloud.getChangesSince(0),
      ).thenAnswer((_) async => Success([rawChange]));

      final result = await syncService.pullChanges('profile-1');
      expect(result.isSuccess, true);
      expect(result.valueOrNull, isEmpty);

      // Decrypt should NOT have been called
      verifyNever(mockEncryption.decrypt(any));
    });

    test('continues on decryption failure', () async {
      final sup = _testSupplement(id: 'sup-2');
      final supJson = jsonEncode(sup.toJson());

      final envelope1 = <String, dynamic>{
        'entityType': 'supplements',
        'entityId': 'sup-1',
        'profileId': 'profile-1',
        'clientId': 'device-1',
        'version': 1,
        'timestamp': 1000,
        'isDeleted': false,
        'encryptedData': 'corrupted-data',
      };
      final envelope2 = <String, dynamic>{
        'entityType': 'supplements',
        'entityId': 'sup-2',
        'profileId': 'profile-1',
        'clientId': 'device-1',
        'version': 2,
        'timestamp': 2000,
        'isDeleted': false,
        'encryptedData': 'valid-data',
      };

      final changes = [
        SyncChange(
          entityType: 'supplements',
          entityId: 'sup-1',
          profileId: 'profile-1',
          clientId: 'device-1',
          data: envelope1,
          version: 1,
          timestamp: 1000,
        ),
        SyncChange(
          entityType: 'supplements',
          entityId: 'sup-2',
          profileId: 'profile-1',
          clientId: 'device-1',
          data: envelope2,
          version: 2,
          timestamp: 2000,
        ),
      ];

      when(
        mockCloud.getChangesSince(0),
      ).thenAnswer((_) async => Success(changes));
      when(
        mockEncryption.decrypt('corrupted-data'),
      ).thenThrow(Exception('Decryption failed'));
      when(
        mockEncryption.decrypt('valid-data'),
      ).thenAnswer((_) async => supJson);

      final result = await syncService.pullChanges('profile-1');
      expect(result.isSuccess, true);

      // Only the second one should be in results
      final pulled = result.valueOrNull!;
      expect(pulled.length, 1);
      expect(pulled.first.entityId, 'sup-2');
    });

    test('returns failure when cloud provider fails', () async {
      when(
        mockCloud.getChangesSince(0),
      ).thenAnswer((_) async => Failure(NetworkError.noConnection()));

      final result = await syncService.pullChanges('profile-1');
      expect(result.isFailure, true);
    });

    test('sorts results by timestamp ascending', () async {
      final sup = _testSupplement();
      final supJson = jsonEncode(sup.toJson());

      final envelope1 = <String, dynamic>{
        'entityType': 'supplements',
        'entityId': 'sup-1',
        'profileId': 'profile-1',
        'clientId': 'device-1',
        'version': 1,
        'timestamp': 5000,
        'isDeleted': false,
        'encryptedData': 'enc-1',
      };
      final envelope2 = <String, dynamic>{
        'entityType': 'supplements',
        'entityId': 'sup-2',
        'profileId': 'profile-1',
        'clientId': 'device-1',
        'version': 2,
        'timestamp': 1000,
        'isDeleted': false,
        'encryptedData': 'enc-2',
      };

      final changes = [
        SyncChange(
          entityType: 'supplements',
          entityId: 'sup-1',
          profileId: 'profile-1',
          clientId: 'device-1',
          data: envelope1,
          version: 1,
          timestamp: 5000,
        ),
        SyncChange(
          entityType: 'supplements',
          entityId: 'sup-2',
          profileId: 'profile-1',
          clientId: 'device-1',
          data: envelope2,
          version: 2,
          timestamp: 1000,
        ),
      ];

      when(
        mockCloud.getChangesSince(0),
      ).thenAnswer((_) async => Success(changes));
      when(mockEncryption.decrypt(any)).thenAnswer((_) async => supJson);

      final result = await syncService.pullChanges('profile-1');
      final pulled = result.valueOrNull!;
      expect(pulled.length, 2);
      // Oldest first (1000 before 5000)
      expect(pulled[0].entityId, 'sup-2');
      expect(pulled[1].entityId, 'sup-1');
    });

    test('applies limit to results', () async {
      final sup = _testSupplement();
      final supJson = jsonEncode(sup.toJson());

      // Create 5 changes
      final changes = List.generate(5, (i) {
        final envelope = <String, dynamic>{
          'entityType': 'supplements',
          'entityId': 'sup-$i',
          'profileId': 'profile-1',
          'clientId': 'device-1',
          'version': i + 1,
          'timestamp': (i + 1) * 1000,
          'isDeleted': false,
          'encryptedData': 'enc-$i',
        };
        return SyncChange(
          entityType: 'supplements',
          entityId: 'sup-$i',
          profileId: 'profile-1',
          clientId: 'device-1',
          data: envelope,
          version: i + 1,
          timestamp: (i + 1) * 1000,
        );
      });

      when(
        mockCloud.getChangesSince(0),
      ).thenAnswer((_) async => Success(changes));
      when(mockEncryption.decrypt(any)).thenAnswer((_) async => supJson);

      final result = await syncService.pullChanges('profile-1', limit: 3);
      expect(result.valueOrNull!.length, 3);
    });
  });

  // ===========================================================================
  // SyncServiceImpl.applyChanges (Phase 3)
  // ===========================================================================

  group('applyChanges', () {
    test('returns zero counts for empty list', () async {
      final result = await syncService.applyChanges('profile-1', []);
      expect(result.isSuccess, true);

      final pullResult = result.valueOrNull!;
      expect(pullResult.pulledCount, 0);
      expect(pullResult.appliedCount, 0);
      expect(pullResult.conflictCount, 0);
      expect(pullResult.conflicts, isEmpty);
      expect(pullResult.latestVersion, 0);
    });

    test('inserts new entity when not found locally', () async {
      // Entity not found → create it
      final sup = _testSupplement(isDirty: false);

      when(mockRepo.getById('sup-1')).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('supplement', 'sup-1')),
      );
      when(mockRepo.create(any)).thenAnswer((_) async => Success(sup));

      final change = SyncChange(
        entityType: 'supplements',
        entityId: 'sup-1',
        profileId: 'profile-1',
        clientId: 'device-1',
        data: sup.toJson(),
        version: 1,
        timestamp: 1000,
      );

      final result = await syncService.applyChanges('profile-1', [change]);
      expect(result.isSuccess, true);

      final pullResult = result.valueOrNull!;
      expect(pullResult.pulledCount, 1);
      expect(pullResult.appliedCount, 1);
      expect(pullResult.conflictCount, 0);

      // Verify create was called with a synced entity (not dirty)
      final captured = verify(mockRepo.create(captureAny)).captured;
      final createdEntity = captured.first as Supplement;
      expect(createdEntity.syncMetadata.syncIsDirty, false);
      expect(createdEntity.syncMetadata.syncStatus, SyncStatus.synced);
    });

    test('overwrites local entity when not dirty', () async {
      // Existing entity, NOT dirty → overwrite
      final localSup = _testSupplement(isDirty: false);
      final remoteSup = _testSupplement(
        isDirty: false,
        syncVersion: 2,
        name: 'Updated Vitamin D',
      );

      when(
        mockRepo.getById('sup-1'),
      ).thenAnswer((_) async => Success(localSup));
      when(
        mockRepo.update(any, markDirty: false),
      ).thenAnswer((_) async => Success(remoteSup));

      final change = SyncChange(
        entityType: 'supplements',
        entityId: 'sup-1',
        profileId: 'profile-1',
        clientId: 'device-1',
        data: remoteSup.toJson(),
        version: 2,
        timestamp: 2000,
      );

      final result = await syncService.applyChanges('profile-1', [change]);
      expect(result.isSuccess, true);

      final pullResult = result.valueOrNull!;
      expect(pullResult.appliedCount, 1);
      expect(pullResult.conflictCount, 0);

      // Verify update was called with markDirty: false
      final captured = verify(
        mockRepo.update(captureAny, markDirty: false),
      ).captured;
      final updatedEntity = captured.first as Supplement;
      expect(updatedEntity.syncMetadata.syncIsDirty, false);
      expect(updatedEntity.syncMetadata.syncStatus, SyncStatus.synced);
    });

    test('creates SyncConflict when local entity is dirty', () async {
      // Existing entity, IS dirty → conflict
      final localSup = _testSupplement();
      final remoteSup = _testSupplement(isDirty: false, syncVersion: 2);

      when(
        mockRepo.getById('sup-1'),
      ).thenAnswer((_) async => Success(localSup));
      // markEntityConflicted calls update to persist the conflict state
      when(
        mockRepo.update(any, markDirty: anyNamed('markDirty')),
      ).thenAnswer((_) async => Success(localSup));
      when(
        mockConflictDao.insert(any),
      ).thenAnswer((_) async => const Success(null));

      final change = SyncChange(
        entityType: 'supplements',
        entityId: 'sup-1',
        profileId: 'profile-1',
        clientId: 'device-1',
        data: remoteSup.toJson(),
        version: 2,
        timestamp: 2000,
      );

      final result = await syncService.applyChanges('profile-1', [change]);
      expect(result.isSuccess, true);

      final pullResult = result.valueOrNull!;
      expect(pullResult.appliedCount, 0);
      expect(pullResult.conflictCount, 1);
      expect(pullResult.conflicts.length, 1);

      final conflict = pullResult.conflicts.first;
      expect(conflict.entityType, 'supplements');
      expect(conflict.entityId, 'sup-1');
      expect(conflict.profileId, 'profile-1');
      expect(conflict.localVersion, 1);
      expect(conflict.remoteVersion, 2);
      expect(conflict.localData, isNotEmpty);
      expect(conflict.remoteData, isNotEmpty);
      expect(conflict.isResolved, false);

      // Should NOT have called create; SHOULD have called update for markEntityConflicted
      verifyNever(mockRepo.create(any));
      verify(mockRepo.update(any, markDirty: anyNamed('markDirty'))).called(1);
      // Conflict row should have been inserted
      verify(mockConflictDao.insert(any)).called(1);
    });

    test('skips unknown entity types', () async {
      const change = SyncChange(
        entityType: 'unknown_table',
        entityId: 'unk-1',
        profileId: 'profile-1',
        clientId: 'device-1',
        data: {'id': 'unk-1'},
        version: 1,
        timestamp: 1000,
      );

      final result = await syncService.applyChanges('profile-1', [change]);
      expect(result.isSuccess, true);
      expect(result.valueOrNull!.appliedCount, 0);
      expect(result.valueOrNull!.conflictCount, 0);

      // Should not have touched the repository
      verifyNever(mockRepo.getById(any));
    });

    test('updates SharedPreferences after successful apply', () async {
      final sup = _testSupplement(isDirty: false);

      when(mockRepo.getById('sup-1')).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('supplement', 'sup-1')),
      );
      when(mockRepo.create(any)).thenAnswer((_) async => Success(sup));

      final change = SyncChange(
        entityType: 'supplements',
        entityId: 'sup-1',
        profileId: 'profile-1',
        clientId: 'device-1',
        data: sup.toJson(),
        version: 7,
        timestamp: 1000,
      );

      await syncService.applyChanges('profile-1', [change]);

      final syncTime = prefs.getInt('sync_last_sync_time_profile-1');
      expect(syncTime, isNotNull);

      final syncVersion = prefs.getInt('sync_last_sync_version_profile-1');
      expect(syncVersion, 7);
    });

    test('tracks latestVersion across multiple changes', () async {
      final sup = _testSupplement(isDirty: false);

      when(mockRepo.getById(any)).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('supplement', 'x')),
      );
      when(mockRepo.create(any)).thenAnswer((_) async => Success(sup));

      final changes = [
        SyncChange(
          entityType: 'supplements',
          entityId: 'sup-1',
          profileId: 'profile-1',
          clientId: 'device-1',
          data: sup.toJson(),
          version: 3,
          timestamp: 1000,
        ),
        SyncChange(
          entityType: 'supplements',
          entityId: 'sup-2',
          profileId: 'profile-1',
          clientId: 'device-1',
          data: _testSupplement(id: 'sup-2', isDirty: false).toJson(),
          version: 9,
          timestamp: 2000,
        ),
        SyncChange(
          entityType: 'supplements',
          entityId: 'sup-3',
          profileId: 'profile-1',
          clientId: 'device-1',
          data: _testSupplement(id: 'sup-3', isDirty: false).toJson(),
          version: 5,
          timestamp: 3000,
        ),
      ];

      final result = await syncService.applyChanges('profile-1', changes);
      expect(result.valueOrNull!.latestVersion, 9);
      expect(result.valueOrNull!.appliedCount, 3);
      expect(result.valueOrNull!.pulledCount, 3);
    });

    test('handles mixed insert, update, and conflict', () async {
      // sup-1: not found → insert
      // sup-2: found, clean → update
      // sup-3: found, dirty → conflict
      final cleanLocal = _testSupplement(id: 'sup-2', isDirty: false);
      final dirtyLocal = _testSupplement(id: 'sup-3');
      final remoteSup = _testSupplement(isDirty: false);

      when(mockRepo.getById('sup-1')).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('supplement', 'sup-1')),
      );
      when(
        mockRepo.getById('sup-2'),
      ).thenAnswer((_) async => Success(cleanLocal));
      when(
        mockRepo.getById('sup-3'),
      ).thenAnswer((_) async => Success(dirtyLocal));

      when(mockRepo.create(any)).thenAnswer((_) async => Success(remoteSup));
      when(
        mockRepo.update(any, markDirty: anyNamed('markDirty')),
      ).thenAnswer((_) async => Success(remoteSup));
      when(
        mockConflictDao.insert(any),
      ).thenAnswer((_) async => const Success(null));

      final changes = [
        SyncChange(
          entityType: 'supplements',
          entityId: 'sup-1',
          profileId: 'profile-1',
          clientId: 'device-1',
          data: remoteSup.toJson(),
          version: 1,
          timestamp: 1000,
        ),
        SyncChange(
          entityType: 'supplements',
          entityId: 'sup-2',
          profileId: 'profile-1',
          clientId: 'device-1',
          data: remoteSup.toJson(),
          version: 2,
          timestamp: 2000,
        ),
        SyncChange(
          entityType: 'supplements',
          entityId: 'sup-3',
          profileId: 'profile-1',
          clientId: 'device-1',
          data: remoteSup.toJson(),
          version: 3,
          timestamp: 3000,
        ),
      ];

      final result = await syncService.applyChanges('profile-1', changes);
      expect(result.isSuccess, true);

      final pullResult = result.valueOrNull!;
      expect(pullResult.pulledCount, 3);
      expect(pullResult.appliedCount, 2); // insert + update
      expect(pullResult.conflictCount, 1); // dirty local
      expect(pullResult.conflicts.length, 1);
      expect(pullResult.latestVersion, 3);
    });
  });

  // ===========================================================================
  // getConflictCount
  // ===========================================================================

  group('getConflictCount', () {
    test('delegates to conflictDao.countUnresolved', () async {
      when(
        mockConflictDao.countUnresolved('profile-1'),
      ).thenAnswer((_) async => const Success(3));

      final result = await syncService.getConflictCount('profile-1');
      expect(result.isSuccess, true);
      expect(result.valueOrNull, 3);
      verify(mockConflictDao.countUnresolved('profile-1')).called(1);
    });

    test('returns zero when no conflicts', () async {
      when(
        mockConflictDao.countUnresolved('profile-1'),
      ).thenAnswer((_) async => const Success(0));

      final result = await syncService.getConflictCount('profile-1');
      expect(result.isSuccess, true);
      expect(result.valueOrNull, 0);
    });

    test('returns failure when DAO fails', () async {
      when(mockConflictDao.countUnresolved('profile-1')).thenAnswer(
        (_) async => Failure(
          DatabaseError.queryFailed(
            'sync_conflicts',
            'db error',
            StackTrace.current,
          ),
        ),
      );

      final result = await syncService.getConflictCount('profile-1');
      expect(result.isFailure, true);
    });
  });

  // ===========================================================================
  // resolveConflict
  // ===========================================================================

  group('resolveConflict', () {
    late SyncConflict testConflict;

    setUp(() {
      final localSup = _testSupplement();
      final remoteSup = _testSupplement(isDirty: false, syncVersion: 2);
      testConflict = SyncConflict(
        id: 'conflict-1',
        entityType: 'supplements',
        entityId: 'sup-1',
        profileId: 'profile-1',
        localVersion: 1,
        remoteVersion: 2,
        localData: localSup.toJson(),
        remoteData: remoteSup.toJson(),
        detectedAt: 1000,
      );

      when(
        mockConflictDao.getById('conflict-1'),
      ).thenAnswer((_) async => Success(testConflict));
      when(
        mockConflictDao.markResolved(any, any, any),
      ).thenAnswer((_) async => const Success(null));
      when(
        mockRepo.getById('sup-1'),
      ).thenAnswer((_) async => Success(_testSupplement()));
      when(
        mockRepo.update(any, markDirty: anyNamed('markDirty')),
      ).thenAnswer((_) async => Success(_testSupplement()));
    });

    test(
      'keepLocal clears conflict on entity and marks conflict resolved',
      () async {
        final result = await syncService.resolveConflict(
          'conflict-1',
          ConflictResolutionType.keepLocal,
        );

        expect(result.isSuccess, true);
        // clearEntityConflict calls update with cleared metadata
        verify(
          mockRepo.update(any, markDirty: anyNamed('markDirty')),
        ).called(1);
        // Conflict row marked resolved with keepLocal
        verify(
          mockConflictDao.markResolved(
            'conflict-1',
            ConflictResolutionType.keepLocal,
            any,
          ),
        ).called(1);
      },
    );

    test(
      'keepRemote overwrites local entity and marks conflict resolved',
      () async {
        final result = await syncService.resolveConflict(
          'conflict-1',
          ConflictResolutionType.keepRemote,
        );

        expect(result.isSuccess, true);
        // Remote entity written with markDirty:false
        verify(
          mockRepo.update(any, markDirty: anyNamed('markDirty')),
        ).called(1);
        verify(
          mockConflictDao.markResolved(
            'conflict-1',
            ConflictResolutionType.keepRemote,
            any,
          ),
        ).called(1);
      },
    );

    test('returns failure when conflict not found', () async {
      when(mockConflictDao.getById('missing-id')).thenAnswer(
        (_) async =>
            Failure(DatabaseError.notFound('SyncConflict', 'missing-id')),
      );

      final result = await syncService.resolveConflict(
        'missing-id',
        ConflictResolutionType.keepLocal,
      );

      expect(result.isFailure, true);
    });

    test('returns failure when adapter not found for entity type', () async {
      const unknownConflict = SyncConflict(
        id: 'conflict-2',
        entityType: 'unknown_table',
        entityId: 'ent-1',
        profileId: 'profile-1',
        localVersion: 1,
        remoteVersion: 2,
        localData: {},
        remoteData: {},
        detectedAt: 1000,
      );
      when(
        mockConflictDao.getById('conflict-2'),
      ).thenAnswer((_) async => const Success(unknownConflict));

      final result = await syncService.resolveConflict(
        'conflict-2',
        ConflictResolutionType.keepLocal,
      );

      expect(result.isFailure, true);
    });
  });
}
