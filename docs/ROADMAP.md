# Shadow — Project Roadmap

**Document:** ROADMAP.md
**Last Updated:** 2026-03-06
**Maintained by:** The Architect (claude.ai)
**Purpose:** Complete build history, current state, and forward plan for Shadow
and the Ember platform. Updated at the close of each major phase or work cycle.

---

## How to Read This Document

Phases are listed chronologically. Each entry shows what was built, why, and the
test count at completion. The test count is the cumulative passing test suite —
it grows with each phase and never regresses.

**Status indicators:**
- ✅ Complete — committed, tested, analyzer clean
- 🔄 In Progress — currently being built
- 📋 Planned — sequenced and specced, not yet started
- 💡 Future — identified, not yet specced

---

## Current State

| Metric | Value |
|--------|-------|
| Tests passing | 3,611 |
| Schema version | v19 |
| Analyzer | Clean |
| Last commit | d622d97 |
| Status | IDLE — Awaiting next phase |

---

## Foundation — Pre-Phase Architecture (January 2026)

Before any numbered phases, the full application architecture was established.
These decisions are the bones of everything that followed.

**Technology decisions:**
- Flutter/Dart for iOS + Android cross-platform development
- Drift (type-safe SQLite wrapper) for local storage with schema migrations
- SQLCipher for AES-256 database encryption
- Riverpod with code generation for state management
- Freezed for immutable entities with generated serialization
- Clean architecture: Domain → Data → Presentation, strictly enforced

**Domain layer built:**
14 entities (Supplement, Condition, ConditionLog, FlareUp, FoodItem, FoodLog,
SleepEntry, FluidsEntry, Activity, ActivityLog, PhotoArea, PhotoEntry, JournalEntry,
IntakeLog), 14 repositories (abstract interfaces), 51 use cases.
Tests at completion: ~500

**Data layer built:**
Drift table definitions, DAOs, repository implementations, migration runner.
Tests at completion: ~800

**Providers built:**
Riverpod providers for all 51 use cases and 14 repositories.
Tests at completion: ~800

**Core widget library built:**
ShadowButton, ShadowTextField, ShadowCard, ShadowDialog, ShadowStatus.
Tests at completion: ~900

**Specialized widget library built:**
ShadowPicker, ShadowChart, ShadowImage, ShadowInput, ShadowBadge.
Tests at completion: ~900

**Reference screen pattern established:**
SupplementListScreen built as the canonical reference for all list screens.
23 tests. This screen's pattern was replicated across all subsequent list screens.
Tests at completion: ~923

**App infrastructure:**
Bootstrap (initialization, theme, routing), Home screen (9-tab navigation with
profile context), Profile management screens (Welcome, list, add/edit),
Cloud sync UI shells (setup + settings screen placeholders).
Tests at completion: ~970

---

## ✅ Phase 1 — Google Drive Authentication (February 2026)

Implemented the full Google Drive authentication flow: OAuth 2.0 with PKCE,
token storage in platform Keychain/Keystore, session persistence across app restarts,
and the CloudStorageProvider abstract interface that both Google Drive and iCloud
implement. 86 unit tests.

Tests at completion: ~1,056

---

## ✅ Phase 2 — Cloud Sync Upload (February 2026)

Implemented encrypt-then-upload: every dirty database record is serialized to JSON,
encrypted with AES-256-GCM, and pushed to a structured folder in Google Drive.
The sync metadata system (syncIsDirty, syncVersion, syncDeviceId, syncLastSyncedAt)
was established here and applied to all 14 entities. 29 tests.

Tests at completion: ~1,085

---

## ✅ Phase 3 — Cloud Sync Download (February 2026)

Implemented pull-decrypt-merge: downloading remote records, decrypting them,
and merging with local state. The incremental sync pattern (only changed records
since last sync) was established. 15 tests.

Tests at completion: ~1,100

---

## ✅ Phase 4 — Conflict Handling (February 2026)

The largest infrastructure phase. Built the full conflict detection and resolution
system: detecting divergent changes on multiple devices, storing conflict records,
presenting them in a resolution UI, and supporting three strategies (keep local,
keep remote, keep both). Bidirectional sync proven end-to-end. Schema v4 through v9
iterations. Significant jump in test count.

