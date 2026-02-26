# ARCHITECT_BRIEFING.md
# Shadow Health Tracking App — Architect Reference
# Last Updated: [auto-stamped on push by push_briefing_to_gdrive.py]
# Briefing Version: 20260226-001
#
# PRIMARY: Google Doc at https://docs.google.com/document/d/1dCOexVrJxnJX4vC8ItvL_twSvqBLC2Ro8oUkcG3m-8w
# This .md file is the source of truth committed to git.
# A Stop hook (scripts/sync_briefing.sh) automatically pushes it to the Google Doc at end of every session.
#
# ── CLAUDE HANDOFF ──────────────────────────────────────────────────────────
# Status:        Phase 17a complete — read-only code audit, 18 findings documented
# Last Action:   Phase 17a exhaustive code audit across all lib/ and test/ files
# Next Action:   Reid to review 5 product decisions; 5 clear fixes ready to implement
# Open Items:    5 product decisions pending Reid's direction (see Phase 17a section)
# Tests:         3,181 passing (unchanged)
# Schema:        v16 (unchanged)
# Analyzer:      Clean
# ────────────────────────────────────────────────────────────────────────────

This document gives Claude.ai high-level visibility into the Shadow codebase.
Sections are in reverse chronological order — most recent at top, oldest at bottom.

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

## [2026-02-26 MST] — Phase 16c Complete: HealthPlatformServiceImpl + HealthSyncSettingsScreen

**What was completed:**

Phase 16c is done and committed (commits `d7c6167`, `d6abfa7`). 39 new tests; 3,181 total passing; analyzer clean. Schema unchanged (v16).

**Changes made:**

- **`HealthPlatformServiceImpl`** (NEW — `lib/data/services/health_platform_service_impl.dart`): Concrete adapter for the `health` plugin. This is the only file in the codebase that imports `package:health/health.dart`. Injected `hp.Health` instance for testability. Handles: iOS vs Android platform detection, `isAvailable()` (false on macOS/other), `requestPermissions()` with per-type `hasPermissions()` check, `readRecords()` with sleep/BP/oxygen unit conversions. Sleep: converts `dateTo - dateFrom` duration to hours. Returns `Result<T, AppError>` for all fallible operations.
- **`HealthSyncSettingsScreen`** (NEW — `lib/presentation/screens/health/health_sync_settings_screen.dart`): 4-section settings screen wired into Settings hub. Sections: (1) Platform status row showing Apple Health / Google Health Connect + available status; (2) Sync controls — "Sync from Health" button, last synced timestamp, sync result message, Manage Permissions row; (3) Date range segmented button (30/60/90 days); (4) Per-data-type toggles for all 9 health data types.
- **DI wiring**: `healthPlatformServiceProvider` in `di_providers.dart` overridden in `bootstrap.dart` with `HealthPlatformServiceImpl`. Settings hub updated with Health Data tile.

**Tests added (39):**
- 14 unit tests for `HealthPlatformServiceImpl` (Mockito mock of `hp.Health`)
- 24 widget tests for `HealthSyncSettingsScreen`
- 1 settings hub tile test

**Current project state:**
- Tests: 3,181 passing
- Analyzer: Clean
- Schema: v16

---

## [2026-02-26 MST] — Phase 16d: Physical Device Testing Deferred

Phase 16d integration testing requires a physical iOS device with HealthKit data.
Testing is deferred pending access to Reid's daughter's iPhone + Apple Watch.

**When device is available, manual test checklist:**
- Settings → Health Data screen renders correctly on device
- Platform status shows "Apple Health — Connected"
- All 9 data type toggles present and enabled by default
- "Sync from Health" button triggers sync with progress indicator
- Result summary shows imported record counts by type
- Last synced timestamp persists after navigation
- Incremental sync imports 0 duplicates on second run
- Imported vitals stored correctly in database (verify via GetImportedVitalsUseCase)
- Permission denial handled gracefully (no crash, denied types reported)
- Steps and sleep data import from iPhone alone (no Watch required)
- Heart rate and resting heart rate import from Apple Watch data

