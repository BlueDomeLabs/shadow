# Plan: Fix Remaining Spec Violations Found by Post-Phase-2 Spec Review

## Context

After completing Phase 1-2 of the spec fix plan (~100 edits to 22_API_CONTRACTS.md), two `/spec-review` passes found remaining violations. This plan captures all findings with user-approved decisions.

**Source:** Post-Phase-2 spec-review audits (2026-02-08)
**Baseline:** 1205 tests passing, 0 analyzer issues, Phase 1-2 committed as b372957
**Convergence audit report:** `.claude/audit-reports/2026-02-08-spec-review-convergence.md`

---

## User Decisions (RESOLVED)

The following decisions were made by the user on 2026-02-08:

1. **TrendGranularity, TrendDirection, ConflictResolution** — NOT database-persisted (query params / computed results / command params). Exempt from Rule 9.1.1. **No int values needed.**
2. **UserAccount field name** — Use `avatarUrl` (matches OAuth terminology). Fix entity definition from `photoUrl` to `avatarUrl`.
3. **Entity-DB mapping mismatches** — Entity definitions (Section 10) are canonical. Update all mapping tables (Section 13) to match entities.
4. **FoodItem servingSize** — Keep as `String?` per entity definition. Update mapping table to match.

---

## CRITICAL: Error Type Violations (5 items)

### Fix 1: StateError in fluids provider (line 8609)
- **Current:** `return Failure(StateError('No fluids state available'));`
- **Fix:** `return Failure(BusinessError.invalidState('FluidsEntry', 'null', 'initialized'));`

### Fix 2: StateError in fluids provider (line 8656)
- **Current:** `if (current == null) return Failure(StateError('No state'));`
- **Fix:** `if (current == null) return Failure(BusinessError.invalidState('FluidsEntry', 'null', 'initialized'));`

### Fix 3: StateError in sync provider (line 9006)
- **Current:** `if (current == null) return Failure(StateError('No sync state'));`
- **Fix:** `if (current == null) return Failure(BusinessError.invalidState('SyncState', 'null', 'initialized'));`

### Fix 4: StateError in sync provider (line 9039)
- **Current:** `if (current == null) return Failure(StateError('No sync state'));`
- **Fix:** `if (current == null) return Failure(BusinessError.invalidState('SyncState', 'null', 'initialized'));`

### Fix 5: UnknownError in screen error handler (line 9226)
- **Current:** `error: error is AppError ? error : UnknownError(error.toString()),`
- **Fix:** `error: error is AppError ? error : BusinessError.unexpected(error.toString()),`

---

## HIGH: Unchecked Result Operations (7 items)

### Fix 6: ActivateDietUseCase unchecked update (line 5022)
- **Current:** `await _dietRepository.update(currentActive.copyWith(...));`
- **Fix:** `final deactivateResult = await _dietRepository.update(currentActive.copyWith(...)); if (deactivateResult.isFailure) return Failure(deactivateResult.errorOrNull!);`

### Fix 7: AnalyzeTriggersUseCase unchecked upsert (line 5509, in loop)
- **Current:** `await _correlationRepository.upsert(correlation);`
- **Fix:** `final upsertResult = await _correlationRepository.upsert(correlation); if (upsertResult.isFailure) return Failure(upsertResult.errorOrNull!);`

### Fix 8: GenerateInsightsUseCase unchecked create (line 5592, in loop)
- **Current:** `await _insightRepository.create(insight);`
- **Fix:** `final createResult = await _insightRepository.create(insight); if (createResult.isFailure) return Failure(createResult.errorOrNull!);`

### Fix 9: GeneratePredictiveAlertsUseCase unchecked create (line 5729, in loop)
- **Current:** `await _alertRepository.create(alert);`
- **Fix:** `final createResult = await _alertRepository.create(alert); if (createResult.isFailure) return Failure(createResult.errorOrNull!);`