Tests at completion: 2,192

---

## ✅ Phase 5 — SupplementEditScreen (February 2026)

Built the full supplement editing form: custom dosage unit input, ingredient
management, full schedule configuration (frequency, anchor events, timing, offset,
specific time, start/end dates). Established the edit screen pattern used by all
subsequent feature edit screens. 79 tests.

Tests at completion: 2,271

---

## ✅ Phases 6–9 — Screen Completions (February 2026)

Brought all remaining list and edit screens to the reference test level established
by SupplementListScreen. Each screen received a minimum test set verifying loading
state, empty state, populated state, navigation, and error handling.

- Phase 6: ConditionListScreen (24 tests)
- Phase 7: FoodListScreen (26 tests)
- Phase 8: SleepListScreen (27 tests)
- Phase 9: 16 remaining screens verified (+22 tests)

Tests at completion: 2,370

---

## ✅ Phase 10 — Profile Entity (February 2026)

Built the domain Profile entity using Freezed code generation, with all fields
required for multi-device sync (ownerId, deviceId, syncMetadata). 26 tests.

Tests at completion: 2,396

---

## ✅ Phase 11 — Profile Repository and Database (February 2026)

Wired the Profile entity into Drift (table definition, DAO, repository
implementation). Schema v10. The database now owns profile storage, replacing
the interim SharedPreferences approach used during early development. 44 tests.

Tests at completion: 2,440

---

## ✅ Phase 12 — Guest Invite System (February 2026)

Built the complete profile-sharing infrastructure across four sub-phases:

- **12a:** GuestInvite entity, DAO, repository, 5 use cases, schema v11. 65 tests.
- **12b:** GuestMode provider, QR code generation screen, invite management list screen. 32 tests.
- **12c:** Deep link handling, token validation, one-device hardware lock, revoke screen.
  Key decision: each QR code can only be active on one device. Scanning a code on a
  second device is hard-blocked (not warned). Host receives immediate notification. 45 tests.
- **12d:** End-to-end integration test pass, guest disclaimer verification. 24 tests.

Tests at completion: 2,606

---

## ✅ Phase 13 — Notification System (February 2026)

Built the full active notification system across five sub-phases:

- **13a:** AnchorEventTime + NotificationCategorySettings entities, schema v12. 86 tests.
- **13b:** ScheduledNotification domain type, NotificationScheduler abstract port,
  ScheduleService orchestration. Same abstract-port pattern as HealthPlatformService —
  keeps domain layer fully testable without a real device. 43 tests.
- **13c:** 8 modal quick-entry bottom sheets (one per trackable category) triggered
  by notification taps. Users log data in one tap without navigating the app. 82 tests.
- **13d:** flutter_local_notifications platform wiring, permissions, deep link plumbing.
- **13e:** Notification Settings UI — per-category enable/disable, scheduling mode
  selection, anchor event configuration. 22 tests.

Key architecture: notifications are local-only, no server required, no subscription.
No health data appears in notification content.

Tests at completion: 2,839

---

## ✅ Phase 14 — Settings Screens (February 2026)

Built the full Settings hub and all settings screens:
- Units settings: weight, food weight, fluids, temperature, energy, macro display
- Security settings: PIN setup/change, biometric authentication (Face ID/fingerprint),
  auto-lock timeout, app switcher privacy mode
- Schema v13

22 tests.

Tests at completion: 2,861

---

## ✅ Phase 15a — Food and Supplement Extensions (February 2026)

Extended both food and supplement data models significantly:
- FoodItem: added 7 nutrition fields (calories, protein, carbs, fiber, sugar, fat, sodium),
  serving size, serving unit, brand, barcode
- FoodItemComponent: ingredient sub-items for composed foods
- Barcode cache table: local lookup cache for scanned products
- Open Food Facts API integration: barcode scan → auto-populate nutrition data
- NIH Dietary Supplement Label Database integration: supplement barcode lookup
- AnthropicApiClient: Claude API integration for AI-powered supplement label photo scanning
- SupplementLabelPhoto entity: stores scanned label photos with link to supplement
- Schema v14