**Data types testable without Apple Watch (iPhone alone):**
- Steps (iPhone accelerometer)
- Sleep (iOS 16+ built-in sleep tracking)
- Weight (manual entry in Health app)
- Blood pressure (manual entry in Health app)
- Blood oxygen (manual entry in Health app)

**Data types requiring Apple Watch:**
- Heart rate
- Resting heart rate
- Active calories

---

## [2026-02-25 21:00 MST] — Phase 16b Complete: health plugin + SyncFromHealthPlatformUseCase

**What was completed:**

Phase 16b is done and committed (commit `51b2385`). 18 new tests; 3,160 total passing; analyzer clean.

**Changes made:**

- `pubspec.yaml`: Added `health: ^13.3.1` (Apple HealthKit / Google Health Connect Flutter plugin). Also upgraded `device_info_plus` from `^10.1.0` to `^12.3.0` (required by health >=13.2.0 — stable APIs unchanged).
- **iOS platform config**: New `ios/Runner/Runner.entitlements` file with `com.apple.developer.healthkit` entitlement (background delivery disabled). `project.pbxproj` updated to wire entitlements into all 3 build configurations. `Info.plist` updated with `NSHealthShareUsageDescription` and `NSHealthUpdateUsageDescription` privacy strings.
- **Android platform config**: 8 Health Connect READ permissions added to `AndroidManifest.xml` (`READ_HEART_RATE`, `READ_RESTING_HEART_RATE`, `READ_WEIGHT`, `READ_BLOOD_PRESSURE`, `READ_SLEEP`, `READ_STEPS`, `READ_ACTIVE_CALORIES_BURNED`, `READ_OXYGEN_SATURATION`). Permission rationale intent filter and HealthConnectClient activity added.
- **`HealthPlatformService`** (NEW — `lib/domain/repositories/health_platform_service.dart`): Abstract domain port. The `health` plugin is never imported in domain layer. Same pattern as `NotificationScheduler`. Exposes: `currentPlatform`, `isAvailable()`, `requestPermissions()`, `readRecords()`.
- **`SyncFromHealthPlatformUseCase`** (NEW): Full orchestration — auth → availability → load settings → request permissions → incremental import per granted type → upsert sync status. Platform read failures per type are non-fatal (logs 0, continues). `importBatch` failures are propagated.
- **`SyncFromHealthPlatformInput` / `SyncFromHealthPlatformResult`**: New freezed types added to `health_types.dart`. Result includes `importedCountByType`, `deniedTypes`, `platformUnavailable`, and `totalImported` computed getter.

**Decisions recorded in DECISIONS.md:**
1. HealthPlatformService as abstract port (domain layer) — keeps use case testable without a real device.
2. device_info_plus upgrade to ^12.3.0 — required by health plugin, no code changes needed.

**What is NOT yet done (Phase 16c):**
- No concrete `HealthPlatformServiceImpl` yet — the abstract port exists but nothing wires the actual `health` plugin to it. Real data won't flow from HealthKit/Health Connect until this is built.
- Health Sync Settings UI screen (HealthSyncSettingsScreen).

**Current project state:**
- Tests: 3,160 passing
- Analyzer: Clean (0 issues)
- Schema: v16
- Open decisions: 0

---

## [2026-02-25 19:00 MST] — Session Status: Spec Cleanup Complete, Awaiting Phase 16b

**Session note:** This entry was added after a rate-limit interruption delayed the briefing sync. The last successful Google Drive push was Briefing Version 20260225-004 (this morning). No work was lost — everything is committed and pushed to GitHub. This entry ensures Claude.ai has a current status report.

**What was completed today (2026-02-25):**

All 4 decisions confirmed by Reid and recorded in DECISIONS.md. All 48 spec findings from the converged spec review were applied across 12 spec documents. Zero source code changes — this was a documentation-only session.

