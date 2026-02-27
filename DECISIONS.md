# Shadow - Decision Log

**This document records significant decisions made during development, written in plain language so Reid can understand why things were done a certain way.**

---

## How to Read This

Each entry has:
- **Date** - when the decision was made
- **What** - what was decided, in plain language
- **Why** - the reasoning behind it
- **Alternatives** - what else was considered
- **Impact** - what this means for the app or future work

---

## Decisions

### 2026-02-26: Welcome Screen "Join Existing Account" — wire deep link scanner

**What:** The "Join Existing Account" button on WelcomeScreen will launch the QR code scanner (the guest invite flow built in Phase 12c). The "Coming soon" snackbar is removed.

**Why:** Phase 12c built the complete deep link handler and guest mode activation. The Welcome screen button was never wired to it.

**Alternatives:** Keep "coming soon" indefinitely. Rejected — the infrastructure is complete and the path should be accessible to users.

**Impact:** Phase 18c implements the wiring. No new use cases or schema changes required.

---

### 2026-02-26: Flare-Ups button — build FlareUpListScreen and Report Flare-Up flow

**What:** Build FlareUpListScreen showing all flare-ups for the current profile. Wire the "Flare-Ups" button on the Conditions tab to navigate to it. Build a Report Flare-Up modal using the existing LogFlareUpUseCase.

**Why:** The FlareUp entity, repository, and all use cases are fully implemented. Users have no way to access or report flare-ups through the UI. This is core health tracking functionality.

**Alternatives:** None — this is a missing screen for implemented functionality.

**Impact:** Phase 18b implements the screens. No schema changes required.

---

### 2026-02-25: Phase 16b — HealthPlatformService as abstract port (domain layer)

**What:** The health plugin (`health: ^13.3.1`) is never imported directly by domain-layer code. Instead, a `HealthPlatformService` abstract interface lives in the domain layer, and the `health` plugin is only wired in the data layer implementation. The `SyncFromHealthPlatformUseCase` depends only on this abstract port.

**Why:** This is the same pattern used for `NotificationScheduler`. It keeps the domain layer fully testable without a real device — all use case tests run with mock implementations. Platform-specific code (HealthKit vs Health Connect) stays in one place.

**Alternatives considered:** Importing the plugin directly in the use case (simpler but untestable and would break domain layer purity).

**Impact:** A concrete `HealthPlatformServiceImpl` still needs to be written (Phase 16c or later). Until then, the use case is fully tested but no real data flows from the device.

---

### 2026-02-25: device_info_plus upgraded from ^10.1.0 to ^12.3.0

**What:** The `device_info_plus` package was upgraded from `^10.1.0` to `^12.3.0` to satisfy the `health >=13.2.0` dependency requirement.

**Why:** `health >=13.2.0` requires `device_info_plus ^12.1.0`. The existing version constraint (`^10.1.0`) was incompatible, blocking `flutter pub get`. The APIs used by Shadow (`identifierForVendor`, `androidInfo.id`, `systemGUID`, `computerName`) are all stable and unchanged between v10 and v12.

**Alternatives considered:** Pinning to an older health package version — rejected because the latest stable (13.3.1) should be used.

**Impact:** No code changes needed beyond the pubspec version bump. All 3,160 tests still pass.

---

### 2026-02-23: BBT/Vitals quick-entry sheet captures BBT only — no BP, heart rate, or weight

**What:** The BBT/Vitals quick-entry sheet captures basal body temperature (BBT) and optional notes only. It does not include fields for blood pressure, heart rate, or weight.

**Why:** Blood pressure, heart rate, and weight have no dedicated storage in the current data model. The only vitals-related entity is `FluidsEntry`, which has a BBT field. Storing structured health values as free-form text in a notes field creates data that cannot be used in reports, charts, or trends later — which defeats the purpose of tracking.

**Alternatives considered:** Storing BP/HR/weight as formatted text in the notes field (e.g., "BP: 120/80, HR: 72"). Rejected because unstructured data cannot be used for reporting.

**Impact:** A dedicated `VitalsLog` entity is needed before BP, heart rate, and weight can be captured. This is planned as a future phase. Do not use the notes field as a workaround for structured data.

### 2026-02-22: Database migration versioning — profiles table gets v10, food/supplement extensions get v11

