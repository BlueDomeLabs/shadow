# Shadow Testing Strategy

**Version:** 1.0
**Last Updated:** January 30, 2026
**Philosophy:** 100% Internal Testing - Every Feature Verified Before Commit

---

## Overview

Shadow follows a rigorous testing strategy where every feature is fully tested before being committed. This document defines the testing philosophy, patterns, and requirements for all code contributions.

> **IMPLEMENTATION STATUS (v1.0, January 2026):** This document defines the complete testing strategy and requirements. Test implementation is pending Phase 1 development. All specified coverage targets and patterns are MANDATORY once development begins.

---

## 1. Testing Philosophy

### 1.1 Core Principles

1. **Test First**: Write tests alongside implementation, not as an afterthought
2. **100% Internal Testing**: Every feature verified before commit
3. **Test Behavior, Not Implementation**: Focus on what code does, not how
4. **Readable Tests**: Tests serve as documentation
5. **Fast Feedback**: Tests should run quickly
6. **Isolated Tests**: No test should depend on another

### 1.2 The Test-As-You-Go Rule

**MANDATORY**: For every feature or bug fix:

```
1. Write failing test(s) for the requirement
2. Implement the minimum code to pass
3. Refactor while keeping tests green
4. Commit with passing tests
```

This is not optional. PRs without adequate tests will be rejected.

---

## 2. Testing Pyramid

```
                    ┌─────────┐
                    │   E2E   │  Few, expensive, slow
                    │  Tests  │
                   ─┴─────────┴─
                  ┌─────────────┐
                  │ Integration │  Some, moderate cost
                  │    Tests    │
                 ─┴─────────────┴─
                ┌─────────────────┐
                │   Widget Tests  │  More, moderate speed
               ─┴─────────────────┴─
              ┌─────────────────────┐
              │     Unit Tests      │  Many, fast, cheap
             ─┴─────────────────────┴─
```

### 2.1 Test Distribution

> **Coverage Requirement:** All layers require **100% coverage** per Section 9.1 and 02_CODING_STANDARDS.md Section 10.3.

| Test Type | Coverage Target | Focus |
|-----------|-----------------|-------|
| Unit Tests | 100% | Entities, Models, Utilities |
| Data Source Tests | 100% | SQLite operations |
| Repository Tests | 100% | Business logic |
| Provider Tests | 100% | State management |
| Widget Tests | 100% | UI components |
| Screen Tests | 100% | Full screen behavior |
| Integration Tests | Key flows | End-to-end scenarios |

---

## 3. Unit Testing

### 3.1 Entity Tests

Test all entity behavior including construction, copyWith, and computed properties.

```dart
// test/domain/entities/supplement_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/supplement.dart';

void main() {
  group('Supplement', () {
    late Supplement supplement;
    late SyncMetadata syncMetadata;

    setUp(() {
      syncMetadata = SyncMetadata(
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
        syncStatus: SyncStatus.pending,
        version: 1,
        createdByDeviceId: 'test-device',
        lastModifiedByDeviceId: 'test-device',
      );

      supplement = Supplement(
        id: 'supp-001',
        profileId: 'profile-001',
        name: 'Vitamin D',
        form: SupplementForm.capsule,
        syncMetadata: syncMetadata,
      );
    });

    group('constructor', () {
      test('constructor_withRequiredFields_createsValidInstance', () {
        expect(supplement.id, 'supp-001');
        expect(supplement.profileId, 'profile-001');
        expect(supplement.name, 'Vitamin D');
        expect(supplement.form, SupplementForm.capsule);
      });

      test('constructor_withOptionalFields_acceptsNullValues', () {
        final minimal = Supplement(
          id: 'supp-002',
          profileId: 'profile-001',
          name: 'Test',
          form: SupplementForm.tablet,
          dosageAmount: null,  // Optional
          syncMetadata: syncMetadata,
        );

        expect(minimal.dosageAmount, isNull);
      });
    });

    group('copyWith', () {
      test('copyWith_noParameters_returnsIdenticalCopy', () {
        final copy = supplement.copyWith();

        expect(copy.id, supplement.id);
        expect(copy.name, supplement.name);
        expect(copy, isNot(same(supplement)));  // Different instance
      });

      test('copyWith_withName_returnsUpdatedCopy', () {
        final updated = supplement.copyWith(name: 'Vitamin C');

        expect(updated.name, 'Vitamin C');
        expect(updated.id, supplement.id);  // Other fields unchanged
      });

      test('copyWith_withSyncMetadata_returnsUpdatedCopy', () {
        final newMetadata = syncMetadata.copyWith(version: 2);
        final updated = supplement.copyWith(syncMetadata: newMetadata);

        expect(updated.syncMetadata.version, 2);
      });
    });

    group('computed properties', () {
      test('isDeleted_withDeletedAt_returnsTrue', () {
        final deleted = supplement.copyWith(
          syncMetadata: syncMetadata.copyWith(
            deletedAt: DateTime.now(),
          ),
        );

        expect(deleted.syncMetadata.isDeleted, isTrue);
      });

      test('isDeleted_withoutDeletedAt_returnsFalse', () {
        expect(supplement.syncMetadata.isDeleted, isFalse);
      });
    });
  });
}
```

