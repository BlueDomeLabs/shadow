---
name: spec-review
description: Comprehensive audit of spec documents against Coding Standards. Runs automatically with parallel agents.
---

# Spec Review Skill

## Purpose

Audit specification documents against 02_CODING_STANDARDS.md to ensure specs are internally consistent and compliant.

## When to Use

- After Coding Standards updates
- Before major implementation phases
- When spec drift is suspected
- When evaluating PATH A (update spec) decisions

---

## AUTOMATIC EXECUTION PROTOCOL

**Execute these steps in order. Do NOT skip phases.**

---

## Phase 1: Compliance Audit (Parallel Agents)

Launch 5 Task agents IN PARALLEL to audit different spec areas:

```
YOU MUST launch all 5 agents in a SINGLE message with multiple Task tool calls.
```

### Agent 1: Entity Specifications

```
Prompt for Task agent (subagent_type: Explore):

Audit entity specifications in 22_API_CONTRACTS.md against 02_CODING_STANDARDS.md.

CHECK EACH ENTITY FOR:
1. Required fields present: id, clientId, profileId, syncMetadata
2. All timestamps are int (epoch milliseconds), NOT DateTime
3. All enums have explicit integer values for database storage
4. Uses @Freezed(toJson: true, fromJson: true) annotation
5. Uses @JsonSerializable(explicitToJson: true) on factory
6. Field naming follows camelCase convention
7. Optional fields use nullable types (String?, int?)
8. Default values use @Default() annotation

OUTPUT FORMAT:
## Entity Compliance Report

### Compliant Entities
- [List entities that pass all checks]

### Violations
| Entity | Field/Issue | Rule Violated | Severity |
|--------|-------------|---------------|----------|

### Ambiguities
- [Unclear specifications needing clarification]
```

### Agent 2: Repository Specifications

```
Prompt for Task agent (subagent_type: Explore):

Audit repository specifications in 22_API_CONTRACTS.md against 02_CODING_STANDARDS.md.

CHECK EACH REPOSITORY FOR:
1. All methods return Result<T, AppError> (never throw)
2. Extends EntityRepository<T, String>
3. Has standard CRUD methods: getAll, getById, create, update, delete
4. Has sync methods: getModifiedSince, getPendingSync
5. Method names follow conventions (get*, create*, update*, delete*)
6. Parameters use correct types (String for IDs, int for timestamps)
7. No raw exceptions in signatures

OUTPUT FORMAT:
## Repository Compliance Report

### Compliant Repositories
- [List repositories that pass all checks]

### Violations
| Repository | Method/Issue | Rule Violated | Severity |
|------------|--------------|---------------|----------|

### Ambiguities
- [Unclear specifications]
```

### Agent 3: Use Case Specifications

```
Prompt for Task agent (subagent_type: Explore):

Audit use case specifications in 22_API_CONTRACTS.md against 02_CODING_STANDARDS.md.

CHECK EACH USE CASE FOR:
1. Authorization check is FIRST (before validation)
2. Uses canRead/canWrite from ProfileAuthorizationService
3. Validation comes AFTER authorization
4. Input classes use @freezed annotation
5. Returns Result<T, AppError>
6. Implements UseCase<Input, Output> interface
7. ID generation uses Uuid().v4() in use case, not repository
8. SyncMetadata created in use case with current timestamp

OUTPUT FORMAT:
## Use Case Compliance Report

### Compliant Use Cases
- [List use cases that pass all checks]

### Violations
| Use Case | Issue | Rule Violated | Severity |
|----------|-------|---------------|----------|

### Ambiguities
- [Unclear specifications]
```

### Agent 4: Error Handling Specifications

```
Prompt for Task agent (subagent_type: Explore):

Audit error handling specifications in 22_API_CONTRACTS.md against 02_CODING_STANDARDS.md.

CHECK FOR:
1. All error codes are from approved list in AppError hierarchy
2. Uses sealed class pattern: AppError -> DatabaseError, AuthError, etc.
3. Factory constructors defined for common errors
4. Error messages use localization keys (not hardcoded strings)
5. ValidationError uses fromFieldErrors pattern
6. No generic "catch (e)" without specific handling

OUTPUT FORMAT:
## Error Handling Compliance Report

### Compliant Patterns
- [List error patterns that pass]

### Violations
| Location | Error Type | Rule Violated | Severity |
|----------|------------|---------------|----------|

### Ambiguities
- [Unclear error handling specifications]
```

### Agent 5: Cross-Cutting Concerns

```
Prompt for Task agent (subagent_type: Explore):

Audit cross-cutting specifications across all spec documents against 02_CODING_STANDARDS.md.

CHECK FOR:
1. File naming matches class naming (snake_case files, PascalCase classes)
2. Import ordering: dart, package, relative
3. Layer dependencies correct: presentation -> domain -> data (no reverse)
4. All public APIs have documentation comments
5. Test file naming matches implementation (foo_test.dart for foo.dart)
6. Barrel files (exports) are consistent

OUTPUT FORMAT:
## Cross-Cutting Compliance Report

### Compliant Areas
- [List areas that pass]

### Violations
| Document | Section | Rule Violated | Severity |
|----------|---------|---------------|----------|

### Ambiguities
- [Unclear cross-cutting specifications]
```

---

## Phase 2: Aggregate and Evaluate Violations

After all 5 agents complete:

1. **Collect all violations** from agent reports
2. **Sort by severity:** Critical > High > Medium > Low
3. **For each violation, determine:**
   - Is the spec wrong? → Propose spec fix
   - Is the standard unclear? → Document in 53_SPEC_CLARIFICATIONS.md
   - Is it a judgment call? → Flag for user decision

