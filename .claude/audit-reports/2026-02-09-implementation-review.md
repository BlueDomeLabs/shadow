# Implementation Review Report - 2026-02-09

## Review Plan (Multi-Pass Serial Approach)

| Pass | Scope | Status |
|------|-------|--------|
| 1 | Entity field-by-field comparison (15 entities + SyncMetadata) | COMPLETE |
| 2 | Repository method signatures (15 repositories) | COMPLETE |
| 3 | Use case input classes + logic (~70 files) | COMPLETE |
| 4 | DAO/Table column alignment (14 tables) | COMPLETE |
| 5 | Enum values alignment | COMPLETE |
| 6 | Core types (SyncMetadata, AppError, Result, base use cases) | COMPLETE |
| 7 | Implementation Gap Analysis (what's missing) | COMPLETE |

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

---

## Pass 6: Core Types (AppError, Result, Base Use Cases, SyncMetadata)

### Method
For each core type:
1. Read the implementation file
2. Find the spec definition in 22_API_CONTRACTS.md
3. Compare class structure, codes, factories, methods, parameters
4. Log every deviation

---

### Pass 6 Results Summary

| Core Type | Match? | Issues | Severity |
|-----------|:---:|:---:|:---:|
| Result<T, E> | EXACT MATCH | 0 | NONE |
| UseCase<Input, Output> | EXACT MATCH | 0 | NONE |
| UseCaseNoInput<Output> | EXACT MATCH | 0 | NONE |
| UseCaseNoOutput<Input> | EXACT MATCH | 0 | NONE |
| UseCaseWithInput<Output, Input> | EXACT MATCH | 0 | NONE |
| AppError (base sealed class) | EXACT MATCH | 0 | NONE |
| **DatabaseError** | **NO** | 3 | **HIGH** |
| AuthError | MATCH | 0 | NONE |
| NetworkError | NEAR MATCH | 2 | LOW |
| ValidationError | EXACT MATCH | 0 | NONE |
| SyncError | EXACT MATCH | 0 | NONE |
| WearableError | EXACT MATCH | 0 | NONE |
| DietError | NEAR MATCH | 1 | LOW |
| IntelligenceError | EXACT MATCH | 0 | NONE |
| BusinessError | EXACT MATCH | 0 | NONE |
| NotificationError | EXACT MATCH | 0 | NONE |
| SyncMetadata | EXACT MATCH | 0 | NONE |
| Syncable interface | EXACT MATCH | 0 | NONE |
| SyncStatus enum | EXACT MATCH | 0 | NONE |
| RecoveryAction enum | NO (int values) | 1 | HIGH (already P5-3) |

**Totals: 16 exact matches, 1 HIGH (DatabaseError), 2 LOW, 1 already tracked (RecoveryAction P5-3)**

---

### Per-Type Detailed Comparison

#### 1. Result<T, E> — EXACT MATCH
- **Spec:** 22_API_CONTRACTS.md Section 1
- **Impl:** lib/core/types/result.dart
- Sealed class with Success and Failure subtypes, all methods match

#### 2. Base Use Case Interfaces (4) — EXACT MATCH
- **Spec:** 22_API_CONTRACTS.md Section 4.5
- **Impl:** lib/domain/usecases/base_use_case.dart
- `UseCase<Input, Output>`, `UseCaseNoInput<Output>`, `UseCaseNoOutput<Input>`, `UseCaseWithInput<Output, Input>` — all match

#### 3. AppError Base — EXACT MATCH
- **Spec:** 22_API_CONTRACTS.md line 86
- **Impl:** lib/core/errors/app_error.dart line 31
- Fields: code, message, userMessage, originalError, stackTrace — all match
- Getters: isRecoverable, recoveryAction — both match

#### 4. DatabaseError — HIGH SEVERITY
- **Spec:** 22_API_CONTRACTS.md line 116
- **Impl:** lib/core/errors/app_error.dart line 57

| Issue | Spec | Implementation | Severity |
|-------|------|----------------|----------|
| Missing error code | `codeTransactionFailed = 'DB_TRANSACTION_FAILED'` | NOT PRESENT | HIGH |
| Missing factory | `transactionFailed(String operation, [dynamic error, StackTrace? stack])` | NOT PRESENT | HIGH |
| Extra parameter | `updateFailed(String table, [dynamic error, StackTrace? stack])` | `updateFailed(String table, String id, [dynamic error, StackTrace? stack])` | MEDIUM |
| Extra parameter | `deleteFailed(String table, [dynamic error, StackTrace? stack])` | `deleteFailed(String table, String id, [dynamic error, StackTrace? stack])` | MEDIUM |

**Impact:**
- Missing `transactionFailed` means DB transaction errors must use a generic error type
- Extra `id` parameter in `updateFailed`/`deleteFailed` provides more context in error messages but deviates from spec

**Assessment on updateFailed/deleteFailed:** The extra `id` parameter is useful for debugging — error messages show which specific record failed. The spec version is simpler but less informative. Consider updating spec to include `id`.

#### 5. AuthError — EXACT MATCH
- **Spec:** 22_API_CONTRACTS.md line 236
- **Impl:** lib/core/errors/app_error.dart line 189
- 7 error codes: all match
- 7 factories: all match (tokenExpired uses `const` optimization — functionally identical)

#### 6. NetworkError — LOW SEVERITY (minor text differences)
- **Spec:** 22_API_CONTRACTS.md line 319
- **Impl:** lib/core/errors/app_error.dart line 279
- 5 error codes: all match
- Minor differences:
  - `codeRateLimited` declared after `sslError` factory (line 348) instead of with other codes (cosmetic)
  - `rateLimited` message text: "Rate limit exceeded for" vs spec "Rate limited during" (minor)
  - `rateLimited` userMessage: "Please try again later." vs spec "Please wait a moment and try again." (minor)
  - `noConnection()` uses `const` optimization (functionally identical)

#### 7. ValidationError — EXACT MATCH
- **Spec:** 22_API_CONTRACTS.md line 387
- **Impl:** lib/core/errors/app_error.dart line 365
- 8 error codes, all factories, fieldErrors map, helper methods — all match

#### 8. SyncError — EXACT MATCH
- **Spec:** 22_API_CONTRACTS.md line 496
- **Impl:** lib/core/errors/app_error.dart line 486
- 5 error codes, 5 factories — all match

#### 9. WearableError — EXACT MATCH
- **Spec:** 22_API_CONTRACTS.md line 572
- **Impl:** lib/core/errors/app_error.dart line 580
- 7 error codes, 7 factories — all match

#### 10. DietError — LOW SEVERITY
- **Spec:** 22_API_CONTRACTS.md line 662
- **Impl:** lib/core/errors/app_error.dart line 686
- 6 error codes, 6 factories — all match
- `multipleActiveDiets()` uses `const` optimization (functionally identical)
- Missing Rule Conflict Detection Criteria comment block from spec (informational only — lines 698-727 in spec are a documentation comment, not executable code)

#### 11. IntelligenceError — EXACT MATCH
- **Spec:** 22_API_CONTRACTS.md line 769
- **Impl:** lib/core/errors/app_error.dart line 762
- 6 error codes, 6 factories — all match

#### 12. BusinessError — EXACT MATCH
- **Spec:** 22_API_CONTRACTS.md line 857
- **Impl:** lib/core/errors/app_error.dart line 869
- 5 error codes, 5 factories — all match

#### 13. NotificationError — EXACT MATCH
- **Spec:** 22_API_CONTRACTS.md line 929
- **Impl:** lib/core/errors/app_error.dart line 946
- 6 error codes, 6 factories — all match
- `permissionDenied()` uses `const` optimization (functionally identical)

#### 14. SyncMetadata — EXACT MATCH
- **Spec:** 22_API_CONTRACTS.md line 1037
- **Impl:** lib/domain/entities/sync_metadata.dart
- Already verified in Pass 1 — 9 fields, all factory methods, computed properties all match

#### 15. Syncable + SyncStatus — EXACT MATCH
- Both verified in Pass 1 and Pass 5 respectively

---

### Pass 6 Action Items

| ID | Severity | Issue | Recommended Action |
|----|----------|-------|-------------------|
| P6-1 | HIGH | DatabaseError missing `codeTransactionFailed` and `transactionFailed()` factory | Add to implementation |
| P6-2 | MEDIUM | DatabaseError `updateFailed`/`deleteFailed` have extra `id` parameter not in spec | **Decide:** Update spec to include `id` (better debugging) OR remove from impl |
| P6-3 | LOW | NetworkError `rateLimited` message text differs slightly from spec | Align message text with spec |
| P6-4 | LOW | DietError missing Rule Conflict Detection Criteria comment | Add comment (informational only) |

---

### Pass 6 Verdict

**16 of 19 core types are exact matches.** The main finding is DatabaseError missing `transactionFailed` (HIGH). NetworkError and DietError have minor text/comment differences (LOW). RecoveryAction's missing int values was already tracked as P5-3.

The core type layer is well-implemented. Result, base use cases, and 7 of 10 error subclasses are exact matches with the spec.

---

## Pass 4: Table Column Alignment (14 Implemented Tables)

### Method
For each Drift table definition:
1. Read the implementation file (lib/data/datasources/local/tables/)
2. Find the spec definition in 22_API_CONTRACTS.md Section 13
3. Compare column-by-column: name, type, nullable, defaults
4. Log every deviation

---

### Pass 4 Results Summary

| Table | Spec Section | Columns Match? | Issues | Severity |
|-------|:---:|:---:|:---:|:---:|
| supplements | 13.2 | YES | 0 | NONE |
| fluids_entries | 13.3 | YES (with noted extras) | 0 | NONE |
| conditions | 13.20 | YES | 0 | NONE |
| condition_logs | 13.21 | YES | 0 | NONE |
| activities | 13.15 | YES | 0 | NONE |
| activity_logs | 13.16 | YES | 0 | NONE |
| **food_items** | **13.13** | **NO** | 2 | **MEDIUM** |
| food_logs | 13.14 | YES | 0 | NONE |
| **intake_logs** | **13.12** | **NO** | SPEC INCONSISTENCY | **HIGH (spec bug)** |
| journal_entries | 13.18 | YES | 0 | NONE |
| photo_areas | 13.24 | YES | 0 | NONE |
| **photo_entries** | **13.25** | **NO** | 1 | **MEDIUM** |
| flare_ups | 13.22 | YES | 0 | NONE |
| sleep_entries | 13.17 | YES | 0 | NONE |

**Totals: 11 exact matches, 1 spec inconsistency (HIGH), 2 with deviations (MEDIUM)**

---

### Per-Table Detailed Comparison

#### 1. Supplements — MATCH
All 16 entity columns + 9 sync columns present. Column names, types, and nullability all match spec Section 13.2.

#### 2. FluidsEntries — MATCH (with noted extras)
All spec columns present. Extra DB columns `bowel_custom_condition` and `urine_custom_condition` exist — these are explicitly noted in spec Section 13.3: "bowelCustomCondition and urineCustomCondition DB columns exist for 'custom' enum values but are not in current entity."

#### 3. Conditions — MATCH
All 18 entity columns + 9 sync columns match spec Section 13.20.

#### 4. ConditionLogs — MATCH
All 16 entity columns + 9 sync columns match spec Section 13.21.

#### 5. Activities — MATCH
All 9 entity columns + 9 sync columns match spec Section 13.15.

#### 6. ActivityLogs — MATCH
All 10 entity columns + 9 sync columns match spec Section 13.16.

#### 7. FoodItems — MEDIUM SEVERITY

| Issue | Spec (13.13) | Implementation | Deviation |
|-------|-------------|----------------|-----------|
| serving_size type | TEXT (String?) | REAL (double?) | **Type mismatch** — spec says "1 cup", "100g" as text; impl stores numeric value |
| serving_unit | NOT IN SPEC | TEXT (String?) | **Extra column** — impl splits serving into value + unit |

**Impact:** The spec models `servingSize` as a free-text string like "1 cup" or "100g". The implementation stores it as a numeric value with a separate unit column. This changes the data model but is arguably more structured. Entity `FoodItem` has `servingSize` as `String?` per spec, but the table stores REAL — the DAO must handle this conversion.

#### 8. FoodLogs — MATCH
All 8 entity columns + 9 sync columns match spec Section 13.14.

#### 9. IntakeLogs — HIGH SEVERITY (Spec Internal Inconsistency)

**The spec's Section 13.12 table definition does NOT match the entity definition in Section 10.10.**

| Section 13.12 (Table) | Section 10.10 (Entity) | Implementation Table |
|----------------------|----------------------|---------------------|
| timestamp | scheduledTime | scheduled_time |
| intake_time (IntakeTime enum) | status (IntakeLogStatus enum) | status |
| dosage_amount (REAL) | actualTime (int?) | actual_time |
| notes (TEXT) | reason (String?) | reason |
| — | note (String?) | note |
| — | snoozeDurationMinutes (int?) | snooze_duration_minutes |

**The implementation table matches the entity definition (Section 10.10), NOT Section 13.12.** This is the correct approach — the table should match the entity. Section 13.12 appears to be from an older version of the IntakeLog entity.

**Verdict:** This is a SPEC BUG — Section 13.12 needs to be updated to match the current IntakeLog entity.

#### 10. JournalEntries — MATCH
All 9 entity columns + 9 sync columns match spec Section 13.18.

#### 11. PhotoAreas — MATCH
All 8 entity columns + 9 sync columns match spec Section 13.24.

#### 12. PhotoEntries — MEDIUM SEVERITY

| Issue | Spec (13.25) | Implementation | Deviation |
|-------|-------------|----------------|-----------|
| FK column name | `photo_area_id` | `area_id` | Column name mismatch |

**Impact:** The entity field is `photoAreaId` which should map to `photo_area_id` in the DB. The implementation uses `area_id` instead. This is a naming inconsistency that could cause issues if code references the column by name.

#### 13. FlareUps — MATCH
All 11 entity columns + 9 sync columns match spec Section 13.22.

#### 14. SleepEntries — MATCH
All 13 entity columns + 9 sync columns match spec Section 13.17.

---

### Sync Metadata Columns (Systematic Check)

All 14 tables have the 9 sync metadata columns per spec Section 13.7:
- `sync_created_at` (INTEGER, non-null)
- `sync_updated_at` (INTEGER, nullable)
- `sync_deleted_at` (INTEGER, nullable)
- `sync_last_synced_at` (INTEGER, nullable)
- `sync_status` (INTEGER, default 0)
- `sync_version` (INTEGER, default 1)
- `sync_device_id` (TEXT, nullable)
- `sync_is_dirty` (BOOLEAN, default true)
- `conflict_data` (TEXT, nullable)

**Note:** Spec Section 13.7 lists `sync_device_id` as nullable, which matches the table impl. However, the entity's `syncDeviceId` is `required String`. The DAO handles this by defaulting to empty string when null in DB.

---

### Pass 4 Action Items

| ID | Severity | Issue | Recommended Action |
|----|----------|-------|-------------------|
| P4-1 | HIGH | Spec Section 13.12 (IntakeLog table) is outdated — doesn't match entity Section 10.10 | **Update spec** Section 13.12 to match entity: scheduledTime, status, actualTime, reason, note, snoozeDurationMinutes |
| P4-2 | MEDIUM | FoodItems table: `serving_size` is REAL instead of TEXT, extra `serving_unit` column | **Decide:** Keep structured format (REAL+unit) and update spec, OR revert to single TEXT column |
| P4-3 | MEDIUM | PhotoEntries table: FK column `area_id` should be `photo_area_id` per spec | Rename column to `photo_area_id` for consistency |

---

### Pass 4 Verdict

**11 of 14 tables are exact column matches.** The main finding is a spec internal inconsistency (IntakeLog table definition is outdated). The FoodItems serving_size type mismatch and PhotoEntries FK naming are medium issues. All 14 tables correctly implement the 9-column sync metadata pattern.

---

## Implementation Gap Analysis

### Overview

The spec (22_API_CONTRACTS.md) defines 41 database tables (Section 13.42). The implementation has **14 of 41** tables built, covering the core health tracking entities. The remaining 27 tables belong to subsystems not yet implemented.

---

### What IS Implemented (14 Entity Subsystems)

| Layer | Components | Count |
|-------|-----------|:---:|
| Entities | supplement, fluids_entry, condition, condition_log, activity, activity_log, flare_up, food_item, food_log, intake_log, journal_entry, photo_area, photo_entry, sleep_entry + sync_metadata | 15 |
| Repository Interfaces | Base + 14 entity-specific | 15 |
| Repository Implementations | 14 (all entities) | 14 |
| Drift Tables | 14 (all entities) | 14 |
| DAOs | 14 (all entities) | 14 |
| Use Cases | ~70 non-generated files across 14 subdirectories | ~70 |
| Riverpod Providers | 14 entity sets + DI | 14+ |
| Screens | 12 screens (list/edit for several entities) | 12 |
| Core Types | Result, AppError (10 subclasses), base use cases, SyncMetadata | 15+ |
| Enums | 28 implemented (of 48 total in spec) | 28 |

**Test Count: 1205 passing**

---

### What IS NOT Implemented (27 Missing Table Subsystems)

#### Tier 1: Auth & Profile Management (Essential for Multi-User)
| Entity | Spec Table Section | Blocking? |
|--------|:---:|:---:|
| UserAccount | 13.8 | YES — needed for auth |
| Profile | 13.9 | YES — needed for profile switching |
| ProfileAccess | 13.10 | YES — needed for shared profiles |
| DeviceRegistration | 13.11 | NO — enhancement |

**Missing use cases:** GetCurrentUser, GetAccessibleProfiles, SetCurrentProfile, CreateProfile, DeleteProfile, UpdateProfile (noted as P9-2 in spec review)

#### Tier 2: Diet Management
| Entity | Spec Table Section | Blocking? |
|--------|:---:|:---:|
| Diet | 13.4 | NO — standalone feature |
| DietRule | 13.5 | NO — depends on Diet |
| DietViolation | 13.6 | NO — depends on Diet |

**Missing:** Complete diet subsystem — entities, repositories, use cases, tables, DAOs, screens

#### Tier 3: Notification System
| Entity | Spec Table Section | Blocking? |
|--------|:---:|:---:|
| NotificationSchedule | 13.26 | NO — enhancement |

**Missing:** Notification scheduling service, platform integration (iOS/Android), quiet hours logic

#### Tier 4: Intelligence & ML
| Entity | Spec Table Section | Blocking? |
|--------|:---:|:---:|
| Pattern | 13.29 | NO — advanced feature |
| TriggerCorrelation | 13.30 | NO — advanced feature |
| HealthInsight | 13.31 | NO — advanced feature |
| PredictiveAlert | 13.32 | NO — advanced feature |
| MLModel | 13.33 | NO — advanced feature |
| PredictionFeedback | 13.34 | NO — advanced feature |

**Missing:** Complete intelligence engine — pattern detection, correlation analysis, ML inference, insight generation

#### Tier 5: Wearable Integration
| Entity | Spec Table Section | Blocking? |
|--------|:---:|:---:|
| WearableConnection | 13.35 | NO — enhancement |
| ImportedDataLog | 13.36 | NO — depends on wearable |

**Missing:** Platform-specific integrations (HealthKit, Google Fit, Fitbit, Garmin, Oura, Whoop)

#### Tier 6: Medical/Compliance
| Entity | Spec Table Section | Blocking? |
|--------|:---:|:---:|
| Document | 13.19 | NO — document management |
| ConditionCategory | 13.23 | NO — condition organization |
| FhirExport | 13.37 | NO — medical export |
| HipaaAuthorization | 13.38 | NO — compliance |
| ProfileAccessLog | 13.39 | NO — compliance |
| AuditLogEntry | 13.40 | NO — compliance |
| BowelUrineLog | 13.41 | NO — legacy migration |
| FoodItemCategory | 13.27 | NO — food categorization |
| UserFoodCategory | 13.28 | NO — food categorization |

---

### Missing Screens (from 38_UI_FIELD_SPECIFICATIONS.md)

| Screen | Has Entity? | Has Use Cases? | Has Provider? | Screen Exists? |
|--------|:---:|:---:|:---:|:---:|
| Activity List/Edit | YES | YES | YES | **NO** |
| Activity Log | YES | YES | YES | **NO** |
| Journal Entry | YES | YES | YES | **NO** |
| Photo Area List | YES | YES | YES | **NO** |
| Photo Entry | YES | YES | YES | **NO** |
| Flare-Up | YES | YES | YES | **NO** |
| Dashboard/Home | — | — | — | **NO** |
| Settings | — | — | — | **NO** |
| Profile Management | NO | NO | NO | **NO** |
| Diet Management | NO | NO | NO | **NO** |
| Notification Settings | NO | NO | NO | **NO** |
| Wearable Connections | NO | NO | NO | **NO** |
| Intelligence/Insights | NO | NO | NO | **NO** |

**6 screens have complete backend support but no screen implementation yet.** These are the lowest-hanging fruit.

---

### Missing Core Infrastructure

| Service | Status | Notes |
|---------|--------|-------|
| Sync Engine | NOT STARTED | Conflict resolution, cloud sync |
| Auth Service | STUB ONLY | ProfileAuthorizationService exists but no real auth |
| Notification Service | NOT STARTED | Platform-specific notification delivery |
| Wearable Service | NOT STARTED | HealthKit/GoogleFit integrations |
| ML Inference Engine | NOT STARTED | TFLite model execution |
| Cloud Storage Service | NOT STARTED | Photo/file uploads |
| FHIR Export Service | NOT STARTED | Medical data export |
| Rate Limiting Service | NOT STARTED | API rate limiting |
| Audit Logging Service | NOT STARTED | HIPAA-compliant audit trail |
| Database Migration | PARTIAL | Schema defined but migration logic not tested |

---

### Completion Percentages by Layer

| Layer | Implemented | Total Spec | % |
|-------|:---------:|:--------:|:---:|
| Core Types (Result, errors, enums) | 43 | ~68 | 63% |
| Entities | 15 | ~40 | 38% |
| Repository Interfaces | 15 | ~40 | 38% |
| Repository Implementations | 14 | ~40 | 35% |
| Tables | 14 | 41 | 34% |
| DAOs | 14 | 41 | 34% |
| Use Cases | ~70 | ~200+ | ~35% |
| Providers | 14 sets | ~25+ sets | 56% |
| Screens | 12 | ~25+ | ~48% |
| Tests | 1205 | — | — |

**Overall estimated completion: ~35-40% of total spec scope.**

---

### Recommended Priority Order for Remaining Work

1. **Auth/Profile** (Tier 1) — Required for multi-user. Blocking.
2. **Missing Screens** (6 with backend ready) — Activity, ActivityLog, Journal, PhotoArea, PhotoEntry, FlareUp
3. **Dashboard/Home Screen** — Core user experience
4. **Diet Management** (Tier 2) — Major feature
5. **Notification System** (Tier 3) — User engagement
6. **Wearable Integration** (Tier 5) — Platform differentiator
7. **Intelligence/ML** (Tier 4) — Advanced analytics
8. **Medical/Compliance** (Tier 6) — Regulatory compliance

---

## Pass 3: Use Case Input Classes + Logic

### Method
For each use case domain (14 subdirectories, ~70 non-generated files):
1. Read the implementation input class file
2. Read the implementation use case file(s)
3. Find corresponding spec definition in 22_API_CONTRACTS.md Section 4
4. Compare field-by-field for Input classes
5. Compare logic: authorization, validation, entity construction, repository call
6. Log every deviation

---

### Pass 3 Results Summary

**14 domains reviewed, ~70 files compared**

| Domain | Input Classes | Use Cases | Match Status |
|--------|:---:|:---:|----------|
| Supplements | 5 | 4 | MATCH (minor style diffs) |
| Fluids Entries | 6 | 5 | MATCH (impl adds extra validation) |
| Conditions | 3 | 3 | DEVIATION: CreateConditionInput has extra `triggers` field |
| Condition Logs | 2 | 2 | DEVIATION: GetConditionLogsInput wrong, LogConditionUseCase simplified |
| Activities | 4 | 4 | MATCH |
| Activity Logs | 4 | 4 | MATCH |
| Flare Ups | 5 | 5 | MATCH |
| Food Items | 5 | 5 | MATCH |
| Food Logs | 4 | 4 | MATCH |
| Intake Logs | 4 | 4 | MATCH (void returns per P2-3) |
| Journal Entries | 5 | 6 | MATCH |
| Photo Areas | 4 | 4 | MATCH |
| Photo Entries | 4 | 4 | MATCH |
| Sleep Entries | 6 | 4 | MATCH |

---

### Pass 3 Findings

#### P3-1: CreateConditionInput has extra `triggers` field — MEDIUM

**Spec** (line 4811-4823):
```dart
class CreateConditionInput {
  required String profileId,
  required String clientId,
  required String name,
  required String category,
  @Default([]) List<String> bodyLocations,
  String? description,
  String? baselinePhotoPath,
  required int startTimeframe,
  int? endDate,
  String? activityId,
}
```

**Implementation** (condition_inputs.dart:21-35):
```dart
class CreateConditionInput {
  ...same fields...
  @Default([]) List<String> triggers,  // EXTRA — not in spec
}
```

**Impact:** Implementation allows setting triggers on a Condition at creation time. The spec's Condition entity (Section 10.8) does have a `triggers` field, so this is functionally reasonable. However, the spec's CreateConditionInput does not include it.

**Verdict:** MEDIUM — Implementation adds a useful field not in the spec Input class, but the entity supports it.

---

#### P3-2: GetConditionLogsInput missing conditionId, has extra limit/offset — HIGH

**Spec** (line 5003-5009):
```dart
class GetConditionLogsInput {
  required String profileId,
  required String conditionId,   // REQUIRED
  int? startDate,
  int? endDate,
}
```

**Implementation** (condition_log_inputs.dart:10-18):
```dart
class GetConditionLogsInput {
  required String profileId,
  // MISSING: conditionId
  int? startDate,
  int? endDate,
  int? limit,    // EXTRA
  int? offset,   // EXTRA
}
```

**Impact:** The spec requires querying by `conditionId` (get logs for a specific condition). The implementation queries by `profileId` only (get ALL logs for a profile). These are fundamentally different operations. The spec's `GetConditionLogsUseCase` calls `_repository.getByCondition(input.conditionId, ...)` while the implementation calls `_repository.getByProfile(input.profileId, ...)`.

**Verdict:** HIGH — Wrong query scope. Missing `conditionId` means the use case fetches all condition logs instead of condition-specific logs.

---

#### P3-3: LogConditionUseCase missing ConditionRepository dependency — MEDIUM

**Spec** (line 4897-4906):
```dart
class LogConditionUseCase {
  final ConditionLogRepository _logRepository;
  final ConditionRepository _conditionRepository;   // PRESENT
  final ProfileAuthorizationService _authService;
}
```

**Implementation** (log_condition_use_case.dart:22-26):
```dart
class LogConditionUseCase {
  final ConditionLogRepository _repository;
  final ProfileAuthorizationService _authService;
  // MISSING: ConditionRepository _conditionRepository
}
```

**Impact:** The spec verifies the condition exists and belongs to the profile before creating the log (lines 4917-4925). The implementation skips this verification — it validates conditionId is non-empty (trim check) but never verifies the condition actually exists in the database.

**Verdict:** MEDIUM — Missing cross-entity validation. A log can be created for a non-existent condition.

---

#### P3-4: Supplement Update/Archive use cases don't pre-compute `now` — LOW

**Spec** `UpdateSupplementUseCase` (line 4648):
```dart
final now = DateTime.now().millisecondsSinceEpoch;  // At method start
```

**Implementation** `UpdateSupplementUseCase` (update_supplement_use_case.dart:64):
```dart
syncUpdatedAt: DateTime.now().millisecondsSinceEpoch,  // Inline
```

**Impact:** Functionally identical. The inline approach calls `DateTime.now()` slightly later than the spec's pre-computation but within the same synchronous block. Not a behavioral difference.

**Verdict:** LOW — Style consistency only.

---

#### P3-5: CreateConditionUseCase validation uses different ValidationRules API — LOW

**Spec** (line 4842):
```dart
final nameError = ValidationRules.conditionName(input.name);
```

**Implementation** (create_condition_use_case.dart:74-78):
```dart
final nameError = ValidationRules.entityName(
  input.name, 'Condition name', ValidationRules.conditionNameMaxLength,
);
```

**Impact:** Both validate the condition name, but the implementation uses a generic `entityName()` method with parameters instead of the specific `conditionName()` method from the spec. The validation behavior depends on whether both methods enforce the same rules.

**Verdict:** LOW — Different API call, likely same behavior.

---

#### P3-6: LogFluidsEntryUseCase adds extra validation not in spec — LOW

The implementation (log_fluids_entry_use_case.dart:126-148) adds validation for:
- `otherFluidName` format (2-100 chars, letters/spaces/hyphens only)
- `otherFluidAmount` max length (50 chars)
- `otherFluidNotes` max length (5000 chars)
- `notes` max length (2000 chars)

The spec (lines 2524-2567) only validates:
- At least one measurement
- Water intake range (0-10000)
- BBT range (95-105°F)
- BBT requires recorded time
- Other fluid name required when amount/notes provided

**Impact:** Implementation is more defensive than spec. No data loss, but could reject valid input if spec allows longer notes.

**Verdict:** LOW — Stricter validation than spec, defensive coding.

---

#### P3-7: MarkTakenUseCase returns void, spec returns IntakeLog — Already tracked as P2-3

The intake log mark* use cases all implement `UseCase<Input, void>` while the spec repository returns `IntakeLog`. This was already identified in Pass 2 as P2-3 (HIGH). The use case correctly mirrors the repository return type.

---

### Pass 3 Summary

| Severity | Count | IDs |
|----------|:---:|-----|
| HIGH | 1 | P3-2 |
| MEDIUM | 2 | P3-1, P3-3 |
| LOW | 3 | P3-4, P3-5, P3-6 |

**Overall Assessment:** The use case implementations are remarkably faithful to the spec. Out of ~70 files across 14 domains, only 3 meaningful deviations were found. The most significant (P3-2) is the GetConditionLogsInput missing `conditionId`, which changes the query semantics. The other two (P3-1 extra field, P3-3 missing cross-entity validation) are moderate impacts.

The vast majority of use cases — all Input classes, authorization patterns, entity construction, validation logic, and repository calls — are exact matches with the spec.

---

## Cumulative Findings Summary (Passes 1-6)

### By Severity (Passes 1-6 Only)

| Severity | Count | Details |
|----------|:---:|---------|
| HIGH | 11 | P1-1, P2-1, P2-2, P2-3, P3-2, P5-1, P5-2, P5-3, P5-4, P6-1, P4-1 |
| MEDIUM | 12 | P1-2, P1-3, P2-4, P3-1, P3-3, P6-2, P4-2, P4-3, + systematic S-1, S-2 |
| LOW | 15 | P1-4, P1-5, P2-5, P2-6, P3-4, P3-5, P3-6, P5-5, P6-3, P6-4, + minor text diffs |

### HIGH Priority Fix List

| ID | Component | Issue | Fix Effort |
|----|-----------|-------|:---:|
| P1-1 | ActivityLog entity | activityIds/adHocActivities required→@Default([]) | 5 min |
| P2-1 | ConditionLogRepository | getByCondition missing startDate/endDate params | 10 min |
| P2-2 | FlareUpRepository | Missing getTriggerCounts method | 15 min |
| P2-3 | IntakeLogRepository | markTaken/markSkipped/markSnoozed return void not IntakeLog | 20 min |
| P3-2 | GetConditionLogsInput | Missing conditionId, wrong query scope (getByProfile vs getByCondition) | 15 min |
| P5-1 | DietPresetType enum | Missing int values (spec has 0-19) | 5 min |
| P5-2 | InsightCategory enum | Missing int values (spec has 0-8) | 5 min |
| P5-3 | RecoveryAction enum | Missing int values (spec has 0-7) | 5 min |
| P5-4 | AccessLevel enum | Missing int values (spec has 0-2) | 5 min |
| P6-1 | DatabaseError | Missing codeTransactionFailed + factory | 10 min |
| P4-1 | Spec Section 13.12 | IntakeLog table definition outdated | Spec fix |

**Total estimated fix time for all HIGH issues: ~100 minutes**

---

---

# Deeper Review — Passes 7-10 (Cross-Layer Analysis)

These passes examine consistency ACROSS layers (entity→repo→usecase→DAO→table) rather than within each layer independently. Performed serially by a single instance per user request.

---

## Pass 7: Cross-Layer Consistency

**Method:** For each of the 14 implemented entities, read across all 5 layers (entity, repository interface, use case inputs, table definition, DAO implementation) and verify fields/types/methods are consistent end-to-end.

### Finding P7-1: Inconsistent List<String> Storage Pattern (MEDIUM)

Two competing patterns exist for storing `List<String>` entity fields in the database:

**Pattern A — JSON arrays** (used by 4 entities):
- Supplement: `ingredients`, `schedules` → `jsonEncode()` / `jsonDecode()`
- Condition: `bodyLocations`, `triggers` → `jsonEncode()` / `_parseJsonList()`
- FlareUp: `triggers` → `jsonEncode()` / `_parseJsonList()`
- FluidsEntry: `photoIds` → `jsonEncode()` / `_parseJsonList()`

**Pattern B — Comma-separated strings** (used by 5 entities):
- ActivityLog: `activityIds`, `adHocActivities` → `.join(',')` / `_parseList()`
- FoodLog: `foodItemIds`, `adHocItems` → `.join(',')` / `_parseList()`
- FoodItem: `simpleItemIds` → `.join(',')` / `_parseList()`
- ConditionLog: `flarePhotoIds` → `.join(',')` / `_parseFlarePhotoIds()`
- JournalEntry: `tags` → `.join(',')` / `_parseList()`

**Impact:** Comma-separated storage breaks if any value contains a comma. This is low-risk for IDs (UUIDs don't contain commas) but higher-risk for `adHocActivities`, `adHocItems`, and `tags` which are user-entered free text.

**Recommendation:** Standardize on JSON arrays for all `List<String>` fields. Comma-separated pattern is a latent bug for user-entered text fields.

---

### Finding P7-2: FoodItem servingSize Cross-Layer Type Mismatch (MEDIUM)

The FoodItem entity has `String? servingSize` but the database table stores it as two separate columns: `serving_size REAL` + `serving_size_unit TEXT`.

The DAO performs a fragile string-based conversion:

```dart
// Entity → Table (in _entityToCompanion)
String? _buildServingSize(double? size, String? unit) {
  if (size == null) return null;
  if (unit == null || unit.isEmpty) return size.toString();
  final sizeStr = size == size.truncate() ? size.truncate().toString() : size.toString();
  return '$sizeStr $unit';
}

// Table → Entity (in _rowToEntity)
(double?, String?) _parseServingSize(String? servingSize) {
  if (servingSize == null || servingSize.isEmpty) return (null, null);
  final parts = servingSize.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty) return (null, null);
  final size = double.tryParse(parts[0]);
  final unit = parts.length > 1 ? parts.sublist(1).join(' ') : null;
  return (size, unit);
}
```

**Problem:** The parsing relies on whitespace splitting. A serving size like `"100g"` (no space) would parse `size=null, unit=null` — losing data. Also `"1.5 fl oz"` correctly parses to `(1.5, "fl oz")` but round-tripping through build+parse is fragile.

**Impact:** Data loss possible for edge-case serving size formats.

---

### Finding P7-3: ConditionLog.triggers vs Condition.triggers Semantic Inconsistency (LOW)

- `Condition.triggers` is `List<String>` — stored as JSON array
- `ConditionLog.triggers` is `String?` — stored as plain text

These represent the same semantic concept (what triggered a condition) but use different types and storage patterns. The Condition entity defines a list of known triggers; the ConditionLog stores a free-text trigger description for a single log entry.

**Impact:** Low — the types are intentionally different (list of predefined triggers vs. free-text for a single event). But the naming collision could confuse implementers.

---

### Finding P7-4: SyncMetadata Nullable→Required Handling (CONSISTENT — No Issue)

All 14 DAOs use the same pattern for handling nullable sync columns → required SyncMetadata entity field:

```dart
syncMetadata: SyncMetadata(
  syncId: row.syncId ?? '',
  syncStatus: SyncStatus.fromValue(row.syncStatus ?? 0),
  syncCreatedAt: row.syncCreatedAt ?? 0,
  syncUpdatedAt: row.syncUpdatedAt ?? 0,
  syncVersion: row.syncVersion ?? 1,
  syncDeviceId: row.syncDeviceId ?? '',
  syncDeletedAt: row.syncDeletedAt,
  syncLastError: row.syncLastError,
  syncRetryCount: row.syncRetryCount ?? 0,
);
```

This is consistent across all implementations. No issue.

---

### Pass 7 Summary

| ID | Severity | Issue |
|----|----------|-------|
| P7-1 | MEDIUM | Inconsistent List<String> storage (JSON vs comma-separated) — latent bug for user text fields |
| P7-2 | MEDIUM | FoodItem servingSize fragile string parsing — data loss on edge cases |
| P7-3 | LOW | ConditionLog.triggers (String?) vs Condition.triggers (List<String>) naming collision |
| P7-4 | — | SyncMetadata handling: consistent across all 14 DAOs (no issue) |

---

## Pass 8: Test Coverage Audit

**Method:** Inventory all test files and identify coverage gaps by layer and entity.

### Test File Inventory (53 files total)

**Use Case Tests (12 files — all 14 domains covered):**
| Domain | File | Test Count |
|--------|------|:---:|
| Supplements | supplement_use_cases_test.dart | 24 |
| Conditions | condition_use_cases_test.dart | 14 |
| ActivityLogs | activity_log_use_cases_test.dart | 17 |
| FlareUps | flare_up_use_cases_test.dart | 22 |
| FoodItems | food_item_use_cases_test.dart | 17 |
| FoodLogs | food_log_use_cases_test.dart | 17 |
| IntakeLogs | intake_log_use_cases_test.dart | 11 |
| SleepEntries | sleep_entry_use_cases_test.dart | 22 |
| JournalEntries | journal_entry_use_cases_test.dart | 19 |
| PhotoAreas | photo_area_use_cases_test.dart | 15 |
| PhotoEntries | photo_entry_use_cases_test.dart | 14 |
| Activities | activity_use_cases_test.dart | 14 |

**DAO Tests (4 files — only 4 of 14 entities):**
- supplement_dao_test.dart (38 tests)
- condition_dao_test.dart
- condition_log_dao_test.dart
- intake_log_dao_test.dart

**Entity Tests (4 files — only 4 of 14 entities):**
- supplement_test.dart (44 tests)
- condition_test.dart
- condition_log_test.dart
- intake_log_test.dart

**Repository Implementation Tests (1 file — only 1 of 14 entities):**
- supplement_repository_impl_test.dart

**Screen Tests:** 12 files
**Widget Tests:** 10 files
**Core Tests:** 5 files (error handling, enums, sync metadata, etc.)

---

### Finding P8-1: Missing DAO Tests for 10 Entities (MEDIUM)

Only 4 of 14 entities have DAO tests. The following 10 entities have **no DAO test coverage**:

| Entity | DAO Exists | DAO Test |
|--------|:---:|:---:|
| Activity | Yes | **NO** |
| ActivityLog | Yes | **NO** |
| FlareUp | Yes | **NO** |
| FluidsEntry | Yes | **NO** |
| FoodItem | Yes | **NO** |
| FoodLog | Yes | **NO** |
| JournalEntry | Yes | **NO** |
| PhotoArea | Yes | **NO** |
| PhotoEntry | Yes | **NO** |
| SleepEntry | Yes | **NO** |

**Impact:** DAO layer is where entity↔table mapping happens. Without tests, the type conversions (especially List<String> storage, enum value mapping, nullable handling) are unverified at the integration level.

---

### Finding P8-2: Missing Entity Tests for 10 Entities (MEDIUM)

Only 4 of 14 entities have entity-level tests (computed getters, serialization, equality). The same 10 entities listed above are missing entity tests.

**Impact:** Entity computed properties (like `isActive`, `isWithinDateRange`, `displayDosage`) are untested for most entities.

---

### Finding P8-3: Missing Repository Implementation Tests for 13 Entities (MEDIUM)

Only Supplement has a repository implementation test. The remaining 13 entities have no repo impl test coverage.

**Impact:** The DAO↔Repository adapter layer (error mapping, sync metadata preparation, Result wrapping) is untested for 13 of 14 entities.

---

### Pass 8 Summary

| ID | Severity | Issue |
|----|----------|-------|
| P8-1 | MEDIUM | 10/14 entities missing DAO tests |
| P8-2 | MEDIUM | 10/14 entities missing entity tests |
| P8-3 | MEDIUM | 13/14 entities missing repo impl tests |

**Note:** These are coverage gaps, not bugs. The existing test patterns (from the 4 well-tested entities) are correct and can be replicated. The coverage gaps should be addressed during the implementation fix phase.

---

## Pass 9: Provider Wiring Verification

**Method:** Read `lib/presentation/providers/di/di_providers.dart` (653 lines) and verify every provider correctly wires its dependencies per the spec.

### Inventory

- **14 repository providers** — all use `throw UnimplementedError()` pattern for ProviderScope override
- **1 ProfileAuthorizationService provider**
- **51 use case providers** across 14 domains

### Verification Results

All 51 use case providers were checked. Each was verified to pass the correct repository provider(s) and the `profileAuthorizationServiceProvider`.

**Only 1 wiring error found:**

### Finding P9-1: LogConditionUseCase Provider Missing Dependency (Confirms P3-3)

```dart
// di_providers.dart line ~278
LogConditionUseCase logConditionUseCase(Ref ref) => LogConditionUseCase(
  ref.read(conditionLogRepositoryProvider),
  ref.read(profileAuthorizationServiceProvider),
);
```

Per spec, `LogConditionUseCase` should also receive `conditionRepositoryProvider` for cross-entity validation (verifying the condition exists before logging against it). The provider only passes 2 of the spec's 3 required dependencies.

**This is the same issue as P3-3 from Pass 3.** The provider wiring is consistent with the use case implementation (which also only accepts 2 deps), but both deviate from the spec.

### Correctly Wired Cross-Entity Providers (Verified)

These providers correctly pass multiple repository dependencies:
- `logFlareUpUseCase` — passes flareUpRepo + conditionRepo + authService ✓
- `logActivityUseCase` — passes activityLogRepo + activityRepo + authService ✓
- `logFoodUseCase` — passes foodLogRepo + foodItemRepo + authService ✓
- `updateActivityLogUseCase` — passes activityLogRepo + activityRepo + authService ✓
- `createPhotoEntryUseCase` — passes photoEntryRepo + photoAreaRepo + authService ✓

---

### Pass 9 Summary

| ID | Severity | Issue |
|----|----------|-------|
| P9-1 | — | LogConditionUseCase provider missing conditionRepo (duplicate of P3-3) |

**51 providers checked, 50 correctly wired, 1 confirmed issue (already tracked).**

---

## Pass 10: End-to-End Data Flow Trace

**Method:** Trace 3 representative entities through the complete data flow: User Action → Provider → UseCase → Repository → DAO → Table → DAO → Entity, verifying field fidelity at every boundary.

### Trace 1: Supplement (Clean Path)

```
CreateSupplementInput (16 fields)
  → CreateSupplementUseCase.execute()
    → authService.validateProfileAccess(profileId) ✓
    → Build Supplement entity (all fields mapped) ✓
    → supplementRepository.create(supplement)
      → SupplementRepositoryImpl.create()
        → _syncService.prepareForCreate() ✓
        → _dao.insertSupplement(supplement)
          → _entityToCompanion() maps all 16 entity + 9 sync fields ✓
          → ingredients → jsonEncode(List<Map>) ✓
          → schedules → jsonEncode(List<Map>) ✓
          → enums → .value (int) ✓
        → Drift INSERT into supplements table ✓
  → Return Result<Supplement, AppError> ✓
```

**Read path:**
```
GetSupplementsUseCase.execute()
  → supplementRepository.getByProfile(profileId)
    → SupplementRepositoryImpl.getByProfile()
      → _dao.getByProfile(profileId)
        → SELECT * FROM supplements WHERE profile_id = ? ✓
        → _rowToEntity() maps all columns back ✓
        → ingredients ← jsonDecode(TEXT) → List<SupplementIngredient> ✓
        → schedules ← jsonDecode(TEXT) → List<SupplementSchedule> ✓
        → enums ← EnumType.fromValue(int) ✓
        → syncMetadata ← nullable columns with ?? fallbacks ✓
  → Return Result<List<Supplement>, AppError> ✓
```

**Verdict: CLEAN.** All fields survive the round trip with no data loss or type mismatches.

---

### Trace 2: ConditionLog (Broken Path)

```
LogConditionInput (8 fields including conditionId)
  → LogConditionUseCase.execute()
    → authService.validateProfileAccess(profileId) ✓
    → ⚠️ MISSING: conditionRepository.getById(conditionId) — spec requires verifying condition exists (P3-3)
    → Build ConditionLog entity ✓
    → conditionLogRepository.create(conditionLog) ✓
      → DAO inserts correctly ✓
  → Return Result<ConditionLog, AppError> ✓

GetConditionLogsInput (profileId only — MISSING conditionId per P3-2)
  → GetConditionLogsUseCase.execute()
    → ⚠️ Calls repository.getByProfile(profileId) instead of getByCondition(conditionId)
      → DAO.getByProfile() works correctly ✓
    → ⚠️ BUT: repository.getByCondition() is MISSING startDate/endDate params (P2-1)
      → Even if the UseCase were fixed, the repo can't filter by date range
```

**Verdict: BROKEN at UseCase layer.** Three linked issues (P2-1, P3-2, P3-3) combine to make the ConditionLog query flow incorrect:
1. UseCase queries wrong scope (all logs for profile vs. logs for specific condition)
2. UseCase doesn't validate condition exists before logging
3. Repository method can't filter by date range even when called correctly

These 3 issues should be fixed together as they affect the same flow.

---

### Trace 3: FoodItem (Fragile Path)

```
CreateFoodItemInput (11 fields including servingSize: String?)
  → CreateFoodItemUseCase.execute()
    → authService.validateProfileAccess(profileId) ✓
    → Build FoodItem entity (servingSize: String?) ✓
    → foodItemRepository.create(foodItem) ✓
      → FoodItemRepositoryImpl.create()
        → _dao.insertFoodItem(foodItem)
          → _entityToCompanion():
            → servingSize: "1.5 fl oz"
            → _parseServingSize("1.5 fl oz") → (1.5, "fl oz")
            → serving_size column = 1.5 (REAL) ✓
            → serving_size_unit column = "fl oz" (TEXT) ✓
          → simpleItemIds → .join(',') (comma-separated) ✓
        → INSERT into food_items table ✓

Read path:
  → _dao.getByProfile(profileId)
    → SELECT * FROM food_items ✓
    → _rowToEntity():
      → serving_size=1.5, serving_size_unit="fl oz"
      → _buildServingSize(1.5, "fl oz") → "1.5 fl oz" ✓
      → simpleItemIds ← _parseList(comma-separated) ✓
    → Round trip: "1.5 fl oz" → (1.5, "fl oz") → "1.5 fl oz" ✓
```

**Edge case test:**
```
Input: servingSize = "100g"  (no space)
→ _parseServingSize("100g"):
  → parts = ["100g"]
  → double.tryParse("100g") → null
  → Returns (null, null)
→ _buildServingSize(null, null) → null
→ ⚠️ DATA LOSS: "100g" round-trips to null
```

**Verdict: FRAGILE.** Normal formats with spaces work correctly. Edge cases without spaces (common in nutrition labeling) cause silent data loss via the string parsing. See P7-2.

---

### Pass 10 Summary

| Entity | Verdict | Issues |
|--------|---------|--------|
| Supplement | CLEAN | None — full round-trip verified |
| ConditionLog | BROKEN | P2-1 + P3-2 + P3-3 combine for incorrect query flow |
| FoodItem | FRAGILE | P7-2 servingSize parsing causes data loss on edge cases |

---

## Updated Cumulative Findings Summary (All 10 Passes)

### By Severity

| Severity | Count | Details |
|----------|:---:|---------|
| HIGH | 11 | P1-1, P2-1, P2-2, P2-3, P3-2, P5-1, P5-2, P5-3, P5-4, P6-1, P4-1 |
| MEDIUM | 17 | P1-2, P1-3, P2-4, P3-1, P3-3, P6-2, P4-2, P4-3, S-1, S-2, P7-1, P7-2, P8-1, P8-2, P8-3 |
| LOW | 16 | P1-4, P1-5, P2-5, P2-6, P3-4, P3-5, P3-6, P5-5, P6-3, P6-4, P7-3, + minor text diffs |

### New Findings from Passes 7-10

| ID | Severity | Pass | Issue |
|----|----------|:---:|-------|
| P7-1 | MEDIUM | 7 | Inconsistent List<String> storage — JSON arrays vs comma-separated. Latent bug for user text fields (adHocActivities, adHocItems, tags) |
| P7-2 | MEDIUM | 7 | FoodItem servingSize fragile string parsing — data loss on "100g" style inputs |
| P7-3 | LOW | 7 | ConditionLog.triggers (String?) vs Condition.triggers (List<String>) naming collision |
| P8-1 | MEDIUM | 8 | 10/14 entities missing DAO tests |
| P8-2 | MEDIUM | 8 | 10/14 entities missing entity tests |
| P8-3 | MEDIUM | 8 | 13/14 entities missing repo impl tests |
| P9-1 | — | 9 | LogConditionUseCase provider wiring (duplicate of P3-3, not counted separately) |

### Linked Issue Groups (Fix Together)

**Group A — ConditionLog Flow (3 issues):**
- P2-1: ConditionLogRepository.getByCondition missing startDate/endDate
- P3-2: GetConditionLogsInput missing conditionId, wrong query scope
- P3-3/P9-1: LogConditionUseCase missing conditionRepository dependency

**Group B — List<String> Storage (1 issue, 5 entities affected):**
- P7-1: Standardize ActivityLog, FoodLog, FoodItem, ConditionLog, JournalEntry to JSON arrays

---

## REVIEW COMPLETE — All 10 Passes Done

**Total findings across all passes: 11 HIGH, 17 MEDIUM, 16 LOW (44 total)**

Of these, 6 are new from the deeper cross-layer analysis (passes 7-10). The cross-layer review confirmed that the Supplement entity (the reference implementation) is fully clean end-to-end. The ConditionLog flow has 3 linked issues that should be fixed together. The FoodItem servingSize parsing is fragile and should be hardened. Test coverage gaps exist for 10 of 14 entities at the DAO/entity/repo-impl layers.

**Recommended fix order:**
1. Fix 11 HIGH issues first (~100 minutes)
2. Fix Group A (ConditionLog flow) as a unit
3. Fix P7-1 (standardize List<String> storage to JSON)
4. Fix P7-2 (FoodItem servingSize parsing)
5. Add missing tests (P8-1, P8-2, P8-3) — largest effort, can parallelize