**Decisions resolved:**
1. WakingFeeling — 3 options only (Unrested/Neutral/Rested). Energized dropped. Spec updated, code already correct.
2. Sleep missing fields (Time to Fall Asleep, Times Awakened, Time Awake During Night) — DECIDED: build in a future sleep enhancement phase. Schema migration required. Do not build without a planned phase.
3. Anchor events — expand from 5 to 8 named events: wake(0), breakfast(1), morning(2), lunch(3), afternoon(4), dinner(5), evening(6), bedtime(7). **This is a breaking enum change requiring a schema migration** — code changes are pending a dedicated implementation phase. Specs updated. Deviation #5 retired.
4. PIN length — 6 digits fixed. 58_SETTINGS_SCREENS.md is authoritative. Spec updated.

**Spec files changed (12 total):**
DECISIONS.md, 10_DATABASE_SCHEMA.md, 22_API_CONTRACTS.md, 38_UI_FIELD_SPECIFICATIONS.md, 56_GUEST_PROFILE_ACCESS.md, 57_NOTIFICATION_SYSTEM.md, 58_SETTINGS_SCREENS.md, 59_DIET_TRACKING.md, 59a_FOOD_DATABASE_EXTENSION.md, 60_SUPPLEMENT_EXTENSION.md, 61_HEALTH_PLATFORM_INTEGRATION.md, 35_QR_DEVICE_PAIRING.md, 53_SPEC_CLARIFICATIONS.md

**Current project state:**
- Tests: 3,142 passing
- Analyzer: Clean (0 issues)
- Schema: v16
- Open decisions: 0
- Unresolved spec findings: 0
- Source code: Unchanged from Phase 16a completion
- Last commit: 6e7e94c (handoff update)

**Next:** Awaiting Reid go-ahead for Phase 16b — SyncFromHealthPlatformUseCase + iOS/Android platform plugin configuration. Do not begin without explicit approval.

---

## [2026-02-25 09:30 MST] — Parts 3–6: Decision Resolution + Full Spec Cleanup

All 4 open decisions resolved. All 48 spec findings from the Section 8 converged review applied.

### Decisions Recorded

| # | Decision | Outcome |
|---|----------|---------|
| 1 | WakingFeeling enum — Energized option | DROPPED — spec updated to 3 options (Unrested/Neutral/Rested). Code was already correct. |
| 2 | 3 missing sleep fields (Time to Fall Asleep, Times Awakened, Time Awake During Night) | BUILD — marked DECIDED/PENDING IMPLEMENTATION. Requires schema migration on sleep_entries. Do not build until a dedicated sleep enhancement phase is planned. |
| 3 | Anchor events — expand to 8 named events | BUILD — wake(0), breakfast(1), morning(2), lunch(3), afternoon(4), dinner(5), evening(6), bedtime(7). Breaking enum change: requires migration remapping existing DB rows (lunch 2→3, dinner 3→5, bed 4→7). Code changes planned for next implementation phase. Spec updated. Deviation #5 retired. |
| 4 | PIN length | 6 DIGITS FIXED — 58_SETTINGS_SCREENS.md is authoritative. 38_UI_FIELD_SPECIFICATIONS.md updated to match. |

### Spec Files Changed

