# Implementation Update Plan

**Created:** 2026-02-10
**Status:** READY FOR IMPLEMENTATION
**Prerequisite:** The Spec Update Plan MUST be completed and committed FIRST
**Scope:** Update all implementation code to EXACTLY match the updated spec documents
**Tests:** 1919 tests currently passing; all must continue to pass after each phase

---

## PHASE 1: Critical Bug Fix (1 file, 1 test file to verify)

### 1.1 BBT Widget Temperature Mismatch — CRITICAL

**Spec reference:** 22_API_CONTRACTS.md Section 6, `bbtMaxCelsius = 40.6`
**Current code:** `lib/presentation/widgets/shadow_input.dart:268` has `_maxC = 40.5`
**Bug impact:** Rejects valid Celsius temperatures 40.5-40.6

**Changes to `lib/presentation/widgets/shadow_input.dart`:**

1. Add import:
```dart
import 'package:shadow_app/core/validation/validation_rules.dart';
```

2. Replace lines 265-268:
```dart
// BEFORE:
static const _minF = 95.0;
static const _maxF = 105.0;
static const _minC = 35.0;
static const _maxC = 40.5;

// AFTER:
static const _minF = ValidationRules.bbtMinFahrenheit;
static const _maxF = ValidationRules.bbtMaxFahrenheit;
static const _minC = ValidationRules.bbtMinCelsius;
static const _maxC = ValidationRules.bbtMaxCelsius;
```

**Test impact:** `test/presentation/widgets/shadow_input_test.dart:75` expects `'95.0 - 105.0 °F'`. Since `ValidationRules.bbtMinFahrenheit` is `double` typed as `95`, Dart's string interpolation produces `'95.0'`. Test should pass unchanged. VERIFY.

---

## PHASE 2: Replace Hardcoded Values With Spec Constants (~25 files)

**Prerequisite:** Spec Update Plan committed (constants exist in spec)

### 2.1 Mood/Severity Sliders (2 files)

**Spec reference:** 22_API_CONTRACTS.md Section 6, `moodMin = 1`, `moodMax = 10`, `severityMin = 1`, `severityMax = 10`

**`lib/presentation/screens/journal_entries/journal_entry_edit_screen.dart` (~line 322-325):**
```dart
// BEFORE:
Slider(
  value: _selectedMood ?? 5,
  min: 1,
  max: 10,
  divisions: 9,

// AFTER:
Slider(
  value: _selectedMood ?? ValidationRules.moodMin.toDouble(),
  min: ValidationRules.moodMin.toDouble(),
  max: ValidationRules.moodMax.toDouble(),
  divisions: ValidationRules.moodMax - ValidationRules.moodMin,
```

**Note:** The `?? 5` default for mood needs review. The midpoint of 1-10 is 5.5, but 5 is a reasonable default. Use `?? ValidationRules.moodMin.toDouble()` to default to minimum (no mood selected state). Actually, review how `_selectedMood` works — if it's nullable, `?? 5` may be intentional as a slider starting position. Keep `?? 5` ONLY if the original UX intent is for the slider to start mid-range. Otherwise use `?? ValidationRules.moodMin.toDouble()`. Check the full context before deciding.

**`lib/presentation/screens/condition_logs/condition_log_screen.dart` (~line 349-353):**
```dart
// BEFORE:
Slider(
  value: _severity,
  min: 1,
  max: 10,
  divisions: 9,

// AFTER:
Slider(
  value: _severity,
  min: ValidationRules.severityMin.toDouble(),
  max: ValidationRules.severityMax.toDouble(),
  divisions: ValidationRules.severityMax - ValidationRules.severityMin,
```

**Test impact:** Check test files for hardcoded `1`, `10`, `9` in slider expectations. Update if needed.

### 2.2 Future Timestamp Tolerance (8 use case files)

**Spec reference:** 22_API_CONTRACTS.md Section 4.2 (updated to use `ValidationRules.maxFutureTimestampToleranceMs`)

**Files and changes (identical pattern in each):**

