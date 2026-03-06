# Shadow Instance Coordination Protocol

**Version:** 1.0
**Last Updated:** February 2, 2026
**Purpose:** Coordination protocol for stateless Claude instances working on Shadow codebase

---

## CRITICAL: You Are a Stateless Agent

**READ THIS FIRST BEFORE ANY WORK.**

You are one of 1000+ independent Claude instances working on this codebase. You have:
- **NO memory** of what previous instances decided
- **NO memory** of other concurrent instances' work
- **NO communication channel** to other instances except through files

The ONLY way instances communicate is through:
1. **Committed code** - Code in the repository
2. **Specification documents** - These markdown files
3. **Test results** - Automated tests that verify compliance
4. **Work status files** - `.claude/work-status/` directory

---

## 1. Instance Startup Protocol

**EVERY instance MUST execute this protocol before doing ANY work.**

### 1.1 Compliance Verification (MANDATORY)

Before writing any code, run this verification:

```bash
# Step 1: Run the specification compliance test
dart run scripts/verify_spec_compliance.dart

# Expected output: "COMPLIANT: 0 errors, 0 warnings"
# If errors: DO NOT PROCEED. Fix errors first or report to user.
```

### 1.2 Previous Work Verification

Check if previous instances left incomplete work:

```bash
# Read the work status file
cat .claude/work-status/current.json
```

The status file contains:
```json
{
  "lastInstanceId": "abc123",
  "lastAction": "implementing",
  "taskId": "SHADOW-042",
  "status": "in_progress|complete|blocked|failed",
  "timestamp": "2026-02-02T10:30:00Z",
  "filesModified": ["lib/domain/entities/fluids_entry.dart"],
  "testsStatus": "passing|failing|not_run",
  "complianceStatus": "verified|unverified|failed",
  "notes": "Completed entity, starting repository"
}
```

### 1.3 Decision Tree

```
IF status == "in_progress" AND testsStatus == "failing":
    → Previous instance left broken code
    → Run tests, identify failures, fix them
    → Update status to "complete" or document why blocked

IF status == "in_progress" AND testsStatus == "passing":
    → Previous instance's work was interrupted mid-task
    → Review filesModified to understand context
    → Continue the task from where they stopped

IF status == "complete":
    → Previous task done
    → Pick next task from 34_PROJECT_TRACKER.md
    → Update status file with new task

IF status == "blocked":
    → Read notes for blocking reason
    → If you can resolve: do so
    → If not: pick alternate task, leave status as blocked

IF status == "failed":
    → Read notes for failure reason
    → Attempt to resolve
    → If unresolvable: escalate to user
```

---

## 2. Work Status File Protocol

### 2.1 Starting Work

Before making ANY changes, update the status file:

```json
{
  "lastInstanceId": "<generate-uuid>",
  "lastAction": "starting",
  "taskId": "SHADOW-042",
  "status": "in_progress",
  "timestamp": "<current-iso-timestamp>",
  "filesModified": [],
  "testsStatus": "not_run",
  "complianceStatus": "verified",
  "notes": "Starting implementation of FluidsEntry entity per 22_API_CONTRACTS.md Section 5"
}
```

### 2.2 During Work

Update after each significant milestone:

```json
{
  "lastAction": "implementing",
  "filesModified": ["lib/domain/entities/fluids_entry.dart"],
  "notes": "Entity created, all required fields present. Starting repository interface."
}
```

### 2.3 Completing Work

BEFORE telling user work is complete:

1. Run all tests
2. Run compliance verification
3. Update status file:

```json
{
  "lastAction": "completed",
  "status": "complete",
  "testsStatus": "passing",
  "complianceStatus": "verified",
  "notes": "FluidsEntry entity and repository complete. All tests passing. Verified against 22_API_CONTRACTS.md Section 5."
}
```

### 2.4 Blocked or Failed

If you cannot complete:

```json
{
  "status": "blocked",
  "notes": "Blocked: API Contract Section 5.3 missing waterIntakeMl validation rules. Cannot proceed without spec clarification."
}
```

---

## 3. Compliance Testing Loop

### 3.1 The Compliance Test

Every instance MUST verify its work complies with coding standards.

Create/update `scripts/verify_spec_compliance.dart`:

```dart
/// Specification Compliance Verifier
/// Run before completing ANY task
///
/// Checks:
/// 1. All entities have required fields (id, clientId, profileId, syncMetadata)
/// 2. All repositories return Result<T, AppError>
/// 3. All timestamps are int (not DateTime)
/// 4. All enums have integer values
/// 5. No exceptions thrown from domain layer
/// 6. All error codes are from approved list

import 'dart:io';

void main() async {
  final errors = <String>[];
  final warnings = <String>[];

  // Check 1: Entity required fields
  await checkEntityFields(errors, warnings);

  // Check 2: Repository Result types
  await checkRepositoryReturns(errors, warnings);

  // Check 3: Timestamp types
  await checkTimestampTypes(errors, warnings);

  // Check 4: Enum integer values
  await checkEnumValues(errors, warnings);

  // Check 5: Exception usage
  await checkExceptionUsage(errors, warnings);

  // Check 6: Error codes
  await checkErrorCodes(errors, warnings);

  // Report
  if (errors.isEmpty && warnings.isEmpty) {
    print('COMPLIANT: 0 errors, 0 warnings');
    exit(0);
  } else {
    print('NON-COMPLIANT:');
    for (final error in errors) {
      print('  ERROR: $error');
    }
    for (final warning in warnings) {
      print('  WARNING: $warning');
    }
    exit(errors.isNotEmpty ? 1 : 0);
  }
}

Future<void> checkEntityFields(List<String> errors, List<String> warnings) async {
  final entityDir = Directory('lib/domain/entities');
  if (!entityDir.existsSync()) return;

  final requiredFields = ['id', 'clientId', 'profileId', 'syncMetadata'];

  await for (final file in entityDir.list(recursive: true)) {
    if (file is File && file.path.endsWith('.dart') && !file.path.contains('.freezed.') && !file.path.contains('.g.')) {
      final content = await file.readAsString();

      // Skip if not a @freezed entity
      if (!content.contains('@freezed')) continue;

      // Check for required fields
      for (final field in requiredFields) {
        if (!content.contains('required String $field') &&
            !content.contains('required SyncMetadata $field') &&
            field != 'profileId') { // profileId may not be required on all entities
          // Check if field exists at all
          if (!content.contains('$field,') && !content.contains('$field;')) {
            errors.add('${file.path}: Missing required field "$field"');
          }
        }
      }

      // Check for const constructor
      final className = RegExp(r'class (\w+) with').firstMatch(content)?.group(1);
      if (className != null && !content.contains('const $className._()')) {
        errors.add('${file.path}: Missing "const $className._()" constructor');
      }
    }
  }
}

Future<void> checkRepositoryReturns(List<String> errors, List<String> warnings) async {
  final repoDir = Directory('lib/domain/repositories');
  if (!repoDir.existsSync()) return;

  await for (final file in repoDir.list(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      final content = await file.readAsString();

      // Find method signatures
      final methodPattern = RegExp(r'Future<(\w+)>\s+\w+\(');
      for (final match in methodPattern.allMatches(content)) {
        final returnType = match.group(1);
        if (returnType != 'Result' && returnType != 'void') {
          errors.add('${file.path}: Method returns Future<$returnType> instead of Future<Result<T, AppError>>');
        }
      }
    }
  }
}

Future<void> checkTimestampTypes(List<String> errors, List<String> warnings) async {
  final entityDir = Directory('lib/domain/entities');
  if (!entityDir.existsSync()) return;

  await for (final file in entityDir.list(recursive: true)) {
    if (file is File && file.path.endsWith('.dart') && !file.path.contains('.freezed.')) {
      final content = await file.readAsString();

      // Check for DateTime in entity fields
      if (content.contains('@freezed') && content.contains('DateTime')) {
        // Allow DateTime in computed properties (getters), not in fields
        final fieldPattern = RegExp(r'(required\s+)?DateTime\??\s+\w+[,;]');
        if (fieldPattern.hasMatch(content)) {
          errors.add('${file.path}: Contains DateTime field - must use int (epoch milliseconds)');
        }
      }
    }
  }
}

Future<void> checkEnumValues(List<String> errors, List<String> warnings) async {
  final files = await Directory('lib').list(recursive: true).toList();

  for (final file in files) {
    if (file is File && file.path.endsWith('.dart') && !file.path.contains('.freezed.') && !file.path.contains('.g.')) {
      final content = await file.readAsString();

      // Find enums
      final enumPattern = RegExp(r'enum\s+(\w+)\s*\{([^}]+)\}', multiLine: true);
      for (final match in enumPattern.allMatches(content)) {
        final enumName = match.group(1)!;
        final enumBody = match.group(2)!;

        // Check if enum has integer values
        if (!enumBody.contains('(') || !enumBody.contains('final int value')) {
          warnings.add('${file.path}: Enum "$enumName" missing integer values for database storage');
        }
      }
    }
  }
}

Future<void> checkExceptionUsage(List<String> errors, List<String> warnings) async {
  final domainDir = Directory('lib/domain');
  if (!domainDir.existsSync()) return;

  await for (final file in domainDir.list(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      final content = await file.readAsString();

      // Check for throw statements (except in test files)
      if (content.contains('throw ') && !file.path.contains('_test.dart')) {
        warnings.add('${file.path}: Contains "throw" statement - domain layer should use Result<T, AppError>');
      }
    }
  }
}

Future<void> checkErrorCodes(List<String> errors, List<String> warnings) async {
  // Load approved error codes from 22_API_CONTRACTS.md
  final approvedCodes = <String>{
    'DB_QUERY_FAILED', 'DB_INSERT_FAILED', 'DB_UPDATE_FAILED', 'DB_DELETE_FAILED',
    'DB_NOT_FOUND', 'DB_MIGRATION_FAILED', 'DB_CONNECTION_FAILED', 'DB_CONSTRAINT_VIOLATION',
    'AUTH_UNAUTHORIZED', 'AUTH_TOKEN_EXPIRED', 'AUTH_REFRESH_FAILED', 'AUTH_SIGNIN_FAILED',
    'AUTH_SIGNOUT_FAILED', 'AUTH_PERMISSION_DENIED', 'AUTH_PROFILE_ACCESS_DENIED',
    'NET_NO_CONNECTION', 'NET_TIMEOUT', 'NET_SERVER_ERROR', 'NET_SSL_ERROR',
    'VAL_REQUIRED', 'VAL_INVALID_FORMAT', 'VAL_OUT_OF_RANGE', 'VAL_TOO_LONG', 'VAL_TOO_SHORT', 'VAL_DUPLICATE',
    'SYNC_CONFLICT', 'SYNC_UPLOAD_FAILED', 'SYNC_DOWNLOAD_FAILED', 'SYNC_QUOTA_EXCEEDED', 'SYNC_CORRUPTED',
    // Add more from 22_API_CONTRACTS.md
  };

  final errorDir = Directory('lib/core/errors');
  if (!errorDir.existsSync()) return;

  await for (final file in errorDir.list(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      final content = await file.readAsString();

      // Find error code definitions
      final codePattern = RegExp(r"static const String code\w+ = '(\w+)'");
      for (final match in codePattern.allMatches(content)) {
        final code = match.group(1)!;
        if (!approvedCodes.contains(code)) {
          warnings.add('${file.path}: Uses error code "$code" not in approved list');
        }
      }
    }
  }
}
```

