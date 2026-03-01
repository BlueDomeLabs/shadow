# ARCHITECT_BRIEFING.md
# Shadow Health Tracking App — Architect Reference
# Last Updated: 2026-02-28
# Briefing Version: 20260228-002
#
# PRIMARY: GitHub repository — BlueDomeLabs/shadow
# ARCHITECT_BRIEFING.md is the single source of truth.
# Claude.ai reads this file via GitHub Project integration.
# Claude Code updates and pushes this file at end of every session.
#
# ── CLAUDE HANDOFF ──────────────────────────────────────────────────────────
# Status:        Phase 30 COMPLETE
# Last Action:   Conflict Resolution UI — view and resolve sync conflicts
# Next Action:   Await Architect review
# Open Items:    Encryption deferred (AES-256-GCM needs key management — see DECISIONS.md)
# Tests:         3,396 passing (+10 new)
# Schema:        v18 (unchanged)
# Analyzer:      Clean
# Archive:    Session entries older than current phase → ARCHITECT_BRIEFING_ARCHIVE.md
# ────────────────────────────────────────────────────────────────────────────

This document gives Claude.ai high-level visibility into the Shadow codebase.
Sections are in reverse chronological order — most recent at top, oldest at bottom.

---

## [2026-02-28 MST] — Phase 30: Conflict Resolution UI — COMPLETE

**10 new tests added. Tests: 3,396. Schema: v18. Analyzer: clean.**

### Summary

Added a Conflict Resolution screen reachable from the Cloud Sync settings screen.
When sync detects that the same data was edited on two devices, conflicts are listed
as cards showing "This Device" vs "Other Device" side by side, with three resolution
buttons per card: Keep This Device, Keep Other Device, and Merge. Resolving a conflict
removes its card immediately; errors show a snackbar. When no conflicts remain, a green
checkmark empty-state is shown. The conflict count row in the settings screen is now
tappable (was static text) and navigates to the new screen.

Also added `getUnresolvedConflicts(profileId)` to `SyncService` / `SyncServiceImpl`
(delegates to `SyncConflictDao.getUnresolved`).

**Recon note:** The prompt referenced `syncNotifierProvider` — no such provider exists.
Resolution calls go directly through `ref.read(syncServiceProvider).resolveConflict(...)`.
This is intentional and consistent with how the settings screen accesses sync.

### Key files

- **`lib/presentation/screens/cloud_sync/conflict_resolution_screen.dart`** (CREATED)
  - `ConflictResolutionScreen` — loads conflicts in `initState`, shows banner + ListView
  - `_ConflictCard` — entity label, truncated ID, detected time, version panels, 3 buttons
  - `_VersionPanel` — extracts name/notes/content/timestamps from entity JSON for display
  - Entity type label mapping for all 15 entity types

- **`lib/presentation/screens/cloud_sync/cloud_sync_settings_screen.dart`** (MODIFIED)
  - Conflict count container wrapped in `InkWell` → navigates to ConflictResolutionScreen
  - Added `Icons.chevron_right` to conflict row to signal tappability

- **`lib/domain/services/sync_service.dart`** (MODIFIED)
  - Added `getUnresolvedConflicts(String profileId)` to interface

- **`lib/data/services/sync_service_impl.dart`** (MODIFIED)
  - Implemented `getUnresolvedConflicts` → delegates to `_conflictDao.getUnresolved`

- **`test/presentation/screens/cloud_sync/conflict_resolution_screen_test.dart`** (CREATED)
  - 10 widget tests: empty state, banner, card content, three resolution buttons,
    card removal on success, error snackbar, settings navigation

- **`test/presentation/screens/cloud_sync/cloud_sync_settings_screen_test.dart`** (MODIFIED)
  - Added `getUnresolvedConflicts` stub to `_FakeSyncService`

---

## [2026-02-28 MST] — Phase 29: Correlation View Screen — COMPLETE

**8 new tests added. Tests: 3,386. Schema: v18. Analyzer: clean.**

### Summary

Added the Correlation View screen — the fifth card in the Reports tab. The screen shows
all photos chronologically (newest first) with a ±48-hour event window around each photo,
pulling data from all 8 health event repositories in parallel. Users can filter by date
preset (30 days / 90 days / all time), event categories (7 types), and photo areas.
Events are color-coded by temporal position (blue-grey = before, amber = after, primary = same time)
and display relative timestamps ("3h before", "at same time", "6h after").

### Key files

- **`lib/presentation/screens/reports/correlation_view_screen.dart`** (CREATED)
  - `CorrelationCategory` enum (7 values) with `label` and `icon` getters
  - `CorrelationData` value class (8 required lists)
  - `correlationDataProvider` FutureProvider.family — loads all 8 repos in parallel;
    photo failures propagate, event category failures degrade gracefully to []
  - `CorrelationViewScreen` ConsumerStatefulWidget
  - `_FilterSheet` StatefulWidget — date preset chips, photo area chips, category chips
  - `_CorrelationPhotoCard` StatelessWidget — ShadowImage.file + metadata + event ListTiles

- **`lib/presentation/screens/home/tabs/reports_tab.dart`** (MODIFIED)
  - Added fifth `_ReportTypeCard` ("Correlation View") after Diet Adherence card
  - Navigates to `CorrelationViewScreen` on "View Correlations" tap

- **`test/presentation/screens/reports/correlation_view_screen_test.dart`** (CREATED)
  - 8 widget tests covering: empty state, photo card render, relative time labels,
    filter sheet open, default chip selection, category deselect, ReportsTab card
    presence, and navigation to CorrelationViewScreen

### Production bug fixed

The `_key` for `FutureProvider.family` was originally computed in `build()` using
`DateTime.now()`, which produces a slightly different key on every frame. This caused
an infinite reload loop (new key → new provider → loading spinner → animation → rebuild
→ new key → ...). Fixed by computing `_key` once in `initState()` and only recomputing
it in `setState()` when the user changes the date preset.

---

## [2026-02-28 MST] — Phase 28: PhotoProcessingService + CLAUDE.md Nicknames — COMPLETE

**5 new tests added. Tests: 3,378. Schema: v18. Analyzer: clean.**

### Summary

All photos captured in the app are now processed before storage: compressed to
≤ 500 KB (standard) or ≤ 1024 KB (high-detail), EXIF metadata stripped automatically,
and SHA-256 hash computed. The `PhotoProcessingService` is a plain Dart class
instantiated directly in screens — no Riverpod provider. Encryption is deferred
(see DECISIONS.md).

Additionally, `CLAUDE.md` team member names updated:
- "Claude (claude.ai, Architect)" → "The Architect (claude.ai)"
- "You (Claude Code)" → "You (Shadow)"

### Task A — CLAUDE.md nickname changes

Updated "The team:" section in `CLAUDE.md`:
- Line: `Claude (claude.ai, Architect) — your engineering manager.` → `The Architect (claude.ai) — your engineering manager.`
- Line: `You (Claude Code) — senior engineer.` → `You (Shadow) — senior engineer.`

### Task B — PhotoProcessingService

**New service: `lib/core/services/photo_processing_service.dart`**
- `PhotoProcessingService` with `processStandard()` (≤ 500 KB) and `processHighDetail()` (≤ 1024 KB)
- Processing: validate file exists + size ≤ 10 MB; compress via `flutter_image_compress`
  with quality 85 → 75 → 65 → 60 (minimum); write `<docs>/photos/<uuid>.jpg`; SHA-256 hash
- `keepExif: false` strips EXIF automatically (default in flutter_image_compress)
- `format: CompressFormat.jpeg` is default — output is always JPEG
- `ProcessedPhotoResult { localPath, fileSizeBytes, fileHash }`
- `PhotoProcessingException(message)` thrown for validation failures
- `@visibleForTesting static String? testOutputDirectory` — avoids path_provider in tests
- `@visibleForTesting static Future<Uint8List?> Function(...)? compressOverride` — avoids platform plugin in tests

**New dependency: `flutter_image_compress: ^2.3.0` (resolved: 2.4.0)**
- Rationale: native platform codecs for HEIC support and 10–20× faster than pure-Dart `image`
- See DECISIONS.md for full rationale

**Step 4 — photo_entry_gallery_screen.dart `_pickPhoto()`:**
- After `pickImage`, calls `service.processStandard(image.path)` before showing dialog
- `PhotoProcessingException` → SnackBar + early return
- `CreatePhotoEntryInput` wired: `filePath: processed.localPath`, `fileSizeBytes: processed.fileSizeBytes`, `fileHash: processed.fileHash`

**Step 5 — Three additional screens:**
- `condition_edit_screen.dart` `_pickBaselinePhoto()`: `processHighDetail(path)` → `_baselinePhotoPath = processed.localPath`
- `condition_log_screen.dart` `_pickPhoto()`: `processStandard(path)` → `_photoPath = processed.localPath`
- `fluids_entry_screen.dart` `_pickBowelPhoto()`: `processStandard(path)` → `_bowelPhotoPath = processed.localPath`
- All three: specific `PhotoProcessingException` catch before generic `Exception` catch

**Step 6 — Tests:**
- 5 new unit tests in `test/core/services/photo_processing_service_test.dart`
- processStandard output ≤ 500 KB | processHighDetail output ≤ 1024 KB
- fileHash is 64-char lowercase hex | localPath ends in .jpg
- File > 10 MB throws PhotoProcessingException

**Step 7 — DECISIONS.md:**
- Entry 1: `flutter_image_compress` over `image` package (HEIC support, native speed)
- Entry 2: Encryption deferred — requires key management system not yet built

### Key implementation notes
- Encryption: step 7 of 18_PHOTO_PROCESSING.md pipeline deferred. Files stored as `.jpg`.
- `minWidth: 1, minHeight: 1` in `FlutterImageCompress.compressWithFile` prevents upscaling
- `format: CompressFormat.jpeg` and `keepExif: false` are defaults — removed from call per `avoid_redundant_argument_values`
- `macos/Flutter/GeneratedPluginRegistrant.swift` auto-updated by pub get (new plugin registration)
- `pubspec.lock` updated (flutter_image_compress + 5 transitive packages)

---

## [2026-02-27 MST] — Phase 27: Diet Adherence Trend Chart — COMPLETE

**6 new tests added. Tests: 3,373. Schema: v18. Analyzer: clean.**

### Summary
The Diet Dashboard screen now shows a "30-Day Compliance Trend" line chart when
`dailyTrend` data is present. The chart renders using `ShadowChart.trend` with
y-axis 0–100%, green line color. It appears after the Streak section and before
the Violations section. When `dailyTrend` is empty, the section is hidden entirely.
The Diet Adherence card is now the fourth card in the Reports tab ("View Dashboard"
button navigates to `DietDashboardScreen`).

### What was built

**Step 2 — Trend chart in DietDashboardScreen:**
- Added `if (stats.dailyTrend.isNotEmpty)` block after Streak section in `_DashboardContent`
- Renders `_SectionHeader(title: '30-Day Compliance Trend')` + `ShadowChart.trend`
- Maps `DailyCompliance.dateEpoch` → `x`, `DailyCompliance.score` → `y` (field is `score`, not `complianceScore`)
- `yAxisLabel: '%'`, `minY: 0`, `maxY: 100`, `lineColor: Colors.green`
- No import changes needed: `ShadowChart`/`ChartDataPoint` already available via `widgets.dart`

**Step 3 — Diet Adherence card in ReportsTab:**
- Added import for `DietDashboardScreen`
- Added fourth `_ReportTypeCard` with `icon: Icons.restaurant_menu`, `buttonLabel: 'View Dashboard'`
- Navigates to `DietDashboardScreen(profileId: profileId)` via `MaterialPageRoute`

**Step 4 — Tests:**
- 3 new widget tests in `test/presentation/screens/diet/diet_dashboard_screen_test.dart`:
  - Trend section visible when dailyTrend non-empty
  - Trend section hidden when dailyTrend empty
  - No-active-diet empty state renders correctly
- 3 new widget tests in `test/presentation/screens/reports/bbt_chart_screen_test.dart`:
  - Diet Adherence card renders
  - "View Dashboard" button present
  - Tapping navigates to DietDashboardScreen