**What:** The profiles table migration uses schema v9→v10 (Phase 11). The food database extension (59a) and supplement extension (60) migrations, originally planned as v9→v10, are now v10→v11 (Phase 15a). Both extension specs were updated to reflect this.

**Why:** Phase 11 (profiles table) is being implemented now, before Phase 15a (food/supplement extensions). Since both originally targeted v9→v10, implementing profiles first would cause a version conflict. By giving profiles v10 and bumping the extensions to v11, each migration has its own clean version number.

**Impact:** When Phase 15a is implemented, the migration code should use `if (from < 11)` instead of `if (from < 10)`. The specs (59a_FOOD_DATABASE_EXTENSION.md and 60_SUPPLEMENT_EXTENSION.md) have been updated accordingly.

---

### 2026-02-22: Guest invites have a hard one-device limit

**What:** Each guest invite QR code can only be active on one device at a time. If a second device tries to scan an already-active QR code, the scan is rejected entirely — no access granted. The host receives a notification when this happens ("Someone attempted to access [Profile Name]'s profile from a second device. The attempt was blocked."). The only way to move access to a new device is for the host to revoke the current device first, then generate a new code.

**Why:** This is a deliberate security decision to reduce the risk of accidental profile sharing. If a QR code is accidentally shared with the wrong person (e.g., screenshotted and forwarded), only one device can use it. The host notification provides immediate visibility that something unexpected happened.

**Alternatives:** Could have allowed multiple devices per invite, but this increases the risk of unauthorized access and makes it harder for the host to track who has access. Could have shown a warning instead of blocking, but a hard block is simpler and more secure.

**Impact:** Patients who change phones will need their host to revoke the old device and generate a new QR code. This is a deliberate trade-off — slightly less convenience for significantly better security and control.

---

### 2026-02-22: Only Supplements, Conditions, and Food support archive/unarchive

**What:** Reid confirmed that only three types of health data support archiving (temporarily hiding) and unarchiving (bringing back): Supplements, Conditions, and Food Items. Everything else (Sleep, Activities, Photos, Journal entries) only needs add, edit, and delete.

**Why:** Archiving makes sense for things that are ongoing and might come back — you might stop taking a supplement but start again later, a condition might flare up again, or you might return to eating a food you stopped. Sleep entries and journal entries are one-time records that don't need to be "paused."

**What was fixed:** Conditions had a bug where tapping "Unarchive" actually archived the item again (the code always set archived=true, regardless of which button was pressed). Food Items were missing the Archive/Unarchive menu option entirely — they only had Edit and Delete, where Delete secretly archived instead of truly deleting. Both were fixed to match the working Supplement pattern. The cloud sync metadata is now properly updated when archiving/unarchiving all three types.

**Impact:** Users can now reliably archive and unarchive Supplements, Conditions, and Food Items. The API contracts spec documents which entities support this feature.

---

### 2026-02-21: Anchor Event dropdown uses code definitions, not UI spec wording

**What:** The Supplement Edit Screen's "Anchor Event" dropdown shows: Morning, Breakfast, Lunch, Dinner, Bedtime, and Specific Time. The UI spec (Section 4.1) listed slightly different labels (including "Evening"), but the actual code enum only has 5 values: wake, breakfast, lunch, dinner, bed. We mapped wake→"Morning" and bed→"Bedtime", and handled "Specific Time" as a special option that switches the timing mode.

**Why:** The API Contracts document (22_API_CONTRACTS.md) is the canonical source of truth. The enum has no "Evening" value, so we can't show it. "Specific Time" in the spec is actually a timing type, not an anchor event — it means "take at a specific clock time" rather than "take relative to a meal or activity."

**Alternatives:** Could have added an "Evening" enum value, but that would change the data model without Reid's approval. Followed the rule: no decisions, follow the code specs exactly.

**Impact:** Users see 6 anchor event options (Morning, Breakfast, Lunch, Dinner, Bedtime, Specific Time).

**Follow-up (2026-02-22):** Reid reviewed this and confirmed "Evening" is intentionally excluded. It's too vague and overlaps with existing options like Dinner and Bedtime. The five anchor events are sufficient. No future action needed.

---

### 2026-02-17: Include client_secret in Google sign-in (no proxy server needed)

