# Shadow Implementation Roadmap

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Step-by-step guide to build Shadow from scratch

---

## Overview

This roadmap provides a systematic approach to building the Shadow health tracking application from the ground up. Each phase builds upon the previous, ensuring a solid foundation before adding features.

---

## Phase 0: Technical Decisions & Modern Stack

### 0.1 Code Generation Strategy

Shadow uses code generation to eliminate boilerplate and ensure consistency across entities and models.

**Required Packages:**
```yaml
dependencies:
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  drift: ^2.14.1  # Type-safe SQL (replaces raw sqflite)
  riverpod_annotation: ^2.3.3
  device_info_plus: ^10.1.0  # Device identification for sync

dev_dependencies:
  build_runner: ^2.4.7
  freezed: ^2.4.5
  json_serializable: ^6.7.1
  drift_dev: ^2.14.1
  riverpod_generator: ^2.3.9
```

**Entity Generation with Freezed:**
```dart
// lib/domain/entities/supplement.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplement.freezed.dart';
part 'supplement.g.dart';

@freezed
class Supplement with _$Supplement {
  const factory Supplement({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    required SupplementForm form,
    required double dosageAmount,
    required DosageUnit dosageUnit,
    String? brand,
    String? notes,
    @Default([]) List<Ingredient> ingredients,
    required SyncMetadata syncMetadata,
  }) = _Supplement;

  factory Supplement.fromJson(Map<String, dynamic> json) =>
      _$SupplementFromJson(json);
}
```

**Database with Drift:**
```dart
// lib/data/datasources/local/database.dart

import 'package:drift/drift.dart';

part 'database.g.dart';

class Supplements extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().references(Profiles, #id)();
  TextColumn get name => text()();
  IntColumn get form => intEnum<SupplementForm>()();
  RealColumn get dosageAmount => real()();
  IntColumn get dosageUnit => intEnum<DosageUnit>()();
  TextColumn get brand => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get ingredients => text().map(const IngredientsConverter())();
  // Sync metadata columns...

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Supplements, Profiles, Conditions, /* ... */])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;
}
```

**Benefits:**
- Immutable entities with `copyWith` generated
- JSON serialization generated
- Type-safe SQL queries with compile-time verification
- Boilerplate reduction: ~60% less code per entity
- No manual toMap/fromMap methods
- Automatic equals/hashCode

### 0.2 State Management: Riverpod

Shadow uses Riverpod for state management, providing compile-time safety and better testability than Provider.

**Riverpod Provider Generation:**
```dart
// lib/presentation/providers/supplement_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supplement_provider.g.dart';

@riverpod
class SupplementNotifier extends _$SupplementNotifier {
  @override
  Future<List<Supplement>> build(String profileId) async {
    final getSupplements = ref.read(getSupplementsUseCaseProvider);
    final result = await getSupplements(profileId: profileId);

    return result.when(
      success: (supplements) => supplements,
      failure: (error) => throw error,
    );
  }

  Future<void> addSupplement(Supplement supplement) async {
    final createSupplement = ref.read(createSupplementUseCaseProvider);
    final result = await createSupplement(supplement);

    result.when(
      success: (_) => ref.invalidateSelf(),
      failure: (error) => throw error,
    );
  }
}

// Usage in widget
class SupplementsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplementsAsync = ref.watch(supplementNotifierProvider(profileId));

    return supplementsAsync.when(
      data: (supplements) => SupplementList(supplements: supplements),
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorDisplay(error: error),
    );
  }
}
```

**Dependency Injection with Riverpod:**
```dart
// lib/injection_container.dart

@Riverpod(keepAlive: true)
AppDatabase database(DatabaseRef ref) => AppDatabase();

@Riverpod(keepAlive: true)
SupplementRepository supplementRepository(SupplementRepositoryRef ref) {
  return SupplementRepositoryImpl(
    ref.read(databaseProvider),
    ref.read(uuidProvider),
    ref.read(deviceInfoServiceProvider),
  );
}

@riverpod
GetSupplementsUseCase getSupplementsUseCase(GetSupplementsUseCaseRef ref) {
  return GetSupplementsUseCase(
    ref.read(supplementRepositoryProvider),
    ref.read(profileAuthorizationServiceProvider),
  );
}
```

**Benefits over Provider:**
- Compile-time safety: Missing providers caught at build time
- No BuildContext required for accessing providers
- Built-in async support (AsyncValue)
- Better testing: Providers can be overridden per-test
- Automatic disposal of unused providers
- Family providers for parameterized state

