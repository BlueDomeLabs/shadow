# FIX_PLAN.md
# Shadow — Audit Fix Plan
# Created: 2026-03-02
# Findings source: docs/AUDIT_FINDINGS.md (64 total)
# Author: Shadow (Claude Code CLI), based on FINAL_AUDIT_PLAN.md convergence protocol

---

## Philosophy

Fixes are sequenced to resolve blocking issues first and preserve build stability throughout.
Each group is a discrete unit of work — one session per group. Dependencies are explicit.
No group begins until the previous group is committed and tests are passing.

Architecture findings (Groups A and B) are last because they require the most coordination
and carry the highest regression risk. Quick, high-value fixes come first.

---

## Section 1 — Group Definitions

---

### GROUP P — Platform & Store Blockers
**Complexity:** Quick (< 30 min total)
**Severity:** 1 CRITICAL + 4 HIGH + 1 MEDIUM + 2 LOW
**Findings:** 8
**Session estimate:** 1 session
**Dependencies:** None — do first

These findings cause App Store rejection or runtime crashes on device.
None require architectural changes. All are config file edits or small additions.

| Finding | Severity | Scope | Fix |
|---------|----------|-------|-----|
| AUDIT-08-001 | CRITICAL | ios/Runner/ | Create PrivacyInfo.xcprivacy + register in pbxproj |
| AUDIT-08-002 | HIGH | ios/Runner/Info.plist | Add 4 missing NSUsageDescription keys |
| AUDIT-08-003 | HIGH | AndroidManifest.xml | Add INTERNET permission |
| AUDIT-08-004 | HIGH | AndroidManifest.xml | Add USE_BIOMETRIC + USE_FINGERPRINT permissions |
| AUDIT-08-005 | HIGH | build.gradle.kts | Set minSdk = 26 explicitly |
| AUDIT-08-006 | MEDIUM | project.pbxproj | Raise IPHONEOS_DEPLOYMENT_TARGET to 16.0 (3 occurrences) |
| AUDIT-08-007 | LOW | build.gradle.kts | Configure release signing (launch checklist — no code change) |
| AUDIT-08-008 | LOW | Play Console | Complete Data Safety declaration (external, not a code change) |

**Notes:**
- AUDIT-08-007 and AUDIT-08-008 are launch checklist items, not code changes.
  Shadow documents them as ACKNOWLEDGED in AUDIT_FINDINGS.md; Reid handles them.
- AUDIT-08-001 requires Xcode project file edit (pbxproj) to register the new file.
  Shadow creates the XML file; Reid verifies Xcode sees it.

---

### GROUP Q — Quick Cleanup
**Complexity:** Quick (< 30 min total)
**Severity:** 0 CRITICAL, 0 HIGH, 1 MEDIUM, 5 LOW
**Findings:** 8
**Session estimate:** 1 session
**Dependencies:** None

Small, self-contained, low-risk changes. Each is a single-file edit.
Grouped together to batch the trivial work into one session.

| Finding | Severity | Scope | Fix |
|---------|----------|-------|-----|
| AUDIT-02-004 | LOW | database.dart | Update stale "Version 7" comment → "Version 18" |
| AUDIT-02-005 | LOW | bootstrap.dart | Update stale "14 entity types" comment → correct count post-fix |
| AUDIT-04-003 | LOW | database.dart | Wrap onUpgrade body in try/catch with descriptive logging |
| AUDIT-05-001 | LOW | 6 list providers | Remove entity names from debug log lines; log profileId only |
| AUDIT-05-003 | LOW | docs/archive/ | Delete client_secret.json; add client_secret*.json to .gitignore |
| AUDIT-10-001 | LOW | get_compliance_stats_use_case.dart | Extract `_maxRecentViolations = 10` constant |
| AUDIT-10-002 | LOW | diet_dashboard_screen.dart | Extract `_maxDashboardViolations = 5` constant |
| AUDIT-CA-003 | MEDIUM | profile_provider.dart | Add try/catch to _load() with logging; prevents silent data wipe on JSON corruption |

**Notes:**
- AUDIT-02-005 comment update should happen AFTER AUDIT-02-003 (diet adapters) is fixed,
  so the count is correct. Shadow updates the comment to reflect post-fix adapter count
  as the last step of GROUP S.
