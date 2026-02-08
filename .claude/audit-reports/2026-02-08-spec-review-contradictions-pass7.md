# Spec Review Report - 2026-02-08 (Cross-Reference Verification Pass 7)

## Executive Summary
- Focus: Systematic cross-reference verification across use cases, entities, repositories, and providers
- New contradictions found: 12
- Severity: 6 CRITICAL (would-not-compile), 4 HIGH (missing definitions), 2 MEDIUM

---

## New Contradictions Found

### ISSUE-XR-1: ConditionLog.severity is `int`, but `.toStorageScale()` is called on it (lines 4760, 4805)

**Severity:** CRITICAL -- would not compile (method does not exist on `int`)
**Source location:** Lines 4760, 4805 (GetConditionTrendUseCase)
**Target location:** Line 11114 (ConditionLog entity: `required int severity`)
**Problem:** `l.severity.toStorageScale()` is called at lines 4760 and 4805, but `severity` is `int` (per entity definition). `toStorageScale()` is a method on `ConditionSeverity` enum (line 1272), not on `int`. Since `ConditionLog.severity` is already an `int` (1-10 scale), calling `.toStorageScale()` on it makes no sense and would not compile.
**Fix:** Remove `.toStorageScale()` calls -- `l.severity` is already the 1-10 int value. Change to:
- Line 4760: `final severities = bucketLogs.map((l) => l.severity).toList();`
- Line 4805: `final severities = logs.map((l) => l.severity).toList();`

Note: Fix 45 already covers the phantom `Severity` type at line 4635, but these `.toStorageScale()` calls at 4760/4805 are separate compilation failures not previously reported.

---

### ISSUE-XR-2: `ConditionTrend.currentSeverity` uses undefined `Severity` type (line 4690)

**Severity:** CRITICAL -- would not compile (type does not exist)
**Source location:** Line 4690 (ConditionTrend definition)
**Target location:** N/A -- `Severity` type is never defined
**Problem:** `required Severity? currentSeverity` uses `Severity` which does not exist. The closest type is `ConditionSeverity` (line 1256).
**Fix:** Change to `ConditionSeverity? currentSeverity` or `int? currentSeverity` (to match the 1-10 int scale used by ConditionLog).

Note: Fix 45 covers the `_detectFlare` method using `Severity` at line 4635, but the `ConditionTrend` class definition at line 4690 is a separate class and a separate compilation failure.

---

### ISSUE-XR-3: SupplementListState missing `archivedSupplements` and `showArchived` fields (line 7870 vs 8258/8273)