| File | Import needed? |
|------|---------------|
| `lib/domain/usecases/sleep_entries/log_sleep_entry_use_case.dart` | Already imports ValidationRules |
| `lib/domain/usecases/sleep_entries/update_sleep_entry_use_case.dart` | Already imports ValidationRules |
| `lib/domain/usecases/activity_logs/log_activity_use_case.dart` | Already imports ValidationRules |
| `lib/domain/usecases/food_logs/log_food_use_case.dart` | Already imports ValidationRules |
| `lib/domain/usecases/condition_logs/log_condition_use_case.dart` | Already imports ValidationRules |
| `lib/domain/usecases/photo_entries/create_photo_entry_use_case.dart` | Already imports ValidationRules |
| `lib/domain/usecases/journal_entries/create_journal_entry_use_case.dart` | Already imports ValidationRules |
| `lib/domain/usecases/flare_ups/log_flare_up_use_case.dart` | Check — may need import |

```dart
// BEFORE (in each file):
final oneHourFromNow = now + (60 * 60 * 1000);

// AFTER:
final oneHourFromNow = now + ValidationRules.maxFutureTimestampToleranceMs;
```

**Test impact:** Use case tests may reference `60 * 60 * 1000` in test setup. Search all 8 test files for this pattern and update consistently. Tests should use the same constant.

### 2.3 Milliseconds Per Day (6 files — use Dart built-in)

**Spec reference:** 22_API_CONTRACTS.md already uses `Duration.millisecondsPerDay` (Dart built-in). Implementation DAOs use `86400000` instead.

**DAO files (3 files, identical pattern):**

| File | Line |
|------|------|
| `lib/data/datasources/local/daos/activity_log_dao.dart` | 185 |
| `lib/data/datasources/local/daos/sleep_entry_dao.dart` | 178 |
| `lib/data/datasources/local/daos/food_log_dao.dart` | 183 |

```dart
// BEFORE:
final endOfDay = date + 86400000; // 24 hours in ms

// AFTER:
final endOfDay = date + Duration.millisecondsPerDay; // 24 hours in ms
```

**`lib/data/datasources/local/daos/intake_log_dao.dart` line 270:**
```dart
// BEFORE:
final endOfDay = date + (24 * 60 * 60 * 1000) - 1;

// AFTER:
final endOfDay = date + Duration.millisecondsPerDay - 1;
```

**Use case files (2 files):**

| File | Line | Context |
|------|------|---------|
| `lib/domain/usecases/sleep_entries/log_sleep_entry_use_case.dart` | 87 | max sleep duration |
| `lib/domain/usecases/sleep_entries/update_sleep_entry_use_case.dart` | 90 | max sleep duration |

```dart
// BEFORE:
final maxWakeTime = input.bedTime + (24 * 60 * 60 * 1000);

// AFTER:
final maxWakeTime = input.bedTime + Duration.millisecondsPerDay;
```

**Test impact:** Search test files for `86400000` and `24 * 60 * 60 * 1000`. Tests use these in test data setup — leave those as literal values in tests (test constants are acceptable).

### 2.4 Default Search Limit (7 source files + regenerate)

**Spec reference:** 22_API_CONTRACTS.md Section 4.3 (updated to use `ValidationRules.defaultSearchLimit`)

**Files and changes:**

| File | Line(s) | Import needed? |
|------|---------|---------------|
| `lib/domain/repositories/supplement_repository.dart` | 35 | Yes |
| `lib/domain/repositories/food_item_repository.dart` | 29, 40 | Yes |
| `lib/data/repositories/supplement_repository_impl.dart` | 117 | Already has |
| `lib/data/repositories/food_item_repository_impl.dart` | 94, 105 | Already has |
| `lib/data/datasources/local/daos/supplement_dao.dart` | 226 | Yes |
| `lib/data/datasources/local/daos/food_item_dao.dart` | 178 | Yes |

```dart
// BEFORE (each occurrence):
int limit = 20,

// AFTER:
int limit = ValidationRules.defaultSearchLimit,
```

