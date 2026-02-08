# Spec Review Report - 2026-02-08 (Contradiction-Focused Pass 5)

## Executive Summary
- Focus: Provider code, Diet/Compliance, Profile management, and missing class definitions
- New contradictions found: 9
- Severity: 6 CRITICAL (would-not-compile), 2 HIGH (missing field/class), 1 MEDIUM

---

## New Contradictions Found

### CRITICAL-1: Profile entity missing `waterGoalMl` field (line 8589 vs 11000-11032)

**Severity:** CRITICAL — would not compile

Provider at line 8589: `profileProvider.valueOrNull?.currentProfile?.waterGoalMl ?? 2500`
Profile entity (11000-11032): No `waterGoalMl` field.

Also, provider method `setWaterGoal` (line 8662-8664) calls `UpdateProfileInput(profileId: ..., waterGoalMl: goalMl)` — both `UpdateProfileInput` and `waterGoalMl` don't exist.

**Fix:** Add `@Default(2500) int waterGoalMl,` to Profile entity definition (after line 11015)

---

### CRITICAL-2: SupplementList.addSupplement passes wrong type (line 7898)

**Severity:** CRITICAL — would not compile (type mismatch)

Provider at line 7898: `useCase(supplement)` — passes `Supplement` object
CreateSupplementUseCase (line 4177): takes `CreateSupplementInput`, not `Supplement`

**Fix:** Change method signature to accept `CreateSupplementInput`:
```dart
Future<Result<Supplement, AppError>> addSupplement(CreateSupplementInput input) async {
  final useCase = ref.read(createSupplementUseCaseProvider);
  final result = await useCase(input);
```

---

### CRITICAL-3: GetConditionsInput — no `activeOnly` field (line 8421 vs 4432-4438)

**Severity:** CRITICAL — would not compile

Provider at line 8419-8422: `GetConditionsInput(profileId: profileId, activeOnly: true)`
GetConditionsInput (4432-4438): Has `status` and `includeArchived`, not `activeOnly`

**Fix:** Change provider to: `GetConditionsInput(profileId: profileId, status: ConditionStatus.active)`

---

### CRITICAL-4: GetNotificationSchedulesInput — class doesn't exist (line 8718)

**Severity:** CRITICAL — would not compile

Provider at line 8718: `GetNotificationSchedulesInput(profileId: profileId)`
No such class is defined anywhere in the spec.

**Fix:** Add input class definition:
```dart
@freezed
class GetNotificationSchedulesInput with _$GetNotificationSchedulesInput {
  const factory GetNotificationSchedulesInput({
    required String profileId,
    NotificationType? type,
    bool enabledOnly = false,
  }) = _GetNotificationSchedulesInput;
}
```

---

### CRITICAL-5: Profile use case layer entirely missing — 3 input classes + 4 use cases undefined

**Severity:** CRITICAL — would not compile (5 provider references to nonexistent classes)

The Profile provider references 5 use case providers and 3 input classes, NONE of which are defined:
- `createProfileUseCaseProvider` + `CreateProfileInput` (line 8176)
- `updateProfileUseCaseProvider` + `UpdateProfileInput` (line 8661-8664)
- `deleteProfileUseCaseProvider` + `DeleteProfileInput` (line 8210-8211)
- `setCurrentProfileUseCaseProvider` (line 8170) — no input class
- `getCurrentUserUseCaseProvider` (line 8869) — no input class

**Fix:** This needs a full section added to 22_API_CONTRACTS.md defining:
1. `CreateProfileInput` class
2. `UpdateProfileInput` class (with `waterGoalMl` field)
3. `DeleteProfileInput` class
4. Use case class stubs for all 5 use cases
This is a larger task — recommend adding as a separate section.

---

### CRITICAL-6: getAccessibleProfilesUseCaseProvider — type mismatch (line 8139-8145)

**Severity:** CRITICAL — would not compile (wrong type)

Provider at line 8139: `final result = await useCase();` — expects `List<Profile>` (used as profiles at line 8143)
`ProfileAuthorizationService.getAccessibleProfiles()` (line 10477): Returns `List<ProfileAccess>`, not `List<Profile>`