### 0.3 Code Generation Workflow

```bash
# One-time generation
dart run build_runner build --delete-conflicting-outputs

# Watch mode during development
dart run build_runner watch --delete-conflicting-outputs

# Before commit
dart run build_runner build --delete-conflicting-outputs && flutter analyze
```

**Generated Files:**
```
lib/
├── domain/entities/
│   ├── supplement.dart
│   ├── supplement.freezed.dart  # Generated: copyWith, ==, hashCode
│   └── supplement.g.dart        # Generated: JSON serialization
├── data/datasources/local/
│   ├── database.dart
│   └── database.g.dart          # Generated: Drift queries
└── presentation/providers/
    ├── supplement_provider.dart
    └── supplement_provider.g.dart  # Generated: Riverpod providers
```

---

## Phase 1: Project Setup & Foundation (Week 1-2)

### 1.1 Initialize Flutter Project

```bash
# Create new Flutter project
flutter create --org com.bluedomecolorado shadow_app
cd shadow_app

# Enable required platforms
flutter config --enable-macos-desktop
flutter config --enable-windows-desktop
```

### 1.2 Configure Project Structure

Create the Clean Architecture folder structure:

```
lib/
├── core/
│   ├── config/
│   ├── errors/
│   ├── services/
│   ├── utils/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── data/
│   ├── repositories/
│   ├── datasources/
│   │   ├── local/
│   │   └── remote/
│   ├── models/
│   └── cloud/
├── presentation/
│   ├── screens/
│   ├── widgets/
│   ├── providers/
│   └── theme/
└── l10n/
```

### 1.3 Add Core Dependencies

Update `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # State Management (Riverpod)
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3

  # Code Generation
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

  # Database (Drift - type-safe SQL)
  drift: ^2.14.1
  sqlite3_flutter_libs: ^0.5.18
  path_provider: ^2.1.1
  path: ^1.8.3

  # Security
  flutter_secure_storage: ^9.0.0
  encrypt: ^5.0.3
  crypto: ^3.0.3
  pointycastle: ^3.7.3

  # Utilities
  uuid: ^4.2.1
  intl: ^0.18.1
  logger: ^2.0.2

  # Google Sign-In & Drive
  google_sign_in: ^6.1.6
  googleapis: ^12.0.0
  googleapis_auth: ^1.4.1
  http: ^1.1.2

  # UI Components
  cached_network_image: ^3.3.0
  image_picker: ^1.0.4

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  mockito: ^5.4.3
  build_runner: ^2.4.7
  freezed: ^2.4.5
  json_serializable: ^6.7.1
  drift_dev: ^2.14.1
  riverpod_generator: ^2.3.9

flutter:
  uses-material-design: true
  generate: true  # Enable l10n generation
```

### 1.4 Configure Localization

Create `l10n.yaml`:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
```

Create initial ARB file `lib/l10n/app_en.arb`:

```json
{
  "@@locale": "en",
  "appTitle": "Shadow",
  "homeTab": "Home",
  "conditionsTab": "Conditions",
  "supplementsTab": "Supplements"
}
```

### 1.5 Set Up Dependency Injection

Create `lib/injection_container.dart`:

```dart
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core Services
  sl.registerLazySingleton(() => const Uuid());

  // Database (to be added in Phase 2)
  // Repositories (to be added in Phase 3)
  // Providers (to be added in Phase 4)
}
```

### Deliverables - Phase 1

- [ ] Flutter project created and configured
- [ ] Folder structure established
- [ ] All dependencies added and resolved
- [ ] Localization configured
- [ ] Dependency injection skeleton in place
- [ ] Project builds successfully on all target platforms

---

## Phase 2: Database & Core Services (Week 3-4)

### 2.1 Create Exception Classes

`lib/core/errors/exceptions.dart`:

```dart
class EntityNotFoundException implements Exception {
  final String entityType;
  final String entityId;

  EntityNotFoundException({
    required this.entityType,
    required this.entityId,
  });

  @override
  String toString() => '$entityType with id $entityId not found';
}

class DatabaseException implements Exception {
  final String message;
  final String? operation;
  final dynamic originalError;

  DatabaseException({
    required this.message,
    this.operation,
    this.originalError,
  });
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}
```

### 2.2 Create Logger Service

`lib/core/services/logger_service.dart`:

```dart
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  late final Logger _logger;

  factory LoggerService() => _instance;

  LoggerService._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
      ),
      level: kDebugMode ? Level.debug : Level.info,
    );
  }

  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  ScopedLogger scope(String scope) => ScopedLogger(scope, this);
}

