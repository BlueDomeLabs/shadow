# Shadow Specification Fixes

**Version:** 1.1
**Created:** January 31, 2026
**Last Updated:** January 31, 2026
**Purpose:** Remediation plan for specification gaps identified during Coding Standards audit
**Status:** ALL PHASES COMPLETE ✅

---

## Overview

This document tracks all specification gaps and inconsistencies identified when auditing the 43 Shadow specification documents against `02_CODING_STANDARDS.md`. Each fix includes the exact changes needed, affected documents, and verification criteria.

**Total Issues:** 57
**Critical:** 14 | **High:** 25 | **Medium:** 14 | **Low:** 4

---

## Fix Categories

| Category | Issues | Priority |
|----------|--------|----------|
| [A. Error Handling Reconciliation](#a-error-handling-reconciliation) | 4 | Critical |
| [B. Entity Standards Updates](#b-entity-standards-updates) | 6 | Critical/High |
| [C. Provider Standards Updates](#c-provider-standards-updates) | 5 | Critical/High |
| [D. Database Standards Alignment](#d-database-standards-alignment) | 5 | Critical/High |
| [E. Sync System Specification](#e-sync-system-specification) | 5 | Critical/High |
| [F. Security Standards Completion](#f-security-standards-completion) | 5 | Critical/High |
| [G. Testing Standards Expansion](#g-testing-standards-expansion) | 5 | High |
| [H. Accessibility Specification](#h-accessibility-specification) | 5 | Critical/High |
| [I. Documentation Standards](#i-documentation-standards) | 4 | Medium |
| [J. Code Review Checklist Updates](#j-code-review-checklist-updates) | 4 | High |
| [K. Cross-Document Alignment](#k-cross-document-alignment) | 9 | Medium |

---

## A. Error Handling Reconciliation

### A1. Choose Single Error Pattern [CRITICAL]

**Problem:** Three conflicting approaches exist:
- `02_CODING_STANDARDS.md` Section 7: Traditional exceptions (`EntityNotFoundException`, `DatabaseException`)
- `16_ERROR_HANDLING.md`: Result type with `AppError` sealed class
- `22_API_CONTRACTS.md`: Result type with error codes

**Decision:** Use `Result<T, AppError>` pattern exclusively

**Files to Update:**

1. **02_CODING_STANDARDS.md** Section 7:
```dart
// REPLACE exception-based examples with Result pattern
// OLD:
try {
  await repository.getSupplement(id);
} catch (e) { ... }

// NEW:
final result = await repository.getSupplement(id);
result.when(
  success: (supplement) => /* handle success */,
  failure: (error) => _log.error('Failed: ${error.message}'),
);
```

2. **02_CODING_STANDARDS.md** Section 3.3 - Update method naming table:
```
| Operation | Method Name | Returns |
|-----------|-------------|---------|
| Get all | `getAll{Entity}s` | `Result<List<Entity>, AppError>` |
| Get one | `getById` | `Result<Entity, AppError>` |
| Create | `create` | `Result<Entity, AppError>` |
| Update | `update` | `Result<Entity, AppError>` |
| Delete | `delete` | `Result<void, AppError>` |
```

3. Remove `find{Entity}` pattern - use `getById` returning `Result<Entity?, AppError>` for nullable lookups

**Verification:**
- [ ] All repository method signatures use Result type
- [ ] No try-catch blocks for repository calls in examples
- [ ] 16_ERROR_HANDLING.md and 22_API_CONTRACTS.md align with updated 02

---

### A2. Document AppError Hierarchy [HIGH]

**Problem:** No central definition of all error types

**File to Update:** `02_CODING_STANDARDS.md` Section 7.1

**Add:**
```dart
/// Base error class for all application errors
sealed class AppError {
  String get code;
  String get message;
  String get userMessage;
  StackTrace? get stackTrace;
}

// Subclasses:
class DatabaseError extends AppError { ... }
class NetworkError extends AppError { ... }
class AuthError extends AppError { ... }
class ValidationError extends AppError { ... }
class SyncError extends AppError { ... }
class DietError extends AppError { ... }      // NEW for diet features
class NotificationError extends AppError { ... } // NEW for notifications
class IntelligenceError extends AppError { ... } // NEW for Phase 3
```

**Verification:**
- [ ] All error subclasses documented with error codes
- [ ] Each feature has corresponding error type

---

### A3. Define Error Code Registry [MEDIUM]

**Problem:** No centralized error code list

**File to Create:** Add section to `22_API_CONTRACTS.md`

**Add Error Code Table:**
```
| Code | Type | Description |
|------|------|-------------|
| DB_001 | DatabaseError | Query execution failed |
| DB_002 | DatabaseError | Entity not found |
| DB_003 | DatabaseError | Constraint violation |
| NET_001 | NetworkError | Connection timeout |
| NET_002 | NetworkError | No internet connection |
| AUTH_001 | AuthError | Token expired |
| AUTH_002 | AuthError | Unauthorized profile access |
| VAL_001 | ValidationError | Required field missing |
| VAL_002 | ValidationError | Value out of range |
| SYNC_001 | SyncError | Conflict detected |
| SYNC_002 | SyncError | Merge failed |
| DIET_001 | DietError | Compliance violation |
| DIET_002 | DietError | Fasting window violation |
```

---

### A4. Structured Logging Format [MEDIUM]

**Problem:** No standard log format defined

**File to Update:** `02_CODING_STANDARDS.md` Section 7.2

**Add:**
```dart
// Structured logging format
_log.error(
  'Operation failed',
  {
    'error_code': error.code,
    'entity_type': 'Supplement',
    'entity_id': id,
    'operation': 'update',
    'user_id': _maskUserId(userId),  // Always masked
    'request_id': requestId,
  },
  error,
  stackTrace,
);

// NEVER log:
// - Passwords, tokens, API keys
// - Health data values (BBT, menstruation, conditions)
// - Full email addresses (mask to first2***@domain)
// - Full phone numbers (mask to ***-***-1234)
```

---

## B. Entity Standards Updates

### B1. Add clientId Requirement [CRITICAL]

**Problem:** clientId not in entity standard but required for database merging

**File to Update:** `02_CODING_STANDARDS.md` Section 5.1

**Change:**
```dart
// CURRENT:
class Supplement {
  final String id;
  final String profileId;
  // ...
}

// UPDATED:
class Supplement {
  final String id;
  final String clientId;     // NEW: Required for database merging
  final String profileId;
  // ...
}
```

**Add to Section 5.1:**
```
All entities in `lib/domain/entities/` MUST include:
- `id` (String) - Unique identifier
- `clientId` (String) - Client identifier for database merging
- `profileId` (String) - Profile scope identifier
- `syncMetadata` (SyncMetadata) - Sync tracking data
```

---

### B2. Enforce Freezed Code Generation [CRITICAL]

**Problem:** Freezed not mentioned in entity standards

**File to Update:** `02_CODING_STANDARDS.md` Section 5

**Add new subsection 5.0:**
```dart
## 5.0 Code Generation Requirement

All entities MUST use Freezed for code generation:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplement.freezed.dart';
part 'supplement.g.dart';

@freezed
class Supplement with _$Supplement {
  const Supplement._(); // Required for custom methods/getters

  const factory Supplement({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    @Default([]) List<SupplementIngredient> ingredients,
    required SyncMetadata syncMetadata,
  }) = _Supplement;

  factory Supplement.fromJson(Map<String, dynamic> json) =>
      _$SupplementFromJson(json);
}
```

Benefits:
- copyWith generated automatically
- Immutability enforced at compile time
- equals/hashCode generated correctly
- JSON serialization generated
- Pattern matching support
```

---

### B3. List Field Initialization Rules [HIGH]

**Problem:** Unclear when to use @Default([]) vs nullable

**File to Update:** `02_CODING_STANDARDS.md` Section 5.2

**Add:**
```
### List Field Defaults

| Scenario | Approach | Example |
|----------|----------|---------|
| Value objects (always loaded together) | `@Default([])` | `List<SupplementIngredient>` |
| FK references (loaded separately) | Nullable `List?` | `List<IntakeLog>?` |
| Required list (must have items) | Required, no default | Required validation in UI |

Example:
```dart
@freezed
class Diet with _$Diet {
  const factory Diet({
    required String id,
    @Default([]) List<DietRule> rules,  // Always loaded with Diet
    List<DietViolation>? violations,     // Loaded on demand
  }) = _Diet;
}
```
```

---

### B4. SyncMetadata Factory Method [HIGH]

**Problem:** No standard way to create empty SyncMetadata

**File to Update:** `02_CODING_STANDARDS.md` Section 5.3

**Add:**
```dart
class SyncMetadata {
  // ... existing fields ...

  /// Creates initial SyncMetadata for new entities
  factory SyncMetadata.initial({required String deviceId}) => SyncMetadata(
    createdAt: DateTime.now().toUtc(),
    updatedAt: DateTime.now().toUtc(),
    deletedAt: null,
    lastSyncedAt: null,
    syncStatus: SyncStatus.pending,
    version: 1,
    createdByDeviceId: deviceId,
    lastModifiedByDeviceId: deviceId,
  );

  /// Increments version for updates
  SyncMetadata incrementVersion({required String deviceId}) => copyWith(
    updatedAt: DateTime.now().toUtc(),
    version: version + 1,
    lastModifiedByDeviceId: deviceId,
    syncStatus: SyncStatus.pending,
  );
}
```

---

### B5. SyncMetadata Mutation Rules [HIGH]

**Problem:** Unclear which fields are mutable

**File to Update:** `02_CODING_STANDARDS.md` Section 5.3

**Add:**
```
### SyncMetadata Field Mutability

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
```

---

### B6. Computed Properties Pattern [MEDIUM]

**Problem:** No guidance on entity computed properties

**File to Update:** `02_CODING_STANDARDS.md` Section 5.1

**Add:**
```dart
### 5.1.2 Computed Properties

Entities MAY include read-only computed properties:

```dart
@freezed
class Diet with _$Diet {
  const Diet._();

  const factory Diet({
    required String id,
    required String clientId,
    required String profileId,
    String? presetId,
    // ... other fields
    required SyncMetadata syncMetadata,
  }) = _Diet;

  // Computed properties - O(1) only, no async, no repository access
  bool get isPreset => presetId != null;
  bool get isCustom => presetId == null;
}
```

Rules:
1. Use only for simple O(1) calculations
2. Never perform async operations
3. Never access repositories or services
4. Document what they compute
```

---

## C. Provider Standards Updates

### C1. Add UseCase Layer Requirement [CRITICAL]

**Problem:** Standards don't mention UseCases but Architecture requires them

**File to Update:** `02_CODING_STANDARDS.md` Section 6

**Add new rule:**
```
### 6.6 UseCase Delegation (MANDATORY)

Providers MUST delegate to UseCases, NOT repositories directly:

```dart
// CORRECT: Provider calls UseCase
class SupplementNotifier extends _$SupplementNotifier {
  @override
  Future<List<Supplement>> build(String profileId) async {
    final useCase = ref.read(getSupplementsUseCaseProvider);
    final result = await useCase(GetSupplementsInput(profileId: profileId));

    return result.when(
      success: (supplements) => supplements,
      failure: (error) => throw error,
    );
  }
}

// INCORRECT: Direct repository access (no authorization, no validation)
class SupplementNotifier extends _$SupplementNotifier {
  @override
  Future<List<Supplement>> build(String profileId) async {
    return await _repository.getAllSupplements(profileId: profileId);
  }
}
```

Benefits:
- UseCases handle authorization checks
- UseCases handle validation
- Single source of business logic
- Easier testing with UseCase mocks
```

---

### C2. Specify Riverpod Framework [CRITICAL]

**Problem:** Examples show ChangeNotifier but Roadmap specifies Riverpod

**File to Update:** `02_CODING_STANDARDS.md` Section 6

**Add preamble:**
```
## 6. Provider Standards

**STATE MANAGEMENT FRAMEWORK**: Riverpod (with code generation)

All providers MUST use Riverpod annotation syntax:

```dart
@riverpod
class SupplementList extends _$SupplementList {
  @override
  Future<List<Supplement>> build(String profileId) async {
    // Implementation
  }
}
```

Reference: See 05_IMPLEMENTATION_ROADMAP.md Section 0.2 for configuration.
```

---

### C3. Result Type in Providers [CRITICAL]

**Problem:** Provider examples use try-catch, not Result type

**File to Update:** `02_CODING_STANDARDS.md` Section 6.1

**Replace example with:**
```dart
@riverpod
class SupplementList extends _$SupplementList {
  static final _log = logger.scope('SupplementList');

  @override
  Future<SupplementListState> build(String profileId) async {
    final useCase = ref.read(getSupplementsUseCaseProvider);
    final result = await useCase(GetSupplementsInput(profileId: profileId));

    return result.when(
      success: (supplements) => SupplementListState(supplements: supplements),
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        return SupplementListState(error: error);
      },
    );
  }

  Future<void> addSupplement(Supplement supplement) async {
    // Check write access
    final authService = ref.read(profileAuthServiceProvider);
    if (!authService.canWrite) {
      throw UnauthorizedException('Write access required');
    }

    final useCase = ref.read(createSupplementUseCaseProvider);
    final result = await useCase(supplement);

    result.when(
      success: (_) => ref.invalidateSelf(),
      failure: (error) {
        _log.error('Add failed: ${error.message}');
        // Error shown via state
      },
    );
  }
}
```

---

### C4. Write Access Check Pattern [HIGH]

**Problem:** checkWriteAccess() mentioned but not specified

**File to Update:** `02_CODING_STANDARDS.md` Section 6.2 Rule 4

**Expand:**
```
### 6.2 Rule 4: Write Access Pattern

Every mutation method MUST check write access:

```dart
Future<void> addSupplement(Supplement supplement) async {
  // REQUIRED: Check before any mutation
  final authService = ref.read(profileAuthServiceProvider);
  if (!authService.canWrite(currentProfileId)) {
    throw UnauthorizedException(
      'Write access required for profile $currentProfileId'
    );
  }

  // Proceed with mutation
  final result = await useCase(supplement);
  // ...
}
```

Authorization is also checked in UseCase layer for defense-in-depth.
```

---

### C5. Profile Filtering Pattern [HIGH]

**Problem:** Rule says "filter by profile" but doesn't show how

**File to Update:** `02_CODING_STANDARDS.md` Section 6.2 Rule 5

**Expand:**
```
### 6.2 Rule 5: Profile Filtering

Every data load MUST include profileId:

```dart
@riverpod
class SupplementList extends _$SupplementList {
  @override
  Future<List<Supplement>> build(String profileId) async {
    // profileId is a required parameter - enforced at compile time

    final result = await useCase(GetSupplementsInput(
      profileId: profileId,  // REQUIRED - never optional
    ));

    return result.when(
      success: (supplements) => supplements,
      failure: (error) => throw error,
    );
  }
}

// In UI:
final supplements = ref.watch(supplementListProvider(currentProfileId));
```

Profile ID comes from:
1. Route parameter (for profile-specific screens)
2. ProfileProvider.currentProfileId (for shared screens)
```

---

## D. Database Standards Alignment

### D1. Sync Metadata Column Types [CRITICAL]

**Problem:** Standards say TEXT, Schema says INTEGER

**Decision:** Use INTEGER (epoch milliseconds) for performance

**Files to Update:**

1. **02_CODING_STANDARDS.md** Section 8.2:
```sql
-- UPDATED: Use INTEGER for timestamps (epoch milliseconds)
CREATE TABLE supplements (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  name TEXT NOT NULL,

  -- Sync metadata (INTEGER for timestamps)
  sync_created_at INTEGER NOT NULL,
  sync_updated_at INTEGER NOT NULL,
  sync_deleted_at INTEGER,
  sync_last_synced_at INTEGER,
  sync_status INTEGER NOT NULL DEFAULT 0,
  sync_version INTEGER NOT NULL DEFAULT 1,
  sync_is_dirty INTEGER NOT NULL DEFAULT 1,
  sync_device_id TEXT NOT NULL,

  FOREIGN KEY (profile_id) REFERENCES profiles(id)
);
```

2. **02_CODING_STANDARDS.md** Section 8.3:
```dart
// Date conversion functions
int dateToEpoch(DateTime dt) => dt.toUtc().millisecondsSinceEpoch;
DateTime epochToDate(int epoch) => DateTime.fromMillisecondsSinceEpoch(epoch, isUtc: true);
```

---

### D2. Sync Device ID Columns [HIGH]

**Problem:** Standards show two device columns, schema shows one

**Decision:** Use single `sync_device_id` (last modifier) for simplicity

**File to Update:** `02_CODING_STANDARDS.md` Section 8.2

**Change from:**
```
sync_created_by_device_id TEXT NOT NULL,
sync_last_modified_by_device_id TEXT NOT NULL,
```

**To:**
```
sync_device_id TEXT NOT NULL,  -- Last device to modify
```

Note: Created-by device can be tracked via first sync version if needed.

---

### D3. Index Specification Guidelines [HIGH]

**Problem:** No guidance on when/what to index

**File to Update:** `02_CODING_STANDARDS.md` Section 8.4

**Add:**
```
### 8.4 Index Guidelines

**Required indexes for EVERY table:**
```sql
-- Foreign key index
CREATE INDEX idx_{table}_profile ON {table}(profile_id);

-- Sync query index
CREATE INDEX idx_{table}_sync ON {table}(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;

-- Client scope index
CREATE INDEX idx_{table}_client ON {table}(client_id);
```

**For frequently queried columns:**
```sql
-- Timestamp range queries
CREATE INDEX idx_{table}_timestamp ON {table}(profile_id, timestamp DESC);

-- Name/search queries
CREATE INDEX idx_{table}_name ON {table}(profile_id, name COLLATE NOCASE);
```

**Avoid indexing:**
- Low cardinality boolean fields alone
- TEXT fields for LIKE queries (use FTS5 instead)
- Columns rarely used in WHERE clauses
```

---

### D4. Migration Strategy [HIGH]

**Problem:** No migration approach documented

**File to Update:** `10_DATABASE_SCHEMA.md` (add new section)

**Add Section 15: Migration Strategy:**
```
## 15. Database Migration Strategy

### 15.1 Migration Naming
- Format: `v{from}_to_v{to}_{description}.sql`
- Example: `v3_to_v4_add_client_id.sql`

### 15.2 Migration Requirements
1. Each migration MUST be idempotent (safe to run multiple times)
2. Include version check: `PRAGMA user_version = X`
3. Wrap in transaction where possible
4. Test against production data snapshot before release

### 15.3 Rollback
- Document rollback SQL for each migration
- Never rely on automatic rollback for data migrations
- Backup before migration in production

### 15.4 Data Validation
- Verify row counts before/after
- Check constraint violations
- Validate foreign key integrity
```

---

### D5. Table Exemptions from Sync [MEDIUM]

**Problem:** Not clear which tables skip sync metadata

**File to Update:** `02_CODING_STANDARDS.md` Section 8.2

**Add:**
```
### 8.2.1 Tables Exempt from Sync Metadata

The following tables do NOT require sync metadata columns:

| Table | Reason |
|-------|--------|
| profile_access_logs | Immutable audit trail |
| imported_data_log | Import deduplication only |
| ml_models | Device-local ML artifacts |
| prediction_feedback | Device-local feedback |

These tables are local-only and not synchronized.
```

---

## E. Sync System Specification

### E1. Conflict Resolution Strategy [CRITICAL]

**Problem:** No conflict handling specified

**File to Update:** `02_CODING_STANDARDS.md` - Add Section 9.4

**Add:**
```
### 9.4 Conflict Resolution

#### Detection
Conflict occurs when:
- Local `sync_version` != remote `sync_version`
- Both have `sync_is_dirty = 1`

#### Resolution Strategies

| Data Type | Strategy | Rationale |
|-----------|----------|-----------|
| Timestamps | Last-write-wins | Simple, deterministic |
| Health entries | User chooses | Medical data too important |
| Settings | Last-write-wins | Low risk |
| Supplements | Merge if possible | Combine ingredient lists |

#### Conflict Data Storage
```sql
-- Store conflicting version in conflict_data column
UPDATE supplements SET
  sync_status = 2,  -- conflict
  conflict_data = '{"remote": {...}, "local": {...}, "detected_at": "..."}'
WHERE id = ?;
```

#### User Resolution Flow
1. Show conflict notification badge
2. Present side-by-side comparison
3. User selects: Keep Local | Accept Remote | Merge
4. After resolution: `sync_version++`, `sync_status = pending`
```

---

### E2. Dirty Flag State Machine [CRITICAL]

**Problem:** Dirty flag transitions undefined

**File to Update:** `02_CODING_STANDARDS.md` Section 9.2

**Add state diagram:**
```
### 9.2 Dirty Flag State Machine

```
CREATE (local) → sync_is_dirty = 1, sync_status = pending
      ↓
SYNC UPLOAD → (no change during upload)
      ↓
SYNC SUCCESS → sync_is_dirty = 0, sync_status = synced, sync_last_synced_at = NOW
      ↓
MODIFY (local) → sync_is_dirty = 1, sync_status = pending
      ↓
SYNC FAIL → sync_is_dirty = 1, sync_status = error (retry later)
      ↓
CONFLICT → sync_is_dirty = 1, sync_status = conflict (user resolves)
      ↓
RESOLVE → sync_is_dirty = 1, sync_status = pending (re-sync)
```

**Rules:**
- `markDirty: true` - Only for LOCAL user actions
- `markDirty: false` - Only for REMOTE sync applies
- Never set `sync_is_dirty = 0` until server confirms receipt
```

---

### E3. Soft Delete with Cascade [CRITICAL]

**Problem:** Cascade behavior undefined

**File to Update:** `02_CODING_STANDARDS.md` Section 9.3

**Expand:**
```
### 9.3 Soft Delete Implementation

#### Basic Soft Delete
```dart
Future<Result<void, AppError>> deleteSupplement(String id) async {
  final supplement = await localDataSource.getSupplement(id);
  final deleted = supplement.copyWith(
    syncMetadata: supplement.syncMetadata.copyWith(
      deletedAt: DateTime.now().toUtc(),
      syncStatus: SyncStatus.pending,
    ),
  );
  await localDataSource.updateSupplement(deleted);
  return const Result.success(null);
}
```

#### Cascade Soft Delete
When parent is deleted, cascade to children:

| Parent | Children to Cascade |
|--------|---------------------|
| Profile | All health data for that profile |
| Supplement | All intake_logs for that supplement |
| Condition | All condition_logs for that condition |
| Diet | All diet_violations for that diet |

```dart
Future<void> deleteSupplementWithCascade(String id) async {
  // 1. Soft delete parent
  await deleteSupplement(id);

  // 2. Soft delete children
  await localDataSource.softDeleteIntakeLogsForSupplement(id);
}
```

#### Hard Delete Policy
Hard delete ONLY allowed for:
1. User account deletion (GDPR right-to-be-forgotten)
2. Sync cleanup after server confirms tombstone received
3. Local cache purge (non-synced temp data)

Never hard delete synced health data without server confirmation.
```

---

### E4. Archive vs Delete Distinction [HIGH]

**Problem:** Archive feature exists but not specified

**File to Update:** `02_CODING_STANDARDS.md` Section 3.3

**Add:**
```
### Archive vs Delete

| Operation | Column Set | User Action | Sync Behavior |
|-----------|------------|-------------|---------------|
| Archive | `is_archived = 1` | "Pause" item | Synced, excluded from active lists |
| Delete | `sync_deleted_at = NOW` | "Delete" item | Synced as tombstone |

```dart
// Archive: Temporarily hide from active lists
Future<void> archiveSupplement(String id) async {
  await update(supplement.copyWith(isArchived: true));
}

// Unarchive: Restore to active lists
Future<void> unarchiveSupplement(String id) async {
  await update(supplement.copyWith(isArchived: false));
}

// Delete: Soft delete (permanent intent)
Future<void> deleteSupplement(String id) async {
  await delete(id);  // Sets sync_deleted_at
}
```
```

---

### E5. Sync Retry Strategy [HIGH]

**Problem:** No retry logic specified

**File to Update:** Add to `02_CODING_STANDARDS.md` Section 9

**Add Section 9.5:**
```
### 9.5 Sync Retry Strategy

#### Exponential Backoff
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

#### Retry Rules
- Max 5 retries per record before marking as `error`
- Reset retry count after successful sync
- Pause sync when offline (resume on connectivity)
- Show "Sync failed" indicator after 3 retries

#### User Recovery
- Manual "Retry Sync" button in settings
- "Discard Local Changes" for unresolvable conflicts
```

---

## F. Security Standards Completion

### F1. PII Masking Functions [CRITICAL]

**Problem:** Only email masking shown

**File to Update:** `02_CODING_STANDARDS.md` Section 11.1

**Add:**
```dart
### 11.1 PII Masking Functions

/// NEVER log these data types without masking:

// Email: first2***@domain.com
String maskEmail(String email) {
  final parts = email.split('@');
  if (parts.length != 2) return '***@***';
  final local = parts[0];
  final masked = local.length > 2 ? '${local.substring(0, 2)}***' : '***';
  return '$masked@${parts[1]}';
}

// Phone: ***-***-1234
String maskPhone(String phone) {
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  if (digits.length < 4) return '***';
  return '***-***-${digits.substring(digits.length - 4)}';
}

// Token: abc***xyz
String maskToken(String token) {
  if (token.length < 8) return '[REDACTED]';
  return '${token.substring(0, 3)}***${token.substring(token.length - 3)}';
}

// Health data: NEVER log values
// Log: "BBT recorded" not "BBT: 98.6°F"
// Log: "Condition severity updated" not "Severity: 8"

// User ID: Hash for correlation, never raw
String maskUserId(String userId) => sha256(userId).substring(0, 16);
```

---

### F2. HTTP Timeout Defaults [CRITICAL]

**Problem:** No timeout values specified

**File to Update:** `11_SECURITY_GUIDELINES.md` Section 11.2

**Add:**
```
### HTTP Timeout Configuration

| Operation Type | Timeout | Example |
|----------------|---------|---------|
| User-facing API | 15 seconds | Profile load, list fetch |
| Standard API | 30 seconds | OAuth, sync operations |
| Heavy operations | 60 seconds | File upload, bulk sync |
| Background sync | 120 seconds | Full sync with retry |

```dart
// Default timeout for all HTTP calls
const defaultHttpTimeout = Duration(seconds: 30);

// Usage
final response = await http.get(uri).timeout(defaultHttpTimeout);
```
```

---

### F3. Certificate Pinning Specification [HIGH]

**Problem:** Mentioned but not detailed

**File to Update:** `11_SECURITY_GUIDELINES.md` Section 11.2

**Add:**
```
### Certificate Pinning

**Required for:**
- `accounts.google.com` (OAuth)
- `oauth2.googleapis.com` (Token exchange)
- `www.googleapis.com` (Drive API)

**Implementation:**
```dart
// Pin SHA-256 public key hash
final pinnedCertificates = {
  'accounts.google.com': 'sha256/AAAA...',
  'oauth2.googleapis.com': 'sha256/BBBB...',
};

// Validation
void validateCertificate(X509Certificate cert, String host) {
  final expectedHash = pinnedCertificates[host];
  if (expectedHash != null) {
    final actualHash = sha256(cert.publicKey);
    if (actualHash != expectedHash) {
      throw CertificatePinningException('Pin mismatch for $host');
    }
  }
}
```

**Rotation:**
- Include backup pins for certificate rotation
- Document pin update schedule (quarterly review)
- Alert on pin mismatch (don't just fail silently)
```

---

### F4. Token Clearance Specification [HIGH]

**Problem:** "Clear tokens on sign-out" too vague

**File to Update:** `02_CODING_STANDARDS.md` Section 11.3

**Expand:**
```
### 11.3 Token Clearance on Sign-Out

All tokens MUST be cleared atomically:

```dart
Future<void> signOut() async {
  // Clear ALL auth-related data
  await Future.wait([
    _secureStorage.delete(key: 'access_token'),
    _secureStorage.delete(key: 'refresh_token'),
    _secureStorage.delete(key: 'token_expiry'),
    _secureStorage.delete(key: 'user_email'),
    _secureStorage.delete(key: 'user_id'),
  ]);

  // Verify clearance
  final accessToken = await _secureStorage.read(key: 'access_token');
  assert(accessToken == null, 'Token clearance failed');

  // Clear in-memory state
  _authState = AuthState.unauthenticated;
  notifyListeners();
}
```

**Verification after clearance:**
- [ ] All tokens return null from secure storage
- [ ] Subsequent API calls fail with 401
- [ ] User must re-authenticate
- [ ] No cached profile data accessible
```

---

### F5. Authorization Validation at SQL Level [CRITICAL]

**Problem:** No profile ownership validation specified

**File to Update:** `02_CODING_STANDARDS.md` Section 4.3

**Add:**
```
### 4.3 Profile Authorization at Data Layer

**MANDATORY:** All data source queries MUST validate profile ownership:

```sql
-- CORRECT: Validate user owns the profile
SELECT s.* FROM supplements s
INNER JOIN profiles p ON s.profile_id = p.id
WHERE s.profile_id = ?
  AND p.owner_id = ?  -- Current user's ID
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
  AND (p.owner_id = ? OR (h.granted_to_user_id = ? AND h.revoked_at IS NULL))
  AND s.sync_deleted_at IS NULL;
```
```

---

## G. Testing Standards Expansion

### G1. Security Test Coverage [HIGH]

**File to Update:** `06_TESTING_STRATEGY.md`

**Add Section 9.2:**
```
### 9.2 Security Test Coverage Requirements

| Component | Coverage | Test Cases |
|-----------|----------|------------|
| OAuth token storage | 100% | Store, retrieve, clear, expired handling |
| Encryption service | 100% | Encrypt/decrypt roundtrip, invalid input |
| Input sanitization | 100% | XSS, SQL injection, HTML injection |
| Authorization checks | 100% | Denied access, expired, wrong profile |
| PII masking | 100% | All masking functions |
| Secure storage | 100% | Platform-specific operations |

**Required test files:**
- `test/core/services/oauth_service_test.dart`
- `test/core/services/encryption_service_test.dart`
- `test/core/utils/input_sanitizer_test.dart`
- `test/core/utils/pii_masking_test.dart`
```

---

### G2. OAuth Token Refresh Tests [HIGH]

**File to Update:** `06_TESTING_STRATEGY.md`

**Add:**
```dart
// test/core/services/oauth_service_test.dart
group('Token Refresh', () {
  test('refreshToken_validToken_returnsNewAccessToken', () async {
    // Arrange: Valid refresh token
    // Act: Call refresh
    // Assert: New access token returned
  });

  test('refreshToken_expiredRefreshToken_throwsAuthError', () async {
    // Arrange: Expired refresh token
    // Act: Call refresh
    // Assert: AuthError thrown, user must re-authenticate
  });

  test('needsRefresh_expiresIn4Minutes_returnsTrue', () {
    // Token expiring within 5 minutes should trigger refresh
  });

  test('needsRefresh_expiresIn10Minutes_returnsFalse', () {
    // Token valid for 10+ minutes should not refresh
  });
});
```

---

### G3. Audit Logging Tests [HIGH]

**File to Update:** `06_TESTING_STRATEGY.md`

**Add:**
```dart
// test/core/services/audit_log_service_test.dart
group('AuditLogService', () {
  test('logPhiAccess_createsImmutableEntry', () async {
    await service.logPhiAccess(
      entityType: 'Supplement',
      entityId: '123',
      action: 'read',
    );

    final entries = await service.getEntries(limit: 1);
    expect(entries.length, 1);

    // Verify immutability
    expect(
      () => service.deleteEntry(entries.first.id),
      throwsA(isA<AuditLogException>()),
    );
  });

  test('logPhiAccess_recordsAllRequiredFields', () async {
    // Verify HIPAA required fields: who, what, when, where
  });
});
```

---

### G4. Integration Test Directory [MEDIUM]

**File to Update:** `06_TESTING_STRATEGY.md` Section 8

**Clarify:**
```
### 8.0 Integration Test Organization

```
test/
├── integration/           # Fast integration tests (mocked backend)
│   ├── supplement_flow_test.dart
│   └── sync_flow_test.dart
└── ...

integration_test/          # Flutter integration tests (on device/emulator)
├── app_test.dart
├── user_journey_test.dart
└── performance_test.dart
```

- `test/integration/` - Run with `flutter test`, use mocks
- `integration_test/` - Run with `flutter drive`, test real UI
```

---

### G5. Network Error Scenario Tests [MEDIUM]

**File to Update:** `06_TESTING_STRATEGY.md`

**Add:**
```dart
// integration_test/network_error_test.dart
testWidgets('timeout_showsErrorAndRetry', (tester) async {
  // Mock HTTP timeout
  when(mockHttp.get(any)).thenThrow(TimeoutException());

  await tester.pumpWidget(ShadowApp());
  await tester.tap(find.byIcon(Icons.sync));
  await tester.pumpAndSettle();

  // Error message shown
  expect(find.text('Connection timed out'), findsOneWidget);

  // Retry button present
  expect(find.text('Retry'), findsOneWidget);
});
```

---

## H. Accessibility Specification

### H1. Semantic Labels for All Fields [CRITICAL]

**Problem:** 150+ form fields have no semantic labels

**File to Update:** `38_UI_FIELD_SPECIFICATIONS.md`

**Add column to ALL field tables:**
```
| Field | Type | Semantic Label |
|-------|------|----------------|
| Profile Name | TextField | "Profile name, required" |
| Birth Date | DatePicker | "Birth date, optional, format month day year" |
| Supplement Name | TextField | "Supplement name, required" |
| Dosage Amount | NumberField | "Dosage amount, required, enter number" |
```

**Pattern:** `"{Field name}, {required|optional}, {additional context}"`

---

### H2. Touch Target Sizes [HIGH]

**File to Update:** `38_UI_FIELD_SPECIFICATIONS.md`

**Add Section 14.6:**
```
### 14.6 Touch Target Requirements

All interactive elements minimum 48x48 dp:

| Element | Minimum Size | Implementation |
|---------|--------------|----------------|
| Buttons | 48x48 dp | `minimumSize: Size(48, 48)` |
| Icon buttons | 48x48 dp container | `SizedBox(width: 48, height: 48)` |
| Checkboxes | 48x48 dp tap area | `Checkbox` default is compliant |
| Switches | 48 dp height | `Switch` default is compliant |
| List items | 48 dp height minimum | `ListTile` default is compliant |
| Form fields | 48 dp height | Standard `TextField` is compliant |
```

---

### H3. Focus Order Specification [HIGH]

**File to Update:** `38_UI_FIELD_SPECIFICATIONS.md`

**Add Section 14.7:**
```
### 14.7 Focus Order

Each form screen MUST define logical focus order:

**Add/Edit Supplement Screen:**
1. Supplement Name
2. Brand
3. Form dropdown
4. Dosage Amount
5. Dosage Unit
6. Frequency
7. Time(s) picker
8. Notes
9. Save button
10. Cancel button

**Implementation:**
```dart
FocusTraversalGroup(
  policy: OrderedTraversalPolicy(),
  child: Column(
    children: [
      FocusTraversalOrder(order: NumericFocusOrder(1), child: nameField),
      FocusTraversalOrder(order: NumericFocusOrder(2), child: brandField),
      // ...
    ],
  ),
)
```
```

---

### H4. Color Independence [MEDIUM]

**File to Update:** `38_UI_FIELD_SPECIFICATIONS.md`

**Add to affected sections:**
```
### Color Independence Requirements

Status displays MUST NOT rely on color alone:

| Element | Color | Additional Indicator |
|---------|-------|---------------------|
| Severity slider | Red gradient | Numeric value + "Severe" label |
| Compliance % | Green/Yellow/Red | Percentage number always shown |
| Diet violation | Red highlight | Warning icon + text description |
| Sync status | Green/Orange/Red | Icon (check/arrow/error) + text |
```

---

### H5. Widget Library Accessibility [HIGH]

**File to Update:** `09_WIDGET_LIBRARY.md`

**Add Section 5.5:**
```
### 5.5 Accessibility Requirements for All Widgets

Every widget MUST support:

1. **Semantic Label** - Required parameter or derived from label
2. **Focus Handling** - Can receive focus via keyboard
3. **Touch Target** - Minimum 48x48 dp
4. **Color Independence** - Information not conveyed by color alone

```dart
class AccessibleTextField extends StatelessWidget {
  final String label;
  final String? semanticLabel;  // Uses label if not provided

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? label,
      textField: true,
      child: TextField(
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
```
```

---

## I. Documentation Standards

### I1. Dartdoc for Widget Library [MEDIUM]

**File to Update:** `09_WIDGET_LIBRARY.md`

**Convert examples to Dartdoc format:**
```dart
/// Accessible text field with semantic support.
///
/// Provides a text input that meets WCAG 2.1 Level AA requirements
/// for screen reader compatibility and keyboard navigation.
///
/// Example:
/// ```dart
/// AccessibleTextField(
///   label: 'Email',
///   controller: emailController,
///   validator: EmailValidator.validate,
/// )
/// ```
///
/// See also:
/// * [AccessibleDropdown] for selection fields
/// * [AccessibleDatePicker] for date inputs
class AccessibleTextField extends StatelessWidget {
  /// The field label displayed above the input.
  final String label;

  /// Screen reader label. Defaults to [label] if not provided.
  final String? semanticLabel;

  /// ...
}
```

---

### I2. File Header Template [LOW]

**File to Update:** `09_WIDGET_LIBRARY.md`

**Add:**
```
### File Header Template

Every widget file must include:

```dart
/// Accessible button components for Shadow app.
///
/// Provides [AccessibleButton], [AccessibleElevatedButton],
/// and [AccessibleIconButton] implementations following
/// WCAG 2.1 Level AA accessibility standards.
///
/// See also:
/// * [12_ACCESSIBILITY_GUIDELINES.md] for full requirements
/// * [AccessibleTextField] for form inputs
library;

import 'package:flutter/material.dart';
```
```

---

### I3. Widget Implementation Mapping [MEDIUM]

**File to Update:** `38_UI_FIELD_SPECIFICATIONS.md`

**Add column to field tables:**
```
| Field | Type | Widget Class |
|-------|------|--------------|
| Profile Name | TextField | `AccessibleTextField` |
| Birth Date | DatePicker | `AccessibleDatePicker` |
| Supplement Form | Dropdown | `AccessibleDropdown<SupplementForm>` |
| Specific Days | Multi-select | `AccessibleMultiSelectChips` |
```

---

### I4. Enum Documentation Pattern [MEDIUM]

**File to Update:** `02_CODING_STANDARDS.md` Section 14.1

**Add:**
```dart
/// Enum Documentation Pattern

/// Flow intensity for menstruation tracking.
///
/// Used in [FluidsEntry] to record menstrual flow levels.
enum MenstruationFlow {
  /// No menstruation or spotting detected.
  none,

  /// Light spotting, barely visible.
  spotty,

  /// Light flow, minimal pad/tampon use.
  light,

  /// Medium flow, regular pad/tampon changes.
  medium,

  /// Heavy flow, frequent pad/tampon changes.
  heavy,
}
```

---

## J. Code Review Checklist Updates

### J1. Spec Compliance Check [HIGH]

**File to Update:** `24_CODE_REVIEW_CHECKLIST.md`

**Add to Section 2.1:**
```
#### Specification Compliance
- [ ] Form matches 38_UI_FIELD_SPECIFICATIONS.md
  - [ ] All required fields present
  - [ ] Field labels match spec
  - [ ] Validation rules implemented
  - [ ] Default values match spec
  - [ ] Placeholder text matches spec
- [ ] Entity matches 22_API_CONTRACTS.md
  - [ ] All fields present with correct types
  - [ ] Required vs optional matches spec
```

---

### J2. Interactive Elements Definition [HIGH]

**File to Update:** `24_CODE_REVIEW_CHECKLIST.md` Section 2.4

**Clarify:**
```
#### Accessibility - Interactive Elements

Elements REQUIRING semantic labels:
- [ ] Buttons (Button, IconButton, FAB)
- [ ] Form inputs (TextField, Dropdown, Switch, Checkbox)
- [ ] Tappable cards/list items (onTap handlers)
- [ ] Custom GestureDetectors with onTap
- [ ] Sliders and range selectors
- [ ] Tab bars and navigation items

Elements NOT requiring labels (mark as decorative):
- [ ] Dividers and spacers
- [ ] Decorative background images
- [ ] Icons inside labeled buttons
- [ ] Status icons when text describes status
```

---

### J3. Performance Checklist Expansion [HIGH]

**File to Update:** `24_CODE_REVIEW_CHECKLIST.md` Section 2.5

**Expand:**
```
#### Performance Review

**List Rendering:**
- [ ] Uses `ListView.builder` for variable-length lists
- [ ] itemBuilder creates const widgets where possible
- [ ] No expensive computations in build()
- [ ] Implements pagination for 50+ items

**Image Performance:**
- [ ] All `Image` widgets specify `cacheWidth`/`cacheHeight`
- [ ] Cache dimensions appropriate for display size
- [ ] Large images loaded asynchronously

**Database Performance:**
- [ ] Queries use indexes on filtered columns
- [ ] No N+1 queries in loops
- [ ] Batch operations for multiple inserts/updates
- [ ] Large result sets paginated

**State Management:**
- [ ] Heavy computations not in build()
- [ ] Providers scoped appropriately
- [ ] No unnecessary rebuilds
```

---

### J4. ProfileId Filtering Checklist [CRITICAL]

**File to Update:** `24_CODE_REVIEW_CHECKLIST.md` Section 2.1

**Add:**
```
#### ProfileId Filtering (MANDATORY)

- [ ] ALL repository methods returning lists include `profileId` parameter
- [ ] Data source WHERE clause always includes `profile_id = ?`
- [ ] UseCase checks authorization: `authService.canRead(profileId)`
- [ ] No methods return data from all profiles without explicit admin role

**Methods that MUST filter by profileId:**
- `getAll{Entity}s()`
- `search{Entity}s()`
- `get{Entity}sForDate()`
- `get{Entity}sInRange()`
- Any method returning `List<T>`
```

---

## K. Cross-Document Alignment

### K1. Update Entity Examples with clientId [MEDIUM]

**Files to Update:**
- `02_CODING_STANDARDS.md` Sections 3.3, 5.1, 7.2
- All entity examples should include clientId

---

### K2. Align SyncStatus Integer Values [MEDIUM]

**Files to Update:**
- `02_CODING_STANDARDS.md` Section 9.1
- `10_DATABASE_SCHEMA.md` Section 2.2

**Standard values:**
```
| Value | Status | Description |
|-------|--------|-------------|
| 0 | pending | Awaiting sync |
| 1 | synced | Successfully synced |
| 2 | conflict | Conflict detected |
| 3 | error | Sync error |
```

---

### K3. Diet System Examples [MEDIUM]

**File to Update:** `02_CODING_STANDARDS.md`

**Add Diet as worked example in relevant sections**

---

### K4. Intelligence System in Architecture [MEDIUM]

**File to Update:** `04_ARCHITECTURE.md`

**Add Intelligence Layer section showing:**
- PatternDetectionService
- TriggerCorrelationService
- HealthInsightsService
- Integration with existing patterns

---

### K5-K9. Minor Alignment Items [LOW]

- Enum value mapping table
- Notification profileId filtering
- Feature-specific error codes
- Archive table documentation
- Data retention policy references

---

## Implementation Tracking

### Phase 1: Critical Fixes (Before Development) ✅ COMPLETE

**Completed: January 31, 2026**

- [x] A1. Choose Result pattern - Updated Section 3.1, 3.3, 3.4, 7 in 02_CODING_STANDARDS.md
- [x] B1. Add clientId requirement - Added to Section 5.1 entity requirements
- [x] B2. Enforce Freezed - Added Section 5.0 with code generation requirement
- [x] C1. Add UseCase requirement - Added Section 6.2 with mandatory delegation
- [x] C2. Specify Riverpod - Added preamble to Section 6 with Riverpod annotation
- [x] C3. Result type in providers - Updated Section 6.1, 6.3 with Result handling
- [x] D1. Sync metadata column types - Changed to INTEGER in Section 8.2, 8.3
- [x] E1. Conflict resolution - Added Section 9.4 with strategies and data storage
- [x] E2. Dirty flag state machine - Added state diagram to Section 9.2
- [x] E3. Soft delete cascade - Expanded Section 9.3 with cascade rules
- [x] F1. PII masking - Added comprehensive masking functions to Section 11.1
- [x] F2. HTTP timeouts - Added timeout table to Section 11.2
- [x] F5. SQL-level authorization - Added Section 11.4 with query examples
- [x] H1. Semantic labels - Added Section 16 to 38_UI_FIELD_SPECIFICATIONS.md
- [x] J4. ProfileId checklist - Added to 24_CODE_REVIEW_CHECKLIST.md Sections 1, 2.1

### Phase 2: High Priority (Before Entity Implementation) ✅ COMPLETE

**Completed: January 31, 2026**

- [x] A2. AppError hierarchy - Added full sealed class in Section 7.1
- [x] B3. List field rules - Added to Section 5.2 with @Default patterns
- [x] B4. SyncMetadata factory - Added SyncMetadata.initial() in Section 5.3
- [x] B5. SyncMetadata mutation rules - Added table and extension in Section 5.3
- [x] C4. Write access pattern - Added to Section 6.4
- [x] C5. Profile filtering pattern - Added to Section 6.5
- [x] D2. Sync device columns - Simplified to single sync_device_id in Section 8.2
- [x] D3. Index guidelines - Added comprehensive Section 8.4
- [x] D4. Migration strategy - Added Section 8.5
- [x] E4. Archive vs delete - Added Section 9.5
- [x] E5. Sync retry - Added Section 9.7
- [x] F3. Certificate pinning - Added details to Section 11.2
- [x] F4. Token clearance - Added atomic clearance to Section 11.3
- [x] H2-H5. Accessibility - Added touch targets, focus order to 38_UI_FIELD_SPECIFICATIONS.md
- [x] G1-G5. Testing standards - Added test directory structure (Section 8.0), network error scenarios (Section 8.2), security test coverage (Section 9.2) to 06_TESTING_STRATEGY.md
- [x] J1-J3. Review checklist additions - Added specification compliance section, expanded performance checklist to 24_CODE_REVIEW_CHECKLIST.md

### Phase 3: Medium Priority (During Development) ✅ COMPLETE

**Completed: January 31, 2026**

- [x] A3. Error code registry - Added table to Section 7.3
- [x] A4. Structured logging - Covered by PII masking in Section 11.1
- [x] B6. Computed properties - Added Section 5.4
- [x] D5. Table exemptions - Added Section 8.2.1
- [x] I1-I4. Documentation - Added comprehensive Dartdoc patterns (Section 7), file headers, widget implementation mapping, focus order requirements to 09_WIDGET_LIBRARY.md
- [x] K1-K9. Cross-document alignment - Entity examples with clientId added to 07_NAMING_CONVENTIONS.md, 05_IMPLEMENTATION_ROADMAP.md, 28_ENGINEERING_PRINCIPLES.md; SyncStatus INTEGER values aligned across all documents (05, 06, 07, 42); sync_created_at/sync_updated_at changed to INTEGER (epoch milliseconds) consistently

---

## Verification ✅ COMPLETE

**Verified: January 31, 2026**

1. **Consistency Check**
   - [x] Search for "EntityNotFoundException" - removed from active standards
   - [x] Search for "ChangeNotifier" - replaced with Riverpod throughout
   - [x] All entity examples include clientId - verified in 02, 05, 07, 22, 28
   - [x] All repository methods return Result type - standardized in 02_CODING_STANDARDS.md Section 3

2. **Standards Compliance**
   - [x] Result pattern documented with sealed class hierarchy
   - [x] Semantic labels added for 200+ form fields in 38_UI_FIELD_SPECIFICATIONS.md Section 16
   - [x] Touch targets (48dp minimum) documented in Section 16.3
   - [x] Focus order requirements added in Section 16.4

3. **Security Audit**
   - [x] PII masking functions documented in 02_CODING_STANDARDS.md Section 11.1
   - [x] HTTP timeouts specified in Section 11.2
   - [x] Profile authorization at SQL level in Section 11.4
   - [x] Token clearance documented in Section 11.3

4. **Cross-Document Alignment**
   - [x] SyncStatus uses INTEGER (0=pending, 1=synced, 2=conflict, 3=error) consistently
   - [x] sync_created_at/sync_updated_at use INTEGER (epoch milliseconds) consistently
   - [x] sync_status column uses INTEGER DEFAULT 0 in all table definitions

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-31 | Initial creation from audit findings |
