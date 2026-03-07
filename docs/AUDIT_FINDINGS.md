# AUDIT_FINDINGS.md
# Shadow — Final Pre-Launch Audit Findings Register
# Status: IN PROGRESS
# Last Updated: 2026-03-02

---

## Security Findings

---

### SEC-001 — Hardcoded OAuth Credentials (Development Fallback)

**Severity:** HIGH
**Category:** Security
**Status:** OPEN
**Gate:** Must be resolved before App Store submission

**Finding:**
OAuth client ID and client secret are hardcoded as development
fallback values in `lib/core/config/google_oauth_config.dart`.
These same credentials are documented in
`docs/specs/19_OAUTH_IMPLEMENTATION.md`. Both files are
git-tracked, meaning real credentials are in git history.

**Resolution Required:**
- Remove hardcoded fallback values from google_oauth_config.dart
- Production build must fail loudly if GOOGLE_OAUTH_CLIENT_ID
  and GOOGLE_OAUTH_CLIENT_SECRET are not provided via --dart-define
- Rotate both credentials after the hardcoded values are removed
- Update docs/specs/19_OAUTH_IMPLEMENTATION.md to remove the
  hardcoded values from code examples

**Files:**
- `lib/core/config/google_oauth_config.dart`
- `docs/specs/19_OAUTH_IMPLEMENTATION.md`

---

## Pass 01 — Architecture & Layer Boundaries
Date: 2026-03-02
Status: COMPLETE
Total findings: 7 (0 CRITICAL, 2 HIGH, 3 MEDIUM, 2 LOW)

---

AUDIT-01-001
Severity: MEDIUM
Category: Architecture & Layer Boundaries
File: lib/domain/services/sync_service.dart
Cross-cutting: lib/data/services/sync_service_impl.dart,
  lib/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart,
  lib/presentation/providers/di/di_providers.dart
Description: sync_service.dart (domain layer) imports
  CloudStorageProvider from lib/data/datasources/remote/.
  Domain must not import from data layer. CloudStorageProvider
  is abstract but physically lives in lib/data/.
Fix approach: Move cloud_storage_provider.dart to
  lib/domain/repositories/ or lib/core/sync/ so domain
  layer can reference it without importing from data layer.
Status: OPEN

---

AUDIT-01-002
Severity: LOW
Category: Architecture & Layer Boundaries
File: lib/domain/services/local_profile_authorization_service.dart
Cross-cutting: None
Description: Concrete class in domain layer. Convention
  is concretions in lib/data/services/. No functional risk
  (no external deps), but violates the layering convention.
Fix approach: Move to lib/data/services/.
Status: OPEN

---

AUDIT-01-003
Severity: LOW
Category: Architecture & Layer Boundaries
File: lib/domain/services/notification_seed_service.dart
Cross-cutting: None
Description: Concrete seeding class with UUID generation
  logic in domain layer. Belongs in lib/data/services/.
Fix approach: Move to lib/data/services/.
Status: OPEN

---

AUDIT-01-004
Severity: HIGH
Category: Architecture & Layer Boundaries
File: lib/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart
Cross-cutting: lib/data/cloud/google_drive_provider.dart,
  lib/data/cloud/icloud_provider.dart,
  lib/core/bootstrap.dart
Description: Provider directly imports and holds concrete
  data-layer types (GoogleDriveProvider, ICloudProvider).
  Contains business logic that belongs in use cases: auth
  session checks, sign-in/sign-out, provider switching,
  FlutterSecureStorage writes. Acknowledged as tech debt
  in file comment.
Fix approach: Extract auth orchestration into a
  CloudSyncAuthUseCase or similar domain use case.
  Provider should hold state only and delegate all
  operations to the use case.
Status: OPEN

---

AUDIT-01-005
Severity: MEDIUM
Category: Architecture & Layer Boundaries
File: lib/presentation/providers/di/di_providers.dart
Cross-cutting: lib/core/bootstrap.dart
Description: Several providers are typed to concrete
  implementations rather than abstract interfaces. DI
  providers should reference domain interfaces so the
  concrete type is only known to bootstrap.dart.
Fix approach: Retype affected providers to their abstract
  interface types. Resolves naturally when AUDIT-01-004
  is addressed.
Status: OPEN

---

AUDIT-01-006
Severity: HIGH
Category: Architecture & Layer Boundaries
File: lib/presentation/providers/profile/profile_provider.dart
Cross-cutting: lib/core/bootstrap.dart,
  lib/data/repositories/profile_repository_impl.dart,
  lib/data/datasources/local/daos/profile_dao.dart
Description: ProfileNotifier maintains a duplicate
  in-memory profile model and persists to SharedPreferences
  directly, bypassing the repository and sync system.
  profileRepositoryProvider in DI throws UnimplementedError
  and is never consumed. Profile create/rename/delete are
  completely invisible to the sync system — profile changes
  will not propagate between devices.
Fix approach: Implement profile use cases. Migrate
  ProfileNotifier to use profileRepositoryProvider.
  Delete duplicate in-memory model. Remove direct
  SharedPreferences writes for profile data.
Status: OPEN

---

AUDIT-01-007
Severity: MEDIUM
Category: Architecture & Layer Boundaries
File: lib/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart
Cross-cutting: lib/core/bootstrap.dart
Description: CloudSyncAuthNotifier instantiates
  ICloudProvider() directly as a fallback (line ~88).
  Concrete instantiation must only occur in bootstrap.dart.
  Subsumed by AUDIT-01-004 — resolves when that is fixed.
Fix approach: Remove direct ICloudProvider() instantiation.
  Receive all concrete providers via constructor injection
  from bootstrap.
Status: OPEN

---

## End of Pass 01 Findings

---

## Pass 02 — Schema → Entity → DAO → Repository Alignment
Date: 2026-03-02
Status: COMPLETE
Total findings: 5 (0 CRITICAL, 1 HIGH, 2 MEDIUM, 2 LOW)

Note: 15 sync adapters exist (not 14 as documented).
3 additional Syncable entities (Diet, DietViolation,
FastingSession) have no adapter registration.

---

AUDIT-02-001
Severity: MEDIUM
Category: Schema → Entity → DAO → Repository Alignment
File: lib/data/datasources/local/tables/fluids_entries_table.dart
Cross-cutting: lib/data/datasources/local/daos/fluids_entry_dao.dart,
  lib/domain/entities/fluids_entry.dart
Description: Two table columns (bowel_custom_condition,
  urine_custom_condition) have no corresponding fields
  in the FluidsEntry entity. The DAO _rowToEntity never
  reads them and _entityToCompanion never writes them.
  These columns are permanently null in all rows.
Fix approach: Either add entity fields for these two
  columns and wire them through the DAO, or drop the
  columns in a migration if they are not needed.
Status: FIXED

---

AUDIT-02-002
Severity: MEDIUM
Category: Schema → Entity → DAO → Repository Alignment
File: lib/data/datasources/local/tables/food_items_table.dart
Cross-cutting: lib/domain/entities/food_item.dart,
  lib/data/datasources/local/daos/food_item_dao.dart
Description: Type mismatch between schema and entity.
  Table stores serving_size (REAL) + serving_unit (TEXT)
  as two separate columns. Entity has a single
  servingSize: String? field (e.g. "1 cup", "100g").
  DAO converts via _buildServingSize/_parseServingSize
  which silently returns (null, null) for non-parseable
  strings — data loss possible on round-trip.
Fix approach: Add a separate servingUnit: String? field
  to the FoodItem entity to match the schema structure.
  Update DAO to read/write both fields independently
  without string parsing.
Status: FIXED

---

AUDIT-02-003
Severity: HIGH
Category: Schema → Entity → DAO → Repository Alignment
File: lib/core/bootstrap.dart
Cross-cutting: lib/domain/entities/diet.dart,
  lib/domain/entities/diet_violation.dart,
  lib/domain/entities/fasting_session.dart,
  lib/data/datasources/local/tables/diets_table.dart,
  lib/data/datasources/local/tables/diet_violations_table.dart,
  lib/data/datasources/local/tables/fasting_sessions_table.dart