Tests at completion: 2,771 (note: slight regression from prior count reflects test suite
reorganization during this phase; no tests were removed, new counts are accurate)

---

## ✅ Phase 15b — Diet Tracking (February 2026)

Built the complete diet tracking system:
- 8 diet types: standard, Mediterranean, keto, paleo, vegan, vegetarian, low-FODMAP,
  and custom with user-defined description
- DietComplianceService: real-time rule evaluation against logged food entries
- Fasting timer: active session with elapsed display and manual end
- Violation dialog: immediate in-app alert when a logged food violates the active diet
- DietDashboard: compliance score, streak display, violation history
- End-to-end integration: FoodLogScreen checks compliance on every food log entry

Tests at completion: 2,817

---

## ✅ Phase 16 — Health Platform Integration (February 2026)

Built the full Apple HealthKit (iOS) and Google Health Connect (Android) import
pipeline across three sub-phases:

- **16a:** ImportedVital + HealthSyncSettings entities, DAOs, repositories, 3 use cases.
  schema v16 (skipped v15 intentionally — migration sequencing). 83 tests.
- **16b:** health plugin integration, iOS/Android platform configuration (entitlements,
  permissions), HealthPlatformService abstract port in domain layer,
  SyncFromHealthPlatformUseCase. 18 tests.
- **16c:** HealthPlatformServiceImpl (concrete adapter — the only file that imports
  package:health/health.dart), HealthSyncSettingsScreen (4-section UI: platform status,
  sync controls, date range, per-type toggles). 39 tests.

Supported data types: steps, heart rate, resting heart rate, weight, blood pressure,
blood oxygen, sleep, and active calories. Import is manual and user-controlled.
Physical device testing deferred pending access to test devices.

Tests at completion: 3,181

---

## ✅ Phase 17 — First Code Audit (February 2026)

A planned read-only audit pass across all lib/ and test/ files before continuing
feature development. Produced 18 findings across data integrity, behavior, UI wiring,
and deferred decisions.

- **17a:** Read-only audit, findings documented, 5 product decisions presented to Reid.
- **17b:** All 18 findings resolved — 2 data bugs (A1–A2), 2 behavior bugs (B1–B2),
  4 UI wiring issues (C1–C4), 3 deferred decisions implemented (D1–D3). 29 tests.

Tests at completion: 3,210

---

## ✅ Phase 18a — Conditions Tab Navigation (February 2026)

Wired all navigation paths in the Conditions tab that previously had TODO placeholders.
Conditions, condition logs, and flare-ups are now fully navigable from the tab.

Tests: incremental

---

## ✅ Phase 18b — FlareUpListScreen + ReportFlareUpScreen (February 2026)

Built FlareUpListScreen showing all flare-ups for the current profile with status
badges (active/resolved) and date display. Built ReportFlareUpScreen — the modal
for creating and editing flare-up records. The FlareUp entity and all its use cases
had been built in the foundation; these screens made the feature accessible to users
for the first time.

Tests: incremental

---

## ✅ Phase 18c — "Join Existing Account" QR Wiring (February 2026)

Wired the "Join Existing Account" button on WelcomeScreen to the QR code scanner
(Phase 12c deep link handler). Removed the "coming soon" placeholder. Users can
now accept guest profile invites from the initial welcome screen without needing
to navigate into the app first.

Tests: incremental

---

## ✅ Phase 20 — Photo Picker Wiring (February 2026)

Wired camera and photo library picker into three screens that had TODO placeholders:
ConditionEditScreen (baseline condition photo), ConditionLogScreen (log photo),
and FluidsEntryScreen (bowel photo). Built PhotoPickerUtils as a shared helper.
14 tests.

Tests at completion: 3,270

---

## ✅ Phase 21 — Sleep Fields (February 2026)

Added three clinical sleep quality fields that were specced but not yet built:
Time to Fall Asleep, Times Awakened, and Time Awake During Night. Schema v18
migration added three new columns to sleep_entries. Fields wired end-to-end
through entity, DAO, repository, use cases, and SleepEntryScreen.

