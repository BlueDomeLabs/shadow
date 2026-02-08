# Fresh Spec Audit - 2026-02-08 (Final - Pass 3 verified)
# Coding Standards v1.1 | Implementation Impact Verified | All Open Questions Resolved

## The Bottom Line

**~180 spec violations found. Only 3 require implementation changes + 1 new factory method.**

| Category | Count | Impl Changes? |
|----------|-------|--------------|
| Spec-only fixes (no code changes) | ~176 | NO |
| Implementation fixes needed | 3 | YES (WearablePlatform enum, SupplementIngredient ctor, SupplementSchedule ctor) |
| New factory method (spec + impl) | 1 | YES (NetworkError.rateLimited) |

### Pass Convergence (5 passes to verify completeness)
| Metric | Pass 1 | Pass 2 | Pass 3 | Pass 4 | Pass 5 | **Final** |
|--------|--------|--------|--------|--------|--------|-----------|
| Impl changes needed | 3 | 3 | 3 | 3 | 3+1 | **3 + 1 new factory** |
| DateTime.now() violations | 0 | 16 | 6 | 6 | 7 | **7** |
| Entity private ctors | 29 | 29 | 20 | 16 | 20 | **20** |
| Enum int values missing | 5 | 5 | 4 | 3 | 4 | **4** |
| Undefined factory methods | 1 | 6 | 6 | 6 | 6 | **6** |
| Undefined error types | 4 | 4 | 4 | 4 | 4 | **4 (16 lines)** |
| Duplicates | 7 | 7 | 7 | 7 | 7 | **7** |
| Repo violations | 5 | 5 | 5 | 5 | 5 | **5** |
| Secondary doc violations | 127 | 190 | 147 | 107 | ~147 | **~147** |

Pass 5 corrections:
- DateTime.now(): Line 4866 was misclassified as PASS in Pass 3; it's an inline copyWith call (FAIL). Corrected 6 → 7.
- NetworkError.rateLimited(): Must be added to BOTH spec AND implementation (not spec-only). Plan updated.
- All other counts confirmed stable.

---

## THE 3 IMPLEMENTATION CHANGES

### 1. WearablePlatform enum - add int values
- **File:** `lib/domain/enums/health_enums.dart:250`
- **Current:** `enum WearablePlatform { healthkit, googlefit, fitbit, garmin, oura, whoop }`
- **Fix:** Add `healthkit(0), googlefit(1), fitbit(2), garmin(3), oura(4), whoop(5)` with `final int value; const WearablePlatform(this.value);`
- **Spec:** Also fix 22_API_CONTRACTS.md line 1411
- **Rule:** 9.1.1

### 2. SupplementIngredient - add private constructor
- **File:** `lib/domain/entities/supplement.dart` (lines 56-67)
- **Fix:** Add `const SupplementIngredient._();` before factory constructor
- **Spec:** Also fix 22_API_CONTRACTS.md line 7053
- **Rule:** 5.0.1

### 3. SupplementSchedule - add private constructor
- **File:** `lib/domain/entities/supplement.dart` (lines 75-89)
- **Fix:** Add `const SupplementSchedule._();` before factory constructor
- **Spec:** Also fix 22_API_CONTRACTS.md line 7093
- **Rule:** 5.0.1

### After these 3 fixes:
```bash
dart run build_runner build --delete-conflicting-outputs
flutter test
flutter analyze
```

---

## 22_API_CONTRACTS.md VIOLATIONS

### 1. Entity Private Constructors - Rule 5.0.1 (20 violations)

Rule 5.0.1 exempts Input DTOs, Result types, and UI state classes. Only persisted entities and domain objects need the constructor. Of 136 @freezed classes found, 25 have private constructors. Pass 3 classified all 11 ambiguous classes (see Exempt section below).

**Confirmed persisted entities missing constructor (20):**

