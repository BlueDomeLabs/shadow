# Shadow Naming Conventions

**Version:** 1.0
**Last Updated:** January 30, 2026
**Compliance:** MANDATORY - All code must follow these conventions

---

## Overview

Consistent naming is critical for maintainability. This document defines naming conventions for every aspect of the Shadow codebase.

---

## 1. General Dart Conventions

### 1.1 Case Styles

| Style | Usage | Examples |
|-------|-------|----------|
| `UpperCamelCase` | Classes, enums, typedefs, extensions | `SupplementRepository`, `SyncStatus` |
| `lowerCamelCase` | Variables, parameters, methods, functions | `getAllSupplements`, `currentProfile` |
| `lowercase_with_underscores` | Libraries, packages, directories, files | `supplement_repository.dart` |
| `SCREAMING_CAPS` | Constants (rarely, prefer lowerCamelCase) | Generally avoid |

### 1.2 File Naming

```
# Entity files
supplement.dart                    # Entity
supplement_repository.dart         # Repository interface
supplement_repository_impl.dart    # Repository implementation
supplement_local_datasource.dart   # Data source
supplement_model.dart              # Model
supplement_provider.dart           # Provider

# Screen files
add_edit_supplement_screen.dart    # Screen
supplement_intake_logs_screen.dart # Screen

# Widget files
supplement_card.dart               # Widget
supplement_list_item.dart          # Widget

# Test files
supplement_test.dart               # Entity test
supplement_repository_impl_test.dart # Repository test

# Fluids feature files (renamed from bowel_urine)
fluids_entry.dart                  # Entity (was bowel_urine_entry.dart)
fluids_repository.dart             # Repository interface
fluids_repository_impl.dart        # Repository implementation
fluids_local_datasource.dart       # Data source
fluids_model.dart                  # Model
fluids_provider.dart               # Provider
fluids_tab.dart                    # Tab screen (was bowels_urine_tab.dart)
add_fluids_entry_screen.dart       # Entry screen

# Notification feature files
notification_schedule.dart         # Entity
notification_schedule_repository.dart
notification_schedule_repository_impl.dart
notification_schedule_local_datasource.dart
notification_schedule_model.dart
notification_provider.dart
notification_service.dart          # Core service
notification_settings_screen.dart  # Settings UI
```

---

## 2. Architecture Layer Naming

### 2.1 Domain Layer

#### Entities

```dart
// File: lib/domain/entities/supplement.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplement.freezed.dart';
part 'supplement.g.dart';

/// Entity name: Singular noun, uses @freezed
@freezed
class Supplement with _$Supplement {
  const factory Supplement({
    // Fields: lowerCamelCase
    required String id,
    required String clientId,     // Required for database merging
    required String profileId,
    required String name,
    @Default(SupplementForm.capsule) SupplementForm form,
    @Default([]) List<SupplementIngredient> ingredients,
    required SyncMetadata syncMetadata,
  }) = _Supplement;

  factory Supplement.fromJson(Map<String, dynamic> json) =>
      _$SupplementFromJson(json);
}

/// Enum name: Singular noun, UpperCamelCase
enum SupplementForm {
  capsule,    // Values: lowerCamelCase
  tablet,
  powder,
  liquid,
  other,
}

/// Fluids-related enums
enum MenstruationFlow {
  none,       // No flow
  spotty,     // Minimal spotting
  light,      // Light flow
  medium,     // Moderate flow
  heavy,      // Heavy flow
}

/// Diet type enum
enum DietType {
  none,       // No specific diet
  vegan,
  vegetarian,
  paleo,
  keto,
  glutenFree,
  other,      // Custom - requires dietDescription
}

/// Notification type enum - 25 values with explicit integer codes
/// CANONICAL DEFINITION: See 22_API_CONTRACTS.md Section 3.2
/// Example values: supplementIndividual(0), mealBreakfast(2), waterSmart(8),
///                 sleepBedtime(11), conditionCheckIn(13), inactivity(24)
```

#### Repository Interfaces