Description: Diet, DietViolation, and FastingSession all
  implement Syncable with full sync metadata columns and
  complete DAO + repository stacks. None are registered
  as SyncEntityAdapter in bootstrap.dart. Diet data is
  marked dirty on every create/update but the sync system
  never reads these entities. Diet tracking data silently
  never syncs between devices — no error, no indication,
  just permanent data divergence.
Fix approach: Add three SyncEntityAdapter registrations
  for Diet, DietViolation, and FastingSession in
  bootstrap.dart. Implement the required toJson/fromJson
  and repository accessors for each adapter.
Status: FIXED — 2026-03-02 GROUP S. Added SyncEntityAdapter<Diet>, SyncEntityAdapter<DietViolation>,
  SyncEntityAdapter<FastingSession> to bootstrap.dart. All three entities have toJson/fromJson
  via Freezed and full repository stacks. Round-trip tests added to sync_service_impl_test.dart.

---

AUDIT-02-004
Severity: LOW
Category: Schema → Entity → DAO → Repository Alignment
File: lib/data/datasources/local/database.dart
Cross-cutting: None
Description: Class doc comment says "Schema version
  follows 10_DATABASE_SCHEMA.md: Version 7" but actual
  schemaVersion constant is 18. Stale comment.
Fix approach: Update comment to "Version 18".
Status: FIXED

---

AUDIT-02-005
Severity: LOW
Category: Schema → Entity → DAO → Repository Alignment
File: lib/core/bootstrap.dart
Cross-cutting: None
Description: Comment says "Build sync entity adapters
  for all 14 entity types" but 15 adapters are registered.
  Additionally 3 more Syncable entities exist without
  adapters (see AUDIT-02-003). Stale comment will be
  wrong in both directions until the adapter gap is fixed.
Fix approach: Update comment after AUDIT-02-003 is
  resolved to reflect the correct adapter count.
Status: FIXED

---

## End of Pass 02 Findings

---

## Pass 03 — Sync Correctness
Date: 2026-03-02
Status: COMPLETE
Total findings: 3 (0 CRITICAL, 1 HIGH, 2 MEDIUM, 0 LOW)

---

AUDIT-03-001
Severity: HIGH
Category: Sync Correctness
File: lib/data/services/sync_service_impl.dart
Cross-cutting: All 15 entity DAOs
Description: After a successful push, markEntitySynced()
  calls repository.getById(entityId) to fetch the entity
  before clearing isDirty. All DAOs filter out
  soft-deleted rows (WHERE sync_deleted_at IS NULL), so
  getById returns not-found for deleted entities.
  markEntitySynced failure is silently ignored. Result:
  deleted entities upload correctly once but their local
  syncIsDirty flag is never cleared — they re-upload on
  every sync cycle indefinitely. Silent infinite loop.
Fix approach: Either (a) have markEntitySynced bypass
  the soft-delete filter to fetch the row, or (b) add a
  DAO-level markSynced(id) partial UPDATE that sets
  syncIsDirty=false directly without fetching the entity.
Status: FIXED — 2026-03-02 GROUP S. Added markSynced(id) partial UPDATE to all 18 DAOs
  (UPDATE ... SET syncIsDirty=false, syncStatus=synced, syncLastSyncedAt=now WHERE id=?).
  SyncEntityAdapter.markEntitySynced() now delegates directly to repository.markSynced(id)
  bypassing the soft-delete filter. EntityRepository interface extended with markSynced().

---

AUDIT-03-002
Severity: MEDIUM
Category: Sync Correctness
File: lib/core/repositories/base_repository.dart
Cross-cutting: All 15 entity DAO softDelete() methods
Description: DAO softDelete() writes a partial Companion
  setting syncDeletedAt, syncUpdatedAt, syncIsDirty=true,
  syncStatus=deleted — but does NOT increment syncVersion
  or update syncDeviceId. BaseRepository.prepareForDelete()
  which calls markDeleted() with proper version increment
  exists but is never called by any repository impl —
  all 15 call _dao.softDelete(id) directly. Conflict
  detection still works (isDirty-based) but syncVersion
  does not reflect delete operations.
Fix approach: Repository delete() methods should call
  prepareForDelete() then _dao.updateEntity(), or each
  DAO softDelete() must also write syncVersion+1 and
  syncDeviceId.
Status: FIXED — 2026-03-02 GROUP S. All 18 DAO softDelete() methods now accept
  {String deviceId = ''} named parameter and fetch the current row before writing,
  incrementing syncVersion+1 and writing syncDeviceId. BaseRepository.delete()
  calls _dao.softDelete(id, deviceId: await getDeviceId()).

---

AUDIT-03-003
Severity: MEDIUM
Category: Sync Correctness
File: lib/domain/usecases/supplements/archive_supplement_use_case.dart
Cross-cutting: lib/domain/usecases/conditions/archive_condition_use_case.dart,
  lib/domain/usecases/food_items/archive_food_item_use_case.dart
Description: All three archive use cases manually set
  syncVersion: existing.syncMetadata.syncVersion + 1
  before calling repository.update(updated). The update()
  path calls prepareForUpdate() which calls markModified(),
  which increments syncVersion again. Archive operations
  double-increment syncVersion (N → N+2 instead of N+1).
  Could cause spurious conflict detection.
Fix approach: Remove the manual syncMetadata.copyWith(...)
  block from all three archive use cases. Only set
  isArchived on the entity copy and let repository.update()
  handle all sync metadata increments.
Status: FIXED — 2026-03-02 GROUP S. Removed manual syncMetadata.copyWith() block
  from archive_supplement_use_case.dart, archive_condition_use_case.dart,
  archive_food_item_use_case.dart. repository.update() now handles all version increments.

---

## End of Pass 03 Findings

---

## Pass 04 — Error Handling & Result Type
Date: 2026-03-02
Status: COMPLETE
Total findings: 3 (0 CRITICAL, 0 HIGH, 2 MEDIUM, 1 LOW)

Note: All 26 repository impls, all use cases, and all
Riverpod providers are clean. Result type usage is
disciplined throughout. No swallowed exceptions found
outside the items below.

---

AUDIT-04-001
Severity: MEDIUM
Category: Error Handling & Result Type
File: lib/domain/usecases/health/sync_from_health_platform_use_case.dart
Cross-cutting: None
Description: Inconsistent per-type error handling in
  health sync loop. Comment at line 127 states "Platform
  read failure for one type should not abort the whole
  sync" — readRecords failures are correctly non-fatal
  and continue to the next type. However,
  _vitalRepo.getLastImportTime(), _vitalRepo.importBatch(),
  and _statusRepo.upsert() failures all return Failure(),
  aborting the entire import. A transient DB error on
  one data type (e.g. heart rate) aborts all remaining
  types (weight, blood pressure, steps, etc.). User sees
  "Sync failed" with no indication of partial completion.
Fix approach: Match the readRecords non-fatal pattern
  for DB operations within the loop — log, record 0
  imported for that type, and continue. Return partial
  SyncFromHealthPlatformResult with per-type error
  counts instead of top-level Failure.
Status: OPEN

---

AUDIT-04-002
Severity: MEDIUM
Category: Error Handling & Result Type
File: lib/presentation/providers/profile/profile_provider.dart
Cross-cutting: lib/domain/usecases/profiles/ (missing),
  lib/data/repositories/profile_repository_impl.dart
Description: ProfileNotifier._load(), _save(),
  addProfile(), updateProfile(), deleteProfile(),
  setCurrentProfile() have no error handling.
  SharedPreferences failures produce uncaught async
  exceptions. ProfileState has no error field. Screens
  call these methods fire-and-forget — if persistence
  fails, UI shows success while the change was not
  saved. Downstream consequence of AUDIT-01-006; the
  architectural fix resolves this automatically.
Fix approach: Add try/catch to _save() and _load()
  with logging as an interim fix. Full resolution
  when AUDIT-01-006 is addressed (migrate profile
  management to profileRepositoryProvider + use cases).
