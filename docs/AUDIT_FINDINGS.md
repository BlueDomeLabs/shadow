# AUDIT_FINDINGS.md
# Shadow — Final Pre-Launch Audit Findings Register
# Status: IN PROGRESS
# Last Updated: 2026-03-02

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
Status: OPEN

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
Status: OPEN

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
Status: OPEN

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
Status: OPEN

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
Status: OPEN

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
Status: OPEN

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
Status: OPEN

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
Status: OPEN

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
Status: OPEN

---

## End of Pass 04 Findings

---
