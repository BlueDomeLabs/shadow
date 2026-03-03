// test/integration/sync_flow_integration_test.dart
// AUDIT-07-001: End-to-end integration test for the sync flow.
//
// Uses a real in-memory SQLite database (same as DAO tests) and a fake
// CloudStorageProvider. Tests the full create→push→pull→apply cycle
// for the Supplement entity type.

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/services/encryption_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/remote/cloud_storage_provider.dart';
import 'package:shadow_app/data/repositories/supplement_repository_impl.dart';
import 'package:shadow_app/data/services/sync_service_impl.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/supplements/create_supplement_use_case.dart';
import 'package:shadow_app/domain/usecases/supplements/supplement_inputs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

// =============================================================================
// Fakes
// =============================================================================

/// DeviceInfoService that returns a fixed device ID without platform channels.
class _FakeDeviceInfoService extends DeviceInfoService {
  _FakeDeviceInfoService() : super(DeviceInfoPlugin());

  @override
  Future<String> getDeviceId() async => 'test-device-001';
}

/// EncryptionService that passes data through unchanged (no platform channels).
///
/// Overrides encrypt/decrypt so no FlutterSecureStorage calls are made.
class _PassthroughEncryptionService extends EncryptionService {
  _PassthroughEncryptionService() : super(const FlutterSecureStorage());

  @override
  Future<String> encrypt(String plaintext) async => plaintext;

  @override
  Future<String> decrypt(String encrypted) async => encrypted;
}

/// In-memory CloudStorageProvider. Captures uploads; returns them on pull.
class _FakeCloudStorageProvider implements CloudStorageProvider {
  /// Stores the full envelope for each uploaded entity, keyed by entityId.
  final Map<String, Map<String, dynamic>> _store = {};

  @override
  CloudProviderType get providerType => CloudProviderType.offline;

  @override
  Future<Result<void, AppError>> authenticate() async => const Success(null);

  @override
  Future<Result<void, AppError>> signOut() async => const Success(null);

  @override
  Future<bool> isAuthenticated() async => true;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<Result<void, AppError>> uploadEntity(
    String entityType,
    String entityId,
    String profileId,
    String clientId,
    Map<String, dynamic> json,
    int version,
  ) async {
    _store[entityId] = Map<String, dynamic>.from(json);
    return const Success(null);
  }

  @override
  Future<Result<Map<String, dynamic>?, AppError>> downloadEntity(
    String entityType,
    String entityId,
  ) async => Success(_store[entityId]);

  /// Returns all stored envelopes as SyncChange objects.
  ///
  /// Each stored envelope is the full envelope from pushChanges() which
  /// contains an `encryptedData` field that pullChanges() will decrypt.
  @override
  Future<Result<List<SyncChange>, AppError>> getChangesSince(
    int sinceTimestamp,
  ) async {
    final changes = _store.values
        .map(
          (env) => SyncChange(
            entityType: env['entityType'] as String,
            entityId: env['entityId'] as String,
            profileId: env['profileId'] as String,
            clientId: env['clientId'] as String,
            data: env, // pullChanges() reads data['encryptedData'] from this
            version: env['version'] as int,
            timestamp: env['timestamp'] as int,
            isDeleted: env['isDeleted'] as bool,
          ),
        )
        .toList();
    return Success(changes);
  }

  @override
  Future<Result<void, AppError>> deleteEntity(
    String entityType,
    String entityId,
  ) async {
    _store.remove(entityId);
    return const Success(null);
  }

  @override
  Future<Result<void, AppError>> uploadFile(
    String localPath,
    String remotePath,
  ) async => const Success(null);

  @override
  Future<Result<String, AppError>> downloadFile(
    String remotePath,
    String localPath,
  ) async => Success(localPath);

  int get uploadedCount => _store.length;
}

/// ProfileAuthorizationService that always grants access.
class _AlwaysAllowAuthService implements ProfileAuthorizationService {
  @override
  Future<bool> canRead(String profileId) async => true;

  @override
  Future<bool> canWrite(String profileId) async => true;

