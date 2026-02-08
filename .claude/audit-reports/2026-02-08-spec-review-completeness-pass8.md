# Spec Review Report - 2026-02-08 (Completeness & Coverage Pass 8)

## Executive Summary
- Focus: Types/classes referenced but never defined, definitions never referenced, missing repository/service contracts
- New completeness gaps found: 11
- Severity: 4 CRITICAL (would-not-compile), 4 HIGH (missing definitions needed for implementation), 3 MEDIUM (orphaned/incomplete)
- **Key systemic finding:** The wearable data import subsystem (Section 4.3 lines 6375-6690) references an entire ecosystem of DTO types and output classes that were never defined

---

## New Completeness Gaps Found

### ISSUE-CG-1: Model<T> interface never defined (line 1732)
**Type:** MISSING_DEFINITION
**Severity:** CRITICAL
**Location:** Line 1732
**Referenced type/method:** `Model<T>`
**Problem:** `BaseLocalDataSource<T extends Syncable, M extends Model<T>>` uses `Model<T>` as a type parameter constraint at line 1732. The `Model<T>` interface is never defined anywhere in the spec. The `_toModel()` method at line 1944 returns type `M` (constrained to `Model<T>`), and `model.copyWith()` and `model.toMap()` are called on it (lines 1800, 1810, 1837, 1844), implying `Model<T>` must define these methods.
**Fix:** Add a `Model<T>` abstract class definition near line 1730:
```dart
/// Base interface for database model classes that map entities to/from database rows.
abstract class Model<T> {
  Map<String, dynamic> toMap();
  Model<T> copyWith({
    String? id,
    int? syncCreatedAt,
    int? syncUpdatedAt,
    int? syncVersion,
    bool? syncIsDirty,
    int? syncStatus,
    int? syncDeletedAt,
  });
}
```

---

### ISSUE-CG-2: 6 Model implementation classes never defined (lines 3608-3907)
**Type:** MISSING_DEFINITION
**Severity:** CRITICAL
**Location:** Lines 3608, 3670, 3750, 3817, 3845, 3907
**Referenced type/method:** `SupplementModel`, `FluidsEntryModel`, `DietModel`, `ConditionLogModel`, `IntakeLogModel`, `HealthInsightModel`
**Problem:** Six data source implementations extend `BaseLocalDataSource<Entity, XxxModel>` but none of the Model classes are defined:
- `SupplementLocalDataSource extends BaseLocalDataSource<Supplement, SupplementModel>` (line 3608)
- `FluidsEntryLocalDataSource extends BaseLocalDataSource<FluidsEntry, FluidsEntryModel>` (line 3670)
- `DietLocalDataSource extends BaseLocalDataSource<Diet, DietModel>` (line 3750)
- `ConditionLogLocalDataSource extends BaseLocalDataSource<ConditionLog, ConditionLogModel>` (line 3817)
- `IntakeLogLocalDataSource extends BaseLocalDataSource<IntakeLog, IntakeLogModel>` (line 3845)
- `HealthInsightLocalDataSource extends BaseLocalDataSource<HealthInsight, HealthInsightModel>` (line 3907)

Each model class must implement `Model<T>` and provide `toMap()` and `copyWith()` methods for database serialization.
**Fix:** Add model class definitions for each entity's data layer (each ~30-50 lines). These belong in a "Section 5: Data Layer Model Contracts" or adjacent to the data source definitions.

---

### ISSUE-CG-3: 3 Wearable DTO types used but never defined (lines 6568, 6603, 6638)
**Type:** MISSING_DEFINITION
**Severity:** CRITICAL
**Location:** Lines 6568, 6603, 6638
**Referenced type/method:** `WearableActivity`, `WearableSleep`, `WearableWaterIntake`
**Problem:** The wearable data import private methods use these types as parameters:
- `_importActivity(String profileId, String clientId, WearableActivity activity)` (line 6565)
- `_importSleep(String profileId, String clientId, WearableSleep sleep)` (line 6600)
- `_importWater(String profileId, String clientId, WearableWaterIntake water)` (line 6635)

The code accesses fields on these DTOs:
- `WearableActivity`: `externalId`, `startTime`, `mappedActivityId`, `durationMinutes`, `source` (lines 6573-6589)
- `WearableSleep`: `externalId`, `sleepStart`, `sleepEnd`, `quality`, `source` (lines 6609-6622)
- `WearableWaterIntake`: `loggedAt`, `amountMl` (lines 6642-6656)

