# Plan: Fix All Spec Violations from Fresh Audit

## Context

5 audit passes (Pass 1-5) have converged on stable violation counts. All open questions resolved. User wants ALL spec errors fixed, even those that don't affect implementation. Only 3 violations require implementation code changes (+ 1 new factory method in impl); the rest are spec-text-only.

**Source of truth:** `.claude/audit-reports/2026-02-08-fresh-audit.md`
**Verified by:** Pass 5 comparison (all items confirmed or corrected)

---

## Phase 1: Implementation Fixes (3 changes)

These must be done first because they require build_runner + test verification.

### Step 1.1: WearablePlatform enum - add int values
- **File:** `lib/domain/enums/health_enums.dart:250`
- **Change:** `enum WearablePlatform { healthkit, googlefit, fitbit, garmin, oura, whoop }` → `enum WearablePlatform { healthkit(0), googlefit(1), fitbit(2), garmin(3), oura(4), whoop(5); final int value; const WearablePlatform(this.value); }`
- **Rule:** 9.1.1

### Step 1.2: SupplementIngredient - add private constructor
- **File:** `lib/domain/entities/supplement.dart` (lines 56-67)
- **Change:** Add `const SupplementIngredient._();` as first declaration inside class body
- **Rule:** 5.0.1

### Step 1.3: SupplementSchedule - add private constructor
- **File:** `lib/domain/entities/supplement.dart` (lines 75-89)
- **Change:** Add `const SupplementSchedule._();` as first declaration inside class body
- **Rule:** 5.0.1

### Step 1.4: Regenerate + verify
```bash
dart run build_runner build --delete-conflicting-outputs
flutter test
flutter analyze
```

---

## Phase 2: 22_API_CONTRACTS.md Fixes (~44 individual edits)

### Step 2.1: Entity Private Constructors (20 entities)

Add `const ClassName._();` before factory constructor for each:

| # | Entity | Line | Notes |
|---|--------|------|-------|
| 1 | Activity | ~11258 | Spec-only (impl already has it) |
| 2 | ActivityLog | ~11293 | Spec-only (impl already has it) |
| 3 | SleepEntry | ~11360 | Spec-only (impl already has it) |
| 4 | SupplementIngredient | ~7053 | Also impl fix (Phase 1) |
| 5 | SupplementSchedule | ~7093 | Also impl fix (Phase 1) |
| 6 | DietRule | ~9321 | Not yet implemented |
| 7 | DietViolation | ~9350 | Not yet implemented |
| 8 | HealthInsight | ~9653 | Not yet implemented |
| 9 | InsightEvidence | ~9680 | Not yet implemented |
| 10 | PredictiveAlert | ~9699 | Not yet implemented |
| 11 | PredictionFactor | ~9726 | Not yet implemented |
| 12 | Pattern | ~9577 | Not yet implemented |
| 13 | TriggerCorrelation | ~9615 | Not yet implemented |
| 14 | DailyCompliance | ~9554 | Not yet implemented |
| 15 | AuditLogEntry | ~10460 | Not yet implemented |
| 16 | ProfileAccessLog | ~10680 | Not yet implemented |
| 17 | ImportedDataLog | ~10788 | Not yet implemented |
| 18 | FhirExport | ~10812 | Not yet implemented |
| 19 | ConditionCategory | ~10594 | Not yet implemented |
| 20 | FoodItemCategory | ~10620 | Not yet implemented |

### Step 2.2: Enum Integer Values (4 enums)

Add `(N)` values + `final int value; const EnumName(this.value);` for each:

| # | Enum | Line | Values |
|---|------|------|--------|
| 1 | WearablePlatform | ~1411 | healthkit(0), googlefit(1), fitbit(2), garmin(3), oura(4), whoop(5) |
| 2 | AuditEventType | ~10480 | Add sequential int values to all members |
| 3 | PredictionType | ~9720 | flareUp(0), menstrualStart(1), ovulation(2), triggerExposure(3), missedSupplement(4), poorSleep(5) |
| 4 | CorrelationType | ~9646 | positive(0), negative(1), neutral(2), doseResponse(3) |

