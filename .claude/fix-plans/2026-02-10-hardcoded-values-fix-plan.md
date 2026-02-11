# FINAL Comprehensive Fix Plan — CONVERGED

**Created:** 2026-02-10
**Status:** CONVERGED (3 review passes, zero new issues in final pass)
**Scope:** All hardcoded values + all coding practice issues across entire codebase
**Files reviewed:** 140+ source files across all layers (entities, use cases, repos, DAOs, providers, screens, widgets)
**Convergence:** Pass 1 found 10 sections. Pass 2 found 3 new items (2D, 2E, 1K). Pass 3 found 2 additional items (SPEC_REVIEW comments, LoggerService unused). Pass 4 (final) found 0 new items.

---

## Completed Fixes

### LOW Severity Hardcoded Values (Fixed 2026-02-10)

| # | File | Change | Status |
|---|------|--------|--------|
| L1 | 5 screen files | `DateTime(2000)` -> `DateTime(ValidationRules.earliestSelectableYear)` | DONE |
| L2 | journal_entry_list_screen.dart | `> 100` snippet -> `ValidationRules.journalSnippetMaxLength` | DONE |
| L3 | shadow_picker.dart (7 occurrences) | `maxTimes = 5` -> `ValidationRules.defaultPickerMaxTimes` | DONE |
| L4 | shadow_badge.dart (4 occurrences) | `maxCount = 99` -> `ValidationRules.badgeMaxDisplayCount` | DONE |
| L5 | photo_entry_gallery_screen.dart | `crossAxisCount: 3` -> `ValidationRules.photoGalleryColumns` | DONE |

---

## SECTION 1: Hardcoded Values (Remaining)

### 1A. HIGH: Bug — BBT Widget Mismatch (CRITICAL)

| File | Line | Value | Correct Value | Impact |
|------|------|-------|---------------|--------|
| `lib/presentation/widgets/shadow_input.dart` | 268 | `_maxC = 40.5` | `ValidationRules.bbtMaxCelsius = 40.6` | **Rejects valid temps 40.5-40.6C** |

**Fix:** Replace all 4 BBT constants (lines 265-268) with `ValidationRules` references:
```dart
static const _minF = ValidationRules.bbtMinFahrenheit;
static const _maxF = ValidationRules.bbtMaxFahrenheit;
static const _minC = ValidationRules.bbtMinCelsius;
static const _maxC = ValidationRules.bbtMaxCelsius;
```
**Files:** 1 | **Tests affected:** Verify shadow_input_test.dart still passes

### 1B. HIGH: Existing Constants Not Used in Screens

| File | Line | Hardcoded | Constant |
|------|------|-----------|----------|
| `journal_entry_edit_screen.dart` | 323-325 | `min: 1, max: 10, divisions: 9` | `ValidationRules.moodMin/moodMax` |
| `condition_log_screen.dart` | 351-353 | `min: 1, max: 10, divisions: 9` | `ValidationRules.severityMin/severityMax` |

**Fix:** Replace literal values with constant references. Compute `divisions` as `max - min`.
**Files:** 2

### 1C. MEDIUM: Future Timestamp Tolerance (8 files)

**Pattern:** `final oneHourFromNow = now + (60 * 60 * 1000);`
**New constant:** `ValidationRules.maxFutureTimestampToleranceMs = 60 * 60 * 1000`

| File | Line |
|------|------|
| `create_journal_entry_use_case.dart` | 94 |
| `log_flare_up_use_case.dart` | 94 |
| `log_activity_use_case.dart` | 77 |
| `log_food_use_case.dart` | 71 |
| `log_condition_use_case.dart` | 102 |
| `create_photo_entry_use_case.dart` | 88 |
| `log_sleep_entry_use_case.dart` | 75 |
| `update_sleep_entry_use_case.dart` | 78 |

### 1D. MEDIUM: Milliseconds Per Day (6 files)

**Pattern:** `86400000` or `24 * 60 * 60 * 1000`
**New constant:** `ValidationRules.millisecondsPerDay = 86400000`

| File | Line | Context |
|------|------|---------|
| `intake_log_dao.dart` | 270 | end of day |
| `activity_log_dao.dart` | 185 | end of day |
| `sleep_entry_dao.dart` | 178 | end of day |
| `food_log_dao.dart` | 183 | end of day |
| `log_sleep_entry_use_case.dart` | 87 | max sleep duration |
| `update_sleep_entry_use_case.dart` | 90 | max sleep duration |

### 1E. MEDIUM: Default Search Limit (7 source files + 1 generated)

**Pattern:** `int limit = 20`
**New constant:** `ValidationRules.defaultSearchLimit = 20`