| # | Entity | Line | Impl Status |
|---|--------|------|------------|
| 1 | Activity | 11258 | Impl already has it - spec-only fix |
| 2 | ActivityLog | 11293 | Impl already has it - spec-only fix |
| 3 | SleepEntry | 11360 | Impl already has it - spec-only fix |
| 4 | SupplementIngredient | 7053 | IMPL FIX #2 |
| 5 | SupplementSchedule | 7093 | IMPL FIX #3 |
| 6 | DietRule | 9321 | Not yet implemented |
| 7 | DietViolation | 9350 | Not yet implemented |
| 8 | HealthInsight | 9653 | Not yet implemented |
| 9 | InsightEvidence | 9680 | Not yet implemented |
| 10 | PredictiveAlert | 9699 | Not yet implemented |
| 11 | PredictionFactor | 9726 | Not yet implemented |
| 12 | Pattern | 9577 | Not yet implemented |
| 13 | TriggerCorrelation | 9615 | Not yet implemented |
| 14 | DailyCompliance | 9554 | Not yet implemented |
| 15 | AuditLogEntry | 10460 | Not yet implemented |
| 16 | ProfileAccessLog | 10680 | Not yet implemented |
| 17 | ImportedDataLog | 10788 | Not yet implemented |
| 18 | FhirExport | 10812 | Not yet implemented |
| 19 | ConditionCategory | 10594 | Reference data entity (DB-persisted) - not yet implemented |
| 20 | FoodItemCategory | 10620 | Reference data entity (DB-persisted) - not yet implemented |

**Exempt - Output DTOs / Not persisted (no constructor needed):**

| # | Class | Line | Reason |
|---|-------|------|--------|
| 1 | ConditionTrend | 4580 | Output type from GetConditionTrendUseCase |
| 2 | TrendDataPoint | 4592 | Embedded in ConditionTrend output |
| 3 | DataGap | 9884 | Part of DataQualityReport output |
| 4 | DataTypeQuality | 9867 | Part of DataQualityReport output |
| 5 | DataQualityReport | 9850 | Output type |
| 6 | ComplianceStats | 9533 | Output type from GetComplianceStatsUseCase |
| 7 | ProfileAccess | 10374 | Not a freezed entity in impl |
| 8 | PendingNotification | 10323 | Transient/ephemeral - not yet implemented |

**Ambiguous (1 - needs user decision when implemented):**

| # | Class | Line | Notes |
|---|-------|------|-------|
| 1 | QueuedNotification | 12144 | Transient queue item - exempt if ephemeral, FAIL if persisted to DB |

### 2. DateTime.now() Violations - Rule 5.2.1 (7 confirmed violations)

Pass 1 found 0, Pass 2 found 16, Pass 3 settled at 6, Pass 5 corrected to 7 (line 4866 was incorrectly classified as PASS in Pass 3 - it is an inline DateTime.now() in a copyWith, not a pre-computed variable).

**Confirmed FAIL - inline DateTime.now() in use case call() methods:**

| # | Line | Use Case / Context |
|---|------|--------------------|
| 1 | 4265 | UpdateSupplementUseCase - inline in syncMetadata copyWith |
| 2 | 4339 | ArchiveSupplementUseCase - inline in syncMetadata copyWith |
| 3 | 4520 | LogConditionUseCase - inline validation before pre-computed `now` at 4531 |
| 4 | 4866 | ActivateDietUseCase - inline in first deactivation copyWith |
| 5 | 4917 | ActivateDietUseCase - inline in second deactivation copyWith |
| 6 | 5303 | DetectPatternsUseCase - inline in pattern update |
| 7 | 6135 | ToggleNotificationUseCase - inline in syncMetadata copyWith |

**Pass 2 lines reclassified as PASS or EXEMPT:**

| Line | Status | Reason |
|------|--------|--------|
| 4531 | PASS | LogConditionUseCase - pre-computed `now` variable |
| 4925 | PASS | ActivateDietUseCase - pre-computed `now` for activation |
| 6211 | PASS | ConnectWearableUseCase - pre-computed `now` |
| 6323 | PASS | SyncWearableDataUseCase - pre-computed `now` |
| 6628 | PASS | SignUpUseCase - pre-computed `now` |
| 8518 | EXEMPT | Provider method, not use case call() |
| 8720 | EXEMPT | Provider method |
| 8918 | EXEMPT | SyncNotifier, not use case call() |
| 8950 | EXEMPT | SyncNotifier |
| 12218 | EXEMPT | Notification delivery system |