Status: OPEN

---

AUDIT-04-003
Severity: LOW
Category: Error Handling & Result Type
File: lib/data/datasources/local/database.dart
Cross-cutting: None
Description: MigrationStrategy.onUpgrade has no
  try/catch. onCreate has a try/catch with descriptive
  logging before rethrow. onUpgrade should match — a
  migration failure is a critical crash and wrapping
  with descriptive logging before rethrow would
  significantly aid crash diagnosis in the field.
Fix approach: Wrap entire onUpgrade body in try/catch
  that logs DatabaseError.migrationFailed(from, to,
  e, stack) then rethrows.
Status: FIXED

---

## End of Pass 04 Findings

---

## Pass 05 — Security & Privacy
Date: 2026-03-02
Status: COMPLETE
Total findings: 3 (0 CRITICAL, 0 HIGH, 1 MEDIUM, 2 LOW)

Note: Encryption, guest access, PIN/biometric, and
health data routing all pass cleanly. The security
architecture is sound.

---

AUDIT-05-001
Severity: LOW
Category: Security & Privacy
File: lib/presentation/providers/conditions/condition_list_provider.dart
Cross-cutting: lib/presentation/providers/supplements/supplement_list_provider.dart,
  lib/presentation/providers/food_items/food_item_list_provider.dart,
  lib/presentation/providers/photos/photo_area_list_provider.dart,
  lib/presentation/providers/diet/diet_list_provider.dart,
  lib/presentation/providers/activities/activity_list_provider.dart
