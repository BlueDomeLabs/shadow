# Shadow Project Tracker

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Daily task assignments in project tracking format

> **CANONICAL SOURCE:** All implementation details must follow [02_CODING_STANDARDS.md](02_CODING_STANDARDS.md). Before creating or updating tickets, review the applicable coding standards sections. See [22_API_CONTRACTS.md](22_API_CONTRACTS.md) for exact interface specifications.

---

## 1. Project Tracking System

### 1.1 Ticket Structure

```
SHADOW-{number}: {Title}
├── Type: Task | Bug | Feature | Spike
├── Status: Backlog | Ready | In Progress | In Review | Done
├── Assignee: {Engineer Name}
├── Sprint: {Sprint Number}
├── Priority: P0 (Critical) | P1 (High) | P2 (Medium) | P3 (Low)
├── Story Points: 1 | 2 | 3 | 5 | 8
├── Labels: [team-name] [phase] [component]
├── Blocked By: SHADOW-{number} (if any)
├── Blocks: SHADOW-{number} (if any)
├── Due Date: YYYY-MM-DD
├── Description: {Detailed description}
├── Acceptance Criteria: {Checklist}
├── Technical Notes: {Implementation guidance}
└── Coordination: {Who to notify when done}
```

### 1.2 Board Columns

```
┌─────────────┬─────────────┬─────────────┬─────────────┬─────────────┐
│   BACKLOG   │    READY    │ IN PROGRESS │  IN REVIEW  │    DONE     │
├─────────────┼─────────────┼─────────────┼─────────────┼─────────────┤
│ Not yet     │ Dependencies│ Actively    │ PR open,    │ Merged to   │
│ ready to    │ met, ready  │ being       │ awaiting    │ develop,    │
│ start       │ to pick up  │ worked on   │ review      │ verified    │
└─────────────┴─────────────┴─────────────┴─────────────┴─────────────┘
```

---

## 2. Sprint 1 Tickets (Weeks 1-2)

### SHADOW-001: Initialize Flutter Project

```yaml
Type: Task
Status: Ready
Assignee: Core-1
Sprint: 1
Priority: P0
Story Points: 3
Labels: [core-team] [phase-0] [setup]
Blocked By: None
Blocks: SHADOW-002, SHADOW-003, SHADOW-008
Due Date: 2026-02-02

Description: |
  Create new Flutter project with multi-platform support.
  Configure for iOS, Android, and macOS builds.

Acceptance Criteria:
  - [ ] Project created with `flutter create --org com.bluedomecolorado shadow_app`
  - [ ] iOS build succeeds: `flutter build ios --debug`
  - [ ] Android build succeeds: `flutter build android --debug`
  - [ ] macOS build succeeds: `flutter build macos --debug`
  - [ ] Git repository initialized with .gitignore
  - [ ] Initial commit pushed to main branch

Technical Notes: |
  Run: flutter create --org com.bluedomecolorado shadow_app
  Enable desktop: flutter config --enable-macos-desktop
  Verify: flutter doctor

Coordination: |
  When complete, post in #shadow-engineering:
  "@core-team Project initialized. SHADOW-002, SHADOW-003 ready to start."
```

---

### SHADOW-002: Create Folder Structure

```yaml
Type: Task
Status: Backlog
Assignee: Core-1
Sprint: 1
Priority: P0
Story Points: 1
Labels: [core-team] [phase-0] [setup]
Blocked By: SHADOW-001
Blocks: SHADOW-005, SHADOW-006, SHADOW-009, SHADOW-010, SHADOW-012
Due Date: 2026-02-03

Description: |
  Create Clean Architecture folder structure per 04_ARCHITECTURE.md.

Acceptance Criteria:
  - [ ] lib/core/config/ created
  - [ ] lib/core/errors/ created
  - [ ] lib/core/services/ created
  - [ ] lib/core/types/ created
  - [ ] lib/core/utils/ created
  - [ ] lib/domain/entities/ created
  - [ ] lib/domain/repositories/ created
  - [ ] lib/domain/usecases/ created
  - [ ] lib/data/repositories/ created
  - [ ] lib/data/datasources/local/ created
  - [ ] lib/data/models/ created
  - [ ] lib/presentation/screens/ created
  - [ ] lib/presentation/widgets/ created
  - [ ] lib/presentation/providers/ created
  - [ ] lib/presentation/theme/ created
  - [ ] lib/l10n/ created
  - [ ] Each folder has .gitkeep or placeholder file

Technical Notes: |
  Follow structure in 04_ARCHITECTURE.md Section 2.
  Create placeholder README.md in each folder explaining purpose.

Coordination: |
  When complete, post: "Folder structure ready. Core services can begin."
```

---

### SHADOW-003: Add Core Dependencies