class ScopedLogger {
  final String scope;
  final LoggerService _logger;

  ScopedLogger(this.scope, this._logger);

  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.debug('[$scope] $message', error, stackTrace);
  }

  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.info('[$scope] $message', error, stackTrace);
  }

  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.warning('[$scope] $message', error, stackTrace);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.error('[$scope] $message', error, stackTrace);
  }
}

final logger = LoggerService();
```

### 2.3 Create Device Info Service

`lib/core/services/device_info_service.dart`:

```dart
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin;
  String? _deviceId;
  String? _deviceName;

  DeviceInfoService(this._deviceInfoPlugin);

  Future<String> getDeviceId() async {
    if (_deviceId != null) return _deviceId!;

    if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      _deviceId = iosInfo.identifierForVendor ??
          'ios-${iosInfo.model}-${iosInfo.name}';
    } else if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      _deviceId = androidInfo.id;
    } else if (Platform.isMacOS) {
      final macInfo = await _deviceInfoPlugin.macOsInfo;
      _deviceId = macInfo.systemGUID ?? 'macos-${macInfo.computerName}';
    }

    return _deviceId!;
  }

  Future<String> getDeviceName() async {
    if (_deviceName != null) return _deviceName!;

    if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      _deviceName = '${iosInfo.name} (${iosInfo.model})';
    } else if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      _deviceName = '${androidInfo.brand} ${androidInfo.model}';
    } else if (Platform.isMacOS) {
      final macInfo = await _deviceInfoPlugin.macOsInfo;
      _deviceName = macInfo.computerName;
    }

    return _deviceName!;
  }

  String getPlatform() {
    if (Platform.isIOS) return 'iOS';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isMacOS) return 'macOS';
    return 'Unknown';
  }
}
```

### 2.4 Create Database Helper

`lib/data/datasources/local/database_helper.dart`:

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'shadow.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    // User & Access tables
    await _createUserAccountsTable(db);
    await _createDeviceRegistrationsTable(db);
    await _createProfilesTable(db);
    await _createProfileAccessTable(db);

    // Health data tables (add as entities are created)
    await _createConditionsTable(db);
    await _createConditionLogsTable(db);
    await _createSupplementsTable(db);
    await _createIntakeLogsTable(db);
    // ... additional tables
  }

  Future<void> _createProfilesTable(Database db) async {
    await db.execute('''
      CREATE TABLE profiles (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        birth_date TEXT,
        biological_sex TEXT,
        ethnicity TEXT,
        notes TEXT,
        owner_id TEXT NOT NULL,

        -- Sync metadata
        sync_created_at INTEGER NOT NULL,
        sync_updated_at INTEGER NOT NULL,
        sync_deleted_at INTEGER,
        sync_last_synced_at INTEGER,
        sync_status INTEGER NOT NULL DEFAULT 0,  -- 0=pending, 1=synced, 2=conflict, 3=error
        sync_version INTEGER NOT NULL DEFAULT 1,
        sync_is_dirty INTEGER NOT NULL DEFAULT 1,
        sync_created_by_device_id TEXT NOT NULL,
        sync_last_modified_by_device_id TEXT NOT NULL,

        FOREIGN KEY (owner_id) REFERENCES user_accounts(id)
      )
    ''');
    await db.execute('CREATE INDEX idx_profiles_owner_id ON profiles(owner_id)');
  }

  // Additional table creation methods...
}
```

### 2.5 Create SyncMetadata Entity

> **CANONICAL:** See `22_API_CONTRACTS.md` Section 3.1 for full @freezed definition.

`lib/domain/sync/sync_metadata.dart`:

```dart
/// Sync status values - MUST match database INTEGER values
enum SyncStatus {
  pending(0),    // Never synced
  synced(1),     // Successfully synced
  modified(2),   // Modified since last sync
  conflict(3),   // Conflict detected
  deleted(4);    // Marked for deletion

  final int value;
  const SyncStatus(this.value);

  static SyncStatus fromValue(int value) =>
    SyncStatus.values.firstWhere((e) => e.value == value, orElse: () => pending);
}

@freezed
class SyncMetadata with _$SyncMetadata {
  const SyncMetadata._();

  const factory SyncMetadata({
    required int syncCreatedAt,      // Epoch milliseconds
    required int syncUpdatedAt,      // Epoch milliseconds
    int? syncDeletedAt,              // Null = active
    @Default(SyncStatus.pending) SyncStatus syncStatus,
    @Default(1) int syncVersion,
    required String syncDeviceId,
    @Default(true) bool syncIsDirty,
    String? conflictData,
  }) = _SyncMetadata;

  factory SyncMetadata.fromJson(Map<String, dynamic> json) =>
      _$SyncMetadataFromJson(json);

  factory SyncMetadata.create({required String deviceId}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return SyncMetadata(
      syncCreatedAt: now,
      syncUpdatedAt: now,
      syncDeviceId: deviceId,
    );
  }

  bool get isDeleted => syncDeletedAt != null;

  SyncMetadata markModified(String deviceId) => copyWith(
    syncUpdatedAt: DateTime.now().millisecondsSinceEpoch,
    syncDeviceId: deviceId,
    syncIsDirty: true,
    syncStatus: SyncStatus.modified,
    syncVersion: syncVersion + 1,
  );

  SyncMetadata markSynced() => copyWith(
    syncIsDirty: false,
    syncStatus: SyncStatus.synced,
  );

  SyncMetadata markDeleted(String deviceId) => copyWith(
    syncDeletedAt: DateTime.now().millisecondsSinceEpoch,
    syncUpdatedAt: DateTime.now().millisecondsSinceEpoch,
    syncDeviceId: deviceId,
    syncIsDirty: true,
    syncStatus: SyncStatus.deleted,
    syncVersion: syncVersion + 1,
  );
}
```

### 2.6 Create BaseRepository

`lib/core/repositories/base_repository.dart`:

```dart
import 'package:uuid/uuid.dart';
import '../services/device_info_service.dart';
import '../../domain/sync/sync_metadata.dart';

/// Base class for all repositories with sync support.
/// ALL repository implementations MUST extend this class.
abstract class BaseRepository<T> {
  final Uuid _uuid;
  final DeviceInfoService _deviceInfoService;

  BaseRepository(this._uuid, this._deviceInfoService);

  /// Generate ID if not provided or empty
  String generateId(String? existingId) {
    return existingId?.isNotEmpty == true ? existingId! : _uuid.v4();
  }

  /// Create fresh SyncMetadata for new entities
  Future<SyncMetadata> createSyncMetadata() async {
    final deviceId = await _deviceInfoService.getDeviceId();
    return SyncMetadata.create(deviceId: deviceId);
  }

  /// Prepare entity for creation (generate ID, create sync metadata)
  /// NOTE: These helpers return the prepared entity; the calling repository
  /// method wraps the result in Result<T, AppError>
  Future<T> prepareForCreate<T>(
    T entity,
    T Function(String id, SyncMetadata syncMetadata) copyWith, {
    String? existingId,
  }) async {
    final id = generateId(existingId);
    final syncMetadata = await createSyncMetadata();
    return copyWith(id, syncMetadata);
  }

  /// Prepare entity for update (update sync metadata)
  /// NOTE: These helpers return the prepared entity; the calling repository
  /// method wraps the result in Result<T, AppError>
  Future<T> prepareForUpdate<T>(
    T entity,
    T Function(SyncMetadata syncMetadata) copyWith, {
    bool markDirty = true,
    required SyncMetadata Function(T) getSyncMetadata,
  }) async {
    if (!markDirty) return entity;

    final deviceId = await _deviceInfoService.getDeviceId();
    final existingMetadata = getSyncMetadata(entity);
    final updatedMetadata = existingMetadata.markModified(deviceId);
    return copyWith(updatedMetadata);
  }

  /// Prepare entity for soft delete
  /// NOTE: These helpers return the prepared entity; the calling repository
  /// method wraps the result in Result<T, AppError>
  Future<T> prepareForDelete<T>(
    T entity,
    T Function(SyncMetadata syncMetadata) copyWith, {
    required SyncMetadata Function(T) getSyncMetadata,
  }) async {
    final deviceId = await _deviceInfoService.getDeviceId();
    final existingMetadata = getSyncMetadata(entity);
    final deletedMetadata = existingMetadata.markDeleted(deviceId);
    return copyWith(deletedMetadata);
  }
}
```

### Deliverables - Phase 2

- [ ] Exception classes created
- [ ] Logger service implemented
- [ ] Device info service implemented
- [ ] Database helper with initial tables
- [ ] SyncMetadata entity defined
- [ ] BaseRepository with sync helpers
- [ ] All services registered in DI container
- [ ] Unit tests for all services (100% coverage)

---

## Phase 3: Domain Entities & Repositories (Week 5-8)

### 3.1 Create Profile Entity

