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

## CRITICAL: Auth & Wearable Error Factory + Input Contradictions (8 items)

### Fix 47: UserAccount entity — `lastLoginAt` should be `lastSignInAt` (line 11736 vs 6757/6780)
- **Entity (line 11736):** `int? lastLoginAt,`
- **Use case (lines 6757, 6780):** `lastSignInAt: now,`
- **Fix:** Change entity field from `lastLoginAt` to `lastSignInAt` (OAuth uses "sign in", not "login")
- **Also update mapping table** if it references `lastLoginAt`

### Fix 48: AuthError — missing `invalidToken` factory (line 6732)
- **Use case:** `AuthError.invalidToken('Google token verification failed')`
- **AuthError class (253-302):** No such factory
- **Fix:** Add after line 271 (after `tokenExpired`):
  ```dart
  static const String codeInvalidToken = 'AUTH_INVALID_TOKEN';

  factory AuthError.invalidToken(String reason) => AuthError._(
    code: codeInvalidToken,
    message: 'Invalid token: $reason',
    userMessage: 'Authentication failed. Please sign in again.',
  );
  ```

### Fix 49: AuthError — missing `accountDeactivated` factory (line 6753)
- **Use case:** `AuthError.accountDeactivated(user.deactivatedReason)`
- **AuthError class (253-302):** No such factory
- **Fix:** Add after `invalidToken` factory:
  ```dart
  static const String codeAccountDeactivated = 'AUTH_ACCOUNT_DEACTIVATED';

  factory AuthError.accountDeactivated(String? reason) => AuthError._(
    code: codeAccountDeactivated,
    message: 'Account deactivated: ${reason ?? 'No reason given'}',
    userMessage: 'This account has been deactivated.',
    isRecoverable: false,
    recoveryAction: RecoveryAction.none,
  );
  ```

### Fix 50: SyncWearableDataInput — missing 4 fields used by use case (line 10188 vs 6438-6467)
- **Input (10188-10193):** Only has `{profileId, platform, sinceEpoch}`
- **Use case references:** `input.clientId` (6467), `input.startDate` (6438), `input.endDate` (6440), `input.dataTypes` (6448)
- **Fix:** Replace input definition with:
  ```dart
  const factory SyncWearableDataInput({
    required String profileId,
    required String clientId,
    required WearablePlatform platform,
    int? startDate,          // Epoch ms, null uses connection.lastSyncAt
    int? endDate,            // Epoch ms, null uses current time
    @Default([]) List<String> dataTypes,  // Empty = use connection.readPermissions
  }) = _SyncWearableDataInput;
  ```

### Fix 51: ConnectWearableInput — missing `enableBackgroundSync` field (line 10167 vs 6336)
- **Input (10167-10173):** `{profileId, clientId, platform, requestedPermissions}`
- **Use case (line 6336):** `backgroundSyncEnabled: input.enableBackgroundSync`
- **Fix:** Add `@Default(false) bool enableBackgroundSync,` to ConnectWearableInput

### Fix 52: WearableError — missing `notConnected` factory (line 6433)
- **Use case:** `WearableError.notConnected(input.platform)`
- **WearableError class (555-637):** No such factory
- **Fix:** Add `notConnected` factory and `codeNotConnected` constant:
  ```dart
  static const String codeNotConnected = 'WEARABLE_NOT_CONNECTED';

  factory WearableError.notConnected(String platform) =>
    WearableError._(
      code: codeNotConnected,
      message: '$platform is not connected',
      userMessage: '$platform is not connected. Please connect first.',
    );
  ```

### Fix 53: WearableError.platformNotAvailable — wrong factory name in use case (line 6301)
- **Use case (line 6301):** `WearableError.platformNotAvailable(input.platform)`
- **Actual factory (line 589):** `WearableError.platformUnavailable(platform)`
- **Fix:** Change use case to `WearableError.platformUnavailable(input.platform.name)`