### Fix 10: SyncWearableDataUseCase unchecked create (line 6524)
- **Current:** `await _importLogRepository.create(importLog);`
- **Fix:** `final importResult = await _importLogRepository.create(importLog); if (importResult.isFailure) return Failure(importResult.errorOrNull!);`

### Fix 11: Auth use case unchecked update (line 6756)
- **Current:** `await _userRepository.update(user.copyWith(...));`
- **Fix:** `final updateResult = await _userRepository.update(user.copyWith(...)); if (updateResult.isFailure) return Failure(updateResult.errorOrNull!);`

### Fix 12: Auth use case unchecked create (line 6811)
- **Current:** `await _profileRepository.create(defaultProfile);`
- **Fix:** `final profileResult = await _profileRepository.create(defaultProfile); if (profileResult.isFailure) return Failure(profileResult.errorOrNull!);`

---

## HIGH: DateTime.now() Violations (2 items)

### Fix 13: DetectPatternsUseCase DateTime.now() in loop (line 5413)
- **Current:** `lastObservedAt: DateTime.now().millisecondsSinceEpoch,` (inside loop)
- **Fix:** `lastObservedAt: now,` (use pre-computed `now` from line 5349)

### Fix 14: ToggleNotificationUseCase missing pre-computation (line 6248)
- **Current:** `syncUpdatedAt: DateTime.now().millisecondsSinceEpoch,` (no pre-computed `now`)
- **Fix:** Add `final now = DateTime.now().millisecondsSinceEpoch;` after authorization check (~line 6231), then use `now` at line 6248

---

## HIGH: Duplicate Definitions (1 item)

### Fix 15: SupplementList defined 3 times (lines 7879, 8246, 13618)
- **Fix:** Keep canonical at line 8246. Replace lines 7879 and 13618 with:
  `// SupplementList: See Section 7.2 (line ~8246) for canonical definition`

---

## HIGH: UserAccount Field Name Mismatch (1 item)

### Fix 16: Entity uses `photoUrl`, use case uses `avatarUrl` (USER DECISION: use `avatarUrl`)
- **Entity (line 11732):** Change `String? photoUrl,` to `String? avatarUrl,`
- **DB mapping 13.8:** Add `avatarUrl | avatar_url | String? | TEXT | Direct` row
- **Rationale:** `avatarUrl` matches Google/Apple OAuth terminology

---

## HIGH: Entity-DB Mapping Fixes (update mappings to match entities)

### Fix 17: IntakeLog mapping table 13.12 (lines 12715-12716)
- **Current:** `timestamp | timestamp` and `intakeTime | intake_time | IntakeTime | INTEGER`
- **Fix:** Update to match entity (line 11187-11192):
  - `scheduledTime | scheduled_time | int | INTEGER | Epoch ms`
  - `actualTime | actual_time | int? | INTEGER | Epoch ms`
  - `status | status | IntakeLogStatus | INTEGER | .value (0-4)`
  - `reason | reason | String? | TEXT | Direct`
  - `note | note | String? | TEXT | Direct`
  - `snoozeDurationMinutes | snooze_duration_minutes | int? | INTEGER | Direct`
- Remove `intakeTime` / `IntakeTime` row (not in entity)

### Fix 18: Document mapping table 13.19 (lines 12827-12831)
- **Current:** `filename`, `type`, `local_path`
- **Fix:** Update to match entity (lines 11833-11835):
  - `name | name | String | TEXT | Direct`
  - `documentType | document_type | DocumentType | INTEGER | .value`
  - `filePath | file_path | String | TEXT | Direct`
- Add missing entity fields: `notes`, `documentDate`

### Fix 19: UserAccount mapping table 13.8 (lines 12640-12653)
- **Current:** Missing `clientId`, has `role` (not in entity), uses `externalId` instead of `authProviderId`
- **Fix:** Update to match entity (lines 11727-11740):
  - Add `clientId | client_id | String | TEXT | Direct`
  - Change `externalId | external_id` to `authProviderId | auth_provider_id | String | TEXT | OAuth provider user ID`
  - Remove `role` row (not in entity definition)
  - Change `photoUrl` references to `avatarUrl` per Fix 16
  - Add `avatarUrl | avatar_url | String? | TEXT | Direct`
  - Add `deactivatedReason | deactivated_reason | String? | TEXT | Direct`