Description: Multiple list providers log entity names
  at debug level on create (e.g. "Creating condition:
  Crohn's Disease"). Medical condition names are PHI.
  All calls are .debug() level — suppressed in release
  builds via kDebugMode check in logger_service.dart.
  Risk is development and testing builds only, not
  production. encryption_service.dart comment says
  "Never log plaintext or encryption keys" but does
  not explicitly address entity content.
Fix approach: Remove entity name from create() debug
  log lines across all list providers. Log operation
  and profileId only (e.g. "Creating condition for
  profile: $profileId"). IDs and counts are acceptable;
  names and content are not.
Status: FIXED

---

AUDIT-05-002
Severity: MEDIUM
Category: Security & Privacy
File: lib/presentation/providers/profile/profile_provider.dart
Cross-cutting: android/ (SharedPreferences storage layer)
Description: Profile JSON (names, profile IDs, profile
  list) stored via plain SharedPreferences with no
  AndroidOptions(encryptedSharedPreferences: true).
  On Android, SharedPreferences data is stored
  unencrypted in the app data directory. Profile names
  are PII. On iOS/macOS, NSUserDefaults is sandboxed
  but also unencrypted. This is distinct from
  AUDIT-01-006 (architectural bypass) — this is
  specifically unencrypted PII on disk. Full resolution
  when AUDIT-01-006 is addressed (profile data moves
  to encrypted Drift/SQLCipher database).
Fix approach: As interim: add AndroidOptions(
  encryptedSharedPreferences: true) to SharedPreferences
  calls in profile_provider.dart. Full resolution
  when AUDIT-01-006 is addressed.
Status: OPEN

---

AUDIT-05-003
Severity: LOW
Category: Security & Privacy
File: docs/archive/cloud-sync/reference-code/client_secret.json
Cross-cutting: .gitignore
Description: Google OAuth client_secret
  (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) present in
  a JSON file committed to the git repository under
  docs/archive/. Same secret as the development
  fallback in google_oauth_config.dart — no additional
  credential exposure beyond what is already accepted
  in DECISIONS.md. Archive file is not included in
  app bundle. Risk is elevated only if repository
  becomes public. The JSON format could be mistakenly
  used with OAuth tooling.
Fix approach: Delete docs/archive/cloud-sync/
  reference-code/client_secret.json from repository.
  Add client_secret*.json to .gitignore.
Status: FIXED

---

## End of Pass 05 Findings

---

## Pass 06 — UI Completeness
Date: 2026-03-02
Status: COMPLETE
Total findings: 5 (0 CRITICAL, 0 HIGH, 3 MEDIUM, 2 LOW)

Note: All 65 screens read. Main feature screens
(condition, supplement, food, activity, sleep, fluids,
photo, journal) all pass loading/error/empty/form/
destructive-action/unsaved-data checks. Gaps concentrated
in home tabs, profile onboarding, and reports preview.

---

AUDIT-06-001
Severity: MEDIUM
Category: UI Completeness
File: lib/presentation/screens/home/tabs/conditions_tab.dart
Cross-cutting: lib/presentation/screens/home/tabs/food_tab.dart,
  lib/presentation/screens/home/tabs/supplements_tab.dart,
  lib/presentation/screens/home/tabs/activities_tab.dart,
  lib/presentation/screens/home/tabs/fluids_tab.dart,
  lib/presentation/screens/home/tabs/photos_tab.dart
Description: All six home tabs use raw Dart exception
  text in error state with no retry button:
  error: (error, _) => Center(child: Text('Error
  loading conditions: $error')). Exposes raw exception
  strings to users. No recovery path — user must leave
  and re-enter the tab. Inconsistent with dedicated list
  screens (supplement_list_screen, flare_up_list_screen,
  etc.) which correctly show AppError.userMessage + retry
  via ref.invalidate().
Fix approach: Replace raw error text with
  AppError.userMessage and add a retry button calling
  ref.invalidate(provider) in all six tabs. Match the
  pattern in supplement_list_screen.dart.
Status: FIXED

---

AUDIT-06-002
Severity: MEDIUM
Category: UI Completeness
File: lib/presentation/screens/profiles/add_edit_profile_screen.dart
Cross-cutting: None
Description: _save() has no _isSaving guard — double-
  submit is possible. Save button does not disable
  during async save. No loading indicator while saving.
  No _isDirty tracking and no PopScope unsaved-data
  warning — back navigation during form fill gives no
  warning. This is the primary onboarding screen for
  new users and is missing all three standard form
  protection patterns present in every other form in
  the app.
Fix approach: Add _isSaving state and guard in _save().
  Disable save button while saving; show
  CircularProgressIndicator in AppBar action.
  Add _isDirty flag and PopScope confirmation on back.
  Match pattern in condition_edit_screen.dart.
Status: FIXED

---

AUDIT-06-003
Severity: MEDIUM
Category: UI Completeness
File: lib/presentation/screens/home/tabs/reports_tab.dart
Cross-cutting: None
Description: Both _ActivityReportSheetState._preview()
  and _ReferenceReportSheetState._preview() swallow
  exceptions silently: } on Exception { setState(() =>
  _isLoading = false); }. Loading spinner clears but no
  error message is shown. User cannot distinguish "no
  records for this date range" from "query failed".
  Export correctly shows a SnackBar on failure — only
  preview is missing the feedback.
Fix approach: Set a _previewError field in the catch
  block and render an error message in the sheet.
  Match the export error pattern (showAccessibleSnackBar)
  or show inline error text.
Status: FIXED

---

AUDIT-06-004
Severity: LOW
Category: UI Completeness
File: lib/presentation/screens/health/health_sync_settings_screen.dart
Cross-cutting: lib/presentation/screens/notifications/notification_settings_screen.dart
Description: Both screens use error: (e, s) =>
  Center(child: Text('Error: $e')). Raw exception text,
  no user-friendly message, no retry button.
Fix approach: Replace with AppError.userMessage text
  and a retry button calling ref.invalidate(provider).
Status: FIXED

---

AUDIT-06-005
Severity: LOW
Category: UI Completeness
File: lib/presentation/screens/guest_invites/guest_invite_list_screen.dart
Cross-cutting: None
Description: Error state uses: error: (error, _) =>
  Center(child: Text('Failed to load invites: $error')).
  Raw error text exposed to user. No retry button.
Fix approach: Replace with AppError.userMessage text
  and a retry button calling ref.invalidate(provider).
Status: FIXED

---

## End of Pass 06 Findings

---

## Pass 07 — Test Quality
Date: 2026-03-02
Status: COMPLETE
Total findings: 4 (0 CRITICAL, 1 HIGH, 2 MEDIUM, 1 LOW)

Note: 210 test files examined. Testing discipline is
strong across the app. All mocks are build_runner
generated and current. All DAO tests use in-memory
databases with isolated state. Failure paths covered
for all critical use cases except those noted below.

---

AUDIT-07-001
Severity: HIGH
Category: Test Quality
File: test/integration/ (missing file)
Cross-cutting: lib/data/services/sync_service_impl.dart,
  lib/data/datasources/local/daos/ (all),
  lib/core/services/encryption_service.dart,
  lib/data/cloud/google_drive_provider.dart
Description: No integration test exercises the full
  sync flow end-to-end. test/integration/ contains
  only guest_profile_access_test.dart. The unit test
  sync_service_impl_test.dart tests SyncServiceImpl
  in isolation with all dependencies mocked — it does
  not catch integration failures between sync service,
  DAO, encryption, and cloud provider. A regression
  that breaks push or pull would not be caught by
  any automated test. Sync is the most critical data
  flow in the app.
Fix approach: Add test/integration/sync_flow_
  integration_test.dart using in-memory DB + mock
  CloudStorageProvider. Test: create entity →
  getPendingSync → pushChanges → mock cloud returns
  the change → pullChanges → applyChanges → verify
  entity marked clean and present in DB.
Status: FIXED (GROUP T — 5 integration tests added)

---

AUDIT-07-002
Severity: MEDIUM
Category: Test Quality
File: test/unit/domain/usecases/fluids_entries/
  (missing directory)
Cross-cutting: lib/domain/usecases/fluids_entries/
  log_fluids_entry_use_case.dart,
  lib/domain/usecases/fluids_entries/
  update_fluids_entry_use_case.dart,
  lib/domain/usecases/fluids_entries/
  delete_fluids_entry_use_case.dart,
  lib/domain/usecases/fluids_entries/
  get_fluids_entries_use_case.dart
Description: LogFluidsEntryUseCase and all related
  fluids entry use cases have no unit test file. All
  other CRUD use case families have test coverage
  under test/unit/domain/usecases/{entity}/. The
  fluids_entries directory is the only missing one.
  Widget tests provide indirect happy-path coverage
  only. No failure path, authorization failure, or
  edge case coverage exists.
Fix approach: Add test/unit/domain/usecases/
  fluids_entries/fluids_entry_usecases_test.dart.
  Cover happy path, repository failure,
  profile authorization failure, and edge cases
  for all four use cases in the family.
Status: FIXED (GROUP T — 14 unit tests added)

---

AUDIT-07-003
Severity: MEDIUM
Category: Test Quality
File: test/unit/domain/repositories/entity_repository_test.dart
Cross-cutting: test/unit/domain/repositories/
  supplement_repository_test.dart
Description: Both files (209 lines + 235 lines,
  53 tests total) test hand-written mock
  implementations that always return Success. Every
  test passes regardless of what real implementations
  do — these tests verify interface compilation, not
  behavior. They provide false confidence and inflate
  the test count by 53 without adding real coverage.
  Real implementation coverage already exists in the
  repository_impl tests.
Fix approach: Either (a) add a comment block making
  the limitation explicit and rename as interface
  contract tests, or (b) delete both files — coverage
  is redundant with existing repository impl tests.
Status: FIXED

---

AUDIT-07-004
Severity: LOW
Category: Test Quality
File: test/presentation/screens/health/health_sync_settings_screen_test.dart
Cross-cutting: None
Description: Tests 17 widget states but does not test
  the AsyncError state. Directly mirrors AUDIT-06-004
  (the screen shows raw exception text with no retry).
  When AUDIT-06-004 is fixed, a corresponding error
  state widget test should be added to verify the
  friendly error message and retry button render.
Fix approach: Add a testWidgets case that overrides
  the provider with an AsyncError state and verifies
  the error message and retry button are rendered.
  Defer addition until AUDIT-06-004 fix lands.
Status: FIXED (GROUP T — error state testWidgets added)

---

## End of Pass 07 Findings

---

## Pass 08 — Platform Compliance
Date: 2026-03-02
Status: COMPLETE
Total findings: 8 (1 CRITICAL, 4 HIGH, 1 MEDIUM, 2 LOW)

---

AUDIT-08-001
Severity: CRITICAL
Category: Platform Compliance
File: ios/Runner/PrivacyInfo.xcprivacy (MISSING)
Cross-cutting: ios/Runner.xcodeproj/project.pbxproj
Description: No PrivacyInfo.xcprivacy file exists for
  the app target. Apple has required this file for all
  App Store submissions since Spring 2024. Only
  pod/build-directory PrivacyInfo files exist — none
  is the app's own manifest. Without this file the
  submission will be rejected before review.
  Must declare: NSPrivacyTracking (false for Shadow),
  NSPrivacyAccessedAPITypes (UserDefaults, file
  timestamps), NSPrivacyCollectedDataTypes (health data).
Fix approach: Create ios/Runner/PrivacyInfo.xcprivacy
  with NSPrivacyTracking: false, appropriate
  NSPrivacyAccessedAPITypes, and
  NSPrivacyCollectedDataTypes for health data.
  Add to Xcode project via project.pbxproj.
Status: FIXED — 2026-03-02: ios/Runner/PrivacyInfo.xcprivacy created; registered in project.pbxproj

---

AUDIT-08-002
Severity: HIGH
Category: Platform Compliance
File: ios/Runner/Info.plist
Cross-cutting: None
Description: Four required NSUsageDescription keys
  are missing. image_picker is confirmed used in
  photo_picker_utils.dart and 4 screen files —
  requires NSCameraUsageDescription,
  NSPhotoLibraryUsageDescription, and
  NSPhotoLibraryAddUsageDescription. local_auth is
  confirmed used in security_settings_service.dart —
  requires NSFaceIDUsageDescription. Absence of
  NSFaceIDUsageDescription crashes the app on Face ID
  devices. Other missing keys cause silent permission
  denial for camera and photo library.
Fix approach: Add all four keys to Info.plist with
  meaningful user-facing descriptions that explain
  why the app needs each permission.
Status: FIXED — 2026-03-02: NSCameraUsageDescription, NSPhotoLibraryUsageDescription, NSPhotoLibraryAddUsageDescription, NSFaceIDUsageDescription added to ios/Runner/Info.plist.

---

AUDIT-08-003
Severity: HIGH
Category: Platform Compliance
File: android/app/src/main/AndroidManifest.xml
Cross-cutting: None
Description: android.permission.INTERNET is not
  declared. The app makes network calls for Google
  Drive sync, Google Sign-In, Open Food Facts, NIH
  DSLD, and Anthropic API. Without INTERNET declared,
  all network calls are blocked on Android — cloud
  sync and all API features fail silently.
Fix approach: Add <uses-permission
  android:name="android.permission.INTERNET"/> to
  AndroidManifest.xml.
Status: FIXED — 2026-03-02: android.permission.INTERNET added to AndroidManifest.xml.

---

AUDIT-08-004
Severity: HIGH
Category: Platform Compliance
File: android/app/src/main/AndroidManifest.xml
Cross-cutting: None
Description: android.permission.USE_BIOMETRIC and
  android.permission.USE_FINGERPRINT (for API < 28
  compatibility) are not declared. local_auth is
  confirmed in use for biometric lock. Without these
  permissions declared, biometric auth throws
  PlatformException on Android.
Fix approach: Add USE_BIOMETRIC and USE_FINGERPRINT
  permissions to AndroidManifest.xml.
Status: FIXED — 2026-03-02: android.permission.USE_BIOMETRIC and android.permission.USE_FINGERPRINT added to AndroidManifest.xml.

---

AUDIT-08-005
Severity: HIGH
Category: Platform Compliance
File: android/app/build.gradle.kts
Cross-cutting: android/app/src/main/AndroidManifest.xml
Description: minSdk = flutter.minSdkVersion resolves
  to 21 (Android 5.0). Health Connect requires API 26+
  (Android 8.0). Eight health permissions and a Health
  Connect intent filter are declared — these are
  non-functional or will crash on API 21-25 devices.
  App does not guard against unsupported API level
  at runtime.
Fix approach: Set minSdk = 26 explicitly in
  build.gradle.kts. Remove dependency on
  flutter.minSdkVersion default.
Status: FIXED — 2026-03-02: minSdk = 26 set explicitly in android/app/build.gradle.kts.

---

AUDIT-08-006
Severity: MEDIUM
Category: Platform Compliance
File: ios/Runner.xcodeproj/project.pbxproj
Cross-cutting: None
Description: IPHONEOS_DEPLOYMENT_TARGET = 13.0 in
  3 occurrences. App declares background modes and
  HealthKit background delivery requires iOS 15+.
  Recommend raising to 16.0 to align with app feature
  set and avoid runtime failures on iOS 13-15 devices
  using advanced HealthKit or background sync features.
Fix approach: Raise IPHONEOS_DEPLOYMENT_TARGET to
  16.0 in all three occurrences in project.pbxproj.
Status: FIXED — 2026-03-02: IPHONEOS_DEPLOYMENT_TARGET raised to 16.0 in all 3 occurrences in project.pbxproj.

---

AUDIT-08-007
Severity: LOW
Category: Platform Compliance
File: android/app/build.gradle.kts
Cross-cutting: None
Description: Flutter default TODO comment indicates
  release build is signed with debug keys. Play Store
  submissions require release signing. Launch checklist
  item — not a code bug but will block Play Store
  submission.
Fix approach: Configure release signing configuration
  before first Play Store submission.
Status: ACKNOWLEDGED — Launch checklist item. No code change. Reid configures release signing before Play Store submission.

---

AUDIT-08-008
Severity: LOW
Category: Platform Compliance
File: (no file — Play Console configuration)
Cross-cutting: None
Description: Google Play Data Safety declaration must
  be completed in Play Console before submission.
  Shadow collects health data — the form is mandatory.
  This is not a code change but a launch checklist item.
Fix approach: Complete the Data Safety form in Google
  Play Console before submitting to Play Store.
Status: ACKNOWLEDGED — External Play Console configuration. No code change. Reid completes Data Safety form before Play Store submission.

---

## End of Pass 08 Findings

---

## Pass 09 — Performance
Date: 2026-03-02
Status: COMPLETE
Total findings: 4 (0 CRITICAL, 1 HIGH, 2 MEDIUM, 1 LOW)

Note: No N+1 query patterns found. No provider
invalidation in loops. No database calls in build()
methods. ListView.builder/GridView.builder used
throughout for virtualization. Issues below are
contained to photo gallery, sync encryption batch,
and long-lived list pagination.

---

AUDIT-09-001
Severity: HIGH
Category: Performance
File: lib/presentation/screens/photos/photo_entries/photo_entry_gallery_screen.dart
Cross-cutting: lib/presentation/widgets/shadow_image.dart
Description: file.existsSync() — synchronous file
  system I/O — called in widget build paths.
  In photo_entry_gallery_screen.dart:118 it is called
  inside GridView.builder's itemBuilder for every
  visible tile (O(n) synchronous disk reads per frame
  during scroll). In shadow_image.dart:270 and :308,
  existsSync() is called inside _buildFileImage() and
  _buildPickerImage() during build. Synchronous file
  stat on the main thread blocks the UI thread.
Fix approach: Replace existsSync() with async exists()
  using FutureBuilder, or pre-compute file existence
  in the provider layer and pass a resolved result
  to the widget. Do not call synchronous file I/O
  in build() or itemBuilder.
Status: FIXED — 2026-03-03 GROUP PH. Replaced existsSync() with async exists() + FutureBuilder in photo_entry_gallery_screen.dart and shadow_image.dart

---

AUDIT-09-002
Severity: MEDIUM
Category: Performance
File: lib/presentation/screens/photos/photo_entries/photo_entry_gallery_screen.dart
Cross-cutting: lib/presentation/widgets/shadow_image.dart
Description: Photo gallery grid loads full-resolution
  images as thumbnails. Image.file(file, fit:
  BoxFit.cover) in _buildPhotoTile has no cacheWidth/
  cacheHeight constraints. ShadowImage widget correctly
  applies ResizeImage when cache dimensions are set,
  but the gallery screen bypasses ShadowImage and calls
  Image.file directly. On a phone with 300+ photos
  each visible tile loads a full-res file (typically
  200-500KB after processing), pressuring the image
  cache and increasing memory consumption.
Fix approach: Replace bare Image.file in _buildPhotoTile
  with ShadowImage.file (or add cacheWidth/cacheHeight
  constraints) sized to the grid tile dimensions.
Status: FIXED — 2026-03-03 GROUP PH. Replaced bare Image.file in _buildPhotoTile with ShadowImage.file(cacheWidth: 300, cacheHeight: 300)

---

AUDIT-09-003
Severity: MEDIUM
Category: Performance
File: lib/data/services/sync_service_impl.dart
Cross-cutting: lib/core/services/encryption_service.dart
Description: AES-256-GCM encryption runs on the main
  isolate during cloud sync push. sync_service_impl.dart
  lines 276-277 call await _encryptionService.encrypt(
  jsonString) in a for loop over every pending change.
  EncryptionService.encrypt() is declared async but
  contains no async gaps — all AES computation is
  synchronous work inside a Future. For a large sync
  batch (100+ entities after extended offline use),
  this executes synchronous crypto on the main thread.
  Contrast: BCrypt (PIN hashing) is correctly offloaded
  via Isolate.run() in security_settings_service.dart.
Fix approach: Wrap the encrypt/decrypt calls in
  Isolate.run() for batches above a threshold (e.g.
  20+ entities), or run the entire sync loop in a
  background isolate.
Status: OPEN

---

AUDIT-09-004
Severity: LOW
Category: Performance
File: lib/presentation/screens/journal/journal_entry_list_screen.dart
Cross-cutting: lib/presentation/screens/photos/photo_entries/photo_entry_gallery_screen.dart
Description: No pagination on long-lived list screens.
  All records load into memory. ListView.builder
  virtualizes rendering but the full Dart list is in
  memory. Journal entries accumulate over years of
  daily use (could reach thousands). Photo gallery
  loads all photo entries for the entire profile then
  filters by area in memory — a user with 5 photo
  areas has entries from all 5 areas loaded into a
  single provider, with 80% discarded client-side.
  Supplements, food items, and conditions are naturally
  bounded and are not a concern.
Fix approach (journal): Add date-range filter loading
  90 days initially with load-more on scroll.
Fix approach (photos): Filter by photoAreaId at the
  DAO/repository level rather than in the UI layer.
Status: OPEN

---

## End of Pass 09 Findings

---

## Convergence Pass A — Profile System End-to-End
Date: 2026-03-02
Status: COMPLETE
Total findings: 5 (0 CRITICAL, 1 HIGH, 3 MEDIUM, 1 LOW)

Note: Profile deletion cascade, guest invite revocation, and startup
resilience all have gaps. ProfileRepositoryImpl and the SyncEntityAdapter
for profiles ARE correctly implemented in bootstrap.dart — the gap is
entirely that ProfileNotifier in the UI layer bypasses the repository
(AUDIT-01-006 confirmed). AddEditProfileScreen is the only profile edit
form; AUDIT-06-002 scope confirmed correct.

---

AUDIT-CA-001
Severity: HIGH
Category: Profile System — Deletion Cascade
File: lib/presentation/providers/profile/profile_provider.dart
Cross-cutting: lib/presentation/screens/profiles/profiles_screen.dart,
  lib/domain/usecases/profiles/ (DeleteProfileUseCase MISSING),
  lib/data/datasources/local/ (all health data tables)
Description: deleteProfile(id) removes the profile entry from
  SharedPreferences only. It makes no call to any repository
  or DAO to delete associated health data. No DB CASCADE
  constraints exist on profileId columns in any health data
  table (supplements, conditions, food items, activity logs,
  sleep entries, fluids entries, journal entries, photo entries,
  condition logs, diet data, fasting sessions). There is no
  DeleteProfileUseCase. After deletion, all health data for
  that profileId remains permanently in the Drift database,
  orphaned and inaccessible. The user believes deletion
  is permanent but data persists indefinitely.
Fix approach: Implement DeleteProfileUseCase that (1) soft-
  deletes all health data by profileId across all entity tables
  before deleting the profile itself, or (2) relies on DB-level
  CASCADE if foreign key constraints are added. Also revoke
  all guest invites for the profile (see AUDIT-CA-002).
Status: OPEN

---

AUDIT-CA-002
Severity: MEDIUM
Category: Profile System — Guest Invite Lifecycle
File: lib/presentation/providers/profile/profile_provider.dart
Cross-cutting: lib/data/datasources/local/tables/guest_invites_table.dart,
  lib/domain/usecases/guest_invites/revoke_guest_invite_use_case.dart
Description: deleteProfile() makes no call to revoke guest
  invites for the deleted profile. The guest_invites table
  has no foreign key REFERENCES profiles(id) ON DELETE CASCADE.
  After a profile is deleted, any active guest invites for
  that profile remain with isRevoked = false. A guest device
  holding a valid token could still attempt sync operations
  targeting the orphaned profileId. Because profile data is
  in SharedPreferences (not Drift), a re-created profile with
  a new ID would not share the orphaned invite tokens, but
  the tokens remain stale in the database indefinitely.
Fix approach: In DeleteProfileUseCase (from AUDIT-CA-001),
  list all non-revoked guest invites for the profileId and
  revoke them before deleting the profile. Alternatively add
  FK CASCADE constraint to guest_invites.profile_id.
Status: OPEN

---

AUDIT-CA-003
Severity: MEDIUM
Category: Profile System — Startup Resilience
File: lib/presentation/providers/profile/profile_provider.dart
Cross-cutting: None
Description: ProfileNotifier._load() has no try/catch. If
  SharedPreferences returns a non-null but corrupt value for
  shadow_profiles (invalid JSON, missing required fields,
  wrong type on a field), jsonDecode() or Profile.fromJson()
  throws an unhandled exception. _load() is called from the
  constructor as a fire-and-forget (no await, no .catchError),
  so the exception becomes an unhandled async error. On
  Android, SharedPreferences writes are not atomic —
  a mid-write crash can corrupt the JSON blob. Result:
  the app loads with empty state silently and any subsequent
  _save() overwrites the corrupted data with an empty list,
  permanently deleting all profile names. No user feedback.
Fix approach: Wrap _load() body in try/catch(Object). On
  error: log the corruption, leave state as empty ProfileState.
  Optionally show a one-time "Profile data could not be loaded"
  message. The full fix is AUDIT-01-006 (move to Drift/SQLCipher
  which uses atomic WAL writes).
Status: FIXED

---

AUDIT-CA-004
Severity: MEDIUM
Category: Profile System — Fallback Safety
File: lib/presentation/screens/home/home_screen.dart
Cross-cutting: lib/presentation/screens/home/tabs/home_tab.dart
Description: When currentProfileId is null (no profile selected,
  or profile state not yet loaded), the HomeScreen and HomeTab
  fall back to the hardcoded string 'test-profile-001':
    state.currentProfileId ?? 'test-profile-001'
  All data tabs receive this ID and query the Drift database
  for it, returning empty results. The user sees empty screens
  with no prompt to create a profile and no error message.
  A new user who somehow reaches HomeScreen before creating
  a profile, or a user whose SharedPreferences is cleared,
  would see silent empty states across all 9 tabs with no
  recovery path visible. The fallback ID is a test artifact,
  not a meaningful sentinel value.
Fix approach: Replace the hardcoded fallback with a guard:
  if currentProfileId is null, show a "No profile selected"
  overlay or redirect to ProfilesScreen. Remove the
  'test-profile-001' string entirely from non-test code.
Status: OPEN

---

AUDIT-CA-005
Severity: LOW
Category: Profile System — Delete Dialog UX
File: lib/presentation/screens/profiles/profiles_screen.dart
Cross-cutting: None
Description: The delete profile confirmation dialog says
  "This cannot be undone" but does not warn the user that
  all health data associated with the profile (supplements,
  conditions, logs, photos, journal entries) will be deleted.
  Combined with AUDIT-CA-001 (data is currently NOT deleted),
  the dialog is misleading in the opposite direction —
  users may not realize the full scope of deletion.
  Once AUDIT-CA-001 is fixed and cascade deletion is
  implemented, the dialog must be updated to describe
  the data destruction scope explicitly.
Fix approach: Update dialog content to list the categories
  of data that will be permanently deleted. Add a bold
  warning line. Resolve after AUDIT-CA-001 is fixed.
Status: OPEN

---

## End of Convergence Pass A Findings

---

## Convergence Pass B — Diet Sync + Photo System Cross-Cut
Date: 2026-03-02
Status: COMPLETE
Total findings: 4 (0 CRITICAL, 0 HIGH, 4 MEDIUM, 0 LOW)

CONFIRMED (no new finding needed):
- Steps 1.2, 1.3, 1.4: Diet/DietViolation/FastingSession delete()
  all use _dao.softDelete() directly — same AUDIT-03-002 pattern.
  No new finding.
- No archive use case for Diet/DietViolation/FastingSession —
  double-increment pattern from AUDIT-03-003 cannot occur here.
- All three DAOs have correct getPendingSync() filtering on
  syncIsDirty=true.
- Step 2.3 existsSync audit: All synchronous file I/O instances
  are the same files already cataloged in AUDIT-09-001. Two new
  instances found (google_drive_provider.dart:363 in async
  upload fn, database.dart:402 in init debugPrint) are NOT in
  build() paths — no new finding.
- Step 2.2 photo save flows: Condition.baselinePhotoPath,
  ConditionLog.photoPath, and FluidsEntry.bowelPhotoPath are all
  correctly wired UI → input → use case → repository → DAO. The
  "silently discarded" pattern from AUDIT-10-006 (supplement label
  photos) does NOT appear for these entities.
- Step 2.4: No delete use case for Condition (archive only) or
  ConditionLog (no deletion path). Photo cleanup concern is limited
  to FlareUp (see AUDIT-CB-004 below).

---

AUDIT-CB-001
Severity: MEDIUM
Category: Diet Sync — markDirty Gap
File: lib/data/datasources/local/daos/diet_dao.dart
Cross-cutting: lib/data/repositories/diet_repository_impl.dart,
  lib/domain/usecases/diet/activate_diet_use_case.dart,
  lib/domain/usecases/diet/create_diet_use_case.dart
Description: DietDao.deactivateAll(profileId) writes
  DietsCompanion(isActive: Value(false)) with no
  syncIsDirty, syncUpdatedAt, or syncVersion update.
  Both setActive() and deactivate() in
  DietRepositoryImpl call deactivateAll() before
  updating the new active diet. The newly activated
  diet IS marked dirty (via prepareForUpdate). The
  previously active diet's deactivation (isActive:
  false) is NOT marked dirty. On another device,
  when the new active diet syncs, the old diet
  remains isActive=true — both diets appear active
  simultaneously until the other device takes
  independent action. This bug is currently dormant
  because AUDIT-02-003 means Diet sync adapters are
  not registered; it will activate once those
  adapters are added.
Fix approach: In DietDao.deactivateAll(), add
  syncIsDirty: const Value(true),
  syncUpdatedAt: Value(DateTime.now()
  .millisecondsSinceEpoch),
  syncStatus: Value(SyncStatus.modified.value)
  to the Companion write. Alternatively: deactivate
  one diet at a time via the repository update path
  (which calls prepareForUpdate) instead of a bulk
  DAO write.
Status: FIXED — 2026-03-02 GROUP S. DietDao.deactivateAll() now writes syncIsDirty=true,
  syncUpdatedAt=now, syncStatus=modified.value via customUpdate SQL bypassing Drift's
  soft-delete filter. Also added softDelete() + markSynced() to DietDao.

---

AUDIT-CB-002
Severity: MEDIUM
Category: Photo System — UI Gap
File: lib/presentation/screens/conditions/report_flare_up_screen.dart
Cross-cutting: lib/domain/usecases/flare_ups/flare_up_inputs.dart,
  lib/domain/entities/flare_up.dart
Description: FlareUp entity has a photoPath: String?
  field. LogFlareUpInput and UpdateFlareUpInput both
  declare a photoPath field. The data layer is fully
  wired to persist photos for flare-ups. However,
  report_flare_up_screen.dart has no _photoPath state
  variable and no photo picker widget. _saveNew()
  constructs LogFlareUpInput without photoPath,
  defaulting to null. _saveEdit() constructs
  UpdateFlareUpInput without photoPath, defaulting to
  null. A user cannot attach a photo to any flare-up
  from the UI — the feature is designed in the data
  layer but never exposed in the interface.
Fix approach: Add a photo picker section to
  report_flare_up_screen.dart using the existing
  PhotoPickerUtils pattern from condition_edit_screen
  and condition_log_screen. Pass _photoPath to both
  LogFlareUpInput and UpdateFlareUpInput.
Status: FIXED — 2026-03-03 GROUP PH. Added photo picker section to report_flare_up_screen.dart; _photoPath wired into LogFlareUpInput and UpdateFlareUpInput

---

AUDIT-CB-003
Severity: MEDIUM
Category: Photo System — UI Gap
File: lib/presentation/screens/fluids_entries/fluids_entry_screen.dart
Cross-cutting: lib/domain/usecases/fluids_entries/fluids_entry_inputs.dart,
  lib/domain/entities/fluids_entry.dart
Description: FluidsEntry entity has both
  bowelPhotoPath: String? and urinePhotoPath: String?
  fields. Both LogFluidsEntryInput and
  UpdateFluidsEntryInput declare both fields.
  fluids_entry_screen.dart implements a complete bowel
  photo picker (_bowelPhotoPath, picker widget, passed
  in save inputs). However, there is no
  _urinePhotoPath state variable and no urine photo
  picker anywhere in the screen. urinePhotoPath is
  always null in both inputs. The urine photo feature
  is half-implemented: complete in the data layer,
  missing entirely in the UI.
Fix approach: Add a urine photo picker section in
  fluids_entry_screen.dart, matching the existing
  bowel photo picker pattern. Pass _urinePhotoPath
  to both LogFluidsEntryInput and
  UpdateFluidsEntryInput.
Status: FIXED — 2026-03-03 GROUP PH. Added urine photo picker to fluids_entry_screen.dart matching bowel photo pattern; urinePhotoPath wired into both save inputs

---

AUDIT-CB-004
Severity: MEDIUM
Category: Photo System — File Cleanup
File: lib/domain/usecases/flare_ups/delete_flare_up_use_case.dart
Cross-cutting: lib/domain/entities/flare_up.dart,
  lib/core/services/photo_processing_service.dart
Description: DeleteFlareUpUseCase fetches the flare-up
  entity before deletion (the existing entity is
  available as a local variable) but does not read or
  delete FlareUp.photoPath. The use case calls only
  _repository.delete(input.id) — a soft-delete that
  marks the DB row deleted but leaves any associated
  photo file on disk permanently. Currently no
  flare-up can have a photoPath (AUDIT-CB-002),
  so there is no active data loss. However, when
  AUDIT-CB-002 is resolved and photos can be
  attached, every deleted flare-up will orphan its
  photo file indefinitely.
Fix approach: In DeleteFlareUpUseCase, after fetching
  the entity, if existing.photoPath != null, call
  File(existing.photoPath!).deleteSync() (or async
  equivalent) before or after the soft-delete.
  Consider a shared photo file cleanup utility since
  this pattern will recur across entity types.
Status: FIXED — 2026-03-03 GROUP PH. Added photo file cleanup to DeleteFlareUpUseCase before soft-delete

---

## End of Convergence Pass B Findings

---

## Pass 10 — Code Standards & Dead Code

**Date:** 2026-02-XX MST
**Scope:** Magic numbers, oversized files, dead code, unreachable paths
**Files reviewed:** All use cases, screens, DI providers
**New findings:** 6 (0 Critical, 1 High, 0 Medium, 5 Low)

---

AUDIT-10-001
Severity: LOW
Category: Code Standards & Dead Code
File: lib/domain/usecases/diet/get_compliance_stats_use_case.dart
Cross-cutting: None
Description: Magic number `violations.take(10)` at line 117.
  The business-logic cap of 10 recent violations has no named
  constant or explanatory comment.
Fix approach: Extract to named constant `_maxRecentViolations = 10`
  at top of class.
Status: FIXED

---

AUDIT-10-002
Severity: LOW
Category: Code Standards & Dead Code
File: lib/presentation/screens/diet/diet_dashboard_screen.dart
Cross-cutting: None
Description: Magic number `.take(5)` at line 235. The dashboard's
  5-violation display limit has no named constant.
Fix approach: Extract to named constant `_maxDashboardViolations = 5`.
Status: FIXED

---

AUDIT-10-003
Severity: LOW
Category: Code Standards & Dead Code
File: lib/presentation/screens/supplements/supplement_edit_screen.dart
Cross-cutting: None
Description: File is 1,634 lines — over the 800-line review
  threshold. Mixes form fields, barcode scanning, AI label scanning,
  photo management, and schedule builder in one file.
Fix approach: Extract sub-concerns into dedicated widget classes
  (schedule builder, photo section, barcode/AI scan actions).
Status: OPEN

---

AUDIT-10-004
Severity: LOW
Category: Code Standards & Dead Code
File: lib/presentation/screens/fluids/fluids_entry_screen.dart
Cross-cutting: None
Description: File is 1,337 lines — over the 800-line threshold.
Fix approach: Extract widget components to reduce file size.
Status: OPEN

---

AUDIT-10-005
Severity: LOW
Category: Code Standards & Dead Code
File: lib/presentation/screens/food/food_item_edit_screen.dart
Cross-cutting: None
Description: File is 1,131 lines — over the 800-line threshold.
Fix approach: Extract widget components to reduce file size.
Status: OPEN

---

AUDIT-10-006
Severity: HIGH
Category: Code Standards & Dead Code
File: lib/presentation/screens/supplements/supplement_edit_screen.dart
Cross-cutting: lib/di/di_providers.dart (line 514),
  lib/core/bootstrap.dart (line 461),
  lib/domain/usecases/supplements/add_supplement_label_photo_use_case.dart
Description: `addSupplementLabelPhotoUseCaseProvider` is defined in
  di_providers.dart (line 514) and `supplementLabelPhotoRepository`
  is overridden in bootstrap (line 461), but
  `addSupplementLabelPhotoUseCase` is never called anywhere in
  the codebase. supplement_edit_screen.dart maintains a
  `_labelPhotoPaths` list and renders a Label Photos UI section
  (up to 3 photos), but `_labelPhotoPaths` is never included in
  `UpdateSupplementInput` or `CreateSupplementInput` at save time.
  Label photos are silently discarded on every save — a silent
  data loss path.
Fix approach: Wire `_labelPhotoPaths` into the save flow by calling
  `addSupplementLabelPhotoUseCaseProvider` after supplement
  create/update. If the feature is intentionally deferred, remove
  the label photo UI section entirely and delete the dead provider
  wiring.
Status: FIXED — wired into save flow. `_handleSave()` now calls
  `addSupplementLabelPhotoUseCaseProvider` for each path in
  `_labelPhotoPaths` after create/update. Errors show a snackbar;
  supplement is still considered saved. `SupplementListProvider.create()`
  now returns `Future<Supplement>` so the new supplement's ID is available
  for the photo use case call. (Phase 18b, 2026-03-03)

---

## End of Pass 10 Findings

---

## Convergence Pass C — FlareUp System + Conditions Navigation Wiring

**Date:** 2026-03-02 MST
**Scope:** FlareUp screens/use cases/DAO, conditions tab navigation, ConditionLog wiring
**Files reviewed:** flare_up_list_screen.dart, report_flare_up_screen.dart,
  flare_up_list_provider.dart, log_flare_up_use_case.dart, update_flare_up_use_case.dart,
  delete_flare_up_use_case.dart, flare_up_dao.dart, flare_up_repository_impl.dart,
  conditions_tab.dart, condition_list_screen.dart, condition_log_screen.dart,
  condition_log_list_provider.dart, get_condition_logs_use_case.dart
**New findings:** 3 (0 Critical, 1 High, 2 Medium, 0 Low)

---

AUDIT-CC-001
Severity: MEDIUM
Category: UI Completeness — Missing Action
File: lib/presentation/screens/conditions/flare_up_list_screen.dart
Cross-cutting: lib/presentation/providers/flare_ups/flare_up_list_provider.dart
Description: FlareUpListScreen exposes no delete action for flare-up
  entries. The provider defines `delete(DeleteFlareUpInput)` (line 113)
  and the underlying use case and soft-delete path are correctly
  implemented, but no delete button, swipe-to-delete, or context menu
  exists in the list screen. Tapping a card opens the edit sheet, which
  has no delete option either. Users have no way to remove a flare-up
  from within the app.
Fix approach: Add a delete action to the edit sheet (ReportFlareUpScreen)
  or to the card's trailing options in FlareUpListScreen. Include a
  confirmation dialog before calling the provider's delete() method.
Status: FIXED

---

AUDIT-CC-002
Severity: HIGH
Category: Navigation Wiring — Unreachable Screen
File: lib/presentation/screens/condition_logs/condition_log_screen.dart
Cross-cutting: lib/presentation/providers/condition_logs/condition_log_list_provider.dart,
  lib/domain/usecases/condition_logs/log_condition_use_case.dart
Description: ConditionLogScreen is fully implemented (create + edit,
  photo picker, trigger chips, severity slider, dirty-state guard) but
  is not imported or navigated to from any other file in the codebase.
  A grep for `ConditionLogScreen` returns only the screen's own file.
  The conditions_tab.dart and condition_list_screen.dart both have no
  entry point to log a daily condition entry. The full condition-logging
  use case (log_condition_use_case.dart) and ConditionLogList provider
  are likewise unreachable via the UI. This is the primary daily-tracking
  feature for conditions and is silently inaccessible to users.
Fix approach: Wire ConditionLogScreen into the conditions navigation.
  Most natural entry: add a "Log Entry" action from each condition card
  in conditions_tab.dart or condition_list_screen.dart, navigating with
  Navigator.push(context, MaterialPageRoute(builder: (_) =>
  ConditionLogScreen(profileId: profileId, condition: condition))).
Status: FIXED

---

AUDIT-CC-003
Severity: MEDIUM
Category: UI Completeness — Non-Functional Stub
File: lib/presentation/screens/conditions/condition_list_screen.dart
Cross-cutting: None
Description: `_FilterBottomSheet` (lines 376–421) renders two Switch
  widgets both hardcoded to `value: true` with `onChanged: (value) {}`
  (no-op). The "Apply" button calls `Navigator.pop(context)` only —
  no filter state is read, stored, or applied to the condition list.
  The filter UI is purely cosmetic. Tapping "Filter" gives users the
  impression they are adjusting the displayed conditions, but the list
  is unaffected in all cases.
Fix approach: Either (a) implement actual filter state (show archived,
  active-only) driving the condition list query, or (b) remove the
  filter button and bottom sheet until the feature is ready for
  implementation.
Status: FIXED

---

## End of Convergence Pass C Findings

---

## Convergence Pass D — Unreachable Screens + Dead Use Case Wiring Sweep
Date: 2026-03-02
Status: COMPLETE
Total findings: 4 (0 CRITICAL, 2 HIGH, 1 MEDIUM, 1 LOW)

---

AUDIT-CD-001
Severity: HIGH
Category: Navigation Wiring — Unreachable Screen
File: lib/presentation/screens/activity_logs/activity_log_screen.dart
Cross-cutting: lib/presentation/providers/activity_logs/activity_log_list_provider.dart,
  lib/presentation/screens/home/tabs/activities_tab.dart
Description: ActivityLogScreen is fully implemented (create + edit,
  timestamp picker, activity multi-select, ad-hoc activities, duration,
  notes, dirty-state guard) but is not imported or navigated to from
  any screen except via activity_quick_entry_sheet.dart (notification
  path only). The ActivitiesTab shows activity definitions (with
  ActivityEditScreen), but has no FAB or action to log an activity
  occurrence. Users can only log an activity via a notification quick-
  entry sheet; the full log screen is inaccessible from the main nav.
  Same pattern as AUDIT-CC-002 (ConditionLogScreen unreachable).
Fix approach: Add a "Log Activity" FAB or per-card action in
  ActivitiesTab navigating to ActivityLogScreen. Alternatively, add a
  dedicated "Activity Logs" history view reachable from the tab.
Status: FIXED

---

AUDIT-CD-002
Severity: HIGH
Category: Navigation Wiring — Unreachable Screen
File: lib/presentation/screens/diet/fasting_timer_screen.dart
Cross-cutting: lib/presentation/screens/diet/diet_dashboard_screen.dart,
  lib/presentation/screens/diet/diet_list_screen.dart
Description: FastingTimerScreen is fully implemented (active fasting
  session display with timer, end-fast action) but is not imported or
  navigated to from any other file in the codebase. A grep for
  `FastingTimerScreen` returns only the screen's own file. The diet
  feature has DietDashboardScreen and DietListScreen but neither
  navigates to the fasting timer. Users have no UI path to view or
  manage an active fasting session.
  Same pattern as AUDIT-CC-002 (ConditionLogScreen unreachable).
Fix approach: Wire FastingTimerScreen into DietDashboardScreen or
  DietListScreen. Most natural entry: a "View Timer" button or card
  that is conditionally visible when an active fasting session exists,
  navigating with Navigator.push to FastingTimerScreen(profileId).
Status: FIXED

---

AUDIT-CD-003
Severity: MEDIUM
Category: Dead DI Wiring — Provider Never Called
File: lib/presentation/providers/di/di_providers.dart
Cross-cutting: lib/domain/usecases/health/get_imported_vitals_use_case.dart,
  lib/presentation/providers/health/health_sync_provider.dart
Description: `getImportedVitalsUseCaseProvider` is registered in
  di_providers.dart (line 1190) and overridden in bootstrap.dart, but
  is never referenced outside di_providers.dart. The
  health_sync_provider.dart does not consume it, and no screen or
  provider reads the imported vitals through this use case.
  Same pattern as AUDIT-10-006 (addSupplementLabelPhotoUseCaseProvider).
Fix approach: Either wire the use case into the health sync provider so
  imported vitals are surfaced in the UI, or document that this use case
  is intentionally deferred (Phase 3 / future health platform work).
Status: FIXED

---

AUDIT-CD-004
Severity: LOW
Category: Dead Domain Code — Use Case Never Wired to DI
File: lib/domain/usecases/fluids_entries/get_fluids_entries_use_case.dart
Cross-cutting: lib/presentation/screens/reports/bbt_chart_screen.dart,
  lib/presentation/providers/di/di_providers.dart
Description: `GetBBTEntriesUseCase` is defined in the domain layer
  (get_fluids_entries_use_case.dart) with a corresponding
  `GetBBTEntriesInput` type. It is never registered in di_providers.dart
  and never called anywhere in the codebase. BBTChartScreen loads BBT
  data by reading fluids_entry_list_provider directly, bypassing the
  dedicated use case entirely. The use case is dead code.
Fix approach: Either (a) register GetBBTEntriesUseCase in di_providers.dart
  and wire BBTChartScreen through the use case (preferred — maintains
  layer boundaries), or (b) delete the unused use case and input type.
Status: FIXED

---

## End of Convergence Pass D Findings

---
