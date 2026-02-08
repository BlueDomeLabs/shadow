# Spec Review Report - 2026-02-08 (Contradiction-Focused Pass 4)

## Executive Summary
- Focus: Intelligence & Sync subsystems — missing methods, factories, and parameter mismatches
- New contradictions found: 6
- Severity: 5 CRITICAL (would-not-compile), 1 HIGH (missing enum value)

---

## New Contradictions Found

### CRITICAL-1: ConditionLogRepository.getByCondition — missing startDate/endDate params (line 11147 vs 4729/5460)

**Severity:** CRITICAL — would not compile (named params don't exist)

Repository definition (line 11147-11151):
```dart
getByCondition(String conditionId, {int? limit, int? offset})
```

Use case calls:
- Line 4729: `getByCondition(input.conditionId, startDate: input.startDate, endDate: input.endDate)` — named params don't exist
- Line 5460: `getByCondition(input.conditionId!, startDate: startDate, endDate: now)` — same issue
- Line 4654: `getByCondition(input.profileId, input.conditionId, input.startDate, input.endDate)` — passes 4 positional args, only 1 accepted. Also passes profileId first (wrong arg).

**Fix:**
1. Update repo signature to include `startDate`/`endDate`:
```dart
Future<Result<List<ConditionLog>, AppError>> getByCondition(
  String conditionId, {
  int? startDate,    // Epoch ms
  int? endDate,      // Epoch ms
  int? limit,
  int? offset,
});
```
2. Fix line 4654 to use named params: `_repository.getByCondition(input.conditionId, startDate: input.startDate, endDate: input.endDate)`

---

### CRITICAL-2: NetworkError.rateLimited — factory doesn't exist (lines 5647, 6417, 6928, 7017)

**Severity:** CRITICAL — would not compile (4 call sites)

All 4 locations call `NetworkError.rateLimited(operation, duration)` but NetworkError (lines 333-353) only has: `noConnection`, `timeout`, `serverError`, `sslError`. No `rateLimited`.

**Fix:** Add factory to NetworkError (after line 353):
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

---

### CRITICAL-3: MLModelRepository.getActiveModels — method doesn't exist (line 5654)

**Severity:** CRITICAL — would not compile

Use case at line 5654: `_mlModelRepository.getActiveModels(input.profileId)`
MLModelRepository (lines 11914-11925): Only has `getLatest`, `getByProfile`, `save`, `delete`, `deleteOldVersions`. No `getActiveModels`.

**Fix:** Either:
- (a) Change use case to `_mlModelRepository.getByProfile(input.profileId)`, OR
- (b) Add `getActiveModels` to repo

Option (a) is simpler — `getByProfile` returns all models for the profile, which is functionally equivalent.

---

### CRITICAL-4: SleepEntryRepository.getByDateRange — method doesn't exist (line 5787)

**Severity:** CRITICAL — would not compile

Use case at line 5787: `_sleepRepository.getByDateRange(input.profileId, startDate, now)`
SleepEntryRepository (lines 11505-11522): Only has `getByProfile`, `getForNight`, `getAverages`. No `getByDateRange`.

**Fix:** Add to SleepEntryRepository (after line 11521):
```dart
Future<Result<List<SleepEntry>, AppError>> getByDateRange(
  String profileId,
  int startDate,  // Epoch ms
  int endDate,    // Epoch ms
);
```

---

### CRITICAL-5: RateLimitOperation.prediction — enum value doesn't exist (line 5641)

**Severity:** CRITICAL — would not compile

Use case at lines 5641/5735: `RateLimitOperation.prediction`
RateLimitOperation enum (line 10522): Has `sync`, `photoUpload`, `reportGeneration`, `dataExport`, `wearableSync` — NO `prediction`.

**Fix:** Add `prediction` to enum:
```dart
prediction(1, Duration(minutes: 1)),  // 1 per minute
```

---

### HIGH-1: GetConditionLogsUseCase — passes wrong first arg (line 4654)

**Severity:** HIGH — would pass profileId where conditionId is expected (silent data error even if params existed)

Line 4654: `_repository.getByCondition(input.profileId, ...)` — first arg should be `input.conditionId`

**Fix:** (Combined with CRITICAL-1 repo fix) Change to:
`_repository.getByCondition(input.conditionId, startDate: input.startDate, endDate: input.endDate)`

---

## Summary Table

| # | Location | Entity/Method | Issue | Severity |
|---|----------|---------------|-------|----------|
| C1 | 11147 vs 4729/5460 | ConditionLogRepository.getByCondition | Missing startDate/endDate params | CRITICAL |
| C2 | 5647/6417/6928/7017 | NetworkError.rateLimited | Factory doesn't exist (4 call sites) | CRITICAL |
| C3 | 5654 vs 11914 | MLModelRepository.getActiveModels | Method doesn't exist | CRITICAL |
| C4 | 5787 vs 11505 | SleepEntryRepository.getByDateRange | Method doesn't exist | CRITICAL |
| C5 | 5641 vs 10522 | RateLimitOperation.prediction | Enum value doesn't exist | CRITICAL |
| H1 | 4654 | GetConditionLogsUseCase | Passes profileId instead of conditionId | HIGH |

---

## Relationship to Existing Fix Plan

- C1 is in the Intelligence subsystem (AnalyzeTriggersUseCase) and ConditionLog subsystem (GetConditionLogsUseCase)
- C2 is across Intelligence + Sync + Wearable subsystems
- C3-C5 are in the Intelligence subsystem
- H1 is in the ConditionLog subsystem
- **All are NEW** — none overlap with the 54 items already in the fix plan