- AUDIT-05-001: The 6 list providers are: condition_list_provider, supplement_list_provider,
  food_item_list_provider, photo_area_list_provider, diet_list_provider, activity_list_provider.

---

### GROUP N — Navigation Wiring (Unreachable Screens)
**Complexity:** Quick to Medium (30-60 min total)
**Severity:** 0 CRITICAL, 3 HIGH, 2 MEDIUM, 0 LOW
**Findings:** 5
**Session estimate:** 1 session
**Dependencies:** None

Five screens are fully implemented but have no navigation entry point.
These are HIGH-severity user-facing gaps. All fixes are Navigator.push additions —
no new screens, no new use cases, no schema changes.

| Finding | Severity | Scope | Fix |
|---------|----------|-------|-----|
| AUDIT-CC-002 | HIGH | conditions_tab.dart | Add "Log Entry" popup menu item per condition card → ConditionLogScreen |
| AUDIT-CD-001 | HIGH | activities_tab.dart | Add "Log Activity" FAB or per-card action → ActivityLogScreen |
| AUDIT-CD-002 | HIGH | diet_dashboard_screen.dart / diet_list_screen.dart | Add "View Timer" entry → FastingTimerScreen when active session exists |
| AUDIT-CC-001 | MEDIUM | report_flare_up_screen.dart | Add delete action with confirmation dialog |
| AUDIT-CC-003 | MEDIUM | condition_list_screen.dart | Remove non-functional _FilterBottomSheet or implement real filter state |

**Notes:**
- AUDIT-CC-002 fix is the highest priority in this group: condition logging is
  the primary daily-tracking feature for conditions and is completely inaccessible.
- AUDIT-CD-002 should conditionally show the timer entry only when
  an active FastingSession exists (check via provider before rendering button).
- AUDIT-CC-003 decision: Architect should specify before session begins
  whether to implement actual filtering or remove the stub entirely.
  Remove is safer and faster; implement if filter UX is planned for launch.

---

### GROUP U — UI Error States & Form Guards
**Complexity:** Quick to Medium (60-90 min total)
**Severity:** 0 CRITICAL, 0 HIGH, 3 MEDIUM, 2 LOW
**Findings:** 5
**Session estimate:** 1 session
**Dependencies:** None

Error states surfaced to users as raw exception text. Form protection
missing on the primary onboarding screen. All fixes are UI-layer only.

| Finding | Severity | Scope | Fix |
|---------|----------|-------|-----|
| AUDIT-06-001 | MEDIUM | 6 home tab files | Replace raw error text with AppError.userMessage + retry button per tab |
| AUDIT-06-002 | MEDIUM | add_edit_profile_screen.dart | Add _isSaving guard, disable save during async, add PopScope unsaved-data warning |
| AUDIT-06-003 | MEDIUM | reports_tab.dart | Set _previewError on catch block and render error feedback in sheet |
| AUDIT-06-004 | LOW | health_sync_settings_screen.dart + notification_settings_screen.dart | Replace raw error text + add retry button |
| AUDIT-06-005 | LOW | guest_invite_list_screen.dart | Replace raw error text + add retry button |

**Notes:**
- AUDIT-06-001 affects all 6 home tabs. Pattern to match:
  supplement_list_screen.dart (AppError.userMessage + ref.invalidate retry).
- AUDIT-06-002: Match the pattern in condition_edit_screen.dart.
- AUDIT-07-004 (test for AUDIT-06-004 fix) should be written in the same session as AUDIT-06-004.

---

### GROUP S — Sync Integrity
**Complexity:** Medium (90-120 min total)
**Severity:** 0 CRITICAL, 2 HIGH, 2 MEDIUM, 0 LOW
**Findings:** 5
**Session estimate:** 1-2 sessions
**Dependencies:** None (GROUP Q should precede to clean up comments)

Data integrity issues in the sync system. None require schema changes but
all require careful implementation and test coverage.