### 3.2 Model Tests

Test serialization and deserialization thoroughly.

```dart
// test/data/models/supplement_model_test.dart

void main() {
  group('SupplementModel', () {
    group('fromMap', () {
      test('fromMap_withAllFields_createsModelCorrectly', () {
        final map = {
          'id': 'supp-001',
          'profile_id': 'profile-001',
          'name': 'Vitamin D',
          'supplement_form': 'capsule',
          'dosage_amount': 5000.0,
          'dosage_unit': 'iu',
          'sync_created_at': 1704067200000,  // 2026-01-01T00:00:00Z epoch ms
          'sync_updated_at': 1704067200000,
          'sync_deleted_at': null,
          'sync_status': 0,  // 0=pending
          'sync_version': 1,
          'sync_is_dirty': 1,
          'sync_created_by_device_id': 'device-001',
          'sync_last_modified_by_device_id': 'device-001',
        };

        final model = SupplementModel.fromMap(map);

        expect(model.id, 'supp-001');
        expect(model.name, 'Vitamin D');
        expect(model.dosageAmount, 5000.0);
        expect(model.form, SupplementForm.capsule);
      });

      test('fromMap_withNullOptionalFields_handlesGracefully', () {
        final map = {
          'id': 'supp-001',
          'profile_id': 'profile-001',
          'name': 'Test',
          'supplement_form': 'tablet',
          'dosage_amount': null,
          'dosage_unit': null,
          // ... required sync fields
        };

        final model = SupplementModel.fromMap(map);

        expect(model.dosageAmount, isNull);
        expect(model.dosageUnit, isNull);
      });

      test('fromMap_withMissingSyncFields_usesDefaults', () {
        final map = {
          'id': 'supp-001',
          'profile_id': 'profile-001',
          'name': 'Test',
          'supplement_form': 'tablet',
          // Missing sync fields
        };

        final model = SupplementModel.fromMap(map);

        expect(model.syncStatus, SyncStatus.pending);
        expect(model.version, 1);
      });
    });

    group('toMap', () {
      test('toMap_withAllFields_createsMapCorrectly', () {
        final model = SupplementModel(
          id: 'supp-001',
          profileId: 'profile-001',
          name: 'Vitamin D',
          form: SupplementForm.capsule,
          // ... all fields
        );

        final map = model.toMap();

        expect(map['id'], 'supp-001');
        expect(map['name'], 'Vitamin D');
        expect(map['supplement_form'], 'capsule');
        expect(map['sync_is_dirty'], 1);
      });
    });

    group('roundtrip', () {
      test('toMap_thenFromMap_preservesAllData', () {
        final original = SupplementModel(/* all fields */);

        final map = original.toMap();
        final restored = SupplementModel.fromMap(map);

        expect(restored.id, original.id);
        expect(restored.name, original.name);
        // ... verify all fields
      });
    });
  });
}
```

### 3.3 Service Tests

```dart
// test/core/services/encryption_service_test.dart

void main() {
  group('EncryptionService', () {
    late EncryptionService service;

    setUp(() {
      service = EncryptionService();
    });

    group('encrypt and decrypt', () {
      test('encrypt_thenDecrypt_returnsOriginalText', () {
        const original = 'Hello, World!';

        final encrypted = service.encrypt(original);
        final decrypted = service.decrypt(encrypted);

        expect(decrypted, original);
        expect(encrypted, isNot(original));
      });

      test('encrypt_sameText_producesDifferentCiphertext', () {
        const text = 'Same text';

        final encrypted1 = service.encrypt(text);
        final encrypted2 = service.encrypt(text);

        // IV should be different each time
        expect(encrypted1, isNot(encrypted2));
      });

      test('encrypt_emptyString_handlesCorrectly', () {
        const empty = '';

        final encrypted = service.encrypt(empty);
        final decrypted = service.decrypt(encrypted);

        expect(decrypted, empty);
      });

      test('decrypt_invalidCiphertext_throwsException', () {
        expect(
          () => service.decrypt('not-valid-ciphertext'),
          throwsA(isA<EncryptionException>()),
        );
      });
    });
  });
}
```

---

## 4. Data Source Testing

### 4.1 SQLite Data Source Tests

Use an in-memory database for fast, isolated tests.

