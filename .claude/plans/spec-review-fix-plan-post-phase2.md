# Plan: Fix Remaining Spec Violations Found by Post-Phase-2 Spec Review

## Context

After completing Phase 1-2 of the spec fix plan (~100 edits to 22_API_CONTRACTS.md), a fresh `/spec-review` audit with 5 parallel agents found remaining violations. This plan captures all findings for systematic fixing.

**Source:** Post-Phase-2 spec-review audit (5 agents, 2026-02-08)
**Baseline:** 1205 tests passing, 0 analyzer issues, Phase 1-2 committed as b372957

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
- **Note:** Need to verify `BusinessError.unexpected()` exists in impl, or use appropriate factory

---

## HIGH: Unchecked Result Operations (6+ items)

### Fix 6: ActivateDietUseCase unchecked update (line 5022)
- **Current:** `await _dietRepository.update(currentActive.copyWith(...));`
- **Fix:** `final deactivateResult = await _dietRepository.update(currentActive.copyWith(...)); if (deactivateResult.isFailure) return Failure(deactivateResult.errorOrNull!);`

### Fix 7: AnalyzeTriggersUseCase unchecked upsert (around line 5509)
- **Current:** `await _correlationRepository.upsert(correlation);`
- **Fix:** Capture result and check for failure

### Fix 8: GenerateInsightsUseCase unchecked create (around line 5592)
- **Current:** `await _insightRepository.create(insight);`
- **Fix:** Capture result and check for failure

### Fix 9: GeneratePredictiveAlertsUseCase unchecked create (around line 5729)
- **Current:** `await _alertRepository.create(alert);`
- **Fix:** Capture result and check for failure

### Fix 10: SyncWearableDataUseCase unchecked creates (lines 6524, 6553)
- **Current:** `await _importLogRepository.create(importLog);` and `await _connectionRepository.update(...)`
- **Fix:** Capture results and check for failure

### Fix 11: Auth use cases unchecked operations (lines 6756, 6811)
- **Current:** `await _userRepository.update(...)` and `await _profileRepository.create(...)`
- **Fix:** Capture results and check for failure

---

## HIGH: Duplicate Definitions (1 item)

### Fix 12: SupplementList defined 3 times (lines 7879, 8246, 13618)
- **Fix:** Keep canonical at line 8246. Replace line 7879 and 13618 with cross-references:
  `// SupplementList: See Section 7.2 (line ~8246) for canonical definition`

---

## HIGH: Enum Int Values Missing (3 enums)

### Fix 13: TrendGranularity enum (line 4681)
- **Current:** `enum TrendGranularity { daily, weekly, monthly }`
- **Fix:** Add `(0)`, `(1)`, `(2)` + `final int value; const TrendGranularity(this.value);`
- **Note:** Evaluate if this enum is persisted to DB. If not persisted (used only as query parameter), int values may not be required per Rule 9.1.1

### Fix 14: TrendDirection enum (line 4706)
- **Current:** `enum TrendDirection { improving, stable, worsening }`
- **Fix:** Add `(0)`, `(1)`, `(2)` + `final int value; const TrendDirection(this.value);`
- **Note:** Same consideration as Fix 13

### Fix 15: ConflictResolution enum (line 7078)
- **Current:** `enum ConflictResolution { keepLocal, keepRemote, merge }`
- **Fix:** Add `(0)`, `(1)`, `(2)` + `final int value; const ConflictResolution(this.value);`
- **Note:** Same consideration - may be transient/non-persisted

---

## MEDIUM: Cross-Reference Accuracy (4 items)

### Fix 16: Invalid cross-reference for Diet entity (line ~13583)
- **Current:** "See Section 8.3 (line ~9254)"
- **Fix:** Update to correct line number for Diet entity definition

### Fix 17: Invalid cross-reference for ComplianceCheckResult (line ~13580)
- **Current:** "See Section 8.3 (line ~9447)"
- **Fix:** Update to correct line number (~9548)

### Fix 18: Invalid cross-reference for CreateDietInput (line ~13577)
- **Current:** "See Section 8.4 (line ~10128)"
- **Fix:** Update to correct line number (~10229)

