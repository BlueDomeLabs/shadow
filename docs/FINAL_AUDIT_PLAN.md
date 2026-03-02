# FINAL_AUDIT_PLAN.md
# Shadow — Final Pre-Launch Code Review
# Orchestrated by: Architect (Claude.ai)
# Executed by: Shadow (Claude Code CLI)
# Status: NOT STARTED

## Philosophy

This review follows a multi-pass, cross-cutting audit
methodology. Each pass examines the entire codebase
through a single focused lens. Findings are cataloged
first; fixes happen only after all passes reach
convergence.

Rules:
- Shadow reads and reports only — no fixes during audit
- Each pass produces a structured findings report
- Architect catalogs all findings into AUDIT_FINDINGS.md
- Passes repeat until convergence (no new findings)
- Excluded from scope: Phase 3 (Intelligence System,
  42_INTELLIGENCE_SYSTEM.md) and Phase 4 wearables/FHIR
  (43_WEARABLE_INTEGRATION.md partial) — these are
  intentional future development, not gaps

## Findings Severity Levels

- CRITICAL: Data loss, security vulnerability, crash risk
- HIGH: Incorrect behavior, silent failure, wrong data
- MEDIUM: Missing state, inconsistent pattern, UX gap
- LOW: Style, naming, dead code, stale comment

## Master Findings Register

All findings go into: docs/AUDIT_FINDINGS.md

Each finding entry format:
  ID: AUDIT-{pass}-{sequence} (e.g. AUDIT-01-003)
  Severity: CRITICAL | HIGH | MEDIUM | LOW
  Category: (pass name)
  File(s): primary file(s) affected
  Cross-cutting: other files affected by same issue
  Description: what is wrong
  Evidence: specific line/method/pattern
  Fix approach: what needs to change (not how to code it)
  Status: OPEN | FIXED | WONT_FIX

---

## Pass 01 — Architecture & Layer Boundaries

**Lens:** Does the layered architecture hold? Are
dependencies flowing in the right direction?

**What to check:**
- Domain layer files (lib/domain/) must not import from
  lib/data/ or lib/presentation/
- Data layer files (lib/data/) must not import from
  lib/presentation/
- Use cases must not directly instantiate repositories
  (must receive via constructor injection)
- Repositories must not import Riverpod providers
- Entities must not import DAOs or services
- No Flutter framework imports in domain layer
  (no material.dart, no widgets)
- Provider files must not contain business logic
  (should delegate to use cases)
- Bootstrap.dart is the only permitted place for
  concrete instantiation

**Files to examine:**
- All files under lib/domain/ (entities, repositories,
  usecases, services, enums)
- All files under lib/data/repositories/
- All files under lib/presentation/providers/
- lib/core/bootstrap.dart

**Output format:**
For each violation found, record:
  AUDIT-01-{sequence}: [severity] [file] — [description]

Then a summary: X findings, breakdown by severity.

---

## Pass 02 — Schema → Entity → DAO → Repository Alignment

**Lens:** Does every database column have a corresponding
entity field? Does every entity field get persisted?
Is every DAO method exposed through the repository?