Tests: incremental

---

## ✅ Phase 22 — iCloud Sync (February/March 2026)

Built complete iCloud/CloudKit sync as a second cloud provider alongside Google Drive.
ICloudProvider implements CloudStorageProvider (10 methods) using the icloud_storage
package with file-based storage mirroring the Google Drive folder structure.
Container ID: iCloud.com.bluedomecolorado.shadowApp. Encryption: same AES-256-GCM
pipeline as Google Drive — all data is encrypted before upload.

Platform: iOS and macOS only. iCloud button hidden on Android.
Xcode entitlements configured for all three build configurations.
Provider selection persisted in FlutterSecureStorage. Provider switching requires
app restart (hot-switching deferred to a future phase).

Tests: incremental. Completed: Phases 31a–31b in original numbering.

---

## ✅ Phase 23 — Conflict Resolution UI (February 2026)

Built the ConflictResolutionScreen — the full UI for reviewing and resolving sync
conflicts. Users see a card per conflict with the conflicting values from each device,
and three resolution buttons (keep local, keep remote, keep both). Connected the
conflict count in CloudSyncSettingsScreen to navigate to the resolution screen.
Added getUnresolvedConflicts() to the SyncService interface and implementation.
10 widget tests.

Tests: incremental

---

## ✅ Phase 24 — Reports Foundation (February 2026)

Built the Reports tab foundation: domain types (ActivityCategory, ReferenceCategory,
ReportConfig), ReportQueryService with 11 repository dependencies, DI wiring, and the
ReportsTab screen. Users can open Activity or Reference report configurations, select
categories via checkboxes, set date ranges, and preview live record counts from their
actual data. 21 tests.

Tests at completion: 3,317

---

## ✅ Phase 25 — Report Export: PDF + CSV (February 2026)

Wired full PDF and CSV export into the Reports tab. ReportDataServiceImpl reads from
12 repositories and assembles tabular data. ReportExportServiceImpl writes PDF
(using the pdf package) or CSV files to the temp directory and triggers native share
sheet via share_plus. Spinner shows during export. 22 tests.

Tests at completion: 3,339

---

## ✅ Phase 26 — BBT Chart Screen (February 2026)

Built a dedicated Basal Body Temperature chart screen in the Reports tab. Displays
BBT as a trend line with a menstruation overlay for cycle tracking. Automatically
adjusts to the user's temperature preference (°F or °C). Stats row: average, minimum,
maximum, reading count. Date range controlled by preset chips and month navigation.
28 tests.

Tests at completion: 3,367

---

## ✅ Phase 27 — Diet Adherence Trend Chart (February 2026)

Added 30-day compliance trend line chart to DietDashboardScreen. Added Diet Adherence
as the fourth card in the Reports tab, navigating to the dashboard. 6 tests.

Tests at completion: 3,373

---

## ✅ Phase 28 — Photo Processing Service (February 2026)

Built PhotoProcessingService: compresses photos to ≤500 KB (standard) or ≤1024 KB
(high-detail) using native platform codecs (flutter_image_compress), strips EXIF
metadata automatically, computes SHA-256 hash. Wired into all photo capture paths.

Key decision: Photo encryption deferred — requires key management system not yet
designed. Photos stored as unencrypted .jpg files. Database remains fully encrypted.

5 tests.

Tests at completion: 3,378

---

## ✅ Phase 29 — Correlation View Screen (February 2026)

Built the Correlation View screen in the Reports tab — the most analytically
powerful report in the app. Shows all photos chronologically with a ±48-hour event
window around each photo, pulling from all 8 health event repositories in parallel.
Filters by date preset, event category (7 types), and photo area. Events color-coded
by temporal position relative to the photo. 8 tests.

Tests at completion: 3,386

---

## ✅ Audit Cycle — 10-Pass Comprehensive Audit (February/March 2026)

Before proceeding with remaining features, a planned comprehensive audit was
conducted across the entire codebase. Shadow read every file in lib/ and test/
across 10 passes, plus cross-cutting convergence passes.