| Finding | Severity | Scope | Fix |
|---------|----------|-------|-----|
| AUDIT-03-001 | HIGH | sync_service_impl.dart (+ DAOs) | Fix markEntitySynced for soft-deleted entities: add DAO-level markSynced(id) partial UPDATE bypassing soft-delete filter |
| AUDIT-02-003 | HIGH | bootstrap.dart + 3 new sync adapters | Register Diet, DietViolation, FastingSession SyncEntityAdapters; implement toJson/fromJson + repository accessors for each |
| AUDIT-03-002 | MEDIUM | All 15 DAO softDelete() methods (or BaseRepository) | Add syncVersion+1 and syncDeviceId writes to softDelete path |
| AUDIT-03-003 | MEDIUM | 3 archive use cases (supplement, condition, food_item) | Remove manual syncMetadata.copyWith() block; let repository.update() handle version increment |
| AUDIT-CB-001 | MEDIUM | diet_dao.dart | Add syncIsDirty/syncUpdatedAt/syncStatus to deactivateAll() Companion write |

**Notes:**
- AUDIT-03-001 fix: preferred approach is a DAO-level `markSynced(id)` partial UPDATE
  (UPDATE ... SET sync_is_dirty=false, sync_updated_at=? WHERE id=?) applied to all 15 DAOs.
  This avoids touching the soft-delete filter logic.
- AUDIT-02-003 is the most complex fix in this group. The three adapters follow the
  existing 15-adapter pattern in bootstrap.dart exactly. Each requires:
  (a) toJson() that serializes all entity fields,
  (b) fromJson() that deserializes and calls repository.create() or update(),
  (c) getPendingSync() wired to the repository method.
  Diet, DietViolation, FastingSession repositories all already have getPendingSync().
- After AUDIT-02-003 is fixed, update AUDIT-02-005 comment (the adapter count comment).
- AUDIT-03-002: Preferred approach is modifying BaseRepository.delete() to call
  prepareForDelete() + _dao.updateEntity() instead of _dao.softDelete(id) directly.
  This changes behavior in one place rather than all 15 DAOs.
- Tests required: AUDIT-03-001 fix must have a unit test verifying that a soft-deleted
  entity's isDirty flag is cleared after markEntitySynced. AUDIT-02-003 requires
  adapter round-trip tests (create → serialize → deserialize → verify).

---

### GROUP T — Test Coverage Gaps
**Complexity:** Medium (60-90 min total)
**Severity:** 0 CRITICAL, 1 HIGH, 2 MEDIUM, 1 LOW
**Findings:** 3 (AUDIT-07-004 deferred to GROUP U session)
**Session estimate:** 1 session
**Dependencies:** GROUP S (sync integration test needs correct sync behavior)

| Finding | Severity | Scope | Fix |
|---------|----------|-------|-----|
| AUDIT-07-001 | HIGH | test/integration/ | Add sync_flow_integration_test.dart: in-memory DB + mock CloudStorageProvider; test full create→push→pull→apply cycle |
| AUDIT-07-002 | MEDIUM | test/unit/domain/usecases/fluids_entries/ | Add fluids_entry_usecases_test.dart covering all 4 use cases (happy path, repository failure, auth failure, edge cases) |
| AUDIT-07-003 | MEDIUM | test/unit/domain/repositories/ | Delete entity_repository_test.dart and supplement_repository_test.dart or rename and comment as interface-contract-only (decision for Architect) |

**Notes:**
- AUDIT-07-001 is the highest-priority test. It provides the only automated coverage
  for the full sync flow and will catch regressions from GROUP S fixes.
- AUDIT-07-003 decision: Architect should specify before session begins:
  (a) delete both files (cleaner), or (b) add comment block marking limitation.
  Deleting them reduces the test count by 53 but the remaining tests are more meaningful.
- AUDIT-07-004 (error state test for health_sync_settings_screen) is written in the
  GROUP U session immediately after the AUDIT-06-004 fix.

---

### GROUP PH — Photo System Gaps
**Complexity:** Medium (90-120 min total)
**Severity:** 0 CRITICAL, 1 HIGH, 3 MEDIUM, 0 LOW
**Findings:** 5
**Session estimate:** 1-2 sessions
**Dependencies:** None

Photo feature gaps: missing UI pickers, missing file cleanup, and synchronous I/O in build paths.

