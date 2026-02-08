# Spec Review Report - 2026-02-08 (Convergence Pass)

## Executive Summary
- Specs reviewed: 22_API_CONTRACTS.md vs 02_CODING_STANDARDS.md
- Total violations: 25
- Critical: 5 | High: 10 | Medium: 8 | Low: 2
- Auto-fixable: 17
- Requires user decision: 8
- Previous fix plan items confirmed: 19 of 21

## Comparison to Previous Fix Plan

The fix plan at `.claude/plans/spec-review-fix-plan-post-phase2.md` identified ~21 items.
This audit **confirms** most of those items still exist and identifies a few additional ones.

---

## Phase 1: Compliance Audit Results

### 1.1 Error Type Violations (CONFIRMED - 5 items)

All 5 error type violations from the fix plan are CONFIRMED still present:

| # | Location | Current | Should Be | Severity |
|---|----------|---------|-----------|----------|
| 1 | Line 8609 | `StateError('No fluids state available')` | `BusinessError.invalidState(...)` | CRITICAL |
| 2 | Line 8656 | `StateError('No state')` | `BusinessError.invalidState(...)` | CRITICAL |
| 3 | Line 9006 | `StateError('No sync state')` | `BusinessError.invalidState(...)` | CRITICAL |
| 4 | Line 9039 | `StateError('No sync state')` | `BusinessError.invalidState(...)` | CRITICAL |
| 5 | Line 9226 | `UnknownError(error.toString())` | `BusinessError.unexpected(...)` | CRITICAL |

**Rule violated:** 7.1 - Only AppError subtypes allowed (DatabaseError, AuthError, NetworkError, ValidationError, SyncError, WearableError, DietError, IntelligenceError, BusinessError, NotificationError).

### 1.2 Unchecked Result Operations (CONFIRMED - 6 items)

All 6 unchecked Result operations from the fix plan are CONFIRMED:

| # | Location | Unchecked Call | Severity |
|---|----------|---------------|----------|
| 6 | Line 5022 | `await _dietRepository.update(currentActive.copyWith(...))` | HIGH |
| 7 | Line 5509 | `await _correlationRepository.upsert(correlation)` (in loop) | HIGH |
| 8 | Line 5592 | `await _insightRepository.create(insight)` (in loop) | HIGH |
| 9 | Line 5729 | `await _alertRepository.create(alert)` (in loop) | HIGH |
| 10 | Line 6524 | `await _importLogRepository.create(importLog)` | HIGH |
| 11 | Line 6756 | `await _userRepository.update(user.copyWith(...))` | HIGH |

**Note:** Line 6811 (`await _profileRepository.create(defaultProfile)`) was flagged in the fix plan but this is actually less critical since the user creation just succeeded and this is a follow-up operation. Still should be checked but lower priority.

**Rule violated:** 3.3/7.2 - All repository calls return `Result<T, AppError>` and MUST be checked.

### 1.3 DateTime.now() Violations (2 items)

| # | Location | Issue | Severity |
|---|----------|-------|----------|
| 12 | Line 5413 | `DateTime.now().millisecondsSinceEpoch` inside loop when `now` already pre-computed at line 5349 | HIGH |
| 13 | Line 6248 | `DateTime.now().millisecondsSinceEpoch` used directly — no `now` pre-computation in ToggleNotificationUseCase | HIGH |

**Rule violated:** 5.2.1 - DateTime.now() MUST be pre-computed ONCE at top of use case call() method.

### 1.4 Enum Integer Value Violations (CONFIRMED - 3 items)

| # | Location | Enum | Severity |
|---|----------|------|----------|
| 14 | Line 4681 | `TrendGranularity { daily, weekly, monthly }` - no int values | CRITICAL* |
| 15 | Line 4706 | `TrendDirection { improving, stable, worsening }` - no int values | CRITICAL* |
| 16 | Line 7078 | `ConflictResolution { keepLocal, keepRemote, merge }` - no int values | CRITICAL* |

*Severity depends on whether these are database-persisted. Rule 9.1.1 exempts UI-only enums.

**USER DECISION NEEDED:** Are TrendGranularity, TrendDirection, and ConflictResolution persisted to the database? If so, they need int values. If they're transient query parameters / in-memory only, they're exempt.

### 1.5 Duplicate Definitions (CONFIRMED - 1 item)

| # | Location | Issue | Severity |
|---|----------|-------|----------|
| 17 | Lines 7879, 8246, 13618 | `SupplementList` class defined 3 times | HIGH |

**Fix:** Keep canonical at line 8246. Replace lines 7879 and 13618 with cross-reference comments.

### 1.6 Section Numbering Duplicates (CONFIRMED - 2 items)

| # | Location | Issue | Severity |
|---|----------|-------|----------|
| 18 | Lines 1667 & 2013 | Two sections both numbered "## 4" | MEDIUM |
| 19 | Lines 9347 & 9675 | Two subsections both numbered "## 7.5" | MEDIUM |

**Fix:**
- Line 2013: Renumber from "## 4. Use Case Contracts" to "## 4a. Use Case Contracts" (or renumber all downstream)
- Line 9675: Renumber from "## 7.5 Intelligence System Contracts" to "## 7.5a Intelligence System Contracts" (line 10085 is already "## 7.6")

### 1.7 Cross-Reference Accuracy (CONFIRMED - 4 items)

