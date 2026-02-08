# Spec Review Report - 2026-02-08 (Contradiction-Focused Pass 3)

## Executive Summary
- Focus: Critical would-not-compile issues in Auth and Wearable subsystems
- New contradictions found: 9
- Severity: 7 CRITICAL (would-not-compile), 2 HIGH (wrong factory name/args)

---

## New Contradictions Found

### CRITICAL-1: UserAccount — `lastSignInAt` vs entity `lastLoginAt` (lines 6757/6780 vs 11736)

**Severity:** CRITICAL — would not compile (field name mismatch)

Use case at line 6757: `lastSignInAt: now,` (in `.copyWith`)
Use case at line 6780: `lastSignInAt: now,` (in constructor)
Entity at line 11736: `int? lastLoginAt,` — different name

**Fix:** Update entity field from `lastLoginAt` to `lastSignInAt` (matches use case; "sign in" is more accurate since the app uses OAuth, not username/password login).

---

### CRITICAL-2: AuthError.invalidToken — factory doesn't exist (line 6732)

**Severity:** CRITICAL — would not compile

Use case at line 6732: `return Failure(AuthError.invalidToken('Google token verification failed'));`
AuthError factories (lines 253-302): `unauthorized`, `profileAccessDenied`, `tokenExpired`, `tokenRefreshFailed`, `signInFailed`, `signOutFailed`, `permissionDenied` — NO `invalidToken`.

**Fix:** Add factory to AuthError:
```dart
factory AuthError.invalidToken(String reason) => AuthError._(
  code: codeInvalidToken,
  message: 'Invalid token: $reason',
  userMessage: 'Authentication failed. Please sign in again.',
);
```
Also add `static const String codeInvalidToken = 'AUTH_INVALID_TOKEN';`

---

### CRITICAL-3: AuthError.accountDeactivated — factory doesn't exist (line 6753)

**Severity:** CRITICAL — would not compile

Use case at line 6753: `return Failure(AuthError.accountDeactivated(user.deactivatedReason));`
AuthError factories (lines 253-302): NO `accountDeactivated`.

**Fix:** Add factory to AuthError:
```dart
factory AuthError.accountDeactivated(String? reason) => AuthError._(
  code: codeAccountDeactivated,
  message: 'Account deactivated: ${reason ?? 'No reason given'}',
  userMessage: 'This account has been deactivated.',
  isRecoverable: false,
  recoveryAction: RecoveryAction.none,
);
```
Also add `static const String codeAccountDeactivated = 'AUTH_ACCOUNT_DEACTIVATED';`

---

### CRITICAL-4: SyncWearableDataInput — missing 4 fields used by use case (line 10188 vs 6438-6467)

**Severity:** CRITICAL — would not compile (4 missing fields)

Input definition (10188-10193) has: `{profileId, platform, sinceEpoch}`
Use case references:
- `input.startDate` (line 6438) — NOT in input
- `input.endDate` (line 6440) — NOT in input
- `input.dataTypes` (line 6448) — NOT in input
- `input.clientId` (line 6467) — NOT in input

**Fix:** Update SyncWearableDataInput to add:
```dart
required String clientId,
int? startDate,          // Epoch ms, null uses connection.lastSyncAt
int? endDate,            // Epoch ms, null uses current time
@Default([]) List<String> dataTypes,  // Empty = use connection.readPermissions
```
Remove `sinceEpoch` (superseded by `startDate`).

---

### CRITICAL-5: ConnectWearableInput — missing `enableBackgroundSync` field (line 10167 vs 6336)

**Severity:** CRITICAL — would not compile

Input definition (10167-10173) has: `{profileId, clientId, platform, requestedPermissions}`
Use case at line 6336: `backgroundSyncEnabled: input.enableBackgroundSync` — field NOT in input.

**Fix:** Add to ConnectWearableInput:
```dart
@Default(false) bool enableBackgroundSync,
```

---

### CRITICAL-6: WearableError.notConnected — factory doesn't exist (line 6433)

**Severity:** CRITICAL — would not compile

Use case at line 6433: `return Failure(WearableError.notConnected(input.platform));`
WearableError factories (lines 555-637): NO `notConnected`.

**Fix:** Add factory to WearableError:
```dart
factory WearableError.notConnected(String platform) =>
  WearableError._(
    code: codeNotConnected,
    message: '$platform is not connected',
    userMessage: '$platform is not connected. Please connect first.',
    isRecoverable: true,
    recoveryAction: RecoveryAction.connectWearable,
  );
```
Also add `static const String codeNotConnected = 'WEARABLE_NOT_CONNECTED';`

---

### CRITICAL-7: WearableError.platformNotAvailable — wrong factory name (line 6301)

**Severity:** CRITICAL — would not compile (wrong method name)

Use case at line 6301: `WearableError.platformNotAvailable(input.platform)`
Actual factory (line 589): `WearableError.platformUnavailable(platform)`

**Fix:** Change use case to `WearableError.platformUnavailable(input.platform.name)`

---

### HIGH-1: WearableError.permissionsDenied — wrong name AND wrong arg count (line 6315)

**Severity:** HIGH — would not compile (wrong name + wrong arg count)

Use case at line 6315: `WearableError.permissionsDenied(input.platform)` — 1 arg, plural name
Actual factory (line 631): `WearableError.permissionDenied(String platform, String permission)` — 2 args, singular name

**Fix:** Change use case to `WearableError.permissionDenied(input.platform.name, 'health data access')`

---

### HIGH-2: UserAccount entity missing `isActive` default (line 11737 vs 6777)

**Severity:** HIGH — inconsistency

Use case at line 6777: constructs UserAccount with `isActive: true`
Entity at line 11737: `@Default(true) bool isActive` — already has default

This is actually OK (entity has the default), but it means the use case is passing a redundant value. Not a compile error but worth noting the use case doesn't need to pass this. **No fix needed.**

---

## Summary Table

| # | Location | Entity/Method | Issue | Severity |
|---|----------|---------------|-------|----------|
| C1 | 6757 vs 11736 | UserAccount.lastSignInAt | Field name: `lastSignInAt` vs `lastLoginAt` | CRITICAL |
| C2 | 6732 vs 253 | AuthError.invalidToken | Factory doesn't exist | CRITICAL |
| C3 | 6753 vs 253 | AuthError.accountDeactivated | Factory doesn't exist | CRITICAL |
| C4 | 6438 vs 10188 | SyncWearableDataInput | Missing 4 fields: clientId, startDate, endDate, dataTypes | CRITICAL |
| C5 | 6336 vs 10167 | ConnectWearableInput | Missing enableBackgroundSync field | CRITICAL |
| C6 | 6433 vs 555 | WearableError.notConnected | Factory doesn't exist | CRITICAL |
| C7 | 6301 vs 589 | WearableError.platformNotAvailable | Wrong name (should be platformUnavailable) | CRITICAL |
| H1 | 6315 vs 631 | WearableError.permissionsDenied | Wrong name (singular) + wrong arg count (needs 2) | HIGH |
| H2 | 6777 vs 11737 | UserAccount.isActive | Redundant explicit value (has default) | LOW-info only |

---

## Relationship to Existing Fix Plan

- C1 (lastSignInAt) is partially related to Fix 16 (avatarUrl) — same entity, different field
- C2-C3 are in the Auth subsystem, not previously audited for missing factories
- C4-C7, H1 are in the Wearable subsystem alongside Fixes 36-43
- **All are NEW** — none overlap with the 46 items already in the fix plan