| File | Changes Made |
|------|-------------|
| DECISIONS.md | Added 4 new decision entries (2026-02-25) |
| 10_DATABASE_SCHEMA.md | Updated schema version to v16; Section 2.7 expanded with 8 entity exemptions; user_accounts/profile_access/device_registrations marked NOT YET IMPLEMENTED; bowel_urine_logs marked DEPRECATED; notification_schedules marked REPLACED; supplements table: added 5 Phase 15a columns; food_items table: updated type enum (simple/composed/packaged), added 7 Phase 15a columns; food_logs: added violation_flag; diet_violations: corrected schema to match actual implementation; added Section 16 documenting all 14 new tables from v12–v16; updated Document Control |
| 22_API_CONTRACTS.md | FoodItemType updated to 3 values (simple/composed/packaged); FoodItem entity: added Phase 15a fields (sodiumMg, barcode, brand, ingredientsText, openFoodFactsId, importSource, imageUrl); FoodLog entity: added violationFlag; Section 8 marked OBSOLETE (pre-Phase 13 design); Section 12.4 quiet hours marked DROPPED |
| 38_UI_FIELD_SPECIFICATIONS.md | Section 5.2 food type: added Packaged + type definitions; Section 6.1 urine color: added Brown and Red; Section 7.1 sleep: WakingFeeling→3 options; deferred note added for 3 missing sleep fields; Section 12.1: replaced obsolete notification toggles with Phase 13 anchor events design; Section 13.1 units: replaced Metric/Imperial toggle with Phase 14 individual toggles; Section 13.4 security: updated Lock Method to separate boolean fields, PIN to 6 digits, Lock Timeout to 5 options; Sections 15.1/15.2 supplement timing: updated to 8 anchor events |
| 56_GUEST_PROFILE_ACCESS.md | Status: COMPLETE — Phase 12 (2026-02-24) |
| 57_NOTIFICATION_SYSTEM.md | Status: COMPLETE — Phase 13 (2026-02-24); anchor events table expanded to 8 events with enum values and defaults; added migration warning |
| 58_SETTINGS_SCREENS.md | Status: COMPLETE — Phase 14 (2026-02-24); Section 1 anchor event list updated to 8 fixed named events, custom events removed |
| 59_DIET_TRACKING.md | Status: COMPLETE — Phase 15b (2026-02-24); dialog title corrected to "Diet Alert"; preset diet list replaced with canonical 20-value list from 41_DIET_SYSTEM.md |
| 59a_FOOD_DATABASE_EXTENSION.md | Status: COMPLETE — Phase 15a (2026-02-24) |
| 60_SUPPLEMENT_EXTENSION.md | Status: COMPLETE — Phase 15a (2026-02-24) |
| 61_HEALTH_PLATFORM_INTEGRATION.md | Status: PARTIAL — Phase 16a done; imported_vitals schema corrected to use INTEGER types and epoch ms timestamps |
| 35_QR_DEVICE_PAIRING.md | Marked SUPERSEDED by 56_GUEST_PROFILE_ACCESS.md; archived notice added |
| 53_SPEC_CLARIFICATIONS.md | All 9 AWAITING_CLARIFICATION items marked RESOLVED with resolution notes |

### Current State
- Open decisions: 0
- Unresolved spec findings: 0
- Tests: 3,142 passing
- Analyzer: Clean
- Source code changes: None (spec-only session)
- Next: Awaiting Reid go-ahead for Phase 16b

---

## [2026-02-25 00:10 MST] — Architect Briefing Sync Infrastructure Upgrade

The Architect Briefing is maintained in two places:

| Location | Purpose | How Updated |
|----------|---------|-------------|
| `ARCHITECT_BRIEFING.md` (this file) | Source of truth, committed to git | Manually by Claude Code at end of each phase/review |
| Google Doc ID `1dCOexVrJxnJX4vC8ItvL_twSvqBLC2Ro8oUkcG3m-8w` | Claude.ai reads this directly via Drive MCP | Automatically by Stop hook; also updated via MCP during session |

### Stop Hook

A Claude Code Stop hook fires at the end of every session and pushes ARCHITECT_BRIEFING.md to the Google Doc if the file was modified.

**Hook entry in `~/.claude/settings.json`:**
```json
"hooks": {
  "Stop": [{ "matcher": "", "hooks": [{ "type": "command",
    "command": "/Users/reidbarcus/Development/Shadow/scripts/sync_briefing.sh" }] }]
}
```

**Scripts:**
- `scripts/sync_briefing.sh` — Bash wrapper: compares MD5 hash against last push, auto-increments the `# Briefing Version:` stamp (NNN counter) before pushing, logs result with version number
- `scripts/push_briefing_to_gdrive.py` — Python: refreshes OAuth token from `~/.config/google-drive-mcp/`, stamps `# Last Updated:` with current local time, calls Google Docs API `batchUpdate` to replace doc content

**Log file:** `scripts/sync_briefing.log`

**OAuth credentials used:** `~/.config/google-drive-mcp/tokens.json` + `~/.config/gcp-oauth.keys.json` (same credentials as the Google Drive MCP — no separate auth setup needed)

**Version stamp format:** `# Briefing Version: YYYYMMDD-NNN` — NNN increments with each push on the same day; resets to 001 on a new day.