| Pass | Focus Area |
|------|-----------|
| 01 | Cloud sync architecture |
| 02 | Sync entity coverage |
| 03 | Soft delete and sync metadata |
| 04 | Domain layer purity |
| 05 | Guest invite security |
| 06 | UI form completeness |
| 07 | Use case validation |
| 08 | Platform compliance (App Store/Play Store) |
| 09 | Performance |
| 10 | Code standards and dead code |
| CA | Profile system end-to-end (convergence) |
| CB | Diet sync + photo system (convergence) |

**Final count: 64 findings — 1 CRITICAL, 13 HIGH, 22 MEDIUM, 28 LOW**

The CRITICAL finding: missing iOS PrivacyInfo.xcprivacy file required for App Store
submission since Spring 2024.

All 64 findings were organized into fix groups and resolved in the sessions below.

---

## ✅ Audit Fix Groups (February/March 2026)

All 64 audit findings resolved across 12 fix groups. Each group was a focused
session with one clear scope. Groups are listed in execution order.

| Group | Scope | Findings |
|-------|-------|---------|
| P | Platform and store blockers | 8 (1 CRITICAL, 4 HIGH) |
| Q | Quick fixes across categories | ~8 |
| N | Null safety and error handling | ~6 |
| U | Use case validation gaps | ~5 |
| T | Test coverage gaps | ~4 |
| PH | Photo system gaps | ~5 |
| F | Form and UI wiring gaps | ~6 |
| X | Supplement label photos + imported vitals | ~4 |
| S | Sync integrity (dirty marks, adapters, softDelete, markSynced) | 5 |
| D | Archive methods syncStatus | ~3 |
| A | Profile architecture (use cases, cascade delete, notifier migration) | 7 |
| B | Cloud sync auth service refactor, domain layer boundaries | ~5 |
| L | Widget component extraction (large files) | 3 |

Group P fixed the App Store blocker first. Groups A and B were last due to
architectural risk. All 64 findings resolved. 3,611 tests passing at close.

---

## 📋 Pre-Launch Work Queue

These items are sequenced and must complete before Shadow ships.

### 1. Fluids Domain Restructuring *(specced — awaiting implementation)*

The current `fluids_entries` table incorrectly groups beverages with bodily outputs
(urine, bowel, menstruation, BBT) and uses a one-row-per-day aggregate model.

Resolution:
- Replace `fluids_entries` with `bodily_output_logs` (one row per event, schema v20)
- Move water and beverages to `food_logs` as FoodItem records with meal_type=beverage
- Rename notification category `fluids` → `bodilyOutputs`
- New use cases: LogBodilyOutputUseCase, GetBodilyOutputsUseCase,
  UpdateBodilyOutputUseCase, DeleteBodilyOutputUseCase

Spec: `docs/planning/FLUIDS_RESTRUCTURING_SPEC.md`
Minimum test count: ~74 new tests

---

### 2. Phase 19 — Conversational Voice Logging *(specced — awaiting Fluids)*

The AI-powered conversational logging assistant. When a notification fires, the user
taps it and the app opens to a voice interface. An AI assistant (Claude API) works
through all pending items in natural conversation, confirms each answer, and writes
confirmed data to the database through the existing use case layer.

Architecture:
- NotificationQueueBuilder → VoiceSessionManager ↔ VoicePipeline → ClaudeApiClient
  → DataExtractor → existing use cases
- On-device STT (speech_to_text) + TTS (flutter_tts) — no third-party voice API
- Rolling 14-day session memory for personalization
- Text input always visible as fallback
- Schema v20 additions: voice_logging_settings, voice_session_history tables
- Session state machine: IDLE → OPENING → GREETING → ASKING ↔ CONFIRMING → LOGGING → CLOSING

Spec: `docs/planning/VOICE_LOGGING_SPEC.md`

---

### 3. Docs Reorganization *(in planning — current session)*