```dart
// test/data/datasources/local/supplement_local_datasource_test.dart

void main() {
  group('SupplementLocalDataSourceImpl', () {
    late Database database;
    late SupplementLocalDataSourceImpl dataSource;

    setUp(() async {
      // Create in-memory database
      database = await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE supplements (
              id TEXT PRIMARY KEY,
              profile_id TEXT NOT NULL,
              name TEXT NOT NULL,
              -- ... other columns
            )
          ''');
        },
      );

      final dbHelper = MockDatabaseHelper();
      when(dbHelper.database).thenAnswer((_) async => database);

      dataSource = SupplementLocalDataSourceImpl(dbHelper);
    });

    tearDown(() async {
      await database.close();
    });

    group('insertSupplement', () {
      test('insertSupplement_validModel_insertsSuccessfully', () async {
        final model = SupplementModel(/* test data */);

        await dataSource.insertSupplement(model);

        final result = await database.query('supplements');
        expect(result.length, 1);
        expect(result.first['id'], model.id);
      });

      test('insertSupplement_duplicateId_throwsDatabaseException', () async {
        final model = SupplementModel(/* test data */);

        await dataSource.insertSupplement(model);

        expect(
          () => dataSource.insertSupplement(model),
          throwsA(isA<DatabaseException>()),
        );
      });
    });

    group('getAllSupplements', () {
      test('getAllSupplements_withProfileId_returnsFilteredList', () async {
        // Insert test data for different profiles
        await _insertTestSupplement(database, profileId: 'profile-1');
        await _insertTestSupplement(database, profileId: 'profile-1');
        await _insertTestSupplement(database, profileId: 'profile-2');

        final result = await dataSource.getAllSupplements(
          profileId: 'profile-1',
        );

        expect(result.length, 2);
        expect(result.every((s) => s.profileId == 'profile-1'), isTrue);
      });

      test('getAllSupplements_excludesDeleted', () async {
        await _insertTestSupplement(database, isDeleted: false);
        await _insertTestSupplement(database, isDeleted: true);

        final result = await dataSource.getAllSupplements();

        expect(result.length, 1);
      });

      test('getAllSupplements_withPagination_respectsLimitAndOffset', () async {
        // Insert 10 test supplements
        for (var i = 0; i < 10; i++) {
          await _insertTestSupplement(database);
        }

        final result = await dataSource.getAllSupplements(
          limit: 5,
          offset: 2,
        );

        expect(result.length, 5);
      });
    });
  });
}
```

---

## 5. Repository Testing

### 5.1 Repository Implementation Tests

```dart
// test/data/repositories/supplement_repository_impl_test.dart

void main() {
  group('SupplementRepositoryImpl', () {
    late MockSupplementLocalDataSource mockDataSource;
    late MockUuid mockUuid;
    late MockDeviceInfoService mockDeviceInfoService;
    late SupplementRepositoryImpl repository;

    setUp(() {
      mockDataSource = MockSupplementLocalDataSource();
      mockUuid = MockUuid();
      mockDeviceInfoService = MockDeviceInfoService();

      when(mockUuid.v4()).thenReturn('generated-uuid');
      when(mockDeviceInfoService.getDeviceId())
          .thenAnswer((_) async => 'test-device');

      repository = SupplementRepositoryImpl(
        mockDataSource,
        mockUuid,
        mockDeviceInfoService,
      );
    });

    group('addSupplement', () {
      test('addSupplement_withNoId_generatesUuid', () async {
        final supplement = Supplement(
          id: '',  // Empty ID
          profileId: 'profile-001',
          name: 'Test',
          form: SupplementForm.tablet,
          syncMetadata: SyncMetadata.empty(),
        );

        when(mockDataSource.insertSupplement(any))
            .thenAnswer((_) async {});

        await repository.addSupplement(supplement);

        final captured = verify(
          mockDataSource.insertSupplement(captureAny),
        ).captured.single as SupplementModel;

        expect(captured.id, 'generated-uuid');
      });

      test('addSupplement_createsSyncMetadata', () async {
        final supplement = Supplement(/* test data */);

        when(mockDataSource.insertSupplement(any))
            .thenAnswer((_) async {});

        await repository.addSupplement(supplement);

        final captured = verify(
          mockDataSource.insertSupplement(captureAny),
        ).captured.single as SupplementModel;

        expect(captured.syncStatus, SyncStatus.pending);
        expect(captured.createdByDeviceId, 'test-device');
        expect(captured.version, 1);
      });
    });

    group('updateSupplement', () {
      test('updateSupplement_withMarkDirtyTrue_incrementsVersion', () async {
        final existing = Supplement(
          id: 'supp-001',
          syncMetadata: SyncMetadata(version: 1),
        );

        when(mockDataSource.updateSupplement(any))
            .thenAnswer((_) async {});

        await repository.updateSupplement(existing, markDirty: true);

        final captured = verify(
          mockDataSource.updateSupplement(captureAny),
        ).captured.single as SupplementModel;

        expect(captured.version, 2);
        expect(captured.syncStatus, SyncStatus.pending);
      });

      test('updateSupplement_withMarkDirtyFalse_preservesVersion', () async {
        final existing = Supplement(
          id: 'supp-001',
          syncMetadata: SyncMetadata(version: 1, syncStatus: SyncStatus.synced),
        );

        when(mockDataSource.updateSupplement(any))
            .thenAnswer((_) async {});

        await repository.updateSupplement(existing, markDirty: false);

        final captured = verify(
          mockDataSource.updateSupplement(captureAny),
        ).captured.single as SupplementModel;

        expect(captured.version, 1);  // Unchanged
      });
    });

    group('deleteSupplement', () {
      test('deleteSupplement_softDeletes', () async {
        final existing = Supplement(id: 'supp-001');

        when(mockDataSource.getSupplement('supp-001'))
            .thenAnswer((_) async => existing);
        when(mockDataSource.updateSupplement(any))
            .thenAnswer((_) async {});

        await repository.deleteSupplement('supp-001');

        final captured = verify(
          mockDataSource.updateSupplement(captureAny),
        ).captured.single as SupplementModel;

        expect(captured.deletedAt, isNotNull);
        expect(captured.syncStatus, SyncStatus.pending);
      });
    });
  });
}
```