### Violation Categories

| Category | Action |
|----------|--------|
| **Auto-fix** | Clear spec error with obvious correction |
| **User decision** | Multiple valid interpretations |
| **Standards question** | Standard itself may need clarification |

---

## Phase 3: Code Example Verification

Search for dart code blocks in specs and verify they would compile:

```bash
# Find all dart code blocks in spec files
grep -n '```dart' 22_API_CONTRACTS.md | head -20
```

For each significant code example:
1. Check syntax is valid Dart
2. Check types are consistent with entity/repository definitions
3. Check imports would resolve
4. Flag any obvious compilation errors

**Skip blocks marked with:**
- `// Example only`
- `// Pseudocode`
- `// Simplified`

---

## Phase 4: Integrity Checks

Verify cross-references are consistent:

### Check 1: Entity-Repository Alignment
- Every entity in spec has a corresponding repository
- Repository methods reference correct entity types

### Check 2: Use Case-Repository Alignment
- Use cases call repository methods that exist
- Input fields map to entity fields correctly

### Check 3: Completeness
- Every entity has: Entity, Repository, at least one Use Case
- Every use case has: Input class defined

---

## Phase 5: Generate Report

Create report at `.claude/audit-reports/YYYY-MM-DD-spec-review.md`:

```markdown
# Spec Review Report - [DATE]

## Executive Summary
- Specs reviewed: [list]
- Total violations: N
- Critical: N | High: N | Medium: N | Low: N
- Auto-fixable: N
- Requires user decision: N

## Phase 1: Compliance Audit Results

### Entity Specifications
[Agent 1 findings]

### Repository Specifications
[Agent 2 findings]

### Use Case Specifications
[Agent 3 findings]

### Error Handling
[Agent 4 findings]

### Cross-Cutting Concerns
[Agent 5 findings]

## Phase 2: Proposed Fixes

### Auto-Fix (Ready to Apply)
| Spec | Location | Current | Proposed | Rationale |
|------|----------|---------|----------|-----------|

### Requires User Decision
| Spec | Location | Issue | Options |
|------|----------|-------|---------|

## Phase 3: Code Example Issues
[List any code blocks with syntax/type errors]

## Phase 4: Integrity Issues
[List any cross-reference inconsistencies]

## Recommendations
1. [Prioritized action items]

## Next Steps
- [ ] Review auto-fix proposals
- [ ] Decide on user-decision items
- [ ] Apply approved fixes
- [ ] Re-run /spec-review to verify
```

---

## Quick Reference

### Severity Levels

| Level | Definition | Example |
|-------|------------|---------|
| **Critical** | Breaks implementation | Missing required field in entity |
| **High** | Causes bugs | Wrong return type on method |
| **Medium** | Inconsistency | Naming convention violation |
| **Low** | Style issue | Missing documentation |

### Common Violations

| Violation | Standard Reference | Fix |
|-----------|-------------------|-----|
| DateTime instead of int | Section 5.1 | Use epoch milliseconds |
| Throwing exceptions | Section 3.2 | Return Result<T, AppError> |
| Validation before auth | Section 4.5 | Authorization FIRST |
| Missing syncMetadata | Section 5.1 | Add required field |

---

## After Completion

1. **If violations found:** Present report to user for approval
2. **If auto-fixes approved:** Apply changes to spec documents
3. **If clean:** Report "Spec review passed - no violations found"
4. **Always:** Save report to `.claude/audit-reports/`

---

## Focused Review Mode

For evaluating specific deviations (PATH A vs PATH B decisions), use focused review:

### When to Use Focused Mode

- Evaluating if an implementation deviation should update the spec (PATH A)
- Checking if a proposed pattern complies with standards
- Quick validation without full audit

### Focused Review Process

1. **Identify the deviation** - What differs between spec and implementation?

2. **Launch single Task agent:**
```
Prompt for Task agent (subagent_type: Explore):

Read 02_CODING_STANDARDS.md and evaluate if this implementation pattern complies:

**Pattern to evaluate:**
[Describe the specific pattern]

**Questions to answer:**
1. Does this pattern comply with Coding Standards?
2. Is it explicitly allowed, forbidden, or not mentioned?
3. If compliant, is it BETTER than the current spec?
4. What is the relevant section in Coding Standards?

**Provide verdict:** COMPLIANT / VIOLATING / AMBIGUOUS
```

3. **Decision matrix:**

| Verdict | Spec Has | Implementation Has | Action |
|---------|----------|-------------------|--------|
| COMPLIANT | Pattern A | Pattern B (better) | PATH A - Update spec |
| COMPLIANT | Pattern A | Pattern B (equivalent) | Either path OK |
| VIOLATING | Pattern A | Pattern B | PATH B - Fix code |
| AMBIGUOUS | Pattern A | Pattern B | Ask user or document in 53_SPEC_CLARIFICATIONS.md |

### Example Focused Review

```
User has implementation with `@Default('') String notes` but spec says `String? notes`.

1. Check 02_CODING_STANDARDS.md Section 5.2 (Null Safety and Default Values)
2. Check if entity uses same pattern
3. If entity has @Default(''), input should match for consistency
4. Verdict: COMPLIANT - update spec to match implementation
```

---

## Notes

- This skill audits SPECS against STANDARDS
- For auditing IMPLEMENTATIONS against SPECS, use `/implementation-review`
- Control document is always 02_CODING_STANDARDS.md
- When in doubt, the standard wins