| Finding | Severity | Scope | Fix |
|---------|----------|-------|-----|
| AUDIT-09-001 | HIGH | photo_entry_gallery_screen.dart + shadow_image.dart | Replace existsSync() with async exists() + FutureBuilder or pre-computed provider state |
| AUDIT-CB-002 | MEDIUM | report_flare_up_screen.dart | Add photo picker section matching condition_edit_screen pattern; pass _photoPath to LogFlareUpInput + UpdateFlareUpInput |
| AUDIT-CB-003 | MEDIUM | fluids_entry_screen.dart | Add urine photo picker matching existing bowel picker pattern; pass _urinePhotoPath to both inputs |
| AUDIT-CB-004 | MEDIUM | delete_flare_up_use_case.dart | Add photo file cleanup: if existing.photoPath != null, delete the file before soft-delete |
| AUDIT-09-002 | MEDIUM | photo_entry_gallery_screen.dart | Replace bare Image.file with ShadowImage.file or add cacheWidth/cacheHeight sized to grid tile |

**Notes:**
- AUDIT-CB-004 depends logically on AUDIT-CB-002: once flare-ups can have photos,
  the cleanup matters. Fix CB-004 in the same session as CB-002.
- AUDIT-09-001 is the highest priority in this group (HIGH, main thread blocking).
  Pre-compute file existence in the provider layer (preferred) or use FutureBuilder.
- AUDIT-CB-003 adds urine photo to fluids_entry_screen.dart, which is already 1,337 lines
  (AUDIT-10-004). The refactor in GROUP X should happen after, not before, this fix.

---

### GROUP F — Schema & Entity Fixes
**Complexity:** Medium
**Severity:** 0 CRITICAL, 1 HIGH, 1 MEDIUM, 0 LOW
**Findings:** 2
**Session estimate:** 1 session
**Dependencies:** None (schema migration required)

| Finding | Severity | Scope | Fix |
|---------|----------|-------|-----|
| AUDIT-02-002 | HIGH | food_item entity + DAO + schema | Add servingUnit: String? field to FoodItem entity; update DAO to read/write both fields independently; add schema migration |
| AUDIT-02-001 | MEDIUM | fluids_entry entity + DAO | Option A: add bowelCustomCondition + urineCustomCondition fields to FluidsEntry; wire through DAO. Option B: drop columns in migration. Architect decision required. |

**Notes:**
- AUDIT-02-002 requires a schema migration (v18 → v19). The ALTER TABLE pattern for
  adding columns is established in database.dart.
- AUDIT-02-001 requires Architect decision before the session: add fields or drop columns?
  If the custom condition fields are never used, dropping is cleaner. If they were intended
  as "custom text override" for bowel/urine condition, they should be added to the entity.
- This group increments the schema version. All subsequent groups must be aware.

---

### GROUP X — Complex Feature Work
**Complexity:** Medium to Complex (per-item)
**Severity:** 0 CRITICAL, 0 HIGH, 3 MEDIUM, 1 LOW
**Findings:** 5
**Session estimate:** 1-2 sessions (can be split)
**Dependencies:** GROUP PH (file refactors after photo additions)

Performance improvements, dead feature resolution, and large file refactors.

| Finding | Severity | Scope | Fix |
|---------|----------|-------|-----|
| AUDIT-04-001 | MEDIUM | sync_from_health_platform_use_case.dart | Match readRecords non-fatal pattern for DB operations inside sync loop; return per-type error counts |
| AUDIT-CD-003 | MEDIUM | health_sync_provider.dart + getImportedVitalsUseCaseProvider | Wire use case into health sync provider OR document as intentionally deferred (Phase 3) |
| AUDIT-09-003 | MEDIUM | sync_service_impl.dart + encryption_service.dart | Wrap encrypt/decrypt batch calls in Isolate.run() for batches above threshold |
| AUDIT-09-004 | LOW | journal_entry_list_screen.dart + photo_entry_gallery_screen.dart | Add date-range initial load for journal; filter photos by photoAreaId at DAO level |
| AUDIT-10-006 | HIGH* | supplement_edit_screen.dart + di_providers.dart | Wire _labelPhotoPaths into save flow via addSupplementLabelPhotoUseCaseProvider OR remove the label photo UI section entirely |

*AUDIT-10-006 is cataloged as HIGH in Pass 10. It is in GROUP X (not GROUP N) because the
fix decision (wire or remove) changes the scope significantly.

**Notes:**
- AUDIT-CD-003 decision required before session: wire or defer?
  If Phase 3 (Intelligence System) is the intended home for imported vitals display,
  document in DECISIONS.md and mark as WONT_FIX with explanation.