---

## 6. Provider Testing

### 6.1 State Management Tests

```dart
// test/presentation/providers/supplement_provider_test.dart

void main() {
  group('SupplementProvider', () {
    late MockSupplementRepository mockRepository;
    late MockProfileAuthorizationService mockAuthService;
    late SupplementProvider provider;

    setUp(() {
      mockRepository = MockSupplementRepository();
      mockAuthService = MockProfileAuthorizationService();

      when(mockAuthService.canWrite).thenReturn(true);

      provider = SupplementProvider(
        mockRepository,
        mockAuthService,
      );
    });

    group('loadSupplements', () {
      test('loadSupplements_setsLoadingStateDuringFetch', () async {
        when(mockRepository.getAllSupplements(profileId: any))
            .thenAnswer((_) async {
              // Verify loading state during operation
              expect(provider.isLoading, isTrue);
              return [];
            });

        provider.setCurrentProfileId('profile-001');
        await provider.loadSupplements();

        expect(provider.isLoading, isFalse);
      });

      test('loadSupplements_populatesSupplementsList', () async {
        final testSupplements = [
          Supplement(id: 'supp-1', name: 'Vitamin A'),
          Supplement(id: 'supp-2', name: 'Vitamin B'),
        ];

        when(mockRepository.getAllSupplements(profileId: 'profile-001'))
            .thenAnswer((_) async => testSupplements);

        provider.setCurrentProfileId('profile-001');
        await provider.loadSupplements();

        expect(provider.supplements.length, 2);
        expect(provider.supplements[0].name, 'Vitamin A');
      });

      test('loadSupplements_onError_setsErrorMessage', () async {
        when(mockRepository.getAllSupplements(profileId: any))
            .thenThrow(Exception('Database error'));

        provider.setCurrentProfileId('profile-001');
        await provider.loadSupplements();

        expect(provider.errorMessage, isNotNull);
        expect(provider.supplements, isEmpty);
      });
    });

    group('addSupplement', () {
      test('addSupplement_withWriteAccess_addsSuccessfully', () async {
        final supplement = Supplement(name: 'Test');

        when(mockRepository.addSupplement(any)).thenAnswer((_) async {});
        when(mockRepository.getAllSupplements(profileId: any))
            .thenAnswer((_) async => [supplement]);

        provider.setCurrentProfileId('profile-001');
        await provider.addSupplement(supplement);

        verify(mockRepository.addSupplement(supplement)).called(1);
      });

      test('addSupplement_withoutWriteAccess_throwsUnauthorized', () async {
        when(mockAuthService.canWrite).thenReturn(false);

        final supplement = Supplement(name: 'Test');

        expect(
          () => provider.addSupplement(supplement),
          throwsA(isA<UnauthorizedException>()),
        );
      });
    });
  });
}
```

---

## 7. Widget Testing

### 7.1 Widget Test Structure

```dart
// test/presentation/widgets/supplement_card_test.dart

void main() {
  group('SupplementCard', () {
    late Supplement testSupplement;

    setUp(() {
      testSupplement = Supplement(
        id: 'supp-001',
        name: 'Vitamin D',
        form: SupplementForm.capsule,
        dosageAmount: 5000,
        dosageUnit: DosageUnit.iu,
      );
    });

    testWidgets('displays supplement name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SupplementCard(supplement: testSupplement),
          ),
        ),
      );

      expect(find.text('Vitamin D'), findsOneWidget);
    });

    testWidgets('displays dosage information', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SupplementCard(supplement: testSupplement),
          ),
        ),
      );

      expect(find.text('5000 IU'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SupplementCard(
              supplement: testSupplement,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SupplementCard));

      expect(tapped, isTrue);
    });

    testWidgets('has correct accessibility semantics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SupplementCard(
              supplement: testSupplement,
              onTap: () {},
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(SupplementCard));

      expect(semantics.label, contains('Vitamin D'));
      expect(semantics.hasAction(SemanticsAction.tap), isTrue);
    });
  });
}
```

---

## 8. Integration Testing

### 8.0 Test Directory Structure