**None of the 7 confirmed violations are implemented yet - all spec-only fixes.**

### 3. Enum Integer Values - Rule 9.1.1 (4 violations)

Pass 3 resolved the 2 open questions: CorrelationType is DB-stored (FAIL), RateLimitOperation is service-only (EXEMPT).

| # | Enum | Line | DB-stored? | Status |
|---|------|------|-----------|--------|
| 1 | WearablePlatform | 1411 | YES (stored in WearableConnection entity) | FAIL - IMPL FIX #1 |
| 2 | AuditEventType | 10480 | YES (AuditLogEntry entity) | FAIL - spec-only (not yet implemented) |
| 3 | PredictionType | 9720 | YES (PredictiveAlert entity) | FAIL - spec-only (not yet implemented) |
| 4 | CorrelationType | 9646 | YES (TriggerCorrelation entity) | FAIL - spec-only (not yet implemented) |

**Exempt (confirmed not DB-stored):** RecoveryAction (error handling), TrendGranularity (query param), TrendDirection (output), ConflictResolution (sync param), RateLimitOperation (service-only, no entity stores it)

**Note on WearablePlatform:** The WearableConnection entity stores `platform` as `required String platform` (line 9981), but the enum exists in implementation without int values. The enum needs int values per 9.1.1 since it represents a DB-stored concept even if the current entity uses String.

### 4. Duplicate Definitions - Rule 16.2.1 (3 enums + 4 classes)

**Enum duplicates:**

| # | Enum | Keep (line) | Remove (line) |
|---|------|------------|--------------|
| 1 | PatternType | 1342 | 9596 |
| 2 | WearablePlatform | 1411 | 10001 |
| 3 | AccessLevel | 1621 | 10388 |

**Class duplicates (Section 14 examples):**

| # | Class | Canonical | Duplicate (Section 14) |
|---|-------|----------|----------------------|
| 4 | Diet | 9252 | 13476 |
| 5 | ComplianceCheckResult | 9443 | 13466 |
| 6 | CreateDietInput | 10117 | 13455 |
| 7 | SupplementListState | 7752 | 8126 |

### 5. Undefined Error Types (4 types, 16 lines)

All spec-only - none used in implementation.

| # | Type | Lines | Replacement |
|---|------|-------|-------------|
| 1 | RateLimitError | 5535, 6304, 6814, 6902 | NetworkError.rateLimited() |
| 2 | DuplicateError | 6356, 6370, 6384, 6462, 6498 | ValidationError.duplicate() |
| 3 | StateError | 8039, 8077, 8506, 8553, 8903, 8936 | BusinessError.invalidState() |
| 4 | UnknownError | 9123 | BusinessError.invalidState() |

### 6. Undefined Factory Methods (6 methods)

All spec-only - none used in implementation.

| # | Method Called | Line | Correct Method |
|---|-------------|------|---------------|
| 1 | DatabaseError.transactionFailed() | 3740 | .queryFailed() |
| 2 | WearableError.platformNotAvailable() | 6188 | .platformUnavailable() |
| 3 | WearableError.permissionsDenied() | 6202 | .permissionDenied() |
| 4 | WearableError.notConnected() | 6319 | .connectionFailed() |
| 5 | AuthError.invalidToken() | 6618 | .unauthorized() |
| 6 | AuthError.accountDeactivated() | 6639 | .unauthorized() |

### 7. New Factory Method to Add (1)

Add `NetworkError.rateLimited(String operation, [Duration? retryAfter])` to the NetworkError definition in Section 7. Note: `BusinessError.invalidState()` already exists in both spec and impl.

---

## SECONDARY DOCUMENT VIOLATIONS (147 total)

Pass 2 over-counted at 190 by treating all enum value instances as separate violations. Pass 3 verified 147 unique violations across 10 documents.

