# Shadow Engineering Governance

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Controls and processes for consistent multi-engineer development

---

## Overview

This document defines the governance structure, processes, and controls required to maintain consistency across a large engineering team. All engineers MUST follow these processes.

---

## 1. Team Structure

### 1.1 Code Ownership Model

```
Shadow Codebase
├── Core Team (3 engineers)
│   ├── lib/core/           - Error handling, services, utilities
│   ├── lib/domain/         - Entities, repositories, use cases
│   └── Database schema     - All migrations
│
├── Feature Teams (8 engineers each)
│   ├── Team Conditions     - Condition tracking features
│   ├── Team Supplements    - Supplement management
│   ├── Team Nutrition      - Food, diet types
│   ├── Team Wellness       - Sleep, fluids, activities
│   ├── Team Sync           - Cloud sync, conflict resolution
│   └── Team Platform       - Notifications, deep linking
│
├── UI/UX Team (4 engineers)
│   ├── lib/presentation/widgets/  - Consolidated widget library
│   └── lib/presentation/theme/    - Design system
│
└── Quality Team (2 engineers)
    ├── test/                       - Test infrastructure
    └── CI/CD                       - Pipeline maintenance
```

### 1.2 CODEOWNERS File

```
# .github/CODEOWNERS

# Core - requires Core Team approval
/lib/core/                    @shadow/core-team
/lib/domain/entities/         @shadow/core-team
/lib/domain/repositories/     @shadow/core-team
/lib/domain/usecases/         @shadow/core-team

# Database - requires Core Team + DBA
/lib/data/datasources/local/database*.dart  @shadow/core-team @shadow/dba

# Features - require feature team + core team
/lib/**/supplement*           @shadow/team-supplements @shadow/core-team
/lib/**/condition*            @shadow/team-conditions @shadow/core-team
/lib/**/food*                 @shadow/team-nutrition @shadow/core-team
/lib/**/fluids*               @shadow/team-wellness @shadow/core-team
/lib/**/sleep*                @shadow/team-wellness @shadow/core-team
/lib/**/sync*                 @shadow/team-sync @shadow/core-team
/lib/**/notification*         @shadow/team-platform @shadow/core-team

# Widgets - require UI team
/lib/presentation/widgets/    @shadow/ui-team
/lib/presentation/theme/      @shadow/ui-team

# Tests - require quality team
/test/                        @shadow/quality-team

# CI/CD - require quality team + tech lead
/.github/workflows/           @shadow/quality-team @shadow/tech-leads

# API Contracts - require architecture review
/docs/*_CONTRACTS.md          @shadow/architects
```

---

## 2. Development Workflow

### 2.1 Branch Strategy

```
main (protected)
  │
  ├── release/v1.1.0 (protected)
  │     │
  │     └── hotfix/v1.1.1-auth-fix
  │
  └── develop (protected)
        │
        ├── feature/SHADOW-123-fluids-bbt
        ├── feature/SHADOW-124-notification-deep-link
        └── feature/SHADOW-125-diet-type-selector
```

**Rules:**
- `main`: Production. Requires 2 approvals + passing CI + tech lead sign-off
- `release/*`: Release candidates. Requires 2 approvals + QA sign-off
- `develop`: Integration branch. Requires 2 approvals + passing CI
- `feature/*`: Feature work. Must include ticket number (SHADOW-XXX)
- `hotfix/*`: Emergency fixes. Requires tech lead approval

### 2.2 Commit Message Format

```
<type>(<scope>): <subject>

[optional body]

[optional footer]

SHADOW-XXX
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code change that neither fixes nor adds
- `test`: Adding tests
- `docs`: Documentation only
- `style`: Formatting, missing semicolons, etc.
- `perf`: Performance improvement
- `chore`: Build process or auxiliary tool changes

**Example:**
```
feat(fluids): add BBT temperature input with validation