- AUDIT-10-006 decision required before session: wire or remove?
  If label photo feature is planned for launch, wire it.
  If deferred: remove the UI section, the DI provider, and the use case.
- Large file refactors (AUDIT-10-003, 10-004, 10-005) are LOW severity and deferred
  to a cleanup session after all higher-severity items are resolved. They are NOT
  in this group — see GROUP L below.

---

### GROUP A — Profile Architecture (Major)
**Complexity:** Complex — dedicated phase
**Severity:** 0 CRITICAL, 2 HIGH, 3 MEDIUM, 1 LOW (from pass findings)
**Cross-cutting resolves:** AUDIT-01-006, AUDIT-04-002, AUDIT-05-002, AUDIT-CA-001,
  AUDIT-CA-002, AUDIT-CA-003 (interim), AUDIT-CA-004, AUDIT-CA-005
**Findings resolved:** 8
**Session estimate:** 2-3 sessions
**Dependencies:** All groups above should be complete before beginning

This is the largest single fix in the audit. ProfileNotifier currently bypasses the
repository and persists profile data to SharedPreferences directly. The fix migrates
profile CRUD through the repository and use case layer, resolves the cascade deletion gap,
and removes the hardcoded test-profile-001 sentinel.

Sub-tasks (in order):

**A1 — Implement Profile Use Cases**
- CreateProfileUseCase (create via repository, not SharedPreferences)
- UpdateProfileUseCase (update via repository)
- DeleteProfileUseCase (cascade soft-delete all health data by profileId, revoke guest invites)
- GetProfilesUseCase (read from repository)
- Wire into di_providers.dart and bootstrap.dart

**A2 — Migrate ProfileNotifier**
- Replace SharedPreferences reads/writes with profileRepositoryProvider calls
- Remove duplicate in-memory model
- Add proper error handling (result type from use cases)
- Add ProfileState.error field

**A3 — Fix Home Screen Sentinel**
- Replace `?? 'test-profile-001'` with null guard in home_screen.dart and home_tab.dart
- Show "No profile selected" overlay or redirect to ProfilesScreen when null

**A4 — Update Delete Dialog**
- After cascade deletion is implemented (A1): update profiles_screen.dart delete dialog
  to describe the full scope of data that will be permanently deleted (AUDIT-CA-005)

**A5 — Interim security fix (if GROUP A is delayed)**
- Add AndroidOptions(encryptedSharedPreferences: true) to SharedPreferences calls
  in profile_provider.dart as AUDIT-05-002 interim fix
- This is not needed if GROUP A is done before first Android device test

**Notes:**
- Profile sync adapter already exists in bootstrap.dart and is correctly implemented.
  The fix is entirely in the UI/use-case layer — the data layer is ready.
- This fix will change how ProfilesScreen, HomeScreen, HomeTab, and OnboardingScreen
  interact with profile state. The Architect should review A2 before implementation
  to confirm the state management pattern.
- After GROUP A, profileRepositoryProvider (currently throwing UnimplementedError)
  will be the live source of truth. This resolves AUDIT-01-006 and downstream findings.

---

### GROUP B — Cloud Sync Architecture
**Complexity:** Complex — dedicated phase
**Severity:** 0 CRITICAL, 1 HIGH, 3 MEDIUM, 0 LOW
**Cross-cutting resolves:** AUDIT-01-001, AUDIT-01-004, AUDIT-01-005, AUDIT-01-007
**Findings resolved:** 4
**Session estimate:** 2 sessions
**Dependencies:** GROUP A complete (reduces refactor scope)

Extracts business logic from CloudSyncAuthProvider into a domain use case,
and moves CloudStorageProvider to the domain layer.

Sub-tasks (in order):

**B1 — Move CloudStorageProvider to domain**
- Move lib/data/datasources/remote/cloud_storage_provider.dart to
  lib/domain/repositories/cloud_storage_provider.dart
- Update all imports (bootstrap.dart, sync_service.dart, DI providers, icloud_provider,
  google_drive_provider)
- Resolves AUDIT-01-001

**B2 — Extract CloudSyncAuthUseCase**
- Create lib/domain/usecases/cloud_sync/cloud_sync_auth_use_case.dart
- Move auth session checks, sign-in/sign-out logic, FlutterSecureStorage writes
  out of CloudSyncAuthNotifier into the use case