`lib/domain/entities/profile.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// User health profile entity.
///
/// Each profile represents a person being tracked (self, family member, client).
@freezed
class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String clientId,     // Required for database merging
    required String name,
    int? birthDate, // Epoch milliseconds
    String? biologicalSex,
    String? ethnicity,
    String? notes,
    required String ownerId,      // User who owns this profile
    @Default(DietType.none) DietType dietType,
    String? dietDescription,
    required SyncMetadata syncMetadata,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
```

### 3.2 Entity Creation Order

Create entities in this order (respecting dependencies):

1. **Core Entities** (no dependencies)
   - Profile
   - UserAccount
   - DeviceRegistration

2. **Standalone Health Entities**
   - Supplement
   - FoodItem
   - Activity
   - PhotoArea

3. **Dependent Health Entities**
   - Condition (references Profile)
   - ConditionLog (references Condition)
   - FlareUp (references Condition)
   - SupplementIntakeLog (references Supplement)
   - FoodLog (references FoodItem)
   - ActivityLog (references Activity)
   - PhotoEntry (references PhotoArea)
   - SleepEntry
   - FluidsEntry
   - JournalEntry
   - Document

4. **Access Control**
   - ProfileAccess (references Profile, UserAccount)

### 3.3 Repository Pattern for Each Entity

For each entity, create:

1. **Repository Interface** (`lib/domain/repositories/{entity}_repository.dart`)
2. **Local Data Source Interface** (`lib/data/datasources/local/{entity}_local_datasource.dart`)
3. **Local Data Source Implementation** (same file)
4. **Model Class** (`lib/data/models/{entity}_model.dart`)
5. **Repository Implementation** (`lib/data/repositories/{entity}_repository_impl.dart`)

### 3.4 Test Each Layer

For each entity, write tests:

```
test/domain/entities/{entity}_test.dart
test/data/models/{entity}_model_test.dart
test/data/datasources/local/{entity}_local_datasource_test.dart
test/data/repositories/{entity}_repository_impl_test.dart
```

### 3.5 New Entities for Phase 2 Features

In addition to the core 22 entities, create:

**FluidsEntry Entity** (replaces BowelUrineEntry):
```dart
enum MenstruationFlow { none, spotty, light, medium, heavy }

class FluidsEntry {
  // Existing bowel/urine fields...
  final MenstruationFlow? menstruationFlow;
  final double? basalBodyTemperature;  // °F or °C
  final DateTime? bbtRecordedTime;
}
```

**NotificationSchedule Entity**:
```dart
/// NotificationType: 25 values - See 22_API_CONTRACTS.md Section 3.2 for canonical definition
/// Includes: supplementIndividual(0)..inactivity(24)

class NotificationSchedule {
  final String id;
  final String? profileId;
  final NotificationType type;
  final String? entityId;
  final List<int> timesMinutesFromMidnight;
  final List<int> weekdays;
  final bool isEnabled;
  final String? customMessage;
  final SyncMetadata syncMetadata;
}
```

**Profile Entity Updates**:
```dart
enum DietType { none, vegan, vegetarian, paleo, keto, glutenFree, other }

class Profile {
  // Existing fields...
  final DietType? dietType;
  final String? dietDescription;  // For 'other' diet type
}
```

### Deliverables - Phase 3

- [ ] All 22+ entities created with proper structure (including FluidsEntry, NotificationSchedule)
- [ ] All repository interfaces defined
- [ ] All data sources implemented
- [ ] All models with JSON serialization
- [ ] All repository implementations
- [ ] Profile entity includes dietType, dietDescription fields
- [ ] FluidsEntry includes menstruation and BBT fields
- [ ] **Verify EVERY entity includes clientId field before repository creation**
- [ ] 100% test coverage on entities
- [ ] 100% test coverage on repositories

---

## Phase 4: UI Foundation & State Management (Week 9-12)

### 4.1 Create Theme Configuration

`lib/presentation/theme/app_theme.dart`:

```dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.light,
      ),
      // Define all theme properties...
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.dark,
      ),
      // Define all theme properties...
    );
  }
}
```

### 4.2 Create Accessible Widget Library

`lib/presentation/widgets/accessible_widgets.dart`:

Create base accessible components:
- AccessibleButton
- AccessibleCard
- AccessibleTextField
- AccessibleDropdown
- AccessibleSwitch
- AccessibleImage
- AccessibleLoadingIndicator
- AccessibleEmptyState

### 4.3 Riverpod Provider Pattern

