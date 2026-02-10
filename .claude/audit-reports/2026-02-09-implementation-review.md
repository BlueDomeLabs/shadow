# Implementation Review Report - 2026-02-09

## Review Plan (Multi-Pass Serial Approach)

| Pass | Scope | Status |
|------|-------|--------|
| 1 | Entity field-by-field comparison (15 entities + SyncMetadata) | COMPLETE |
| 2 | Repository method signatures (15 repositories) | COMPLETE |
| 3 | Use case input classes + logic (100+ files) | PENDING |
| 4 | DAO/Table column alignment (15 DAOs, 14 tables) | PENDING |
| 5 | Enum values alignment | COMPLETE |
| 6 | Core types (SyncMetadata, AppError, Result, base use cases) | PENDING |

## Implementation Inventory

### Entities (16 files)
- activity.dart, activity_log.dart, condition.dart, condition_log.dart
- flare_up.dart, fluids_entry.dart, food_item.dart, food_log.dart
- intake_log.dart, journal_entry.dart, photo_area.dart, photo_entry.dart
- sleep_entry.dart, supplement.dart, sync_metadata.dart

### Repositories (15 abstract + 14 impl)
- supplement, fluids_entry, condition, condition_log, activity, activity_log
- flare_up, food_item, food_log, intake_log, journal_entry
- photo_area, photo_entry, sleep_entry + entity_repository (base)

### Use Cases (~100+ files across 14 subdirectories)
- supplements, fluids_entries, conditions, condition_logs
- activities, activity_logs, flare_ups, food_items, food_logs
- intake_logs, journal_entries, photo_areas, photo_entries, sleep_entries

### DAOs (15) + Tables (14)
- One DAO and one table per entity

---

## Pass 1: Entity Field-by-Field Comparison

### Method
For each entity implementation file:
1. Read the implementation file
2. Find the spec definition in 22_API_CONTRACTS.md
3. Compare field-by-field: name, type, required/optional, default value
4. Log every deviation

---

### Pass 1 Results Summary

| Entity | Fields Match? | Annotation | implements Syncable | Extra Getters | Severity |
|--------|:---:|:---:|:---:|:---:|:---:|
| Supplement | YES | S-1 | N/A (neither) | 0 | LOW |
| FluidsEntry | YES | S-1 | N/A (neither) | 0 | LOW |
| Condition | YES | S-1 | N/A (neither) | 0 | LOW |
| ConditionLog | YES | S-1 | N/A (neither) | 0 | LOW |
| Activity | YES | S-1 | MISSING (spec has it) | +1 (isActive) | MEDIUM |
| **ActivityLog** | **NO** | S-1 | MISSING (spec has it) | +2 | **HIGH** |
| FoodItem | YES | S-1 | N/A (neither) | +1 (isActive) | LOW |
| FoodLog | YES | S-1 | N/A (neither) | 0 | LOW |
| IntakeLog | YES | S-1 | N/A (neither) | 0 | LOW |
| JournalEntry | YES | S-1 | MISSING (spec has it) | +3 | MEDIUM |
| PhotoArea | YES | S-1 | MISSING (spec has it) | 0 | MEDIUM |
| PhotoEntry | YES | S-1 | MISSING (spec has it) | +1 (isPendingUpload) | MEDIUM |
| SleepEntry | YES | S-1 | MISSING (spec has it) | 0 | MEDIUM |
| FlareUp | YES | S-1 | MISSING (spec has it) | 0 | MEDIUM |
| SyncMetadata | YES | MATCH (@freezed) | N/A | 0 | NONE |

**Totals: 1 field deviation (HIGH), 2 systematic deviations, 7 missing Syncable, 7 extra computed getters**

---

### Systematic Deviations

#### S-1: @Freezed Annotation Style (ALL entities except SyncMetadata)

**Spec:**
```dart
@freezed
class Entity with _$Entity {
  const factory Entity({...}) = _Entity;
```

**Implementation:**
```dart
@Freezed(toJson: true, fromJson: true)
class Entity with _$Entity {
  @JsonSerializable(explicitToJson: true)
  const factory Entity({...}) = _Entity;
```

**Affected entities:** ALL 14 (Supplement, FluidsEntry, Condition, ConditionLog, Activity, ActivityLog, FlareUp, FoodItem, FoodLog, IntakeLog, JournalEntry, PhotoArea, PhotoEntry, SleepEntry)