| File | Line(s) |
|------|---------|
| `supplement_repository.dart` | 35 |
| `food_item_repository.dart` | 29, 40 |
| `supplement_repository_impl.dart` | 117 |
| `food_item_repository_impl.dart` | 94, 105 |
| `supplement_dao.dart` | 226 |
| `food_item_dao.dart` | 178 |
| `food_item_inputs.freezed.dart` | (auto-regenerated from input class) |

**Note:** Must also update the input class source so codegen picks up the new default.

### 1F. MEDIUM: Meal Time Boundaries (1 file)

**Pattern:** `hour >= 5 && hour <= 10` etc. in `food_log_screen.dart:75-77`
**New constants:**
```dart
ValidationRules.breakfastStartHour = 5
ValidationRules.breakfastEndHour = 10
ValidationRules.lunchStartHour = 11
ValidationRules.lunchEndHour = 14
ValidationRules.dinnerStartHour = 15
ValidationRules.dinnerEndHour = 20
```

### 1G. MEDIUM: Snooze Durations (2 files)

**Pattern:** `[5, 10, 15, 30, 60]` duplicated in:
- `intake_log_screen.dart:74`
- `mark_snoozed_use_case.dart:26`

**New constant:** `ValidationRules.validSnoozeDurationMinutes = [5, 10, 15, 30, 60]`

### 1H. MEDIUM: Times Awakened Max (1 file)

**Pattern:** `parsed >= 0 && parsed <= 20` in `sleep_entry_edit_screen.dart:295`
**New constant:** `ValidationRules.timesAwakenedMax = 20`

### 1I. MEDIUM: Hardcoded Import Sources (1 file)

**Pattern:** `['healthkit', 'googlefit', 'apple_watch', 'fitbit', 'garmin', 'manual']` in `log_sleep_entry_use_case.dart:130-137`
**New constant:** `ValidationRules.validSleepImportSources`

### 1J. MEDIUM: Anchor Event Default Times (1 file)

**Pattern:** `7 * 60`, `8 * 60`, `12 * 60`, `18 * 60`, `22 * 60` in `supplement_repository_impl.dart:207-216`
**New constants:** Add to ValidationRules or create a separate `DefaultScheduleTimes` class.

### 1K. LOW: Hardcoded Tag Preview Limit (1 file)

**Pattern:** `.take(3)` in `journal_entry_list_screen.dart:149`
**New constant:** `ValidationRules.tagPreviewMaxCount = 3`

---

## SECTION 2: Code Duplication (STRUCTURAL)

### 2A. HIGH: Duplicated Error State Widget (8 files)

**`_buildErrorState()` is copy-pasted identically in 8 list screens:**
- supplement_list_screen.dart:257
- condition_list_screen.dart:247
- activity_list_screen.dart:223
- food_item_list_screen.dart:243
- journal_entry_list_screen.dart:224
- sleep_entry_list_screen.dart:239
- photo_area_list_screen.dart:224
- photo_entry_gallery_screen.dart:156

**Fix:** Extract to `lib/presentation/widgets/shadow_error_state.dart`:
```dart
class ShadowErrorState extends StatelessWidget {
  final String message;
  final Object error;
  final VoidCallback onRetry;
}
```

### 2B. HIGH: Duplicated Empty State Widget (8 files)

**`_buildEmptyState()` is copy-pasted with minor differences in 8 list screens.**
Same files as above.

**Fix:** Extract to `lib/presentation/widgets/shadow_empty_state.dart`:
```dart
class ShadowEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
}
```

### 2C. HIGH: Duplicated Section Header (21 screens, 2 different signatures)

**Two variants of `_buildSectionHeader()` exist across 21 screen files:**
- Variant A (10 edit/log screens): `_buildSectionHeader(ThemeData theme, String title)` — returns `Semantics(header: true, ...)`
- Variant B (8 list screens): `_buildSectionHeader(BuildContext context, String title)` — returns `Padding(...Text(title))`

**Fix:** Extract to `lib/presentation/widgets/shadow_section_header.dart`:
```dart
class ShadowSectionHeader extends StatelessWidget {
  final String title;
  // Automatically uses Semantics(header: true) for accessibility
}
```

### 2D. MEDIUM: Duplicated Date/Time Formatting (8+ files)