**Shadow uses Riverpod with code generation for all state management.** No base provider class is needed - Riverpod's `@riverpod` annotation generates the boilerplate.

`lib/presentation/providers/supplement_provider.dart`:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/supplement.dart';
import '../../domain/usecases/get_supplements_use_case.dart';

part 'supplement_provider.g.dart';

/// Profile-scoped async provider using family pattern
@riverpod
class SupplementList extends _$SupplementList {
  @override
  Future<List<Supplement>> build(String profileId) async {
    // Delegate to use case (authorization checked there)
    final useCase = ref.read(getSupplementsUseCaseProvider);
    final result = await useCase(GetSupplementsInput(profileId: profileId));

    return result.when(
      success: (supplements) => supplements,
      failure: (error) => throw error,  // AsyncValue handles error state
    );
  }

  /// Mutation methods return Result for explicit error handling
  Future<Result<Supplement, AppError>> add(CreateSupplementInput input) async {
    final useCase = ref.read(createSupplementUseCaseProvider);
    final result = await useCase(input);

    if (result.isSuccess) {
      ref.invalidateSelf();  // Trigger refresh
    }

    return result;
  }
}
```

### 4.4 Create Feature Providers

Create providers for each feature domain:
- ProfileProvider
- ConditionProvider
- SupplementProvider
- FoodProvider
- ActivityProvider
- SleepProvider
- FluidsProvider
- PhotoProvider
- JournalProvider
- DocumentProvider
- AuthProvider
- SyncProvider

### 4.5 Create Main App Structure

`lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'injection_container.dart' as di;
import 'presentation/screens/home_screen.dart';
import 'presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const ShadowApp());
}

class ShadowApp extends StatelessWidget {
  const ShadowApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Riverpod ProviderScope wraps the entire app (in main.dart)
    // No manual provider registration needed - @riverpod generates them
    return MaterialApp(
      title: 'Shadow',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomeScreen(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

// In main.dart:
void main() {
  runApp(
    ProviderScope(  // Riverpod's root scope
      child: const ShadowApp(),
    ),
  );
}
```

### Deliverables - Phase 4

- [ ] Theme configuration complete
- [ ] Accessible widget library created
- [ ] All providers implemented
- [ ] Main app structure with provider setup
- [ ] Tab navigation working
- [ ] 100% test coverage on providers

---

## Phase 5: Core Screens & Features (Week 13-20)

### 5.1 Screen Development Order

Build screens in this order:

**Week 13-14: Profile & Authentication**
- Welcome Screen
- Sign In Screen
- Profiles Screen
- Add/Edit Profile Screen

**Week 15-16: Condition Tracking**
- Conditions Tab
- Add Condition Screen
- Condition Detail Screen
- Report Flare-Up Screen
- Flare-Ups List Screen

**Week 17-18: Supplement Management**
- Supplements Tab
- Add/Edit Supplement Screen
- Supplement Intake Logs Screen
- Report Supplements Screen

**Week 19-20: Additional Tracking**
- Food Tab + Log Food Screen
- Activities Tab + Add Activity Screen
- Sleep Tab + Add Sleep Entry Screen
- Bowels Tab + Add Entry Screen
- Photos Tab + Take Photo Screen
- Journal List + Add Entry Screen

### 5.2 Screen Template

Each screen follows this structure:

```dart
class AddSupplementScreen extends StatefulWidget {
  final Supplement? editingSupplement;

  const AddSupplementScreen({super.key, this.editingSupplement});

  @override
  State<AddSupplementScreen> createState() => _AddSupplementScreenState();
}

class _AddSupplementScreenState extends State<AddSupplementScreen> {
  static final _log = logger.scope('AddSupplementScreen');
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  late TextEditingController _nameController;

  bool get _isEditing => widget.editingSupplement != null;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(
      text: widget.editingSupplement?.name ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final provider = context.read<SupplementProvider>();
      // Save logic...
      Navigator.pop(context);
    } catch (e, stackTrace) {
      _log.error('Failed to save supplement', e, stackTrace);
      // Show error to user
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editSupplement : l10n.addSupplement),
      ),
      body: Form(
        key: _formKey,
        child: // Form content...
      ),
    );
  }
}
```

### Deliverables - Phase 5

- [ ] All 31+ screens implemented
- [ ] Full CRUD functionality for all entities
- [ ] Navigation working correctly
- [ ] Form validation on all inputs
- [ ] Loading and error states handled
- [ ] Widget tests for all screens (100% coverage)

---

## Phase 6: Cloud Sync & OAuth (Week 21-24)

### 6.1 OAuth Configuration

See [08_OAUTH_IMPLEMENTATION.md](./08_OAUTH_IMPLEMENTATION.md) for complete details.

**Key Configuration Values:**

```dart
// lib/core/config/google_oauth_config.dart
class GoogleOAuthConfig {
  // From .env or --dart-define
  static String get clientId =>
    const String.fromEnvironment('GOOGLE_OAUTH_CLIENT_ID');