| # | Document | DateTime | Private Ctors | Dup Enums | New Enums | Errors | Total |
|---|----------|----------|---------------|-----------|-----------|--------|-------|
| 1 | 42_INTELLIGENCE_SYSTEM.md | 18 | 10 | 4 | 2 | 0 | 34 |
| 2 | 35_QR_DEVICE_PAIRING.md | 20 | 2 | 7 | 0 | 15 | 44 |
| 3 | 37_NOTIFICATIONS.md | 4 | 3 | 3 | 2 | 0 | 12 |
| 4 | 39_SAMPLE_DATA_GENERATOR.md | 18 | 1 | 0 | 0 | 0 | 19 |
| 5 | 46_AUDIT_FIXES_ROUND3.md | 2 | 2 | 12 | 0 | 1 | 17 |
| 6 | 44_SPECIFICATION_FIXES.md | 3 | 1 | 1 | 0 | 0 | 5 |
| 7 | 41_DIET_SYSTEM.md | 0 | 2 | 2 | 2 | 0 | 6 |
| 8 | 36_INTERNATIONAL_UNITS.md | 0 | 1 | 1 | 2 | 0 | 4 |
| 9 | 43_WEARABLE_INTEGRATION.md | 3 | 0 | 1 | 0 | 0 | 4 |
| 10 | 40_REPORT_GENERATION.md | 0 | 1 | 0 | 1 | 0 | 2 |
| | **TOTAL** | **68** | **23** | **31** | **9** | **16** | **147** |

All secondary document fixes are spec-text-only (no implementation impact).

---

## REPOSITORY VIOLATIONS (5 items, all spec-only)

| # | Repository | Issue | Location |
|---|-----------|-------|---------|
| 1 | PatternRepository | Duplicate with different signatures | 42_INTEL:1791 vs 22_API |
| 2 | TriggerCorrelationRepository | Duplicate (consistent) | 42_INTEL:1809 vs 22_API |
| 3 | HealthInsightRepository | Duplicate with different signatures | 42_INTEL:1836 vs 22_API |
| 4 | PredictiveAlertRepository | Duplicate (consistent) | 42_INTEL:1854 vs 22_API |
| 5 | PairingSessionRepository | Missing from 22_API, uses Future<T> | 35_QR:249 |

---

## USER DECISIONS (all decided)

| # | Issue | Decision | Impl Change? |
|---|-------|---------|-------------|
| 1 | UnknownError (line 9123) | Replace with BusinessError.invalidState() | NO |
| 2 | RateLimitError | Replace with NetworkError.rateLimited() | NO |
| 3 | DuplicateError | Replace with ValidationError.duplicate() | NO |
| 4 | StateError (as AppError) | Replace with BusinessError.invalidState() | NO |

**Note:** Implementation being ahead of specs is expected. CLAUDE.md tracked improvements made by previous instances that were never backported to 02_CODING_STANDARDS.md (updated to v1.1 this session) or to the spec documents.

---

## OPEN QUESTIONS - ALL RESOLVED (Pass 3)

| # | Item | Resolution |
|---|------|-----------|
| 1 | Entity private ctor count | **20 confirmed.** 8 classes exempt as output DTOs, 1 ambiguous (QueuedNotification). |
| 2 | CorrelationType enum | **DB-stored (FAIL).** Stored in TriggerCorrelation entity. |
| 3 | RateLimitOperation enum | **Service-only (EXEMPT).** No entity stores this enum. |
| 4 | WearablePlatform storage | **Stored as String** in WearableConnection entity (`required String platform` line 9981), but enum exists in impl without int values. Needs int values per 9.1.1. |

---

## EXECUTION PLAN

```
Step 1: Apply 3 implementation fixes (supplement.dart + health_enums.dart)
Step 2: Run build_runner, tests, analyzer
Step 3: Apply ~37 fixes to 22_API_CONTRACTS.md:
        - 20 private constructors (3 spec-only, 2 impl, 15 not-yet-implemented)
        - 4 enums need int values (1 impl + 3 spec-only)
        - 6 DateTime.now() pre-computation fixes
        - 7 duplicate definitions to remove
        - 4 undefined error types to replace (16 lines)
        - 6 undefined factory methods to correct
        - 1 new factory method to add (NetworkError.rateLimited)
Step 4: Apply 147 fixes to 10 secondary documents
Step 5: Apply 5 repository fixes
Step 6: Commit all
Step 7: Re-run /spec-review to verify clean
```