```yaml
Type: Task
Status: Backlog
Assignee: Core-2
Sprint: 1
Priority: P0
Story Points: 2
Labels: [core-team] [phase-0] [setup]
Blocked By: SHADOW-001
Blocks: SHADOW-004, SHADOW-011
Due Date: 2026-02-03

Description: |
  Add all required dependencies to pubspec.yaml per 05_IMPLEMENTATION_ROADMAP.md.

Acceptance Criteria:
  - [ ] flutter_riverpod: ^2.4.9 added
  - [ ] riverpod_annotation: ^2.3.3 added
  - [ ] freezed_annotation: ^2.4.1 added
  - [ ] json_annotation: ^4.8.1 added
  - [ ] drift: ^2.14.1 added
  - [ ] sqlite3_flutter_libs: ^0.5.18 added
  - [ ] flutter_secure_storage: ^9.0.0 added
  - [ ] uuid: ^4.2.1 added
  - [ ] logger: ^2.0.2 added
  - [ ] google_sign_in: ^6.1.6 added
  - [ ] Dev dependencies: freezed, json_serializable, drift_dev, riverpod_generator, build_runner
  - [ ] `flutter pub get` succeeds
  - [ ] No dependency conflicts

Technical Notes: |
  Copy exact versions from 05_IMPLEMENTATION_ROADMAP.md Phase 0.
  Run `flutter pub get` and resolve any conflicts.

Coordination: |
  When complete, post: "Dependencies installed. SHADOW-004 ready."
```

---

### SHADOW-004: Configure Code Generation

```yaml
Type: Task
Status: Backlog
Assignee: Core-2
Sprint: 1
Priority: P0
Story Points: 3
Labels: [core-team] [phase-0] [setup]
Blocked By: SHADOW-003
Blocks: SHADOW-007, SHADOW-008, SHADOW-015
Due Date: 2026-02-04

Description: |
  Configure Freezed, Drift, and Riverpod code generation.
  Verify build_runner works correctly.

Acceptance Criteria:
  - [ ] build.yaml configured for freezed
  - [ ] Sample freezed class generates correctly
  - [ ] Sample drift database generates correctly
  - [ ] Sample riverpod provider generates correctly
  - [ ] `dart run build_runner build` completes without errors
  - [ ] Generated files have .freezed.dart, .g.dart extensions
  - [ ] .gitignore updated to NOT ignore generated files (we commit them)

Technical Notes: |
  Create test files:
  - lib/domain/entities/_test_entity.dart (freezed)
  - lib/data/datasources/local/_test_database.dart (drift)
  - lib/presentation/providers/_test_provider.dart (riverpod)

  Run: dart run build_runner build --delete-conflicting-outputs
  Delete test files after verification.

Coordination: |
  When complete, post: "Code generation working. All entity work can begin."
```

---

### SHADOW-005: Implement Result Type

```yaml
Type: Task
Status: Backlog
Assignee: Core-1
Sprint: 1
Priority: P0
Story Points: 2
Labels: [core-team] [phase-0] [types]
Blocked By: SHADOW-002
Blocks: SHADOW-006
Due Date: 2026-02-04

Description: |
  Implement Result<T, E> sealed class per 22_API_CONTRACTS.md Section 1.

Acceptance Criteria:
  - [ ] lib/core/types/result.dart created
  - [ ] sealed class Result<T, E> implemented
  - [ ] Success<T, E> class implemented
  - [ ] Failure<T, E> class implemented
  - [ ] isSuccess getter works
  - [ ] isFailure getter works
  - [ ] valueOrNull getter works
  - [ ] errorOrNull getter works
  - [ ] when() method works with success/failure callbacks
  - [ ] Unit tests: test/core/types/result_test.dart
  - [ ] 100% test coverage on Result type

Technical Notes: |
  EXACT implementation from 22_API_CONTRACTS.md:

  sealed class Result<T, E> {
    const Result();
    bool get isSuccess => this is Success<T, E>;
    bool get isFailure => this is Failure<T, E>;
    T? get valueOrNull => isSuccess ? (this as Success<T, E>).value : null;
    E? get errorOrNull => isFailure ? (this as Failure<T, E>).error : null;
    R when<R>({
      required R Function(T value) success,
      required R Function(E error) failure,
    }) { ... }
  }

Coordination: |
  When complete, post: "Result type ready. Error classes can begin."
```

---

### SHADOW-006: Implement AppError Hierarchy

```yaml
Type: Task
Status: Backlog
Assignee: Core-1
Sprint: 1
Priority: P0
Story Points: 3
Labels: [core-team] [phase-0] [errors]
Blocked By: SHADOW-005
Blocks: SHADOW-007, All repository work
Due Date: 2026-02-06

Description: |
  Implement all error classes per 22_API_CONTRACTS.md Section 2.

Acceptance Criteria:
  - [ ] lib/core/errors/app_error.dart - Base sealed class
  - [ ] lib/core/errors/database_error.dart - All DB error codes
  - [ ] lib/core/errors/auth_error.dart - All auth error codes
  - [ ] lib/core/errors/network_error.dart - All network error codes
  - [ ] lib/core/errors/validation_error.dart - With fieldErrors map
  - [ ] lib/core/errors/sync_error.dart - All sync error codes
  - [ ] Each error has factory constructors
  - [ ] Error codes are static const strings
  - [ ] Unit tests for all error classes
  - [ ] 100% test coverage

Technical Notes: |
  Use EXACT error codes from 22_API_CONTRACTS.md:
  - DatabaseError: DB_QUERY_FAILED, DB_INSERT_FAILED, DB_NOT_FOUND, etc.
  - AuthError: AUTH_UNAUTHORIZED, AUTH_TOKEN_EXPIRED, etc.
  - NetworkError: NET_NO_CONNECTION, NET_TIMEOUT, etc.
  - ValidationError: VAL_REQUIRED, VAL_INVALID_FORMAT, etc.
  - SyncError: SYNC_CONFLICT, SYNC_UPLOAD_FAILED, etc.

Coordination: |
  When complete, post: "Error hierarchy complete. Repository work unblocked."
```