### Fix 20: FoodItem mapping table 13.13 (lines 12733-12734)
- **Current:** `servingSize | serving_size | double? | REAL` + `servingUnit | serving_unit | String? | TEXT`
- **Fix:** Update to match entity (line 11260):
  - `servingSize | serving_size | String? | TEXT | e.g., "1 cup", "100g"`
  - Remove `servingUnit` row (not in entity)

### Fix 21: DeviceRegistration mapping table 13.11 note (line 12693)
- **Current:** `deviceType | device_type | DeviceType | TEXT | .name`
- **Fix:** Add clarifying note: "DeviceType enum has int values for internal use, but DB stores as TEXT .name for human-readable device queries. This is an intentional exception to Rule 9.1.1 — device type queries benefit from readable TEXT values."

---

## MEDIUM: Cross-Reference Accuracy (4 items)

### Fix 22: Diet entity cross-ref (line 13583)
- **Current:** "See Section 8.3 (line ~9254)"
- **Fix:** "See Section 7.5 (line ~9355)"

### Fix 23: ComplianceCheckResult cross-ref (line 13580)
- **Current:** "See Section 8.3 (line ~9447)"
- **Fix:** "See Section 7.5 (line ~9548)"

### Fix 24: CreateDietInput cross-ref (line 13577)
- **Current:** "See Section 8.4 (line ~10128)"
- **Fix:** "See Section 7.7 (line ~10229)"

### Fix 25: SupplementList stub cross-ref (line 13621)
- **Current:** "See Section 7 (line ~7766)"
- **Fix:** "See Section 7.2 (line ~8246)"

---

## MEDIUM: Section Numbering Duplicates (2 items)

### Fix 26: Duplicate "Section 4" (lines 1667 and 2013)
- **Issue:** Two sections both numbered "## 4"
- Line 1667: "## 4. Repository Interface Contracts"
- Line 2013: "## 4. Use Case Contracts"
- **Fix:** Renumber line 2013 to "## 4a. Use Case Contracts"

### Fix 27: Duplicate "Section 7.5" (lines 9347 and 9675)
- **Issue:** Two subsections both numbered "## 7.5"
- Line 9347: "## 7.5 Diet Entity Contracts"
- Line 9675: "## 7.5 Intelligence System Contracts (Phase 3)"
- **Fix:** Renumber line 9675 to "## 7.5a Intelligence System Contracts (Phase 3)"

---

## CRITICAL: Entity Definition vs Use Case Code Contradictions (2 items)

### Fix 28: Profile entity missing 3 fields used in auth use case (line 6798-6804)
- **Auth use case constructs Profile with:**
  - `userId: user.id` — but entity (line 11011) has `ownerId`, not `userId`
  - `isDefault: true` — field does NOT exist in entity (lines 11003-11016)
  - `avatarUrl: googleUser.avatarUrl` — field does NOT exist in entity