- Add BBTInputWidget with temperature range validation
- Support both Fahrenheit and Celsius units
- Include time picker for recording time

Acceptance criteria verified:
- [x] Temperature range validated (95-105°F)
- [x] Unit toggle works correctly
- [x] Time picker shows correct default

SHADOW-456
```

### 2.3 Pull Request Template

```markdown
## Description
<!-- What does this PR do? -->

## Related Issue
SHADOW-XXX

## Type of Change
- [ ] Feature
- [ ] Bug fix
- [ ] Refactor
- [ ] Documentation
- [ ] Test

## Checklist
### Code Quality
- [ ] Code follows API Contracts (22_API_CONTRACTS.md)
- [ ] All methods use Result type (no throwing)
- [ ] Validation rules from ValidationRules class used
- [ ] Error codes from defined constants used

### Testing
- [ ] Unit tests added/updated (coverage maintained)
- [ ] Widget tests for UI changes
- [ ] Integration tests for new flows
- [ ] Contract tests pass

### Documentation
- [ ] Code comments for complex logic
- [ ] API documentation updated if public interface changed
- [ ] Spec documents updated if behavior changed

### Accessibility
- [ ] Semantic labels on all interactive elements
- [ ] Touch targets minimum 48x48
- [ ] Screen reader tested (if UI change)

### Generated Code
- [ ] Ran `dart run build_runner build`
- [ ] Generated files committed

## Screenshots (if UI change)
<!-- Before/After screenshots -->

## Test Plan
<!-- How to verify this works -->
```

---

## 3. Quality Gates

### 3.1 Required Checks

| Check | Blocking | Details |
|-------|----------|---------|
| `flutter analyze` | Yes | Zero warnings, zero infos |
| `flutter test` | Yes | 100% pass rate |
| Coverage threshold | Yes | 100% for all code |
| Contract tests | Yes | All interface contracts valid |
| Build (iOS) | Yes | Successful build |
| Build (Android) | Yes | Successful build |
| Build (macOS) | Yes | Successful build |
| Lint rules | Yes | Custom lint rules pass |
| Commit format | Yes | Conventional commits |
| Generated files | Yes | Up to date |

### 3.2 Code Coverage Requirements

> **Canonical Source:** All coverage requirements are defined in `02_CODING_STANDARDS.md` Section 10.3.

| Area | Minimum | Target |
|------|---------|--------|
| Domain Entities | 100% | 100% |
| Data Models | 100% | 100% |
| Data Sources | 100% | 100% |
| Repositories | 100% | 100% |
| Services | 100% | 100% |
| Providers | 100% | 100% |
| Widgets | 100% | 100% |
| Screens | 100% | 100% |
| **Overall** | **100%** | **100%** |

### 3.3 Review Requirements

| Change Type | Reviewers Required | Special Approvers |
|-------------|-------------------|-------------------|
| Core/Domain | 2 | Core Team member |
| Database schema | 2 | DBA + Core Team |
| API Contracts | 3 | Architect + 2 Core |
| Feature code | 2 | Feature Team + Core |
| Widget library | 2 | UI Team member |
| CI/CD | 2 | Quality Team + Tech Lead |
| Security-related | 3 | Security Team + Core |

---

## 4. Architecture Decision Records (ADRs)

### 4.1 When ADR Required

An ADR is REQUIRED for:
- Any change to API Contracts
- New dependencies
- Database schema changes
- New architectural patterns
- Deviation from established conventions
- Performance optimizations affecting architecture
- Security-related changes

### 4.2 ADR Template

```markdown
# ADR-XXX: Title

## Status
Proposed | Accepted | Deprecated | Superseded by ADR-YYY

## Context
What is the issue motivating this decision?

## Decision
What is the change being proposed?

## Consequences
What are the positive and negative effects?

## Alternatives Considered
What other options were evaluated?