**NOT affected:** SyncMetadata (uses plain `@freezed` — matches spec)

**Assessment:** The `@Freezed(toJson: true, fromJson: true)` + `@JsonSerializable(explicitToJson: true)` pattern is a common Freezed best practice for proper JSON serialization of nested objects. The spec's `@freezed` is the shorthand. Both generate `fromJson`/`toJson` since all entities have `factory Entity.fromJson(...)`.

**Verdict:** SPEC SHOULD BE UPDATED — The implementation pattern is more explicit and correct for nested objects (SyncMetadata, List<SupplementIngredient>, etc.). The spec's `@freezed` relies on implicit behavior.

---

#### S-2: Missing `implements Syncable` (7 entities)

**Spec declares `implements Syncable` on:**
- Activity (line 12139)
- ActivityLog (line 12175)
- FlareUp (line 12431)
- JournalEntry (line 12298)
- PhotoArea (line 12346)
- PhotoEntry (line 12383)
- SleepEntry (line 12243)

**Spec does NOT declare `implements Syncable` on:**
- Supplement (line 7502)
- FluidsEntry (line 7625)
- Condition (line 11820)
- ConditionLog (line 11870)
- FoodItem (line 12013)
- FoodLog (line 12089)
- IntakeLog (line 11946)

**Implementation:** NONE of the 14 entities implement `Syncable`.

**The Syncable interface IS defined** in `sync_metadata.dart` (both spec and impl):
```dart
abstract interface class Syncable {
  SyncMetadata get syncMetadata;
}
```

**Assessment:** ALL entities have `required SyncMetadata syncMetadata` so they structurally conform. The `implements Syncable` provides compile-time guarantees. The spec is inconsistent — some entities have it, some don't. All should have it since ALL have syncMetadata.

**Verdict:** BOTH NEED UPDATE — Spec should add `implements Syncable` to ALL entities. Implementation should add `implements Syncable` to ALL entities.

---

### Per-Entity Detailed Comparison

#### 1. Supplement
- **Spec:** 22_API_CONTRACTS.md line 7502
- **Impl:** lib/domain/entities/supplement.dart
- **Fields:** ALL MATCH (16 fields)
  - id, clientId, profileId, name, form, customForm?, dosageQuantity, dosageUnit, brand(@Default('')), notes(@Default('')), ingredients(@Default([])), schedules(@Default([])), startDate?, endDate?, isArchived(@Default(false)), syncMetadata
- **Computed getters:** ALL MATCH — hasSchedules, isActive, isWithinDateRange, displayDosage
- **Value objects:** SupplementIngredient, SupplementSchedule — both match spec
- **Deviations:** S-1 only

#### 2. FluidsEntry
- **Spec:** 22_API_CONTRACTS.md line 7625
- **Impl:** lib/domain/entities/fluids_entry.dart
- **Fields:** ALL MATCH (22 fields)
  - id, clientId, profileId, entryDate, waterIntakeMl?, waterIntakeNotes?, bowelCondition?, bowelSize?, bowelPhotoPath?, urineCondition?, urineSize?, urinePhotoPath?, menstruationFlow?, basalBodyTemperature?, bbtRecordedTime?, otherFluidName?, otherFluidAmount?, otherFluidNotes?, importSource?, importExternalId?, cloudStorageUrl?, fileHash?, fileSizeBytes?, isFileUploaded(@Default(false)), notes(@Default('')), photoIds(@Default([])), syncMetadata
- **Computed getters:** ALL MATCH — hasWaterData, hasBowelData, hasUrineData, hasMenstruationData, hasBBTData, hasOtherFluidData, bbtCelsius
- **Deviations:** S-1 only

#### 3. Condition
- **Spec:** 22_API_CONTRACTS.md line 11820
- **Impl:** lib/domain/entities/condition.dart
- **Fields:** ALL MATCH (17 fields)
  - id, clientId, profileId, name, category, bodyLocations, triggers(@Default([])), description?, baselinePhotoPath?, startTimeframe, endDate?, status(@Default(ConditionStatus.active)), isArchived(@Default(false)), activityId?, cloudStorageUrl?, fileHash?, fileSizeBytes?, isFileUploaded(@Default(false)), syncMetadata
- **Computed getters:** ALL MATCH — hasBaselinePhoto, isResolved, isActive
- **Deviations:** S-1 only