### Fix 54: WearableError.permissionsDenied — wrong name + wrong arg count (line 6315)
- **Use case (line 6315):** `WearableError.permissionsDenied(input.platform)` — 1 arg, plural
- **Actual factory (line 631):** `WearableError.permissionDenied(String platform, String permission)` — 2 args, singular
- **Fix:** Change to `WearableError.permissionDenied(input.platform.name, 'health data access')`

---

## CRITICAL: Intelligence & Sync Subsystem Contradictions (6 items)

### Fix 55: ConditionLogRepository.getByCondition — missing startDate/endDate params (line 11147 vs 4729/5460/4654)
- **Repo (11147-11151):** `getByCondition(String conditionId, {int? limit, int? offset})` — no date filtering
- **Use case (4729-4732):** `getByCondition(input.conditionId, startDate: ..., endDate: ...)` — named date params
- **Use case (5460-5463):** Same pattern
- **Use case (4654):** `getByCondition(input.profileId, input.conditionId, input.startDate, input.endDate)` — 4 positional args (WRONG), also passes profileId first (should be conditionId)
- **Fix (repo):** Add `startDate`/`endDate` to signature:
  ```dart
  Future<Result<List<ConditionLog>, AppError>> getByCondition(
    String conditionId, {
    int? startDate,    // Epoch ms
    int? endDate,      // Epoch ms
    int? limit,
    int? offset,
  });
  ```
- **Fix (line 4654):** Change to `_repository.getByCondition(input.conditionId, startDate: input.startDate, endDate: input.endDate)`

### Fix 56: NetworkError.rateLimited — factory doesn't exist (lines 5647, 6417, 6928, 7017)
- **4 call sites** use `NetworkError.rateLimited(operation, duration)`
- **NetworkError class (333-353):** Only has `noConnection`, `timeout`, `serverError`, `sslError`
- **Fix:** Add factory and constant to NetworkError (after line 353):
  ```dart
  static const String codeRateLimited = 'NETWORK_RATE_LIMITED';

  factory NetworkError.rateLimited(String operation, Duration retryAfter) => NetworkError._(
    code: codeRateLimited,
    message: '$operation rate limited, retry after ${retryAfter.inSeconds}s',
    userMessage: 'Too many requests. Please wait a moment.',
    isRecoverable: true,
    recoveryAction: RecoveryAction.retry,
  );
  ```

### Fix 57: MLModelRepository.getActiveModels — method doesn't exist (line 5654)
- **Use case (5654):** `_mlModelRepository.getActiveModels(input.profileId)`
- **Repo (11914-11925):** Only has `getLatest`, `getByProfile`, `save`, `delete`, `deleteOldVersions`
- **Fix:** Change use case call to `_mlModelRepository.getByProfile(input.profileId)` (functionally equivalent)

### Fix 58: SleepEntryRepository — missing getByDateRange method (line 5787)
- **Use case (5787):** `_sleepRepository.getByDateRange(input.profileId, startDate, now)`
- **Repo (11505-11522):** Only has `getByProfile`, `getForNight`, `getAverages`
- **Fix:** Add to SleepEntryRepository (after line 11521):
  ```dart
  Future<Result<List<SleepEntry>, AppError>> getByDateRange(
    String profileId,
    int startDate,  // Epoch ms
    int endDate,    // Epoch ms
  );
  ```

### Fix 59: RateLimitOperation — missing `prediction` enum value (line 5641/5735)
- **Use case:** `RateLimitOperation.prediction`
- **Enum (10522-10527):** Has `sync`, `photoUpload`, `reportGeneration`, `dataExport`, `wearableSync` — NO `prediction`
- **Fix:** Add to enum: `prediction(1, Duration(minutes: 1)),  // 1 per minute`

### Fix 60: GetConditionLogsUseCase — passes profileId where conditionId expected (line 4654)
- **Current (4654):** `_repository.getByCondition(input.profileId, input.conditionId, ...)`
- **Repo signature:** First positional param is `conditionId`, not `profileId`
- **Fix:** Combined with Fix 55 — change to `_repository.getByCondition(input.conditionId, startDate: input.startDate, endDate: input.endDate)`

