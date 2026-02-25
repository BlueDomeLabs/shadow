# ARCHITECT_BRIEFING.md
# Shadow Health Tracking App — Architect Reference
# Last Updated: Spec Review Pass complete (2026-02-24)
# NOTE: This file will be superseded by a Google Doc once the Drive Docs API is enabled.

This document gives Claude.ai high-level visibility into the Shadow codebase. It is updated at the end of every phase and after spec review passes.

---

## 1. PROJECT VITALS

| Field | Value |
|-------|-------|
| **Schema Version** | v16 |
| **Test Count** | 3,142 passing |
| **Flutter SDK** | ^3.10.4 |
| **Dart SDK** | ^3.10.4 |
| **Last Completed Phase** | Phase 15b-4: Diet tracking integration tests (25 new tests) |
| **Next Awaiting Approval** | Phase 16b: SyncFromHealthPlatformUseCase + iOS/Android platform config |
| **Analyzer Status** | Clean (0 issues) |
| **Open Decisions** | 2 open — see Section 7 (Spec Review) |

---

## 2. ARCHITECTURE OVERVIEW

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
| anchor_event_times | v12 | Notification anchor event times (wake, sleep, etc.) |
| notification_category_settings | v12 | Per-category notification config |
| user_settings | v13 | App-wide settings (units, security, etc.) |
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
| **Health** | getImportedVitals, updateHealthSyncSettings, getLastSyncStatus |
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

## 3. PHASE COMPLETION LOG

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
| Phase 4: Conflict handling | Detection, resolution, bidirectional sync, settings screen (2192 total) | 2192 |
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

**Note:** Phase 15b (Diet Tracking screens and core use cases) was implemented between 15a and 15b-4 — the test count jump reflects that work.

---

## 4. SPEC DEVIATION REGISTER

These are places where the code intentionally differs from specs. Cross-referenced with DECISIONS.md entries.

| # | Area | What Spec Says | What Code Does | Reason | DECISIONS.md |
|---|------|---------------|----------------|--------|--------------|
| 1 | BBT/Vitals quick-entry | Capture multiple vitals (BBT, BP, HR, weight) | Captures BBT only | No storage entities for BP/HR/weight exist yet; those require Phase 16 vitals import | Decision 1 |
| 2 | Database migrations | Single sequential versioning | Profiles = v10, food/supplement extensions = v14 (not re-numbered on merge) | Separate parallel dev streams; merge required bumping only as needed | Decision 2 |
| 3 | Guest invite one-device limit | Spec implies flexible device management | Hard limit: one active device per invite | Security decision — prevents token sharing | Decision 3 |
| 4 | Archive/unarchive | All entities support archive | Only Supplements, Conditions, Food Items support archive | Other entities use soft-delete via syncMetadata instead | Decision 4 |
| 5 | Anchor Event dropdown | UI spec uses "Evening" as a label | Code uses enum definition without "Evening" variant | Code definitions take precedence; "Evening" was removed from enum | Decision 5 |
| 6 | Google OAuth client_secret | Spec implied proxy server | client_secret embedded in app | No proxy server infrastructure; acceptable for private beta | Decision 6 |
| 7 | DietRule / DietException entities | Must have clientId, profileId, syncMetadata | Neither field present on either entity | Sub-entities of Diet — synced and deleted as part of parent. Same rationale as food_item_categories exemption | New (spec review) |
| 8 | UserSettings / HealthSyncSettings entities | Must have clientId, syncMetadata | Both fields absent | Local-only configuration tables; never synced to Google Drive | New (spec review) |

---

## 5. KNOWN GAPS AND TECH DEBT

### Code TODOs (active in source)