#### 4. ConditionLog
- **Spec:** 22_API_CONTRACTS.md line 11870
- **Impl:** lib/domain/entities/condition_log.dart
- **Fields:** ALL MATCH (15 fields)
  - id, clientId, profileId, conditionId, timestamp, severity, notes?, isFlare(@Default(false)), flarePhotoIds(@Default([])), photoPath?, activityId?, triggers?, cloudStorageUrl?, fileHash?, fileSizeBytes?, isFileUploaded(@Default(false)), syncMetadata
- **Computed getters:** ALL MATCH — hasPhoto, triggerList
- **Deviations:** S-1 only

#### 5. Activity
- **Spec:** 22_API_CONTRACTS.md line 12139
- **Impl:** lib/domain/entities/activity.dart
- **Fields:** ALL MATCH (10 fields)
  - id, clientId, profileId, name, description?, location?, triggers?, durationMinutes, isArchived(@Default(false)), syncMetadata
- **Computed getters:** Spec has NONE. Impl has `isActive` (extra).
- **Deviations:** S-1, S-2 (missing `implements Syncable`), extra getter `isActive`

#### 6. ActivityLog — HIGH SEVERITY
- **Spec:** 22_API_CONTRACTS.md line 12175
- **Impl:** lib/domain/entities/activity_log.dart
- **Field deviations:**

| Field | Spec | Implementation | Deviation |
|-------|------|----------------|-----------|
| activityIds | `required List<String> activityIds` | `@Default([]) List<String> activityIds` | required → @Default([]) |
| adHocActivities | `required List<String> adHocActivities` | `@Default([]) List<String> adHocActivities` | required → @Default([]) |

**Impact:** Callers can omit activityIds and adHocActivities in implementation (defaults to empty list), but spec requires them to be explicitly provided. This changes the API contract — a log entry could be created with neither activities nor ad-hoc items without compiler warning.

- **Other fields:** ALL MATCH (9 remaining fields)
  - id, clientId, profileId, timestamp, duration?, notes?, importSource?, importExternalId?, syncMetadata
- **Computed getters:** Spec has NONE. Impl has `hasActivities`, `isImported` (extra).
- **Deviations:** S-1, S-2, 2 field modifier changes (required→@Default([])), 2 extra getters

#### 7. FoodItem
- **Spec:** 22_API_CONTRACTS.md line 12013
- **Impl:** lib/domain/entities/food_item.dart
- **Fields:** ALL MATCH (13 fields)
  - id, clientId, profileId, name, type(@Default(FoodItemType.simple)), simpleItemIds(@Default([])), isUserCreated(@Default(true)), isArchived(@Default(false)), servingSize?, calories?, carbsGrams?, fatGrams?, proteinGrams?, fiberGrams?, sugarGrams?, syncMetadata
- **Computed getters:** Spec has `isComplex`, `isSimple`, `hasNutritionalInfo`. Impl has same + extra `isActive`.
- **Deviations:** S-1, extra getter `isActive`

#### 8. FoodLog
- **Spec:** 22_API_CONTRACTS.md line 12089
- **Impl:** lib/domain/entities/food_log.dart
- **Fields:** ALL MATCH (8 fields)
  - id, clientId, profileId, timestamp, mealType?, foodItemIds(@Default([])), adHocItems(@Default([])), notes?, syncMetadata
- **Computed getters:** ALL MATCH — hasItems, totalItems
- **Deviations:** S-1 only

#### 9. IntakeLog
- **Spec:** 22_API_CONTRACTS.md line 11946
- **Impl:** lib/domain/entities/intake_log.dart
- **Fields:** ALL MATCH (10 fields)
  - id, clientId, profileId, supplementId, scheduledTime, actualTime?, status(@Default(IntakeLogStatus.pending)), reason?, note?, snoozeDurationMinutes?, syncMetadata
- **Computed getters:** ALL MATCH — isTaken, isPending, isSkipped, isMissed, isSnoozed, delayFromScheduled
- **Deviations:** S-1 only

#### 10. JournalEntry
- **Spec:** 22_API_CONTRACTS.md line 12298
- **Impl:** lib/domain/entities/journal_entry.dart
- **Fields:** ALL MATCH (9 fields)
  - id, clientId, profileId, timestamp, content, title?, mood?, tags?, audioUrl?, syncMetadata