### Step 2.3: DateTime.now() Pre-computation (7 use cases)

For each, add `final now = DateTime.now();` at top of call() method and replace inline calls:

| # | Line | Use Case |
|---|------|----------|
| 1 | ~4265 | UpdateSupplementUseCase - inline in syncMetadata copyWith |
| 2 | ~4339 | ArchiveSupplementUseCase - inline in syncMetadata copyWith |
| 3 | ~4520 | LogConditionUseCase - inline before pre-computed `now` at 4531 |
| 4 | ~4866 | ActivateDietUseCase - inline in first deactivation copyWith |
| 5 | ~4917 | ActivateDietUseCase - inline in second deactivation copyWith |
| 6 | ~5303 | DetectPatternsUseCase - inline in pattern update |
| 7 | ~6135 | ToggleNotificationUseCase - inline in syncMetadata copyWith |

### Step 2.4: Remove Duplicate Definitions (7 items)

**Enums (3) - remove duplicate, keep canonical:**

| # | Enum | Keep (line) | Remove (line) |
|---|------|-------------|---------------|
| 1 | PatternType | ~1342 | ~9596 |
| 2 | WearablePlatform | ~1411 (after adding int values) | ~10001 |
| 3 | AccessLevel | ~1621 (has int values) | ~10388 |

**Classes (4) - remove Section 14 duplicates, add cross-references:**

| # | Class | Keep (line) | Remove (line) |
|---|-------|-------------|---------------|
| 4 | Diet | ~9252 | ~13476 |
| 5 | ComplianceCheckResult | ~9443 | ~13466 |
| 6 | CreateDietInput | ~10117 | ~13455 |
| 7 | SupplementListState | ~7752 | ~8126 |

### Step 2.5: Replace Undefined Error Types (4 types, 16 lines)

| # | Find | Replace With | Lines |
|---|------|-------------|-------|
| 1 | `RateLimitError` | `NetworkError.rateLimited()` | 5535, 6304, 6814, 6902 |
| 2 | `DuplicateError` | `ValidationError.duplicate()` | 6356, 6370, 6384, 6462, 6498 |
| 3 | `StateError` (as AppError) | `BusinessError.invalidState()` | 8039, 8077, 8506, 8553, 8903, 8936 |
| 4 | `UnknownError` | `BusinessError.invalidState()` | 9123 |

### Step 2.6: Fix Undefined Factory Methods (6 methods)

| # | Find | Replace With | Line |
|---|------|-------------|------|
| 1 | `DatabaseError.transactionFailed()` | `DatabaseError.queryFailed()` | ~3740 |
| 2 | `WearableError.platformNotAvailable()` | `WearableError.platformUnavailable()` | ~6188 |
| 3 | `WearableError.permissionsDenied()` | `WearableError.permissionDenied()` | ~6202 |
| 4 | `WearableError.notConnected()` | `WearableError.connectionFailed()` | ~6319 |
| 5 | `AuthError.invalidToken()` | `AuthError.unauthorized()` | ~6618 |
| 6 | `AuthError.accountDeactivated()` | `AuthError.unauthorized()` | ~6639 |

### Step 2.7: Add NetworkError.rateLimited() Factory Method (1 addition to SPEC + IMPL)

In Section 7 NetworkError definition (around line 306-340) of 22_API_CONTRACTS.md, add:
```dart
factory NetworkError.rateLimited(String operation, [Duration? retryAfter]) => NetworkError._(
  code: 'RATE_LIMITED',
  message: 'Rate limit exceeded for $operation${retryAfter != null ? '. Retry after ${retryAfter.inSeconds}s' : ''}',
  userMessage: 'Too many requests. Please try again later.',
  isRecoverable: true,
  recoveryAction: RecoveryAction.retry,
);
```

**Also add to implementation:** `lib/core/errors/app_error.dart` in the NetworkError class, matching the spec definition above. This is needed because the error type replacements (Step 2.5) reference NetworkError.rateLimited() which must exist in implementation for future use case implementations to compile.