---

### SHADOW-007: Implement BaseRepository

```yaml
Type: Task
Status: Backlog
Assignee: Core-2
Sprint: 1
Priority: P1
Story Points: 2
Labels: [core-team] [phase-0] [repository]
Blocked By: SHADOW-006, SHADOW-004
Blocks: All repository implementations
Due Date: 2026-02-06

Description: |
  Implement BaseRepository abstract class with sync metadata helpers.

Acceptance Criteria:
  - [ ] lib/core/repositories/base_repository.dart created
  - [ ] generateId() method implemented
  - [ ] createSyncMetadata() method implemented
  - [ ] updateSyncMetadata() method implemented
  - [ ] prepareForCreate() method implemented
  - [ ] prepareForUpdate() method implemented
  - [ ] prepareForDelete() method implemented
  - [ ] Unit tests with 100% coverage

Technical Notes: |
  Follow 05_IMPLEMENTATION_ROADMAP.md Section 2.6.
  Uses Uuid and DeviceInfoService (inject via constructor).

Coordination: |
  When complete, post: "BaseRepository ready. Entity repos can extend it."
```

---

### SHADOW-008: Implement Database Helper (Drift)

```yaml
Type: Task
Status: Backlog
Assignee: Core-3
Sprint: 1
Priority: P0
Story Points: 5
Labels: [core-team] [phase-0] [database]
Blocked By: SHADOW-004
Blocks: All database tables
Due Date: 2026-02-07

Description: |
  Implement AppDatabase with Drift ORM and SQLCipher encryption.

Acceptance Criteria:
  - [ ] lib/data/datasources/local/database.dart created
  - [ ] @DriftDatabase annotation with tables list
  - [ ] Database opens successfully
  - [ ] SQLCipher encryption configured
  - [ ] schemaVersion = 4
  - [ ] Migration strategy defined
  - [ ] Foreign keys enabled
  - [ ] Database connection works on iOS, Android, macOS
  - [ ] Integration test verifying database operations

Technical Notes: |
  Use Drift (not raw sqflite).
  See 10_DATABASE_SCHEMA.md for schema version 4.
  Encryption key stored in flutter_secure_storage.

  Tables will be added incrementally in Phase 1.
  Start with empty table list, verify infrastructure works.

Coordination: |
  When complete, post: "Database infrastructure ready. Tables can be added."
```

---

### SHADOW-009: Implement EncryptionService

```yaml
Type: Task
Status: Backlog
Assignee: Core-3
Sprint: 1
Priority: P1
Story Points: 3
Labels: [core-team] [phase-0] [security]
Blocked By: SHADOW-002
Blocks: Cloud sync, File storage
Due Date: 2026-02-06

Description: |
  Implement AES-256 encryption service for cloud data encryption.

Acceptance Criteria:
  - [ ] lib/core/services/encryption_service.dart created
  - [ ] encrypt(String plaintext) -> String ciphertext
  - [ ] decrypt(String ciphertext) -> String plaintext
  - [ ] generateKey() -> encryption key
  - [ ] Key stored securely in flutter_secure_storage
  - [ ] Uses AES-256-GCM algorithm
  - [ ] Works with JSON data (for cloud sync)
  - [ ] Unit tests with known test vectors
  - [ ] 100% test coverage

Technical Notes: |
  Use pointycastle package.
  See 11_SECURITY_GUIDELINES.md for encryption requirements.
  Key derivation from user-specific seed.

Coordination: |
  When complete, post: "EncryptionService ready."
```

---

### SHADOW-010: Implement LoggerService

```yaml
Type: Task
Status: Backlog
Assignee: Core-1
Sprint: 1
Priority: P2
Story Points: 1
Labels: [core-team] [phase-0] [services]
Blocked By: SHADOW-002
Blocks: None (but all code should use it)
Due Date: 2026-02-05

Description: |
  Implement structured logging service with scoped loggers.

Acceptance Criteria:
  - [ ] lib/core/services/logger_service.dart created
  - [ ] LoggerService singleton
  - [ ] debug(), info(), warning(), error() methods
  - [ ] ScopedLogger class for per-class logging
  - [ ] scope() factory method
  - [ ] Different log levels for debug vs release
  - [ ] No PII in log output
  - [ ] Global `logger` instance exported

Technical Notes: |
  Use logger package.
  See 05_IMPLEMENTATION_ROADMAP.md Section 2.2.

  Usage:
  static final _log = logger.scope('MyClass');
  _log.info('Something happened');

Coordination: |
  When complete, post: "LoggerService ready. Use `logger.scope('ClassName')` for logging."
```

---

### SHADOW-011: Implement DeviceInfoService