## References
- Related ADRs
- External documentation
```

### 4.3 ADR Process

```
1. Engineer identifies need for architectural decision
         │
         ▼
2. Create ADR in /docs/adr/ with status "Proposed"
         │
         ▼
3. Submit PR for ADR (separate from implementation)
         │
         ▼
4. Architecture review meeting (weekly)
         │
         ├── Approved → Status: "Accepted", merge ADR
         │
         └── Rejected → Update ADR with feedback, re-review
         │
         ▼
5. Implementation PR references ADR number
```

---

## 5. Contract Testing

### 5.1 Contract Test Requirements

Every repository and use case MUST have contract tests:

```dart
// test/contracts/repositories/supplement_repository_contract_test.dart

@Tags(['contract'])
void main() {
  group('SupplementRepository Contract', () {
    late SupplementRepository repository;

    setUp(() {
      repository = SupplementRepositoryImpl(/* ... */);
    });

    group('getAll', () {
      test('returns Result<List<Supplement>, AppError>', () async {
        final result = await repository.getAll();

        expect(result, isA<Result<List<Supplement>, AppError>>());
      });

      test('returns empty list when no supplements, not null', () async {
        final result = await repository.getAll(profileId: 'empty-profile');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
        expect(result.valueOrNull, isNotNull);
      });
    });

    group('getById', () {
      test('returns Failure with DatabaseError.notFound for missing id', () async {
        final result = await repository.getById('non-existent-id');

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<DatabaseError>());
        expect((result.errorOrNull as DatabaseError).code,
            equals(DatabaseError.codeNotFound));
      });
    });

    group('create', () {
      test('returns created entity with generated ID', () async {
        final input = Supplement(id: '', /* ... */);
        final result = await repository.create(input);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, isNotEmpty);
        expect(result.valueOrNull!.id, isNot(equals('')));
      });

      test('returns created entity with sync metadata populated', () async {
        final input = Supplement(id: '', /* ... */);
        final result = await repository.create(input);

        expect(result.valueOrNull!.syncMetadata.createdAt, isNotNull);
        expect(result.valueOrNull!.syncMetadata.syncStatus, equals(SyncStatus.pending));
      });
    });
  });
}
```

### 5.2 Running Contract Tests

```bash
# Run all contract tests
flutter test --tags=contract

# Contract tests MUST pass before PR merge
# CI will run: flutter test --tags=contract --coverage
```

---

## 6. Consistency Enforcement

### 6.1 Pre-commit Hooks

```bash
#!/bin/bash
# .git/hooks/pre-commit

set -e

echo "Running pre-commit checks..."

# 1. Ensure generated files are up to date
echo "Checking generated files..."
dart run build_runner build --delete-conflicting-outputs
if [[ -n $(git status --porcelain | grep -E '\.(freezed|g)\.dart$') ]]; then
  echo "ERROR: Generated files are out of date. Please commit the changes."
  exit 1
fi

# 2. Run analyzer
echo "Running analyzer..."
flutter analyze --fatal-infos --fatal-warnings

# 3. Run format check
echo "Checking format..."
dart format --set-exit-if-changed lib/ test/

# 4. Run contract tests
echo "Running contract tests..."
flutter test --tags=contract

# 5. Check commit message format
echo "Checking commit message..."
commit_msg=$(cat "$1" 2>/dev/null || git log -1 --format=%B)
if ! echo "$commit_msg" | grep -qE '^(feat|fix|refactor|test|docs|style|perf|chore)\(.+\): .+'; then
  echo "ERROR: Commit message must follow format: type(scope): subject"
  exit 1
fi

if ! echo "$commit_msg" | grep -qE 'SHADOW-[0-9]+'; then
  echo "ERROR: Commit message must reference a ticket (SHADOW-XXX)"
  exit 1
fi

echo "All pre-commit checks passed!"
```

### 6.2 Custom Lint Rules

```dart
// tool/custom_lints/lib/rules/require_result_type.dart