---

## Phase 3: Secondary Document Fixes (~147 edits across 10 docs)

All spec-text-only. Apply in document order, largest first.

### Step 3.1: 42_INTELLIGENCE_SYSTEM.md (~34 fixes)
- DateTime → int: ~18 field/parameter changes
- Private constructors: ~10 @freezed entities
- Duplicate enums: ~3 (remove, reference 22_API_CONTRACTS.md)
- New enums to centralize: ~3 (move to 22_API_CONTRACTS.md or add cross-ref)

### Step 3.2: 35_QR_DEVICE_PAIRING.md (~44 fixes)
- DateTime → int: ~20 field/parameter changes
- Private constructors: ~2-5 entities
- Duplicate enums: ~7 (remove, reference canonical)
- Error type fixes: ~15 (Future<T> → Result<T, AppError> in PairingSessionRepository)

### Step 3.3: 39_SAMPLE_DATA_GENERATOR.md (~19 fixes)
- DateTime → int: ~18 (sample data generation code uses DateTime extensively)
- Private constructors: ~1

### Step 3.4: 37_NOTIFICATIONS.md (~15 fixes)
- DateTime → int: ~4-7
- Private constructors: ~3-4
- Duplicate enums: ~2-3
- New enums: ~2

### Step 3.5: 46_AUDIT_FIXES_ROUND3.md (~17 fixes)
- DateTime → int: ~2-3
- Private constructors: ~2
- Duplicate enums: ~12

### Step 3.6: 41_DIET_SYSTEM.md (~6 fixes)
- Private constructors: ~2-3
- Duplicate enums: ~1-2
- New enums: ~2

### Step 3.7: 44_SPECIFICATION_FIXES.md (~5 fixes)
- DateTime → int: ~3
- Private constructors: ~1-3

### Step 3.8: 36_INTERNATIONAL_UNITS.md (~4 fixes)
- Private constructors: ~1
- Enum fixes: ~1-2

### Step 3.9: 43_WEARABLE_INTEGRATION.md (~4 fixes)
- DateTime → int: ~3-4
- Duplicate enums: ~1 (WearablePlatform)

### Step 3.10: 40_REPORT_GENERATION.md (~2 fixes)
- Private constructors: ~1
- New enums: ~1

---

## Phase 4: Repository Fixes (5 items)

### Step 4.1: Reconcile intelligence repositories (4 items)
For PatternRepository, TriggerCorrelationRepository, HealthInsightRepository, PredictiveAlertRepository:
- Merge methods from 42_INTELLIGENCE_SYSTEM.md into 22_API_CONTRACTS.md (superset)
- Remove duplicate definitions from 42_INTELLIGENCE_SYSTEM.md, add cross-reference

### Step 4.2: Add PairingSessionRepository to 22_API_CONTRACTS.md
- Copy from 35_QR_DEVICE_PAIRING.md
- Change all `Future<T>` returns to `Result<T, AppError>`
- Add `implements EntityRepository<PairingSession, String>` if applicable

---

## Phase 5: Verification

```bash
flutter test          # Verify Phase 1 impl changes didn't break anything
flutter analyze       # Clean
```

Then commit all changes with descriptive message.

---

## Phase 6: Re-audit

Run `/spec-review` one final time to verify 0 violations remain.

---

## Execution Strategy

Given the volume (~180+ individual edits), this should be done methodically:
- **Phase 1** (impl fixes): ~5 minutes, must verify with tests
- **Phase 2** (22_API_CONTRACTS.md): Largest single file, ~44 edits. Use parallel agents for different subsections.
- **Phase 3** (secondary docs): 10 documents. Can parallelize with agents (2-3 docs per agent).
- **Phase 4** (repos): 5 targeted edits across 3 files.
- **Phase 5-6**: Verification pass.

Estimated: Phase 1 first, then Phases 2-4 can be parallelized with agents, Phase 5-6 to close.