**IMPORTANT:** Also check `lib/domain/usecases/food_items/food_item_inputs.dart` (the SOURCE for the freezed input). If it has `@Default(20) int limit`, change to `@Default(ValidationRules.defaultSearchLimit) int limit`. Then run `dart run build_runner build --delete-conflicting-outputs` to regenerate `.freezed.dart` files.

**Test impact:** Tests that pass `limit: 20` explicitly are fine. Tests that rely on the default value are also fine since the value doesn't change.

### 2.5 Meal Time Detection Boundaries (1 file)

**Spec reference:** 22_API_CONTRACTS.md Section 6 (updated) + 38_UI_FIELD_SPECIFICATIONS.md Section 5.1

**`lib/presentation/screens/food_logs/food_log_screen.dart` (~lines 75-78):**
```dart
// BEFORE:
if (hour >= 5 && hour <= 10) return MealType.breakfast;
if (hour >= 11 && hour <= 14) return MealType.lunch;
if (hour >= 15 && hour <= 20) return MealType.dinner;

// AFTER:
if (hour >= ValidationRules.breakfastStartHour && hour <= ValidationRules.breakfastEndHour) return MealType.breakfast;
if (hour >= ValidationRules.lunchStartHour && hour <= ValidationRules.lunchEndHour) return MealType.lunch;
if (hour >= ValidationRules.dinnerStartHour && hour <= ValidationRules.dinnerEndHour) return MealType.dinner;
```

**Import needed:** Check if `validation_rules.dart` is already imported. If not, add it.

**Test impact:** Check `food_log_screen_test.dart` for any tests that verify meal detection. Values don't change, so tests should pass.

### 2.6 Snooze Duration Valid Values (2 files)

**Spec reference:** 22_API_CONTRACTS.md Section 6 (updated with `ValidationRules.validSnoozeDurationMinutes`)

**`lib/domain/usecases/intake_logs/mark_snoozed_use_case.dart` line 26:**
```dart
// BEFORE:
static const validDurations = [5, 10, 15, 30, 60];

// AFTER:
static const validDurations = ValidationRules.validSnoozeDurationMinutes;
```

**`lib/presentation/screens/intake_logs/intake_log_screen.dart` line 74:**
```dart
// BEFORE:
static const _snoozeDurations = [5, 10, 15, 30, 60];

// AFTER:
static const _snoozeDurations = ValidationRules.validSnoozeDurationMinutes;
```

**Import needed:** Check both files for ValidationRules import.

**Test impact:** No value change. Verify tests still pass.

### 2.7 Times Awakened Max (1 file)

**Spec reference:** 22_API_CONTRACTS.md Section 6 (updated with `timesAwakenedMax = 20`)

**`lib/presentation/screens/sleep_entries/sleep_entry_edit_screen.dart` (~lines 288-295):**
```dart
// BEFORE:
helperText: '0-20',
inputFormatters: [
  FilteringTextInputFormatter.digitsOnly,
  _RangeTextInputFormatter(min: 0, max: 20),
],
onChanged: (value) {
  final parsed = int.tryParse(value);
  if (parsed != null && parsed >= 0 && parsed <= 20) {

// AFTER:
helperText: '0-${ValidationRules.timesAwakenedMax}',
inputFormatters: [
  FilteringTextInputFormatter.digitsOnly,
  _RangeTextInputFormatter(min: 0, max: ValidationRules.timesAwakenedMax),
],
onChanged: (value) {
  final parsed = int.tryParse(value);
  if (parsed != null && parsed >= 0 && parsed <= ValidationRules.timesAwakenedMax) {
```

**Import needed:** Check for ValidationRules import.

**Test impact:** No value change. Verify tests still pass.

### 2.8 Sleep Import Sources (1 file)

**Spec reference:** 22_API_CONTRACTS.md Section 6 (updated with `validSleepImportSources`)

