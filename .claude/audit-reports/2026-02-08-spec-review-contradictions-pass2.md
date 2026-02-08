# Spec Review Report - 2026-02-08 (Contradiction-Focused Pass 2)

## Executive Summary
- Focus: Entity-vs-use-case contradictions (same class as Profile/Pattern issues)
- New contradictions found: 8
- Severity: 5 CRITICAL (would-not-compile), 3 HIGH (silent data loss or missing methods)

---

## New Contradictions Found

### CRITICAL-1: ImportedDataLog — Entity vs Use Case Design Mismatch (lines 6507-6523 vs 10902-10914)

**Severity:** CRITICAL — completely different schemas, would not compile

The `SyncWearableDataUseCase._importLog` constructs `ImportedDataLog` as a **summary object** (counts, ranges):
```dart
// Use case (line 6507-6523):
ImportedDataLog(
  source: input.platform.name,        // String
  importedAt: now,
  recordCount: importedCount,          // int
  skippedCount: skippedCount,          // int
  errorCount: errorCount,             // int
  syncRangeStart: syncStart,           // int
  syncRangeEnd: syncEnd,              // int
)
```

But the entity definition is a **per-record log** (one row per imported record):
```dart
// Entity (line 10902-10914):
ImportedDataLog(
  sourcePlatform: WearablePlatform,    // enum, not String
  sourceRecordId: String,              // required — not in use case
  targetEntityType: String,            // required — not in use case
  targetEntityId: String,              // required — not in use case
  sourceTimestamp: int,                // required — not in use case
  rawData: String?,
)
```

**Fields in use case but NOT in entity:** `source` (wrong name+type), `recordCount`, `skippedCount`, `errorCount`, `syncRangeStart`, `syncRangeEnd`
**Required entity fields NOT in use case:** `sourcePlatform`, `sourceRecordId`, `targetEntityType`, `targetEntityId`, `sourceTimestamp`

**Decision needed:** Should the entity be a summary log (matching use case) or a per-record log (current entity)? The use case design makes more sense for "import session" tracking. The entity design makes more sense for "what was this record imported from" deduplication.

---

### CRITICAL-2: SleepEntry — _importSleep uses 4 wrong field names (lines 6615-6630 vs 11478-11493)

**Severity:** CRITICAL — would not compile (4 field name mismatches)

| Line | Use Case Uses | Entity Has |
|------|---------------|------------|
| 6619 | `sleepStart` | `bedTime` |
| 6620 | `sleepEnd` | `wakeTime` |
| 6621 | `quality` | *(no such field)* |
| 6623 | `externalId` | `importExternalId` |

**Fix:** Update _importSleep to use correct entity field names: `bedTime`, `wakeTime`, `importExternalId`. Remove `quality` (entity has `wakingFeeling` and `dreamType` but no single `quality` field).

---

### CRITICAL-3: ActivityLog — _importActivity missing required field (line 6580-6595 vs 11410-11423)

**Severity:** CRITICAL — would not compile (missing required field with no default)

The `_importActivity` constructs `ActivityLog` without `adHocActivities`, which is `required List<String>` with NO `@Default` value. This is a compile error.

**Fix:** Add `adHocActivities: []` to the _importActivity construction.

---

### CRITICAL-4: PatternRepository.findSimilar — signature mismatch (line 5408 vs 9872-9876)

**Severity:** CRITICAL — would not compile

Use case calls: `_patternRepository.findSimilar(pattern)` passing a **Pattern object**
Repository defines: `findSimilar(String patternId, {double minSimilarity, int? limit})` taking a **String ID**

Also, repository returns `Result<List<Pattern>>` but use case treats it as if it returns a single `Result<Pattern?>` (line 5409: `existing.valueOrNull != null` then `.copyWith`).

**Fix:** Either:
- (a) Change repo signature to `findSimilar(Pattern pattern)` returning `Result<Pattern?, AppError>`, OR
- (b) Change use case to `findSimilar(pattern.id)` and handle List return

---

### CRITICAL-5: ActivityLogRepository.getByExternalId — wrong arg count (line 6571 vs 11443)

**Severity:** CRITICAL — would not compile

Use case calls with 2 args: `getByExternalId(profileId, activity.externalId)`
Repository defines 3 args: `getByExternalId(String profileId, String importSource, String importExternalId)`

**Fix:** Update use case call to pass all 3: `getByExternalId(profileId, activity.source, activity.externalId)`