Additionally, the return type of `_platformService.fetchData()` (line 6443-6451) is never defined. The result object accesses `.activities`, `.sleepEntries`, `.waterIntakes` (lines 6465, 6479, 6493), implying a container class like `WearablePlatformData`.
**Fix:** Define 4 DTO classes:
```dart
@freezed class WearableActivity with _$WearableActivity { ... }
@freezed class WearableSleep with _$WearableSleep { ... }
@freezed class WearableWaterIntake with _$WearableWaterIntake { ... }
@freezed class WearablePlatformData with _$WearablePlatformData { ... }
```

---

### ISSUE-CG-4: SyncWearableDataOutput field names completely wrong (line 6538 vs 10200)
**Type:** MISSING_DEFINITION (field mismatch)
**Severity:** CRITICAL
**Location:** Lines 6538-6544 (construction) vs 10200-10210 (definition)
**Referenced type/method:** `SyncWearableDataOutput`
**Problem:** The use case constructs `SyncWearableDataOutput` with 5 fields that don't exist in the definition:

| Use case (line 6538) | Entity definition (line 10200) |
|---|---|
| `importedCount: importedCount` | `recordsImported` |
| `skippedCount: skippedCount` | `recordsSkipped` |
| `errorCount: errorCount` | `errors` (List\<String\>, NOT int!) |
| `syncedRangeStart: syncStart` | DOES NOT EXIST |
| `syncedRangeEnd: syncEnd` | DOES NOT EXIST |
| (missing) | `syncedAtEpoch` (required) |

This is 5 wrong field names plus 1 missing required field plus a type mismatch (`errorCount: int` vs `errors: List<String>`).
**Fix:** Reconcile either the definition or the use case. Recommend updating the definition to match usage (use case is more descriptive):
```dart
@freezed
class SyncWearableDataOutput with _$SyncWearableDataOutput {
  const factory SyncWearableDataOutput({
    required int importedCount,
    required int skippedCount,
    required int errorCount,
    required int syncedRangeStart,    // Epoch ms
    required int syncedRangeEnd,      // Epoch ms
  }) = _SyncWearableDataOutput;
}
```

---

### ISSUE-CG-5: HipaaAuthorization entity has no repository (line 10756)
**Type:** MISSING_DEFINITION
**Severity:** HIGH
**Location:** Lines 10756-10783
**Referenced type/method:** `HipaaAuthorizationRepository`
**Problem:** `HipaaAuthorization` is a fully defined @freezed entity with `syncMetadata` (line 10775), mapped to the `hipaa_authorizations` database table (line 13271, section 13.38). However, there is NO `HipaaAuthorizationRepository` abstract class defined anywhere. Without a repository, there is no way to persist, retrieve, or manage HIPAA authorizations -- which is a HIPAA compliance requirement.
**Fix:** Add repository definition:
```dart
abstract class HipaaAuthorizationRepository implements EntityRepository<HipaaAuthorization, String> {
  Future<Result<List<HipaaAuthorization>, AppError>> getByProfile(String profileId);
  Future<Result<List<HipaaAuthorization>, AppError>> getActive(String profileId);
  Future<Result<HipaaAuthorization?, AppError>> getByGrantee(String profileId, String grantedToUserId);
  Future<Result<void, AppError>> revoke(String id, String reason);
}
```

---