**What to check:**
- For each of the 14 synced entities: compare table
  definition (tables/*.dart) → entity (entities/*.dart)
  → DAO (daos/*.dart) → repository impl
  (repositories/*_impl.dart)
- Every table column must map to an entity field
- Every entity field must be written/read in DAO
- Every DAO method must have a corresponding repository
  method (or justified reason for absence)
- Schema version in database.dart must match highest
  migration number
- Every migration must be additive (no DROP without
  corresponding CREATE)
- Local-only tables (health_sync_settings,
  health_sync_status, user_settings) are exempt from
  sync requirements but must still align entity→DAO

**Files to examine:**
- lib/data/datasources/local/tables/ (all files)
- lib/domain/entities/ (all files)
- lib/data/datasources/local/daos/ (all files)
- lib/data/repositories/ (all *_impl.dart files)
- lib/data/datasources/local/database.dart (migrations)

**Output format:**
For each entity, report: ALIGNED or list of gaps.
Then all findings in AUDIT-02-{sequence} format.

---

## Pass 03 — Sync Correctness

**Lens:** Is cloud sync wired completely and correctly
for all 14 syncable entities?

**What to check:**
- All 14 SyncEntityAdapter registrations in bootstrap.dart
- Every entity's update() path calls markDirty: true
  (or has explicit justification for false)
- Every entity's delete() path sets isDeleted=true
  and markDirty=true (soft delete, not hard delete)
- Every repository's getPendingSync() returns dirty
  records correctly
- profileId filtering applied in all repository queries
  that return lists
- clientId generated at entity creation (not null)
- syncMetadata.initial() used at creation
- markEntitySynced() clears dirty flag correctly
- SyncConflict detection: applyChanges() handles
  insert/overwrite/conflict correctly for all entity types
- No entity hard-deletes a row that should be soft-deleted

**Files to examine:**
- lib/core/bootstrap.dart (adapter registrations)
- lib/data/repositories/ (all *_impl.dart)
- lib/data/datasources/local/daos/ (all files)
- lib/data/services/sync_service_impl.dart

**Output format:**
AUDIT-03-{sequence} format. Flag any entity missing
from sync adapters as CRITICAL.

---

## Pass 04 — Error Handling & Result Type

**Lens:** Are failures handled everywhere? Are Results
ever ignored? Are there silent failure paths?

**What to check:**
- Every Result<T, AppError> return value is either:
  (a) checked with .isSuccess/.isFailure, or
  (b) returned up the call chain
- No .valueOrNull! used without prior isSuccess check
- No bare try/catch that swallows exceptions without
  logging or returning a Failure
- Every use case that can fail returns Result
- Every repository method that can fail returns Result
- Provider error states surfaced to UI (not silently
  dropped)
- AppError types used appropriately (DatabaseError for
  DB failures, NetworkError for API, etc.)
- No generic Exception thrown where AppError should be used
- Error messages contain enough context to debug

**Files to examine:**
- lib/data/repositories/ (all *_impl.dart)
- lib/domain/usecases/ (all files)
- lib/presentation/providers/ (all files)
- lib/core/ (error types)

**Output format:**
AUDIT-04-{sequence} format. Unhandled Result or
swallowed exception = at minimum HIGH severity.

---

## Pass 05 — Security & Privacy

**Lens:** Is sensitive data protected? Are there any
exposure risks?

**What to check:**
- No PII (names, health data, email) written to
  logger/print statements
- All encryption done via EncryptionService
  (not raw encrypt package calls)
- FlutterSecureStorage used for all secrets
  (no SharedPreferences for sensitive data)
- Google OAuth client_secret situation: is it
  embedded in the app? If so, document the risk
- No hardcoded API keys or tokens in source
- Database encryption: sqlcipher_flutter_libs in use
- Health data never sent to third-party servers
  (only user's own Drive/iCloud)
- Guest token validation enforces one-device limit
- PIN/biometric auth cannot be bypassed
- No sensitive data in URL parameters or logs

**Files to examine:**
- lib/core/services/encryption_service.dart
- lib/core/bootstrap.dart
- lib/data/services/ (all service impls)
- lib/presentation/providers/ (auth providers)
- lib/core/services/logger_service.dart
- Any file importing FlutterSecureStorage or
  SharedPreferences

**Output format:**
AUDIT-05-{sequence} format. Any PII exposure or
hardcoded secret = CRITICAL.

---

## Pass 06 — UI Completeness

**Lens:** Does every screen handle all states correctly?

**What to check:**
- Every screen that loads async data has:
  (a) loading state (spinner or skeleton)
  (b) error state (message + retry option)
  (c) empty state (message, not blank screen)
- Every form has:
  (a) validation before submit
  (b) loading indicator during save
  (c) error feedback on failure
  (d) success feedback on completion
- No screen shows a blank white screen in any state
- Destructive actions (delete) have confirmation dialog
- Navigation after save goes to correct destination
- Back navigation doesn't lose unsaved data silently
  (warn user or auto-save)
- Pull-to-refresh where lists are shown

**Files to examine:**
- lib/presentation/screens/ (all screen files)

**Output format:**
Per screen: COMPLETE or list of missing states.
Then all findings in AUDIT-06-{sequence} format.

---

## Pass 07 — Test Quality

**Lens:** Are tests actually verifying correct behavior?

**What to check:**
- Tests assert on outcomes, not on mock call counts
  alone (verify() without an assertion is weak)
- No test that will always pass regardless of
  implementation (e.g. expect(true, true))
- Mock setup matches actual interface signatures
  (stale mocks that don't match current interfaces)
- Happy path AND at least one failure path tested
  for every use case
- Widget tests pump enough frames (pumpAndSettle
  where async involved)
- No test importing implementation details that
  should be private
- Database tests use in-memory database, not production
- Tests clean up after themselves (no shared state
  between tests)
- Critical paths (sync, encryption, auth) have
  integration-level coverage

**Files to examine:**
- test/ (all files, systematically)

**Output format:**
AUDIT-07-{sequence} format. Always-passing test = HIGH.
Missing failure path on critical feature = HIGH.

---

## Pass 08 — Platform Compliance

**Lens:** Are iOS and Android platform requirements met?

**What to check:**
- iOS Info.plist: all required usage descriptions present
  for every permission requested at runtime
- iOS entitlements: match capabilities actually used
- Android AndroidManifest.xml: all permissions declared
- Android: Health Connect intent filter present
- Background modes: only modes actually used are declared
- App transport security: no cleartext HTTP
- No deprecated API usage that will be rejected by
  App Store
- Privacy manifest (required by Apple since 2024):
  does the project have one?
- Google OAuth: redirect URI scheme registered
- Push notifications: APNs configured correctly

**Files to examine:**
- ios/Runner/Info.plist
- ios/Runner/Runner.entitlements
- ios/Runner.xcodeproj/project.pbxproj
- android/app/src/main/AndroidManifest.xml
- android/app/build.gradle
- pubspec.yaml (permission-related packages)

**Output format:**
AUDIT-08-{sequence} format. Missing privacy manifest
or required usage description = CRITICAL.

---

## Pass 09 — Performance

**Lens:** Are there patterns that will cause
performance problems at scale?

**What to check:**
- No database queries inside build() methods
- No synchronous I/O on the main thread
- Lists with potentially large datasets use
  pagination or lazy loading
- Images loaded with caching (not re-fetched each build)
- No StreamBuilder rebuilding the entire widget tree
  on every event
- Providers with keepAlive: true are justified
  (not overused)
- No unnecessary provider invalidation in loops
- Drift queries use indexes where filtering on
  indexed columns
- No N+1 query patterns (loading list then
  fetching each item individually)
- Heavy computations (encryption, compression)
  done off main isolate where possible

**Files to examine:**
- lib/presentation/screens/ (all screen files)
- lib/presentation/providers/ (all provider files)
- lib/data/repositories/ (all impl files)
- lib/data/datasources/local/daos/ (all DAO files)

**Output format:**
AUDIT-09-{sequence} format. N+1 query or sync I/O
on main thread = HIGH.

---

## Pass 10 — Code Standards & Dead Code

**Lens:** Is the codebase clean and maintainable?

**What to check:**
- No TODO/FIXME/HACK comments remaining in production
  code (legitimate future work should be in DECISIONS.md)
- No commented-out code blocks
- No unreachable code paths
- No unused imports
- No unused variables or parameters
- Public API methods have doc comments
- Consistent naming: camelCase for variables/methods,
  PascalCase for classes, snake_case for files
- No magic numbers (use named constants)
- No duplicate logic that should be extracted
- File length reasonable (<500 lines; flag >500
  for review)
- No circular dependencies between files

**Files to examine:**
- lib/ (all files)

**Output format:**
AUDIT-10-{sequence} format. Commented-out code or
duplicate logic = MEDIUM. Missing doc on public API = LOW.

---

## Convergence Protocol

After all 10 passes:

1. Architect reviews AUDIT_FINDINGS.md for cross-cutting
   patterns
2. If any pass-N finding reveals a gap that should have
   been caught by pass-M, run targeted pass-M follow-up
3. Repeat until two consecutive review cycles add
   zero new findings
4. Architect declares convergence and produces
   FIX_PLAN.md grouping findings by fix complexity:
   - Quick fixes (< 30 min): batch into single session
   - Medium fixes (30-120 min): one session each
   - Complex fixes (schema change, architecture):
     dedicated phase

## Execution Status

| Pass | Name | Status | Findings | Date |
|------|------|--------|----------|------|
| 01 | Architecture & Layer Boundaries | NOT STARTED | — | — |
| 02 | Schema → Entity → DAO → Repository | NOT STARTED | — | — |
| 03 | Sync Correctness | NOT STARTED | — | — |
| 04 | Error Handling & Result Type | NOT STARTED | — | — |
| 05 | Security & Privacy | NOT STARTED | — | — |
| 06 | UI Completeness | NOT STARTED | — | — |
| 07 | Test Quality | NOT STARTED | — | — |
| 08 | Platform Compliance | NOT STARTED | — | — |
| 09 | Performance | NOT STARTED | — | — |
| 10 | Code Standards & Dead Code | NOT STARTED | — | — |

## Notes for Architect

- Run one pass per Shadow session
- Always /compact Shadow before each session
- After each pass: sync GitHub → Project Knowledge
  before reviewing findings
- AUDIT_FINDINGS.md is append-only during audit phase
- Do not instruct Shadow to fix anything until
  Architect declares convergence
- Shadow reports findings to Architect in chat;
  Architect maintains the master catalog