**What:** Added the Google client_secret to the token exchange requests in the app. The app was failing to sign in because Google was rejecting requests without it. Also updated the OAuth spec (Section 10) which incorrectly claimed the secret wasn't needed.

**Why:** Google's token exchange was returning "client_secret is missing" when the app tried to complete sign-in. Research confirmed that while Google's documentation says the secret is "optional" for Desktop apps, in practice their servers require it. The old app handled this through a separate proxy server, but that approach adds unnecessary complexity — Google themselves say desktop client secrets are "obviously not treated as a secret" since anyone could pull them from the app. No proxy server will be needed for the App Store either, since iOS apps don't use a client_secret at all (Apple verifies the app through the App Store).

**Alternatives:** Could have set up a proxy server like the old app. This would mean running and paying for a separate server permanently — if it goes down, nobody can sign in. For a desktop app where the secret isn't really secret, this adds cost and a point of failure for no real security benefit.

**Impact:** Sign-in should now work. The client_secret is embedded in the app for development with a fallback value. For production builds, it must be provided via a launch flag. The OAuth spec is updated to reflect how Google actually works.

---

### 2026-02-14: Added spec coverage for Phase 1c cloud sync sign-in

**What:** Updated two spec documents to cover the new code from Phase 1c (wiring the Cloud Sync Setup screen to real Google sign-in). Added Sections 16.9–16.12 to the API Contracts spec (covering the auth state, the auth notifier, the email getter, and the provider declarations). Added Section 13.2 to the UI Field Specifications (covering all four visual states of the setup screen: initial, loading, signed-in, and error).

**Why:** Reid requires specs and code to match 100%. The Phase 1c code introduced new components (auth state management, screen state changes) that weren't covered by existing specs. This was caught and Reid directed the spec update.

**Alternatives:** None — spec/code parity is a non-negotiable requirement.

**Impact:** The spec now fully documents the current Cloud Sync Setup screen behavior. The spec also notes that the current auth provider pattern (StateNotifier) is an interim approach that will be replaced with the standard @riverpod annotation pattern when the auth domain layer is built in a future phase.

---

### 2026-02-14: Streamlined the instance coordination system

**What:** Reduced the instruction documents for Claude instances from ~3,500 lines across 10 skill files down to ~400 lines across 7 skill files. Deleted 3 skills that weren't working (manager, team, major-audit). Removed all instructions that told instances to spawn sub-agents.

**Why:** Instances were ignoring protocols because there was too much to read. Two skill files explicitly told instances to spawn agents (which caused the inconsistency problems Reid experienced). Simpler instructions are more likely to be followed.

**Alternatives:** Could have kept all skills and just patched the agent references, but the volume of documentation was itself a problem - instances would skip reading it after context compaction.

**Impact:** Future instances get shorter, clearer instructions. The plan checklist is now embedded directly in CLAUDE.md so instances always know what to work on. Agent spawning is prohibited at every level.

---

### 2026-02-14: Used SharedPreferences for profile storage instead of the encrypted database

**What:** The profile management feature (creating profiles, switching between them) stores profile data in a simple local storage system (SharedPreferences) rather than the encrypted database used for health data.

**Why:** Profiles don't contain sensitive health information - they're just names and settings. Using the simpler storage system avoided needing to build the full database integration for profiles (which is complex and requires code generation). The health data itself is still fully encrypted.

**Alternatives:** Could have built the full domain-layer Profile entity with encrypted database storage. This is still planned for later (item 7 on the plan) and would be needed for cloud sync of profiles.

**Impact:** Profile management works now with minimal code. When cloud sync is built, profiles will need to be migrated to the encrypted database so they can sync across devices.

---

### 2026-02-25: WakingFeeling enum — drop "Energized", keep 3 options

**What:** The WakingFeeling enum stays at 3 values: Unrested, Neutral, Rested. The "Energized" option that appeared in an earlier version of 38_UI_FIELD_SPECIFICATIONS.md is dropped permanently.

**Why:** The code has always had 3 values (unrested/neutral/rested). "Energized" was in the spec but never implemented. The 3-option set covers the meaningful range for sleep quality assessment without over-engineering.

**Impact:** 38_UI_FIELD_SPECIFICATIONS.md Section 7.1 updated to show 3 options. No code change needed — code is already correct.

---