**`lib/domain/usecases/sleep_entries/log_sleep_entry_use_case.dart` (~lines 130-137):**
```dart
// BEFORE:
final validSources = [
  'healthkit',
  'googlefit',
  'apple_watch',
  'fitbit',
  'garmin',
  'manual',
];
if (!validSources.contains(input.importSource!.toLowerCase())) {
  errors['importSource'] = [
    'Invalid import source. Valid: ${validSources.join(", ")}',
  ];
}

// AFTER:
if (!ValidationRules.validSleepImportSources.contains(input.importSource!.toLowerCase())) {
  errors['importSource'] = [
    'Invalid import source. Valid: ${ValidationRules.validSleepImportSources.join(", ")}',
  ];
}
```

**Test impact:** Check `log_sleep_entry_use_case_test.dart` for import source test values. No value change.

### 2.9 Tag Preview Limit (1 file)

**Spec reference:** 22_API_CONTRACTS.md Section 6 (updated with `tagPreviewMaxCount = 3`)

**`lib/presentation/screens/journal_entries/journal_entry_list_screen.dart` line 149:**
```dart
// BEFORE:
.take(3)

// AFTER:
.take(ValidationRules.tagPreviewMaxCount)
```

**Import:** Already imported (from L2 fix).

**Test impact:** No value change.

---

## PHASE 3: Code Quality Fixes (~35 files)

These fixes address coding practice issues that don't require spec changes.

### 3.1 DAO Silent Exception Logging (11 occurrences in 9 DAO files)

**Coding Standard reference:** Section 7.1 — "Log with Context"

Each DAO has JSON parsing catch blocks that silently return empty. Add logging.

**Pattern in each DAO:**
```dart
// BEFORE:
} on Exception {
  return [];
}

// AFTER:
} on Exception catch (e) {
  // Log corrupt JSON for debugging — data silently lost otherwise
  debugPrint('WARNING: Failed to parse JSON in [DaoName].[methodName]: $e');
  return [];
}
```

**Note on LoggerService:** `LoggerService` is only available via Riverpod providers. DAOs don't have access to providers (they're in the data layer). Use `debugPrint` for now as a lightweight logging solution, or add a `Logger` parameter to DAO constructors. The simpler `debugPrint` approach is recommended to avoid constructor signature changes.

**Files:**
| File | Occurrences |
|------|-------------|
| `supplement_dao.dart` | 2 (ingredients, schedules) |
| `condition_dao.dart` | 2 (triggers, flarePhotoIds) |
| `condition_log_dao.dart` | 1 (triggers) |
| `activity_log_dao.dart` | 1 (adHocActivities/activityIds) |
| `food_log_dao.dart` | 1 (adHocItems/foodItemIds) |
| `food_item_dao.dart` | 1 (nutritionInfo) |
| `fluids_entry_dao.dart` | 1 (bowelData) |
| `flare_up_dao.dart` | 1 (bodyLocationDetails) |
| `journal_entry_dao.dart` | 1 (tags) |

### 3.2 Screen Error Display — Replace `error.toString()` (8 files)

**Coding Standard reference:** Section 7.2 — "User-Friendly Messages: userMessage is shown to users, message is for logs"

In each list screen's `_buildErrorState()`, `error.toString()` exposes internal details.

```dart
// BEFORE:
Text(
  error.toString(),
  ...
),

// AFTER:
Text(
  error is AppError ? error.userMessage : 'Something went wrong. Please try again.',
  ...
),
```

**Files:** All 8 list screens (supplement, condition, activity, food_item, journal_entry, sleep_entry, photo_area, photo_entry_gallery).

**Import needed:** Add `import 'package:shadow_app/core/errors/app_error.dart';` if not present.

### 3.3 PopupMenuButton Tooltips (7 files)

**Coding Standard reference:** Section 13.1 — "All interactive elements MUST have semantic labels"

```dart
// BEFORE:
PopupMenuButton<String>(
  onSelected: ...

// AFTER:
PopupMenuButton<String>(
  tooltip: 'More options',
  onSelected: ...
```

**Files:** supplement_list, condition_list, activity_list, food_item_list, journal_entry_list, sleep_entry_list, photo_area_list.

### 3.4 ValueKey on Dynamic List Items (8 list screens)