```yaml
Type: Task
Status: Backlog
Assignee: Core-2
Sprint: 1
Priority: P2
Story Points: 2
Labels: [core-team] [phase-0] [services]
Blocked By: SHADOW-003
Blocks: SHADOW-007 (needed for sync metadata)
Due Date: 2026-02-05

Description: |
  Implement device information service for multi-device tracking.

Acceptance Criteria:
  - [ ] lib/core/services/device_info_service.dart created
  - [ ] getDeviceId() -> unique device identifier
  - [ ] getDeviceName() -> human-readable device name
  - [ ] getPlatform() -> 'iOS' | 'Android' | 'macOS'
  - [ ] Works on iOS, Android, macOS
  - [ ] Caches values after first retrieval
  - [ ] Unit tests with mocked device_info_plus

Technical Notes: |
  Use device_info_plus package.
  See 05_IMPLEMENTATION_ROADMAP.md Section 2.3.

  iOS: identifierForVendor
  Android: androidId
  macOS: systemGUID

Coordination: |
  When complete, post: "DeviceInfoService ready."
```

---

### SHADOW-012: Configure Localization

```yaml
Type: Task
Status: Backlog
Assignee: Core-3
Sprint: 1
Priority: P2
Story Points: 1
Labels: [core-team] [phase-0] [l10n]
Blocked By: SHADOW-002
Blocks: All UI text
Due Date: 2026-02-05

Description: |
  Set up Flutter localization with ARB files.

Acceptance Criteria:
  - [ ] l10n.yaml created with configuration
  - [ ] lib/l10n/app_en.arb created with base strings
  - [ ] AppLocalizations generated
  - [ ] flutter gen-l10n works
  - [ ] Sample usage in test widget works
  - [ ] Documented usage pattern

Technical Notes: |
  See 13_LOCALIZATION_GUIDE.md for setup.

  l10n.yaml:
  arb-dir: lib/l10n
  template-arb-file: app_en.arb
  output-localization-file: app_localizations.dart

Coordination: |
  When complete, post: "Localization configured. Add strings to app_en.arb."
```

---

### SHADOW-013: Set Up CI/CD Pipeline

```yaml
Type: Task
Status: Backlog
Assignee: Core-3
Sprint: 1
Priority: P1
Story Points: 3
Labels: [core-team] [phase-0] [cicd]
Blocked By: SHADOW-004
Blocks: All PRs need CI
Due Date: 2026-02-07

Description: |
  Set up GitHub Actions CI/CD pipeline per 20_CICD_PIPELINE.md.

Acceptance Criteria:
  - [ ] .github/workflows/pr-checks.yml created
  - [ ] Runs on all PRs to develop and main
  - [ ] Runs flutter analyze
  - [ ] Runs flutter test
  - [ ] Runs build_runner build
  - [ ] Checks generated files are committed
  - [ ] Reports coverage
  - [ ] Workflow passes on current code
  - [ ] Branch protection rules configured

Technical Notes: |
  Follow 20_CICD_PIPELINE.md exactly.
  Start with PR checks only, add deployment later.

Coordination: |
  When complete, post: "CI pipeline active. All PRs will be validated."
```

---

### SHADOW-014: Configure Pre-commit Hooks

```yaml
Type: Task
Status: Backlog
Assignee: Core-1
Sprint: 1
Priority: P2
Story Points: 1
Labels: [core-team] [phase-0] [tooling]
Blocked By: SHADOW-013
Blocks: None
Due Date: 2026-02-07

Description: |
  Set up pre-commit hooks per 23_ENGINEERING_GOVERNANCE.md.

Acceptance Criteria:
  - [ ] .git/hooks/pre-commit created
  - [ ] Hook runs build_runner
  - [ ] Hook checks for uncommitted generated files
  - [ ] Hook runs flutter analyze
  - [ ] Hook runs dart format check
  - [ ] scripts/install-hooks.sh created for team setup
  - [ ] Documented in README.md

Technical Notes: |
  See 23_ENGINEERING_GOVERNANCE.md Section 6.1.
  Make hooks executable: chmod +x .git/hooks/pre-commit

Coordination: |
  When complete, post: "Pre-commit hooks ready. Run ./scripts/install-hooks.sh"
```

---

### SHADOW-015: Create Custom Lint Rules

```yaml
Type: Task
Status: Backlog
Assignee: Core-2
Sprint: 1
Priority: P2
Story Points: 3
Labels: [core-team] [phase-0] [tooling]
Blocked By: SHADOW-004
Blocks: None
Due Date: 2026-02-07

Description: |
  Configure analysis_options.yaml with strict linting and custom rules.

Acceptance Criteria:
  - [ ] analysis_options.yaml configured
  - [ ] flutter_lints included
  - [ ] Strict mode enabled
  - [ ] No implicit casts
  - [ ] No implicit dynamic
  - [ ] Custom lint rules for Result type enforcement (if possible)
  - [ ] Zero warnings on current codebase
  - [ ] Documented lint exceptions process

Technical Notes: |
  See 23_ENGINEERING_GOVERNANCE.md Section 6.2.
  Start with built-in rules, custom_lint package for advanced rules.

  Key rules:
  - prefer_const_constructors
  - avoid_print (use logger)
  - always_use_package_imports

Coordination: |
  When complete, post: "Lint rules configured. `flutter analyze` enforces standards."
```

---