---

## [2026-02-24 23:52 MST] — Test: BOONDOGGLE Timestamp Verification

This section marks a deliberate test push confirming the Claude Code → Google Drive → Claude.ai communication channel is live and working. The push script, Stop hook, and Google Doc were all verified end-to-end at this timestamp.

# ████████████████████████████████████████████████████████████████
# BOONDOGGLE — TEST PUSH TIMESTAMP: 2026-02-24 23:52:21 MST
# ████████████████████████████████████████████████████████████████

---

## [2026-02-24 22:56 MST] — Spec Review: Full Converged Pass (Phases 1–16a)

**Completed:** 2026-02-24. Iterative read-only pass across all spec documents.
**Total findings: 48** (4 DECISION REQUIRED, 9 MISSING, 35 STALE)
**Convergence:** Three passes — Pass 2 found 17 new items, Pass 3 found 3 more. Final pass found zero new items.

> **ALL 48 FINDINGS RESOLVED — 2026-02-25.** See the [2026-02-25 09:30 MST] section at the top for the complete summary of changes made to each spec file. The individual findings below are retained for historical reference.

Legend: **STALE** = spec needs updating, code is correct. **MISSING** = feature built but spec has no entry (or planned but unbuilt). **DECISION** = product call needed from Reid.

---

### 10_DATABASE_SCHEMA.md

**MISSING** — `diet_rules` and `diet_exceptions` tables have no definition section. Both are fully implemented (v15). DietRule intentionally omits clientId/syncMetadata (sub-entity exemption — needs adding to Section 2.7).

**MISSING** — 11 implemented tables have no spec section: `guest_invites` (v11), `anchor_event_times` (v12), `notification_category_settings` (v12), `user_settings` (v13), `food_item_components` (v14), `food_barcode_cache` (v14), `supplement_label_photos` (v14), `supplement_barcode_cache` (v14), `imported_vitals` (v16), `health_sync_settings` (v16), `health_sync_status` (v16).

**MISSING** — Intelligence system tables defined in spec (v6→v7) never built: `patterns`, `trigger_correlations`, `health_insights`, `predictive_alerts`, `ml_models`, `prediction_feedback`. Future phase. Spec should mark "Not yet implemented."

**MISSING** — HIPAA and wearable tables defined in spec (v6→v7) never built: `hipaa_authorizations`, `profile_access_logs`, `wearable_connections`, `imported_data_log`, `fhir_exports`. Future phase.

**STALE** — Schema version header says v11; code is at v16. Migration blocks v12–v16 missing from spec entirely.

**STALE** — Supplements table (Section 4.1) missing 5 Phase 15a columns: `custom_dosage_unit`, `source`, `price_paid`, `barcode`, `import_source`.

**STALE** — Food items table (Section 5.1) missing 7 Phase 15a columns: `sodium_mg`, `barcode`, `brand`, `ingredients_text`, `open_food_facts_id`, `import_source`, `image_url`. Also: type enum shows simple/complex; code has simple/composed/packaged.

**STALE** — Food logs table (Section 5.2) missing `violation_flag` column added in v15.

**STALE** — Diet violations table schema in spec is completely wrong. Spec: `food_log_id NOT NULL`, `rule_type`, `severity`, `message`. Code: `food_log_id NULLABLE`, `rule_id`, `food_name`, `rule_description`, `was_overridden`. Code is correct per 59_DIET_TRACKING.md.

**STALE** — `imported_vitals` schema stub in 61_HEALTH_PLATFORM_INTEGRATION.md uses TEXT types and ISO8601 strings. Code correctly uses INTEGER (enum values and epoch ms). Stub needs full replacement.

**STALE** — Spec defines 7 tables never built; mark as "not yet implemented": `user_accounts`, `profile_access`, `device_registrations`, `documents`, `condition_categories`, `bowel_urine_logs` (deprecated, replaced by `fluids_entries`), `notification_schedules` (replaced by `anchor_event_times` + `notification_category_settings` in Phase 13).

---

### 22_API_CONTRACTS.md