```
test/
├── core/
│   ├── services/         # Service unit tests
│   └── utils/            # Utility unit tests
├── domain/
│   └── entities/         # Entity unit tests
├── data/
│   ├── repositories/     # Repository unit tests
│   ├── datasources/      # Data source unit tests
│   └── models/           # Model unit tests
├── presentation/
│   ├── providers/        # Provider unit tests
│   └── widgets/          # Widget unit tests
├── integration/          # Fast integration tests (mocked backend)
│   ├── supplement_flow_test.dart
│   ├── sync_flow_test.dart
│   └── auth_flow_test.dart
└── performance/          # Performance benchmark tests

integration_test/         # Flutter integration tests (on device/emulator)
├── app_test.dart         # Full app flow tests
├── user_journey_test.dart
└── performance_test.dart
```

**Distinction:**
- `test/integration/` - Run with `flutter test`, use mocks, fast
- `integration_test/` - Run with `flutter drive`, test real UI on device

### 8.1 User Flow Tests

```dart
// integration_test/supplement_flow_test.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Supplement Management Flow', () {
    testWidgets('user can add and view a supplement', (tester) async {
      await tester.pumpWidget(const ShadowApp());
      await tester.pumpAndSettle();

      // Navigate to supplements tab
      await tester.tap(find.byIcon(Icons.medication));
      await tester.pumpAndSettle();

      // Tap add button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Fill in form
      await tester.enterText(
        find.byKey(Key('supplement_name_field')),
        'Integration Test Vitamin',
      );
      await tester.pumpAndSettle();

      // Save
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify supplement appears in list
      expect(find.text('Integration Test Vitamin'), findsOneWidget);
    });
  });
}
```

### 8.2 Network Error Scenario Tests

Test how the app handles network failures, timeouts, and error conditions.

```dart
// integration_test/network_error_test.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Network Error Handling', () {
    testWidgets('timeout shows error message and retry button', (tester) async {
      // Setup: Configure mock HTTP client to timeout
      final mockClient = MockHttpClient();
      when(mockClient.get(any)).thenThrow(
        TimeoutException('Connection timed out'),
      );

      await tester.pumpWidget(
        ShadowApp(httpClient: mockClient),
      );
      await tester.pumpAndSettle();

      // Trigger sync
      await tester.tap(find.byIcon(Icons.sync));
      await tester.pumpAndSettle(const Duration(seconds: 35));

      // Verify error message shown
      expect(find.text('Connection timed out'), findsOneWidget);

      // Verify retry button present
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('offline mode shows offline indicator', (tester) async {
      // Setup: Configure connectivity as offline
      final mockConnectivity = MockConnectivity();
      when(mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => ConnectivityResult.none,
      );

      await tester.pumpWidget(
        ShadowApp(connectivity: mockConnectivity),
      );
      await tester.pumpAndSettle();

      // Verify offline indicator shown
      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
      expect(find.text('Offline'), findsOneWidget);
    });

    testWidgets('sync failure shows pending changes count', (tester) async {
      // Setup: First create local data, then fail sync
      // ...test implementation...

      // Verify pending count shown
      expect(find.textContaining('3 changes pending'), findsOneWidget);
    });
  });
}
```

---

## 9. Test Coverage Requirements

### 9.1 Minimum Coverage by Layer

| Layer | Minimum | Target |
|-------|---------|--------|
| Domain Entities | 100% | 100% |
| Data Models | 100% | 100% |
| Data Sources | 100% | 100% |
| Repositories | 100% | 100% |
| Providers | 100% | 100% |
| Services | 100% | 100% |
| Widgets | 100% | 100% |
| Screens | 100% | 100% |
| **Overall** | **100%** | **100%** |

### 9.2 Security Test Coverage (MANDATORY)

Security-critical components require 100% test coverage.

| Component | Minimum | Required Test Cases |
|-----------|---------|---------------------|
| OAuth Token Storage | 100% | Store, retrieve, clear, expired handling |
| Encryption Service | 100% | Encrypt/decrypt roundtrip, invalid input, key rotation |
| Input Sanitization | 100% | XSS, SQL injection, HTML injection |
| Authorization Checks | 100% | Denied access, expired, wrong profile, shared profile |
| PII Masking | 100% | All masking functions with edge cases |
| Secure Storage | 100% | Platform-specific read/write operations |
| Audit Logging | 100% | PHI access logging, immutability |

**Required Security Test Files:**

```
test/core/services/
├── oauth_service_test.dart
├── encryption_service_test.dart
├── secure_storage_service_test.dart
└── audit_log_service_test.dart

test/core/utils/
├── input_sanitizer_test.dart
└── pii_masking_test.dart

test/data/repositories/
└── authorization_test.dart
```

#### 9.2.1 OAuth Service Tests