- **Computed getters:** Spec has NONE. Impl has `hasMood`, `hasAudio`, `hasTags` (3 extra).
- **Deviations:** S-1, S-2 (missing `implements Syncable`), 3 extra getters

#### 11. PhotoArea
- **Spec:** 22_API_CONTRACTS.md line 12346
- **Impl:** lib/domain/entities/photo_area.dart
- **Fields:** ALL MATCH (9 fields)
  - id, clientId, profileId, name, description?, consistencyNotes?, sortOrder(@Default(0)), isArchived(@Default(false)), syncMetadata
- **Computed getters:** Neither has any.
- **Deviations:** S-1, S-2 (missing `implements Syncable`)

#### 12. PhotoEntry
- **Spec:** 22_API_CONTRACTS.md line 12383
- **Impl:** lib/domain/entities/photo_entry.dart
- **Fields:** ALL MATCH (11 fields)
  - id, clientId, profileId, photoAreaId, timestamp, filePath, notes?, cloudStorageUrl?, fileHash?, fileSizeBytes?, isFileUploaded(@Default(false)), syncMetadata
- **Computed getters:** Spec has NONE. Impl has `isPendingUpload` (extra).
- **Deviations:** S-1, S-2 (missing `implements Syncable`), extra getter `isPendingUpload`

#### 13. SleepEntry
- **Spec:** 22_API_CONTRACTS.md line 12243
- **Impl:** lib/domain/entities/sleep_entry.dart
- **Fields:** ALL MATCH (13 fields)
  - id, clientId, profileId, bedTime, wakeTime?, deepSleepMinutes(@Default(0)), lightSleepMinutes(@Default(0)), restlessSleepMinutes(@Default(0)), dreamType(@Default(DreamType.noDreams)), wakingFeeling(@Default(WakingFeeling.neutral)), notes?, importSource?, importExternalId?, syncMetadata
- **Computed getters:** ALL MATCH — totalSleepMinutes
- **Deviations:** S-1, S-2 (missing `implements Syncable`)

#### 14. FlareUp
- **Spec:** 22_API_CONTRACTS.md line 12431
- **Impl:** lib/domain/entities/flare_up.dart
- **Fields:** ALL MATCH (12 fields)
  - id, clientId, profileId, conditionId, startDate, endDate?, severity, notes?, triggers, activityId?, photoPath?, syncMetadata
- **Computed getters:** ALL MATCH — durationMs, isOngoing
- **Deviations:** S-1, S-2 (missing `implements Syncable`)

#### 15. SyncMetadata
- **Spec:** 22_API_CONTRACTS.md line 1037
- **Impl:** lib/domain/entities/sync_metadata.dart
- **Annotation:** `@freezed` — MATCHES spec
- **Fields:** ALL MATCH (9 fields with @JsonKey annotations)
  - syncCreatedAt, syncUpdatedAt, syncDeletedAt?, syncLastSyncedAt?, syncStatus(@Default(SyncStatus.pending)), syncVersion(@Default(1)), syncDeviceId, syncIsDirty(@Default(true)), conflictData?
- **Methods:** ALL MATCH — create(), markModified(), markSynced(), markDeleted(), isDeleted, empty(), needsInitialization
- **Minor difference:** `empty()` uses arrow syntax with `const` in impl vs body syntax in spec. Functionally identical.
- **SyncStatus enum:** MATCHES (5 values: pending(0), synced(1), modified(2), conflict(3), deleted(4))
- **Syncable interface:** MATCHES (defined identically in both)
- **Deviations:** NONE (annotation, fields, methods all match)

---

### Pass 1 Action Items

| ID | Severity | Issue | Recommended Action |
|----|----------|-------|-------------------|
| P1-1 | HIGH | ActivityLog: `activityIds` and `adHocActivities` are `required` in spec but `@Default([])` in impl | **Decide:** Update spec to match impl (Default is reasonable — allows empty logs) OR update impl to match spec |
| P1-2 | MEDIUM | 7 entities missing `implements Syncable` in impl (Activity, ActivityLog, FlareUp, JournalEntry, PhotoArea, PhotoEntry, SleepEntry) | Add `implements Syncable` to ALL entity implementations |
| P1-3 | MEDIUM | Spec inconsistency: only 7 of 14 entities declare `implements Syncable` | Add `implements Syncable` to ALL entities in spec (all have syncMetadata) |
| P1-4 | LOW | 14 entities use `@Freezed(toJson:true, fromJson:true)` + `@JsonSerializable(explicitToJson:true)` but spec uses `@freezed` | Update spec to match impl — impl pattern is more explicit and correct for nested objects |
| P1-5 | LOW | 7 extra computed getters in impl not in spec: Activity.isActive, ActivityLog.hasActivities, ActivityLog.isImported, FoodItem.isActive, JournalEntry.hasMood/hasAudio/hasTags, PhotoEntry.isPendingUpload | Update spec to include these getters — they are useful convenience methods |