## 3. Daily To-Do Lists by Engineer

### 3.1 Core-1 Daily Schedule (Sprint 1)

```
═══════════════════════════════════════════════════════════════════
                    CORE-1 DAILY TO-DO LIST
═══════════════════════════════════════════════════════════════════

┌─────────────────────────────────────────────────────────────────┐
│ DAY 1 (Monday)                                                  │
├─────────────────────────────────────────────────────────────────┤
│ □ 9:00 AM  - Team standup (15 min)                             │
│ □ 9:30 AM  - Start SHADOW-001: Initialize Flutter Project       │
│              - Create project with flutter create               │
│              - Configure platforms                              │
│              - Test builds                                      │
│ □ 12:00 PM - Lunch                                              │
│ □ 1:00 PM  - Continue SHADOW-001                                │
│              - Initialize git repo                              │
│              - Create .gitignore                                │
│              - Push initial commit                              │
│ □ 4:00 PM  - Document any issues encountered                    │
│ □ 5:00 PM  - EOD: Update ticket status                          │
│                                                                 │
│ BLOCKED BY: Nothing                                             │
│ BLOCKS: Core-2 (SHADOW-003), Core-3 (SHADOW-008)               │
│ NOTIFY WHEN DONE: @core-team in #shadow-engineering             │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ DAY 2 (Tuesday)                                                 │
├─────────────────────────────────────────────────────────────────┤
│ □ 9:00 AM  - Team standup                                       │
│ □ 9:30 AM  - Complete SHADOW-001 if not done                    │
│ □ 10:00 AM - Create PR for SHADOW-001                           │
│ □ 10:30 AM - Start SHADOW-002: Folder Structure                 │
│              - Create all directories per architecture doc      │
│              - Add placeholder files                            │
│ □ 12:00 PM - Lunch                                              │
│ □ 1:00 PM  - Complete SHADOW-002                                │
│              - Create PR                                        │
│              - Get review from Core-2 or Core-3                 │
│ □ 3:00 PM  - PR reviews for teammates                           │
│ □ 5:00 PM  - EOD: Update tickets, notify blocked work           │
│                                                                 │
│ BLOCKED BY: Nothing                                             │
│ BLOCKS: SHADOW-005, SHADOW-009, SHADOW-010, SHADOW-012          │
│ NOTIFY WHEN DONE: "Folder structure complete, services can start"│
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ DAY 3 (Wednesday)                                               │
├─────────────────────────────────────────────────────────────────┤
│ □ 9:00 AM  - Team standup                                       │
│ □ 9:30 AM  - Start SHADOW-005: Result Type                      │
│              - Implement sealed class Result<T, E>              │
│              - Implement Success and Failure                    │
│ □ 12:00 PM - Lunch                                              │
│ □ 1:00 PM  - Continue SHADOW-005                                │
│              - Add when() method                                │
│              - Write unit tests                                 │
│ □ 3:00 PM  - Start SHADOW-010: LoggerService                    │
│              - Basic implementation                             │
│ □ 5:00 PM  - EOD: PR for SHADOW-005, update tickets             │
│                                                                 │
│ BLOCKED BY: SHADOW-002 (should be done)                         │
│ BLOCKS: SHADOW-006 (error hierarchy)                            │
│ NOTIFY WHEN DONE: "Result type ready, error classes can start"  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ DAY 4 (Thursday)                                                │
├─────────────────────────────────────────────────────────────────┤
│ □ 9:00 AM  - Team standup                                       │
│ □ 9:30 AM  - Complete SHADOW-010: LoggerService                 │
│              - Create PR                                        │
│ □ 10:30 AM - Start SHADOW-006: AppError Hierarchy               │
│              - Implement AppError base class                    │
│              - Implement DatabaseError                          │
│              - Implement AuthError                              │
│ □ 12:00 PM - Lunch                                              │
│ □ 1:00 PM  - Continue SHADOW-006                                │
│              - Implement NetworkError                           │
│              - Implement ValidationError                        │
│              - Implement SyncError                              │
│ □ 4:00 PM  - Write tests for error classes                      │
│ □ 5:00 PM  - EOD: Update tickets                                │
│                                                                 │
│ BLOCKED BY: SHADOW-005 (should be done)                         │
│ BLOCKS: SHADOW-007, all repository work                         │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ DAY 5 (Friday)                                                  │
├─────────────────────────────────────────────────────────────────┤
│ □ 9:00 AM  - Team standup                                       │
│ □ 9:30 AM  - Complete SHADOW-006                                │
│              - Finish tests                                     │
│              - Create PR                                        │
│ □ 11:00 AM - PR reviews for Core-2 and Core-3                   │
│ □ 12:00 PM - Lunch                                              │
│ □ 1:00 PM  - Address review feedback                            │
│ □ 2:00 PM  - Sprint preparation for next week                   │
│ □ 3:00 PM  - Documentation updates                              │
│ □ 4:00 PM  - Week 1 retrospective                               │
│ □ 5:00 PM  - EOD: All tickets updated                           │
│                                                                 │
│ END OF WEEK STATUS:                                             │
│ ✓ SHADOW-001: Done                                              │
│ ✓ SHADOW-002: Done                                              │
│ ✓ SHADOW-005: Done                                              │
│ ✓ SHADOW-006: In Review                                         │
│ ✓ SHADOW-010: Done                                              │
└─────────────────────────────────────────────────────────────────┘

... (Days 6-10 continue with SHADOW-014 and Sprint 2 prep)
```