```dart
// test/core/services/oauth_service_test.dart

void main() {
  late OAuthService service;
  late MockSecureStorage mockStorage;
  late MockHttpClient mockHttp;

  setUp(() {
    mockStorage = MockSecureStorage();
    mockHttp = MockHttpClient();
    service = OAuthService(storage: mockStorage, http: mockHttp);
  });

  group('Token Storage', () {
    test('storeTokens_savesAllTokensSeparately', () async {
      await service.storeTokens(OAuthTokens(
        accessToken: 'access123',
        refreshToken: 'refresh456',
        expiresAt: DateTime.now().add(Duration(hours: 1)),
      ));

      verify(mockStorage.write(key: 'access_token', value: 'access123')).called(1);
      verify(mockStorage.write(key: 'refresh_token', value: 'refresh456')).called(1);
      verify(mockStorage.write(key: 'token_expiry', value: any)).called(1);
    });

    test('clearTokens_removesAllTokens', () async {
      await service.clearTokens();

      verify(mockStorage.delete(key: 'access_token')).called(1);
      verify(mockStorage.delete(key: 'refresh_token')).called(1);
      verify(mockStorage.delete(key: 'token_expiry')).called(1);
      verify(mockStorage.delete(key: 'user_email')).called(1);
    });

    test('clearTokens_verifiesComplete', () async {
      when(mockStorage.read(key: 'access_token')).thenAnswer((_) async => null);

      await service.clearTokens();

      verify(mockStorage.read(key: 'access_token')).called(1);
    });
  });

  group('Token Refresh', () {
    test('refreshToken_validToken_returnsNewAccessToken', () async {
      when(mockStorage.read(key: 'refresh_token'))
          .thenAnswer((_) async => 'valid_refresh');
      when(mockHttp.post(any, body: any)).thenAnswer(
        (_) async => Response('{"access_token": "new_access"}', 200),
      );

      final result = await service.refreshToken();

      expect(result.isSuccess, isTrue);
      result.when(
        success: (tokens) => expect(tokens.accessToken, 'new_access'),
        failure: (_) => fail('Should succeed'),
      );
    });

    test('refreshToken_expiredRefreshToken_returnsAuthError', () async {
      when(mockStorage.read(key: 'refresh_token'))
          .thenAnswer((_) async => 'expired_refresh');
      when(mockHttp.post(any, body: any)).thenAnswer(
        (_) async => Response('{"error": "invalid_grant"}', 400),
      );

      final result = await service.refreshToken();

      expect(result.isFailure, isTrue);
      result.when(
        success: (_) => fail('Should fail'),
        failure: (error) => expect(error.code, 'AUTH_001'),
      );
    });

    test('needsRefresh_expiresIn4Minutes_returnsTrue', () {
      final expiry = DateTime.now().add(Duration(minutes: 4));

      expect(service.needsRefresh(expiry), isTrue);
    });

    test('needsRefresh_expiresIn10Minutes_returnsFalse', () {
      final expiry = DateTime.now().add(Duration(minutes: 10));

      expect(service.needsRefresh(expiry), isFalse);
    });
  });
}
```

#### 9.2.2 Audit Logging Tests

```dart
// test/core/services/audit_log_service_test.dart

void main() {
  late AuditLogService service;
  late MockDatabase mockDb;

  setUp(() {
    mockDb = MockDatabase();
    service = AuditLogService(database: mockDb);
  });

  group('PHI Access Logging', () {
    test('logPhiAccess_createsImmutableEntry', () async {
      await service.logPhiAccess(
        entityType: 'Supplement',
        entityId: 'supp-123',
        action: AuditAction.read,
        userId: 'user-456',
      );

      verify(mockDb.insert('audit_logs', any)).called(1);
    });

    test('logPhiAccess_recordsAllRequiredFields', () async {
      Map<String, dynamic>? capturedData;
      when(mockDb.insert('audit_logs', any)).thenAnswer((invocation) {
        capturedData = invocation.positionalArguments[1];
        return Future.value(1);
      });

      await service.logPhiAccess(
        entityType: 'Condition',
        entityId: 'cond-789',
        action: AuditAction.update,
        userId: 'user-123',
      );

      expect(capturedData, isNotNull);
      expect(capturedData!['entity_type'], 'Condition');
      expect(capturedData!['entity_id'], 'cond-789');
      expect(capturedData!['action'], 'update');
      expect(capturedData!['user_id'], isNotEmpty);
      expect(capturedData!['timestamp'], isNotNull);
      expect(capturedData!['device_id'], isNotEmpty);
    });

    test('deleteEntry_throwsAuditLogException', () async {
      expect(
        () => service.deleteEntry('entry-123'),
        throwsA(isA<AuditLogException>()),
      );
    });

    test('updateEntry_throwsAuditLogException', () async {
      expect(
        () => service.updateEntry('entry-123', any),
        throwsA(isA<AuditLogException>()),
      );
    });
  });

  group('Audit Query', () {
    test('getEntriesForEntity_returnsChronologicalList', () async {
      when(mockDb.query(any, where: any, whereArgs: any)).thenAnswer(
        (_) async => [
          {'id': '1', 'timestamp': 1000},
          {'id': '2', 'timestamp': 2000},
        ],
      );

      final entries = await service.getEntriesForEntity('Supplement', 'supp-123');

      expect(entries.length, 2);
      expect(entries.first.id, '2'); // Most recent first
    });
  });
}
```

#### 9.2.3 PII Masking Tests