---

### Pass 1 Verdict

**Entity fields are highly aligned.** Only 1 actual field deviation found (ActivityLog required→@Default). All other 14 entities have exact field matches. The main gaps are:
1. Annotation style (systematic, low risk)
2. Missing `implements Syncable` (medium — should be added for type safety)
3. Extra computed getters (low — convenience methods, no contract violation)

**Ready for Pass 2: Repository method signatures.**

---

## Pass 2: Repository Method Signatures

### Method
For each repository interface:
1. Read the implementation file
2. Find the spec definition in 22_API_CONTRACTS.md
3. Compare method-by-method: name, parameters, return type
4. Log every deviation

---

### Pass 2 Results Summary

| Repository | Methods Match? | Extra Methods | Missing Methods | Return Type Issues | Severity |
|-----------|:---:|:---:|:---:|:---:|:---:|
| EntityRepository (base) | YES | 0 | 0 | 0 | NONE |
| SupplementRepository | YES | 0 | 0 | 0 | NONE |
| FluidsEntryRepository | YES | 0 | 0 | 0 | NONE |
| ConditionRepository | YES | 0 | 0 | 0 | NONE |
| **ConditionLogRepository** | **NO** | 0 | 0 | 0 | **HIGH** |
| **ActivityRepository** | **NO** | +2 | 0 | 0 | **MEDIUM** |
| ActivityLogRepository | YES | 0 | 0 | 0 | NONE |
| **FlareUpRepository** | **NO** | +1 | -1 | 0 | **HIGH** |
| FoodItemRepository | YES | 0 | 0 | 0 | NONE |
| FoodLogRepository | YES | 0 | 0 | 0 | NONE |
| **IntakeLogRepository** | **NO** | 0 | 0 | 3 | **HIGH** |
| JournalEntryRepository | YES | 0 | 0 | 0 | NONE |
| **PhotoAreaRepository** | **NO** | +1 | 0 | 0 | **LOW** |
| PhotoEntryRepository | YES | 0 | 0 | 0 | NONE |
| SleepEntryRepository | YES | 0 | 0 | 0 | NONE |

**Totals: 5 repositories with deviations (3 HIGH, 1 MEDIUM, 1 LOW)**

---

### Per-Repository Detailed Comparison

#### 1. EntityRepository (base)
- **Spec:** 22_API_CONTRACTS.md line 1699
- **Impl:** lib/domain/repositories/entity_repository.dart
- **Methods (8):** getAll, getById, create, update, delete, hardDelete, getModifiedSince, getPendingSync
- **Alias:** `BaseRepositoryContract<T, ID> = EntityRepository<T, ID>` — both have it
- **Deviations:** NONE

#### 2. SupplementRepository
- **Spec:** 22_API_CONTRACTS.md line 1988
- **Impl:** lib/domain/repositories/supplement_repository.dart
- **Methods (3):** getByProfile, getDueAt, search — ALL MATCH
- **Deviations:** NONE

#### 3. FluidsEntryRepository
- **Spec:** 22_API_CONTRACTS.md line 2017
- **Impl:** lib/domain/repositories/fluids_entry_repository.dart
- **Methods (4):** getByDateRange, getBBTEntries, getMenstruationEntries, getTodayEntry — ALL MATCH
- **Deviations:** NONE

#### 4. ConditionRepository
- **Spec:** 22_API_CONTRACTS.md line 11854
- **Impl:** lib/domain/repositories/condition_repository.dart
- **Methods (4):** getByProfile, getActive, archive, resolve — ALL MATCH
- **Deviations:** NONE

#### 5. ConditionLogRepository — HIGH SEVERITY
- **Spec:** 22_API_CONTRACTS.md line 11901
- **Impl:** lib/domain/repositories/condition_log_repository.dart
- **Parameter deviation:**