```dart
// File: lib/domain/repositories/supplement_repository.dart

/// Interface name: {Entity}Repository
/// All methods return Result<T, AppError> - never throw exceptions
abstract class SupplementRepository {
  // Standard method patterns (ALL return Result type):
  // getAll{Entity}s  - Returns Result<List<Entity>, AppError>
  // getById          - Returns Result<Entity?, AppError> (null if not found)
  // create           - Creates new entity, returns Result<Entity, AppError>
  // update           - Updates existing, returns Result<Entity, AppError>
  // delete           - Soft deletes, returns Result<void, AppError>
  //
  // NOTE: find{Entity} pattern is DEPRECATED - use getById with nullable return

  Future<Result<List<Supplement>, AppError>> getAllSupplements({
    required String profileId,  // Always required for profile scoping
    int? limit,
    int? offset,
  });

  Future<Result<Supplement?, AppError>> getById(String id);

  Future<Result<Supplement, AppError>> create(Supplement supplement);

  Future<Result<Supplement, AppError>> update(
    Supplement supplement, {
    bool markDirty = true,
  });

  Future<Result<void, AppError>> delete(String id);
}
```

### 2.2 Data Layer

#### Repository Implementations

```dart
// File: lib/data/repositories/supplement_repository_impl.dart

/// Implementation name: {Entity}RepositoryImpl
class SupplementRepositoryImpl extends BaseRepository<Supplement>
    implements SupplementRepository {

  // Dependencies: Private with underscore prefix
  final SupplementLocalDataSource _localDataSource;

  // Constructor: Positional for required deps
  SupplementRepositoryImpl(
    this._localDataSource,
    Uuid uuid,
    DeviceInfoService deviceInfoService,
  ) : super(uuid, deviceInfoService);

  // Method implementations match interface exactly
  @override
  Future<List<Supplement>> getAllSupplements({...}) async {...}
}
```

#### Data Sources

```dart
// File: lib/data/datasources/local/supplement_local_datasource.dart

/// Interface name: {Entity}LocalDataSource
abstract class SupplementLocalDataSource {
  // Methods mirror repository but work with Models
  Future<List<Supplement>> getAllSupplements({...});
  Future<Supplement> getSupplement(String id);
  Future<Supplement?> findSupplement(String id);
  Future<void> insertSupplement(SupplementModel supplement);
  Future<void> updateSupplement(SupplementModel supplement);
}

/// Implementation name: {Entity}LocalDataSourceImpl
class SupplementLocalDataSourceImpl implements SupplementLocalDataSource {
  final DatabaseHelper _databaseHelper;

  SupplementLocalDataSourceImpl(this._databaseHelper);

  // Implementation...
}
```

#### Models

```dart
// File: lib/data/models/supplement_model.dart

/// Model name: {Entity}Model
class SupplementModel {
  // Same fields as entity
  final String id;
  final String profileId;
  // ...

  const SupplementModel({...});

  /// Factory: fromEntity - Convert entity to model
  factory SupplementModel.fromEntity(Supplement entity) {...}

  /// Factory: fromMap - Convert database row to model
  factory SupplementModel.fromMap(Map<String, dynamic> map) {...}

  /// Factory: fromJson - Convert JSON to model (for cloud sync)
  factory SupplementModel.fromJson(Map<String, dynamic> json) {...}

  /// Method: toEntity - Convert model to entity
  Supplement toEntity() {...}

  /// Method: toMap - Convert model to database row
  Map<String, dynamic> toMap() {...}

  /// Method: toJson - Convert model to JSON (for cloud sync)
  Map<String, dynamic> toJson() {...}
}
```

### 2.3 Presentation Layer

#### Providers (Riverpod)

**All providers use Riverpod with code generation (@riverpod annotation).**

**Provider Class Naming:**
| Type | Pattern | Example | Use Case |
|------|---------|---------|----------|
| Async list | `{Entity}List` | `SupplementList` | Fetches and manages list of entities |
| Single entity | `{Entity}Detail` | `SupplementDetail` | Fetches and manages single entity |
| Stateful | `{Feature}Notifier` | `SettingsNotifier` | Non-async state management |
| Computed | `{Feature}State` | `ComplianceState` | Derived state from other providers |