**`_formatTime()`, `_formatDate()`, `_formatDateTime()` are copy-pasted across multiple files:**
- `_formatTime(TimeOfDay)` in: shadow_picker.dart, shadow_input.dart, intake_log_screen.dart, fluids_entry_screen.dart, sleep_entry_edit_screen.dart
- `_formatDate(DateTime)` in: shadow_picker.dart, sleep_entry_list_screen.dart, sleep_entry_edit_screen.dart
- Inline `'${date.month}/${date.day}/${date.year}'` in: photo_entry_gallery_screen.dart (2x), journal_entry_list_screen.dart
- `final months = [...]` array duplicated in: shadow_picker.dart, fluids_entry_screen.dart

**Fix:** Create `lib/core/utils/date_formatters.dart`:
```dart
class DateFormatters {
  static String shortDate(DateTime date) => '${date.month}/${date.day}/${date.year}';
  static String longDate(DateTime date) => '${_months[date.month - 1]} ${date.day}, ${date.year}';
  static String time12h(TimeOfDay time) { ... }
  static String dateTime12h(DateTime dt) { ... }
}
```

### 2E. MEDIUM: Duplicated Menstruation Flow Color Mapping (2 files)

**Exact same 5-line switch expression in both:**
- `shadow_picker.dart:467-471`
- `shadow_input.dart:623-627`

**Fix:** Extract to shared constant in `shadow_picker.dart` or a common location, import in both files.

### 2F. MEDIUM: Duplicated Save/Error Handling Pattern (21 screens)

**Every screen has the identical try/catch pattern:**
```dart
try { ... }
on AppError catch (e) { showAccessibleSnackBar(message: e.userMessage); }
on Exception { showAccessibleSnackBar(message: 'An unexpected error occurred'); }
```

**Fix:** Extract to a utility function:
```dart
Future<void> handleAsyncAction(
  BuildContext context,
  Future<void> Function() action, {
  String? successMessage,
}) async { ... }
```

### 2G. MEDIUM: Duplicated Dirty Tracking Pattern (12 edit screens)

**Every edit screen has identical `_isDirty`, `_isSaving`, `_markDirty()`, and `_confirmDiscardChanges()` patterns.**

**Fix:** Create a mixin `DirtyTrackingMixin` or base class that provides these.

---

## SECTION 3: Error Handling Issues

**NOTE:** `LoggerService` exists at `lib/core/services/logger_service.dart` and is imported in 18 provider files, but is NOT imported in any screens, DAOs, repositories, or use cases. All logging fixes below should use this existing service.

### 3A. HIGH: Silent Exception Swallowing in DAO JSON Parsing (11 occurrences)

**Pattern:** `on Exception { return []; }` — silently returns empty list when JSON parsing fails.

| File | Line | What it parses |
|------|------|---------------|
| `supplement_dao.dart` | 327 | ingredients JSON |
| `supplement_dao.dart` | 342 | schedules JSON |
| `condition_dao.dart` | 372 | triggers JSON |
| `condition_dao.dart` | 381 | flarePhotoIds JSON |
| `condition_log_dao.dart` | 391 | triggers JSON |
| `activity_log_dao.dart` | 320 | adHocActivities/activityIds JSON |
| `food_log_dao.dart` | 314 | adHocItems/foodItemIds JSON |
| `food_item_dao.dart` | 328 | nutritionInfo JSON |
| `fluids_entry_dao.dart` | 356 | bowelData JSON |
| `flare_up_dao.dart` | 387 | bodyLocationDetails JSON |
| `journal_entry_dao.dart` | 349 | tags JSON (returns null) |

**Problem:** Corrupt data silently becomes empty. User sees no data, no error, no way to recover.
**Fix:** Log a warning when parsing fails. Consider returning the raw JSON for inspection.

### 3B. MEDIUM: Generic `on Exception` in Screen Save Methods (21 files)

**Pattern:** `on Exception { showAccessibleSnackBar(message: 'An unexpected error occurred'); }`
**Problem:** No logging. Exception details lost forever.
**Fix:** Add `_log.error('Save failed', e)` before showing snackbar, or pass exception to a crash reporter.

### 3C. MEDIUM: Raw `error.toString()` Displayed to Users (8 files)

**Pattern:** In `_buildErrorState()`, shows `error.toString()` directly in the UI.
**Problem:** Exposes internal error details (stack traces, database errors) to users.
**Fix:** Show user-friendly message, log the actual error. If error is `AppError`, use `error.userMessage`.

### 3D. LOW: `syncDeviceId: ''` Placeholder (13 use cases)

**Pattern:** All create use cases pass `syncDeviceId: ''` in SyncMetadata with comment "Will be populated by repository".
**Issue:** Not a bug (BaseRepository does populate it), but the empty string is a code smell.
**Fix:** Consider `SyncMetadata.forCreate()` factory that doesn't require a device ID at all.

---

## SECTION 4: Memory & Resource Management