**MISSING** — No entity contracts for Phase 13–16 entities: AnchorEventTime, NotificationCategorySettings, ScheduledNotification, UserSettings, FoodItemComponent, SupplementLabelPhoto, Diet, DietRule, DietException, FastingSession, DietViolation, ImportedVital, HealthSyncSettings, HealthSyncStatus.

**MISSING** — Section 12.4 defines `QueuedNotification` and `QuietHoursQueueService` for quiet hours notification queuing. No implementation exists anywhere in the codebase. Either deferred or dropped.

**STALE** — Section 8 (Notification Schedule Contracts) defines `NotificationSchedule` entity and `NotificationScheduleRepository` using the old pre-Phase 13 design. Entire section is obsolete — replaced by Phase 13's AnchorEventTime + NotificationCategorySettings + ScheduledNotification (non-persisted value object).

**STALE** — Section 10.11 (FoodItem): `FoodItemType` shows only `simple(0)/complex(1)`. Code has `simple(0)/composed(1)/packaged(2)`. Also missing all Phase 15a fields: `sodiumMg`, `barcode`, `brand`, `ingredientsText`, `openFoodFactsId`, `importSource`, `imageUrl`.

**STALE** — Section 10.12 (FoodLog): missing `violationFlag` field added in Phase 15b.

**STALE** — Section 4.5.2: `CreateSupplementInput` class definition omits `customDosageUnit` but the example implementation code in the same section uses `input.customDosageUnit`. Field exists in code. Internal inconsistency in the spec's own example.

**STALE** — `GuestInvite` entity (Section 18.1) missing `clientId` and `syncMetadata`. Code matches spec — both intentionally omit these. Neither is in the exemptions list in 10_DATABASE_SCHEMA.md Section 2.7. Should be added.

**STALE** — Nine spec clarification items from `53_SPEC_CLARIFICATIONS.md` (filed 2026-02-09) remain `AWAITING_CLARIFICATION`. All have clear recommended resolutions that don't require Reid's input: ActivityLog field defaults, IntakeLog table definition, Syncable declarations, ActivityRepository archive methods, CreateConditionInput triggers, DatabaseError id param, FoodItem serving_size storage type, Freezed annotation style, and 10 minor getter/method additions.

**STALE** — Section 12.3: `complianceImpactPercent` typed as `double` in spec formula; code uses `int` for `complianceImpact`. Minor type mismatch; functionally equivalent.

**CONFIRMED CORRECT** — All core enums in Section 3.3 match code exactly. Result type, AppError subclasses, ValidationRules all match spec exactly.

---

### 38_UI_FIELD_SPECIFICATIONS.md

**DECISION REQUIRED (1 of 4)** — Section 7.1 Sleep Entry: Waking Feeling shows 4 options (Groggy/Neutral/Rested/Energized). Code `WakingFeeling` enum has 3: `unrested(0)/neutral(1)/rested(2)`. "Energized" is absent. Add the fourth value or drop it?

**DECISION REQUIRED (2 of 4)** — Section 7.1 Sleep Entry: Three fields exist in UI spec but have no database columns: "Time to Fall Asleep," "Times Awakened," "Time Awake During Night." Were these intentionally deferred or should they be built?

**MISSING** — No field specs for Phase 15a–16a screens: barcode scan flows (food and supplement), diet selection, custom diet builder, fasting timer, compliance dashboard, health platform sync settings.

**MISSING** — Section 6.1 Fluids: "Urgency | Slider | 1-5 scale" for urine exists in spec but no column in `fluids_entries` table or entity. Never implemented.

**STALE** — Section 5.2 (Add/Edit Food Item): Type field shows Simple/Composed only. Phase 15a added Packaged as a third type.

**STALE** — Section 6.1 Fluids: Urine Color list shows 6 options. Code `UrineCondition` enum has 8 (also includes `brown(5)` and `red(6)`). Spec missing two options.

**STALE** — Section 12.1 (Notification Preferences): Describes the old pre-Phase 13 toggle-based notification system with quiet hours. Replaced entirely by Phase 13's anchor events and category scheduling. Section is obsolete.