| # | Location | References | Actual Location | Severity |
|---|----------|-----------|-----------------|----------|
| 20 | Line 13583 | "Diet: See Section 8.3 (line ~9254)" | Diet entity is at line 9355 | MEDIUM |
| 21 | Line 13580 | "ComplianceCheckResult: See Section 8.3 (line ~9447)" | ComplianceCheckResult is at line 9548 | MEDIUM |
| 22 | Line 13577 | "CreateDietInput: See Section 8.4 (line ~10128)" | CreateDietInput is at line 10229 | MEDIUM |
| 23 | Line 13621 | "See Section 7 (line ~7766)" | Canonical SupplementList is at line 8246 | MEDIUM |

### 1.8 Entity-DB Mapping Mismatches (5 items - REQUIRES VERIFICATION)

These were identified by Agent 1 and need user decisions:

| # | Entity | Entity Field | DB Mapping Field | Issue | Severity |
|---|--------|-------------|-----------------|-------|----------|
| A | IntakeLog | `scheduledTime` (11187) | `timestamp` (12715) | Different field names | HIGH |
| B | IntakeLog | N/A | `intakeTime` / IntakeTime enum (12716) | DB mapping has field not in entity | HIGH |
| C | Document | `name` (11833) | `filename` (12827) | Different field names | HIGH |
| D | Document | `filePath` (11835) | `local_path` / `localPath` (12831) | Different field names | MEDIUM |
| E | Document | `documentType` (11834) | `type` (12828) | Different field names | MEDIUM |
| F | UserAccount | `photoUrl` (11732) | N/A (not in mapping) | Entity field missing from mapping | MEDIUM |
| G | UserAccount | N/A | `role` (12647) | DB mapping has field not in entity | HIGH |
| H | UserAccount | `authProviderId` (11734) | `externalId` / `external_id` (12649) | Different field names | HIGH |
| I | UserAccount | `clientId` (11729) | N/A | Required entity field missing from mapping | CRITICAL |
| J | FoodItem | `servingSize` String? (11260) | `servingSize` double? (12733) | Type mismatch | HIGH |
| K | FoodItem | N/A | `servingUnit` String? (12734) | DB mapping has extra field | MEDIUM |
| L | DeviceRegistration | DeviceType has int values | DB stores as TEXT .name (12693) | Storage format contradiction | MEDIUM |

**USER DECISION NEEDED:** For each mismatch, should the entity definition be updated to match the DB mapping, or vice versa? The entity definition should be canonical, and the mapping table should be updated to match.

### 1.9 Use Case Field Name Mismatch (NEW - 1 item)

| # | Location | Issue | Severity |
|---|----------|-------|----------|
| 24 | Line 6776 | Use case constructs UserAccount with `avatarUrl` but entity uses `photoUrl` (11732) | HIGH |

### 1.10 Unchecked Downstream Operations (NEW - 1 item)

| # | Location | Issue | Severity |
|---|----------|-------|----------|
| 25 | Line 6811 | `await _profileRepository.create(defaultProfile)` - unchecked Result | MEDIUM |

---

## Phase 2: Categorization

### Auto-Fix (17 items - clear spec errors)

| Item | Fix |
|------|-----|
| 1-5 | Replace StateError/UnknownError with BusinessError factories |
| 6-11,25 | Capture Result and check .isFailure for all unchecked repo calls |
| 12 | Change `DateTime.now().millisecondsSinceEpoch` to `now` at line 5413 |
| 13 | Add `final now = DateTime.now().millisecondsSinceEpoch;` at top of ToggleNotificationUseCase.call() |
| 17 | Remove duplicate SupplementList definitions, add cross-refs |
| 18-19 | Renumber duplicate sections |
| 20-23 | Update cross-reference line numbers |

### Requires User Decision (8 items)

| Item | Question |
|------|----------|
| 14-16 | Are TrendGranularity/TrendDirection/ConflictResolution DB-persisted? |
| A-L | For each entity-DB mapping mismatch: update entity or update mapping? |
| 24 | UserAccount field: `photoUrl` or `avatarUrl`? |

---

## Phase 3: Code Example Issues

- Line 6776: UserAccount constructed with `avatarUrl` field that doesn't exist in entity definition (entity uses `photoUrl`)
- Lines 5509, 5592, 5729: Loop bodies don't capture/check repository call results

---

## Phase 4: Integrity Issues

1. **Section numbering**: Two "## 4" sections and two "## 7.5" sections
2. **SupplementList**: Defined 3 times, only one is canonical
3. **Cross-references**: 4 line number references are stale (off by ~100 lines each due to Phase 2 edits)
4. **IntakeLog entity vs DB mapping**: Field naming completely different (scheduledTime vs timestamp, N/A vs intakeTime)
5. **Document entity vs DB mapping**: 3 field name mismatches (name/filename, filePath/localPath, documentType/type)
6. **UserAccount entity vs DB mapping**: Missing clientId, extra role field, authProviderId/externalId mismatch

---

## Recommendations

1. **Fix auto-fixable items first** (17 items) — these are all clear spec errors with obvious corrections
2. **Get user decisions** on the 8 items requiring judgment
3. **Entity-DB mapping mismatches** should be resolved by treating the entity definition (Section 10) as canonical and updating the mapping tables (Section 13) to match
4. **After fixes**, run one more /spec-review to confirm convergence to 0

## Expected Convergence

- Previous pass: ~280 issues (Phase 1-2)
- This pass: 25 issues (17 auto-fix + 8 decisions)
- Next pass after fixes: should be 0-3 issues (cross-ref drift only)