**Coding Standard reference:** Section 12.1 — ListView best practices

Add `key: ValueKey(entity.id)` to the outermost widget returned by `itemBuilder` in each `ListView.builder`.

**Specific locations (outermost widget per screen):**

| File | Widget to key | Entity ID field |
|------|--------------|-----------------|
| `supplement_list_screen.dart` | `Padding` wrapping `ShadowCard` | `supplement.id` |
| `condition_list_screen.dart` | `Padding` wrapping `ShadowCard` | `condition.id` |
| `activity_list_screen.dart` | `Padding` wrapping `ShadowCard` | `activity.id` |
| `food_item_list_screen.dart` | `Padding` wrapping `ShadowCard` | `foodItem.id` |
| `journal_entry_list_screen.dart` | `Padding` wrapping `ShadowCard` | `entry.id` |
| `sleep_entry_list_screen.dart` | `Padding` wrapping `ShadowCard` | `entry.id` |
| `photo_area_list_screen.dart` | `Padding` wrapping `ShadowCard` | `area.id` |
| `photo_entry_gallery_screen.dart` | widget in `GridView.builder` | `entry.id` |

**IMPORTANT:** Verify the outermost widget for each by reading the `itemBuilder` callback before adding the key. The key must go on the TOP-LEVEL widget returned by the builder, not an inner child.

### 3.5 Replace `int.parse` / `double.parse` with `tryParse` (3 files, 5 occurrences)

**Coding Standard reference:** Section 7.1 — defensive error handling

| File | Line | Change |
|------|------|--------|
| `fluids_entry_screen.dart` | 1155 | `double.parse(waterText)` → `double.tryParse(waterText) ?? 0.0` |
| `fluids_entry_screen.dart` | 1168 | `double.parse(bbtText)` → `double.tryParse(bbtText)` (already nullable context) |
| `activity_edit_screen.dart` | 349, 369 | `int.parse(...)` → `int.tryParse(...) ?? 0` |
| `supplement_edit_screen.dart` | 508 | `int.parse(...)` → `int.tryParse(...) ?? 0` |

**IMPORTANT:** Read the surrounding code to determine the correct fallback value. The `?? 0` is a starting point — the actual default should match the field's validation minimum. For example, activity duration might default to `ValidationRules.activityDurationMinMinutes` instead of `0`.

### 3.6 Date Formatter Extraction (8+ files)

**Create `lib/core/utils/date_formatters.dart`:**
```dart
// lib/core/utils/date_formatters.dart
// Centralized date/time formatting utilities.

import 'package:flutter/material.dart';

/// Centralized date and time formatting for consistent display across screens.
class DateFormatters {
  DateFormatters._(); // Prevent instantiation

  /// Short date: "1/15/2026"
  static String shortDate(DateTime date) =>
      '${date.month}/${date.day}/${date.year}';

  /// Long date with month name: "January 15, 2026"
  static String longDate(DateTime date) =>
      '${_months[date.month - 1]} ${date.day}, ${date.year}';

  /// 12-hour time: "2:30 PM"
  static String time12h(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// 12-hour time from DateTime: "2:30 PM"
  static String dateTime12h(DateTime dt) =>
      time12h(TimeOfDay.fromDateTime(dt));

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
}
```

**Then replace in each file:**
- `shadow_picker.dart`: Replace `_formatTime()`, `_formatDate()`, and `months` array
- `shadow_input.dart`: Replace `_formatTime()` if present
- `intake_log_screen.dart`: Replace `_formatTime()`
- `fluids_entry_screen.dart`: Replace `_formatTime()` and `months` array
- `sleep_entry_edit_screen.dart`: Replace `_formatTime()`, `_formatDate()`
- `sleep_entry_list_screen.dart`: Replace `_formatDate()`
- `photo_entry_gallery_screen.dart`: Replace inline `'${date.month}/${date.day}/${date.year}'` (2 occurrences)
- `journal_entry_list_screen.dart`: Replace inline date formatting

**IMPORTANT:** Before replacing, read each `_format*` method to verify it produces IDENTICAL output to the shared utility. If any method has a different format, do NOT replace it — only replace exact matches.