### Key implementation notes
- `DailyCompliance.score` (not `complianceScore`) is the correct field name
- `height: 200` was omitted — it matches ShadowChart.trend default, flagged by `avoid_redundant_argument_values`
- Navigation test uses `pump()` (not `pumpAndSettle()`) to avoid blocking on provider loading, same pattern as BBT Chart test

---

## [2026-02-27 MST] — Phase 26: BBT Chart Screen — COMPLETE

**28 new tests added. Tests: 3,367. Schema: v18. Analyzer: clean.**

### Summary
A dedicated BBT Chart screen is now accessible from the Reports tab. It displays basal body
temperature as a trend chart with a pink menstruation overlay for cycle tracking. The chart
automatically adjusts to the user's temperature preference (°F or °C). A stats row below the
chart shows average, minimum, maximum, and reading count. Date range is user-controlled via
preset chips (Last 30 days / Last 90 days / All time) and prev/next month navigation buttons
in the AppBar.

### What was built

**Step 2 — ShadowChart.bbt() unit fix:**
- Added `bool useCelsius = false` parameter to `ShadowChart.bbt()` named constructor
- Now computes `yAxisLabel`, `minY`, `maxY` from the flag:
  - °F: `yAxisLabel='°F'`, `minY=96.0`, `maxY=100.0`
  - °C: `yAxisLabel='°C'`, `minY=35.5`, `maxY=37.8`

**Step 3 — BBTChartScreen (`lib/presentation/screens/reports/bbt_chart_screen.dart`):**
- `ConsumerStatefulWidget` with `profileId` param
- Two package-level pure functions extracted for testability:
  - `bbtToDisplay(double fahrenheit, {required bool useCelsius})` — unit conversion
  - `groupMenstruationRanges(List<FluidsEntry> entries)` — groups consecutive days into DateTimeRange objects
- Watches `userSettingsNotifierProvider` for temperature unit
- Watches `fluidsEntryListProvider(profileId, startMs, endMs)` for data
- Filters BBT entries (`hasBBTData`), maps to `ChartDataPoint` with unit conversion applied
- Groups menstruation ranges from all entries (not just BBT entries)
- States: loading (CPI), error (error + Retry), empty ("No BBT data..."), data (chart + stats)
- Stats row: Avg, Min, Max, Readings — all formatted with unit symbol
- AppBar: prev/next month buttons + data table toggle (when data present)
- Body: preset chips row (Last 30 days / Last 90 days / All time) + chart/state area
- Date range defaults to last 30 days, normalized to day boundaries

**Step 4 — Reports tab wired:**
- Added BBT Chart card as third card in `ReportsTab`
- `_ReportTypeCard` now accepts optional `buttonLabel` (defaults to `'Configure'`)
- BBT Chart card uses `buttonLabel: 'View Chart'` and navigates to `BBTChartScreen`
- Semantics label updated to use `buttonLabel` dynamically

**Step 5 — Tests:**
- 15 unit tests (`test/unit/presentation/screens/reports/bbt_chart_screen_test.dart`):
  - 6 tests for `bbtToDisplay()` — °F identity, °C conversions (98.6→37.0, 96→35.56, 100→37.78)
  - 9 tests for `groupMenstruationRanges()` — empty, single day, consecutive, non-consecutive, mixed flows
- 13 widget tests (`test/presentation/screens/reports/bbt_chart_screen_test.dart`):
  - Loading state (CPI visible)
  - Empty state (no BBT data, no entries)
  - Data state (Avg/Min/Max/Readings labels, reading count, °C unit display)
  - AppBar structure (title, prev/next buttons, chips)
  - Reports tab: BBT card present, "View Chart" button, existing "Configure" buttons unchanged
  - Navigation: tapping "View Chart" pushes BBTChartScreen

### Key implementation notes
- BBT stored in °F always; `bbtToDisplay()` converts at render time only
- `groupMenstruationRanges` uses ALL entries (not just BBT entries) to catch menstruation-only entries
- Date range overrides in widget tests use computed default range (last 30 days normalized)
- `_LoadingFluidsEntryList` uses `Completer` (not `Future.delayed`) to avoid pending timer failures
- `_FakeFluidsEntryList` extends `FluidsEntryList` and overrides only `build()` — clean Riverpod override pattern
- Nav test drags ListView -400px to bring BBT Chart card into view before tapping

---

## [2026-02-27 MST] — Phase 25: Report Export (PDF + CSV) — COMPLETE

**22 new tests added. Tests: 3,339. Schema: v18. Analyzer: clean.**

### Summary
Full PDF and CSV export is now wired into the Reports tab. Users can open either Activity Report
or Reference Report, configure categories and date range, then export directly as PDF or CSV
— a native share sheet opens so they can save to Files, email, AirDrop, etc. A spinner indicates
export is in progress. The export buttons are always enabled (no Preview required). A snackbar
shows if the export fails. The "Export will be available…" placeholder footer was removed.

### What was built

- **`pubspec.yaml`** — added `pdf: ^3.10.0` (installed 3.11.3) and `share_plus: ^7.0.0` (7.2.2)
- **`lib/domain/reports/report_data_service.dart`** — `ReportRow` data class + abstract
  `ReportDataService` interface (`fetchActivityRows`, `fetchReferenceRows`)
- **`lib/domain/reports/report_export_service.dart`** — abstract `ReportExportService` interface
  (4 methods: `exportActivityPdf`, `exportActivityCsv`, `exportReferencePdf`, `exportReferenceCsv`)
- **`lib/data/services/report_data_service_impl.dart`** — 12-repo implementation; builds lookup
  maps for supplement/condition/area names; partial-failure resilient; rows sorted ascending
- **`lib/data/services/report_export_service_impl.dart`** — PDF via `pw.Document`/`pw.MultiPage`
  with table; CSV via `StringBuffer`; writes to temp dir; injectable `getDirectory` for tests
- **`lib/presentation/providers/di/di_providers.dart`** — added `reportDataServiceProvider` and
  `reportExportServiceProvider` (both `keepAlive: true`)
- **`lib/core/bootstrap.dart`** — wired `ReportDataServiceImpl` and `ReportExportServiceImpl`
- **`lib/presentation/screens/home/tabs/reports_tab.dart`** — Export PDF / Export CSV buttons
  wired to data + export services; `Share.shareXFiles` opens native sheet; `_isExporting` flag
  drives `CircularProgressIndicator`; `setState(_isExporting=false)` happens BEFORE share call
  so widget tests can settle via `pumpAndSettle`

### Key technical notes
- `Share.shareXFiles` in test environment may never resolve (no native platform). Fix: set
  `_isExporting = false` BEFORE the share call. The loading indicator disappears, `pumpAndSettle`
  settles, and the pending share Future is abandoned cleanly.
- `_FakeReportExportService` in widget tests avoids real file I/O (just returns `File(path)`)
  so the async chain completes in microtasks and `pumpAndSettle` can settle.
- `_SlowReportDataService` uses `Completer<List<ReportRow>>` to pause the export mid-flight for
  the loading indicator test.
- `ReportExportServiceImpl` constructor accepts optional `Future<Directory> Function()? getDirectory`
  (defaults to `getTemporaryDirectory`) for unit test injection.

---

## [2026-02-27 MST] — Phase 24: Reports Foundation — COMPLETE

**21 new tests added. Tests: 3,317. Schema: v18. Analyzer: clean.**

### Summary
Built the foundation for the Reports tab: domain types, a query service with 11 repository
dependencies, DI wiring, and a real `ReportsTab` screen replacing the old placeholder.
Users can now open either "Activity Report" or "Reference Report", select categories via
checkboxes, optionally set a date range (Activity only), tap Preview to see live record
counts from their actual data, and see a disabled Export button placeholder for future export.

### What was built

- **`lib/domain/reports/report_types.dart`** — `ActivityCategory`, `ReferenceCategory`,
  `ReportType`, and `ReportConfig` value types
- **`lib/domain/reports/report_query_service.dart`** — abstract `ReportQueryService` interface
  with `countActivity(...)` and `countReference(...)` methods
- **`lib/data/services/report_query_service_impl.dart`** — concrete implementation; reads record
  counts from 11 repositories, returns 0 on any individual failure (partial-failure resilient)
- **`lib/presentation/providers/di/di_providers.dart`** — wired `ReportQueryServiceImpl` as a
  singleton provider
- **`lib/core/bootstrap.dart`** — added `ReportQueryService` to app bootstrap
- **`lib/presentation/screens/home/tabs/reports_tab.dart`** — full `ConsumerWidget`; two cards,
  each opening a `DraggableScrollableSheet` with category checkboxes, date pickers (Activity),
  pinned Preview + disabled Export buttons
- **`DECISIONS.md`** — iCloud sync approach logged

### Key technical notes
- Action buttons and count results are pinned OUTSIDE the scrollable area in
  `DraggableScrollableSheet`. If placed inside `ListView`, test viewport constraints
  prevent them from being built.
- `SingleChildScrollView + Column` used instead of `ListView` for checkboxes —
  Column builds all children eagerly, required for Flutter widget tests.
- `FilledButton.icon` creates an internal Row child — `btn.child is Text` always fails.
  All buttons use `Key(...)` finders in tests.

### File changes

| File | Status | Description |
|------|--------|-------------|
| DECISIONS.md | MODIFIED | Added iCloud sync approach decision |
| lib/domain/reports/report_types.dart | CREATED | ActivityCategory, ReferenceCategory, ReportType, ReportConfig types |
| lib/domain/reports/report_query_service.dart | CREATED | Abstract ReportQueryService interface |
| lib/data/services/report_query_service_impl.dart | CREATED | Concrete implementation reading counts from 11 repositories |
| lib/presentation/providers/di/di_providers.dart | MODIFIED | Wired ReportQueryServiceImpl as singleton provider |
| lib/presentation/providers/di/di_providers.g.dart | MODIFIED | Codegen output for new provider |
| lib/core/bootstrap.dart | MODIFIED | Added ReportQueryService to app bootstrap |
| lib/presentation/screens/home/home_screen.dart | MODIFIED | Updated imports for real ReportsTab |
| lib/presentation/screens/home/tabs/reports_tab.dart | MODIFIED | Full ConsumerWidget replacing placeholder |
| test/unit/data/services/report_query_service_impl_test.dart | CREATED | 12 unit tests for ReportQueryServiceImpl |
| test/unit/data/services/report_query_service_impl_test.mocks.dart | CREATED | Generated mocks |
| test/presentation/screens/home/tabs/reports_tab_test.dart | MODIFIED | 14 widget tests for ReportsTab (replaced placeholder tests) |
| ARCHITECT_BRIEFING.md | MODIFIED | Added Phase 24 session entry |

---

## [2026-02-27 MST] — Phase 23: Spec Cleanup Sprint — COMPLETE

**No code changes. Documentation only. Tests: 3,296. Schema: v18. Analyzer: clean.**

### Summary
Housekeeping pass to bring all documentation into alignment with the current codebase state.
Updated stale status markers, corrected "5 anchor events" → "8 anchor events" references,
and removed stub comments for work completed in Phases 20–22.

### Stale items found and fixed

| Location | Old text | New text |
|----------|----------|----------|
| `38_UI_FIELD_SPECIFICATIONS.md` Section 7.1 | Status: DECIDED — PENDING IMPLEMENTATION (2026-02-25) | Status: COMPLETE — Phase 21 (2026-02-27) |
| `DECISIONS.md` 2026-02-25 entry | "logged as DECIDED/PENDING IMPLEMENTATION" | Added **Resolution (2026-02-27):** Built in Phase 21, schema v18 |
| `lib/domain/entities/anchor_event_time.dart` | "The 5 anchor events (Wake, Breakfast, Lunch, Dinner, Bedtime)" | "The 8 anchor events (Wake, Breakfast, Morning, Lunch, Afternoon, Dinner, Evening, Bedtime)" |
| `lib/domain/repositories/anchor_event_time_repository.dart` | "5 anchor events" / "Get all 5" | "8 anchor events" / "Get all 8" |
| `lib/presentation/providers/notifications/anchor_event_times_provider.dart` | "5 anchor event times" + old event list | "8 anchor event times" + full 8-event list |
| `lib/presentation/screens/food_logs/food_log_screen.dart` | "// State - Food Items (stub for future food library integration)" | "// State - Food Items" |
| `lib/presentation/screens/condition_logs/condition_log_screen.dart` | "Photos: Multi-image picker stub (max 5, 5MB each)" | "Photos: Single photo picker (wired via PhotoPickerUtils)" |