### 4A. MEDIUM: Listeners Never Removed (12 edit screens, 33 listeners)

**Pattern:** `_controller.addListener(_markDirty)` in `initState()` — but `removeListener` is never called.
**Problem:** While `dispose()` calls `_controller.dispose()` which removes all listeners, best practice is to explicitly remove them.

| File | Count |
|------|-------|
| supplement_edit_screen.dart | 6 |
| fluids_entry_screen.dart | 8 |
| condition_edit_screen.dart | 2 |
| activity_edit_screen.dart | 5 |
| activity_log_screen.dart | 2 |
| condition_log_screen.dart | 2 |
| food_log_screen.dart | 1 |
| journal_entry_edit_screen.dart | 2 |
| intake_log_screen.dart | 2 |
| photo_area_edit_screen.dart | 3 |

**Fix:** Add `_controller.removeListener(_markDirty)` in `dispose()` before `_controller.dispose()`.

---

## SECTION 5: Accessibility Violations

### 5A. MEDIUM: PopupMenuButton Missing Tooltip/Semantics (7 files)

**Every list screen has a `PopupMenuButton` with no tooltip or semantic label.**

| File | Line |
|------|------|
| `supplement_list_screen.dart` | 186 |
| `condition_list_screen.dart` | 186 |
| `activity_list_screen.dart` | 162 |
| `food_item_list_screen.dart` | 184 |
| `journal_entry_list_screen.dart` | 165 |
| `sleep_entry_list_screen.dart` | 180 |
| `photo_area_list_screen.dart` | 163 |

**Fix:** Add `tooltip: 'More options'` to each `PopupMenuButton`.

---

## SECTION 6: Performance Issues

### 6A. MEDIUM: Missing Keys on Dynamic List Items (8+ list screens)

**Zero `ValueKey` usage found across all screen files.** No list screen uses keys on dynamically generated items.

**Problem:** Flutter can't efficiently diff list items when data changes. Can cause:
- Incorrect animations
- Stale state in stateful list items
- Unnecessary rebuilds

**Fix:** Add `key: ValueKey(entity.id)` to the outermost widget in each list item builder.

**Files:** All list screens that use `ListView.builder` or `.map().toList()`.

---

## SECTION 7: Code Safety Issues

### 7A. MEDIUM: `int.parse` / `double.parse` Without `tryParse` (5 occurrences)

**These throw `FormatException` if input is invalid.** While validation should prevent this, it's fragile.

| File | Line | Call |
|------|------|------|
| `fluids_entry_screen.dart` | 1155 | `double.parse(waterText)` |
| `fluids_entry_screen.dart` | 1168 | `double.parse(bbtText)` |
| `activity_edit_screen.dart` | 349, 369 | `int.parse(_durationController.text.trim())` |
| `supplement_edit_screen.dart` | 508 | `int.parse(_dosageAmountController.text.trim())` |

**Fix:** Replace with `tryParse` and handle null case, or wrap in a guard that returns a default.

---

## SECTION 8: Unfinished Work (TODOs)

### 8A. LOW: 9 TODO Comments in Production Code

| File | Line | TODO |
|------|------|------|
| `food_item_list_screen.dart` | 284 | `// TODO: Implement search` |
| `food_item_repository_impl.dart` | 107 | `// TODO: Implement category filtering` |
| `supplement_list_screen.dart` | 304 | `// TODO: Implement filter dialog` |
| `supplement_list_screen.dart` | 312 | `// TODO: Navigate to add supplement screen` |
| `supplement_list_screen.dart` | 347 | `// TODO: Navigate to log intake screen` |
| `supplement_list_screen.dart` | 417 | `// TODO: Implement filter options` |
| `sleep_entry_list_screen.dart` | 418 | `// TODO: Implement date range filter` |
| `condition_edit_screen.dart` | 365 | `// TODO: Implement camera/photo picker` |
| `condition_edit_screen.dart` | 545 | `// TODO: Implement update when provider supports it` |

**Fix:** Either implement the feature, replace with no-op + tracking issue, or remove the dead code path.

### 8B. LOW: 5 SPEC_REVIEW Comments in Production Code

| File | Line | Comment |
|------|------|---------|
| `fluids_entry_screen.dart` | 51 | Water unit defaulting to fl oz |
| `fluids_entry_screen.dart` | 129 | Urgency not stored in entity |
| `fluids_entry_screen.dart` | 537 | Bristol stool scale label |
| `condition_log_screen.dart` | 498 | Photo infrastructure not built |
| `condition_log_screen.dart` | 566 | Provider only has log() method |