```dart
// File: lib/presentation/providers/supplement_provider.dart

/// Provider name: {feature}Provider (camelCase, generated)
/// Class name: {Feature}List or {Feature}Detail (PascalCase)

@riverpod
class SupplementList extends _$SupplementList {
  static final _log = logger.scope('SupplementList');

  @override
  Future<List<Supplement>> build(String profileId) async {
    // Delegate to use case, not repository
    final useCase = ref.read(getSupplementsUseCaseProvider);
    final result = await useCase(GetSupplementsInput(profileId: profileId));

    return result.when(
      success: (supplements) => supplements,
      failure: (error) {
        _log.error('Failed to load supplements: ${error.message}');
        throw error;  // AsyncValue handles error state
      },
    );
  }

  // Methods: Action verbs, return Result for mutations
  Future<Result<Supplement, AppError>> addSupplement(CreateSupplementInput input) async {...}
  Future<Result<Supplement, AppError>> updateSupplement(UpdateSupplementInput input) async {...}
  Future<Result<void, AppError>> deleteSupplement(String id) async {...}
}
```

#### Screens

```dart
// File: lib/presentation/screens/add_edit_supplement_screen.dart

/// Screen name: {Action}{Entity}Screen
class AddEditSupplementScreen extends StatefulWidget {
  // Parameters: Named, optional for editing
  final Supplement? editingSupplement;

  const AddEditSupplementScreen({
    super.key,
    this.editingSupplement,
  });

  @override
  State<AddEditSupplementScreen> createState() =>
      _AddEditSupplementScreenState();
}

class _AddEditSupplementScreenState extends State<AddEditSupplementScreen> {
  static final _log = logger.scope('AddEditSupplementScreen');

  // Form controllers: Named for their field
  late TextEditingController _nameController;
  late TextEditingController _dosageController;

  // Computed properties: Descriptive boolean names
  bool get _isEditing => widget.editingSupplement != null;

  // Private methods: Underscore prefix
  void _initializeControllers() {...}
  Future<void> _save() async {...}
  void _showError(String message) {...}
}
```

#### Widgets

```dart
// File: lib/presentation/widgets/supplement_card.dart

/// Widget name: Descriptive noun
class SupplementCard extends StatelessWidget {
  // Required parameters first
  final Supplement supplement;

  // Optional parameters with defaults
  final VoidCallback? onTap;
  final bool showDetails;

  const SupplementCard({
    super.key,
    required this.supplement,
    this.onTap,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {...}
}
```

---

## 3. Database Naming

### 3.1 Table Names

```sql
-- Tables: snake_case, plural
CREATE TABLE supplements (...);
CREATE TABLE condition_logs (...);
CREATE TABLE photo_entries (...);
CREATE TABLE user_accounts (...);
```

### 3.2 Column Names

```sql
-- Columns: snake_case
CREATE TABLE supplements (
  -- Primary key
  id TEXT PRIMARY KEY,

  -- Foreign keys: {table_singular}_id
  profile_id TEXT NOT NULL,

  -- Entity fields: snake_case
  name TEXT NOT NULL,
  dosage_amount REAL,
  supplement_form TEXT NOT NULL,

  -- Boolean fields: is_ prefix
  is_active INTEGER NOT NULL DEFAULT 1,

  -- Date fields: _at suffix or _date suffix (stored as epoch milliseconds INTEGER)
  created_at INTEGER NOT NULL,
  start_date INTEGER,

  -- Sync metadata: sync_ prefix (all timestamps as epoch milliseconds INTEGER)
  sync_created_at INTEGER NOT NULL,
  sync_updated_at INTEGER NOT NULL,
  sync_deleted_at INTEGER,
  sync_status INTEGER NOT NULL DEFAULT 0,  -- 0=pending, 1=synced, 2=conflict, 3=error
  sync_is_dirty INTEGER NOT NULL DEFAULT 1,
  sync_version INTEGER NOT NULL DEFAULT 1,

  FOREIGN KEY (profile_id) REFERENCES profiles(id)
);
```