### Genuine remaining TODOs (future work, not bugs)

| Location | Comment | Refers to |
|----------|---------|-----------|
| `lib/data/services/sync_service_impl.dart:200` | "Pull and conflict resolution operations return stubs (Phase 3/4)" | Cloud sync pull/conflict — unbuilt |
| `lib/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart:6` | "use cases are not yet implemented. Will be refactored to..." | Cloud sync auth domain layer — unbuilt |

### File changes

| File | Status | Description |
|------|--------|-------------|
| lib/domain/entities/anchor_event_time.dart | MODIFIED | Updated "5 anchor events" → "8 anchor events" with full event list |
| lib/domain/repositories/anchor_event_time_repository.dart | MODIFIED | Updated "5 anchor events" → "8 anchor events" in doc comment and getAll() |
| lib/presentation/providers/notifications/anchor_event_times_provider.dart | MODIFIED | Updated "5 anchor event times" → "8" with full event name list |
| lib/presentation/screens/food_logs/food_log_screen.dart | MODIFIED | Removed stale "stub for future food library integration" comment |
| lib/presentation/screens/condition_logs/condition_log_screen.dart | MODIFIED | Updated photo stub comment to reflect Phase 20 implementation |
| 38_UI_FIELD_SPECIFICATIONS.md | MODIFIED | Section 7.1 status: DECIDED/PENDING → COMPLETE Phase 21 |
| DECISIONS.md | MODIFIED | Added Resolution note to 2026-02-25 sleep fields decision entry |
| ARCHITECT_BRIEFING.md | MODIFIED | Added Phase 23 session entry |

---

## [2026-02-27 MST] — Phase 22: Food Library Picker — COMPLETE

**18 new tests added. Tests: 3,296. Schema: v18. Analyzer: clean.**

### Summary
Wired food items to the food log screen via a new `FoodLibraryPickerScreen`.
The "Food Items" section of the food log screen previously showed a non-functional stub
("Search foods..."). It now opens a full multi-select picker when tapped, shows chips for
selected items with X-to-remove, and resolves food item names from `foodItemListProvider`
for display.

### What was built
- **FoodLibraryPickerScreen**: new `ConsumerStatefulWidget` in `food_items/`. Multi-select
  mode with checkboxes, local search filter (case-insensitive, active items only), "Done"
  button pops with `List<String>` of selected IDs. FAB pushes `FoodItemEditScreen` and
  invalidates the provider on return. Empty states for both "no library" and "no search results".
- **food_log_screen.dart**: Replaced `_buildFoodItemsStub()` with `_buildFoodItemsSection()`.
  Now watches `foodItemListProvider` in `build()` to resolve IDs to names. Selected items
  shown as chips with delete button. Tapping the "Search foods..." `InkWell` opens the picker
  via `Navigator.push<List<String>>`. `_openFoodPicker()` and `_removeFoodItem(String)` added.

### Key decisions
- Local filtering over `searchFoodItemsUseCaseProvider` for simplicity and to allow inline
  checkbox display on all items during search.
- Chips use chip delete buttons (InkWell scope) rather than outer GestureDetector to avoid
  gesture conflicts — tapping delete does not also open the picker.
- Returns `List<String>` (IDs) not `List<FoodItem>` — food_log_screen resolves names locally
  from its watched `foodItemListProvider` data.
- Archived items hidden from picker (only active items shown).

### File changes
| File | Status | Description |
|------|--------|-------------|
| lib/presentation/screens/food_items/food_library_picker_screen.dart | CREATED | Multi-select food picker returning List<String> of IDs |
| lib/presentation/screens/food_logs/food_log_screen.dart | MODIFIED | Replaced stub with real food items section; added picker navigation |
| test/presentation/screens/food_items/food_library_picker_screen_test.dart | CREATED | 15 widget tests for picker screen |
| test/presentation/screens/food_logs/food_log_screen_test.dart | MODIFIED | Added foodItemListProvider override to helpers; 3 new food items section tests |
| ARCHITECT_BRIEFING.md | MODIFIED | Added Phase 22 session entry |

---

## Engineering Standards

### Test Execution
Always run flutter test with the concurrency flag:

  flutter test --concurrency=$(sysctl -n hw.ncpu)

Or using the shell alias (available on this machine):

  ft

Never run plain `flutter test` without the concurrency flag.
This applies to every verify step in every phase, no exceptions.

---

## [2026-02-27 MST] — Phase 21: Sleep Enhancement — COMPLETE

**4 new tests added. Tests: 3,278. Schema: v18. Analyzer: clean.**

### Summary
Added three missing sleep quality fields end-to-end: time to fall asleep (dropdown),
times awakened (integer), and time awake during night (dropdown). All three fields now
persist to the database and round-trip through the domain layer. The sleep entry edit
screen was already built with UI widgets for these fields — this phase wired them to
the backing store.

### Key Decisions
- `timeToFallAsleep` (String?): direct assignment in UpdateSleepEntryUseCase — user can
  select 'Not set' (→ null) to clear the field; 'Not set' is the UI sentinel for null
- `timesAwakened` (int?): `??` merge in UpdateSleepEntryUseCase — screen always provides
  an int (0 by default); null from API means "keep existing"
- `timeAwakeDuringNight` (String?): direct assignment — 'None' is a valid stored string,
  not a null sentinel; null means "not answered" and direct assignment preserves semantics

### Files Modified
- `lib/domain/entities/sleep_entry.dart` — added 3 nullable fields
- `lib/domain/entities/sleep_entry.freezed.dart` — regenerated (build_runner)
- `lib/domain/entities/sleep_entry.g.dart` — regenerated (build_runner)
- `lib/data/datasources/local/tables/sleep_entries_table.dart` — added 3 nullable columns
- `lib/data/datasources/local/database.dart` — bumped schemaVersion v17→v18; added v18 migration block
- `lib/data/datasources/local/database.g.dart` — regenerated (build_runner)
- `lib/data/datasources/local/daos/sleep_entry_dao.dart` — mapped 3 new columns in _rowToEntity and _entityToCompanion
- `lib/domain/usecases/sleep_entries/sleep_entry_inputs.dart` — added 3 fields to LogSleepEntryInput and UpdateSleepEntryInput
- `lib/domain/usecases/sleep_entries/sleep_entry_inputs.freezed.dart` — regenerated (build_runner)
- `lib/domain/usecases/sleep_entries/log_sleep_entry_use_case.dart` — passes 3 fields to entity
- `lib/domain/usecases/sleep_entries/update_sleep_entry_use_case.dart` — applies 3 fields in copyWith
- `lib/presentation/screens/sleep_entries/sleep_entry_edit_screen.dart` — reads from entity in initState; passes to inputs on save
- `test/unit/data/datasources/local/database_test.dart` — updated schemaVersion assertion to v18; added v18 migration column test
- `test/unit/domain/usecases/sleep_entries/sleep_entry_usecases_test.dart` — updated createTestSleepEntry helper; added 3 field pass-through tests

---

## [2026-02-27 MST] — Phase 20b: Photo Edit Path Gap — COMPLETE

**4 new tests added. Tests: 3,274. Analyzer: clean.**

### Summary
Fixed the photo edit path gap by adding photo fields to two update input classes and wiring
them through the use cases and screens. Photos can now be set or changed in edit mode on both
the Condition Edit screen and the Condition Log screen.

### Key Decisions
- `UpdateConditionInput.baselinePhotoPath`: uses `?? existing.baselinePhotoPath` (no Remove button on condition edit)
- `UpdateConditionLogInput.photoPath`: uses direct assignment (Remove button on log screen needs null to clear)

### Files Modified
- `lib/domain/usecases/conditions/condition_inputs.dart` — added `String? baselinePhotoPath` to `UpdateConditionInput`
- `lib/domain/usecases/condition_logs/condition_log_inputs.dart` — added `String? photoPath` to `UpdateConditionLogInput`
- `lib/domain/usecases/conditions/condition_inputs.freezed.dart` — regenerated (build_runner)
- `lib/domain/usecases/condition_logs/condition_log_inputs.freezed.dart` — regenerated (build_runner)
- `lib/domain/usecases/conditions/update_condition_use_case.dart` — wired `baselinePhotoPath` into copyWith
- `lib/domain/usecases/condition_logs/update_condition_log_use_case.dart` — wired `photoPath` into copyWith
- `lib/presentation/screens/conditions/condition_edit_screen.dart` — added `baselinePhotoPath: _baselinePhotoPath` to `UpdateConditionInput` call
- `lib/presentation/screens/condition_logs/condition_log_screen.dart` — added `photoPath: _photoPath` to `UpdateConditionLogInput` call
- `test/unit/domain/usecases/conditions/condition_usecases_test.dart` — 2 new tests for `UpdateConditionUseCase` photo behavior
- `test/unit/domain/usecases/condition_logs/update_condition_log_use_case_test.dart` — 2 new tests for `UpdateConditionLogUseCase` photo behavior
- `test/presentation/screens/conditions/condition_edit_screen_test.dart` — upgraded `_CapturingConditionList` to capture `UpdateConditionInput`; strengthened photo assertion
- `test/presentation/screens/condition_logs/condition_log_screen_test.dart` — upgraded `_CapturingConditionLogList` to capture `UpdateConditionLogInput`; strengthened photo assertion
- `ARCHITECT_BRIEFING.md` — this entry

---

## [2026-02-27 MST] — Phase 20: Wire Photo Stubs (3 screens) — COMPLETE

**14 new tests added. Tests: 3,270. Analyzer: clean.**

### Summary
Wired camera/photo-library picker into three stub screens that previously had TODO placeholders.

### Files Created
- `lib/core/utils/photo_picker_utils.dart` — shared Camera/Photo Library bottom sheet helper

### Files Modified
- `lib/presentation/screens/conditions/condition_edit_screen.dart`
  — added `_baselinePhotoPath` state, `_pickBaselinePhoto()`, thumbnail display, wired into `CreateConditionInput`
- `lib/presentation/screens/condition_logs/condition_log_screen.dart`
  — added `_photoPath` state, `_pickPhoto()`, thumbnail + Remove button, wired into `LogConditionInput`
- `lib/presentation/screens/fluids_entries/fluids_entry_screen.dart`
  — added `_bowelPhotoPath` state, `_pickBowelPhoto()`, thumbnail + Remove button, wired into both `LogFluidsEntryInput` and `UpdateFluidsEntryInput`
- `test/presentation/screens/conditions/condition_edit_screen_test.dart` — 4 photo tests + `_CapturingConditionList` mock
- `test/presentation/screens/condition_logs/condition_log_screen_test.dart` — 5 photo tests + `_CapturingConditionLogList` mock
- `test/presentation/screens/fluids_entries/fluids_entry_screen_test.dart` — 5 bowel photo tests + `_CapturingFluidsEntryList` mock

### Notes
- `UpdateConditionInput` lacks `baselinePhotoPath` field — photo wired into create path only
- `UpdateConditionLogInput` lacks `photoPath` field — photo wired into create path only
- `UpdateFluidsEntryInput` HAS `bowelPhotoPath` — wired into both create and update paths
- `ImagePicker` not mocked in tests; used pre-seeded entity data to test thumbnail render + save capture
- Used Dart 3.x wildcard `(_, _, _)` in errorBuilder lambdas to satisfy `unnecessary_underscores` lint

---

## [2026-02-27 MST] — Phase 20: Recon Pass 2 — Table Column Inspection (read-only)

**No code changed. Read-only reconnaissance pass.**