---

## CRITICAL: Provider Layer + Missing Class Definitions (9 items)

### Fix 61: Profile entity — missing `waterGoalMl` field (line 11000 vs 8589)
- **Provider (8589):** `currentProfile?.waterGoalMl ?? 2500`
- **Entity (11000-11032):** No `waterGoalMl` field
- **Fix:** Add `@Default(2500) int waterGoalMl,` to Profile entity after line 11015

### Fix 62: SupplementList.addSupplement — passes Supplement instead of CreateSupplementInput (line 7898)
- **Provider (7896-7898):** `addSupplement(Supplement supplement)` → `useCase(supplement)`
- **Use case (4177):** `CreateSupplementUseCase implements UseCase<CreateSupplementInput, Supplement>`
- **Fix:** Change method signature and body:
  ```dart
  Future<Result<Supplement, AppError>> addSupplement(CreateSupplementInput input) async {
    final useCase = ref.read(createSupplementUseCaseProvider);
    final result = await useCase(input);
  ```

### Fix 63: GetConditionsInput — no `activeOnly` field (line 8421 vs 4432)
- **Provider (8419-8422):** `GetConditionsInput(profileId: profileId, activeOnly: true)`
- **Input (4432-4438):** Has `ConditionStatus? status` and `bool includeArchived`, NOT `activeOnly`
- **Fix:** Change provider to `GetConditionsInput(profileId: profileId, status: ConditionStatus.active)`

### Fix 64: GetNotificationSchedulesInput — class undefined (line 8718)
- **Provider (8718):** `GetNotificationSchedulesInput(profileId: profileId)`
- **Nowhere:** Class is never defined
- **Fix:** Add to notification input section:
  ```dart
  @freezed
  class GetNotificationSchedulesInput with _$GetNotificationSchedulesInput {
    const factory GetNotificationSchedulesInput({
      required String profileId,
      NotificationType? type,
      @Default(false) bool enabledOnly,
    }) = _GetNotificationSchedulesInput;
  }
  ```

### Fix 65: Profile use case layer — 5 use cases + 3 input classes entirely missing
- **Provider references:** `createProfileUseCaseProvider` (8176), `updateProfileUseCaseProvider` (8661), `deleteProfileUseCaseProvider` (8210), `setCurrentProfileUseCaseProvider` (8170), `getCurrentUserUseCaseProvider` (8869)
- **Input classes needed:** `CreateProfileInput`, `UpdateProfileInput` (with `waterGoalMl`), `DeleteProfileInput`
- **Fix:** Add a "Profile Use Cases" section with all 5 use case stubs and 3 input classes. This is a larger addition (~60-80 lines).

### Fix 66: getAccessibleProfiles — returns ProfileAccess not Profile (line 8139 vs 10477)
- **Provider (8139-8145):** Calls `getAccessibleProfilesUseCase()`, uses result as `List<Profile>` (accesses `p.isDefault`, `p.id`)
- **ProfileAuthorizationService (10477):** `getAccessibleProfiles()` returns `Result<List<ProfileAccess>, AppError>`
- **ProfileAccess (10486-10494):** Has `profileId`, `profileName`, `accessLevel` — not `id`, `isDefault`
- **Fix:** The use case should fetch Profile entities, not ProfileAccess. Change provider to use a dedicated use case that: fetches ProfileAccess list → for each, loads Profile by profileId. Define this in Fix 65.

### Fix 67: DietViolation — missing `wasDismissed` field (lines 5232-5233 vs 9454-9472)
- **Use case (5232-5233):** `v.wasDismissed != true` and `v.wasDismissed == true`
- **Entity (9454-9472):** No `wasDismissed` field
- **Fix:** Add `@Default(false) bool wasDismissed,` to DietViolation entity after line 9467