ProfileAccess (10486-10494) has `profileId`, `profileName`, `accessLevel` — NO `id`, `isDefault`, `ownerId` fields that the provider accesses.

**Fix:** Either:
- (a) Add a use case that returns `List<Profile>` (wrapping the auth service + profile repo), OR
- (b) Change provider to work with `ProfileAccess` instead of `Profile`

Option (a) is better — the provider should call a use case that fetches actual Profile entities.

---

### HIGH-1: DietViolation entity missing `wasDismissed` field (lines 5232-5233 vs 9454-9472)

**Severity:** HIGH — would not compile

Use case at line 5232: `violations.where((v) => v.wasDismissed != true).length`
Use case at line 5233: `violations.where((v) => v.wasDismissed == true).length`
DietViolation entity (9454-9472): No `wasDismissed` field.

**Fix:** Add `@Default(false) bool wasDismissed,` to DietViolation entity (after line 9467)

---

### HIGH-2: SyncConflict class — referenced but never defined (lines 6897, 6985)

**Severity:** HIGH — would not compile (missing class)

`PushChangesResult` (6897): `required List<SyncConflict> conflicts`
`PullChangesResult` (6985): `required List<SyncConflict> conflicts`
No `SyncConflict` class definition exists in the spec.

**Fix:** Add class definition:
```dart
@freezed
class SyncConflict with _$SyncConflict {
  const factory SyncConflict({
    required String id,
    required String entityType,
    required String entityId,
    required String localVersion,   // JSON of local entity
    required String remoteVersion,  // JSON of remote entity
    required int localUpdatedAt,    // Epoch ms
    required int remoteUpdatedAt,   // Epoch ms
    ConflictResolution? resolution,
  }) = _SyncConflict;
}
```

---

### MEDIUM-1: PreLogComplianceCheck passes DateTime, CheckCompliance passes int to same service method (lines 5086 vs 9590)

**Severity:** MEDIUM — inconsistent types

Line 5086: `checkFoodAgainstRules(food, diet.rules, logTime)` — `logTime` is `DateTime`
Line 9590: `checkFoodAgainstRules(input.foodItem, diet.rules, input.logTimeEpoch)` — `input.logTimeEpoch` is `int`

**Fix:** Change line 5086 to pass `input.logTimeEpoch` (int) directly, consistent with Rule 5.2.1. Remove the DateTime conversion at line 5085.

---

## Summary Table

| # | Location | Entity/Method | Issue | Severity |
|---|----------|---------------|-------|----------|
| C1 | 8589 vs 11000 | Profile.waterGoalMl | Field doesn't exist | CRITICAL |
| C2 | 7898 vs 4177 | SupplementList.addSupplement | Passes Supplement instead of CreateSupplementInput | CRITICAL |
| C3 | 8421 vs 4432 | GetConditionsInput.activeOnly | Field doesn't exist (has `status` instead) | CRITICAL |
| C4 | 8718 | GetNotificationSchedulesInput | Class doesn't exist | CRITICAL |
| C5 | 8176/8661/8210/8170/8869 | Profile use cases | 5 use cases + 3 input classes undefined | CRITICAL |
| C6 | 8139 vs 10477 | getAccessibleProfiles return type | Returns ProfileAccess, not Profile | CRITICAL |
| H1 | 5232 vs 9454 | DietViolation.wasDismissed | Field doesn't exist | HIGH |
| H2 | 6897/6985 | SyncConflict | Class never defined | HIGH |
| M1 | 5086 vs 9590 | checkFoodAgainstRules | Inconsistent param type (DateTime vs int) | MEDIUM |

---

## Relationship to Existing Fix Plan

- C1 and C5 are related — Profile entity needs `waterGoalMl`, and the Profile use case layer needs to be created
- C2-C4, C6 are provider-layer issues not previously audited
- H1-H2 are in Diet/Sync subsystems not previously deeply checked
- **All are NEW** — none overlap with the 60 items already in the fix plan