### 3.3 Index Names

```sql
-- Indexes: idx_{table}_{column}
CREATE INDEX idx_supplements_profile_id ON supplements(profile_id);
CREATE INDEX idx_supplements_sync_status ON supplements(sync_status);
```

---

## 4. Test Naming

### 4.1 Test Files

```
test/
├── domain/
│   └── entities/
│       └── supplement_test.dart
├── data/
│   ├── models/
│   │   └── supplement_model_test.dart
│   ├── datasources/
│   │   └── local/
│   │       └── supplement_local_datasource_test.dart
│   └── repositories/
│       └── supplement_repository_impl_test.dart
└── presentation/
    ├── providers/
    │   └── supplement_provider_test.dart
    └── screens/
        └── add_edit_supplement_screen_test.dart
```

### 4.2 Test Names

```dart
void main() {
  group('SupplementRepository', () {
    // Pattern: methodName_condition_expectedResult
    // Note: All methods return Result type, so tests check isSuccess/isFailure

    // Read operations
    test('getAllSupplements_withProfileId_returnsSuccessWithList', () {...});
    test('getAllSupplements_withNoResults_returnsSuccessWithEmptyList', () {...});
    test('getById_existingId_returnsSuccessWithSupplement', () {...});
    test('getById_nonExistentId_returnsSuccessWithNull', () {...});
    test('getById_databaseError_returnsFailureWithDatabaseError', () {...});

    // Write operations
    test('create_validSupplement_returnsSuccessWithSupplement', () {...});
    test('create_duplicateId_returnsFailureWithConstraintViolation', () {...});
    test('update_existingSupplement_returnsSuccessWithUpdated', () {...});
    test('update_withMarkDirtyFalse_doesNotUpdateSyncMetadata', () {...});
    test('update_nonExistentId_returnsFailureWithNotFound', () {...});
    test('delete_existingId_returnsSuccessAndSoftDeletes', () {...});
  });
}
```

---

## 5. Localization Keys

### 5.1 ARB Key Naming

```json
{
  "@@locale": "en",

  // Screen titles: {screen}Title
  "addSupplementTitle": "Add Supplement",
  "editSupplementTitle": "Edit Supplement",
  "supplementsTitle": "Supplements",

  // Button labels: {action}Button
  "saveButton": "Save",
  "cancelButton": "Cancel",
  "deleteButton": "Delete",

  // Field labels: {field}Label
  "nameLabel": "Name",
  "dosageLabel": "Dosage",

  // Field hints: {field}Hint
  "nameHint": "Enter supplement name",
  "dosageHint": "Enter dosage amount",

  // Validation messages: {field}ValidationError or validation{Error}
  "nameRequired": "Name is required",
  "validationRequired": "{field} is required",
  "@validationRequired": {
    "placeholders": {
      "field": {"type": "String"}
    }
  },

  // Empty states: {feature}EmptyState
  "supplementsEmptyState": "No supplements yet",
  "supplementsEmptyStateHint": "Tap + to add your first supplement",

  // Error messages: error{Description}
  "errorLoadingSupplements": "Failed to load supplements",
  "errorSavingSupplement": "Failed to save supplement",

  // Confirmation dialogs: confirm{Action}
  "confirmDeleteSupplement": "Delete this supplement?",
  "confirmDeleteSupplementMessage": "This action cannot be undone.",

  // Accessibility labels: a11y{Element}{Action}
  "a11yAddSupplementButton": "Add new supplement",
  "a11ySupplementCard": "Supplement: {name}, {dosage}",
  "@a11ySupplementCard": {
    "placeholders": {
      "name": {"type": "String"},
      "dosage": {"type": "String"}
    }
  }
}
```

---

## 6. Constants and Configuration

### 6.1 Configuration Classes

