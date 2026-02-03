# Shadow Specification Validation Fixes

**Version:** 1.0
**Created:** February 1, 2026
**Purpose:** Fixes identified by automated specification validator (`scripts/validate_spec.dart`)
**Status:** IN PROGRESS

---

## Overview

Automated validation of 52 spec files found:
- **43 Errors**: Enum inconsistencies, missing required fields
- **33 Warnings**: Missing repository methods, DateTime type usage
- **623 Dart code blocks** analyzed across all documents

---

## Critical Errors: Enum Inconsistencies

### E1. NotificationType Enum [CRITICAL]

**Problem:** 4 different definitions across documents with incompatible values.

**Canonical Definition (to be used everywhere):**
```dart
// 22_API_CONTRACTS.md - AUTHORITATIVE
enum NotificationType {
  // Supplements (0-1)
  supplement(0),
  supplementGroup(1),

  // Food/Meals (2-6)
  food(2),
  mealBreakfast(3),
  mealLunch(4),
  mealDinner(5),
  mealSnacks(6),

  // Fluids (7-8)
  fluids(7),
  water(8),

  // Health tracking (9-11)
  bbt(9),
  menstruation(10),
  condition(11),

  // Other tracking (12-15)
  photo(12),
  journal(13),
  activity(14),
  sleep(15),

  // System (16)
  sync(16),

  // Diet (17-21)
  fastingWindowOpen(17),
  fastingWindowClose(18),
  dietViolation(19),
  dietStreak(20),
  dietWeekly(21),
  ;

  final int value;
  const NotificationType(this.value);
}
```

**Documents to Update:**
- [ ] 37_NOTIFICATIONS.md - Align to canonical
- [ ] 46_AUDIT_FIXES_ROUND3.md - Align to canonical
- [ ] 48_AUDIT_FIXES_ROUND5.md - Align to canonical

---

### E2. SyncStatus Enum [CRITICAL]

**Canonical Definition:**
```dart
enum SyncStatus {
  pending(0),    // Not yet synced
  synced(1),     // Successfully synced
  modified(2),   // Modified since last sync
  conflict(3),   // Conflict detected
  deleted(4),    // Soft deleted, pending sync
  ;

  final int value;
  const SyncStatus(this.value);
}
```

**Documents to Update:**
- [ ] 02_CODING_STANDARDS.md - Add modified(2), deleted(4)
- [ ] 47_AUDIT_FIXES_ROUND4.md - Align examples

---

### E3. AccessLevel Enum [HIGH]

**Canonical Definition:**
```dart
enum AccessLevel {
  readOnly(0),
  readWrite(1),
  owner(2),      // Full control
  ;

  final int value;
  const AccessLevel(this.value);
}
```

**Documents to Update:**
- [ ] 35_QR_DEVICE_PAIRING.md
- [ ] 46_AUDIT_FIXES_ROUND3.md

---

### E4. ConflictResolution Enum [HIGH]

**Canonical Definition:**
```dart
enum ConflictResolution {
  keepLocal,   // Use local version
  keepRemote,  // Use remote version
  merge,       // Merge compatible changes
}
```

**Documents to Update:**
- [ ] 04_ARCHITECTURE.md (uses localWins/remoteWins)
- [ ] 35_QR_DEVICE_PAIRING.md (uses different names)

---

### E5. RecoveryAction Enum [HIGH]

**Canonical Definition:**
```dart
enum RecoveryAction {
  none,
  retry,
  refreshToken,
  reAuthenticate,
  goToSettings,
  contactSupport,
  checkConnection,
  freeStorage,
}
```

**Documents to Update:**
- [ ] 46_AUDIT_FIXES_ROUND3.md

---

### E6. DeviceType Enum [MEDIUM]

**Canonical Definition (from 22_API_CONTRACTS.md):**
```dart
enum DeviceType {
  iOS(0),
  android(1),
  macOS(2),
  web(3);

  final int value;
  const DeviceType(this.value);
}
```

**Documents Updated:**
- [x] 35_QR_DEVICE_PAIRING.md - Updated to match canonical definition

---

## High Priority: Missing Repository Methods

Use cases call these methods but they're not in repository interfaces.

### Methods to Add to 22_API_CONTRACTS.md

```dart
// DietRepository - Add:
Future<Result<Diet?, AppError>> getActiveDiet(String profileId);

// FoodLogRepository - Add:
Future<Result<List<FoodLog>, AppError>> getByDateRange(
  String profileId,
  int startDate,
  int endDate,
);

// ConditionLogRepository - Add:
Future<Result<List<ConditionLog>, AppError>> getByProfile(
  String profileId, {
  int? startDate,
  int? endDate,
});

Future<Result<List<ConditionLog>, AppError>> getByCondition(
  String conditionId, {
  int? startDate,
  int? endDate,
});

// PatternRepository - Add:
Future<Result<List<Pattern>, AppError>> getByProfile(String profileId);
Future<Result<Pattern?, AppError>> findSimilar(Pattern pattern);

// FoodItemRepository - Add:
Future<Result<List<FoodItem>, AppError>> searchExcludingCategories(
  String query, {
  required List<FoodCategory> excludeCategories,
  int limit = 10,
});

// IntakeLogRepository - Add:
Future<Result<List<IntakeLog>, AppError>> getByProfile(
  String profileId, {
  int? startDate,
  int? endDate,
});

// ActivityLogRepository - Add:
Future<Result<ActivityLog?, AppError>> getByExternalId(
  String profileId,
  String externalId,
);

// ProfileRepository - Add:
Future<Result<List<Profile>, AppError>> getByUser(String userId);

// ConditionRepository - Add:
Future<Result<List<Condition>, AppError>> getByProfile(
  String profileId, {
  bool? activeOnly,
  String? categoryId,
  int? limit,
  int? offset,
});
```

---

## Medium Priority: DateTime Type Fixes

Change `DateTime` to `int` (epoch milliseconds) in these files:

| File | Lines | Count |
|------|-------|-------|
| 42_INTELLIGENCE_SYSTEM.md | 73, 229, 352, 480, 551, 836, 1095 | 7 |
| 22_API_CONTRACTS.md | 4386 | 1 |
| 18_PHOTO_PROCESSING.md | 139 | 1 |
| 35_QR_DEVICE_PAIRING.md | 721, 1038 | 2 |

---

## Implementation Tracking

### Phase 1: Critical Enums (Blocking)
- [ ] E1: NotificationType - Standardize to 22 values
- [ ] E2: SyncStatus - Add modified, deleted
- [ ] E3: AccessLevel - Use owner not admin
- [ ] E4: ConflictResolution - Use keepLocal/keepRemote/merge
- [ ] E5: RecoveryAction - Use full names
- [ ] E6: DeviceType - Use lowercase

### Phase 2: Repository Methods
- [ ] Add 10 missing repository methods to 22_API_CONTRACTS.md

### Phase 3: DateTime Fixes
- [ ] Fix 11 DateTime → int conversions

---

## Validation Command

```bash
dart run scripts/validate_spec.dart
```

**Target:** 0 errors, 0 warnings

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-02-01 | Initial creation from automated validation |