---

### 3.2 Core-2 Daily Schedule (Sprint 1)

```
═══════════════════════════════════════════════════════════════════
                    CORE-2 DAILY TO-DO LIST
═══════════════════════════════════════════════════════════════════

┌─────────────────────────────────────────────────────────────────┐
│ DAY 1 (Monday)                                                  │
├─────────────────────────────────────────────────────────────────┤
│ □ 9:00 AM  - Team standup (15 min)                             │
│ □ 9:30 AM  - WAIT for Core-1 to complete SHADOW-001             │
│              - Review project setup documentation               │
│              - Prepare for SHADOW-003                           │
│ □ 12:00 PM - Lunch                                              │
│ □ 1:00 PM  - Check if SHADOW-001 is done                        │
│              - If yes: Start SHADOW-003 (Dependencies)          │
│              - If no: Help Core-1 or do documentation           │
│ □ 5:00 PM  - EOD: Update ticket status                          │
│                                                                 │
│ BLOCKED BY: SHADOW-001 (Core-1)                                 │
│ COORDINATE: Ping Core-1 at 2 PM if still waiting                │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ DAY 2 (Tuesday)                                                 │
├─────────────────────────────────────────────────────────────────┤
│ □ 9:00 AM  - Team standup                                       │
│ □ 9:30 AM  - Complete SHADOW-003: Dependencies                  │
│              - Add all packages to pubspec.yaml                 │
│              - Run flutter pub get                              │
│              - Resolve any conflicts                            │
│              - Create PR                                        │
│ □ 12:00 PM - Lunch                                              │
│ □ 1:00 PM  - Start SHADOW-004: Code Generation                  │
│              - Configure build.yaml                             │
│              - Create test freezed class                        │
│ □ 5:00 PM  - EOD: SHADOW-003 done, SHADOW-004 in progress       │
│                                                                 │
│ BLOCKED BY: SHADOW-001 (should be done)                         │
│ BLOCKS: SHADOW-004 needs SHADOW-003 first                       │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ DAY 3 (Wednesday)                                               │
├─────────────────────────────────────────────────────────────────┤
│ □ 9:00 AM  - Team standup                                       │
│ □ 9:30 AM  - Complete SHADOW-004: Code Generation               │
│              - Test Drift database generation                   │
│              - Test Riverpod provider generation                │
│              - Verify build_runner works                        │
│              - Create PR                                        │
│ □ 12:00 PM - Lunch                                              │
│ □ 1:00 PM  - Start SHADOW-011: DeviceInfoService                │
│              - Implement device ID retrieval                    │
│              - Test on available platforms                      │
│ □ 5:00 PM  - EOD: SHADOW-004 complete (CRITICAL UNBLOCK)        │
│                                                                 │
│ NOTIFY: "Code generation working. Database and entities can start."│
│ UNBLOCKS: Core-3 (SHADOW-008), SHADOW-015                       │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ DAY 4 (Thursday)                                                │
├─────────────────────────────────────────────────────────────────┤
│ □ 9:00 AM  - Team standup                                       │
│ □ 9:30 AM  - Complete SHADOW-011: DeviceInfoService             │
│              - Add unit tests                                   │
│              - Create PR                                        │
│ □ 11:00 AM - Start SHADOW-007: BaseRepository                   │
│              - Wait for SHADOW-006 (error hierarchy)            │
│              - Check with Core-1 on status                      │
│ □ 12:00 PM - Lunch                                              │
│ □ 1:00 PM  - Continue SHADOW-007 if unblocked                   │
│              - OR: Help with PR reviews                         │
│              - OR: Start SHADOW-015 (lint rules)                │
│ □ 5:00 PM  - EOD: Update tickets                                │
│                                                                 │
│ BLOCKED BY: SHADOW-006 (for SHADOW-007)                         │
│ COORDINATE: Check with Core-1 at standup                        │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ DAY 5 (Friday)                                                  │
├─────────────────────────────────────────────────────────────────┤
│ □ 9:00 AM  - Team standup                                       │
│ □ 9:30 AM  - Complete SHADOW-007: BaseRepository                │
│              - Implement all sync metadata helpers              │
│              - Write unit tests                                 │
│              - Create PR                                        │
│ □ 12:00 PM - Lunch                                              │
│ □ 1:00 PM  - Start SHADOW-015: Custom Lint Rules                │
│              - Configure analysis_options.yaml                  │
│ □ 3:00 PM  - PR reviews                                         │
│ □ 4:00 PM  - Week 1 retrospective                               │
│ □ 5:00 PM  - EOD: All tickets updated                           │
│                                                                 │
│ END OF WEEK STATUS:                                             │
│ ✓ SHADOW-003: Done                                              │
│ ✓ SHADOW-004: Done (CRITICAL)                                   │
│ ✓ SHADOW-007: In Review                                         │
│ ✓ SHADOW-011: Done                                              │
│ ○ SHADOW-015: In Progress                                       │
└─────────────────────────────────────────────────────────────────┘
```