**STALE** — Section 13.1 (Units Settings): Shows a single Metric/Imperial toggle. Phase 14 implemented individual toggles per unit type (weight, food weight, fluids, temperature, energy, macros).

**STALE** — Section 13.4 (Security Settings): Lock Timeout shows 4 options; code and `58_SETTINGS_SCREENS.md` both have 5 (adds "1 hour"). Also: Lock Method shown as single dropdown; code uses separate boolean fields.

**STALE** — Sections 15.1/15.2 (Supplement Timing): Still references "Morning" and "Evening" as anchor event options. Code has: wake, breakfast, lunch, dinner, bed — no Morning or Evening. Known deviation #5 from DECISIONS.md.

---

### 56_GUEST_PROFILE_ACCESS.md

**STALE** — Status says "PLANNED — Not yet implemented." Phase 12 (a, b, c, d) is complete.

---

### 57_NOTIFICATION_SYSTEM.md

**STALE** — Status says "PLANNED — Not yet implemented." Phase 13 (a through e) is complete.

---

### 58_SETTINGS_SCREENS.md

**DECISION REQUIRED (3 of 4)** — Section 1: Lists anchor events as "Wake, Breakfast, Lunch, Dinner, Bedtime, Custom 1, Custom 2, Custom 3." Code and `57_NOTIFICATION_SYSTEM.md` only support 5 fixed events. Should custom anchor events be built or dropped?

**DECISION REQUIRED (4 of 4)** — PIN length: `58_SETTINGS_SCREENS.md` says "6-digit PIN" in the setup flow. `38_UI_FIELD_SPECIFICATIONS.md` says "4-6 digits." Two spec docs contradict each other. Which is authoritative?

**STALE** — Status says "PLANNED — Not yet implemented." Phase 14 is complete.

---

### 59_DIET_TRACKING.md

**STALE** — Status says "PLANNED — Not yet implemented." Phase 15b is complete.

**STALE** — Screen 5 Violation Alert: spec says title is "Diet Rule Violation." Code's `DietViolationDialog` uses "Diet Alert."

**STALE** — Screen 1 preset diet list includes Carnivore and DASH. Neither is in the `DietPresetType` enum or in `41_DIET_SYSTEM.md` (canonical source with 20 presets). The 59 spec's UI list needs to match 41.

---

### 59a_FOOD_DATABASE_EXTENSION.md

**STALE** — Status says "PLANNED — Not yet implemented." Phase 15a is complete.

---

### 60_SUPPLEMENT_EXTENSION.md

**STALE** — Status says "PLANNED — Not yet implemented." Phase 15a supplement extension is complete.

---

### 61_HEALTH_PLATFORM_INTEGRATION.md

**STALE** — Status says "PLANNED — Not yet implemented." Phase 16a complete. Correct status: PARTIAL — Phase 16a done, Phase 16b–16d pending.

**STALE** — Data Storage section shows `imported_vitals` with TEXT types and ISO8601 timestamps. Code uses INTEGER throughout. Entire table definition needs replacement.

---

### 35_QR_DEVICE_PAIRING.md

**STALE** — Entire document describes a multi-device sync pairing system (QR codes + Diffie-Hellman key exchange) that was never implemented and was superseded by the Guest Profile Access system (`56_GUEST_PROFILE_ACCESS.md`). Should be marked "SUPERSEDED by 56_GUEST_PROFILE_ACCESS.md" or archived.

---

### 53_SPEC_CLARIFICATIONS.md

**STALE** — 9 items filed 2026-02-09 remain `AWAITING_CLARIFICATION` with no resolution action. All have recommended resolutions that don't require Reid's input. Should be marked RESOLVED and closed.

---

### Other Documents (confirmed correct)

- `37_NOTIFICATIONS.md` — Notification type enum confirmed matches code exactly. PASS.
- `41_DIET_SYSTEM.md` — Authoritative preset diet list (20 values) confirmed matches `DietPresetType` enum exactly. PASS.
- `02_CODING_STANDARDS.md` — Architecture patterns correct throughout. PASS.

---

### Coding Standards Deviations — Entities Needing Exemption Documentation