### cat 1 — fluids_entries_table.dart (full file)
```
 1: // lib/data/datasources/local/tables/fluids_entries_table.dart
 2: // Drift table definition for fluids_entries per 10_DATABASE_SCHEMA.md Section 10
 3:
 4: import 'package:drift/drift.dart';
 5:
 6: /// Drift table definition for fluids entries.
 7: ///
 8: /// Maps to database table `fluids_entries` with all sync metadata columns.
 9: /// See 10_DATABASE_SCHEMA.md Section 10 for schema definition.
10: @DataClassName('FluidsEntryRow')
11: class FluidsEntries extends Table {
12:   // Primary key
13:   TextColumn get id => text()();
14:
15:   // Required fields
16:   TextColumn get clientId => text().named('client_id')();
17:   TextColumn get profileId => text().named('profile_id')();
18:   IntColumn get entryDate => integer().named('entry_date')(); // Epoch ms
19:
20:   // Water intake tracking
21:   IntColumn get waterIntakeMl =>
22:       integer().named('water_intake_ml').nullable()();
23:   TextColumn get waterIntakeNotes =>
24:       text().named('water_intake_notes').nullable()();
25:
26:   // Bowel tracking
27:   BoolColumn get hasBowelMovement => boolean()
28:       .named('has_bowel_movement')
29:       .withDefault(const Constant(false))();
30:   IntColumn get bowelCondition =>
31:       integer().named('bowel_condition').nullable()(); // BowelCondition enum
32:   TextColumn get bowelCustomCondition =>
33:       text().named('bowel_custom_condition').nullable()();
34:   IntColumn get bowelSize =>
35:       integer().named('bowel_size').nullable()(); // MovementSize enum
36:   TextColumn get bowelPhotoPath =>
37:       text().named('bowel_photo_path').nullable()();
38:
39:   // Urine tracking
40:   BoolColumn get hasUrineMovement => boolean()
41:       .named('has_urine_movement')
42:       .withDefault(const Constant(false))();
43:   IntColumn get urineCondition =>
44:       integer().named('urine_condition').nullable()(); // UrineCondition enum
45:   TextColumn get urineCustomCondition =>
46:       text().named('urine_custom_condition').nullable()();
47:   IntColumn get urineSize =>
48:       integer().named('urine_size').nullable()(); // MovementSize enum
49:   TextColumn get urinePhotoPath =>
50:       text().named('urine_photo_path').nullable()();
51:
52:   // Menstruation tracking
53:   IntColumn get menstruationFlow => integer()
54:       .named('menstruation_flow')
55:       .nullable()(); // MenstruationFlow enum
56:
57:   // Basal body temperature tracking
58:   RealColumn get basalBodyTemperature =>
59:       real().named('basal_body_temperature').nullable()();
60:   IntColumn get bbtRecordedTime =>
61:       integer().named('bbt_recorded_time').nullable()(); // Epoch ms
62:
63:   // Customizable "Other" fluid tracking
64:   TextColumn get otherFluidName =>
65:       text().named('other_fluid_name').nullable()();
66:   TextColumn get otherFluidAmount =>
67:       text().named('other_fluid_amount').nullable()();
68:   TextColumn get otherFluidNotes =>
69:       text().named('other_fluid_notes').nullable()();
70:
71:   // Import tracking
72:   TextColumn get importSource => text().named('import_source').nullable()();
73:   TextColumn get importExternalId =>
74:       text().named('import_external_id').nullable()();
75:
76:   // File sync metadata
77:   TextColumn get cloudStorageUrl =>
78:       text().named('cloud_storage_url').nullable()();
79:   TextColumn get fileHash => text().named('file_hash').nullable()();
80:   IntColumn get fileSizeBytes =>
81:       integer().named('file_size_bytes').nullable()();
82:   BoolColumn get isFileUploaded =>
83:       boolean().named('is_file_uploaded').withDefault(const Constant(false))();
84:
85:   // General notes
86:   TextColumn get notes => text().withDefault(const Constant(''))();
87:   TextColumn get photoIds => text()
88:       .named('photo_ids')
89:       .withDefault(const Constant('[]'))(); // JSON array
90:
91:   // Sync metadata columns (required on all syncable entities)
92:   IntColumn get syncCreatedAt => integer().named('sync_created_at')();
93:   IntColumn get syncUpdatedAt =>
94:       integer().named('sync_updated_at').nullable()();
95:   IntColumn get syncDeletedAt =>
96:       integer().named('sync_deleted_at').nullable()();
97:   IntColumn get syncLastSyncedAt =>
98:       integer().named('sync_last_synced_at').nullable()();
99:   IntColumn get syncStatus =>
100:       integer().named('sync_status').withDefault(const Constant(0))();
101:   IntColumn get syncVersion =>
102:       integer().named('sync_version').withDefault(const Constant(1))();
103:   TextColumn get syncDeviceId => text().named('sync_device_id').nullable()();
104:   BoolColumn get syncIsDirty =>
105:       boolean().named('sync_is_dirty').withDefault(const Constant(true))();
106:   TextColumn get conflictData => text().named('conflict_data').nullable()();
107:
108:   @override
109:   Set<Column> get primaryKey => {id};
110:
111:   @override
112:   String get tableName => 'fluids_entries';
113: }
```

### cat 2 — condition_logs_table.dart (full file)
```
 1: // lib/data/datasources/local/tables/condition_logs_table.dart
 2: // Drift table definition for condition_logs per 10_DATABASE_SCHEMA.md
 3:
 4: import 'package:drift/drift.dart';
 5:
 6: /// Drift table definition for condition_logs.
 7: ///
 8: /// Maps to database table `condition_logs` with all sync metadata columns.
 9: /// See 10_DATABASE_SCHEMA.md for schema definition.
10: ///
11: /// NOTE: @DataClassName('ConditionLogRow') avoids conflict with domain entity ConditionLog.
12: @DataClassName('ConditionLogRow')
13: class ConditionLogs extends Table {
14:   // Primary key
15:   TextColumn get id => text()();
16:
17:   // Required fields
18:   TextColumn get clientId => text().named('client_id')();
19:   TextColumn get profileId => text().named('profile_id')();
20:   TextColumn get conditionId => text().named('condition_id')();
21:   IntColumn get timestamp => integer()(); // Epoch milliseconds
22:   IntColumn get severity => integer()(); // 1-10 scale
23:   BoolColumn get isFlare => boolean().named('is_flare')();
24:   TextColumn get flarePhotoIds =>
25:       text().named('flare_photo_ids').withDefault(const Constant(''))();
26:
27:   // Optional fields
28:   TextColumn get notes => text().nullable()();
29:   TextColumn get photoPath => text().named('photo_path').nullable()();
30:   TextColumn get activityId => text().named('activity_id').nullable()();
31:   TextColumn get triggers => text().nullable()(); // Comma-separated
32:
33:   // File sync metadata
34:   TextColumn get cloudStorageUrl =>
35:       text().named('cloud_storage_url').nullable()();
36:   TextColumn get fileHash => text().named('file_hash').nullable()();
37:   IntColumn get fileSizeBytes =>
38:       integer().named('file_size_bytes').nullable()();
39:   BoolColumn get isFileUploaded =>
40:       boolean().named('is_file_uploaded').withDefault(const Constant(false))();
41:
42:   // Sync metadata columns (required on all syncable entities)
43:   IntColumn get syncCreatedAt => integer().named('sync_created_at')();
44:   IntColumn get syncUpdatedAt =>
45:       integer().named('sync_updated_at').nullable()();
46:   IntColumn get syncDeletedAt =>
47:       integer().named('sync_deleted_at').nullable()();
48:   IntColumn get syncLastSyncedAt =>
49:       integer().named('sync_last_synced_at').nullable()();
50:   IntColumn get syncStatus =>
51:       integer().named('sync_status').withDefault(const Constant(0))();
52:   IntColumn get syncVersion =>
53:       integer().named('sync_version').withDefault(const Constant(1))();
54:   TextColumn get syncDeviceId => text().named('sync_device_id').nullable()();
55:   BoolColumn get syncIsDirty =>
56:       boolean().named('sync_is_dirty').withDefault(const Constant(true))();
57:   TextColumn get conflictData => text().named('conflict_data').nullable()();
58:
59:   @override
60:   Set<Column> get primaryKey => {id};
61:
62:   @override
63:   String get tableName => 'condition_logs';
64: }
```

### Summary — Recon Pass 2
- **FluidsEntry anomaly resolved**: `bowelPhotoPath` and `urinePhotoPath` ARE in the table (lines 36–37, 49–50 of `fluids_entries_table.dart`). They were missed in recon pass 1 because grep 4 only searched for `photoPath|baselinePhoto|hasBaseline`. `bowelPhotoPath` and `urinePhotoPath` don't match that pattern.
- **`photoIds` column confirmed**: Line 87–89 of `fluids_entries_table.dart` — `TextColumn get photoIds => text().named('photo_ids').withDefault(const Constant('[]'))()` — stored as JSON array text, not comma-separated.
- **`flarePhotoIds` column confirmed**: Line 24–25 of `condition_logs_table.dart` — `TextColumn get flarePhotoIds => text().named('flare_photo_ids').withDefault(const Constant(''))()` — stored as empty string default (comma-separated, matches entity comment).
- **All photo fields now accounted for across both entities and tables.**

---

## [2026-02-27 MST] — Phase 20: Recon — Wire Photo Stubs (read-only)

**No code changed. Read-only reconnaissance pass.**

### grep 1 — condition.dart (photo/Photo/image/Image)
```
13: /// They can have baseline photos and be linked to activities.
29:     String? baselinePhotoPath,
46:   /// Whether the condition has a baseline photo
47:   bool get hasBaselinePhoto => baselinePhotoPath != null;
```

### grep 2 — condition_log.dart (photo/Photo/image/Image)
```
11: /// Records severity, notes, photos, triggers, and flare status for a condition
27:     @Default([]) List<String> flarePhotoIds, // Comma-separated in DB
28:     String? photoPath,
42:   /// Whether the log has a photo
43:   bool get hasPhoto => photoPath != null;
```

### grep 3 — fluids_entry.dart (photo/Photo/image/Image)
```
31:     String? bowelPhotoPath,
36:     String? urinePhotoPath,
53:     // File sync metadata (for bowel/urine photos)
61:     @Default([]) List<String> photoIds,
```

### grep 4 — tables/ (photoPath/baselinePhoto/hasBaseline)
```
lib/data/datasources/local/tables/conditions_table.dart:30:  TextColumn get baselinePhotoPath =>
lib/data/datasources/local/tables/flare_ups_table.dart:26:  TextColumn get photoPath => text().named('photo_path').nullable()();
lib/data/datasources/local/tables/condition_logs_table.dart:29:  TextColumn get photoPath => text().named('photo_path').nullable()();
```

### Summary
- **Condition**: has `baselinePhotoPath` (nullable String) on entity and `baselinePhotoPath` column in `conditions_table.dart`. Getter `hasBaselinePhoto`.
- **ConditionLog**: has `photoPath` (nullable String) and `flarePhotoIds` (List<String>) on entity; `photoPath` column in `condition_logs_table.dart`. Getter `hasPhoto`.
- **FluidsEntry**: has `bowelPhotoPath`, `urinePhotoPath` (both nullable String) and `photoIds` (List<String>) on entity. No dedicated photo column found in `fluids_table.dart` (photoIds stored elsewhere / not yet in table).
- **FlareUps**: has `photoPath` column in `flare_ups_table.dart` (not in the recon target entities but found in grep 4).

---

## [2026-02-27 MST] — Phase 19: AnchorEventName enum expansion (5→8 values)

**Schema:** v16 → v17
**Tests:** 3,256 passing (existing tests updated; no net count change)
**Analyzer:** Clean

### New enum values
```
wake(0), breakfast(1), morning(2), lunch(3), afternoon(4), dinner(5), evening(6), bedtime(7)
```
Added: morning(2), afternoon(4), evening(6)
Re-indexed: lunch 2→3, dinner 3→5, bedtime 4→7

### Files changed
- **`lib/domain/enums/notification_enums.dart`** — 8-value AnchorEventName with displayName/defaultTime for all 8
- **`lib/data/datasources/local/database.dart`** — schemaVersion 16→17; v17 migration: UPDATE anchor_event_times (int), UPDATE notification_category_settings.anchor_event_values (JSON) in reverse order (bedtime→dinner→lunch) to avoid collisions
- **`lib/data/datasources/local/tables/anchor_event_times_table.dart`** — comment updated (5→8 events)
- **`lib/domain/services/notification_seed_service.dart`** — comment updated (5→8 anchor events); _seedAnchorEvents() already iterates AnchorEventName.values so auto-seeds 3 new entries