| Method | Spec Parameters | Impl Parameters | Deviation |
|--------|----------------|-----------------|-----------|
| getByCondition | `String conditionId, {int? startDate, int? endDate, int? limit, int? offset}` | `String conditionId, {int? limit, int? offset}` | **Missing `startDate` and `endDate`** |

**Impact:** Callers cannot filter condition logs by date range when querying by condition. The `getByDateRange` method exists separately but requires a profileId, not a conditionId.

- **Other methods:** getByProfile, getByDateRange, getFlares — ALL MATCH
- **Deviations:** 1 method missing 2 parameters

#### 6. ActivityRepository — MEDIUM SEVERITY
- **Spec:** 22_API_CONTRACTS.md line 12158
- **Impl:** lib/domain/repositories/activity_repository.dart
- **Spec methods (2):** getByProfile, getActive
- **Impl methods (4):** getByProfile, getActive, **archive**, **unarchive**

| Method | In Spec? | In Impl? | Notes |
|--------|:---:|:---:|-------|
| getByProfile | YES | YES | Match |
| getActive | YES | YES | Match |
| archive | NO | YES | Extra — reasonable for archivable entity |
| unarchive | NO | YES | Extra — reasonable companion to archive |

**Assessment:** The extra `archive`/`unarchive` methods are reasonable for an entity with `isArchived` field. ConditionRepository has `archive` in spec. The Activity spec should include these.

- **Deviations:** 2 extra methods

#### 7. ActivityLogRepository
- **Spec:** 22_API_CONTRACTS.md line 12196
- **Impl:** lib/domain/repositories/activity_log_repository.dart
- **Methods (3):** getByProfile, getForDate, getByExternalId — ALL MATCH
- **Deviations:** NONE

#### 8. FlareUpRepository — HIGH SEVERITY
- **Spec:** 22_API_CONTRACTS.md line 12459
- **Impl:** lib/domain/repositories/flare_up_repository.dart

| Method | In Spec? | In Impl? | Notes |
|--------|:---:|:---:|-------|
| getByCondition | YES | YES | Match |
| getByProfile | YES | YES | Match |
| getTriggerCounts | YES | **NO** | **MISSING** — returns `Map<String, int>` of trigger→count |
| getOngoing | YES | YES | Match |
| endFlareUp | **NO** | YES | Extra — returns `Result<FlareUp, AppError>` |

**Impact:** `getTriggerCounts` is needed for the intelligence/analytics layer to analyze common triggers. `endFlareUp` is a convenience method that could be achieved via `update()`.

- **Deviations:** 1 missing method, 1 extra method

#### 9. FoodItemRepository
- **Spec:** 22_API_CONTRACTS.md line 12046
- **Impl:** lib/domain/repositories/food_item_repository.dart
- **Methods (4):** getByProfile, search, archive, searchExcludingCategories — ALL MATCH
- **Deviations:** NONE

#### 10. FoodLogRepository
- **Spec:** 22_API_CONTRACTS.md line 12111
- **Impl:** lib/domain/repositories/food_log_repository.dart
- **Methods (3):** getByProfile, getForDate, getByDateRange — ALL MATCH
- **Deviations:** NONE

#### 11. IntakeLogRepository — HIGH SEVERITY
- **Spec:** 22_API_CONTRACTS.md line 11977
- **Impl:** lib/domain/repositories/intake_log_repository.dart
- **Return type deviations:**

| Method | Spec Return Type | Impl Return Type | Deviation |
|--------|-----------------|------------------|-----------|
| markTaken | `Result<IntakeLog, AppError>` | `Result<void, AppError>` | **IntakeLog → void** |
| markSkipped | `Result<IntakeLog, AppError>` | `Result<void, AppError>` | **IntakeLog → void** |
| markSnoozed | `Result<IntakeLog, AppError>` | `Result<void, AppError>` | **IntakeLog → void** |

**Impact:** Callers cannot get the updated IntakeLog back after marking it. They would need a separate `getById()` call to refresh state. This affects UI patterns that update local state from the returned entity.

- **Other methods:** getByProfile, getBySupplement, getPendingForDate — ALL MATCH
- **Deviations:** 3 return type mismatches

#### 12. JournalEntryRepository
- **Spec:** 22_API_CONTRACTS.md line 12318
- **Impl:** lib/domain/repositories/journal_entry_repository.dart
- **Methods (3):** getByProfile, search, getMoodDistribution — ALL MATCH
- **Deviations:** NONE