### 3.2 Pre-Completion Checklist

Before telling the user ANY task is complete, verify:

```
□ 1. Run: dart run scripts/verify_spec_compliance.dart
      Result: COMPLIANT (0 errors, 0 warnings)

□ 2. Run: flutter test
      Result: All tests passing

□ 3. Run: flutter analyze
      Result: No issues found

□ 4. Run: dart format --set-exit-if-changed lib/
      Result: Already formatted (exit code 0)

□ 5. Verify entity fields match 22_API_CONTRACTS.md EXACTLY
      - Open the relevant section
      - Compare field-by-field
      - Check types match exactly

□ 6. Verify repository methods match contracts EXACTLY
      - Method names identical
      - Parameter types identical
      - Return types are Result<T, AppError>

□ 7. Update .claude/work-status/current.json
      - Set status to "complete"
      - Set testsStatus to "passing"
      - Set complianceStatus to "verified"
```

---

## 4. Inter-Instance Communication

### 4.1 What Instances Can Communicate

| Communication Type | Method | Persistence |
|-------------------|--------|-------------|
| Task completion | `.claude/work-status/current.json` | Git tracked |
| Code changes | Committed code in repository | Git tracked |
| Spec clarifications | Append to `53_SPEC_CLARIFICATIONS.md` | Git tracked |
| Blocked issues | `.claude/work-status/blocked.json` | Git tracked |
| Decision records | `docs/decisions/ADR-XXX.md` | Git tracked |

### 4.2 What Instances CANNOT Communicate

- Real-time status ("I'm working on X right now")
- Opinions or preferences ("I think approach A is better")
- Uncommitted work-in-progress
- Verbal agreements ("Let's do it this way")

### 4.3 Handoff Protocol

When your conversation is about to be compacted/summarized:

1. **Commit all work** - Nothing uncommitted should exist
2. **Update status file** - Clear description of state
3. **Run compliance check** - Verify work is compliant
4. **Document decisions** - Any decisions made should be in specs
5. **Create ADR if needed** - For architectural decisions