### Fix 68: SyncConflict — class referenced but never defined (lines 6897, 6985)
- **PushChangesResult (6897):** `required List<SyncConflict> conflicts`
- **PullChangesResult (6985):** `required List<SyncConflict> conflicts`
- **Fix:** Add class definition:
  ```dart
  @freezed
  class SyncConflict with _$SyncConflict {
    const factory SyncConflict({
      required String id,
      required String entityType,
      required String entityId,
      required String localVersion,
      required String remoteVersion,
      required int localUpdatedAt,    // Epoch ms
      required int remoteUpdatedAt,   // Epoch ms
      ConflictResolution? resolution,
    }) = _SyncConflict;
  }
  ```

### Fix 69: PreLogComplianceCheck — passes DateTime instead of int to service method (line 5085-5086)
- **Line 5085:** `final logTime = DateTime.fromMillisecondsSinceEpoch(input.logTimeEpoch);`
- **Line 5086:** `checkFoodAgainstRules(food, diet.rules, logTime)` — passes DateTime
- **Line 9590 (same service):** `checkFoodAgainstRules(input.foodItem, diet.rules, input.logTimeEpoch)` — passes int
- **Fix:** Remove line 5085 and change line 5086 to: `checkFoodAgainstRules(food, diet.rules, input.logTimeEpoch)`

---

## Pass 6 Findings: Service Interfaces + Intelligence Input/Output Mismatches (9 items)

### Fix 70: 12 Service Interfaces Used But Never Defined (MEGA-GAP — add new Section 11)
- **Issue:** 12 abstract service classes are used as constructor dependencies in ~20 use cases but never defined
- **Services (with methods extracted from usage):**
  1. `NotificationService` — scheduleNotifications(NotificationSchedule), cancelNotifications(String id), cancelAllNotifications(), showNow(QueuedNotification)
  2. `WearablePlatformService` — isAvailable(WearablePlatform), requestPermissions(WearablePlatform, List<String>), fetchData(...)
  3. `AuthTokenService` — storeTokens({userId, accessToken, refreshToken}), clearTokens()
  4. `SyncService` — pushPendingChanges(), getPendingChanges(String profileId, {int? limit}), pushChanges(List<SyncChange>), getLastSyncVersion(String profileId), pullChanges(String profileId, {int? sinceVersion, int? limit}), applyChanges(String profileId, List<SyncChange>), resolveConflict(String conflictId, ConflictResolution resolution)
  5. `DeviceInfoService` — registerCurrentDevice(String userId), unregisterCurrentDevice()
  6. `GoogleAuthService` — verifyIdToken(String idToken) returns Result<GoogleUserInfo, AppError>
  7. `TriggerAnalysisService` — analyzeCorrelations({conditionLogs, foodLogs, timeWindows, minimumConfidence, minimumOccurrences})
  8. `InsightGeneratorService` — generateInsights({patterns, correlations, recentLogs, categories, maxInsights})
  9. `PredictionService` — predictFlareUps(...), predictMenstrualCycle(...), generateTriggerWarnings(...), predictMissedSupplements(...)
  10. `DataQualityService` — assessConditionLogging(logs, start, end), assessFoodLogging(...), assessSleepLogging(...), assessFluidsLogging(...), assessSupplementLogging(...), findGaps(timestamps, start, end, type), generateRecommendations(scores, gaps)
  11. `DietComplianceService` — checkFoodAgainstRules(foodItem, rules, logTimeEpoch), calculateImpact(profileId, violations)
  12. `PatternDetectionService` — detectPatterns({conditionLogs, foodLogs, sleepEntries, patternTypes, minimumConfidence})
- **Fix:** Add new "Section 11: Service Interface Contracts" to 22_API_CONTRACTS.md (~150-200 lines) defining all 12 abstract classes