Complete restructuring of the docs/ folder:
- New structure: docs/specs/, docs/standards/, docs/planning/, docs/archive/
- All active specs renumbered into clean sequence
- Standards extracted into docs/standards/ subfolder
- Era 1 and Era 2 historical docs consolidated into single archive files
- All audit history rounds consolidated into AUDIT_HISTORY.md
- VISION.md, PRODUCT_SPEC.md, ROADMAP.md written as new top-level documents

---

### 4. VIDEO_PROCESSING Spec *(to be written)*

Video capture and storage as an extension of the photo pipeline. 10-second clips for
documenting conditions, wounds, skin changes, or any domain where motion matters.
Chunked upload, local compression, storage management, timeline organization.

---

### 5. VitalsLog Entity *(specced as future — needs phase planning)*

A dedicated VitalsLog entity for blood pressure, heart rate, and weight tracked
manually (as opposed to imported from HealthKit). Currently these cannot be logged
as structured data — only as free text. The data model gap is documented in
DECISIONS.md (2026-02-23).

---

### 6. Photo Encryption *(deferred — needs phase planning)*

AES-256-GCM encryption for photo files at rest. Currently deferred because it
requires a key management system (generation, storage, rotation, distribution).
The database is fully encrypted; photos are not. Documented in DECISIONS.md
(2026-02-27).

---

### 7. Supplement Archive Support *(noted gap)*

SupplementDao has no archive() method — Supplements cannot currently be archived
(hidden without deleting). Conditions and FoodItems support archive/unarchive.
This gap was confirmed during the audit and needs a phase before launch.

---

### 8. Physical Device Testing

Several features are code-complete but untested on physical hardware:

- **HealthKit integration** — requires iOS device. Steps and sleep testable on iPhone
  alone. Heart rate and resting heart rate require Apple Watch data in HealthKit.
- **Google Health Connect** — requires Android device with Health Connect installed.
- **iCloud sync** — requires two Apple devices signed into the same iCloud account.
- **Biometric authentication** — Face ID/Touch ID requires physical device.
- **Notifications** — Local notification delivery requires physical device.

---

### 9. App Store and Play Store Preparation

- App icons (all required sizes for iOS and Android)
- Screenshots for App Store Connect and Google Play Console
- Privacy policy (hosted URL)
- App Store Connect listing (description, keywords, category)
- Google Play Console listing
- App Store Review notes (explain health data handling)

---

## 💡 Post-Launch / Future

These items are identified and specced but will not block the initial launch.

### Intelligence System *(spec: docs/specs/27_INTELLIGENCE_SYSTEM.md)*

Pattern detection and trigger correlation. Analyzes historical data to surface
non-obvious relationships — foods that correlate with symptom flare-ups, activities
that improve sleep, environmental factors that precede health events. Requires
meaningful accumulated data history to be useful. Fully domain-agnostic.

### Wearable Device APIs *(spec: docs/specs/28_WEARABLE_INTEGRATION.md)*

Direct API integrations with Fitbit, Garmin, Oura, and WHOOP beyond the HealthKit/
Health Connect import already built. Each requires its own OAuth flow and data mapping.
FHIR R4 export for interoperability with healthcare systems.

### Hot Provider Switching

Switch between Google Drive and iCloud sync without an app restart. Currently requires
app restart. Deferred as acceptable for launch.

### Pagination

Journal entry lists and photo galleries currently load all records into memory.
For long-term users with years of data, cursor-based pagination at the DAO level
will be needed. Documented in AUDIT-09-004.

### Encryption Offload

AES-256 encryption during sync currently runs on the main thread. For large sync
batches after extended offline periods, this could cause brief UI freezes. Should
be moved to a background isolate. Documented in AUDIT-09-003.

---

## Ember Platform Extraction

After Shadow ships, the platform capabilities built here will be extracted into
Ember — a reusable Flutter/Dart template for building new personal tracking apps.

Ember extracts: encrypted storage, cloud sync, security, profile management,
guest access, notifications, voice logging infrastructure, photo and video
processing, health platform import, AI integration, report generation,
barcode scanning, unit localization, and the full standards/specs documentation.

The first planned Ember app: **Seeds** — a personal seed collection tracker for
Reid's collaborator Gurattan, built on a revenue-share model.

See VISION.md for the full Ember platform story.
