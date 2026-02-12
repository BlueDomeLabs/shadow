# Spec Update Plan

**Created:** 2026-02-10
**Status:** COMPLETE (committed as ef1a5b9)
**Prerequisite:** Must be completed BEFORE the Implementation Update Plan
**Scope:** Updates to 22_API_CONTRACTS.md to add missing constants and align spec code examples with Coding Standards Rule 7.2

---

## Why This Is Needed

Coding Standards Rule 7.2 states:
> "No Hardcoded Validation Limits: All validation limits (field lengths, numeric ranges, collection sizes) MUST reference constants from ValidationRules."

Coding Standards Rule 16.1 states:
> "All code examples in specification documents MUST follow these coding standards."

Currently, 22_API_CONTRACTS.md has hardcoded values in its code examples that violate Rule 7.2 as applied via Rule 16.1. Additionally, 5 UI display constants were added to the implementation's `ValidationRules` but NOT to the spec — creating a spec/code mismatch.

---

## PART 1: Add Missing Constants to ValidationRules (Section 6)

All additions go into 22_API_CONTRACTS.md Section 6, inside the `ValidationRules` class (after line 7822, before the closing `}`).

### 1A. UI Display Constants (Already in code, NOT in spec)

These 5 constants were added to `lib/core/validation/validation_rules.dart` in commit `30e37cd` but were not added to the spec. The spec must be updated to match.

```dart
// ===== UI display constants =====
static const int earliestSelectableYear = 2000;
static const int journalSnippetMaxLength = 100;
static const int defaultPickerMaxTimes = 5;
static const int badgeMaxDisplayCount = 99;
static const int photoGalleryColumns = 3;
```

**Coding Standards compliance:**
- These are numeric limits used in presentation code (date picker year bounds, snippet truncation, picker max, badge cap, grid columns)
- Rule 7.2 requires centralized constants for numeric limits
- No other rule prohibits UI constants in ValidationRules
- **COMPLIANT**

### 1B. Future Timestamp Tolerance

```dart
// ===== Time validation constants =====
static const int maxFutureTimestampToleranceMs = 60 * 60 * 1000; // 1 hour
```

**Coding Standards compliance:**
- This is a numeric range used in timestamp validation (8 use cases check `timestamp > now + (60 * 60 * 1000)`)
- Rule 7.2 explicitly requires validation limits in ValidationRules
- **COMPLIANT**

### 1C. Default Search Limit

```dart
// ===== Search defaults =====
static const int defaultSearchLimit = 20;
```

**Coding Standards compliance:**
- This is a collection size limit used in repository method signatures
- Rule 7.2 covers "collection sizes"
- **COMPLIANT**

### 1D. Meal Time Detection Boundaries

```dart
// ===== Meal time detection =====
// Per 38_UI_FIELD_SPECIFICATIONS.md Section 5.1
static const int breakfastStartHour = 5;
static const int breakfastEndHour = 10;
static const int lunchStartHour = 11;
static const int lunchEndHour = 14;
static const int dinnerStartHour = 15;
static const int dinnerEndHour = 20;
```

**Coding Standards compliance:**
- These are numeric range boundaries used in meal type auto-detection logic
- Already specified in 38_UI_FIELD_SPECIFICATIONS.md Section 5.1 but not in ValidationRules
- Rule 7.2 requires centralization; Rule 16.2.1 requires single source of truth
- **COMPLIANT**

### 1E. Sleep UI Constraints

```dart
// ===== Sleep UI constraints =====
static const int timesAwakenedMax = 20;
```

**Coding Standards compliance:**
- This is a numeric range used in sleep entry UI field validation (`_RangeTextInputFormatter(min: 0, max: 20)`)
- Rule 7.2 requires centralization
- **COMPLIANT**

### 1F. Snooze Duration Valid Values

```dart
// ===== Intake snooze durations =====
// Per 38_UI_FIELD_SPECIFICATIONS.md Section 4.2
static const List<int> validSnoozeDurationMinutes = [5, 10, 15, 30, 60];
```

**Coding Standards compliance:**
- These are the allowed values for snooze duration, currently in 22_API_CONTRACTS.md as a comment (`// 5/10/15/30/60 min when snoozed` on line 11974) and hardcoded in `MarkSnoozedUseCase.validDurations`
- Rule 7.2 requires centralization of validation limits
- Moving from use case static const to ValidationRules is more centralized
- **COMPLIANT**

### 1G. Sleep Import Sources

```dart
// ===== Import source validation =====
static const List<String> validSleepImportSources = [
  'healthkit',
  'googlefit',
  'apple_watch',
  'fitbit',
  'garmin',
  'manual',
];
```

**Coding Standards compliance:**
- These are validated values used in `LogSleepEntryUseCase._validate()` (line 130-137 of use case)
- Currently hardcoded as a local variable in the use case
- Rule 7.2: validation limits must be centralized
- **COMPLIANT**