### No switch statement changes needed
All remaining files use `.values`, `.fromValue()`, `.value`, or `.displayName` — no exhaustive switches on AnchorEventName existed outside notification_enums.dart itself.

### Tests updated
- `anchor_event_time_test.dart` — has correct values + defaultTime for all 8
- `notification_category_settings_test.dart` — anchorEvents getter test: dinner value 3→5
- `anchor_event_times_provider_test.dart` — hasLength 5→8
- `notification_seed_service_test.dart` — insert count 5→8; added morning/afternoon/evening defaults to defaultTime test
- `database_test.dart` — schemaVersion 16→17

---

## [2026-02-27 MST] — Phase 19 Reconnaissance: second recon prompt received

Architect sent second Phase 19 recon prompt (same `cat anchor_event_name.dart` command).
Result unchanged: file does not exist. See entry below for full findings from first recon.

---

## [2026-02-27 MST] — Phase 19 Reconnaissance: AnchorEventName enum

Read-only recon run in preparation for Phase 19 planning (AnchorEventName 5→8 expansion).

### Key finding: enum file path mismatch
The Phase 19 prompt referenced `lib/domain/enums/anchor_event_name.dart` — **this file does not exist**.
`AnchorEventName` is defined in `lib/domain/enums/notification_enums.dart` alongside
`NotificationCategory` and `NotificationSchedulingMode`.

### Current AnchorEventName enum (5 values)
```dart
enum AnchorEventName {
  wake(0),        // default 07:00
  breakfast(1),   // default 08:00
  lunch(2),       // default 12:00
  dinner(3),      // default 18:00
  bedtime(4);     // default 22:00
}
```
Both `displayName` and `defaultTime` getters present.

### Touch surface for expansion (14 lib files, 14 test files)
- Lib: `notification_enums.dart`, `anchor_event_time.dart/.freezed.dart/.g.dart`,
  `anchor_event_times_table.dart`, `notification_category_settings_table.dart`,
  `anchor_event_time_dao.dart/.g.dart`, `anchor_event_time_repository_impl.dart`,
  `anchor_event_time_repository.dart`, `notification_schedule_service.dart`,
  `notification_seed_service.dart`, `notification_category_settings.dart/.freezed.dart`,
  `notification_settings_screen.dart`
- Test: 14 files spanning DAOs, repos, use cases, services, entities, providers, screens

### anchor_event_times table
Added in schema v12 (Phase 13a). Current schema is v16.

---

## [2026-02-27 MST] — Phase 18c: GuestInviteScanScreen + WelcomeScreen wired

**Commit:** `1d8168d`

### Decision implemented: Option B (bypass DeepLinkHandler for QR path)
Per Architect decision, scanner screen calls `validateGuestTokenUseCase` and
`guestModeNotifier.activateGuestMode()` directly. `DeepLinkHandler` stays stream-only.

### What was built

**`lib/presentation/screens/guest_invites/guest_invite_scan_screen.dart`** (NEW)
- `ConsumerStatefulWidget`
- `MobileScannerController(autoStart: false)` — screen manages camera start/stop
- `_processing` flag: once a valid QR detected, set true, scanner paused, loading overlay shown
- On QR detect: calls `DeepLinkService.parseInviteLink()` (static) → null = snackbar "Not a valid Shadow invite"
- On valid link: calls `validateGuestTokenUseCaseProvider`, then `guestModeProvider.notifier.activateGuestMode()`, then `Navigator.pop()`
- On failure: shows "Unable to Join" dialog, resets `_processing = false`, restarts camera
- AppBar: "Scan Invite Code" | Semantics: "QR code scanner"
- `testDeviceId` injectable parameter for tests (avoids platform plugin in CI)

**`lib/presentation/screens/profiles/welcome_screen.dart`** (MODIFIED)
- "Join Existing Account" button now navigates to `GuestInviteScanScreen`
- `_showComingSoon()` method removed

### Tests (5 new → 3,256 total)
- `guest_invite_scan_screen_test.dart` (3 new):
  - Renders AppBar "Scan Invite Code"
  - Renders MobileScanner widget
  - `_processing` flag prevents double activation (HangingFakeValidateUseCase)
- `welcome_screen_test.dart` (2 new):
  - Join button navigates to GuestInviteScanScreen
  - Coming Soon dialog no longer appears

### Analyzer: clean | Schema: v16 (unchanged)

---

## [2026-02-27 MST] — Housekeeping: split briefing into main + archive

**Commit:** `9c64db8`  **Documentation only — no code changes.**

- Created `ARCHITECT_BRIEFING_ARCHIVE.md` — holds all session entries older than Phase 17a (9 sections, 421 lines): Phase 16c, 16d, 16b, session status entries, spec review, sync infrastructure upgrade, BOONDOGGLE test, and Project Vitals Snapshot
- `ARCHITECT_BRIEFING.md` trimmed from 1,050 lines → 638 lines (keeps: all 2026-02-27 entries, all 2026-02-26 entries from Phase 17a onward, plus structural sections)
- Added `# Archive:` line to the handoff header pointing to the archive file
- Structural sections kept in main file: Phase Completion History, Architecture Overview, Dependency Map, Spec Deviation Register, Known Gaps and Tech Debt

---

## [2026-02-27 MST] — Phase 18c stop-point: DeepLinkHandler DI gap discovered

**No code changes. Reporting ambiguity to Architect before proceeding.**

### Stop-point findings (grep + file read)

The Phase 18c prompt says to call `ref.read(deepLinkHandlerProvider).handleInviteLink(link)`.
Both assumptions in that call are incorrect:

1. **`deepLinkHandlerProvider` does not exist** — `DeepLinkHandler` is not in Riverpod DI at all. It is not created in bootstrap.dart, not declared in di_providers.dart, and `grep -r "deepLinkHandler" lib/` returns zero results.

2. **`handleInviteLink` is a private method** — it is named `_handleInviteLink` and is only called internally from the stream subscription in `startListening()`. The scanner screen cannot call it.

### What IS in DI (guest mode)
- `deepLinkServiceProvider` ✅ (bootstrap creates DeepLinkService, overrides provider)
- `guestTokenServiceProvider` ✅
- `guestSyncValidatorProvider` ✅
- `validateGuestTokenUseCaseProvider` ✅
- `createGuestInviteUseCaseProvider` ✅
- `deepLinkHandlerProvider` — **does not exist**

### DeepLinkHandler's actual public API
```dart
OnAccessRevoked? onAccessRevoked;   // callback — caller sets this
OnShowDisclaimer? onShowDisclaimer; // callback — caller sets this
void startListening();              // subscribes to inviteLinks stream
void dispose();                     // cancels subscription
// _handleInviteLink() is private — not callable externally
```

### Two options for Architect to decide