```dart
// File: lib/core/config/app_constants.dart

/// Class name: Descriptive, ends in Constants/Config/Keys
class AppConstants {
  // Private constructor (utility class)
  AppConstants._();

  // Grouped by feature
  static const String appName = 'Shadow';
  static const String appVersion = '1.0.0';
}

class DatabaseConstants {
  DatabaseConstants._();

  static const String databaseName = 'shadow.db';
  static const int databaseVersion = 1;
}

class SecureStorageKeys {
  SecureStorageKeys._();

  // Key names: snake_case describing content
  static const String googleDriveAccessToken = 'google_drive_access_token';
  static const String googleDriveRefreshToken = 'google_drive_refresh_token';
}

class SyncConstants {
  SyncConstants._();

  static const Duration syncTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}
```

---

## 7. Service and Utility Naming

### 7.1 Services

```dart
// File: lib/core/services/encryption_service.dart

/// Service name: {Feature}Service
class EncryptionService {
  // Singleton pattern (if needed)
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  // Methods: Action verbs
  String encrypt(String plaintext) {...}
  String decrypt(String ciphertext) {...}
  String generateKey() {...}
}

// File: lib/core/services/logger_service.dart
class LoggerService {...}

// File: lib/core/services/device_info_service.dart
class DeviceInfoService {...}
```

### 7.2 Utilities

```dart
// File: lib/core/utils/date_utils.dart

/// Utility class: {Feature}Utils (static methods only)
class DateUtils {
  DateUtils._(); // Private constructor

  static String formatForDisplay(DateTime date) {...}
  static DateTime parseIso8601(String dateString) {...}
  static bool isSameDay(DateTime a, DateTime b) {...}
}

// File: lib/core/utils/validators.dart
class Validators {
  Validators._();

  static String? validateRequired(String? value, String fieldName) {...}
  static String? validateEmail(String? value) {...}
  static String? validatePositiveNumber(String? value) {...}
}
```

---

## 8. Exception Naming

```dart
// File: lib/core/errors/exceptions.dart

/// Exception name: Descriptive, ends in Exception
class EntityNotFoundException implements Exception {
  final String entityType;
  final String entityId;

  EntityNotFoundException({
    required this.entityType,
    required this.entityId,
  });
}

class DatabaseException implements Exception {...}
class CloudStorageException implements Exception {...}
class OAuthException implements Exception {...}
class UnauthorizedException implements Exception {...}
class ValidationException implements Exception {...}
class SyncConflictException implements Exception {...}
```

---

## 9. Quick Reference Table

| Item | Convention | Example |
|------|------------|---------|
| Entity class | UpperCamelCase, singular | `Supplement`, `FluidsEntry`, `NotificationSchedule` |
| Entity file | lowercase_underscore | `supplement.dart`, `fluids_entry.dart` |
| Repository interface | {Entity}Repository | `SupplementRepository`, `FluidsRepository` |
| Repository impl | {Entity}RepositoryImpl | `SupplementRepositoryImpl` |
| Data source | {Entity}LocalDataSource | `SupplementLocalDataSource` |
| Model | {Entity}Model | `SupplementModel`, `FluidsModel` |
| Provider | {Feature}Provider | `SupplementProvider`, `FluidsProvider`, `NotificationProvider` |
| Screen | {Action}{Entity}Screen | `AddEditSupplementScreen`, `NotificationSettingsScreen` |
| Widget | Descriptive noun | `SupplementCard`, `FlowIntensityPicker`, `BBTChart` |
| Database table | snake_case, plural | `supplements`, `fluids_entries`, `notification_schedules` |
| Database column | snake_case | `profile_id`, `menstruation_flow`, `basal_body_temperature` |
| Test method | method_condition_result | `getSupplement_existingId_returns` |
| l10n key | camelCase with prefix | `addSupplementTitle`, `fluidsTab`, `notificationSettings` |
| Constant class | {Feature}Constants | `DatabaseConstants` |
| Service | {Feature}Service | `EncryptionService`, `NotificationService` |
| Exception | {Description}Exception | `EntityNotFoundException` |

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
| 1.1 | 2026-01-30 | Added Fluids naming (replacing BowelUrine), NotificationSchedule naming, DietType/MenstruationFlow enums |