---

### HIGH-1: HealthInsight — missing `insightKey` field (lines 5583/5587 vs 9759-9776)

**Severity:** HIGH — entity missing field used for deduplication

`GenerateInsightsUseCase` references `i.insightKey` at lines 5583 and 5587 to deduplicate insights. But HealthInsight entity has NO `insightKey` field.

**Fix:** Add to HealthInsight entity: `required String insightKey, // Stable key for deduplication across generations`

---

### HIGH-2: HealthInsightRepository — missing getByProfile method (line 5578)

**Severity:** HIGH — use case calls method that doesn't exist in repo

Use case calls: `_insightRepository.getByProfile(input.profileId, includeDismissed: false)`
Repository (line 9891) only has: `getActive(profileId, {category, minPriority, limit})` and `dismiss(id)`

No `getByProfile` or `includeDismissed` parameter exists.

**Fix:** Either:
- (a) Add `getByProfile(String profileId, {bool includeDismissed})` to repo, OR
- (b) Change use case to use `getActive()` instead

---

### HIGH-3: LogFoodUseCase — silently drops mealType (line 2956 vs input line 2927)

**Severity:** HIGH — data silently lost

`LogFoodInput` has `MealType? mealType` (line 2927) but `LogFoodUseCase` doesn't pass it to `FoodLog()` construction (line 2956). The field is nullable so it compiles, but user-provided meal type is silently discarded.

**Fix:** Add `mealType: input.mealType,` to the FoodLog construction at line 2956.

---

### HIGH-4: SleepEntryRepository — missing getByExternalId method (line 6607)

**Severity:** HIGH — use case calls method not defined in repo

`_importSleep` calls `_sleepRepository.getByExternalId(profileId, sleep.externalId)` but SleepEntryRepository (lines 11505-11522) has no `getByExternalId` method.

**Fix:** Add `getByExternalId(String profileId, String importSource, String importExternalId)` to SleepEntryRepository (same signature as ActivityLogRepository).

---

## Minor Issues (LOW severity)

### LOW-1: _detectFlare references phantom `Severity` type (line 4635)
`_detectFlare(Severity severity, Condition condition)` — no `Severity` type exists. Uses `severity.toStorageScale()` which is on `ConditionSeverity`. And this method is never called.
**Fix:** Either remove or fix to `_detectFlare(ConditionSeverity severity, Condition condition)`.

### LOW-2: CreateConditionInput missing `triggers` field (line 4466-4478)
Entity has `@Default([]) List<String> triggers` but input doesn't expose it. Not a compile error (default applies), but users can't set triggers at creation time.
**Fix:** Add `@Default([]) List<String> triggers` to `CreateConditionInput` and pass to entity construction.

---

## Summary Table

| # | Location | Entity/Method | Issue | Severity |
|---|----------|---------------|-------|----------|
| C1 | 6507 vs 10902 | ImportedDataLog | Completely different schema (summary vs per-record) | CRITICAL |
| C2 | 6615 vs 11478 | SleepEntry | 4 wrong field names in _importSleep | CRITICAL |
| C3 | 6580 vs 11410 | ActivityLog | Missing required `adHocActivities` | CRITICAL |
| C4 | 5408 vs 9872 | PatternRepository.findSimilar | Object vs String param, List vs single return | CRITICAL |
| C5 | 6571 vs 11443 | ActivityLogRepository.getByExternalId | 2 args passed, 3 required | CRITICAL |
| H1 | 5583 vs 9759 | HealthInsight | Missing `insightKey` field | HIGH |
| H2 | 5578 vs 9891 | HealthInsightRepository | Missing `getByProfile` method | HIGH |
| H3 | 2956 vs 2927 | FoodLog/LogFoodUseCase | `mealType` silently dropped | HIGH |
| H4 | 6607 vs 11505 | SleepEntryRepository | Missing `getByExternalId` method | HIGH |
| L1 | 4635 | ConditionLog | Phantom `Severity` type | LOW |
| L2 | 4466 | CreateConditionInput | Missing `triggers` field | LOW |

---

## Relationship to Existing Fix Plan

These are **all new** — none overlap with the 35 items already in `.claude/plans/spec-review-fix-plan-post-phase2.md`.

Most of these are in the **Wearable import** (Section 4a.8) and **Intelligence** (Section 7.5a) subsystems, which were the last sections written and received less review.