---

### 3.3 Core-3 Daily Schedule (Sprint 1)

```
═══════════════════════════════════════════════════════════════════
                    CORE-3 DAILY TO-DO LIST
═══════════════════════════════════════════════════════════════════

┌─────────────────────────────────────────────────────────────────┐
│ DAY 1 (Monday)                                                  │
├─────────────────────────────────────────────────────────────────┤
│ □ 9:00 AM  - Team standup (15 min)                             │
│ □ 9:30 AM  - WAIT for SHADOW-001 and SHADOW-004                 │
│              - Review database schema docs (10_DATABASE_SCHEMA) │
│              - Review Drift documentation                       │
│              - Plan database structure                          │
│ □ 12:00 PM - Lunch                                              │
│ □ 1:00 PM  - Continue preparation                               │
│              - Study SQLCipher encryption                       │
│              - Prepare questions for SHADOW-008                 │
│ □ 5:00 PM  - EOD: Ready to start when unblocked                 │
│                                                                 │
│ BLOCKED BY: SHADOW-004 (code generation)                        │
│ COORDINATE: Check with Core-2 on SHADOW-004 progress            │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ DAY 2 (Tuesday)                                                 │
├─────────────────────────────────────────────────────────────────┤
│ □ 9:00 AM  - Team standup                                       │
│ □ 9:30 AM  - Check if SHADOW-004 is complete                    │
│              - If blocked: Start SHADOW-009 or SHADOW-012       │
│ □ 10:00 AM - Start SHADOW-012: Localization Setup               │
│              - Create l10n.yaml                                 │
│              - Create app_en.arb                                │
│              - Test generation                                  │
│ □ 12:00 PM - Lunch                                              │
│ □ 1:00 PM  - Complete SHADOW-012                                │
│              - Create PR                                        │
│ □ 2:00 PM  - Start SHADOW-009: EncryptionService                │
│              - Research pointycastle AES-256                    │
│              - Begin implementation                             │
│ □ 5:00 PM  - EOD: SHADOW-012 done, SHADOW-009 started           │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ DAY 3 (Wednesday)                                               │
├─────────────────────────────────────────────────────────────────┤
│ □ 9:00 AM  - Team standup                                       │
│              - Core-2 should announce SHADOW-004 complete       │
│ □ 9:30 AM  - Start SHADOW-008: Database Helper (CRITICAL)       │
│              - Create AppDatabase class with Drift              │
│              - Configure SQLCipher encryption                   │
│ □ 12:00 PM - Lunch                                              │
│ □ 1:00 PM  - Continue SHADOW-008                                │
│              - Test database opens correctly                    │
│              - Test encryption works                            │
│ □ 5:00 PM  - EOD: SHADOW-008 in progress                        │
│                                                                 │
│ CRITICAL: SHADOW-008 blocks all entity table work               │
│ PRIORITY: Focus exclusively on this                             │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ DAY 4 (Thursday)                                                │
├─────────────────────────────────────────────────────────────────┤
│ □ 9:00 AM  - Team standup                                       │
│ □ 9:30 AM  - Continue SHADOW-008                                │
│              - Test on iOS                                      │
│              - Test on Android                                  │
│              - Test on macOS                                    │
│ □ 12:00 PM - Lunch                                              │
│ □ 1:00 PM  - Complete SHADOW-008                                │
│              - Write integration tests                          │
│              - Create PR                                        │
│ □ 3:00 PM  - Complete SHADOW-009: EncryptionService             │
│ □ 5:00 PM  - EOD: SHADOW-008 and SHADOW-009 ready               │
│                                                                 │
│ NOTIFY: "Database infrastructure ready. Tables can be added."   │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ DAY 5 (Friday)                                                  │
├─────────────────────────────────────────────────────────────────┤
│ □ 9:00 AM  - Team standup                                       │
│ □ 9:30 AM  - Start SHADOW-013: CI/CD Pipeline                   │
│              - Create .github/workflows/pr-checks.yml           │
│              - Configure flutter analyze                        │
│              - Configure flutter test                           │
│ □ 12:00 PM - Lunch                                              │
│ □ 1:00 PM  - Complete SHADOW-013                                │
│              - Test pipeline on a PR                            │
│              - Configure branch protection                      │
│ □ 3:00 PM  - PR reviews                                         │
│ □ 4:00 PM  - Week 1 retrospective                               │
│ □ 5:00 PM  - EOD: Sprint 1 complete                             │
│                                                                 │
│ END OF WEEK STATUS:                                             │
│ ✓ SHADOW-008: Done (CRITICAL)                                   │
│ ✓ SHADOW-009: Done                                              │
│ ✓ SHADOW-012: Done                                              │
│ ✓ SHADOW-013: Done                                              │
└─────────────────────────────────────────────────────────────────┘
```

---

## 4. Sprint Board View