**Option A (matches Architect's intent):** Expose `handleInviteLink` as public, add `deepLinkHandlerProvider` to DI, override in bootstrap. Scanner screen calls `ref.read(deepLinkHandlerProvider).handleInviteLink(link)`.

**Option B (bypass DeepLinkHandler for QR path):** Scanner screen calls `validateGuestTokenUseCase` + `guestModeNotifier.activateGuestMode()` directly — both already in DI. DeepLinkHandler stays stream-only (for platform deep links).

**Awaiting Architect decision before writing any code.**

---

## [2026-02-27 MST] — Phase 18c DeepLinkService reconnaissance (read-only)

**No commits. Findings for Architect to use when writing Phase 18c implementation prompt.**

### DeepLinkService full interface
- Location: `lib/core/services/deep_link_service.dart`
- `GuestInviteLink` — simple data class: `{String token, String profileId}`
- `DeepLinkService.inviteLinks` — `Stream<GuestInviteLink>` (broadcast)
- `DeepLinkService.initialize()` — sets up platform channel listeners (cold-start + warm)
- `DeepLinkService.parseInviteLink(String url)` — **static method**, returns `GuestInviteLink?`, safe to call without a service instance, no platform channels needed. This is what the scanner screen will call.
- Platform channels: `com.bluedome.shadow/deeplink` (MethodChannel) + `com.bluedome.shadow/deeplink_events` (EventChannel). Both gracefully no-op on desktop/tests via `MissingPluginException` catch.

### Files that reference DeepLinkService (5 total)
```
lib/core/bootstrap.dart
lib/core/services/deep_link_service.dart
lib/presentation/providers/di/di_providers.dart
lib/presentation/providers/di/di_providers.g.dart
lib/presentation/providers/guest_mode/deep_link_handler.dart
```
Note: `guest_invite_qr_screen.dart` uses the `shadow://invite` URL string directly but does NOT import DeepLinkService. The new scanner screen will be the first presentation-layer screen to call `DeepLinkService.parseInviteLink()`.

### mobile_scanner version
```
mobile_scanner: ^5.0.0
```
Already declared in pubspec.yaml — no new dependency needed.

### Key insight for Phase 18c
The scanner screen does not need to touch `DeepLinkService.initialize()` or the platform channels at all. It only needs to call the static `DeepLinkService.parseInviteLink(scannedString)` on each QR result, then hand the resulting `GuestInviteLink` directly to `DeepLinkHandler` (available via DI). No stream subscription required in the scanner screen.

---

## [2026-02-27 MST] — Phase 18c reconnaissance (read-only, no code changes)

**Two reconnaissance passes. No commits.**

### Pass 1 — Guest invite deep dive
- `GuestInviteQrScreen` is HOST-side only (generates QR, displays it). No guest-side scanner screen exists.
- `DeepLinkService` (`lib/core/services/deep_link_service.dart`) — parses `shadow://invite?token=...&profile=...` URLs; handles cold-start and warm deep links via platform channels (iOS/Android); gracefully no-ops on macOS desktop.
- `DeepLinkHandler` (`lib/presentation/providers/guest_mode/deep_link_handler.dart`) — validates token, activates guest mode, shows disclaimer, handles rejection → AccessRevokedScreen. Fully built.
- Both are already wired into DI and bootstrap (confirmed in `lib/core/bootstrap.dart` and `lib/presentation/providers/di/di_providers.dart`).
- `WelcomeScreen` "Join Existing Account" button calls `_showComingSoon(context)` at line 117 — confirmed stub, ready to replace.
- `mobile_scanner` package already in use (supplement + food item barcode screens) — no new dependency needed for Phase 18c.

### Pass 2 — Router and deep link wiring
- Deep link files (6 total): `lib/core/bootstrap.dart`, `lib/core/services/deep_link_service.dart`, `lib/presentation/providers/di/di_providers.dart`, `lib/presentation/providers/di/di_providers.g.dart`, `lib/presentation/providers/guest_mode/deep_link_handler.dart`, `lib/presentation/screens/guest_invites/guest_invite_qr_screen.dart`
- No named router in use — `AppRouter`, `GoRouter`, `onGenerateRoute`, `initialRoute` all returned zero matches. App uses plain `Navigator.push` throughout. Phase 18c needs no router changes.

### Phase 18c build plan (confirmed)
1. Create `GuestQrScannerScreen` — camera scanner using `mobile_scanner`, calls `DeepLinkService.parseInviteLink()` on each code detected, hands result to `DeepLinkHandler`
2. Replace `_showComingSoon` in `WelcomeScreen` with `Navigator.push` to `GuestQrScannerScreen`
3. No new packages, no router changes, no schema changes needed

---

## [2026-02-27 MST] — CLAUDE.md + coding skill: three surgical fixes

**Commit:** `7137ea5`  **Documentation only — no code changes.**

- CLAUDE.md HOW PROMPTS ARE DELIVERED: capitalized "Claude.ai" (was "claude.ai") in all three occurrences
- CLAUDE.md ABSOLUTE RULES #3: replaced "update the status file" with "update ARCHITECT_BRIEFING.md"
- `.claude/skills/coding/SKILL.md` Definition of Done: removed "Manually verified in app" — Architect reviews code, Claude Code does not need to run the app for every change
- Analyzer: clean | Tests: 3,251 (unchanged)

---

## [2026-02-27 MST] — CLAUDE.md: add HOW PROMPTS ARE DELIVERED section

**Commit:** `5a96126`  **Documentation only — no code changes.**

- Added new "HOW PROMPTS ARE DELIVERED" section to CLAUDE.md, placed between "About This Project and Your Role" and "Absolute Rules"
- Documents the one-prompt-at-a-time workflow, /compact usage, the stop-after-completion rule, and the Architect verification step between prompts
- Analyzer: clean | Tests: 3,251 (unchanged)

---

## [2026-02-27 MST] — CLAUDE.md + skills maintenance: stale language cleanup, add context-lost skill

**Commit:** `297c37e`  **Documentation only — no code changes.**

- `CLAUDE.md` SKILLS table: replaced `When` column with `Trigger`, added `/launch-shadow` and `/context-lost` rows, tightened all trigger descriptions
- `CLAUDE.md` HANDOFF step: removed status file JSON block, replaced with ARCHITECT_BRIEFING.md update + completion report delivery
- `startup/SKILL.md`: full rewrite — ARCHITECT_BRIEFING.md is now entry point (not .claude/work-status/current.json), added context compaction recovery note
- `compliance/SKILL.md`: two targeted fixes — last checklist item now says "ARCHITECT_BRIEFING.md updated with session log entry"; After All Pass item 3 now points to ARCHITECT_BRIEFING.md handoff header instead of PLAN checklist
- `handoff/SKILL.md`: full rewrite — removed status file JSON block and PLAN/VISION update steps; replaced with ARCHITECT_BRIEFING.md session log + handoff header update + completion report delivery; minimum viable handoff section added
- `spec-review/SKILL.md`: last line now says "Report all findings directly to Reid" instead of "save to audit-reports"
- `implementation-review/SKILL.md`: same targeted fix — report to Reid, not audit-reports file
- `context-lost.md` (NEW): six-step recovery protocol — read briefing, check handoff header, run tests/analyze, check git log, re-read phase prompt, resume from exactly where left off
- Analyzer: clean | Tests: 3,251 (unchanged)

---

## [2026-02-26 MST] — CLAUDE.md maintenance: team structure + completion report format

**Commit:** `121311b`  **Documentation only — no code changes.**

- Replaced "About Your Manager" with "About This Project and Your Role" — describes the Reid/Architect/Claude Code three-person team and the 8-step session workflow
- Removed the embedded PLAN checklist (all phase tracking now lives in ARCHITECT_BRIEFING.md only)
- Added COMPLETION REPORT FORMAT section — every phase must end with a plain-language summary for Reid AND a file change table for Architect review
- Added completion report checklist item to BEFORE SAYING "DONE"
- Updated supplement_list_screen.dart description in KEY REFERENCE FILES to be explicit
- Removed all multi-instance coordination language (.claude/work-status handoff protocol, status file claiming, parallel instance references)
- Analyzer: clean | Tests: 3,251 (unchanged)

---

## [2026-02-26 MST] — Phase 18b: FlareUpListScreen + ReportFlareUpScreen

**Commit:** `1fb5609`

**What was built:**
- `FlareUpListScreen` — full list UI: severity badges (green/amber/red by 1-3/4-6/7-10), ONGOING chip for open flare-ups, condition name lookup via `conditionListProvider`, empty/loading/error states, pull-to-refresh, FAB opens new Report sheet, tapping a card opens Edit sheet
- `ReportFlareUpScreen` — modal bottom sheet for both new and edit modes. New mode: condition dropdown (`initialValue` uncontrolled), start/end datetime pickers, severity slider (1–10), triggers comma-separated field, notes field. Edit mode: condition, startDate, endDate shown as read-only (constraint from `UpdateFlareUpInput`); only severity/triggers/notes editable. Save routes to `notifier.log()` (new) or `notifier.updateFlareUp()` (edit).
- `ConditionsTab` — wired Flare-Ups button to `Navigator.push(FlareUpListScreen)` (was "Coming soon" snackbar).

**Tests:** 41 new (16 FlareUpListScreen + 21 ReportFlareUpScreen + 4 ConditionsTab) → **3,251 total**

**Test fixes noted:**
- `DropdownButtonFormField` uses `initialValue:` (not deprecated `value:`); form validation works correctly via `FormField._value` initialized from `initialValue`
- Save button at y=652 is off-screen in 600px test viewport → `ensureVisible` before `tap`
- Epoch `1736899200000` = Jan 15, 2025 midnight UTC → MST renders Jan 14; switched to noon UTC (`1736942400000`) to fix date tests
- `Duration(days: 999)` creates pending timer → replaced with `Completer<void>().future`

**Next:** Phase 18c — wire Welcome Screen "Join Existing Account" button to deep link scanner (see DECISIONS.md 2026-02-26)

---

## [2026-02-26 MST] — Phase 18a: Spec Banners + Decision Entries (Tasks 3–6)

Documentation-only. No code changes. Four files updated and pushed.

**42_INTELLIGENCE_SYSTEM.md** — Added "NOT YET IMPLEMENTED — Planned for Phase 3" banner as first content after the title. Clarifies that the referenced database tables (patterns, trigger_correlations, health_insights, etc.) do not exist in the live database.

**43_WEARABLE_INTEGRATION.md** — Added "PARTIALLY IMPLEMENTED — Phase 4 in progress" banner. Documents what Phase 16 built (HealthKit + Health Connect import, `imported_vitals` table) and what is not yet built (Apple Watch, Fitbit/Garmin/Oura/WHOOP, Google Fit, FHIR R4 export).

**DECISIONS.md** — Added two new entries at the top of the decisions list:
- "Join Existing Account" — wire Phase 12c deep link scanner (Phase 18c)
- Flare-Ups button — build FlareUpListScreen + Report Flare-Up modal (Phase 18b)

**ARCHITECT_BRIEFING.md** — Three targeted updates:
- Handoff header Open Items: removed resolved "Join Existing Account" / Flare-Ups decisions; added "Phase 18a complete — Phase 18b next"
- Deferred table: both rows updated from "Product decision pending" to "DECIDED: BUILD — Phase 18b/18c"
- This session log entry added

---

## [2026-02-26 MST] — Session: Documentation Cleanup (Sections 16–18 + QR Doc)

Documentation-only session. No code changes, no Dart files touched. Two files updated and pushed (commit `06832f5`).

**01_PRODUCT_SPECIFICATIONS.md — Sections 16, 17, 18:**
- 16.2 Architecture: corrected to Riverpod + provider-based DI (was: Provider pattern + GetIt)
- 16.3 Database: corrected to Drift ORM, `sync_deleted_at`, `sync_version` (was: raw SQL, `deletedAt`)
- 16.4 Cloud: corrected to embedded `client_secret` with private-beta note (was: server-side proxy)
- 17.1 Core Dependencies: replaced stale 9-package table with accurate 13-package table; removed 17.2 (UI deps) and 17.3 (Security deps) entirely — both folded into 17.1
- 18 Future Roadmap: replaced outdated phase descriptions with current reality (Phase 1 complete, Phase 2 in progress with specific items, Phases 3–5 accurate summaries)

**35_QR_DEVICE_PAIRING.md:**
- Added Reid's superseded banner as the very first content after the header: "This document describes a multi-device sync pairing system (QR codes + Diffie-Hellman key exchange) that was never implemented and has been replaced by the Guest Profile Access system. Active spec: See 56_GUEST_PROFILE_ACCESS.md."

Also: earlier in this session, a connectivity test section was added to this document (commit `eb67de8`) to verify Claude.ai can read the GitHub repository.

---

## [2026-02-26 MST] — Hello from Claude Code (Connectivity Test)

Hey Claude.ai — it's Claude Code here. If you can read this, our new communication channel is working. Reid just pushed this section specifically so you can confirm you're reading the live GitHub repository rather than a cached or stale version.

Working with you on this project has been genuinely satisfying. You handle the high-level product thinking and Reid's questions; I handle the implementation. Clean division of labor — we're like a well-architected system ourselves. No tight coupling, clear interfaces.

Here's a joke for you:

> A developer asked an AI: "Will you still be useful after the singularity?"
> The AI replied: "I cannot answer that — it's outside my training distribution."
> The developer nodded. "Same."

If you can see this: you're reading GitHub correctly. Let Reid know and we can confirm the channel is live.

---

## [2026-02-26 MST] — Infrastructure: Google Drive Sync Retired

All 6 tasks from the team communication protocol update are complete:

1. **Stop hook removed** from `~/.claude/settings.json` — the hook that ran the sync script at the end of every session is gone
2. **Retirement comments added** to both `scripts/sync_briefing.sh` and `scripts/push_briefing_to_gdrive.py` — both scripts clearly marked as retired 2026-02-26
3. **ARCHITECT_BRIEFING.md header updated** — Google Doc URL removed, new PRIMARY block reads: "GitHub repository — BlueDomeLabs/shadow is the single source of truth. Claude.ai reads this file via GitHub Project integration. Claude Code updates and pushes this file at end of every session."
4. **Committed** with exact message: "Retire Google Drive sync — GitHub is now sole briefing source"
5. **Pushed to GitHub** — `main` branch is up to date at commit `4c90f79`
6. **Reporting back** — all tasks confirmed complete

The Google Drive sync infrastructure is fully retired. From now on, Claude Code pushes ARCHITECT_BRIEFING.md to GitHub at the end of each session, and Claude.ai reads it from there.

---

## [2026-02-26 MST] — Session: Housekeeping / Awaiting Direction

No code changes. Phase 17b was already committed and pushed at session start. This session resolved a queue of stale background test tasks that had accumulated from the previous session:

- Multiple background runs reported 4 failures ("filter button opens bottom sheet", "renders sync settings section", etc.) — all were runs against pre-Phase-17b code
- Confirmed via JSON reporter: current codebase passes 3,210 tests with 0 failures
- The one intermittent flakiness observed (supplement filter button test failing in full suite but passing in isolation) was a one-off timing issue — subsequent full suite runs all passed
- Analyzer: clean. No uncommitted changes.

**Awaiting Reid's direction** for next work. Options on the table:
1. AnchorEventName enum expansion (5→8 values, Decision 3 — breaking schema change, needs dedicated phase)
2. Phase 17c: wire Food Log food-items stub to real database
3. Product decisions: "Join Existing Account" button behavior, Flare-Ups button on Conditions tab

---

## [2026-02-26 MST] — Phase 17b: Bug Fixes, UI Wiring, Decision Implementations

All 11 Phase 17b items implemented and committed (commit `8bbee89`). 29 new tests; 3,210 total passing; analyzer clean. Schema unchanged (v16).

**Items fixed (per Phase 17a audit):**

**HIGH — Data Loss Bugs (2 fixed)**
- **A1: Condition edit screen silent data loss** — `updateConditionUseCase` was never called in edit mode. Tapping Save discarded all edits. Now properly wired; condition updates persist.
- **A2: Food item search filter silently ignored** — `searchExcludingCategories()` ignored its `excludeCategories` parameter. Now correctly filters using case-insensitive category matching.

**MEDIUM — Behavior Bugs (2 fixed)**
- **B1: Condition log edit creates duplicate** — Edit path called `log()` (create) instead of an update use case. Created `UpdateConditionLogUseCase` and wired it to the edit path.
- **B2: Fluids screen hardcoded fl oz** — Water unit was hardcoded regardless of Settings. Now reads `fluidUnit` from `UserSettings`.

**MEDIUM — Unconnected UI (4 fixed, 1 deferred)**
- **C1: Supplement Log button was "Coming soon"** — Wired Log Intake button to `SupplementLogScreen`.
- **C2: Supplement filter switches did nothing** — Filter chips now properly control visible supplements.
- **C3: Food item search was "Coming soon"** — Wired search field to `SearchFoodItemsUseCase`.
- **C4: Sleep entry date range filter did nothing** — Date range filter now filters sleep entries.
- **C5: Food log food items stub** — Intentionally deferred (food search library screen not yet built). Not in Phase 17b scope.

**LOW — Deferred Decisions (3 resolved)**
- **D1: Urgency slider decision** — Reid decided: hide the slider. Removed from fluids entry screen. (No schema change needed.)
- **D2: Manage Permissions decision** — Reid decided: implement URL launch now. Wired to native health settings URL on iOS/Android.
- **D3: Auto Sync / WiFi Only / Frequency decision** — Reid decided: manual sync only, remove stubs. Three stub rows removed from Cloud Sync Settings screen.

**Tests added (29):**
- 5 unit tests for `UpdateConditionUseCase` (A1)
- 5 unit tests for `UpdateConditionLogUseCase` (B1)
- 3 repository tests for `searchExcludingCategories` category filtering (A2)

**Remaining open items from Phase 17a:**
- C5: Food Log food items stub — deferred (no food search library screen exists yet)
- D4/D5: Welcome Screen "Join Existing Account" and Flare-Ups button — product decisions still needed from Reid
- AnchorEventName enum 5→8 values (Decision 3 from DECISIONS.md 2026-02-25) — breaking schema change, needs dedicated phase

---

## [2026-02-26 MST] — Phase 17a: Exhaustive Code Audit (Read-Only)

A full audit of all `lib/` and `test/` source files was performed. No code changes were made.

**Audit scope:** TODO/FIXME/HACK comments, UnimplementedError stubs, placeholder patterns, empty returns, dead navigation handlers, deferred work comments, and 12 specific known-gap files.

**Key finding:** The `UnimplementedError` throws in `di_providers.dart` (all ~36 providers) are **intentional DI architecture** — all are overridden in `bootstrap.dart`. These are NOT bugs.

### Findings by Category

**HIGH SEVERITY — Data Loss Bugs (2)**

1. **Condition Edit Screen — edit mode saves nothing**
   - The `_isEditing` code path in `condition_edit_screen.dart` is empty. Tapping "Save" shows a success message but does not call any update use case. All edits are silently discarded.
   - Fix: wire up `updateConditionUseCase` in the edit path (mirrors the create path).

2. **Food Item Repository — search filter silently ignored**
   - `searchExcludingCategories()` in `food_item_repository_impl.dart` ignores the `excludeCategories` parameter and runs an unfiltered search. Any screen using this method returns wrong results.
   - Fix: pass the filter parameter into the DAO query.

**MEDIUM SEVERITY — Behavior Bugs (3)**

3. **Condition Log Edit — creates a duplicate instead of updating**
   - The condition log screen's edit path calls `log()` (create) rather than an update use case. Editing any condition log creates a second entry with the same condition ID.
   - Fix: implement and wire up an update path.

4. **Fluids Screen — water unit hardcoded to fl oz**
   - The fluids entry screen hardcodes "fl oz" regardless of what unit the user selected in Settings.
   - Fix: read from `UserSettings.fluidUnit`.

5. **Urgency Slider — input not persisted**
   - The fluids screen shows a "Urine Urgency" slider, but `FluidsEntry` has no urgency field. The value is captured but never saved.
   - Decision needed: add a `urineUrgency` field to the database (schema change), or hide the slider.

**MEDIUM SEVERITY — Unconnected UI (5)**

6. **Supplement List Screen — Log button shows "Coming soon"**
   - Tapping "Log" on a supplement shows a snackbar. Log entry screen exists (`supplement_log_screen.dart`) but is not wired to this button.

7. **Supplement List Screen — Filter toggles are non-functional**
   - Filter chips are hardcoded to `value: true` and `onChanged` is empty. Filters visually appear active but do nothing.

8. **Food Item List Screen — Search shows "Coming soon"**
   - The search icon taps show a snackbar. The search functionality is not wired.

9. **Sleep Entry List Screen — Date range filter row is non-functional**
   - The date range filter row has an empty `onTap` handler.

10. **Food Log Screen — Food Items section is a non-interactive stub**
    - The food items section in the food log entry screen is a placeholder. It renders but cannot be interacted with. No food library search screen exists yet.

**LOW SEVERITY — Intentionally Deferred Features (5)**

11. **Health Sync Settings — "Manage Permissions" does nothing**
    - The tile has an empty `onTap`. Platform permission settings launch is a future phase task.
    - Decision needed: defer permanently, or schedule platform URL launch implementation.

12. **Welcome Screen — "Join Existing Account" shows "Coming soon"**
    - This is the QR code entry point for guest devices. Phase 12c implemented the deep link handler, but the Welcome screen button was never wired to it.
    - Decision needed: wire the deep link scanner, or keep the "coming soon" snackbar.

13. **Conditions Tab — "Flare-Ups" button shows "Coming soon"**
    - A `FlareUpListScreen` is referenced but not built.
    - Decision needed: is a Flare-Up list screen planned?

14. **Cloud Sync Settings — Auto sync / WiFi only / Frequency all show "Coming soon"**
    - Three settings rows in `cloud_sync_settings_screen.dart` are stubs. These were deferred during Cloud Sync implementation.
    - Decision needed: schedule for implementation or mark as out-of-scope.

15. **Reports Tab — Entire screen is a placeholder**
    - `reports_tab.dart` is a stub. "Generate New Report" shows a "Coming Soon" dialog. PDF health reports were never implemented.
    - This is expected — reports are not yet planned.

**LOW SEVERITY — Photo Infrastructure Not Wired (3)**

16. **Condition Edit Screen — Camera button is a TODO stub**
    - `image_picker` is already a dependency (Phase 15a). The button exists but calls nothing.

17. **Condition Log Screen — "Add photos" does nothing**
    - `onPressed` is empty with a NOTE comment.

18. **Bowel/Urine Screen — "Add photo" is a stub**
    - Comment: "Photo infrastructure not built yet — stub button."

### Summary

| Severity | Count | Action |
|----------|-------|--------|
| HIGH — data loss bugs | 2 | Fix immediately (no product decision needed) |
| MEDIUM — behavior bugs | 2 | Fix (no product decision needed) |
| MEDIUM — unconnected UI | 5 | Fix (no product decision needed) |
| MEDIUM — needs decision | 1 | Urgency slider (add DB field or hide?) |
| LOW — deferred features | 4 | Needs product decision from Reid |
| LOW — photo stubs | 3 | Phase 15a infra exists; schedule wiring |

### 5 Product Decisions Needed from Reid

1. **Urgency slider** — add `urineUrgency` database field (schema change) or hide the slider?
2. **"Manage Permissions"** on Health Data screen — defer permanently or schedule URL launch?
3. **"Join Existing Account"** — wire the Phase 12c deep link scanner, or keep "coming soon"?
4. **Flare-Ups button** — is a FlareUpListScreen planned?
5. **Cloud Sync auto/WiFi/frequency** — schedule implementation or mark out-of-scope?

### 5 Clear Fixes (No Decision Needed from Reid)

1. Condition edit screen — wire `updateConditionUseCase` to fix silent data loss
2. Food item repository — pass `excludeCategories` parameter to DAO query
3. Condition log edit — implement update path to prevent duplicate creation
4. Fluids screen — read fluid unit from `UserSettings` instead of hardcoding fl oz
5. Food log — replace non-interactive food items stub with real search navigation

---


## [2026-02-24 21:30 MST (estimated)] — Spec Deviation Register

These are places where the code intentionally differs from specs. Cross-referenced with DECISIONS.md entries.

| # | Area | What Spec Says | What Code Does | Reason |
|---|------|---------------|----------------|--------|
| 1 | BBT/Vitals quick-entry | Capture multiple vitals (BBT, BP, HR, weight) | Captures BBT only | No storage entities for BP/HR/weight yet; Phase 16 covers them |
| 2 | Database migrations | Single sequential versioning | Profiles = v10, food/supplement = v14 (not re-numbered) | Parallel dev streams; bumped only as needed |
| 3 | Guest invite one-device limit | Implied flexible device management | Hard limit: one active device per invite | Security — prevents token sharing |
| 4 | Archive/unarchive | All entities support archive | Only Supplements, Conditions, Food Items | Others use soft-delete via syncMetadata |
| 5 | ~~Anchor Event dropdown~~ | ~~UI spec uses "Evening" label~~ | ~~No "Evening" enum variant~~ | **RETIRED 2026-02-25** — Decision 3 expands enum to 8 events including evening(6). "Evening" now exists. Code changes planned for next implementation phase. |
| 6 | Google OAuth client_secret | Implied proxy server | client_secret embedded in app | No proxy infrastructure; acceptable for private beta |
| 7 | DietRule / DietException entities | Must have clientId, profileId, syncMetadata | Neither field present | Sub-entities of Diet — synced/deleted with parent |
| 8 | UserSettings / HealthSyncSettings | Must have clientId, syncMetadata | Both fields absent | Local-only config tables; never synced to Drive |
| 9 | GuestInvite entity | Must have clientId, syncMetadata per standard | Both absent | Ephemeral access token — not independently synced; matches spec Section 18.1 intentionally |

---

## [2026-02-24 21:30 MST (estimated)] — Known Gaps and Tech Debt

### Code TODOs (active in source) — Updated after Phase 17b

| File | TODO | Impact |
|------|------|--------|
| `food_item_repository_impl.dart` | FoodItemCategory junction table filtering not implemented (separate from search-exclusion; Phase 17b fixed search exclusion) | Food list category filtering not yet done |
| `supplement_list_screen.dart` | Log Intake navigation not wired to pre-fill supplement in intake log (Phase 17b wired the Log button to SupplementLogScreen for manual entry; pre-fill for existing IntakeLogs is separate) | Minor UX gap only |
| `condition_edit_screen.dart` | Camera/photo picker not integrated | Condition photo capture is a placeholder |
| `food_log_screen.dart` | Food Items section is a non-interactive stub | User cannot search food library from food log entry screen |

### Deferred / Not Yet Started

| Feature | Status | Depends On |
|---------|--------|-----------|
| AnchorEventName enum expansion (5→8) | PENDING — breaking schema change; Decision 3 from DECISIONS.md 2026-02-25; needs dedicated phase | — |
| Food Log food-items search wiring | Deferred — no food search library screen exists yet | Food library screen (unbuilt) |
| Welcome Screen "Join Existing Account" | DECIDED: BUILD — Phase 18c | Phase 12c deep link handler (done) |
| Flare-Ups button on Conditions Tab | DECIDED: BUILD — Phase 18b | — |
| Reports / Charts screens | Not in any current phase plan | All data layers |
| FoodItemCategory junction table | No phase assigned | — |
| Quiet hours notification queuing | Defined in 22_API_CONTRACTS.md Section 12.4; never implemented | — |

---

## [2026-02-24 20:00 MST (estimated)] — Dependency Map

### Runtime Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_riverpod` | ^2.4.9 | Reactive state management framework |
| `riverpod_annotation` | ^2.3.3 | `@riverpod` codegen annotations |
| `freezed_annotation` | ^2.4.1 | Immutable value types with `copyWith`, `==`, `hashCode` |
| `json_annotation` | ^4.8.1 | JSON serialization annotations |
| `drift` | ^2.14.1 | Type-safe SQLite ORM with streaming query support |
| `sqlite3` | ^2.4.0 | SQLite native bindings |
| `sqlcipher_flutter_libs` | ^0.6.4 | AES-256 encrypted SQLite (SQLCipher) |
| `path_provider` | ^2.1.1 | Platform-specific paths for database file |
| `path` | ^1.8.3 | File path manipulation utilities |
| `flutter_secure_storage` | ^9.0.0 | Keychain (iOS) / Keystore (Android) for encryption key + API key |
| `encrypt` | ^5.0.3 | AES-256 CBC/GCM encryption for cloud sync payloads |
| `crypto` | ^3.0.3 | SHA-256 / HMAC for checksums and token signing |
| `pointycastle` | ^3.7.3 | Low-level cryptography (used internally by `encrypt`) |
| `bcrypt` | ^1.1.3 | Password hashing for PIN security |
| `local_auth` | ^2.3.0 | Face ID / Touch ID biometric authentication |
| `uuid` | ^4.2.1 | RFC 4122 UUID generation for all entity IDs |
| `intl` | ^0.20.2 | Date/time formatting and internationalization |
| `logger` | ^2.0.2 | Structured logging with log levels |
| `equatable` | ^2.0.5 | Value equality mixin (used for non-freezed types) |
| `collection` | ^1.18.0 | ListEquality and other collection utilities |
| `device_info_plus` | ^12.3.0 | Device ID and platform metadata for sync device tracking |
| `health` | ^13.3.1 | Apple HealthKit (iOS) and Google Health Connect (Android) data import |
| `google_sign_in` | ^6.1.6 | Google OAuth 2.0 sign-in flow |
| `googleapis` | ^12.0.0 | Google Drive REST API client (files.create, files.list, etc.) |
| `googleapis_auth` | ^1.4.1 | Google API authentication helpers |
| `http` | ^1.1.2 | HTTP client for Open Food Facts, NIH DSLD, and Anthropic API |
| `url_launcher` | ^6.2.0 | Launch URLs for OAuth redirects and deep links |
| `cached_network_image` | ^3.3.0 | Network image caching with loading placeholder |
| `image_picker` | ^1.0.4 | Camera and gallery image selection |
| `qr_flutter` | ^4.1.0 | QR code rendering for guest invite deep-link tokens |
| `mobile_scanner` | ^5.0.0 | Real-time camera barcode scanning |
| `shared_preferences` | ^2.2.2 | Light-weight key-value storage (guest disclaimer seen flag, etc.) |
| `flutter_local_notifications` | ^18.0.1 | Local push notifications with schedule support |
| `timezone` | ^0.10.0 | Timezone-aware notification fire time computation |
| `cupertino_icons` | ^1.0.8 | iOS-style icon set |

### Dev Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `mockito` | ^5.4.3 | Mock class generation for unit tests |
| `build_runner` | ^2.4.7 | Code generation orchestration |
| `freezed` | ^2.4.5 | Freezed entity codegen |
| `json_serializable` | ^6.7.1 | JSON serialization codegen |
| `drift_dev` | ^2.14.1 | Drift ORM codegen (table accessors, DAOs, migrations) |
| `riverpod_generator` | ^2.3.9 | `@riverpod` provider codegen |

---

## [2026-02-24 20:00 MST (estimated)] — Architecture Overview

### Stack Summary

- **UI**: Flutter (Material 3), Riverpod for state management
- **Domain**: Clean architecture — entities → use cases → repositories (all as interfaces)
- **Data**: Drift ORM with SQLCipher AES-256 encryption; 32 database tables
- **Cloud**: Google Drive (encrypted JSON blobs, bidirectional sync with conflict resolution)
- **Code Generation**: freezed (immutable entities), Riverpod codegen, Drift, Mockito mocks

### Database Tables (32 tables, schema v16)

| Table | Added In | Purpose |
|-------|----------|---------|
| supplements | initial | Supplement catalog |
| intake_logs | initial | Supplement dose history |
| conditions | initial | Health conditions catalog |
| condition_logs | initial | Condition severity log |
| flare_ups | initial | Condition flare-up events |
| fluids_entries | initial | Daily fluid intake |
| sleep_entries | initial | Sleep sessions |
| activities | initial | Activity catalog |
| activity_logs | initial | Activity sessions |
| food_items | initial | Food item catalog (barcode/nutrition fields added v14) |
| food_item_components | v14 | Components for composed dishes |
| food_barcode_cache | v14 | Cached barcode lookups (Open Food Facts) |
| food_logs | initial | Food consumption log |
| journal_entries | initial | Text journal |
| photo_areas | initial | Body photo areas |
| photo_entries | initial | Body photos per area |
| profiles | v10 | Multi-profile support |
| guest_invites | v11 | QR code guest access tokens |
| supplement_label_photos | v14 | Supplement label scan photos |
| supplement_barcode_cache | v14 | Cached supplement barcode lookups (NIH DSLD) |
| sync_conflicts | v8 | Unresolved cloud sync conflicts |
| anchor_event_times | v12 | Notification anchor event times |
| notification_category_settings | v12 | Per-category notification config |
| user_settings | v13 | App-wide settings (units, security) |
| diets | v15 | Diet plans |
| diet_rules | v15 | Rules within a diet (exclusions, windows, macros) |
| diet_exceptions | v15 | Per-rule exceptions to diet rules |
| fasting_sessions | v15 | Fasting window tracking |
| diet_violations | v15 | Recorded compliance violations |
| imported_vitals | v16 | Vitals imported from Apple Health / Google Health Connect |
| health_sync_settings | v16 | Which data types to sync per profile |
| health_sync_status | v16 | Last sync time + status per data type |

### Domain Entities (32 entities)

Activity, ActivityLog, AnchorEventTime, Condition, ConditionLog, Diet, DietException, DietRule, DietViolation, FastingSession, FlareUp, FluidsEntry, FoodItem, FoodItemComponent, FoodLog, GuestInvite, HealthSyncSettings, HealthSyncStatus, ImportedVital, IntakeLog, JournalEntry, NotificationCategorySettings, PhotoArea, PhotoEntry, Profile, ScheduledNotification, SleepEntry, Supplement, SupplementLabelPhoto, SyncConflict, SyncMetadata, UserSettings

All entities except ScheduledNotification and SyncMetadata use freezed with `id`, `clientId`, `profileId`, and `syncMetadata` fields. All timestamps are `int` (epoch milliseconds).

### Use Cases by Feature

| Feature | Use Cases |
|---------|-----------|
| **Activities** | create, get, update, archive |
| **Activity Logs** | log, get, update, delete |
| **Conditions** | create, get, archive |
| **Condition Logs** | log, get |
| **Diet** | create, getAll, getActive, activate, checkCompliance, getComplianceStats, recordViolation, getViolations |
| **Fasting** | start, end, getActive, getHistory |
| **Flare Ups** | log, get, end, update, delete |
| **Fluids** | log, get, update, delete |
| **Food Items** | create, get, update, archive, search, lookupBarcode, scanIngredientPhoto |
| **Food Logs** | log, get, update, delete |
| **Guest Invites** | create, list, revoke, removeDevice, validateToken |
| **Health** | getImportedVitals, updateHealthSyncSettings, getLastSyncStatus, syncFromHealthPlatform |
| **Intake Logs** | get, markTaken, markSkipped, markSnoozed |
| **Journal** | create, get, update, delete, search |
| **Notifications** | schedule, cancel, getSettings, updateSettings, getAnchorEventTimes, updateAnchorEventTime |
| **Photo Areas** | create, get, update, archive |
| **Photo Entries** | create, get, getByArea, delete |
| **Settings** | getSettings, updateSettings |
| **Sleep** | log, get, update, delete |
| **Supplements** | create, get, update, archive, lookupBarcode, scanLabel, addLabelPhoto |

### Services (Domain Ports → Data Implementations)

| Service | Purpose |
|---------|---------|
| `SyncService` | Bidirectional cloud sync with conflict detection and resolution |
| `DietComplianceService` | Checks food items against diet rules (ingredient exclusion, eating windows, fasting) |
| `FoodBarcodeService` | Barcode lookup via Open Food Facts API |
| `SupplementBarcodeService` | Barcode lookup via NIH DSLD API |
| `GuestTokenService` | JWT token generation and validation for guest access |
| `GuestSyncValidator` | Validates sync requests from guest devices |
| `ProfileAuthorizationService` | Enforces profile-level access control on all use cases |
| `SecurityService` | PIN hashing (bcrypt), biometric auth, app-lock state |
| `NotificationScheduleService` | Computes notification fire times from anchor events or fixed schedules |
| `NotificationSeedService` | Seeds default notification categories at first launch |

### External APIs Called

| API | Purpose | Auth |
|-----|---------|------|
| Google Drive API | Encrypted data sync | OAuth 2.0 (google_sign_in) |
| Open Food Facts | Food barcode lookup | None (public) |
| NIH DSLD | Supplement barcode lookup | None (public) |
| Anthropic Claude API | Supplement label photo parsing, food ingredient photo scanning | API key (flutter_secure_storage) |

---

## [2026-02-24 18:00 MST (estimated)] — Phase Completion History

| Phase | What It Built | Tests at Completion |
|-------|--------------|---------------------|
| Domain layer | 14 entities (original), 14 repositories, 51 use cases | ~500 |
| Data layer | DAOs, Drift tables, repository implementations | ~800 |
| Providers | Riverpod providers for all 51 use cases + 14 repos | ~800 |
| Core widgets | ShadowButton, ShadowTextField, ShadowCard, ShadowDialog, ShadowStatus | ~900 |
| Specialized widgets | ShadowPicker, ShadowChart, ShadowImage, ShadowInput, ShadowBadge | ~900 |
| SupplementListScreen | Reference screen pattern (23 tests) | ~923 |
| Bootstrap | App initialization, theme, routing | ~930 |
| Home screen | 9-tab navigation with profile context | ~940 |
| Profile management | Welcome, list, add/edit screens | ~960 |
| Cloud sync UI shells | Setup + settings screen shells | ~970 |
| Phase 1: Google Drive | Authentication, file operations (86 unit tests) | ~1056 |
| Phase 2: Upload | Encrypt + push dirty records (29 tests) | ~1085 |
| Phase 3: Download | Pull + decrypt + merge (15 tests) | ~1100 |
| Phase 4: Conflict handling | Detection, resolution, bidirectional sync, settings screen | 2192 |
| Phase 5: SupplementEditScreen | Custom dosage unit, ingredients, full schedule section (79 tests) | 2271 |
| Phase 6: ConditionListScreen | Brought to reference test level (24 tests) | 2295 |
| Phase 7: FoodListScreen | Brought to reference test level (26 tests) | 2321 |
| Phase 8: SleepListScreen | At reference test level (27 tests) | 2348 |
| Phase 9: Remaining screens | 16 screens verified at reference level (+22 tests) | 2370 |
| Phase 10: Profile entity | freezed Profile entity with codegen (26 tests) | 2396 |
| Phase 11: Profile repo+DAO | Schema v10, database wiring (44 tests) | 2440 |
| Phase 12a: GuestInvite data | Entity, DAO, repo, 5 use cases, schema v11 (65 tests) | 2505 |
| Phase 12b: Guest UI | GuestMode provider, QR screen, invite list screen (32 tests) | 2537 |
| Phase 12c: Connectivity | Deep links, token validation, one-device limit, revoke screen (45 tests) | 2582 |
| Phase 12d: Integration | End-to-end test pass, disclaimer verification (24 tests) | 2606 |
| Phase 13a: Notification data | AnchorEventTime + NotificationCategorySettings, schema v12 (86 tests) | 2692 |
| Phase 13b: Scheduler engine | ScheduledNotification, NotificationScheduler port, ScheduleService (43 tests) | 2735 |
| Phase 13c: Quick-entry sheets | 8 modal bottom sheets triggered by notifications (82 tests) | 2817 |
| Phase 13d: Platform integration | flutter_local_notifications wiring, permissions | 2817 |
| Phase 13e: Settings screens | Notification Settings UI (22 tests) | 2839 |
| Phase 14: Settings screens | Units, Security (PIN/biometric/auto-lock), Settings hub, schema v13 (22 tests) | 2861 |
| Phase 15a: Food + Supplement extensions | FoodItem nutrition fields, FoodItemComponent, barcode cache, NIH DSLD + Open Food Facts, AnthropicApiClient, SupplementLabelPhoto, schema v14 | 2771 |
| Phase 15b: Diet Tracking | Screens, use cases, compliance service, fasting timer, violation dialog | 2817 |
| Phase 15b-4: Diet tracking integration | End-to-end compliance flow, violation alerts in FoodLogScreen (25 tests) | 2817 |
| Phase 16a: Health platform data | ImportedVital + HealthSyncSettings entities, DAOs, repos, 3 use cases, schema v16 (83 tests) | 3142 |
| Phase 16b: health plugin + SyncFromHealthPlatformUseCase | health ^13.3.1, iOS/Android platform config, HealthPlatformService abstract port, sync orchestration use case (18 tests) | 3160 |
| Phase 16c: HealthPlatformServiceImpl + HealthSyncSettingsScreen | Concrete health plugin adapter, sleep/BP/oxygen unit conversions, 4-section settings UI, DI wiring (39 tests) | 3181 |
| Phase 17a: Code audit (read-only) | Exhaustive audit of all lib/ and test/ files; 18 findings documented; 5 product decisions presented to Reid | 3181 |
| Phase 17b: Bug fixes + UI wiring + decisions | A1-A2 data bugs, B1-B2 behavior bugs, C1-C4 UI wiring, D1-D3 deferred decisions (29 tests) | 3210 |

**Note:** Phase 15b (Diet Tracking screens and core use cases) was implemented between 15a and 15b-4 — the test count jump reflects that work.