#### 13. PhotoAreaRepository — LOW SEVERITY
- **Spec:** 22_API_CONTRACTS.md line 12365
- **Impl:** lib/domain/repositories/photo_area_repository.dart
- **Spec methods (2):** getByProfile, reorder
- **Impl methods (3):** getByProfile, reorder, **archive**

**Assessment:** Extra `archive` method is reasonable for an entity with `isArchived` field. Similar to Activity/Condition repos.

- **Deviations:** 1 extra method

#### 14. PhotoEntryRepository
- **Spec:** 22_API_CONTRACTS.md line 12406
- **Impl:** lib/domain/repositories/photo_entry_repository.dart
- **Methods (3):** getByArea, getByProfile, getPendingUpload — ALL MATCH
- **Deviations:** NONE

#### 15. SleepEntryRepository
- **Spec:** 22_API_CONTRACTS.md line 12272
- **Impl:** lib/domain/repositories/sleep_entry_repository.dart
- **Methods (3):** getByProfile, getForNight, getAverages — ALL MATCH
- **Deviations:** NONE

---

### Pass 2 Action Items

| ID | Severity | Issue | Recommended Action |
|----|----------|-------|-------------------|
| P2-1 | HIGH | ConditionLogRepository.getByCondition missing `startDate`/`endDate` params | Add params to impl to match spec |
| P2-2 | HIGH | FlareUpRepository missing `getTriggerCounts` method | Add method to impl |
| P2-3 | HIGH | IntakeLogRepository: markTaken/markSkipped/markSnoozed return `void` instead of `IntakeLog` | **Decide:** Update impl to return IntakeLog (better for UI state) OR update spec to return void |
| P2-4 | MEDIUM | ActivityRepository has extra archive/unarchive methods not in spec | Update spec to include these (entity has isArchived field) |
| P2-5 | LOW | FlareUpRepository has extra `endFlareUp` method not in spec | Update spec to include (useful convenience method) |
| P2-6 | LOW | PhotoAreaRepository has extra `archive` method not in spec | Update spec to include (entity has isArchived field) |

---

### Pass 2 Verdict

**10 of 15 repositories are exact matches.** 5 repositories have deviations:
- 3 HIGH issues: missing parameters, missing method, return type mismatches
- 1 MEDIUM: extra methods (reasonable additions)
- 1 LOW: extra method (reasonable addition)

The most impactful is P2-3 (IntakeLog return types) as it affects the UI update pattern. The extra methods (P2-4/5/6) are all reasonable additions that should be added to the spec.

**Ready for Pass 3: Use case input classes + logic.**

---

## Pass 5: Enum Values Alignment

### Method
For each enum in implementation:
1. Find the spec definition in 22_API_CONTRACTS.md
2. Compare: values, int assignments, fromValue(), extra methods
3. Log every deviation

---

### Pass 5 Results Summary

**28 enums compared (26 in health_enums.dart + 2 elsewhere)**

| Status | Count | Details |
|--------|:---:|---------|
| EXACT MATCH | 24 | All values, int assignments, methods match |
| MISSING INT VALUES | 4 | DietPresetType, InsightCategory, RecoveryAction, AccessLevel |
| NOT YET IMPLEMENTED | ~17 | Spec enums for unbuilt subsystems (expected) |

---

### Enums with EXACT MATCH (24)

All values, int assignments, `fromValue()`, and methods match between spec and impl:

| Enum | Values | Int Range | Extra Methods |
|------|:---:|:---:|-------|
| BowelCondition | 7 | 0-6 | fromValue |
| UrineCondition | 8 | 0-7 | fromValue |
| MovementSize | 5 | 0-4 | fromValue |
| MenstruationFlow | 5 | 0-4 | fromValue |
| SleepQuality | 5 | 1-5 | fromValue |
| ActivityIntensity | 3 | 0-2 | fromValue |
| ConditionSeverity | 5 | 0-4 | fromValue, toStorageScale, fromStorageScale |
| MoodLevel | 5 | 1-5 | fromValue |
| DietRuleType | 22 | 0-21 | fromValue |
| PatternType | 5 | 0-4 | fromValue |
| AlertPriority | 4 | 0-3 | fromValue |
| WearablePlatform | 6 | 0-5 | — |
| NotificationType | 25 | 0-24 | fromValue, allowsSnooze, defaultSnoozeMinutes |
| SupplementForm | 7 | 0-6 | fromValue |
| DosageUnit | 9 | 0-8 | fromValue + abbreviation field |
| SupplementTimingType | 4 | 0-3 | fromValue |
| SupplementFrequencyType | 3 | 0-2 | fromValue |
| SupplementAnchorEvent | 5 | 0-4 | fromValue |
| IntakeLogStatus | 5 | 0-4 | fromValue |
| ConditionStatus | 2 | 0-1 | fromValue |
| MealType | 4 | 0-3 | fromValue |
| FoodItemType | 2 | 0-1 | fromValue |
| DreamType | 4 | 0-3 | fromValue |
| WakingFeeling | 3 | 0-2 | fromValue |