- CloudSyncAuthNotifier becomes state-holder only, delegating all operations to use case
- Resolves AUDIT-01-004 and AUDIT-01-007

**B3 — Retype DI providers to abstract interfaces**
- Update affected providers in di_providers.dart to reference domain interfaces
- Resolves AUDIT-01-005

**Notes:**
- This group has the highest regression risk of all groups. A bug here could break
  cloud sync entirely. The Architect should design the CloudSyncAuthUseCase interface
  before Shadow implements it.
- B1 (file move) should be committed and tested independently before B2 begins.

---

### GROUP L — Large File Refactors (Low Priority)
**Complexity:** Medium (cosmetic/structural only)
**Severity:** 0 CRITICAL, 0 HIGH, 0 MEDIUM, 3 LOW
**Findings:** 3
**Session estimate:** 1-2 sessions
**Dependencies:** GROUP PH and GROUP X complete (adds to these files before refactor)

| Finding | Severity | File | Current Lines | Fix |
|---------|----------|------|---------------|-----|
| AUDIT-10-003 | LOW | supplement_edit_screen.dart | 1,634 | Extract schedule builder, photo section, barcode/AI scan into widget classes |
| AUDIT-10-004 | LOW | fluids_entry_screen.dart | 1,337 | Extract widget components |
| AUDIT-10-005 | LOW | food_item_edit_screen.dart | 1,131 | Extract widget components |

**Notes:**
- These refactors carry real regression risk for no functional improvement.
  Do last. Each extraction must be accompanied by widget tests verifying
  the extracted component renders correctly.
- AUDIT-10-003 depends on GROUP PH (CB-003 adds urine photo to fluids_entry_screen)
  and GROUP X (AUDIT-10-006 may add or remove content from supplement_edit_screen).
  Do not refactor until all content additions are complete.

---

### GROUP DEFERRED — Intentionally Deferred Items
**These items are NOT scheduled for implementation. Architect marks them in AUDIT_FINDINGS.md.**

| Finding | Severity | Reason |
|---------|----------|--------|
| AUDIT-CD-004 | LOW | GetBBTEntriesUseCase — delete the dead use case; BBTChartScreen direct provider access is acceptable |
| AUDIT-01-002 | LOW | local_profile_authorization_service.dart move — low risk, revisit with GROUP B |
| AUDIT-01-003 | LOW | notification_seed_service.dart move — low risk, revisit with GROUP B |
| AUDIT-09-004 (journal) | LOW | Pagination deferred to Phase 4 (journal list will not reach thousands of entries at launch) |
| AUDIT-08-007 | LOW | Release signing — launch checklist item for Reid |
| AUDIT-08-008 | LOW | Play Console Data Safety — external action for Reid |

**Notes:**
- AUDIT-CD-004: Shadow should simply delete the dead use case file in GROUP Q.
  BBTChartScreen reading fluids_entry_list_provider directly is a documented shortcut.
- AUDIT-01-002 and AUDIT-01-003: These file moves are low-value renames. They become
  relevant only if GROUP B proceeds (cloud sync architecture refactor). If GROUP B is
  deferred post-launch, these can be WONT_FIX.

---

## Section 2 — Execution Sequence

| Order | Group | Findings | C | H | M | L | Estimate | Blocker? |
|-------|-------|----------|---|---|---|---|----------|----------|
| 1 | **P — Platform & Store Blockers** ✓ DONE | 8 | 1 | 4 | 1 | 2 | 1 session | YES — App Store |
| 2 | **Q — Quick Cleanup** ✓ DONE | 8 | 0 | 0 | 1 | 7 | 1 session | No |
| 3 | **N — Navigation Wiring** ✓ DONE | 5 | 0 | 3 | 2 | 0 | 1 session | YES — users can't reach features |
| 4 | **U — UI Error States** ✓ DONE | 6 | 0 | 0 | 3 | 2 | 1 session | No |
| 5 | **S — Sync Integrity** ✓ DONE | 5 | 0 | 2 | 2 | 0 (+ comment) | 1-2 sessions | YES — data correctness |
| 6 | T — Test Coverage | 3 | 0 | 1 | 2 | 0 | 1 session | No |
| 7 | PH — Photo System | 5 | 0 | 1 | 3 | 0 | 1-2 sessions | No |
| 8 | F — Schema & Entity | 2 | 0 | 1 | 1 | 0 | 1 session | No |
| 9 | X — Complex Features | 5 | 0 | 1 | 3 | 0 | 1-2 sessions | No |
| 10 | A — Profile Architecture | 8 | 0 | 2 | 4 | 1 | 2-3 sessions | YES — sync & data integrity |
| 11 | B — Cloud Sync Architecture | 4 | 0 | 1 | 3 | 0 | 2 sessions | No |
| 12 | L — Large File Refactors | 3 | 0 | 0 | 0 | 3 | 1-2 sessions | No |
| DEF | Deferred | 6 | 0 | 0 | 0 | 6 | — | No |
| **TOTAL** | | **67*** | **1** | **15** | **25** | **21** | **~15 sessions** | |