```dart
// test/core/utils/pii_masking_test.dart

void main() {
  group('maskEmail', () {
    test('standardEmail_masksCorrectly', () {
      expect(maskEmail('john.doe@example.com'), 'jo***@example.com');
    });

    test('shortEmail_masksCompletely', () {
      expect(maskEmail('a@b.com'), '***@b.com');
    });

    test('invalidEmail_returnsPlaceholder', () {
      expect(maskEmail('invalid'), '***@***');
    });

    test('emptyEmail_returnsPlaceholder', () {
      expect(maskEmail(''), '***@***');
    });
  });

  group('maskPhone', () {
    test('usPhone_showsLastFour', () {
      expect(maskPhone('555-123-4567'), '***-***-4567');
    });

    test('phoneWithExtras_showsLastFour', () {
      expect(maskPhone('+1 (555) 123-4567'), '***-***-4567');
    });

    test('shortPhone_returnsPlaceholder', () {
      expect(maskPhone('123'), '***');
    });
  });

  group('maskToken', () {
    test('longToken_showsEnds', () {
      expect(maskToken('abcdefghijklmnop'), 'abc***nop');
    });

    test('shortToken_fullyRedacted', () {
      expect(maskToken('short'), '[REDACTED]');
    });
  });

  group('maskUserId', () {
    test('hashesConsistently', () {
      final hash1 = maskUserId('user-123');
      final hash2 = maskUserId('user-123');
      expect(hash1, hash2);
    });

    test('differentIds_differentHashes', () {
      final hash1 = maskUserId('user-123');
      final hash2 = maskUserId('user-456');
      expect(hash1, isNot(hash2));
    });

    test('returns16Chars', () {
      expect(maskUserId('any-user-id').length, 16);
    });
  });
}
```

### 9.3 Running Coverage

```bash
# Generate coverage report
flutter test --coverage

# View coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 10. Continuous Integration

### 10.1 Pre-Commit Checks

```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: flutter-test
        name: Flutter Tests
        entry: flutter test
        language: system
        pass_filenames: false
```

### 10.2 CI Pipeline

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Analyze code
        run: flutter analyze

      - name: Run tests with coverage
        run: flutter test --coverage

      - name: Check coverage threshold
        run: |
          COVERAGE=$(lcov --summary coverage/lcov.info | grep "lines" | grep -oP '\d+\.\d+')
          if (( $(echo "$COVERAGE < 100" | bc -l) )); then
            echo "Coverage $COVERAGE% is below 100% threshold"
            exit 1
          fi
```

---

## 11. Specialized Test Cases

### 11.1 Boundary Tests for Numeric Validations

All numeric fields MUST have boundary tests:

```dart
group('ValidationRules boundary tests', () {
  group('BBT Temperature', () {
    test('accepts minimum Fahrenheit (95.0)', () {
      expect(Validators.bbtFahrenheit(95.0), isNull);
    });

    test('accepts maximum Fahrenheit (105.0)', () {
      expect(Validators.bbtFahrenheit(105.0), isNull);
    });

    test('rejects below minimum (94.9)', () {
      expect(Validators.bbtFahrenheit(94.9), isNotNull);
    });

    test('rejects above maximum (105.1)', () {
      expect(Validators.bbtFahrenheit(105.1), isNotNull);
    });
  });

  group('Water Intake', () {
    test('accepts minimum (0 mL)', () {
      expect(Validators.waterIntakeMl(0), isNull);
    });

    test('accepts maximum (10000 mL)', () {
      expect(Validators.waterIntakeMl(10000), isNull);
    });

    test('rejects negative', () {
      expect(Validators.waterIntakeMl(-1), isNotNull);
    });

    test('rejects above maximum', () {
      expect(Validators.waterIntakeMl(10001), isNotNull);
    });
  });

  group('Severity Scale', () {
    test('accepts minimum (1)', () {
      expect(Validators.severity(1), isNull);
    });

    test('accepts maximum (10)', () {
      expect(Validators.severity(10), isNull);
    });

    test('rejects 0', () {
      expect(Validators.severity(0), isNotNull);
    });

    test('rejects 11', () {
      expect(Validators.severity(11), isNotNull);
    });
  });

  // Additional boundary tests for:
  // - dosageAmount (0.001 to 999999.0)
  // - confidence (0 to 1)
  // - probability (0 to 1)
  // - pValue (0 to 1)
  // - timesMinutesFromMidnight (0 to 1439)
  // - weekdays (0 to 6)
});
```

### 11.2 Diet Compliance Calculation Tests