### 4.1 Sprint 1 Board (End of Week 1)

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              SPRINT 1 BOARD - END OF WEEK 1                          │
├─────────────┬─────────────┬─────────────┬─────────────┬─────────────────────────────┤
│   BACKLOG   │    READY    │ IN PROGRESS │  IN REVIEW  │            DONE             │
├─────────────┼─────────────┼─────────────┼─────────────┼─────────────────────────────┤
│             │             │ SHADOW-008  │ SHADOW-006  │ SHADOW-001 ✓ (Core-1)       │
│             │             │ (Core-3)    │ (Core-1)    │ SHADOW-002 ✓ (Core-1)       │
│             │             │ Database    │ Errors      │ SHADOW-003 ✓ (Core-2)       │
│             │             │             │             │ SHADOW-004 ✓ (Core-2)       │
│             │             │ SHADOW-015  │ SHADOW-007  │ SHADOW-005 ✓ (Core-1)       │
│             │             │ (Core-2)    │ (Core-2)    │ SHADOW-009 ✓ (Core-3)       │
│             │             │ Lint rules  │ BaseRepo    │ SHADOW-010 ✓ (Core-1)       │
│             │             │             │             │ SHADOW-011 ✓ (Core-2)       │
│             │             │ SHADOW-013  │             │ SHADOW-012 ✓ (Core-3)       │
│             │             │ (Core-3)    │             │                             │
│             │             │ CI/CD       │             │                             │
│             │             │             │             │                             │
│             │             │ SHADOW-014  │             │                             │
│             │             │ (Core-1)    │             │                             │
│             │             │ Hooks       │             │                             │
├─────────────┴─────────────┴─────────────┴─────────────┴─────────────────────────────┤
│ SPRINT PROGRESS: 9/15 tasks complete (60%)                                           │
│ BLOCKERS: None                                                                       │
│ AT RISK: None                                                                        │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 5. Ticket Templates

### 5.1 Feature Ticket Template

```yaml
SHADOW-XXX: [Feature Name]

Type: Feature
Status: Backlog
Assignee: [Engineer]
Sprint: [Number]
Priority: [P0-P3]
Story Points: [1,2,3,5,8]
Labels: [team] [phase] [component]
Epic: SHADOW-EPIC-XXX

Description: |
  As a [user type],
  I want to [action],
  So that [benefit].

Acceptance Criteria:
  - [ ] [Criterion 1]
  - [ ] [Criterion 2]
  - [ ] [Criterion 3]
  - [ ] Unit tests written (coverage: 100%)
  - [ ] Widget tests written (if UI)
  - [ ] Documentation updated
  - [ ] Accessibility verified

Technical Notes: |
  Implementation guidance...
  Reference specs: [doc numbers]
  API Contract: [section reference]

Dependencies:
  Blocked By: SHADOW-XXX, SHADOW-YYY
  Blocks: SHADOW-ZZZ

Coordination: |
  Notify when complete: @team-name
  Handoff to: [team/person]

Definition of Done:
  - [ ] All acceptance criteria met
  - [ ] PR approved by 2 reviewers
  - [ ] CI passing
  - [ ] Merged to develop
```

### 5.2 Bug Ticket Template

```yaml
SHADOW-XXX: [Bug Title]

Type: Bug
Status: Backlog
Assignee: [Engineer]
Sprint: [Number]
Priority: [P0-P3]
Story Points: [1,2,3]
Labels: [team] [bug] [component]
Severity: [Critical|High|Medium|Low]

Description: |
  **Current Behavior:**
  [What happens now]

  **Expected Behavior:**
  [What should happen]

  **Steps to Reproduce:**
  1. [Step 1]
  2. [Step 2]
  3. [Step 3]

Environment:
  - Platform: [iOS/Android/macOS]
  - Version: [app version]
  - Device: [device model]

Acceptance Criteria:
  - [ ] Bug no longer reproducible
  - [ ] Regression test added
  - [ ] No new bugs introduced

Root Cause: |
  [To be filled during investigation]

Fix: |
  [To be filled during implementation]
```

---

## 6. Daily Standup Template

```
═══════════════════════════════════════════════════════════════════
              DAILY STANDUP - [TEAM NAME] - [DATE]
═══════════════════════════════════════════════════════════════════

[Engineer Name]:
┌─────────────────────────────────────────────────────────────────┐
│ YESTERDAY:                                                      │
│ ✓ Completed SHADOW-XXX (merged to develop)                      │
│ ✓ Started SHADOW-YYY                                            │
│                                                                 │
│ TODAY:                                                          │
│ → Continue SHADOW-YYY (target: complete by EOD)                 │
│ → Start SHADOW-ZZZ after YYY merged                             │
│                                                                 │
│ BLOCKERS:                                                       │
│ ⚠ Waiting on SHADOW-AAA from @other-engineer                    │
│   - ETA from them: Today 2pm                                    │
│   - If not unblocked by 3pm, will pick up SHADOW-BBB instead    │
│                                                                 │
│ HELP NEEDED:                                                    │
│ ? Need review on SHADOW-XXX PR                                  │
│ ? Question about Result type usage in use cases                 │
└─────────────────────────────────────────────────────────────────┘

TEAM ACTIONS:
- @reviewer-1 to review SHADOW-XXX PR
- @core-1 to answer Result type question after standup
- Schedule pairing session for SHADOW-ZZZ if complex

CROSS-TEAM UPDATES:
- Team Sync announced: OAuth service ready by Thursday
- Team UI: Widget library v2 deploying today

═══════════════════════════════════════════════════════════════════
```

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