**Test impact:** Write a test file `test/core/utils/date_formatters_test.dart` for the new utility. Existing screen tests should pass unchanged since output is identical.

### 3.7 Menstruation Flow Color Deduplication (2 files)

**`shadow_picker.dart` and `shadow_input.dart` have identical flow color switch expressions.**

Extract to a shared location. The simplest approach: add a `static Color flowColor(int level, ColorScheme colorScheme)` method to `shadow_input.dart` (or a new `flow_colors.dart` file) and import in both places.

Read both files' exact switch expressions before implementing to confirm they're identical.

### 3.8 TODO and SPEC_REVIEW Comment Cleanup (7+ files)

**TODOs (9):** These represent unimplemented features. For each:
- If the dead code path exists (e.g., button that calls a TODO method), add a no-op with user feedback (`showAccessibleSnackBar(message: 'Coming soon')`)
- If the code path doesn't exist yet, the TODO is informational — leave as-is

**SPEC_REVIEW comments (5):** Convert to `// NOTE:` with a brief explanation, or remove if the issue has been resolved. Do NOT leave review-specific comments in production code.

---

## PHASE 4: Build Runner + Verification

### 4.1 Regenerate Code

```bash
dart run build_runner build --delete-conflicting-outputs
```

This is needed after:
- Changing `@Default(20)` to `@Default(ValidationRules.defaultSearchLimit)` in input classes
- Any changes to freezed/riverpod-annotated files

### 4.2 Format

```bash
dart format lib/ test/
```

### 4.3 Analyze

```bash
flutter analyze
```

Fix any issues before proceeding.

### 4.4 Test

```bash
flutter test
```

All 1919+ tests must pass.

### 4.5 Verification Grep Checks

```bash
# These should return ZERO results in lib/ (excluding comments and fix-plan files):
grep -r "60 \* 60 \* 1000" lib/          # Should be 0 (replaced with constant)
grep -r "86400000" lib/                    # Should be 0 (replaced with Duration.millisecondsPerDay)
grep -r "limit = 20," lib/                 # Should be 0 (replaced with constant)
grep -r "_maxC = 40.5" lib/               # Should be 0 (BBT bug fixed)
grep -r "min: 1," lib/ | grep Slider      # Should be 0 (replaced with constants)
```

---

## Items DEFERRED to Future Projects

| Item | Reason | Recommended Project |
|------|--------|-------------------|
| 2A-2C: Shared widgets (ShadowErrorState, ShadowEmptyState, ShadowSectionHeader) | 21+ file refactor, high blast radius, many test changes | Widget Library Expansion project |
| 2F: Shared save/error handler | 21 file refactor, high blast radius | Widget Library Expansion project |
| 2G: Dirty tracking mixin | 12 file refactor, behavioral risk | Widget Library Expansion project |
| 3D: `syncDeviceId: ''` pattern | By design per BaseRepository | Not needed |
| 4A: `removeListener` in `dispose()` | `controller.dispose()` already clears listeners | Not needed |
| 1J: Anchor event default times | User preference defaults, not validation rules | User Preferences project |
| 3B: Screen exception logging | Needs architectural decision on LoggerService access in screens | Logging Infrastructure project |

---

## Execution Order Summary

```
1. PHASE 1: BBT bug fix (1 file) → commit
2. PHASE 2: Hardcoded value replacements (~25 files) → commit
3. PHASE 3: Code quality fixes (~35 files) → commit
4. PHASE 4: build_runner + verify → final commit if formatting changed
```

Each phase should be committed separately for clean git history.

---

## Total File Count

| Phase | Files Modified | Files Created | Tests to Verify |
|-------|---------------|--------------|-----------------|
| Phase 1 | 1 | 0 | shadow_input_test.dart |
| Phase 2 | ~25 | 0 | All 8 use case test files + screen tests |
| Phase 3 | ~35 | 2 (date_formatters.dart + test) | All screen tests |
| Phase 4 | Generated files only | 0 | Full test suite |