  static const String authUri = 'https://accounts.google.com/o/oauth2/auth';
  static const String tokenUri = 'https://oauth2.googleapis.com/token';

  static const List<String> scopes = [
    'https://www.googleapis.com/auth/drive.file',
    'email',
    'profile',
  ];
}
```

### 6.2 Implement Cloud Storage Provider Interface

```dart
abstract class CloudStorageProvider {
  Future<bool> get isAuthenticated;
  Future<void> signIn();
  Future<void> signOut();
  Future<String> uploadJson(String path, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> downloadJson(String path);
  Future<String> uploadFile(String localPath, String cloudPath);
  Future<void> downloadFile(String cloudPath, String localPath);
  Future<void> deleteFile(String cloudPath);
  Future<List<String>> listFiles(String folder);
}
```

### 6.3 Implement Google Drive Provider

Complete implementation with:
- PKCE authentication flow
- Token management and refresh
- Rate limiting
- File upload/download
- JSON data sync

### 6.4 Implement Sync Service

```dart
class SyncService {
  Future<SyncResult> sync() async {
    // 1. Check connectivity
    // 2. Authenticate
    // 3. Upload dirty entities
    // 4. Download remote changes
    // 5. Resolve conflicts
    // 6. Sync files
    // 7. Update sync metadata
  }
}
```

### Deliverables - Phase 6

- [ ] OAuth flow working on all platforms
- [ ] Google Drive provider fully implemented
- [ ] Sync service orchestrating full sync
- [ ] Conflict resolution working
- [ ] File sync (photos, documents) working
- [ ] Multi-device pairing implemented
- [ ] Integration tests for sync flow

---

## Phase 7: Enhanced Features (Week 25-28)

### 7.1 Fluids Tab Enhancement

**Rename and Extend**:
1. Rename `bowels_urine_tab.dart` → `fluids_tab.dart`
2. Rename `BowelUrineProvider` → `FluidsProvider`
3. Add menstruation tracking section
4. Add BBT tracking section
5. Add BBT chart for cycle visualization

**UI Components**:
```dart
// Menstruation Flow Picker
FlowIntensityPicker(
  value: selectedFlow,
  onChanged: (flow) => setState(() => selectedFlow = flow),
)

// BBT Input
BBTInput(
  temperature: _temperature,
  recordedTime: _recordedTime,
  onTemperatureChanged: (temp) => setState(() => _temperature = temp),
  onTimeChanged: (time) => setState(() => _recordedTime = time),
)

// BBT Chart
BBTChart(
  entries: fluidsEntries,
  dateRange: DateRange(start: cycleStart, end: today),
)
```

### 7.2 Diet Type Feature

**Profile Updates**:
1. Add `DietType` dropdown to Add/Edit Profile screen
2. Add `dietDescription` text field (visible when dietType == other)
3. Display current diet type badge in Food tab header

**Food Tab Integration**:
```dart
// In FoodTab header
if (profile.dietType != null && profile.dietType != DietType.none)
  DietTypeBadge(dietType: profile.dietType!),
```

### 7.3 Notifications System

**Implementation Order**:

1. **Add Dependencies**:
```yaml
flutter_local_notifications: ^18.0.1
timezone: ^0.10.0
```

2. **Platform Configuration**:
   - Android: Add permissions to AndroidManifest.xml
   - iOS: Add background modes to Info.plist
   - Initialize timezone database

3. **Create Entity Stack**:
   - `lib/domain/entities/notification_schedule.dart`
   - `lib/domain/repositories/notification_schedule_repository.dart`
   - `lib/data/models/notification_schedule_model.dart`
   - `lib/data/datasources/local/notification_schedule_local_datasource.dart`
   - `lib/data/repositories/notification_schedule_repository_impl.dart`

4. **Create Service**:
   - `lib/core/services/notification_service.dart`
   - Handle initialization, permissions, scheduling
   - Implement deep link handling

5. **Create UI**:
   - `lib/presentation/providers/notification_provider.dart`
   - `lib/presentation/screens/notification_settings_screen.dart`
   - Add entry point from profile/settings

**Notification Settings Screen Layout**:
```
┌─────────────────────────────────────────┐
│ Notification Settings                    │
├─────────────────────────────────────────┤
│ ◉ Supplement Reminders                   │
│   [Vitamin D] 8:00 AM, 8:00 PM          │
│   [Magnesium] 9:00 PM                    │
│   [+ Add Reminder]                       │
├─────────────────────────────────────────┤
│ ◉ Meal Reminders                         │
│   Breakfast: 8:00 AM                     │
│   Lunch: 12:00 PM                        │
│   Dinner: 6:00 PM                        │
│   [+ Add Time]                           │
├─────────────────────────────────────────┤
│ ◉ Fluids Reminders                       │
│   Morning: 7:00 AM                       │
│   [+ Add Time]                           │
├─────────────────────────────────────────┤
│ ◉ Sleep Reminders                        │
│   Bedtime: 10:00 PM                      │
│   Wake-up: 6:30 AM                       │
└─────────────────────────────────────────┘
```

### 7.4 Branding Update

**Logo Replacement**:
1. Generate shadow silhouette icons in all required sizes
2. Replace Android mipmap icons
3. Replace iOS AppIcon assets
4. Replace macOS AppIcon assets
5. Replace web icons and favicon

**Color Scheme Update**:
1. Update `AppColors.dart` with earth tone palette
2. Update `app_constants.dart` PDF colors
3. Update `web/manifest.json` theme colors
4. Find and replace hardcoded `Colors.*` with `AppColors.*`

### Deliverables - Phase 7

- [ ] Fluids tab with menstruation and BBT tracking
- [ ] BBT chart visualization
- [ ] Diet type selection on profile
- [ ] Diet type display in food tab
- [ ] Notification service implemented
- [ ] Notification settings screen
- [ ] Deep linking from notifications
- [ ] Shadow silhouette logo assets
- [ ] Earth tone color scheme applied
- [ ] All hardcoded colors refactored

---

## Phase 8: Polish & Production (Week 29-32)

### 8.1 Performance Optimization

- Profile app with DevTools
- Optimize database queries
- Implement image caching
- Lazy load heavy screens

### 8.2 Accessibility Audit

- Test with VoiceOver/TalkBack
- Verify all semantic labels
- Check focus order
- Test keyboard navigation

### 8.3 Security Hardening

- Enable code obfuscation
- Implement certificate pinning
- Audit all logs for PII
- Test encryption end-to-end

### 8.4 App Store Preparation

**iOS:**
- Create App Store Connect listing
- Prepare screenshots
- Write app description
- Create privacy policy URL
- Create PrivacyInfo.xcprivacy

**Android:**
- Create Play Console listing
- Prepare screenshots
- Write store description
- Create privacy policy URL

### 8.5 Final Testing

- Full regression test
- Performance benchmarking
- Security penetration testing
- Accessibility validation

### Deliverables - Phase 8

- [ ] Performance meets all targets
- [ ] WCAG 2.1 Level AA certified
- [ ] Security audit passed
- [ ] App Store listings prepared
- [ ] All tests passing (5000+ tests)
- [ ] Documentation complete

---

## Testing Requirements Throughout

### Test-As-You-Go Rule

**MANDATORY**: Every feature must have tests before it's considered complete.

```
For each entity/feature:
1. Write unit tests for entity
2. Write unit tests for model
3. Write unit tests for data source
4. Write unit tests for repository
5. Write unit tests for provider
6. Write widget tests for screens
7. Write integration tests for user flows
```

### Coverage Targets

| Phase | Minimum Coverage |
|-------|------------------|
| Phase 2 | 100% for services |
| Phase 3 | 100% for repositories |
| Phase 4 | 100% for providers |
| Phase 5 | 100% for screens |
| Phase 6 | 100% for sync |
| Phase 7 | 100% overall |

> **Note:** Per 02_CODING_STANDARDS.md Section 10.3, 100% test coverage is required for all code at all phases.

---

## Consistency Checklist

Before completing any phase, verify:

- [ ] All naming conventions followed (see 07_NAMING_CONVENTIONS.md)
- [ ] All coding standards met (see 02_CODING_STANDARDS.md)
- [ ] All tests passing
- [ ] Documentation updated
- [ ] Code reviewed
- [ ] No compiler warnings
- [ ] flutter analyze clean

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
| 1.1 | 2026-01-30 | Added Phase 7 for enhanced features (Fluids, notifications, diet types, branding) |
