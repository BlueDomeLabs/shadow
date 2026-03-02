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