### Fix 19: Invalid cross-reference for SupplementList stub (line ~13621)
- **Current:** "See Section 7 (line ~7766)"
- **Fix:** Update to correct line number for canonical SupplementList (~8246)

---

## MEDIUM: Section Numbering Duplicates (2 items)

### Fix 20: Duplicate "Section 4" (lines 1667 and 2013)
- **Issue:** Two sections both numbered "4" - Repository Interface Contracts and Use Case Contracts
- **Fix:** Renumber to 4 and 5 (or 4.1 and 4.2), adjusting all downstream references

### Fix 21: Duplicate "Section 7.5" (lines 9347 and 9675)
- **Issue:** Two subsections both numbered "7.5" - Diet Entity Contracts and Intelligence System Contracts
- **Fix:** Renumber intelligence section to 7.6 (or choose appropriate number)

---

## LOW-MEDIUM: Entity-DB Mapping Residual Issues

### Fix 22-26: Remaining mapping table mismatches (5 entities)
These were flagged by Agent 1 but may have already been fixed in Phase 2 Step 2.10. Need to VERIFY before adding to fix list:
- IntakeLog (13.12): scheduledTime/actualTime vs timestamp/intakeTime
- Document (13.19): name/filePath vs filename/localPath
- UserAccount (13.8): missing clientId, authProviderId naming
- FoodItem (13.13): servingSize type (double? vs String?)
- DeviceRegistration (13.11): missing deviceModel field

**Action:** Read each mapping table and entity definition to confirm if still mismatched or already fixed.

---

## LOW: DateTime.now() Pattern Clarification

### Note 27: DateTime vs int pre-computation style
- Agent 3 flagged `final now = DateTime.now();` as needing to be `final now = DateTime.now().millisecondsSinceEpoch;`
- **Analysis:** The current pattern `final now = DateTime.now();` followed by `now.millisecondsSinceEpoch` is correct per 02_CODING_STANDARDS.md Rule 5.2.1 which says "pre-compute DateTime.now()" - it does NOT say to convert to int immediately. The DateTime object allows calling `.millisecondsSinceEpoch` at each usage point, which is actually cleaner.
- **Action:** NO FIX NEEDED. This is correct as-is.

### Note 28: DetectPatternsUseCase DateTime.now() in loop (line 5413)
- `lastObservedAt: DateTime.now().millisecondsSinceEpoch` inside a loop
- **Fix:** Should use pre-computed `now.millisecondsSinceEpoch` from the top of the method, but the top-level `now` variable hasn't been added to this use case yet (it was in the plan but may not have been applied due to agent conflicts)
- **Action:** Verify and fix if needed

---

## Verification Items (Not Fixes)

### Verify A: Agent 1 mapping table claims
Agent 1 claimed CRITICAL mapping mismatches but Phase 2 Step 2.10 was supposed to fix all 24 tables. Need to re-verify IntakeLog, Document, UserAccount, FoodItem, DeviceRegistration mapping tables against entity definitions.

### Verify B: DeviceRegistration deviceType storage
Agent 1 flagged a conflict between enum with int values and DB mapping showing TEXT .name storage. Need to check if this is intentional (some enums stored as .name for readability).

---

## Execution Strategy

1. Fix items 1-5 (error types) - spec-text-only, simple replacements
2. Fix items 6-11 (unchecked Results) - spec-text-only, add result capture + failure check
3. Fix item 12 (duplicate SupplementList) - remove duplicates, add cross-refs
4. Verify items 22-26 (mapping tables) - read and confirm status
5. Fix items 13-15 (enum int values) - after determining if they're persisted
6. Fix items 16-21 (cross-refs + section numbering) - low risk, formatting only
7. Verify item 28 (DetectPatterns DateTime in loop)

**All changes are spec-text-only.** No implementation code changes needed. No tests affected.

---

## Estimated Scope

- ~15-20 targeted edits to 22_API_CONTRACTS.md
- 5 verification reads (mapping tables)
- 0 implementation changes
- 0 test changes