### Fix 71: GrantedPermissions Type Never Defined (line 6312)
- **Line 6312:** `final grantedPermissions = permissionsResult.valueOrNull!;` — accesses `.read` and `.write` as `List<String>`
- **Fix:** Add class definition adjacent to WearablePlatformService:
  ```dart
  @freezed
  class GrantedPermissions with _$GrantedPermissions {
    const factory GrantedPermissions({
      required List<String> read,
      required List<String> write,
    }) = _GrantedPermissions;
  }
  ```

### Fix 72: GetPendingNotificationsUseCase — enabledOnly param doesn't exist (line 6070-6072)
- **Use case (6070-6072):** `_repository.getByProfile(input.profileId, enabledOnly: true)`
- **Repo (10363-10365):** `getByProfile(String profileId)` — no `enabledOnly` param
- **Repo (10368-10370):** `getEnabled(String profileId)` — correct method already exists
- **Fix:** Change line 6070-6072 to: `final schedulesResult = await _repository.getEnabled(input.profileId);`

### Fix 73: HealthInsightRepository.getByProfile — method doesn't exist (line 5578)
- **Use case (5578):** `_insightRepository.getByProfile(input.profileId, includeDismissed: false)`
- **Repo (9891-9899):** Only has `getActive(profileId, ...)` and `dismiss(id)`. No `getByProfile`.
- **Fix:** Change line 5578 to: `final existingResult = await _insightRepository.getActive(input.profileId);`

### Fix 74: DetectPatternsInput — 4 field names don't match use case (lines 5350/5383/5396/5400 vs 9913-9924)
- **Used in code / Exists in input:**
  - `lookbackDays` (5350) / has `startDate, endDate` — mismatch
  - `minimumDataPoints` (5383) / has `minimumOccurrences` — name mismatch
  - `minimumConfidence` (5396) / has `significanceThreshold` — name mismatch
  - `conditionIds` (5400) / NOT in input — missing field
- **Fix:** Update DetectPatternsInput definition (9913-9924) to use field names from use case code:
  - Replace `startDate`/`endDate` with `@Default(90) int lookbackDays`
  - Rename `minimumOccurrences` to `minimumDataPoints`
  - Rename `significanceThreshold` to `minimumConfidence`
  - Add `@Default([]) List<String> conditionIds`

### Fix 75: AnalyzeTriggersInput — 4 mismatches + nullable conflict (lines 5454-5498 vs 9929-9943)
- **Used in code / Exists in input:**
  - `conditionId` used as nullable (5459) / defined as `required String` — nullable conflict
  - `lookbackDays` (5455) / has `startDate, endDate` — mismatch
  - `timeWindowHours` (5494) / has `timeWindowsHours` — typo (extra 's')
  - `minimumConfidence` (5497) / has `significanceThreshold` — name mismatch
- **Fix:** Update AnalyzeTriggersInput (9929-9943):
  - Change `required String conditionId` to `String? conditionId`
  - Replace `startDate`/`endDate` with `@Default(90) int lookbackDays`
  - Rename `timeWindowsHours` to `timeWindowHours`
  - Rename `significanceThreshold` to `minimumConfidence`

### Fix 76: GenerateInsightsInput — categories vs insightTypes (line 5571 vs 9953)
- **Use case (5571):** `input.categories.isEmpty ? InsightCategory.values : input.categories`
- **Input (9953):** Has `insightTypes`, NOT `categories`
- **Fix:** Rename field in GenerateInsightsInput from `insightTypes` to `categories`:
  `@Default([]) List<InsightCategory> categories,`

### Fix 77: DataQualityReport Construction — 6 wrong names + 4 missing required fields (lines 5898-5905 vs 9969-9979)
- **Wrong field names:**
  - `overallScore` → entity has `overallQualityScore`
  - `scoresByDataType` → entity has `byDataType`
  - `analyzedFromEpoch` → DOES NOT EXIST in entity
  - `analyzedToEpoch` → DOES NOT EXIST in entity