Also verified: **SyncStatus** (in sync_metadata.dart) — 5 values (0-4), fromValue — MATCH

---

### Enums MISSING Int Values (4) — HIGH SEVERITY

Per Rule 9.1.1 in 02_CODING_STANDARDS.md, ALL enums stored in the database MUST have explicit int values.

| Enum | Location | Spec Line | Spec Has Int Values? | Impl Has Int Values? |
|------|----------|:---------:|:---:|:---:|
| DietPresetType | health_enums.dart:200 | 1378 | YES (0-19) | **NO** |
| InsightCategory | health_enums.dart:223 | 1404 | YES (0-8) | **NO** |
| RecoveryAction | app_error.dart:5 | 64 | YES (0-7) | **NO** |
| AccessLevel | profile_authorization_service.dart:43 | 1645 | YES (0-2) | **NO** |

**Impact:** These enums cannot be reliably stored in the database as integers. Any database reads of these values would fail to deserialize correctly.

---

### Extra Methods in Impl (1) — LOW

| Enum | Impl Extra | Notes |
|------|-----------|-------|
| WearablePlatform | `fromValue()` method | Spec has no fromValue(). Impl adds it. Useful convenience. |

---

### Spec Enums Not Yet Implemented (~17) — Expected

These enums are defined in the spec but belong to subsystems not yet built:

| Enum | Spec Line | Subsystem |
|------|:---------:|-----------|
| DocumentType | 1611 | Medical documents |
| DataScope | 1628 | HIPAA authorization |
| AuthorizationDuration | 1655 | HIPAA authorization |
| WriteOperation | 1675 | Authorization |
| TrendGranularity | 5025 | Intelligence/trends |
| TrendDirection | 5060 | Intelligence/trends |
| ConflictResolution | 7453 | Sync system |
| RuleSeverity | 9810 | Diet rules |
| FoodCategory | 9819 | Diet system |
| CorrelationType | 10151 | ML correlations |
| PredictionType | 10237 | ML predictions |
| RateLimitOperation | 11239 | Rate limiting |
| AuditEventType | 11307 | Audit logging |
| ProfileAccessAction | 11580 | Profile auth |
| BiologicalSex | 11733 | Profile entity |
| ProfileDietType | 11747 | Profile entity |
| AuthProvider | 12515 | Authentication |
| DeviceType | 12565 | Device management |
| MLModelType | 12670 | ML models |

**Assessment:** These are NOT deviations — they belong to subsystems (intelligence, ML, FHIR, advanced auth, wearable) that are not yet in the implementation phase. They will be implemented when their respective subsystems are built.

---

### Pass 5 Action Items

| ID | Severity | Issue | Recommended Action |
|----|----------|-------|-------------------|
| P5-1 | HIGH | DietPresetType missing int values (spec has 0-19) | Add int values to match spec |
| P5-2 | HIGH | InsightCategory missing int values (spec has 0-8) | Add int values to match spec |
| P5-3 | HIGH | RecoveryAction missing int values (spec has 0-7) | Add int values to match spec |
| P5-4 | HIGH | AccessLevel missing int values (spec has 0-2) | Add int values to match spec |
| P5-5 | LOW | WearablePlatform has extra `fromValue()` in impl | Update spec to include |

---

### Pass 5 Verdict

**24 of 28 implemented enums are exact matches.** 4 enums are missing their int values — a clear pattern violation of Rule 9.1.1. These are straightforward fixes (add int values + constructor). ~17 spec enums are not yet implemented but belong to unbuilt subsystems.

**Ready for Pass 3/4/6 (remaining passes).**