**Fix:** Resolve or convert to tracked issues. Don't leave inline review comments in production code.

---

## SECTION 9: Constants to Add to ValidationRules

```dart
// ===== Time constants =====
static const int maxFutureTimestampToleranceMs = 60 * 60 * 1000; // 1 hour
static const int millisecondsPerDay = 86400000;

// ===== Search defaults =====
static const int defaultSearchLimit = 20;

// ===== Meal time detection =====
static const int breakfastStartHour = 5;
static const int breakfastEndHour = 10;
static const int lunchStartHour = 11;
static const int lunchEndHour = 14;
static const int dinnerStartHour = 15;
static const int dinnerEndHour = 20;

// ===== Sleep constraints =====
static const int timesAwakenedMax = 20;

// ===== Snooze/Intake =====
static const List<int> validSnoozeDurationMinutes = [5, 10, 15, 30, 60];

// ===== Import sources =====
static const List<String> validSleepImportSources = [
  'healthkit', 'googlefit', 'apple_watch', 'fitbit', 'garmin', 'manual',
];
```

## SECTION 10: Shared Widgets to Create

| Widget | Purpose | Replaces |
|--------|---------|----------|
| `ShadowErrorState` | Error display with retry button | `_buildErrorState()` in 8 files |
| `ShadowEmptyState` | Empty list placeholder with icon + message | `_buildEmptyState()` in 8 files |
| `ShadowSectionHeader` | Accessible section header | `_buildSectionHeader()` in 21 files |

---

## Implementation Order (Recommended)

### Phase A: Critical Bug Fix (1 file)
1. Fix BBT `_maxC = 40.5` -> `ValidationRules.bbtMaxCelsius` (1A)

### Phase B: Add Constants + Replace Hardcoded Values (~30 files)
2. Add all new constants to `ValidationRules` (Section 9)
3. Replace slider values in 2 screens (1B)
4. Replace timestamp tolerance in 8 use cases (1C)
5. Replace ms-per-day in 6 files (1D)
6. Replace search limit in 7 files + regenerate (1E)
7. Replace meal times, snooze, sleep max, import sources (1F-1J)

### Phase C: Extract Shared Widgets (21+ files)
8. Create `ShadowErrorState`, `ShadowEmptyState`, `ShadowSectionHeader` (Section 10)
9. Replace in all 21 screen files (2A-2C)

### Phase D: Error Handling Fixes (~30 files)
10. Add logging to DAO JSON parse failures (3A — 11 DAOs)
11. Add logging to screen `on Exception` blocks (3B — 21 screens)
12. Fix `error.toString()` user display (3C — 8 screens)

### Phase E: Quality Improvements (~20 files)
13. Add `removeListener` calls in `dispose()` (4A — 12 screens)
14. Add `tooltip` to PopupMenuButtons (5A — 7 screens)
15. Add `ValueKey` to list items (6A — 8 screens)
16. Replace `int.parse` with `tryParse` (7A — 3 screens)

### Phase F: Cleanup
17. Address or remove TODO comments (8A — 7 files)
18. Run `build_runner` for regenerated code
19. Run `flutter analyze`, `dart format`, `flutter test`

---

## Total Impact

| Metric | Count |
|--------|-------|
| New constants in ValidationRules | ~15 |
| New shared widgets | 3 |
| Files to modify | ~50 unique files |
| Hardcoded value replacements | ~45 |
| Error handling improvements | ~40 |
| Accessibility fixes | 7 |
| Performance fixes | 8 |
| TODOs to resolve | 9 |

---

## Verification Checklist (After ALL Fixes)

- [ ] `flutter test` — all 1919+ tests passing
- [ ] `flutter analyze` — clean (no errors, no warnings)
- [ ] `dart format --set-exit-if-changed lib/ test/` — exit 0
- [ ] Zero `DateTime(2000)` in screens
- [ ] Zero `60 * 60 * 1000` in use cases
- [ ] Zero `86400000` in DAOs
- [ ] Zero `limit = 20` hardcoded defaults
- [ ] Zero `_buildErrorState` private methods (replaced by ShadowErrorState)
- [ ] Zero `_buildEmptyState` private methods (replaced by ShadowEmptyState)
- [ ] Zero `on Exception {` blocks without logging
- [ ] Zero `error.toString()` displayed to users
- [ ] Zero `PopupMenuButton` without tooltip
- [ ] All list items have `ValueKey`
- [ ] All `int.parse` replaced with `tryParse`
- [ ] All `addListener` have matching `removeListener`
- [ ] All slider min/max use ValidationRules constants
- [ ] BBT widget uses exact ValidationRules values (40.6, not 40.5)
