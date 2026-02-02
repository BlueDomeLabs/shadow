# Shadow Coding Standards

**Version:** 1.0
**Last Updated:** January 30, 2026
**Compliance:** MANDATORY - All code must meet these standards before merge

---

## Table of Contents

1. [Philosophy](#1-philosophy)
2. [Architecture Standards](#2-architecture-standards)
3. [Repository Pattern Standards](#3-repository-pattern-standards)
4. [Data Source Standards](#4-data-source-standards)
5. [Entity Standards](#5-entity-standards)
6. [Provider Standards](#6-provider-standards)
7. [Error Handling Standards](#7-error-handling-standards)
8. [Database Standards](#8-database-standards)
9. [Sync System Standards](#9-sync-system-standards)
10. [Testing Standards](#10-testing-standards)
11. [Security Standards](#11-security-standards)
12. [Performance Standards](#12-performance-standards)
13. [Accessibility Standards](#13-accessibility-standards)
14. [Documentation Standards](#14-documentation-standards)
15. [Code Review Standards](#15-code-review-standards)

---

## 1. Philosophy

### 1.1 Core Principles

1. **Consistency Over Cleverness**: Predictable code is maintainable code
2. **Explicit Over Implicit**: Make intentions clear
3. **Test First**: Write tests before or alongside implementation
4. **Security by Default**: Consider security implications of every decision
5. **Accessibility Always**: Every feature must be accessible

### 1.2 Apple Engineering Standards

This project follows engineering principles used at Apple:

- **Code Ownership**: Every file has a clear owner responsible for quality
- **Design Review**: Architecture changes require design review
- **No Broken Windows**: Fix issues immediately, don't accumulate debt
- **Documentation as Code**: Documentation is part of the deliverable
- **Ship Quality**: Don't ship anything you wouldn't be proud of

---

## 2. Architecture Standards

### 2.1 Clean Architecture Layers

```
┌─────────────────────────────────────────────┐
│              PRESENTATION LAYER              │
│  (Screens, Widgets, Providers)              │
├─────────────────────────────────────────────┤
│                DOMAIN LAYER                  │
│  (Entities, Repository Interfaces, UseCases)│
├─────────────────────────────────────────────┤
│                 DATA LAYER                   │
│  (Repository Impl, DataSources, Models)     │
└─────────────────────────────────────────────┘
```

### 2.2 Dependency Rules

- **Presentation depends on Domain**: Never directly on Data
- **Domain has no dependencies**: Pure business logic
- **Data depends on Domain**: Implements domain interfaces

### 2.3 File Organization

```
lib/
├── core/                    # Cross-cutting concerns
│   ├── config/             # Configuration classes
│   ├── errors/             # Exception definitions
│   ├── services/           # Shared services
│   ├── utils/              # Utility functions
│   └── repositories/       # Base repository class
├── domain/                  # Business logic layer
│   ├── entities/           # Domain models
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business use cases
├── data/                    # Data access layer
│   ├── repositories/       # Repository implementations
│   ├── datasources/        # Data sources
│   │   ├── local/         # SQLite datasources
│   │   └── remote/        # API datasources
│   ├── models/            # Data transfer objects
│   └── cloud/             # Cloud provider implementations
├── presentation/            # UI layer
│   ├── screens/           # Full-page screens
│   ├── widgets/           # Reusable components
│   ├── providers/         # State management
│   └── theme/             # Theme configuration
└── l10n/                   # Localization files
```

---

## 3. Repository Pattern Standards

### 3.1 Interface Naming

Repository interfaces live in `lib/domain/repositories/` and define the contract:

```dart
// CORRECT: Interface in domain layer using Result pattern
abstract class SupplementRepository {
  Future<Result<List<Supplement>, AppError>> getAllSupplements({
    required String profileId,
  });
  Future<Result<Supplement, AppError>> getById(String id);
  Future<Result<Supplement, AppError>> create(Supplement supplement);
  Future<Result<Supplement, AppError>> update(
    Supplement supplement,
    {bool markDirty = true},
  );
  Future<Result<void, AppError>> delete(String id);
  Future<Result<void, AppError>> hardDelete(String id);
}
```

**Note:** All repository methods return `Result<T, AppError>` - never throw exceptions.
See `16_ERROR_HANDLING.md` and `22_API_CONTRACTS.md` for Result type definition.

### 3.2 Implementation Naming

Implementations live in `lib/data/repositories/`:

```dart
// CORRECT: Implementation in data layer
class SupplementRepositoryImpl extends BaseRepository<Supplement>
    implements SupplementRepository {
  final SupplementLocalDataSource localDataSource;

  SupplementRepositoryImpl(
    this.localDataSource,
    Uuid uuid,
    DeviceInfoService deviceInfoService,
  ) : super(uuid, deviceInfoService);

  // Implementation methods...
}
```

### 3.3 Method Naming Conventions

**All methods return `Result<T, AppError>` - never throw exceptions.**

| Operation | Method Name | Returns | On Failure |
|-----------|-------------|---------|------------|
| Get all | `getAll{Entity}s` | `Result<List<Entity>, AppError>` | `DatabaseError` |
| Get by ID | `getById` | `Result<Entity, AppError>` | `NotFoundError` |
| Create | `create` | `Result<Entity, AppError>` | `ValidationError`, `DatabaseError` |
| Update | `update` | `Result<Entity, AppError>` | `NotFoundError`, `ValidationError` |
| Delete (soft) | `delete` | `Result<void, AppError>` | `NotFoundError` |
| Delete (hard) | `hardDelete` | `Result<void, AppError>` | `NotFoundError` |

**Handling Results:**
```dart
// CORRECT: Use Result pattern
final result = await repository.getById(id);
result.when(
  success: (supplement) => /* use supplement */,
  failure: (error) => _log.error('Failed: ${error.message}'),
);

// INCORRECT: Never use try-catch with repositories
try {
  await repository.getById(id);  // Wrong - doesn't return Result
} catch (e) { ... }
```

### 3.4 BaseRepository Class

All repository implementations MUST extend BaseRepository:

> **CANONICAL:** See `05_IMPLEMENTATION_ROADMAP.md` Section 2.6 for full implementation.

```dart
/// Base class for all repositories with sync support.
/// Provides ID generation and sync metadata helpers.
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
  Future<T> prepareForUpdate<T>(
    T entity,
    T Function(SyncMetadata syncMetadata) copyWith, {
    bool markDirty = true,
    required SyncMetadata Function(T) getSyncMetadata,
  }) async {
    if (!markDirty) return entity;
    final deviceId = await _deviceInfoService.getDeviceId();
    final existingMetadata = getSyncMetadata(entity);
    return copyWith(existingMetadata.markModified(deviceId));
  }

  /// Prepare entity for soft delete
  Future<T> prepareForDelete<T>(
    T entity,
    T Function(SyncMetadata syncMetadata) copyWith, {
    required SyncMetadata Function(T) getSyncMetadata,
  }) async {
    final deviceId = await _deviceInfoService.getDeviceId();
    final existingMetadata = getSyncMetadata(entity);
    return copyWith(existingMetadata.markDeleted(deviceId));
  }
}
```

### 3.5 Repository Implementation Pattern

All repository implementations MUST use BaseRepository helpers and return Result:

```dart
// CREATE: Use prepareForCreate, return Success/Failure
@override
Future<Result<Supplement, AppError>> create(Supplement supplement) async {
  try {
    final supplementWithSync = await prepareForCreate(
      supplement,
      (id, syncMetadata) => supplement.copyWith(
        id: id,
        syncMetadata: syncMetadata,
      ),
    );
    await localDataSource.insertSupplement(
      SupplementModel.fromEntity(supplementWithSync)
    );
    return Success(supplementWithSync);
  } catch (e, stackTrace) {
    _log.error('Create failed', e, stackTrace);
    return Failure(DatabaseError.fromException(e));
  }
}

// UPDATE: Use prepareForUpdate, return Success/Failure
@override
Future<Result<Supplement, AppError>> update(
  Supplement supplement,
  {bool markDirty = true},
) async {
  try {
    final supplementWithSync = await prepareForUpdate(
      supplement,
      (syncMetadata) => supplement.copyWith(syncMetadata: syncMetadata),
      markDirty: markDirty,
      getSyncMetadata: (s) => s.syncMetadata,
    );
    await localDataSource.updateSupplement(
      SupplementModel.fromEntity(supplementWithSync)
    );
    return Success(supplementWithSync);
  } catch (e, stackTrace) {
    _log.error('Update failed', e, stackTrace);
    return Failure(DatabaseError.fromException(e));
  }
}

// DELETE: Use prepareForDelete (soft delete), return Success/Failure
@override
Future<Result<void, AppError>> delete(String id) async {
  try {
    final supplement = await localDataSource.getSupplement(id);
    if (supplement == null) {
      return Failure(DatabaseError.notFound('Supplement', id));
    }
    final supplementWithSync = await prepareForDelete(
      supplement,
      (syncMetadata) => supplement.copyWith(syncMetadata: syncMetadata),
      getSyncMetadata: (s) => s.syncMetadata,
    );
    await localDataSource.updateSupplement(
      SupplementModel.fromEntity(supplementWithSync)
    );
    return const Success(null);
  } catch (e, stackTrace) {
    _log.error('Delete failed', e, stackTrace);
    return Failure(DatabaseError.fromException(e));
  }
}
```

---

## 4. Data Source Standards

**Exception vs Result Pattern:**
- **Data Sources MAY throw exceptions** (e.g., `DatabaseException`, `SQLException`)
- **Repositories MUST catch exceptions** and wrap in `Result<T, AppError>`
- Data sources deal with raw database operations; repositories handle business error semantics

### 4.1 Interface Pattern

Every data source MUST have an abstract interface:

```dart
abstract class SupplementLocalDataSource {
  Future<List<Supplement>> getAllSupplements({
    String? profileId,
    int? limit,
    int? offset,
  });
  Future<Supplement> getSupplement(String id);
  Future<Supplement?> findSupplement(String id);
  Future<void> insertSupplement(SupplementModel supplement);
  Future<void> updateSupplement(SupplementModel supplement);
}
```

### 4.2 Implementation Requirements

```dart
class SupplementLocalDataSourceImpl implements SupplementLocalDataSource {
  final DatabaseHelper databaseHelper;

  SupplementLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<List<Supplement>> getAllSupplements({
    String? profileId,
    int? limit,
    int? offset,
  }) async {
    final db = await databaseHelper.database;

    // REQUIRED: Always filter by profileId when provided
    String whereClause = 'sync_deleted_at IS NULL';
    List<dynamic> whereArgs = [];

    if (profileId != null) {
      whereClause += ' AND profile_id = ?';
      whereArgs.add(profileId);
    }

    final result = await db.query(
      'supplements',
      where: whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      limit: limit,
      offset: offset,
      orderBy: 'sync_created_at DESC',
    );

    return result.map((map) => SupplementModel.fromMap(map).toEntity()).toList();
  }
}
```

### 4.3 ProfileId Filtering

**MANDATORY**: All data source methods that return lists MUST support profileId filtering:

```dart
// CORRECT: ProfileId filtering supported
Future<List<Condition>> getAllConditions({
  String? profileId,
  int? limit,
  int? offset,
});

// INCORRECT: No profileId parameter
Future<List<Condition>> getAllConditions();
```

---

## 5. Entity Standards

### 5.0 Code Generation Requirement

**All entities MUST use Freezed for code generation.**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplement.freezed.dart';
part 'supplement.g.dart';

@freezed
class Supplement with _$Supplement {
  const Supplement._(); // Required for custom methods/getters

  const factory Supplement({
    required String id,
    required String clientId,     // Required for database merging
    required String profileId,
    required String name,
    String? brand,
    @Default([]) List<SupplementIngredient> ingredients,
    required SyncMetadata syncMetadata,
  }) = _Supplement;

  factory Supplement.fromJson(Map<String, dynamic> json) =>
      _$SupplementFromJson(json);

  // Computed properties (optional)
  bool get hasIngredients => ingredients.isNotEmpty;
}
```

**Benefits:**
- `copyWith` generated automatically
- Immutability enforced at compile time
- `equals`/`hashCode` generated correctly
- JSON serialization generated via json_serializable
- Pattern matching support

### 5.1 Required Entity Fields

All entities in `lib/domain/entities/` MUST include:

| Field | Type | Purpose |
|-------|------|---------|
| `id` | `String` | Unique identifier (UUID) |
| `clientId` | `String` | Client identifier for database merging |
| `profileId` | `String` | Profile scope identifier |
| `syncMetadata` | `SyncMetadata` | Sync tracking data |

```dart
@freezed
class Supplement with _$Supplement {
  const factory Supplement({
    required String id,
    required String clientId,     // REQUIRED: For database merging
    required String profileId,    // REQUIRED: Profile scope
    required String name,
    // ... entity-specific fields
    required SyncMetadata syncMetadata,  // REQUIRED: Sync tracking
  }) = _Supplement;
}
```

### 5.2 Null Safety and Default Values

| Field Type | Approach | Example |
|------------|----------|---------|
| Required String | `required String` | `required String name` |
| Optional String | `String?` | `String? brand` |
| Required List (always loaded) | `@Default([])` | `@Default([]) List<Ingredient> ingredients` |
| Optional List (loaded on demand) | `List?` | `List<IntakeLog>? recentLogs` |
| Required DateTime | `required DateTime` | `required DateTime scheduledAt` |
| Optional DateTime | `DateTime?` | `DateTime? completedAt` |
| Enum with default | `@Default(EnumType.value)` | `@Default(SupplementForm.capsule) SupplementForm form` |

```dart
@freezed
class Diet with _$Diet {
  const factory Diet({
    required String id,
    required String clientId,
    required String profileId,
    String? presetId,                    // Optional - null if custom
    @Default([]) List<DietRule> rules,   // Always loaded with Diet
    List<DietViolation>? violations,     // Loaded on demand
    required SyncMetadata syncMetadata,
  }) = _Diet;
}
```

### 5.3 SyncMetadata Requirements

Every syncable entity MUST include SyncMetadata.

> **CANONICAL:** See `22_API_CONTRACTS.md` Section 3.1 for authoritative @freezed definition.

```dart
@freezed
class SyncMetadata with _$SyncMetadata {
  const SyncMetadata._();

  const factory SyncMetadata({
    required int syncCreatedAt,      // Epoch milliseconds - IMMUTABLE after creation
    required int syncUpdatedAt,      // Epoch milliseconds - Updated on every change
    int? syncDeletedAt,              // Epoch milliseconds - Set on soft delete (null = active)
    @Default(SyncStatus.pending) SyncStatus syncStatus,
    @Default(1) int syncVersion,     // Optimistic concurrency version
    required String syncDeviceId,    // Device that last modified
    @Default(true) bool syncIsDirty, // Has unsynchronized changes
    String? conflictData,            // JSON of conflicting record
  }) = _SyncMetadata;

  factory SyncMetadata.fromJson(Map<String, dynamic> json) =>
      _$SyncMetadataFromJson(json);

  /// Creates initial SyncMetadata for new entities
  factory SyncMetadata.create({required String deviceId}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return SyncMetadata(
      syncCreatedAt: now,
      syncUpdatedAt: now,
      syncDeviceId: deviceId,
    );
  }

  /// Whether entity is soft-deleted
  bool get isDeleted => syncDeletedAt != null;

  /// Mark as modified (updates timestamp and dirty flag)
  SyncMetadata markModified(String deviceId) => copyWith(
    syncUpdatedAt: DateTime.now().millisecondsSinceEpoch,
    syncDeviceId: deviceId,
    syncIsDirty: true,
    syncStatus: SyncStatus.modified,
    syncVersion: syncVersion + 1,
  );

  /// Mark as synced (clears dirty flag)
  SyncMetadata markSynced() => copyWith(
    syncIsDirty: false,
    syncStatus: SyncStatus.synced,
  );

  /// Mark as soft deleted
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

**Mutation Rules:**
| Field | Mutability | When Changed |
|-------|------------|--------------|
| createdAt | IMMUTABLE | Never after creation |
| createdByDeviceId | IMMUTABLE | Never after creation |
| updatedAt | Mutable | Every local change |
| version | Mutable | Increment on every change |
| lastModifiedByDeviceId | Mutable | Every local change |
| deletedAt | Mutable | Set on soft delete only |
| lastSyncedAt | Mutable | After successful sync |
| syncStatus | Mutable | Based on sync state |

### 5.4 Computed Properties

Entities MAY include read-only computed properties:

```dart
@freezed
class Diet with _$Diet {
  const Diet._();  // Required for custom getters

  const factory Diet({
    String? presetId,
    // ... other fields
  }) = _Diet;

  // Computed properties - O(1) only, no async, no repository access
  bool get isPreset => presetId != null;
  bool get isCustom => presetId == null;
}
```

**Rules for computed properties:**
1. Use only for simple O(1) calculations
2. Never perform async operations
3. Never access repositories or services
4. Document what they compute

---

## 6. Provider Standards

**STATE MANAGEMENT FRAMEWORK**: Riverpod with code generation

All providers MUST use Riverpod annotation syntax and delegate to UseCases.
See `05_IMPLEMENTATION_ROADMAP.md` Section 0.2 for configuration.

### 6.1 Provider Structure (Riverpod)

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supplement_provider.g.dart';

/// Provider for supplement list with profile scope
@riverpod
class SupplementList extends _$SupplementList {
  static final _log = logger.scope('SupplementList');

  @override
  Future<List<Supplement>> build(String profileId) async {
    // Delegate to UseCase - never call repository directly
    final useCase = ref.read(getSupplementsUseCaseProvider);
    final result = await useCase(GetSupplementsInput(profileId: profileId));

    return result.when(
      success: (supplements) => supplements,
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;  // AsyncValue will handle as error state
      },
    );
  }

  /// Add a supplement (mutation)
  Future<void> addSupplement(Supplement supplement) async {
    // Check write access
    final authService = ref.read(profileAuthServiceProvider);
    if (!authService.canWrite(supplement.profileId)) {
      throw AuthError(
        code: 'AUTH_002',
        message: 'Write access required for profile ${supplement.profileId}',
      );
    }

    // Delegate to UseCase
    final useCase = ref.read(createSupplementUseCaseProvider);
    final result = await useCase(supplement);

    result.when(
      success: (_) => ref.invalidateSelf(),  // Refresh list
      failure: (error) {
        _log.error('Add failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Update a supplement
  Future<void> updateSupplement(Supplement supplement) async {
    final authService = ref.read(profileAuthServiceProvider);
    if (!authService.canWrite(supplement.profileId)) {
      throw AuthError(code: 'AUTH_002', message: 'Write access required');
    }

    final useCase = ref.read(updateSupplementUseCaseProvider);
    final result = await useCase(supplement);

    result.when(
      success: (_) => ref.invalidateSelf(),
      failure: (error) => throw error,
    );
  }

  /// Delete a supplement
  Future<void> deleteSupplement(String id) async {
    final useCase = ref.read(deleteSupplementUseCaseProvider);
    final result = await useCase(id);

    result.when(
      success: (_) => ref.invalidateSelf(),
      failure: (error) => throw error,
    );
  }
}
```

### 6.2 UseCase Delegation (MANDATORY)

Providers MUST delegate to UseCases, NOT repositories directly:

```dart
// CORRECT: Provider calls UseCase
@riverpod
class SupplementList extends _$SupplementList {
  @override
  Future<List<Supplement>> build(String profileId) async {
    final useCase = ref.read(getSupplementsUseCaseProvider);
    final result = await useCase(GetSupplementsInput(profileId: profileId));
    // ...
  }
}

// INCORRECT: Direct repository access (no authorization, no validation)
@riverpod
class SupplementList extends _$SupplementList {
  @override
  Future<List<Supplement>> build(String profileId) async {
    final repo = ref.read(supplementRepositoryProvider);
    return await repo.getAllSupplements(profileId: profileId);  // WRONG
  }
}
```

**Benefits of UseCase delegation:**
- UseCases handle authorization checks
- UseCases handle validation
- Single source of business logic
- Easier testing with UseCase mocks

### 6.3 Result Pattern in Providers

Handle `Result<T, AppError>` from UseCases:

```dart
@riverpod
class SupplementList extends _$SupplementList {
  @override
  Future<List<Supplement>> build(String profileId) async {
    final result = await useCase(input);

    // Option 1: Throw on failure (AsyncValue handles as error)
    return result.when(
      success: (data) => data,
      failure: (error) => throw error,
    );

    // Option 2: Return custom state with error
    // Use this if you need more control over error display
  }
}

// In UI: Watch provider and handle states
Widget build(BuildContext context, WidgetRef ref) {
  final supplementsAsync = ref.watch(supplementListProvider(profileId));

  return supplementsAsync.when(
    data: (supplements) => SupplementListView(supplements: supplements),
    loading: () => const LoadingIndicator(),
    error: (error, stack) => ErrorDisplay(
      message: error is AppError ? error.userMessage : 'An error occurred',
      onRetry: () => ref.invalidate(supplementListProvider(profileId)),
    ),
  );
}
```

### 6.4 Write Access Pattern

Every mutation method MUST check write access:

```dart
Future<void> addSupplement(Supplement supplement) async {
  // REQUIRED: Check before any mutation
  final authService = ref.read(profileAuthServiceProvider);
  if (!authService.canWrite(supplement.profileId)) {
    throw AuthError(
      code: 'AUTH_002',
      message: 'Write access required for profile ${supplement.profileId}',
    );
  }

  // Proceed with mutation via UseCase
  final result = await useCase(supplement);
  // ...
}
```

**Note:** Authorization is also checked in UseCase layer for defense-in-depth.

### 6.5 Profile Filtering (MANDATORY)

Every data load MUST include profileId:

```dart
@riverpod
class SupplementList extends _$SupplementList {
  @override
  Future<List<Supplement>> build(String profileId) async {
    // profileId is a REQUIRED build parameter - enforced at compile time
    final result = await useCase(GetSupplementsInput(
      profileId: profileId,  // REQUIRED - never optional
    ));
    // ...
  }
}

// In UI: Pass profile ID explicitly
final supplements = ref.watch(supplementListProvider(currentProfileId));
```

### 6.6 Provider Rules Summary

1. **Use Riverpod**: All providers use `@riverpod` annotation
2. **Delegate to UseCases**: Never call repositories directly
3. **Handle Result Type**: Use `.when()` to handle success/failure
4. **Check Write Access**: Verify permissions before mutations
5. **Profile Filtering**: ProfileId is required parameter, not optional
6. **Invalidate on Mutation**: Call `ref.invalidateSelf()` after successful writes
7. **Let AsyncValue Handle Loading**: Don't manually track loading state

---

## 7. Error Handling Standards

> **Complete Implementation:** See `16_ERROR_HANDLING.md` for full error handling patterns including recovery strategies, UI integration, and logging. This section provides the canonical interface definition.

### 7.1 Result Pattern and AppError Hierarchy

**All domain operations use `Result<T, AppError>` - never throw exceptions.**

Define error types in `lib/core/errors/app_error.dart`:

```dart
/// Recovery action to suggest to users
enum RecoveryAction {
  none,           // No recovery possible
  retry,          // User can retry the operation
  refreshToken,   // Need to refresh auth token
  reAuthenticate, // Need full re-authentication
  goToSettings,   // User should go to settings
  contactSupport, // User should contact support
}

/// Base sealed class for all application errors
sealed class AppError {
  String get code;
  String get message;
  String get userMessage;
  StackTrace? get stackTrace;
  dynamic get originalError;
  bool get isRecoverable;
  RecoveryAction get recoveryAction;

  /// Factory to create appropriate error from exception
  static AppError fromException(dynamic e, [StackTrace? stackTrace]) {
    if (e is AppError) return e;
    return UnknownError(message: e.toString(), stackTrace: stackTrace);
  }
}

/// Database operation errors
final class DatabaseError extends AppError {
  @override final String code;
  @override final String message;
  @override final String userMessage;
  @override final StackTrace? stackTrace;
  @override final dynamic originalError;
  @override bool get isRecoverable => true;
  @override RecoveryAction get recoveryAction => RecoveryAction.retry;
  final String? operation;

  DatabaseError({
    required this.code,
    required this.message,
    this.userMessage = 'A database error occurred. Please try again.',
    this.stackTrace,
    this.originalError,
    this.operation,
  });

  factory DatabaseError.fromException(dynamic e, [StackTrace? st]) =>
    DatabaseError(code: 'DB_001', message: e.toString(), stackTrace: st, originalError: e);
}

/// Entity not found error
final class NotFoundError extends AppError {
  @override final String code = 'DB_002';
  @override final String message;
  @override final String userMessage;
  @override final StackTrace? stackTrace;
  @override dynamic get originalError => null;
  @override bool get isRecoverable => false;
  @override RecoveryAction get recoveryAction => RecoveryAction.none;
  final String entityType;
  final String entityId;

  NotFoundError({
    required this.entityType,
    required this.entityId,
    this.stackTrace,
  }) : message = '$entityType with id $entityId not found',
       userMessage = '$entityType not found.';
}

/// Network/API errors
final class NetworkError extends AppError {
  @override final String code;
  @override final String message;
  @override final String userMessage;
  @override final StackTrace? stackTrace;
  @override final dynamic originalError;
  @override bool get isRecoverable => true;
  @override RecoveryAction get recoveryAction => RecoveryAction.retry;

  NetworkError({
    required this.code,
    required this.message,
    this.userMessage = 'Network error. Check your connection.',
    this.stackTrace,
    this.originalError,
  });
}

/// Authentication/authorization errors
final class AuthError extends AppError {
  @override final String code;
  @override final String message;
  @override final String userMessage;
  @override final StackTrace? stackTrace;
  @override final dynamic originalError;
  @override final bool isRecoverable;
  @override final RecoveryAction recoveryAction;

  AuthError({
    required this.code,
    required this.message,
    this.userMessage = 'Authentication required.',
    this.stackTrace,
    this.originalError,
    this.isRecoverable = true,
    this.recoveryAction = RecoveryAction.reAuthenticate,
  });
}

/// Input validation errors
final class ValidationError extends AppError {
  @override final String code;
  @override final String message;
  @override final String userMessage;
  @override final StackTrace? stackTrace;
  @override dynamic get originalError => null;
  @override bool get isRecoverable => true;
  @override RecoveryAction get recoveryAction => RecoveryAction.none;

  /// Field-specific errors: field name -> list of error messages
  final Map<String, List<String>> fieldErrors;

  // Standard validation error codes
  static const String codeRequired = 'VAL_REQUIRED';
  static const String codeInvalidFormat = 'VAL_INVALID_FORMAT';
  static const String codeOutOfRange = 'VAL_OUT_OF_RANGE';
  static const String codeTooLong = 'VAL_TOO_LONG';
  static const String codeTooShort = 'VAL_TOO_SHORT';
  static const String codeDuplicate = 'VAL_DUPLICATE';

  ValidationError({
    required this.code,
    required this.message,
    required this.userMessage,
    this.fieldErrors = const {},
    this.stackTrace,
  });

  /// Factory for required field validation
  factory ValidationError.required(String fieldName) => ValidationError(
    code: codeRequired,
    message: '$fieldName is required',
    userMessage: 'Please provide $fieldName.',
    fieldErrors: {fieldName: ['Required']},
  );

  /// Factory for out of range validation
  factory ValidationError.outOfRange(String fieldName, num value, num min, num max) => ValidationError(
    code: codeOutOfRange,
    message: '$fieldName value $value is out of range [$min, $max]',
    userMessage: '$fieldName must be between $min and $max.',
    fieldErrors: {fieldName: ['Must be between $min and $max']},
  );
}

/// Sync-related errors
final class SyncError extends AppError {
  @override final String code;
  @override final String message;
  @override final String userMessage;
  @override final StackTrace? stackTrace;
  @override final dynamic originalError;
  @override bool get isRecoverable => true;
  @override RecoveryAction get recoveryAction => RecoveryAction.retry;

  SyncError({
    required this.code,
    required this.message,
    this.userMessage = 'Sync failed. Will retry automatically.',
    this.stackTrace,
    this.originalError,
  });
}

/// Notification-related errors
final class NotificationError extends AppError {
  @override final String code;
  @override final String message;
  @override final String userMessage;
  @override final StackTrace? stackTrace;
  @override final dynamic originalError;
  @override final bool isRecoverable;
  @override final RecoveryAction recoveryAction;

  NotificationError({
    required this.code,
    required this.message,
    this.userMessage = 'Notification error.',
    this.stackTrace,
    this.originalError,
    this.isRecoverable = true,
    this.recoveryAction = RecoveryAction.goToSettings,
  });

  factory NotificationError.permissionDenied() => NotificationError(
    code: 'NOTIF_PERMISSION_DENIED',
    message: 'Notification permissions not granted',
    userMessage: 'Please enable notifications in Settings.',
    recoveryAction: RecoveryAction.goToSettings,
  );
}

/// Unknown/unexpected errors
final class UnknownError extends AppError {
  @override final String code = 'UNKNOWN';
  @override final String message;
  @override final String userMessage;
  @override final StackTrace? stackTrace;
  @override final dynamic originalError;
  @override bool get isRecoverable => false;
  @override RecoveryAction get recoveryAction => RecoveryAction.contactSupport;

  UnknownError({
    required this.message,
    this.userMessage = 'An unexpected error occurred.',
    this.stackTrace,
    this.originalError,
  });
}
```

### 7.2 Error Handling Rules

1. **Use Result Pattern**: All repository/usecase methods return `Result<T, AppError>`
2. **Never Throw from Repositories**: Wrap exceptions and return as `Result.failure`
3. **User-Friendly Messages**: `userMessage` is shown to users, `message` is for logs
4. **Log with Context**: Include operation, entity type, IDs in log calls
5. **Recover When Possible**: Provide fallback behavior for non-critical errors

```dart
// CORRECT: Handle Result pattern
final result = await repository.getById(id);
result.when(
  success: (supplement) {
    // Use supplement
  },
  failure: (error) {
    _log.error('Get supplement failed', error.message, error.stackTrace);
    showSnackBar(error.userMessage);
  },
);

// CORRECT: Chain operations with Result
Future<Result<void, AppError>> logIntake(String supplementId) async {
  final supplementResult = await supplementRepository.getById(supplementId);

  return supplementResult.when(
    success: (supplement) async {
      final log = IntakeLog(supplementId: supplement.id, ...);
      return await intakeLogRepository.create(log);
    },
    failure: (error) => Result.failure(error),
  );
}

// INCORRECT: Never use try-catch with Result-returning methods
try {
  final result = await repository.getById(id);  // Wrong pattern
} catch (e) {
  // This won't catch Result.failure - it returns normally
}
```

### 7.3 Error Code Registry

**Common error codes** (quick reference):

| Code | Type | Description |
|------|------|-------------|
| DB_001 | DatabaseError | Query execution failed |
| DB_002 | NotFoundError | Entity not found |
| DB_003 | DatabaseError | Constraint violation |
| NET_001 | NetworkError | Connection timeout |
| NET_002 | NetworkError | No internet connection |
| AUTH_001 | AuthError | Token expired |
| AUTH_002 | AuthError | Unauthorized profile access |
| VAL_001 | ValidationError | Required field missing |
| VAL_002 | ValidationError | Value out of range |
| SYNC_001 | SyncError | Conflict detected |
| SYNC_002 | SyncError | Merge failed |

> **Canonical Source:** See `22_API_CONTRACTS.md` Section 7 for the complete error code registry (62+ codes) with all validation rules, field-specific codes, and error payloads.

---

## 8. Database Standards

### 8.1 Table Naming

- Tables: `snake_case` plural (e.g., `supplements`, `condition_logs`)
- Columns: `snake_case` (e.g., `created_at`, `profile_id`)
- Foreign Keys: `{table_singular}_id` (e.g., `supplement_id`)

### 8.2 Required Columns

Every health data table MUST have these columns:

```sql
CREATE TABLE supplements (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,      -- REQUIRED: For database merging
  profile_id TEXT NOT NULL,
  name TEXT NOT NULL,
  -- ... entity-specific columns ...

  -- REQUIRED: Sync metadata columns (INTEGER for timestamps)
  sync_created_at INTEGER NOT NULL,
  sync_updated_at INTEGER NOT NULL,
  sync_deleted_at INTEGER,
  sync_last_synced_at INTEGER,
  sync_status INTEGER NOT NULL DEFAULT 0,  -- 0=pending, 1=synced, 2=conflict, 3=error
  sync_version INTEGER NOT NULL DEFAULT 1,
  sync_is_dirty INTEGER NOT NULL DEFAULT 1,
  sync_device_id TEXT NOT NULL,            -- Last device to modify

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
);
```

### 8.2.1 Tables Exempt from Sync Metadata

The following tables are local-only and do NOT require sync metadata:

| Table | Reason |
|-------|--------|
| `profile_access_logs` | Immutable audit trail |
| `imported_data_log` | Import deduplication only |
| `ml_models` | Device-local ML artifacts |
| `prediction_feedback` | Device-local feedback |

### 8.3 Date Storage

- **Format**: Epoch milliseconds (INTEGER)
- **Storage**: INTEGER columns for performance
- **Timezone**: Always UTC

```dart
// CORRECT: Convert DateTime to epoch milliseconds
int dateToEpoch(DateTime dt) => dt.toUtc().millisecondsSinceEpoch;

// CORRECT: Convert epoch milliseconds to DateTime
DateTime epochToDate(int epoch) =>
    DateTime.fromMillisecondsSinceEpoch(epoch, isUtc: true);

// Usage in Model
class SupplementModel {
  static SupplementModel fromMap(Map<String, dynamic> map) {
    return SupplementModel(
      createdAt: epochToDate(map['sync_created_at'] as int),
      // ...
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sync_created_at': dateToEpoch(createdAt),
      // ...
    };
  }
}
```

### 8.4 Index Guidelines

**Required indexes for EVERY health data table:**

```sql
-- Foreign key index
CREATE INDEX idx_{table}_profile ON {table}(profile_id);

-- Client scope index
CREATE INDEX idx_{table}_client ON {table}(client_id);

-- Sync query index (composite for efficient dirty record lookup)
CREATE INDEX idx_{table}_sync ON {table}(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
```

**For frequently queried columns:**

```sql
-- Timestamp range queries
CREATE INDEX idx_{table}_timestamp ON {table}(profile_id, timestamp DESC);

-- Name/search queries
CREATE INDEX idx_{table}_name ON {table}(profile_id, name COLLATE NOCASE);
```

**Avoid indexing:**
- Low cardinality boolean fields alone (unless combined with other fields)
- TEXT fields used for LIKE queries (use FTS5 instead)
- Columns rarely used in WHERE clauses

### 8.5 Migration Strategy

**Migration naming:** `v{from}_to_v{to}_{description}.sql`

Example: `v6_to_v7_add_wearable_tables.sql`

**Requirements:**
1. Each migration MUST be idempotent (safe to run multiple times)
2. Include version check: `PRAGMA user_version = X`
3. Wrap in transaction where possible
4. Test against production data snapshot before release
5. Document rollback procedure for each migration

### 8.6 Transaction Handling

**When to use transactions:**

| Scenario | Transaction Required | Example |
|----------|---------------------|---------|
| Multi-table writes | **YES** | Delete supplement + cascade to intake_logs |
| Batch inserts | **YES** | Importing multiple food items |
| Read-modify-write | **YES** | Increment counter, update sync version |
| Single row insert/update | No | Creating one supplement |
| Read-only queries | No | Fetching list of conditions |

**Transaction patterns:**

```dart
// Pattern 1: Simple transaction with rollback on error
Future<Result<void, AppError>> deleteSupplementWithCascade(String id) async {
  final db = await databaseHelper.database;

  try {
    await db.transaction((txn) async {
      // 1. Delete child records first (foreign key order)
      await txn.delete(
        'intake_logs',
        where: 'supplement_id = ?',
        whereArgs: [id],
      );

      // 2. Delete parent record
      await txn.delete(
        'supplements',
        where: 'id = ?',
        whereArgs: [id],
      );
    });
    return const Success(null);
  } catch (e, stackTrace) {
    // Transaction automatically rolled back on exception
    return Failure(DatabaseError.deleteFailed('supplements', id, e, stackTrace));
  }
}

// Pattern 2: Transaction with explicit batch for performance
Future<Result<int, AppError>> importFoodItems(List<FoodItem> items) async {
  final db = await databaseHelper.database;

  try {
    int count = 0;
    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final item in items) {
        batch.insert('food_items', FoodItemModel.fromEntity(item).toMap());
        count++;
      }

      await batch.commit(noResult: true);
    });
    return Success(count);
  } catch (e, stackTrace) {
    return Failure(DatabaseError.insertFailed('food_items', e, stackTrace));
  }
}

// Pattern 3: Read-modify-write with optimistic locking
Future<Result<Supplement, AppError>> incrementIntakeCount(String id) async {
  final db = await databaseHelper.database;

  try {
    late Supplement updated;
    await db.transaction((txn) async {
      // 1. Read current state
      final rows = await txn.query(
        'supplements',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (rows.isEmpty) throw Exception('Supplement not found');

      final current = SupplementModel.fromMap(rows.first).toEntity();

      // 2. Modify
      updated = current.copyWith(
        intakeCount: current.intakeCount + 1,
        syncMetadata: current.syncMetadata.markModified(deviceId),
      );

      // 3. Write with version check (optimistic lock)
      final rowsAffected = await txn.update(
        'supplements',
        SupplementModel.fromEntity(updated).toMap(),
        where: 'id = ? AND sync_version = ?',
        whereArgs: [id, current.syncMetadata.syncVersion],
      );

      if (rowsAffected == 0) {
        throw Exception('Concurrent modification detected');
      }
    });
    return Success(updated);
  } catch (e, stackTrace) {
    return Failure(DatabaseError.updateFailed('supplements', id, e, stackTrace));
  }
}
```

**Transaction rules:**
1. Keep transactions short - don't hold locks during network calls
2. Always handle transaction failures by returning `Result.failure`
3. Order deletes from child → parent to respect foreign keys
4. Order inserts from parent → child to respect foreign keys
5. Use batches for 10+ inserts in a single transaction
6. SQLite transactions are SERIALIZABLE by default - no isolation level configuration needed

**Nested transactions:**
SQLite does not support true nested transactions. Use savepoints for partial rollback:

```dart
await db.transaction((txn) async {
  await txn.execute('SAVEPOINT sp1');
  try {
    // Risky operation
    await txn.insert('table', data);
  } catch (e) {
    await txn.execute('ROLLBACK TO SAVEPOINT sp1');
    // Continue with alternative
  }
  await txn.execute('RELEASE SAVEPOINT sp1');
});
```

---

## 9. Sync System Standards

### 9.1 Sync Status Values

> **CANONICAL:** See `22_API_CONTRACTS.md` Section 3.1 for authoritative SyncMetadata definition.

```dart
/// Sync status values - MUST match database INTEGER values exactly
enum SyncStatus {
  pending(0),    // Never synced or awaiting sync
  synced(1),     // Successfully synced with cloud
  modified(2),   // Modified locally since last sync
  conflict(3),   // Conflict detected, needs resolution
  deleted(4);    // Marked for deletion (soft delete)

  final int value;
  const SyncStatus(this.value);

  static SyncStatus fromValue(int value) =>
    SyncStatus.values.firstWhere((e) => e.value == value, orElse: () => pending);
}
```

**State Transitions:**
```
CREATE (local) → pending
MODIFY (local) → modified (if was synced) or pending (if never synced)
SYNC SUCCESS → synced
SYNC FAIL → stays current status (retry with backoff)
CONFLICT DETECTED → conflict (user resolves)
CONFLICT RESOLVED → pending (re-sync)
RECEIVE REMOTE → synced
SOFT DELETE → deleted
```

### 9.2 Dirty Flag State Machine

```
┌─────────────────────────────────────────────────────────────┐
│  CREATE (local)                                              │
│    └─→ sync_is_dirty = 1, sync_status = pending             │
│                                                              │
│  MODIFY (local)                                              │
│    └─→ sync_is_dirty = 1, sync_status = pending             │
│                                                              │
│  SYNC UPLOAD SUCCESS                                         │
│    └─→ sync_is_dirty = 0, sync_status = synced,             │
│        sync_last_synced_at = NOW                             │
│                                                              │
│  SYNC UPLOAD FAIL                                            │
│    └─→ sync_is_dirty = 1, sync_status = error               │
│        (retry with exponential backoff)                      │
│                                                              │
│  RECEIVE REMOTE UPDATE                                       │
│    └─→ sync_is_dirty = 0, sync_status = synced,             │
│        sync_last_synced_at = NOW                             │
│                                                              │
│  CONFLICT DETECTED                                           │
│    └─→ sync_is_dirty = 1, sync_status = conflict            │
│        (store remote in conflict_data)                       │
│                                                              │
│  CONFLICT RESOLVED                                           │
│    └─→ sync_is_dirty = 1, sync_status = pending,            │
│        sync_version++, conflict_data = NULL                  │
└─────────────────────────────────────────────────────────────┘
```

**Rules:**
- `markDirty: true` - Only for LOCAL user actions
- `markDirty: false` - Only for REMOTE sync applies
- Never set `sync_is_dirty = 0` until server confirms receipt

```dart
// Local change: mark dirty
await repository.update(supplement, markDirty: true);

// Remote sync apply: don't mark dirty
await repository.update(remoteVersion, markDirty: false);
```

### 9.3 Soft Delete with Cascade

**Never physically delete synced records.**

```dart
// CORRECT: Soft delete via repository
Future<Result<void, AppError>> delete(String id) async {
  try {
    final entity = await localDataSource.getById(id);
    if (entity == null) {
      return Result.failure(NotFoundError(entityType: 'Supplement', entityId: id));
    }

    final deleted = entity.copyWith(
      syncMetadata: entity.syncMetadata.markDeleted(deviceId: _deviceId),
    );
    await localDataSource.update(SupplementModel.fromEntity(deleted));
    return const Result.success(null);
  } catch (e, st) {
    return Result.failure(DatabaseError.fromException(e, st));
  }
}
```

**Cascade soft deletes to children:**

| Parent | Children to Cascade |
|--------|---------------------|
| Profile | All health data for that profile |
| Supplement | All intake_logs for that supplement |
| Condition | All condition_logs for that condition |
| Diet | All diet_violations for that diet |
| Activity | All activity_logs for that activity |

```dart
Future<Result<void, AppError>> deleteSupplementWithCascade(String id) async {
  // 1. Soft delete parent
  final result = await delete(id);
  if (result.isFailure) return result;

  // 2. Cascade to children
  await intakeLogLocalDataSource.softDeleteForSupplement(id);

  return const Result.success(null);
}
```

**Query filtering:** All queries MUST include `WHERE sync_deleted_at IS NULL`

### 9.4 Conflict Resolution

**Detection:** Conflict occurs when:
- Local has `sync_is_dirty = 1`
- Remote has different `sync_version`
- Both modified since last sync

**Resolution Strategies:**

| Data Type | Strategy | Rationale |
|-----------|----------|-----------|
| Settings, preferences | Last-write-wins | Low risk |
| Timestamps | Last-write-wins | Simple, deterministic |
| Health entries | User chooses | Medical data too important |
| Supplements, conditions | User chooses | User intent matters |
| Complex data (ingredients) | Attempt merge | Combine non-conflicting changes |

**Conflict data storage:**
```sql
UPDATE supplements SET
  sync_status = 2,  -- conflict
  conflict_data = '{
    "remote": { ...entity data... },
    "local": { ...entity data... },
    "detected_at": "2026-01-31T12:00:00Z",
    "conflict_fields": ["name", "dosage"]
  }'
WHERE id = ?;
```

**User resolution flow:**
1. Show conflict notification badge
2. Present side-by-side comparison (local vs remote)
3. User selects: Keep Local | Accept Remote | Merge
4. After resolution: `sync_version++`, `sync_status = pending`, `conflict_data = NULL`

### 9.5 Archive vs Delete

| Operation | Column Set | User Action | Sync Behavior |
|-----------|------------|-------------|---------------|
| Archive | `is_archived = 1` | "Pause" item | Synced, excluded from active lists |
| Delete | `sync_deleted_at = NOW` | "Delete" item | Synced as tombstone |

**Entity Archive Support:**

| Entity | Supports Archive | Rationale |
|--------|-----------------|-----------|
| Profile | No | Delete only - archive would confuse multi-profile UX |
| Supplement | **Yes** | User may pause, then resume supplements |
| Condition | **Yes** | Conditions can go into remission |
| Activity | **Yes** | User may pause activities seasonally |
| Diet | **Yes** | User may pause diets (vacations, holidays) |
| FoodItem | No | Delete unused foods, no pause concept |
| PhotoArea | No | Delete unused areas |
| NotificationSchedule | No | Disable via isEnabled flag instead |
| JournalEntry | No | Historical record, delete if unwanted |
| SleepEntry | No | Historical record |
| FluidsEntry | No | Historical record |
| ConditionLog | No | Historical record |
| IntakeLog | No | Historical record |
| FoodLog | No | Historical record |
| ActivityLog | No | Historical record |
| PhotoEntry | No | Historical record |
| FlareUp | No | Historical record |
| DietViolation | No | Historical record |

**Archive vs isEnabled vs isActive:**
- **Archive** (`is_archived`): User-initiated pause, entity excluded from normal lists
- **isEnabled** (notifications only): Toggle on/off without deleting schedule
- **isActive** (computed): Entity is not archived AND not soft-deleted

```dart
// Archive: Temporarily hide from active lists
Future<Result<Supplement, AppError>> archive(String id) async {
  final entity = await getById(id);
  return entity.when(
    success: (supp) => update(supp.copyWith(isArchived: true)),
    failure: (error) => Result.failure(error),
  );
}

// Unarchive: Restore to active lists
Future<Result<Supplement, AppError>> unarchive(String id) async {
  final entity = await getById(id);
  return entity.when(
    success: (supp) => update(supp.copyWith(isArchived: false)),
    failure: (error) => Result.failure(error),
  );
}

// Delete: Soft delete (permanent intent)
Future<Result<void, AppError>> delete(String id) async {
  // Sets sync_deleted_at, syncs as tombstone
}
```

### 9.6 Hard Delete Policy

**Hard delete ONLY allowed for:**
1. User account deletion (GDPR right-to-be-forgotten)
2. Sync cleanup after server confirms tombstone received
3. Local cache purge (non-synced temp data only)

```dart
Future<Result<void, AppError>> hardDelete(String id) async {
  // Only call after server confirms deletion
  await localDataSource.permanentlyDelete(id);
  return const Result.success(null);
}
```

### 9.7 Sync Retry Strategy

**Exponential backoff:**
```dart
const retryDelays = [
  Duration(seconds: 1),
  Duration(seconds: 2),
  Duration(seconds: 4),
  Duration(seconds: 8),
  Duration(seconds: 16),
  Duration(minutes: 1),
  Duration(minutes: 5),  // Max delay
];
```

**Rules:**
- Max 5 retries per record before marking as `error`
- Reset retry count after successful sync
- Pause sync when offline (resume on connectivity)
- Show "Sync failed" indicator after 3 consecutive failures
- User can manually trigger "Retry Sync" from settings

### 9.8 Sync Order Dependencies

Entities MUST be synced in dependency order to satisfy foreign key constraints.

**Sync Order (Push to Cloud):**

| Tier | Entities | Dependencies |
|------|----------|--------------|
| 1 | `user_accounts` | None |
| 2 | `profiles` | user_accounts |
| 3 | `hipaa_authorizations`, `device_registrations` | profiles |
| 4 | `supplements`, `conditions`, `activities`, `diets`, `photo_areas` | profiles |
| 5 | `food_items` | profiles |
| 6 | `intake_logs`, `condition_logs`, `activity_logs`, `diet_rules`, `diet_violations`, `flare_ups`, `photo_entries` | Parent entities (tier 4/5) |
| 7 | `food_logs` | food_items |
| 8 | `sleep_entries`, `fluids_entries`, `journal_entries`, `notification_schedules` | profiles |
| 9 | `patterns`, `trigger_correlations`, `health_insights`, `predictive_alerts` | profiles (intelligence) |

**Sync Order (Pull from Cloud):**
Same tier order - process parent entities before children.

**Implementation:**

```dart
class SyncService {
  /// Sync tiers in order, each tier completes before next begins
  Future<Result<SyncReport, AppError>> syncAll() async {
    final tiers = [
      [userAccountRepository],
      [profileRepository],
      [hipaaAuthRepository, deviceRepository],
      [supplementRepository, conditionRepository, activityRepository, dietRepository, photoAreaRepository],
      [foodItemRepository],
      [intakeLogRepository, conditionLogRepository, activityLogRepository, dietRuleRepository, dietViolationRepository, flareUpRepository, photoEntryRepository],
      [foodLogRepository],
      [sleepRepository, fluidsRepository, journalRepository, notificationScheduleRepository],
      [patternRepository, correlationRepository, insightRepository, alertRepository],
    ];

    for (final tier in tiers) {
      // Sync all repositories in tier in parallel
      final results = await Future.wait(
        tier.map((repo) => repo.syncPendingRecords()),
      );

      // If any failed, stop and return first error
      for (final result in results) {
        if (result.isFailure) return result;
      }
    }

    return Success(SyncReport(success: true));
  }
}
```

**Handling Missing Parent During Sync:**
If a child record references a parent that hasn't synced yet:
1. Skip the child record for this sync cycle
2. It will be picked up on the next sync after parent completes
3. Never create orphan records in cloud storage

### 9.9 Offline Queue Management

**Queue State:**
The sync queue is implicitly defined by records with `sync_is_dirty = 1`.

**Queue Query:**
```sql
SELECT * FROM {table}
WHERE sync_is_dirty = 1
  AND sync_deleted_at IS NULL
ORDER BY sync_updated_at ASC  -- Oldest changes first
LIMIT 100;  -- Process in batches
```

**Queue Ordering:**
- Process oldest changes first (`sync_updated_at ASC`)
- Respect tier dependencies (Section 9.8)
- Within a tier, order doesn't matter

**Queue Size Limits:**

| Threshold | Action |
|-----------|--------|
| 100 dirty records | Normal operation |
| 500 dirty records | Show "Sync recommended" badge |
| 1000 dirty records | Show "Sync required" notification |
| 5000 dirty records | Block new data entry until sync completes |

```dart
Future<int> getDirtyRecordCount() async {
  final db = await databaseHelper.database;
  final tables = ['supplements', 'intake_logs', 'conditions', ...];

  int total = 0;
  for (final table in tables) {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $table WHERE sync_is_dirty = 1 AND sync_deleted_at IS NULL'
    );
    total += result.first['count'] as int;
  }
  return total;
}
```

**Crash Recovery:**
- Queue state is persisted in database (dirty flag on each record)
- On app restart, query dirty records to rebuild queue
- No separate queue persistence needed - database IS the queue

**Network Interruption:**
- Partial sync: Already-synced records are marked clean
- Remaining dirty records stay in queue
- Resume from where sync left off on reconnection

**Conflict During Queue Processing:**
- Mark record as `sync_status = conflict`
- Remove from dirty queue (`sync_is_dirty` stays 1 but status prevents re-sync)
- Present to user for resolution
- After resolution, record re-enters queue

---

## 10. Testing Standards

### 10.1 Test File Organization

```
test/
├── core/
│   ├── services/
│   └── utils/
├── domain/
│   └── entities/
├── data/
│   ├── repositories/
│   ├── datasources/
│   └── models/
├── presentation/
│   ├── providers/
│   └── widgets/
├── integration/
└── performance/
```

### 10.2 Test Naming Convention

```dart
// Pattern: methodName_condition_expectedResult
void main() {
  group('SupplementRepository', () {
    test('getAllSupplements_withProfileId_returnsFilteredList', () async {
      // Test implementation
    });

    test('getSupplement_nonExistentId_throwsEntityNotFoundException', () async {
      // Test implementation
    });
  });
}
```

### 10.3 Test Coverage Requirements

| Layer | Minimum Coverage |
|-------|------------------|
| Domain Entities | 100% |
| Data Models | 100% |
| Data Sources | 100% |
| Repositories | 100% |
| Services | 100% |
| Providers | 100% |
| Widgets | 100% |
| Screens | 100% |
| **Overall** | **100%** |

### 10.4 Test-As-You-Go Rule

**MANDATORY**: Tests must be written alongside implementation:

1. Write test for new functionality
2. Implement functionality
3. Verify test passes
4. Refactor if needed
5. Commit with passing tests

---

## 11. Security Standards

### 11.1 PII Masking (MANDATORY)

**NEVER log these data types without masking:**

| Data Type | Masking Pattern | Example |
|-----------|-----------------|---------|
| Email | first2***@domain | `jo***@gmail.com` |
| Phone | ***-***-last4 | `***-***-1234` |
| Token/API Key | first3***last3 | `abc***xyz` |
| Health values | [REDACTED] | Never log BBT, severity, etc. |
| User ID | SHA-256 hash prefix | `a3f2c8...` (first 16 chars) |

```dart
/// Email masking - first 2 chars visible
String maskEmail(String email) {
  final parts = email.split('@');
  if (parts.length != 2) return '***@***';
  final local = parts[0];
  final masked = local.length > 2 ? '${local.substring(0, 2)}***' : '***';
  return '$masked@${parts[1]}';
}

/// Phone masking - last 4 digits visible
String maskPhone(String phone) {
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  if (digits.length < 4) return '***';
  return '***-***-${digits.substring(digits.length - 4)}';
}

/// Token masking - first 3 and last 3 chars visible
String maskToken(String token) {
  if (token.length < 8) return '[REDACTED]';
  return '${token.substring(0, 3)}***${token.substring(token.length - 3)}';
}

/// User ID - hash for correlation without exposing ID (with 4-char suffix)
String maskUserId(String userId) {
  final bytes = utf8.encode(userId);
  final digest = sha256.convert(bytes);
  final suffix = userId.length >= 4 ? userId.substring(userId.length - 4) : userId;
  return '${digest.toString().substring(0, 16)}...$suffix';
}

/// Profile ID - same pattern as User ID
String maskProfileId(String profileId) => maskUserId(profileId);

/// Device ID - hash only, no suffix (devices don't have human-readable IDs)
String maskDeviceId(String deviceId) {
  final bytes = utf8.encode(deviceId);
  final digest = sha256.convert(bytes);
  return digest.toString().substring(0, 16);
}

/// IP address - partial masking
String maskIpAddress(String ip) {
  final parts = ip.split('.');
  if (parts.length == 4) {
    return '${parts[0]}.${parts[1]}.xxx.xxx';
  }
  return 'xxx.xxx.xxx.xxx';
}
```

**Health data logging rules:**
```dart
// CORRECT: Log action, not value
_log.info('BBT recorded for profile ${maskUserId(profileId)}');
_log.info('Condition severity updated');

// INCORRECT: Never log health values
_log.info('BBT: 98.6°F');  // NEVER
_log.info('Severity: 8');   // NEVER
_log.info('Menstruation flow: heavy');  // NEVER
```

### 11.2 HTTP Security

**Timeout defaults:**

| Operation Type | Timeout | Use Case |
|----------------|---------|----------|
| User-facing API | 15 seconds | Profile load, list fetch |
| Standard API | 30 seconds | OAuth, sync operations |
| Heavy operations | 60 seconds | File upload, bulk sync |
| Background sync | 120 seconds | Full sync with retry |

```dart
// Define constants
const userFacingTimeout = Duration(seconds: 15);
const standardTimeout = Duration(seconds: 30);
const heavyOperationTimeout = Duration(seconds: 60);

// CORRECT: Always specify timeout
final response = await http.get(uri).timeout(standardTimeout);

// INCORRECT: No timeout
final response = await http.get(uri);  // NEVER
```

**Certificate pinning (required for ALL external APIs):**

| Host Category | Domains |
|---------------|---------|
| Google OAuth/Drive | `accounts.google.com`, `oauth2.googleapis.com`, `www.googleapis.com`, `drive.googleapis.com` |
| Apple Sign-in/iCloud | `appleid.apple.com`, `api.apple-cloudkit.com` |
| Wearable APIs | `api.fitbit.com`, `connect.garmin.com`, `cloud.ouraring.com`, `api.prod.whoop.com` |
| Shadow API | `api.shadow.app` |

```dart
// ALL pinned hosts (11 total)
final pinnedHosts = {
  // Google services
  'accounts.google.com',
  'oauth2.googleapis.com',
  'www.googleapis.com',
  'drive.googleapis.com',
  // Apple services
  'appleid.apple.com',
  'api.apple-cloudkit.com',
  // Wearable APIs
  'api.fitbit.com',
  'connect.garmin.com',
  'cloud.ouraring.com',
  'api.prod.whoop.com',
  // Shadow API
  'api.shadow.app',
};

// Validation on connection
void validateCertificate(X509Certificate cert, String host) {
  if (pinnedHosts.contains(host)) {
    final expectedHash = getPinnedHash(host);
    final actualHash = sha256(cert.der);
    if (actualHash != expectedHash) {
      throw CertificatePinningException('Pin mismatch for $host');
    }
  }
}
```

> **Real Certificate Pins:** See `11_SECURITY_GUIDELINES.md` Section 5.4 for actual SHA256 SPKI hashes. Each domain requires 2 backup pins for redundancy.

### 11.3 OAuth Token Storage

**Storage requirements:**
- Store tokens in platform secure storage only (iOS Keychain, Android Keystore)
- Use separate keys for each token type
- Clear ALL tokens atomically on sign-out

```dart
// Separate keys for each token
const _accessTokenKey = 'access_token';
const _refreshTokenKey = 'refresh_token';
const _tokenExpiryKey = 'token_expiry';
const _userEmailKey = 'user_email';

// Store tokens separately
Future<void> saveTokens(OAuthTokens tokens) async {
  await Future.wait([
    _secureStorage.write(key: _accessTokenKey, value: tokens.accessToken),
    _secureStorage.write(key: _refreshTokenKey, value: tokens.refreshToken),
    _secureStorage.write(key: _tokenExpiryKey, value: tokens.expiresAt.toIso8601String()),
  ]);
}

// Clear ALL tokens atomically on sign-out
Future<void> clearTokens() async {
  await Future.wait([
    _secureStorage.delete(key: _accessTokenKey),
    _secureStorage.delete(key: _refreshTokenKey),
    _secureStorage.delete(key: _tokenExpiryKey),
    _secureStorage.delete(key: _userEmailKey),
  ]);

  // VERIFY clearance
  final accessToken = await _secureStorage.read(key: _accessTokenKey);
  assert(accessToken == null, 'Token clearance failed');
}
```

### 11.4 Encryption Standards

> **Complete Implementation:** See `11_SECURITY_GUIDELINES.md` Sections 2.1-2.3 for full encryption procedures including key rotation.

**Required encryption:**

| Data | Encryption | Key Storage |
|------|------------|-------------|
| Database | AES-256-GCM via SQLCipher | Platform secure storage |
| Sensitive fields | AES-256-GCM field-level | Platform secure storage |
| Photos | AES-256-GCM before storage | Platform secure storage |
| Cloud backup | AES-256-GCM envelope | Derived from user key |

**CRITICAL: Use GCM mode, NOT CBC.**

```dart
// lib/core/services/encryption_service.dart

/// AES-256-GCM encryption service
class EncryptionService {
  static const int keyLengthBytes = 32;  // 256 bits
  static const int nonceLengthBytes = 12; // 96 bits for GCM

  /// Encrypt data with AES-256-GCM
  Future<EncryptedData> encrypt(Uint8List plaintext, SecretKey key) async {
    final algorithm = AesGcm.with256bits();
    final nonce = algorithm.newNonce(); // 96-bit random nonce

    final secretBox = await algorithm.encrypt(
      plaintext,
      secretKey: key,
      nonce: nonce,
    );

    return EncryptedData(
      ciphertext: secretBox.cipherText,
      nonce: nonce,
      mac: secretBox.mac.bytes,
    );
  }

  /// Decrypt data with AES-256-GCM
  Future<Uint8List> decrypt(EncryptedData data, SecretKey key) async {
    final algorithm = AesGcm.with256bits();

    final secretBox = SecretBox(
      data.ciphertext,
      nonce: data.nonce,
      mac: Mac(data.mac),
    );

    return await algorithm.decrypt(secretBox, secretKey: key);
  }
}
```

**Key rotation:**
- Keys must be rotated annually or on security incident
- Old key retained for decryption during transition
- Re-encrypt all data with new key on next app open
- See `11_SECURITY_GUIDELINES.md` Section 2.3 for full procedure

### 11.5 SQL-Level Authorization (MANDATORY)

**All data source queries MUST validate profile ownership:**

```sql
-- CORRECT: Validate user owns the profile
SELECT s.* FROM supplements s
INNER JOIN profiles p ON s.profile_id = p.id
WHERE s.profile_id = ?
  AND p.owner_id = ?           -- Current user's ID
  AND s.sync_deleted_at IS NULL;

-- INCORRECT: No ownership check (security vulnerability)
SELECT * FROM supplements WHERE profile_id = ?;
```

**For shared profiles (via HIPAA authorization):**

```sql
SELECT s.* FROM supplements s
INNER JOIN profiles p ON s.profile_id = p.id
LEFT JOIN hipaa_authorizations h ON h.profile_id = p.id
WHERE s.profile_id = ?
  AND s.sync_deleted_at IS NULL
  AND (
    p.owner_id = ?                    -- User owns profile
    OR (
      h.granted_to_user_id = ?        -- User has authorization
      AND h.revoked_at IS NULL
      AND (h.expires_at IS NULL OR h.expires_at > ?)
    )
  );
```

**Implementation in DataSource:**

```dart
Future<List<Supplement>> getAllSupplements({
  required String profileId,
  required String userId,  // Current authenticated user
}) async {
  final db = await databaseHelper.database;

  final result = await db.rawQuery('''
    SELECT s.* FROM supplements s
    INNER JOIN profiles p ON s.profile_id = p.id
    LEFT JOIN hipaa_authorizations h ON h.profile_id = p.id
    WHERE s.profile_id = ?
      AND s.sync_deleted_at IS NULL
      AND (
        p.owner_id = ?
        OR (h.granted_to_user_id = ? AND h.revoked_at IS NULL)
      )
    ORDER BY s.sync_created_at DESC
  ''', [profileId, userId, userId]);

  return result.map((map) => SupplementModel.fromMap(map).toEntity()).toList();
}
```

---

## 12. Performance Standards

### 12.0 Frame Rate Requirements

**Target:** 60 frames per second (fps) minimum for all animations and scrolling.

**Performance Targets:**

| Metric | Target | Acceptable | Alert Threshold |
|--------|--------|------------|-----------------|
| Frame rate | 60 fps | 55 fps | < 50 fps |
| Frame render time | < 16ms | < 18ms | > 20ms |
| Jank frames | 0% | < 1% | > 3% |
| App launch (cold) | < 2s | < 3s | > 4s |
| Tab switch | < 100ms | < 200ms | > 500ms |

**Monitoring implementation:**

```dart
// Enable frame timing callbacks in debug/profile mode
void enableFrameMonitoring() {
  WidgetsBinding.instance.addTimingsCallback((List<FrameTiming> timings) {
    for (final timing in timings) {
      final buildDuration = timing.buildDuration.inMilliseconds;
      final rasterDuration = timing.rasterDuration.inMilliseconds;
      final totalDuration = timing.totalSpan.inMilliseconds;

      // Log jank frames (> 16ms total)
      if (totalDuration > 16) {
        analytics.logEvent('frame_drop', {
          'build_ms': buildDuration,
          'raster_ms': rasterDuration,
          'total_ms': totalDuration,
          'screen': currentRouteName,
        });
      }
    }
  });
}
```

**Common jank causes and fixes:**

| Cause | Fix |
|-------|-----|
| Heavy build() method | Move computation to initState or provider |
| Large images | Use cacheWidth/cacheHeight, lazy load |
| Complex list items | Use ListView.builder with const widgets |
| Unnecessary rebuilds | Use const constructors, select() in Riverpod |
| Sync operations on main thread | Move to isolate or compute() |

### 12.1 ListView Best Practices

**MANDATORY**: Use `ListView.builder` for dynamic lists:

```dart
// CORRECT: ListView.builder for efficiency
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemCard(item: items[index]),
)

// INCORRECT: ListView with children
ListView(
  children: items.map((item) => ItemCard(item: item)).toList(),
)
```

### 12.2 Image Caching

Always specify cache dimensions:

```dart
// CORRECT: With cache dimensions
Image.file(
  file,
  cacheWidth: 200,
  cacheHeight: 200,
)

// INCORRECT: No cache dimensions
Image.file(file)
```

### 12.3 Database Query Optimization

- Use pagination for large result sets
- Create indexes for frequently filtered columns
- Batch operations when possible

---

## 13. Accessibility Standards

### 13.1 Semantic Labels

All interactive elements MUST have semantic labels:

```dart
// CORRECT: Localized semantic label
Semantics(
  label: l10n.addSupplementButton,
  button: true,
  child: IconButton(
    onPressed: _addSupplement,
    icon: Icon(Icons.add),
  ),
)

// INCORRECT: Missing semantics
IconButton(
  onPressed: _addSupplement,
  icon: Icon(Icons.add),
)
```

### 13.2 Touch Targets

Minimum touch target size: 48x48 dp

```dart
// CORRECT: Adequate touch target
SizedBox(
  width: 48,
  height: 48,
  child: IconButton(...),
)
```

### 13.3 Focus Management

Logical focus order for keyboard navigation:

```dart
FocusTraversalGroup(
  policy: OrderedTraversalPolicy(),
  child: Column(
    children: [
      FocusTraversalOrder(order: NumericFocusOrder(1), child: nameField),
      FocusTraversalOrder(order: NumericFocusOrder(2), child: dosageField),
      FocusTraversalOrder(order: NumericFocusOrder(3), child: saveButton),
    ],
  ),
)
```

---

## 14. Documentation Standards

### 14.1 Dartdoc Requirements

All public APIs MUST have dartdoc comments:

```dart
/// Repository for managing [Supplement] entities.
///
/// This repository handles CRUD operations for supplements,
/// including sync metadata management for cloud synchronization.
class SupplementRepositoryImpl implements SupplementRepository {

  /// Retrieves all supplements for the specified profile.
  ///
  /// * [profileId] - Optional filter for specific profile
  /// * [limit] - Maximum results to return
  /// * [offset] - Number of results to skip
  ///
  /// Returns a list of [Supplement] objects, ordered by creation date.
  @override
  Future<List<Supplement>> getAllSupplements({
    String? profileId,
    int? limit,
    int? offset,
  }) async {
    // Implementation
  }
}
```

### 14.2 File Headers

Every file MUST have a header comment:

```dart
/// Supplement repository implementation.
///
/// Handles CRUD operations for supplement entities with
/// sync metadata management for cloud synchronization.
library;

import 'package:uuid/uuid.dart';
// ...
```

---

## 15. Code Review Standards

### 15.1 Review Checklist

Before approving any PR, verify these essential items (see `24_CODE_REVIEW_CHECKLIST.md` for complete 58-item detailed checklist):

- [ ] All tests pass
- [ ] New tests added for new functionality
- [ ] File header comment present
- [ ] Dartdoc comments on public APIs
- [ ] No sensitive data in logs
- [ ] Error handling uses Result pattern
- [ ] Accessibility requirements met (semantic labels, 48x48dp touch targets)
- [ ] Performance considerations addressed (ListView.builder, image caching)
- [ ] Naming conventions followed
- [ ] ProfileId filtering supported where needed

### 15.2 PR Requirements

- Descriptive title and description
- Link to issue/ticket
- Screenshots for UI changes
- Test coverage report
- No unresolved comments

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