All intentional. All need adding to `10_DATABASE_SCHEMA.md` Section 2.7 (Sync Metadata Exemptions).

| Entity | Missing Fields | Reason |
|--------|---------------|--------|
| `GuestInvite` | clientId, syncMetadata | Ephemeral access token; not independently synced |
| `DietRule` | clientId, profileId, syncMetadata | Sub-entity of Diet; synced/deleted with parent |
| `DietException` | clientId, profileId, syncMetadata | Same as DietRule |
| `AnchorEventTime` | clientId, profileId | Global app config; not profile-specific; local-only |
| `NotificationCategorySettings` | clientId, profileId, syncMetadata | Global app config; local-only |
| `UserSettings` | clientId, profileId, syncMetadata | Device-local preferences; never synced |
| `HealthSyncSettings` | clientId, syncMetadata | Device-local health sync config |
| `HealthSyncStatus` | clientId, profileId, syncMetadata | Device-local tracking state |

---

### Summary Count

| Category | Count |
|----------|-------|
| DECISION REQUIRED | 4 |
| MISSING | 9 |
| STALE | 35 |
| PASS (confirmed correct) | 5 areas |
| **Total findings** | **48** |

---

### The 4 Open Decisions

**Decision 1** — Sleep "Waking Feeling": 3 options (Unrested/Neutral/Rested) in code vs 4 (adding Energized) in spec. Add Energized or drop it?

**Decision 2** — Sleep missing fields: "Time to Fall Asleep," "Times Awakened," "Time Awake During Night" are in the UI spec but have no database columns. Intentionally deferred or should they be built?

**Decision 3** — Custom anchor events: `58_SETTINGS_SCREENS.md` describes Custom 1/2/3 user-defined anchor events. Code and `57_NOTIFICATION_SYSTEM.md` support only 5 fixed events. Build custom events or drop from spec?

**Decision 4** — PIN length: `58_SETTINGS_SCREENS.md` says 6 digits; `38_UI_FIELD_SPECIFICATIONS.md` says 4-6 digits. Which is correct?

---

## [2026-02-24 22:00 MST (estimated)] — Project Vitals Snapshot

| Field | Value |
|-------|-------|
| **Schema Version** | v16 |
| **Test Count** | 3,160 passing |
| **Flutter SDK** | ^3.10.4 |
| **Dart SDK** | ^3.10.4 |
| **Last Completed Phase** | Phase 16b: health plugin + SyncFromHealthPlatformUseCase (2026-02-25) |
| **Next** | Phase 16c: HealthPlatformServiceImpl + Health Sync Settings UI |
| **Analyzer Status** | Clean (0 issues) |
| **Open Decisions** | 0 — all resolved 2026-02-25 |

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

### Code TODOs (active in source)

| File | TODO | Impact |
|------|------|--------|
| `food_item_repository_impl.dart` | Category filtering not implemented (awaits FoodItemCategory junction table) | Food list cannot filter by category |
| `supplement_list_screen.dart` | IntakeLogScreen navigation not wired | Tap on supplement doesn't open intake log with pre-filled supplement |
| `supplement_list_screen.dart` | Filter switches not wired to provider state | Active/archived filter UI exists but does nothing |
| `food_item_list_screen.dart` | SearchFoodItemsUseCase not wired | Search icon shown but search does nothing |
| `sleep_entry_list_screen.dart` | Date range filter not implemented | No date filtering on sleep history |
| `condition_edit_screen.dart` | Camera/photo picker not integrated | Condition photo capture is a placeholder |
| `condition_edit_screen.dart` | Update use case not called (create-only) | Editing a condition always creates a new record |

### Deferred / Not Yet Started

| Feature | Status | Depends On |
|---------|--------|-----------|
| Phase 16c: HealthPlatformServiceImpl | Not started — needs concrete impl of HealthPlatformService wiring health plugin | Phase 16b (done) |
| Phase 16c: Health Sync Settings UI | Not started — HealthSyncSettingsScreen per spec | Phase 16b (done) |
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

**Note:** Phase 15b (Diet Tracking screens and core use cases) was implemented between 15a and 15b-4 — the test count jump reflects that work.