### ISSUE-CG-6: UserFoodCategory entity referenced in DB table mapping but never defined (line 13261)
**Type:** MISSING_DEFINITION
**Severity:** HIGH
**Location:** Line 13261 (DB table mapping)
**Referenced type/method:** `UserFoodCategory`
**Problem:** The table-to-entity mapping at line 13261 references `UserFoodCategory` for table `user_food_categories` (table #27). However, no `@freezed class UserFoodCategory` exists anywhere in the spec. The DB alignment section 13.28 presumably documents its column mapping, but the entity class itself is never defined.
**Fix:** Add a `UserFoodCategory` entity definition in Section 10 (Entity Contracts), similar to other category entities.

---

### ISSUE-CG-7: QuietHoursQueueService missing constructor and field declarations (line 12275)
**Type:** INCOMPLETE
**Severity:** HIGH
**Location:** Lines 12275-12346
**Referenced type/method:** `QuietHoursQueueService` fields: `_queuedNotificationsTable`, `_notificationService`
**Problem:** `QuietHoursQueueService` (line 12275) uses two private fields:
- `_queuedNotificationsTable` (lines 12280, 12291, 12310) -- for database operations
- `_notificationService` (line 12306) -- to show notifications

But the class has no constructor and no field declarations. Both fields are used without being declared or injected.
**Fix:** Add constructor and fields:
```dart
class QuietHoursQueueService {
  final QueuedNotificationTable _queuedNotificationsTable;
  final NotificationService _notificationService;

  QuietHoursQueueService(this._queuedNotificationsTable, this._notificationService);
  ...
}
```
Note: `QueuedNotificationTable` (or similar data source) also needs definition.

---

### ISSUE-CG-8: 30 Use Case Input classes defined with no corresponding UseCase class (lines 2425-3593)
**Type:** INCOMPLETE
**Severity:** HIGH
**Location:** Lines 2425-3593 (various)
**Referenced type/method:** 30 `*Input` classes: `GetSleepEntriesInput`, `UpdateSleepEntryInput`, `DeleteSleepEntryInput`, `GetActivitiesInput`, `UpdateActivityInput`, `ArchiveActivityInput`, `GetActivityLogsInput`, `UpdateActivityLogInput`, `DeleteActivityLogInput`, `GetFoodItemsInput`, `SearchFoodItemsInput`, `UpdateFoodItemInput`, `ArchiveFoodItemInput`, `GetFoodLogsInput`, `UpdateFoodLogInput`, `DeleteFoodLogInput`, `GetJournalEntriesInput`, `SearchJournalEntriesInput`, `UpdateJournalEntryInput`, `DeleteJournalEntryInput`, `GetPhotoAreasInput`, `UpdatePhotoAreaInput`, `ArchivePhotoAreaInput`, `GetPhotoEntriesByAreaInput`, `GetPhotoEntriesInput`, `DeletePhotoEntryInput`, `GetFlareUpsInput`, `UpdateFlareUpInput`, `EndFlareUpInput`, `DeleteFlareUpInput`
**Problem:** These 30 input classes are defined as `@freezed` types but have NO corresponding `UseCase` class implementations. While the generic `CreateEntityUseCase`, `UpdateEntityUseCase`, and `DeleteEntityUseCase` templates exist (lines 4025-4145), there is no generic "Get" or "Search" or "Archive" use case template. The Get/Search/Archive/End operations need dedicated use case classes because:
1. Get operations need authorization checks (canRead)
2. Search operations need query sanitization
3. Archive/End operations have specific business logic (e.g., "EndFlareUp" sets endTime)

The spec defines these inputs but never shows HOW they should be used.
**Fix:** Either:
(a) Add explicit use case implementations for each input (extensive but clear), OR
(b) Add additional generic templates: `GetEntitiesUseCase<T, GetInput>`, `SearchEntitiesUseCase<T, SearchInput>`, `ArchiveEntityUseCase<T, ArchiveInput>` and document which input maps to which generic

---

### ISSUE-CG-9: deleteSupplementUseCaseProvider and deleteNotificationScheduleUseCaseProvider never registered (lines 8365, 8801)
**Type:** MISSING_DEFINITION
**Severity:** MEDIUM
**Location:** Lines 8365, 8801
**Referenced type/method:** `deleteSupplementUseCaseProvider`, `deleteNotificationScheduleUseCaseProvider`
**Problem:** The Supplement provider at line 8365 calls `ref.read(deleteSupplementUseCaseProvider)` and the Notification provider at line 8801 calls `ref.read(deleteNotificationScheduleUseCaseProvider)`. Neither provider is registered with `@riverpod` anywhere in the spec. While `DeleteEntityUseCase` exists as a generic class, there's no mapping that creates these named providers. The spec should either show the Riverpod provider registration or reference how generic use cases become named providers.
**Fix:** Add provider registrations (in a dependency injection section or inline):
```dart
@riverpod
DeleteEntityUseCase deleteSupplementUseCase(Ref ref) =>
    DeleteEntityUseCase(ref.read(supplementRepositoryProvider), ref.read(profileAuthServiceProvider));

@riverpod
DeleteEntityUseCase deleteNotificationScheduleUseCase(Ref ref) =>
    DeleteEntityUseCase(ref.read(notificationScheduleRepositoryProvider), ref.read(profileAuthServiceProvider));
```

---

### ISSUE-CG-10: DB table mapping says "AuditLog" but entity is "AuditLogEntry" (line 13273 vs 10568)
**Type:** INCOMPLETE (naming gap)
**Severity:** MEDIUM
**Location:** Line 13273 (table mapping), line 10568 (entity definition)
**Referenced type/method:** `AuditLog` vs `AuditLogEntry`
**Problem:** The database table mapping at line 13273 says table `audit_logs` maps to entity `AuditLog`. But the actual entity class is named `AuditLogEntry` (line 10568). This is confusing: either the entity should be renamed to `AuditLog` for consistency with every other table mapping, or the table mapping should reference `AuditLogEntry`.
**Fix:** Update table mapping at line 13273 to reference `AuditLogEntry`, OR rename the entity class from `AuditLogEntry` to `AuditLog`.

---

### ISSUE-CG-11: PairingSession entity referenced in DB table mapping but defined in external doc (line 13275)
**Type:** INCOMPLETE
**Severity:** MEDIUM
**Location:** Line 13275
**Referenced type/method:** `PairingSession`
**Problem:** Table #41 `pairing_sessions` references `PairingSession` entity with "35_QR_DEVICE_PAIRING.md" as its documentation location. However, since 22_API_CONTRACTS.md is the "exact interface definitions that ALL implementations MUST follow" (line 5), referencing an entity definition in another document without at least a stub definition here creates ambiguity about the canonical source. No `@freezed class PairingSession` exists in this document.
**Fix:** Add at minimum a stub definition or cross-reference note in Section 10 indicating that `PairingSession` is defined in 35_QR_DEVICE_PAIRING.md and specifying which fields it must have.

---

## Summary Table

| # | Location | Type/Method | Issue | Severity |
|---|----------|-------------|-------|----------|
| CG-1 | 1732 | Model\<T\> | Interface never defined | CRITICAL |
| CG-2 | 3608-3907 | 6 XxxModel classes | Model implementations never defined | CRITICAL |
| CG-3 | 6568/6603/6638 | WearableActivity + 3 DTOs | 4 wearable DTO types never defined | CRITICAL |
| CG-4 | 6538 vs 10200 | SyncWearableDataOutput | 5 wrong field names + type mismatch | CRITICAL |
| CG-5 | 10756 | HipaaAuthorizationRepository | Entity has no repository (HIPAA concern) | HIGH |
| CG-6 | 13261 | UserFoodCategory | DB table mapped but entity never defined | HIGH |
| CG-7 | 12275 | QuietHoursQueueService | Missing constructor and 2 field declarations | HIGH |
| CG-8 | 2425-3593 | 30 Input classes | Defined but no UseCase consumes them | HIGH |
| CG-9 | 8365/8801 | 2 provider registrations | Providers referenced but never registered | MEDIUM |
| CG-10 | 13273 vs 10568 | AuditLog vs AuditLogEntry | DB mapping name doesn't match entity name | MEDIUM |
| CG-11 | 13275 | PairingSession | DB table mapped but entity defined in external doc only | MEDIUM |

---

## Impact Assessment

**CG-1 + CG-2 together** block the entire data layer implementation. Without `Model<T>` and the 6 model classes, none of the 6 `LocalDataSource` implementations can compile.

**CG-3 + CG-4 together** block the wearable data import feature. Without the DTO types and correct output fields, `SyncWearableDataUseCase` cannot be implemented.

**CG-5** is a HIPAA compliance concern -- the authorization entity exists but cannot be persisted without a repository.

**CG-8** represents the largest single gap by count (30 classes). While the spec provides generic use case templates, the absence of explicit Get/Search/Archive use cases means implementers must guess the pattern for 30 different operations.

---

## Cross-Team Coordination Notes

- **type-safety**: CG-1 (Model\<T\> interface) and CG-3 (WearableActivity etc.) are type definition gaps that affect compilability
- **cross-references**: CG-4 (SyncWearableDataOutput field mismatch) and CG-10 (AuditLog naming) are cross-reference discrepancies
- **naming-consistency**: CG-10 (AuditLog vs AuditLogEntry) is a naming consistency issue

---

## Relationship to Existing Fix Plan

- CG-1, CG-2, CG-3, CG-4, CG-5, CG-6, CG-7, CG-8, CG-9, CG-10, CG-11 are ALL NEW findings
- None overlap with the previously reported 69+ issues from passes 2-7
- CG-3 is related to (but distinct from) pass 3 CRITICAL-4 (SyncWearableDataInput missing fields) -- that was about input fields, this is about DTO types
- CG-4 is related to (but distinct from) pass 3 CRITICAL-4 -- that was about input, this is about output