```dart
group('DietComplianceService', () {
  test('calculates 100% compliance when no violations', () {
    final diet = Diet(rules: [excludeGluten, maxCarbs50]);
    final foodLogs = [glutenFreeMeal, lowCarbMeal];

    final compliance = service.calculateCompliance(diet, foodLogs);

    expect(compliance.percentage, 100.0);
    expect(compliance.violations, isEmpty);
  });

  test('calculates partial compliance with one violation', () {
    final diet = Diet(rules: [excludeGluten]);
    final foodLogs = [glutenFreeMeal, glutenMeal]; // 2 meals, 1 violation

    final compliance = service.calculateCompliance(diet, foodLogs);

    expect(compliance.percentage, 50.0);
    expect(compliance.violations.length, 1);
  });

  test('handles intermittent fasting window correctly', () {
    final diet = Diet(rules: [eatingWindow8amTo4pm]);
    final foodLogs = [mealAt7am, mealAt12pm, mealAt5pm];

    final compliance = service.calculateCompliance(diet, foodLogs);

    // 7am and 5pm are outside window
    expect(compliance.percentage, closeTo(33.3, 0.1));
    expect(compliance.violations.length, 2);
  });

  test('handles overnight eating windows', () {
    final diet = Diet(rules: [eatingWindow8pmTo8am]);
    final foodLogs = [mealAt9pm, mealAt6am, mealAt12pm];

    final compliance = service.calculateCompliance(diet, foodLogs);

    // 12pm is outside overnight window
    expect(compliance.violations.length, 1);
  });

  test('returns 100% compliance with empty food logs', () {
    final diet = Diet(rules: [excludeGluten]);
    final foodLogs = <FoodLog>[];

    final compliance = service.calculateCompliance(diet, foodLogs);

    expect(compliance.percentage, 100.0);
  });
});
```

### 11.3 Pattern Detection Tests with Insufficient Data

```dart
group('PatternDetectionService', () {
  test('returns empty patterns when data is below minimum threshold', () {
    // minDaysForPatternDetection = 14
    final logs = generateLogsForDays(10);

    final patterns = service.detectPatterns(logs);

    expect(patterns, isEmpty);
    expect(service.hasInsufficientData, isTrue);
    expect(service.daysNeeded, 4);
  });

  test('returns warning when approaching minimum data', () {
    final logs = generateLogsForDays(12);

    final result = service.analyzeDataSufficiency(logs);

    expect(result.isReady, isFalse);
    expect(result.daysRemaining, 2);
    expect(result.message, contains('2 more days'));
  });

  test('returns patterns when sufficient data available', () {
    final logs = generateLogsForDays(14);

    final patterns = service.detectPatterns(logs);

    expect(patterns, isNotEmpty);
    expect(service.hasInsufficientData, isFalse);
  });

  test('trigger correlation requires 30 days minimum', () {
    final logs = generateLogsForDays(25);

    final correlations = service.detectTriggerCorrelations(logs);

    expect(correlations, isEmpty);
    expect(service.daysNeededForCorrelation, 5);
  });

  test('predictive alerts require 60 days minimum', () {
    final logs = generateLogsForDays(45);

    final alerts = service.generatePredictiveAlerts(logs);

    expect(alerts, isEmpty);
    expect(service.daysNeededForPrediction, 15);
  });
});
```

### 11.4 HIPAA Authorization Flow Tests

```dart
group('HipaaAuthorizationService', () {
  test('creates authorization with required fields', () {
    final auth = service.createAuthorization(
      profileId: profileId,
      authorizedUserId: coachId,
      accessLevel: AccessLevel.readOnly,
      scopes: ['conditions', 'supplements'],
    );

    expect(auth.grantedAt, isNotNull);
    expect(auth.deviceSignature, isNotNull);
    expect(auth.isRevoked, isFalse);
  });

  test('enforces scope restrictions on data access', () async {
    final auth = await service.createAuthorization(
      scopes: ['conditions'], // Only conditions
    );

    expect(
      () => service.accessData(auth, 'supplements'),
      throwsA(isA<UnauthorizedAccessException>()),
    );
  });

  test('revocation prevents further access', () async {
    final auth = await service.createAuthorization(scopes: ['conditions']);

    await service.revokeAuthorization(auth.id);

    expect(
      () => service.accessData(auth, 'conditions'),
      throwsA(isA<AuthorizationRevokedException>()),
    );
  });

  test('logs all access attempts for audit', () async {
    final auth = await service.createAuthorization(scopes: ['conditions']);

    await service.accessData(auth, 'conditions');

    final logs = await service.getAccessLogs(auth.profileId);
    expect(logs, isNotEmpty);
    expect(logs.last.action, 'read');
    expect(logs.last.entityType, 'conditions');
  });

  test('expired authorization prevents access', () async {
    final auth = await service.createAuthorization(
      scopes: ['conditions'],
      expiresAt: DateTime.now().subtract(Duration(days: 1)),
    );

    expect(
      () => service.accessData(auth, 'conditions'),
      throwsA(isA<AuthorizationExpiredException>()),
    );
  });

  test('notifies owner on access when enabled', () async {
    await userPreferences.setAccessNotificationsEnabled(profileId, true);

    final auth = await service.createAuthorization(scopes: ['conditions']);
    await service.accessData(auth, 'conditions');

    verify(notificationService.sendAccessNotification(profileId, any)).called(1);
  });
});
```

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.1 | 2026-01-31 | Added specialized test cases (boundary, diet compliance, pattern detection, HIPAA) |
| 1.0 | 2026-01-30 | Initial release |