**Severity:** CRITICAL -- would not compile (fields don't exist in state class)
**Source location:** Lines 8258, 8273, 8335, 8341, 8360 (enhanced provider at Section 7.2.3)
**Target location:** Line 7870-7876 (SupplementListState definition)
**Problem:** The SupplementListState at line 7870 only has 3 fields: `supplements`, `isLoading`, `error`. But the enhanced provider (line 8246+) references:
- `archivedSupplements` (lines 8258, 8335, 8341, 8360) -- NOT in state class
- `showArchived` (line 8273) -- NOT in state class
**Fix:** Update SupplementListState definition (line 7870) to add missing fields:
```dart
class SupplementListState with _$SupplementListState {
  const factory SupplementListState({
    @Default([]) List<Supplement> supplements,
    @Default([]) List<Supplement> archivedSupplements,
    @Default(false) bool showArchived,
    @Default(false) bool isLoading,
    AppError? error,
  }) = _SupplementListState;
}
```
Note: Fix 15 addresses the duplicate definitions but does NOT fix the missing fields in the state class.

---

### ISSUE-XR-4: FluidsEntryList provider passes `String` to use case expecting `GetTodayFluidsEntryInput` (line 8577)

**Severity:** CRITICAL -- would not compile (type mismatch)
**Source location:** Line 8577 (`todayResult = await todayUseCase(profileId)`)
**Target location:** Line 2276 (GetTodayFluidsEntryUseCase definition)
**Problem:** The provider passes a bare `String profileId` to the use case, but `GetTodayFluidsEntryUseCase` implements `UseCase<GetTodayFluidsEntryInput, FluidsEntry?>` and its `call()` method expects `GetTodayFluidsEntryInput`, not `String`.
**Fix:** Change line 8577 to:
```dart
final todayResult = await todayUseCase(GetTodayFluidsEntryInput(profileId: profileId));
```

---

### ISSUE-XR-5: FluidsState and SyncState missing private constructor for computed properties (lines 8548, 8973)

**Severity:** CRITICAL -- would not compile (Freezed requires private constructor for computed properties)
**Source location:** Lines 8548 (FluidsState), 8973 (SyncState)
**Target location:** Same lines (class definitions)
**Problem:** Both `FluidsState` and `SyncState` have computed getter properties but are missing the `const ClassName._();` private constructor that Freezed requires when a class has custom methods/getters.
- `FluidsState` (line 8548): has `waterProgress` and `waterRemaining` getters but no private constructor
- `SyncState` (line 8973): has `hasPendingChanges` and `hasConflicts` getters but no private constructor
**Fix:** Add private constructors:
- After line 8548: add `const FluidsState._();`
- After line 8973: add `const SyncState._();`

---

### ISSUE-XR-6: `getBBTEntriesUseCaseProvider` and `GetBBTEntriesInput` never defined (line 8679-8680)

**Severity:** HIGH -- would not compile (undefined use case and input class)
**Source location:** Lines 8679-8680 (bbtChartData provider)
**Target location:** N/A -- never defined
**Problem:** The provider calls `ref.read(getBBTEntriesUseCaseProvider)` and constructs `GetBBTEntriesInput(...)`, but neither the use case nor input class is defined anywhere in the spec. The `getBBTEntries` method exists on `FluidsEntryRepository` (line 1991) but there's no use case wrapper.
**Fix:** Either:
- (a) Define `GetBBTEntriesInput` and a `GetBBTEntriesUseCase` wrapping `FluidsEntryRepository.getBBTEntries()`, OR
- (b) Use the existing `GetFluidsEntriesUseCase` and filter BBT entries in the provider

Option (a) is more consistent with the pattern. Add:
```dart
@freezed
class GetBBTEntriesInput with _$GetBBTEntriesInput {
  const factory GetBBTEntriesInput({
    required String profileId,
    required int startDate,  // Epoch ms
    required int endDate,    // Epoch ms
  }) = _GetBBTEntriesInput;
}

class GetBBTEntriesUseCase implements UseCase<GetBBTEntriesInput, List<FluidsEntry>> { ... }
```

---

### ISSUE-XR-7: `getSupplementByIdUseCaseProvider` never defined (line 8383)

**Severity:** HIGH -- would not compile (undefined provider)
**Source location:** Line 8383 (supplement provider)
**Target location:** N/A -- never defined
**Problem:** `ref.read(getSupplementByIdUseCaseProvider)` is used but no such use case is defined. The base `EntityRepository.getById()` exists but there's no wrapping use case with authorization checks for getting a single supplement by ID.
**Fix:** Define a `GetSupplementByIdUseCase` or change the provider to use the repository directly (less safe -- skips authorization).

---

### ISSUE-XR-8: `SignInWithAppleInput` and `SignInWithAppleUseCase` never defined (line 8916, 8921)

**Severity:** HIGH -- would not compile (undefined class and use case)
**Source location:** Lines 8916, 8921 (AuthStateNotifier provider)
**Target location:** N/A -- never defined
**Problem:** The auth provider references `SignInWithAppleInput` (line 8916) and `signInWithAppleUseCaseProvider` (line 8921), but neither the input class nor the use case is defined anywhere. Only `SignInWithGoogleInput` (line 6695) and `SignInWithGoogleUseCase` (line 6712) exist.
**Fix:** Add `SignInWithAppleInput` class and `SignInWithAppleUseCase` class, mirroring the Google counterparts but for Apple Sign-In.

---

### ISSUE-XR-9: SyncService missing 3 methods used by SyncNotifier provider (lines 8993-8995)

**Severity:** HIGH -- would not compile (methods don't exist)
**Source location:** Lines 8993-8995 (SyncNotifier provider)
**Target location:** SyncService (undefined per Fix 70, but even the extracted interface doesn't include these)
**Problem:** The SyncNotifier provider calls:
- `syncService.getPendingChangesCount(profileId)` (line 8993)
- `syncService.getConflictCount(profileId)` (line 8994)
- `syncService.getLastSyncTime(profileId)` (line 8995)
But Fix 70's extracted SyncService interface only has: `pushPendingChanges`, `getPendingChanges`, `pushChanges`, `getLastSyncVersion`, `pullChanges`, `applyChanges`, `resolveConflict`. The 3 convenience count/time methods are not listed.
**Fix:** When defining `SyncService` in Fix 70 (Section 11), also include:
```dart
Future<Result<int, AppError>> getPendingChangesCount(String profileId);
Future<Result<int, AppError>> getConflictCount(String profileId);
Future<int?> getLastSyncTime(String profileId);  // Returns epoch ms or null
```

---

### ISSUE-XR-10: AuthTokenService missing `hasValidToken()` method (line 8862)

**Severity:** MEDIUM -- referenced method not in extracted interface
**Source location:** Line 8862 (`tokenService.hasValidToken()`)
**Target location:** AuthTokenService (Fix 70 only lists `storeTokens`, `clearTokens`)
**Problem:** The auth provider calls `tokenService.hasValidToken()` but Fix 70 extracted only `storeTokens` and `clearTokens` for `AuthTokenService`. `hasValidToken` is missing from the interface definition.
**Fix:** When defining `AuthTokenService` in Fix 70 (Section 11), add:
```dart
Future<bool> hasValidToken();
```

---

### ISSUE-XR-11: `FluidsEntryLocalDataSource.getByDateRange` queries `timestamp` but entity uses `entryDate` (lines 3680-3688 vs 7251)

**Severity:** MEDIUM -- silent data error (wrong column name in SQL)
**Source location:** Lines 3680-3688 (FluidsEntryLocalDataSource.getByDateRange SQL)
**Target location:** Line 7251 (FluidsEntry entity: `required int entryDate`)
**Problem:** The SQL query uses `timestamp` column (`AND timestamp >= ? AND timestamp < ?`), but the FluidsEntry entity uses `entryDate` (line 7251). The DB column would be `entry_date`, not `timestamp`. The same `timestamp` column reference appears in `getBBTEntries` (line 3707-3708), `getTodayEntry` (line 3731-3732).
**Fix:** Change all SQL queries in FluidsEntryLocalDataSource from `timestamp` to `entry_date`:
- Line 3685-3686: Change `timestamp` to `entry_date`
- Line 3707-3708: Same
- Line 3731-3732: Same

---

### ISSUE-XR-12: `NotificationType.supplement`, `.food`, `.fluids`, `.water` don't exist in enum (lines 6009/6017/6144/6154/6159/6164)

**Severity:** CRITICAL -- would not compile (6 references to 4 nonexistent enum values)
**Source location:** Lines 6009, 6017, 6144, 6154, 6159, 6164 (CreateNotificationScheduleUseCase + GetPendingNotificationsUseCase)
**Target location:** Lines 1459-1484 (NotificationType enum definition)
**Problem:** The use case code references 4 enum values that do not exist in NotificationType:
- `NotificationType.supplement` (lines 6009, 6017, 6144) -- enum has `supplementIndividual(0)` and `supplementGrouped(1)`, not `supplement`
- `NotificationType.food` (line 6154) -- enum has `mealBreakfast(2)`, `mealLunch(3)`, `mealDinner(4)`, `mealSnacks(5)`, not `food`
- `NotificationType.fluids` (line 6159) -- enum has `fluidsGeneral(22)` and `fluidsBowel(23)`, not `fluids`
- `NotificationType.water` (line 6164) -- enum has `waterInterval(6)`, `waterFixed(7)`, `waterSmart(8)`, not `water`

This is a systemic mismatch: the enum was designed with granular notification types, but the use case code was written assuming coarse-grained types.

**Fix:** Update the switch statement and validation to use actual enum values. The switch cases need to handle multiple enum values per branch:
```dart
switch (schedule.type) {
  case NotificationType.supplementIndividual:
  case NotificationType.supplementGrouped:
    // Supplement reminder logic...
    break;
  case NotificationType.mealBreakfast:
  case NotificationType.mealLunch:
  case NotificationType.mealDinner:
  case NotificationType.mealSnacks:
    // Meal reminder logic...
    break;
  case NotificationType.fluidsGeneral:
  case NotificationType.fluidsBowel:
    // Fluids reminder logic...
    break;
  case NotificationType.waterInterval:
  case NotificationType.waterFixed:
  case NotificationType.waterSmart:
    // Water reminder logic...
    break;
  // ... remaining cases
}
```
Similarly, the validation at lines 6009/6017 needs to check for `supplementIndividual` or `supplementGrouped` instead of `supplement`.

---

## Summary Table

| # | Location | Entity/Method | Issue | Severity |
|---|----------|---------------|-------|----------|
| XR-1 | 4760/4805 vs 11114 | ConditionLog.severity.toStorageScale() | Method doesn't exist on int | CRITICAL |
| XR-2 | 4690 | ConditionTrend.currentSeverity | Uses undefined Severity type | CRITICAL |
| XR-3 | 8258/8273 vs 7870 | SupplementListState | Missing archivedSupplements, showArchived fields | CRITICAL |
| XR-4 | 8577 vs 2276 | GetTodayFluidsEntryUseCase | Passes String instead of Input class | CRITICAL |
| XR-5 | 8548/8973 | FluidsState, SyncState | Missing private constructor for Freezed computed properties | CRITICAL |
| XR-6 | 8679-8680 | getBBTEntriesUseCaseProvider + Input | Never defined | HIGH |
| XR-7 | 8383 | getSupplementByIdUseCaseProvider | Never defined | HIGH |
| XR-8 | 8916/8921 | SignInWithAppleInput + UseCase | Never defined | HIGH |
| XR-9 | 8993-8995 | SyncService count/time methods | 3 methods not in interface | HIGH |
| XR-10 | 8862 | AuthTokenService.hasValidToken | Method not in extracted interface | MEDIUM |
| XR-11 | 3685/3707/3731 vs 7251 | FluidsEntry SQL uses timestamp not entry_date | Wrong column name | MEDIUM |
| XR-12 | 6009/6017/6144/6154/6159/6164 vs 1459-1484 | NotificationType enum | 4 nonexistent enum values used in 6 places | CRITICAL |

---

## Relationship to Existing Fix Plan

- XR-1 extends Fix 45 (phantom Severity type) to cover additional `.toStorageScale()` calls
- XR-2 is a separate type error in ConditionTrend class, related to Fix 45 but distinct
- XR-3 extends Fix 15 (duplicate SupplementList definitions) with missing state fields
- XR-4 is entirely new -- fluids provider type mismatch
- XR-5 is entirely new -- missing Freezed private constructors in state classes
- XR-6, XR-7 are entirely new -- missing use case/input definitions referenced by providers
- XR-8 is entirely new -- Apple Sign-In support referenced but never defined
- XR-9 extends Fix 70 (undefined SyncService) with 3 additional methods
- XR-10 extends Fix 70 (undefined AuthTokenService) with 1 additional method
- XR-11 is entirely new -- SQL column name vs entity field name mismatch
- XR-12 is entirely new -- NotificationType enum values used in use cases don't match enum definition

**All 12 issues are NEW -- none overlap with the 78 items already in the fix plan.**