### 2026-02-25: Build the 3 missing sleep fields — decided, pending future phase

**What:** Three UI fields shown in the sleep entry spec have no backing database columns: "Time to Fall Asleep," "Times Awakened," and "Time Awake During Night." Reid has decided these should be built, not dropped.

**Why:** These are standard sleep quality metrics used in clinical sleep assessments. Capturing them would make the sleep log significantly more useful for health analysis.

**Alternatives:** Dropping them permanently (simpler). Rejected — these are valuable data points worth the schema work.

**Impact:** Required a schema migration adding columns to sleep_entries, new entity fields, and UI wiring to the sleep entry screen.

**Resolution (2026-02-27):** Built in Phase 21. Schema v18 added `time_to_fall_asleep` (TEXT), `times_awakened` (INTEGER), and `time_awake_during_night` (TEXT) to `sleep_entries`. All three fields are fully wired end-to-end. See Phase 21 session entry in ARCHITECT_BRIEFING.md.

---

### 2026-02-25: Expand AnchorEventType to 8 fixed named events

**What:** The AnchorEventName enum expands from 5 to 8 values. The new ordered list is: wake(0), breakfast(1), morning(2), lunch(3), afternoon(4), dinner(5), evening(6), bedtime(7). The old "bed" value is renamed to "bedtime." Three new events are added: morning, afternoon, evening. No custom/user-defined anchor events will be supported.

**Why:** The notification system (Phase 13) uses anchor events as trigger points for all health data reminders. The 5-event set was too sparse — it left no good trigger point for mid-morning supplements, afternoon check-ins, or evening routines. The 8-event set covers the full waking day without requiring custom slots.

**Critical impact — breaking enum change:** Existing anchor_event_times rows in the database use integer values 0–4 (wake/breakfast/lunch/dinner/bed). The new enum inserts 3 new values at positions 2, 4, and 6, pushing existing values up. This requires a schema migration to remap existing rows:
- Old bed(4) → New bedtime(7): any row with value=4 must be updated to value=7
- Old lunch(2) → New lunch(3): rows with value=2 must be updated to value=3
- Old dinner(3) → New dinner(5): rows with value=3 must be updated to value=5
- wake(0) and breakfast(1) are unchanged.
This migration must run as part of the next schema version bump. Do not deploy the new enum without the migration.

**Alternatives:** Custom anchor events (rejected — adds complexity with little benefit; 8 named events are sufficient). Appending new values at the end (rejected — "morning" and "afternoon" should appear between existing events in display order).

**Impact:** 57_NOTIFICATION_SYSTEM.md, 58_SETTINGS_SCREENS.md, and 38_UI_FIELD_SPECIFICATIONS.md Sections 15.1/15.2 updated to reflect 8 events. Spec Deviation #5 (no "Evening" variant) is retired. Code changes (enum + migration + any UI using the enum) are planned for the next implementation phase.

---

### 2026-02-25: 6-digit PIN is fixed — 58_SETTINGS_SCREENS.md is authoritative

**What:** The PIN for app lock is exactly 6 digits. No minimum, no range. 58_SETTINGS_SCREENS.md is the authoritative spec. The "4-6 digits" wording in 38_UI_FIELD_SPECIFICATIONS.md Section 13.4 was incorrect and has been updated to say "6 digits."

**Why:** A fixed 6-digit PIN is simpler to implement, easier to communicate to users ("set a 6-digit PIN"), and consistent with iOS/Android standard app lock patterns.

**Impact:** 38_UI_FIELD_SPECIFICATIONS.md Section 13.4 updated. No code change needed — the existing security implementation already enforces 6 digits.

---

### 2026-02-14: Committed working code and deleted broken code from previous instance

**What:** A previous Claude instance had done extensive work (54 files) but never committed any of it and left 6 files in a broken state. We committed the 54 working files and deleted the 6 broken ones.

**Why:** The broken files referenced other files that didn't exist yet, causing errors throughout the project. They were incomplete work from agents that were terminated mid-task.

**Alternatives:** Could have tried to fix the broken files, but they were scaffolding for features not yet needed (Google Drive provider, iCloud provider, domain Profile entity). Better to build them properly when the time comes.

**Impact:** The project is clean and all 1986 tests pass. The features those files were scaffolding for are on the plan as future work items.