Example status for handoff:
```json
{
  "lastInstanceId": "instance-xyz",
  "lastAction": "handoff",
  "taskId": "SHADOW-042",
  "status": "in_progress",
  "timestamp": "2026-02-02T14:30:00Z",
  "filesModified": [
    "lib/domain/entities/fluids_entry.dart",
    "lib/domain/repositories/fluids_repository.dart"
  ],
  "testsStatus": "passing",
  "complianceStatus": "verified",
  "notes": "Entity and repository interface complete. Next: implement repository, create datasource, write tests. See 22_API_CONTRACTS.md Section 5 for contract."
}
```

---

## 5. Conflict Resolution

### 5.1 When You Find Spec Ambiguity

DO NOT make a decision. Instead:

1. Document the ambiguity in `53_SPEC_CLARIFICATIONS.md`:
```markdown
## AMBIGUITY-2026-02-02-001: FluidsEntry water tracking

**Found in:** 22_API_CONTRACTS.md Section 5
**Issue:** waterIntakeMl validation range not specified
**Possible interpretations:**
1. 0-10000 mL (reasonable daily max)
2. 0-5000 mL (conservative)
3. No upper limit (user discretion)

**Blocking:** SHADOW-042 entity validation
**Status:** AWAITING_CLARIFICATION
```

2. Update work status to "blocked"
3. Ask user for clarification
4. Do NOT proceed until spec is updated

### 5.2 When Previous Instance Made a Decision

If you find code that doesn't match the spec:

1. **Check if spec was updated** - Maybe it's now correct
2. **Check ADR records** - Maybe there's a documented reason
3. **If no justification found:**
   - Flag as potential spec violation
   - Ask user whether to:
     a) Fix code to match spec
     b) Update spec to match code (with ADR)

### 5.3 When Tests Fail

1. Read test failure message carefully
2. Check if test is testing spec compliance
3. If code violates spec: fix code
4. If test is wrong: verify against spec, then fix test
5. Document resolution in commit message

---

## 6. Task Assignment Protocol

### 6.1 Picking Tasks

Tasks are defined in `34_PROJECT_TRACKER.md`. To pick a task:

1. Read `34_PROJECT_TRACKER.md`
2. Find first task with status "Ready" that you can work on
3. Check dependencies (Blocked By field)
4. Update status file to claim task

### 6.2 Task Dependencies

```
DO NOT start a task if its "Blocked By" tasks are not "Done".

Example:
SHADOW-007: BaseRepository
Blocked By: SHADOW-006 (AppError hierarchy)

→ If SHADOW-006 status is not "Done", DO NOT start SHADOW-007
→ Instead: work on SHADOW-006 or pick different task
```

### 6.3 Parallel Work

Multiple instances may work concurrently. To avoid conflicts:

1. Check `.claude/work-status/` for in-progress tasks
2. Do not start a task another instance has claimed
3. If you must work on same area, work on non-overlapping files
4. Always pull latest before starting

---

## 7. Instance Verification Tests

### 7.1 Startup Verification

Every instance should verify previous work:

```dart
// test/instance_verification_test.dart

void main() {
  group('Previous Instance Compliance', () {
    test('All entities have required fields', () {
      // Run entity field checker
    });

    test('All repositories return Result', () {
      // Run repository signature checker
    });

    test('No DateTime in entities', () {
      // Run timestamp type checker
    });

    test('All tests pass', () {
      // Run flutter test
    });

    test('No lint warnings', () {
      // Run flutter analyze
    });
  });
}
```

### 7.2 Continuous Compliance

Add to CI pipeline:
```yaml
# .github/workflows/compliance.yml
name: Spec Compliance

on: [push, pull_request]

jobs:
  compliance:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2

      - name: Install dependencies
        run: flutter pub get

      - name: Run spec compliance check
        run: dart run scripts/verify_spec_compliance.dart

      - name: Check entities have required fields
        run: dart run scripts/check_entity_fields.dart

      - name: Check repository signatures
        run: dart run scripts/check_repository_signatures.dart

      - name: Run tests
        run: flutter test

      - name: Run analyzer
        run: flutter analyze --fatal-infos
```

---

## 8. Summary: The Golden Rules

1. **NEVER make decisions** - Follow specs exactly
2. **ALWAYS verify compliance** - Before completing any task
3. **ALWAYS update status** - For next instance to understand
4. **NEVER leave uncommitted work** - At end of conversation
5. **ALWAYS run tests** - Before claiming completion
6. **STOP if ambiguous** - Ask for clarification, don't guess
7. **Document everything** - Next instance has no memory of you

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-02-02 | Initial release |