| File | TODO | Impact |
|------|------|--------|
| `food_item_repository_impl.dart` | Category filtering not implemented (awaits FoodItemCategory junction table) | Food list cannot filter by category |
| `supplement_list_screen.dart` | IntakeLogScreen navigation not wired (supplement pre-selection not supported) | Tap on supplement doesn't open intake log with that supplement pre-filled |
| `supplement_list_screen.dart` | Filter switches not wired to provider state | Active/archived filter UI exists but does nothing |
| `food_item_list_screen.dart` | SearchFoodItemsUseCase not wired (no search delegate) | Search icon shown but search does nothing |
| `sleep_entry_list_screen.dart` | Date range filter not implemented | No date filtering on sleep history |
| `condition_edit_screen.dart` | Camera/photo picker not integrated | Condition photo capture is a placeholder |
| `condition_edit_screen.dart` | Update use case not called (create-only) | Editing a condition always creates a new record |

### Deferred / Not Yet Started

| Feature | Status | Depends On |
|---------|--------|-----------|
| Phase 16b: SyncFromHealthPlatformUseCase | Awaiting Reid approval | Phase 16a (done) |
| Phase 16c: iOS HealthKit plugin | Not started | Phase 16b |
| Phase 16d: Android Health Connect plugin | Not started | Phase 16b |
| Reports / Charts screens | Not in any current phase plan | All data layers |
| FoodItemCategory junction table | No phase assigned | — |

---

## 6. DEPENDENCY MAP

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
| `device_info_plus` | ^10.1.0 | Device ID and platform metadata for sync device tracking |
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

## 7. SPEC REVIEW REPORT — Phases 1–15b + 16a

**Completed:** 2026-02-24. Read-only pass — no code changes made.
**Result:** 19 discrepancies found across 7 spec documents.

**Legend:**
- STALE — spec needs updating, code is correct
- MISSING — feature built but spec has no entry
- DECISION — needs Reid to decide before action is taken

---

### 7.1 10_DATABASE_SCHEMA.md

**STALE** — Schema version header says v11; code is at v16. Update header and add v12–v16 migration history blocks.

**STALE** — Supplements table (Section 4.1) missing 5 Phase 15a columns: `custom_dosage_unit`, `source`, `price_paid`, `barcode`, `import_source`.

**STALE** — Food items table (Section 5.1) missing 7 Phase 15a columns: `sodium_mg`, `barcode`, `brand`, `ingredients_text`, `open_food_facts_id`, `import_source`, `image_url`. Also: spec calls type 1 "complex" but code and 59a spec say "composed" and add type 2 "packaged".

**STALE** — Food logs table (Section 5.2) missing `violation_flag` column added in v15.

**STALE** — Diet violations schema in spec is completely wrong. Spec has `food_log_id NOT NULL`, `rule_type`, `severity`, `message`. Code has `food_log_id NULLABLE`, `rule_id`, `food_name`, `rule_description`, `was_overridden`. Code is correct per 59_DIET_TRACKING.md.

**MISSING** — No table definitions for `diet_rules` or `diet_exceptions` anywhere in spec. Both are fully implemented.

**MISSING** — 11 implemented tables have no spec section: `guest_invites` (v11), `anchor_event_times` (v12), `notification_category_settings` (v12), `user_settings` (v13), `food_item_components` (v14), `food_barcode_cache` (v14), `supplement_label_photos` (v14), `supplement_barcode_cache` (v14), `imported_vitals` (v16), `health_sync_settings` (v16), `health_sync_status` (v16).

**STALE** — Spec describes 7 tables never built: `user_accounts`, `profile_access`, `device_registrations`, `documents`, `condition_categories`, `bowel_urine_logs` (deprecated, replaced by fluids_entries), `notification_schedules` (replaced by anchor_event_times + notification_category_settings in Phase 13).

**STALE** — `imported_vitals` schema shown in 61_HEALTH_PLATFORM_INTEGRATION.md uses TEXT for `data_type`, `recorded_at`, `source_platform` and ISO8601 timestamps. Code correctly uses INTEGER (enum values and epoch ms per coding standards).

---

### 7.2 22_API_CONTRACTS.md

**CONFIRMED CORRECT** — All core enums (health_enums.dart) verified against Section 3.3. Every value and integer assignment matches exactly.