### 1H. Tag Preview Limit

```dart
// ===== Tag display =====
static const int tagPreviewMaxCount = 3;
```

**Coding Standards compliance:**
- This is a collection size limit for UI tag display
- Rule 7.2 covers "collection sizes"
- **COMPLIANT**

---

## PART 2: Update Spec Code Examples to Use New Constants

After adding the constants above, the following code examples in 22_API_CONTRACTS.md must be updated to reference them.

### 2A. Future Timestamp Tolerance (7 use case examples)

**Lines affected:** 2720, 2995, 3330, 3482, 3737, 3873, 4941

**Before (each occurrence):**
```dart
final oneHourFromNow = now + (60 * 60 * 1000);
```

**After:**
```dart
final oneHourFromNow = now + ValidationRules.maxFutureTimestampToleranceMs;
```

**Coding Standards compliance:** Rule 16.1 + Rule 7.2. **COMPLIANT**

### 2B. Default Search Limit (6 repository signatures)

**Lines affected:** 2011, 3992, 4261, 12070, 12079, 12645

**Before (each occurrence):**
```dart
int limit = 20,
```

**After:**
```dart
int limit = ValidationRules.defaultSearchLimit,
```

**Coding Standards compliance:** Rule 16.1 + Rule 7.2. **COMPLIANT**

### 2C. Snooze Duration in IntakeLog Entity Comment

**Line affected:** 11974

**Before:**
```dart
int? snoozeDurationMinutes,           // 5/10/15/30/60 min when snoozed
```

**After:**
```dart
int? snoozeDurationMinutes,           // See ValidationRules.validSnoozeDurationMinutes
```

**Coding Standards compliance:** Rule 16.2.2 — use cross-references, not duplicated values. **COMPLIANT**

---

## PART 3: Items NOT Included (With Rationale)

### 3A. `millisecondsPerDay` — NOT added to ValidationRules

Dart provides `Duration.millisecondsPerDay` as a built-in constant. The spec already uses it (15+ occurrences). Creating a `ValidationRules.millisecondsPerDay` would be redundant. Implementation DAOs that use `86400000` should use `Duration.millisecondsPerDay` instead — that is an implementation fix, not a spec change.

### 3B. Anchor Event Default Times — NOT added to ValidationRules

The anchor event times in `supplement_repository_impl.dart` (`7 * 60` for wake, `8 * 60` for breakfast, etc.) are user preference defaults, NOT validation limits. The code comment says "In production, these would come from user preferences." These do not belong in ValidationRules. They can remain as local constants until user preferences are implemented.

### 3C. `SyncMetadata.forCreate()` factory — NOT added

The `syncDeviceId: ''` placeholder pattern is by design. `BaseRepository.createSyncMetadata()` populates the real device ID (Coding Standard Section 3.4). Changing the `SyncMetadata` definition is a structural spec change with no behavioral benefit.

### 3D. Shared Widget Patterns — NOT spec changes

Extracting `ShadowErrorState`, `ShadowEmptyState`, `ShadowSectionHeader` are implementation refactors, not spec-level changes. Widget library specs are in `09_WIDGET_LIBRARY.md` and would need separate updates if new widgets are added. Deferred to a future refactoring project.

### 3E. Error Handling / Logging Patterns — NOT spec changes

Adding logging to DAO catch blocks and screen error handlers are implementation quality improvements. The spec already shows the `Result<T, AppError>` pattern. The fact that implementations silently swallow exceptions is an implementation deficiency, not a spec gap.

---

## Verification Checklist (After Spec Updates)

- [ ] All new constants are inside `ValidationRules` class in Section 6
- [ ] All constants use correct types (`int`, `double`, `List<int>`, `List<String>`)
- [ ] All code examples in Section 4.2 use `ValidationRules.maxFutureTimestampToleranceMs`
- [ ] All repository signatures in Sections 4.3, 10.x use `ValidationRules.defaultSearchLimit`
- [ ] IntakeLog entity comment references `ValidationRules.validSnoozeDurationMinutes`
- [ ] No Dart `DateTime` objects in entity fields (Rule 5.2)
- [ ] No implicit enum values (Rule 9.1.1)
- [ ] Cross-references used per Rule 16.2.2

---

## Execution Notes for Next Instance

1. Open `22_API_CONTRACTS.md`
2. Navigate to Section 6, line ~7822 (before closing `}` of `ValidationRules`)
3. Add all constants from Part 1 (1A through 1H) in order
4. Navigate to each line listed in Part 2 and make the replacements
5. Run `flutter test` — spec changes are documentation only, no code changed yet, all tests should still pass
6. Commit with message: `Update 22_API_CONTRACTS.md: add ValidationRules constants per Coding Standards Rule 7.2`
7. THEN proceed to the Implementation Update Plan