class RequireResultTypeForRepositories extends DartLintRule {
  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodDeclaration((node) {
      // Check if this is a repository method
      if (!_isRepositoryMethod(node)) return;

      // Check return type is Future<Result<...>>
      final returnType = node.returnType?.type;
      if (returnType == null) {
        reporter.reportErrorForNode(
          LintCode('require_result_type', 'Repository methods must return Future<Result<T, AppError>>'),
          node,
        );
        return;
      }

      if (!_isResultType(returnType)) {
        reporter.reportErrorForNode(
          LintCode('require_result_type', 'Repository methods must return Future<Result<T, AppError>>, got ${returnType}'),
          node,
        );
      }
    });
  }
}
```

### 6.3 CI Validation

```yaml
# .github/workflows/validate.yml

name: Validate

on: [pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Generate code
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Check generated files committed
        run: |
          if [[ -n $(git status --porcelain) ]]; then
            echo "Generated files not committed:"
            git status --porcelain
            exit 1
          fi

      - name: Analyze
        run: flutter analyze --fatal-infos --fatal-warnings

      - name: Format check
        run: dart format --set-exit-if-changed lib/ test/

      - name: Contract tests
        run: flutter test --tags=contract

      - name: All tests
        run: flutter test --coverage

      - name: Check coverage
        run: |
          # Parse coverage and fail if below 100% threshold
          ./scripts/check_coverage.sh 100
```

---

## 7. Documentation Requirements

### 7.1 Self-Documenting Code Rules

| Element | Documentation Required |
|---------|----------------------|
| Public API | Dartdoc with `///` |
| Use Case | Purpose, inputs, outputs, errors |
| Repository method | What it does, when to use |
| Entity | Field descriptions |
| Complex logic | Inline comments explaining why |
| Magic numbers | Named constants with explanation |

### 7.2 Documentation Sync

```bash
# Run weekly
./scripts/sync_documentation.sh

# Checks:
# 1. All public APIs have Dartdoc
# 2. README files exist for each feature
# 3. API Contracts match actual interfaces
# 4. No TODO comments older than 30 days
```

### 7.3 Living Documentation

```yaml
# docs/LIVING_DOCS.yml
# Auto-generated from code - DO NOT EDIT

entities:
  - name: Supplement
    file: lib/domain/entities/supplement.dart
    fields: 12
    methods: 3

repositories:
  - name: SupplementRepository
    file: lib/domain/repositories/supplement_repository.dart
    methods:
      - getAll: "Future<Result<List<Supplement>, AppError>>"
      - getById: "Future<Result<Supplement, AppError>>"
      # ...

usecases:
  - name: GetSupplementsUseCase
    input: GetSupplementsInput
    output: List<Supplement>
    errors: [AuthError.profileAccessDenied, DatabaseError.*]
```

---

## 8. Conflict Prevention

### 8.1 Interface Lock

When working on shared interfaces:

1. Create ADR proposing interface change
2. Get approval BEFORE implementing
3. Interface changes require Core Team approval
4. All implementations updated in same PR

### 8.2 Feature Flags for WIP

All work-in-progress features MUST be behind feature flags:

```dart
// All new features default to disabled
if (featureFlags.isEnabled(FeatureFlags.fluidsBbtEnabled)) {
  // New BBT code
}
```

This prevents partial features from breaking the build.

### 8.3 Integration Windows

```
Monday-Wednesday: Feature development
Thursday: Integration testing, conflict resolution
Friday: Code freeze, release prep (for release weeks)
```

---

## 9. Onboarding Checklist

New engineers MUST complete:

- [ ] Read all specification documents (01-25)
- [ ] Complete API Contracts quiz (100% required)
- [ ] Shadow a PR review
- [ ] Submit first PR with mentor review
- [ ] Pass contract test certification
- [ ] Complete accessibility training
- [ ] Set up local hooks and tooling

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