- **Missing required fields:** `profileId`, `assessedAt`, `totalDaysAnalyzed`, `daysWithData`
- **Fix:** Update use case construction (5898-5905) to match entity:
  ```dart
  DataQualityReport(
    profileId: input.profileId,
    assessedAt: now,
    totalDaysAnalyzed: input.lookbackDays,
    daysWithData: scores.values.fold(0, (sum, q) => sum + q.daysWithData),
    overallQualityScore: overallScore,
    byDataType: scores,
    gaps: gaps,
    recommendations: recommendations,
  )
  ```

### Fix 78: QueuedNotification Construction — DateTime vs int + missing required fields (line 12329-12339)
- **Line 12333:** `queuedAt: DateTime.now()` — field is `int` (epoch ms per line 12266)
- **Missing:** `clientId` (required per 12262), `profileId` (required per 12263)
- **Fix:** Change construction (12329-12339) to:
  ```dart
  QueuedNotification(
    id: 'collapsed_${entry.key.name}',
    clientId: entry.value.first.clientId,
    profileId: entry.value.first.profileId,
    type: entry.key,
    originalScheduledTime: entry.value.first.originalScheduledTime,
    queuedAt: DateTime.now().millisecondsSinceEpoch,
    payload: { ... },
  )
  ```

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
**Phase 3: DateTime (Fixes 13-14, 69, 78)** — 4 edits (now includes QueuedNotification DateTime fix)
**Phase 4: Duplicates + field names (Fixes 15-16)** — Remove duplicate definitions, fix avatarUrl
**Phase 5: Entity definition gaps (Fixes 28-29, 41, 47, 61, 67)** — Add missing fields to Profile (waterGoalMl, isDefault, avatarUrl), Pattern, HealthInsight, UserAccount, DietViolation
**Phase 6: Use case/provider field name fixes (Fixes 35, 37, 40, 44, 53, 54, 57, 60, 62, 63, 72, 73, 77)** — Fix field names, wrong args, wrong types in use case + provider code. Now includes getEnabled fix, getActive fix, DataQualityReport construction fix.
**Phase 7: Mapping tables (Fixes 17-21, 30-34)** — 10 table updates in Section 13
**Phase 8: Cross-refs + numbering (Fixes 22-27)** — 6 low-risk formatting edits
**Phase 9: Wearable import contradictions (Fixes 36, 38, 43)** — Fix ImportedDataLog entity, add missing fields/methods
**Phase 10: Repository signature fixes (Fixes 39, 42, 55, 58)** — Fix findSimilar, add getByProfile, fix getByCondition params, add getByDateRange
**Phase 11: Missing error factories (Fixes 48-49, 52, 56)** — Add AuthError.invalidToken, AuthError.accountDeactivated, WearableError.notConnected, NetworkError.rateLimited
**Phase 12: Missing input fields + enum values (Fixes 50-51, 59, 64)** — Add fields to SyncWearableDataInput, ConnectWearableInput, GetNotificationSchedulesInput; add `prediction` to RateLimitOperation
**Phase 13: Missing class definitions (Fixes 65, 66, 68)** — Profile use case layer (5 use cases + 3 inputs), getAccessibleProfiles type fix, SyncConflict class
**Phase 14: Minor cleanups (Fixes 45-46)** — Fix phantom type, add triggers to input
**Phase 15: Intelligence input/output field mismatches (Fixes 74-76)** — Fix DetectPatternsInput (4 fields), AnalyzeTriggersInput (4 fields + nullable), GenerateInsightsInput (categories vs insightTypes)
**Phase 16: Service Interface Contracts — NEW SECTION (Fixes 70-71)** — Add Section 11 to 22_API_CONTRACTS.md defining all 12 service abstract classes (~150-200 lines). Also add GrantedPermissions type. **This is the largest single phase.**

**Total: 78 fixes across 16 phases. All changes are spec-text-only.** No implementation code changes needed. No tests affected.

---

## Estimated Scope

- 69 targeted edits to 22_API_CONTRACTS.md
- 0 implementation changes
- 0 test changes
- Expected next /spec-review result: 0 violations