**CONFIRMED CORRECT** — Result type, AppError subclasses, and ValidationRules constants all match spec exactly.

**MISSING** — No entity contracts for any Phase 13–16 entities: AnchorEventTime, NotificationCategorySettings, ScheduledNotification, UserSettings, FoodItemComponent, SupplementLabelPhoto, Diet, DietRule, DietException, FastingSession, DietViolation, ImportedVital, HealthSyncSettings, HealthSyncStatus. Implementations are correct — spec stubs are missing.

---

### 7.3 38_UI_FIELD_SPECIFICATIONS.md

**STALE** — Section 5.2 (Add/Edit Food Item) shows Type field as "Simple/Composed" only. Phase 15a added a third type: Packaged.

**MISSING** — No field specs for Phase 15a–16a screens: barcode scan flows, supplement scan flows, diet selection/builder/fasting/compliance screens, health platform sync settings.

---

### 7.4 56_GUEST_PROFILE_ACCESS.md

**STALE** — Status says "PLANNED — Not yet implemented". Phase 12 (a, b, c, d) is complete.

---

### 7.5 57_NOTIFICATION_SYSTEM.md and 58_SETTINGS_SCREENS.md

**STALE** — Both status fields say "PLANNED — Not yet implemented". Phase 13 and Phase 14 are complete.

**DECISION REQUIRED (1 of 2)** — Custom anchor events: 58_SETTINGS_SCREENS.md describes "Custom 1, Custom 2, Custom 3" user-defined anchor events. 57_NOTIFICATION_SYSTEM.md and the code only support the 5 fixed events (Wake, Breakfast, Lunch, Dinner, Bedtime). The two spec documents disagree. Should custom anchor events be built, or should the mention be removed from the Settings spec?

---

### 7.6 59_DIET_TRACKING.md and 59a_FOOD_DATABASE_EXTENSION.md

**STALE** — Both status fields say "PLANNED — Not yet implemented". Phase 15a and Phase 15b are complete.

**DECISION REQUIRED (2 of 2)** — Preset diet list: the Diet spec lists "Carnivore" and "DASH" as preset diets. The code's DietPresetType enum does not include either. The code has additional intermittent fasting variants not in the spec (pescatarian, ketoStrict, lowCarb, zone, if168, if186, if204, omad, fiveTwoDiet). Should Carnivore and DASH be added, or is the code's preset list the authoritative one?

---

### 7.7 60_SUPPLEMENT_EXTENSION.md

**STALE** — Status says "PLANNED — Not yet implemented". Phase 15a supplement extension is complete.

---

### 7.8 61_HEALTH_PLATFORM_INTEGRATION.md

**STALE** — Status says "PLANNED — Not yet implemented". Phase 16a (data foundation) is complete. Correct status: PARTIAL — Phase 16a done, Phase 16b–16d pending.

---

### 7.9 Coding Standards Deviations Found

**DietRule and DietException** — Missing `clientId`, `profileId`, `syncMetadata`. Intentional: sub-entities of Diet, synced and deleted as part of parent. Should be added to Sync Metadata Exemptions section of 10_DATABASE_SCHEMA.md.

**UserSettings and HealthSyncSettings** — Missing `clientId` and `syncMetadata`. Intentional: local-only configuration tables, never synced to Google Drive. Should be added to exemptions section.

**AnchorEventTime** — Missing `clientId` and `profileId`. Intentional: global app configuration, not profile-specific, local-only. Should be added to exemptions section.

---

### 7.10 Two Open Decisions for Reid

**DECISION 1 — Custom anchor events:**
58_SETTINGS_SCREENS.md describes custom anchor events ("Pre-workout", etc.). 57_NOTIFICATION_SYSTEM.md and the code only support 5 fixed events. Which spec is correct? Should custom events be built or dropped?

**DECISION 2 — Missing preset diets:**
The Diet spec lists Carnivore and DASH. The code enum does not include them. The code has more fasting protocol variants instead. Should Carnivore and DASH be added, or is the code's enum intentionally different?