- **Profile mapping table 13.9** also missing `isDefault` and `avatarUrl`
- **Fix (entity definition, lines 11003-11016):**
  - Add `@Default(false) bool isDefault,` field
  - Add `String? avatarUrl,` field
  - Keep `ownerId` as-is (it's correct), fix use case line 6801 from `userId: user.id` to `ownerId: user.id`
- **Fix (mapping table 13.9):**
  - Add `isDefault | is_default | bool | INTEGER | 0/1`
  - Add `avatarUrl | avatar_url | String? | TEXT | Direct`
- **Fix (ProfileProvider, line 8143):** Already uses `p.isDefault` — will compile once entity has the field

### Fix 29: Pattern entity missing 3 fields used in DetectPatternsUseCase (lines 5403, 5412-5414)
- **Use case references:**
  - `p.relatedConditionId` (line 5403) — NOT in Pattern entity (lines 9685-9700)
  - `lastObservedAt:` (line 5413) — NOT in Pattern entity
  - `observationCount:` (line 5414) — NOT in Pattern entity
- **Fix (Pattern entity definition, after line 9698):**
  - Add `String? relatedConditionId,   // FK to condition this pattern relates to`
  - Add `int? lastObservedAt,          // Epoch milliseconds - last time pattern was observed`
  - Add `@Default(1) int observationCount,  // Number of times pattern observed`
- **Fix (mapping table 13.29):**
  - Add `relatedConditionId | related_condition_id | String? | TEXT | FK to conditions`
  - Add `lastObservedAt | last_observed_at | int? | INTEGER | Epoch ms`
  - Add `observationCount | observation_count | int | INTEGER | Default 1`

---

## HIGH: Additional Entity-DB Mapping Contradictions (5 items)

### Fix 30: FoodLog mapping missing `mealType` (line 12743-12754)
- **Entity (line 11330):** `MealType? mealType`
- **Mapping table 13.14:** No `mealType` field
- **Fix:** Add row: `mealType | meal_type | MealType? | INTEGER | .value (0=breakfast, 1=lunch, 2=dinner, 3=snack)`

### Fix 31: JournalEntry mapping missing `mood` (line 12806-12818)
- **Entity (line 11541):** `int? mood  // Mood rating 1-10, optional`
- **Mapping table 13.18:** No `mood` field
- **Fix:** Add row: `mood | mood | int? | INTEGER | 1-10 scale`

### Fix 32: Condition mapping missing `triggers`, wrong `status` storage format (lines 12841-12862)
- **Missing field:** Entity (line 11065) has `@Default([]) List<String> triggers` but mapping has no `triggers` row
- **Wrong storage format:** Mapping (line 12855) stores `ConditionStatus` as `TEXT 'active' | 'resolved'`, but entity enum has explicit int values (`active(0), resolved(1)`)
- **Fix:**
  - Add row: `triggers | triggers | List<String> | TEXT | JSON array (default: [])`
  - Change status row to: `status | status | ConditionStatus | INTEGER | .value (0=active, 1=resolved)`

### Fix 33: Supplement mapping stores enums as TEXT instead of INTEGER (lines 12509, 12512)
- **Current:**
  - `form | form | SupplementForm | TEXT | .name`
  - `dosageUnit | dosage_unit | DosageUnit | TEXT | .name`
- **Both enums have explicit int values** (SupplementForm: 0-6, DosageUnit: 0-8)
- **Fix:**
  - `form | form | SupplementForm | INTEGER | .value (0=capsule, 1=powder, ..., 6=other)`
  - `dosageUnit | dosage_unit | DosageUnit | INTEGER | .value (0=g, 1=mg, ..., 8=custom)`

### Fix 34: HealthInsight mapping has AlertPriority int values backwards (line 13038)
- **Current:** `priority | priority | AlertPriority | INTEGER | .value (0=high, 1=medium, 2=low)`
- **Actual enum:** `low(0), medium(1), high(2), critical(3)`
- **Fix:** `priority | priority | AlertPriority | INTEGER | .value (0=low, 1=medium, 2=high, 3=critical)`

---

## HIGH: Use Case Field Name Mismatch (1 item)

### Fix 35: Auth use case uses `userId` instead of `ownerId` for Profile (line 6801)
- **Current:** `userId: user.id,`
- **Fix:** `ownerId: user.id,`
- **Note:** This is part of Fix 28 but listed separately since it's a different location (use case code vs entity definition)

---

## CRITICAL: Use Case vs Entity/Repository Contradictions — Wearable & Intelligence (9 items)

### Fix 36: ImportedDataLog — completely different schema in use case vs entity (lines 6507-6523 vs 10902-10914)
- **Use case constructs ImportedDataLog as a summary object:**
  - `source: input.platform.name` (String), `recordCount`, `skippedCount`, `errorCount`, `syncRangeStart`, `syncRangeEnd`
- **Entity definition is a per-record log:**
  - `sourcePlatform` (WearablePlatform enum), `sourceRecordId` (required), `targetEntityType` (required), `targetEntityId` (required), `sourceTimestamp` (required)
- **Fix:** The use case design (import session summary) is more practical for the sync flow. Update the entity definition to match the use case:
  - Change `sourcePlatform: WearablePlatform` to `source: String` (platform name)
  - Replace `sourceRecordId`, `targetEntityType`, `targetEntityId`, `sourceTimestamp` with `recordCount: int`, `skippedCount: int`, `errorCount: int`, `syncRangeStart: int`, `syncRangeEnd: int`
  - Remove `rawData`
  - Update mapping table accordingly

### Fix 37: SleepEntry — _importSleep uses 4 wrong field names (lines 6615-6630)
- **Use case uses:** `sleepStart`, `sleepEnd`, `quality`, `externalId`
- **Entity has:** `bedTime`, `wakeTime`, *(no quality field)*, `importExternalId`
- **Fix (use case code):**
  - Line 6619: Change `sleepStart: sleep.sleepStart` to `bedTime: sleep.sleepStart`
  - Line 6620: Change `sleepEnd: sleep.sleepEnd` to `wakeTime: sleep.sleepEnd`
  - Line 6621: Remove `quality: sleep.quality` (no equivalent entity field)
  - Line 6623: Change `externalId: sleep.externalId` to `importExternalId: sleep.externalId`
  - Line 6624: Keep `importSource: sleep.source` (correct)

### Fix 38: ActivityLog — _importActivity missing required `adHocActivities` (line 6580-6595)
- **Entity (line 11416):** `required List<String> adHocActivities` — no @Default, so it's required
- **Use case (line 6580):** Doesn't pass `adHocActivities` to ActivityLog constructor
- **Fix:** Add `adHocActivities: [],` to the _importActivity ActivityLog construction after line 6585

### Fix 39: PatternRepository.findSimilar — signature mismatch (line 5408 vs 9872-9876)
- **Use case (line 5408):** `_patternRepository.findSimilar(pattern)` — passes a Pattern object
- **Repository (line 9872):** `findSimilar(String patternId, {double minSimilarity, int? limit})` — expects String ID, returns `Result<List<Pattern>>`
- **Use case also treats result as single Pattern (line 5409):** `existing.valueOrNull != null` then `.copyWith`
- **Fix (repository definition):** Change signature to:
  ```
  Future<Result<Pattern?, AppError>> findSimilar(Pattern pattern);
  ```
  This matches the use case semantics: "find an existing pattern similar to this one, return it or null"

### Fix 40: ActivityLogRepository.getByExternalId — wrong arg count (line 6571 vs 11443)
- **Use case (line 6571):** `getByExternalId(profileId, activity.externalId)` — 2 args
- **Repository (line 11443):** `getByExternalId(String profileId, String importSource, String importExternalId)` — 3 args
- **Fix (use case code):** Change to `getByExternalId(profileId, activity.source, activity.externalId)`

### Fix 41: HealthInsight — missing `insightKey` field (lines 5583/5587 vs 9759-9776)
- **Use case references:** `i.insightKey` at lines 5583 and 5587 for deduplication
- **Entity definition (9759-9776):** No `insightKey` field
- **Fix (entity definition):** Add `required String insightKey,  // Stable key for deduplication across generations` after line 9766

### Fix 42: HealthInsightRepository — missing `getByProfile` method (line 5578 vs 9891-9899)
- **Use case (line 5578):** `_insightRepository.getByProfile(input.profileId, includeDismissed: false)`
- **Repository (lines 9891-9899):** Only has `getActive(...)` and `dismiss(...)` — no `getByProfile`
- **Fix (repository definition):** Add method after line 9897:
  ```
  Future<Result<List<HealthInsight>, AppError>> getByProfile(
    String profileId, {
    bool includeDismissed = false,
  });
  ```

### Fix 43: SleepEntryRepository — missing `getByExternalId` method (line 6607 vs 11505-11522)
- **Use case (line 6607):** `_sleepRepository.getByExternalId(profileId, sleep.externalId)`
- **Repository (lines 11505-11522):** No `getByExternalId` method
- **Fix (repository definition):** Add method after line 11521:
  ```
  Future<Result<SleepEntry?, AppError>> getByExternalId(
    String profileId,
    String importSource,
    String importExternalId,
  );
  ```
  Also fix the use case call (line 6607) to pass 3 args: `getByExternalId(profileId, sleep.source, sleep.externalId)`

### Fix 44: LogFoodUseCase — silently drops `mealType` from input (line 2956 vs input line 2927)
- **LogFoodInput (line 2927):** has `MealType? mealType`
- **FoodLog construction (line 2956):** does NOT pass `mealType` to entity
- **Fix:** Add `mealType: input.mealType,` to the FoodLog construction after line 2960

---

## LOW: Minor Use Case Issues (2 items)

### Fix 45: _detectFlare references phantom `Severity` type (line 4635)
- **Current:** `bool _detectFlare(Severity severity, Condition condition)` — `Severity` type doesn't exist
- **Also calls:** `severity.toStorageScale()` which is on `ConditionSeverity`, not `Severity`
- **Method is never called** from the use case code above it
- **Fix:** Change to `bool _detectFlare(ConditionSeverity severity, Condition condition)` or remove dead method

### Fix 46: CreateConditionInput missing `triggers` field (line 4466-4478)
- **Entity (line 11065):** `@Default([]) List<String> triggers`
- **Input:** No `triggers` field — users can't set triggers at creation time
- **Fix:** Add `@Default([]) List<String> triggers,` to CreateConditionInput and pass to entity construction

---

## REMOVED: Items Not Needing Fixes

### Removed: Enum int values for TrendGranularity, TrendDirection, ConflictResolution
- **Reason:** User confirmed these are NOT database-persisted. Exempt from Rule 9.1.1.
  - TrendGranularity: query parameter in GetConditionTrendInput
  - TrendDirection: computed output in ConditionTrend result
  - ConflictResolution: command parameter in ResolveConflictInput

### Removed: DateTime.now() style (DateTime object vs int)
- **Reason:** `final now = DateTime.now();` followed by `now.millisecondsSinceEpoch` is correct per Rule 5.2.1. Pre-computing the DateTime object satisfies the rule.

---

## Execution Strategy

**Phase 1: Error types (Fixes 1-5)** — 5 simple text replacements
**Phase 2: Unchecked Results (Fixes 6-12)** — 7 edits adding result capture + failure checks
**Phase 3: DateTime (Fixes 13-14)** — 2 edits
**Phase 4: Duplicates + field names (Fixes 15-16)** — Remove duplicate definitions, fix avatarUrl
**Phase 5: Entity definition gaps (Fixes 28-29, 41)** — Add missing fields to Profile, Pattern, HealthInsight entities
**Phase 6: Use case field name fixes (Fixes 35, 37, 40, 44)** — Fix field names and missing args in use case code
**Phase 7: Mapping tables (Fixes 17-21, 30-34)** — 10 table updates in Section 13
**Phase 8: Cross-refs + numbering (Fixes 22-27)** — 6 low-risk formatting edits
**Phase 9: Wearable import contradictions (Fixes 36, 38, 43)** — Fix ImportedDataLog entity, add missing fields/methods
**Phase 10: Repository signature fixes (Fixes 39, 42)** — Fix findSimilar signature, add getByProfile
**Phase 11: Minor cleanups (Fixes 45-46)** — Fix phantom type, add triggers to input

**All changes are spec-text-only.** No implementation code changes needed. No tests affected.

---

## Estimated Scope

- 46 targeted edits to 22_API_CONTRACTS.md
- 0 implementation changes
- 0 test changes
- Expected next /spec-review result: 0 violations