*67 because DEFERRED group includes 3 items counted in prior groups (01-002, 01-003 in B;
CD-004 in Q/GROUP Q note). Net unique finding count remains 64 from AUDIT_FINDINGS.md.

---

## Section 3 — Decisions Required Before Sessions Begin

The following decisions must be made by the Architect before the relevant session starts.
Shadow cannot proceed without explicit direction on ambiguous items.

| Decision | Needed Before | Options |
|----------|--------------|---------|
| AUDIT-07-003: Delete redundant repository tests or comment? | GROUP T | (a) Delete both files (−53 tests), or (b) Add limitation comment and rename |
| AUDIT-02-001: Add FluidsEntry custom condition fields or drop columns? | GROUP F | (a) Add bowelCustomCondition + urineCustomCondition to entity, or (b) Drop columns in migration |
| AUDIT-CD-003: Wire imported vitals or document as Phase 3 deferral? | GROUP X | (a) Wire getImportedVitalsUseCaseProvider into health_sync_provider, or (b) Mark WONT_FIX (Phase 3) |
| AUDIT-10-006: Wire supplement label photos or remove dead code? | GROUP X | (a) Wire into save flow, or (b) Remove UI section + DI wiring |
| GROUP A: CloudSyncAuthUseCase interface design | GROUP B | Architect drafts interface before Shadow implements |

---

## Section 4 — Coverage Summary After All Fixes

When all groups are complete and deferred items are acknowledged:

| Category | Before | After |
|----------|--------|-------|
| CRITICAL findings | 1 | 0 |
| HIGH findings | 15 | 0 |
| MEDIUM findings | 28 | 0 |
| LOW findings | 20 | 2–3 (deferred) |
| Unreachable screens | 4 | 0 |
| Missing platform manifests | 1 critical + 4 high | 0 |
| Unregistered sync adapters | 3 | 0 |
| Sync correctness bugs | 3 | 0 |
| Test coverage gaps | 3 | 0 |

---

---

## Section 5 — Fix Session Log

| Date | Group | Finding IDs | Commit | Notes |
|------|-------|-------------|--------|-------|
| 2026-03-02 | GROUP P | AUDIT-08-001, 08-002, 08-003, 08-004, 08-005, 08-006, 08-007(ack), 08-008(ack) | 4782b15 | All 6 code fixes done; 2 launch-checklist items acknowledged |
| 2026-03-02 | GROUP Q | AUDIT-02-004, 02-005, 04-003, 05-001, 05-003, 07-003, 10-001, 10-002, CA-003 | 458ce90 | All 9 findings fixed; 3,442 tests passing; analyzer clean |
| 2026-03-02 | GROUP N | AUDIT-CC-002, CC-003, CD-001, CD-002, CD-004 | 40154aa | All 5 findings fixed; 3,441 tests passing (−1 from removed filter stub test); analyzer clean |
| 2026-03-02 | GROUP U | AUDIT-06-001, 06-002, 06-003, 06-004, 06-005, CC-001 | TBD | All 6 findings fixed; 3,441 tests passing; analyzer clean |
| 2026-03-02 | GROUP S | AUDIT-CB-001, AUDIT-02-003, AUDIT-03-002, AUDIT-03-003, AUDIT-03-001 | TBD | All 5 findings fixed; 3,448 tests passing (+7 new); analyzer clean. Session spanned 2 context windows (compaction mid-session). |

---

*End of FIX_PLAN.md*
*Architect: review group definitions and decisions required before issuing GROUP Q prompt to Shadow.*