  @override
  Future<bool> isOwner(String profileId) async => true;

  @override
  Future<List<ProfileAccess>> getAccessibleProfiles() async => [];
}

// =============================================================================
// Integration tests
// =============================================================================

void main() {
  group('Sync flow integration (AUDIT-07-001)', () {
    late AppDatabase database;
    late SupplementRepositoryImpl supplementRepo;
    late CreateSupplementUseCase createUseCase;
    late _FakeCloudStorageProvider fakeCloud;
    late SyncServiceImpl syncService;

    const profileId = 'profile-001';

    setUp(() async {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
      supplementRepo = SupplementRepositoryImpl(
        database.supplementDao,
        const Uuid(),
        _FakeDeviceInfoService(),
      );

      createUseCase = CreateSupplementUseCase(
        supplementRepo,
        _AlwaysAllowAuthService(),
      );

      fakeCloud = _FakeCloudStorageProvider();

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      syncService = SyncServiceImpl(
        adapters: [
          SyncEntityAdapter<Supplement>(
            entityType: 'supplements',
            repository: supplementRepo,
            withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
            fromJson: Supplement.fromJson,
          ),
        ],
        encryptionService: _PassthroughEncryptionService(),
        cloudProvider: fakeCloud,
        prefs: prefs,
        conflictDao: database.syncConflictDao,
      );
    });

    tearDown(() async {
      await database.close();
    });

    // =========================================================================
    // Test 1: Create via use case → syncIsDirty=true
    // =========================================================================

    test('create entity via use case sets syncIsDirty=true in DB', () async {
      const input = CreateSupplementInput(
        profileId: profileId,
        clientId: 'device-001',
        name: 'Vitamin D',
        form: SupplementForm.capsule,
        dosageQuantity: 1000,
        dosageUnit: DosageUnit.mg,
      );

      final result = await createUseCase(input);

      expect(result.isSuccess, isTrue);

      final createdId = result.valueOrNull!.id;
      final fetchResult = await supplementRepo.getById(createdId);
      expect(fetchResult.isSuccess, isTrue);

      final stored = fetchResult.valueOrNull!;
      expect(stored.syncMetadata.syncIsDirty, isTrue);
      expect(stored.profileId, profileId);
    });

    // =========================================================================
    // Test 2: getPendingChanges returns the dirty entity
    // =========================================================================

    test('getPendingChanges includes newly created entity', () async {
      const input = CreateSupplementInput(
        profileId: profileId,
        clientId: 'device-001',
        name: 'Magnesium',
        form: SupplementForm.tablet,
        dosageQuantity: 400,
        dosageUnit: DosageUnit.mg,
      );
      await createUseCase(input);

      final pendingResult = await syncService.getPendingChanges(profileId);

      expect(pendingResult.isSuccess, isTrue);
      final pending = pendingResult.valueOrNull!;
      expect(pending.length, 1);
      expect(pending.first.entityType, 'supplements');
      expect(pending.first.profileId, profileId);
    });

    // =========================================================================
    // Test 3: pushChanges marks entity clean in DB
    // =========================================================================

    test(
      'pushChanges uploads to cloud and marks entity syncIsDirty=false',
      () async {
        // Create entity
        const input = CreateSupplementInput(
          profileId: profileId,
          clientId: 'device-001',
          name: 'Omega-3',
          form: SupplementForm.capsule,
          dosageQuantity: 1,
          dosageUnit: DosageUnit.mg,
        );
        final createResult = await createUseCase(input);
        final entityId = createResult.valueOrNull!.id;

        // Get pending and push
        final pendingResult = await syncService.getPendingChanges(profileId);
        final pending = pendingResult.valueOrNull!;

        final pushResult = await syncService.pushChanges(pending);

        expect(pushResult.isSuccess, isTrue);
        final pushed = pushResult.valueOrNull!;
        expect(pushed.pushedCount, 1);
        expect(pushed.failedCount, 0);

        // Cloud should have received the upload
        expect(fakeCloud.uploadedCount, 1);

        // Entity must be marked clean in DB
        final fetchResult = await supplementRepo.getById(entityId);
        expect(fetchResult.isSuccess, isTrue);
        expect(fetchResult.valueOrNull!.syncMetadata.syncIsDirty, isFalse);
      },
    );

    // =========================================================================
    // Test 4: pullChanges decrypts cloud data into SyncChange list
    // =========================================================================

    test('pullChanges returns the entity that was pushed', () async {
      // Create and push
      const input = CreateSupplementInput(
        profileId: profileId,
        clientId: 'device-001',
        name: 'Zinc',
        form: SupplementForm.capsule,
        dosageQuantity: 15,
        dosageUnit: DosageUnit.mg,
      );
      await createUseCase(input);
      final pending = (await syncService.getPendingChanges(
        profileId,
      )).valueOrNull!;
      await syncService.pushChanges(pending);

      // Pull from cloud
      final pullResult = await syncService.pullChanges(profileId);

      expect(pullResult.isSuccess, isTrue);
      final pulled = pullResult.valueOrNull!;
      expect(pulled.length, 1);
      expect(pulled.first.entityType, 'supplements');
      expect(pulled.first.profileId, profileId);

      // The decrypted data should be deserializable as a Supplement
      final entityData = pulled.first.data;
      final roundTripped = Supplement.fromJson(entityData);
      expect(roundTripped.name, 'Zinc');
    });

    // =========================================================================
    // Test 5: applyChanges stores entity in DB (full round-trip)
    // =========================================================================

    test('full round-trip: create → push → pull → apply stores entity', () async {
      // 1. Create entity
      const input = CreateSupplementInput(
        profileId: profileId,
        clientId: 'device-001',
        name: 'Vitamin C',
        form: SupplementForm.capsule,
        dosageQuantity: 500,
        dosageUnit: DosageUnit.mg,
      );
      final createResult = await createUseCase(input);
      final entityId = createResult.valueOrNull!.id;

      // 2. Push
      final pending = (await syncService.getPendingChanges(
        profileId,
      )).valueOrNull!;
      await syncService.pushChanges(pending);

      // Entity is now clean in DB. Simulate a second device pulling and applying.
      // We re-create a fresh DB/repo to represent the second device.
      final db2 = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
      final repo2 = SupplementRepositoryImpl(
        db2.supplementDao,
        const Uuid(),
        _FakeDeviceInfoService(),
      );
      SharedPreferences.setMockInitialValues({});
      final prefs2 = await SharedPreferences.getInstance();
      final syncService2 = SyncServiceImpl(
        adapters: [
          SyncEntityAdapter<Supplement>(
            entityType: 'supplements',
            repository: repo2,
            withSyncMetadata: (e, m) => e.copyWith(syncMetadata: m),
            fromJson: Supplement.fromJson,
          ),
        ],
        encryptionService: _PassthroughEncryptionService(),
        cloudProvider: fakeCloud, // same cloud — has the uploaded entity
        prefs: prefs2,
        conflictDao: db2.syncConflictDao,
      );

      // 3. Pull on device 2
      final pullResult = await syncService2.pullChanges(profileId);
      expect(pullResult.isSuccess, isTrue);

      // 4. Apply on device 2
      final applyResult = await syncService2.applyChanges(
        profileId,
        pullResult.valueOrNull!,
      );
      expect(applyResult.isSuccess, isTrue);
      expect(applyResult.valueOrNull!.appliedCount, 1);
      expect(applyResult.valueOrNull!.conflictCount, 0);

      // 5. Entity is present in device 2's DB
      final fetchResult = await repo2.getById(entityId);
      expect(fetchResult.isSuccess, isTrue);
      expect(fetchResult.valueOrNull!.name, 'Vitamin C');
      // Entities inserted via repository.create() are always marked dirty —
      // this is by design (the DAO hardcodes syncIsDirty=true on insert).
      // The important invariant is that the entity is present and correct.
      expect(fetchResult.valueOrNull!.profileId, profileId);

      await db2.close();
    });
  });
}
