# Implementation Review Skill

## Purpose

Compare implementations against 22_API_CONTRACTS.md specifications. Implementations must EXACTLY match specs OR spec must be updated via PATH A.

## When to Use

- After completing implementation work
- When deviations suspected
- Before releases
- When evaluating PATH A (update spec) vs PATH B (fix code) decisions

---

## AUTOMATIC EXECUTION PROTOCOL

**Execute these steps in order. Do NOT skip phases.**

---

## Phase 1: Implementation Audit (Parallel Agents)

Launch 5 Task agents IN PARALLEL to audit different implementation areas:

```
YOU MUST launch all 5 agents in a SINGLE message with multiple Task tool calls.
```

### Agent 1: Entity Implementations

```
Prompt for Task agent (subagent_type: Explore):

Compare entity implementations in lib/domain/entities/ against 22_API_CONTRACTS.md.

FOR EACH ENTITY FILE:
1. Find the corresponding spec section in 22_API_CONTRACTS.md
2. Compare EXACTLY:
   - Field names (must match exactly, including casing)
   - Field types (must match exactly)
   - Field order (should match spec order)
   - Required vs optional (@Default vs nullable)
   - Annotations (@Freezed, @JsonSerializable, etc.)
   - Default values (@Default(''), @Default(0), etc.)

3. Document ANY deviation with:
   - File path and line number
   - What spec says
   - What implementation has
   - Whether this is a SEMANTIC difference or COSMETIC difference

OUTPUT FORMAT:
## Entity Implementation Report

### Exact Matches
- [List entities that match spec exactly]

### Deviations Found
| Entity | Field/Annotation | Spec Says | Code Has | Type |
|--------|------------------|-----------|----------|------|

(Type: SEMANTIC = affects behavior, COSMETIC = formatting/order only)
```

### Agent 2: Repository Implementations

```
Prompt for Task agent (subagent_type: Explore):

Compare repository implementations in lib/domain/repositories/ and lib/data/repositories/ against 22_API_CONTRACTS.md.

FOR EACH REPOSITORY:
1. Find the corresponding spec section in 22_API_CONTRACTS.md
2. Compare EXACTLY:
   - Method names (must match exactly)
   - Method signatures (parameters, types, return types)
   - Return type is Result<T, AppError> (never throws)
   - Parameter names and types

3. Document ANY deviation with:
   - File path and line number
   - What spec says
   - What implementation has

OUTPUT FORMAT:
## Repository Implementation Report

### Exact Matches
- [List repositories that match spec exactly]

### Deviations Found
| Repository | Method | Spec Says | Code Has | Type |
|------------|--------|-----------|----------|------|
```

### Agent 3: Use Case Implementations

```
Prompt for Task agent (subagent_type: Explore):

Compare use case implementations in lib/domain/usecases/**/ against 22_API_CONTRACTS.md.

FOR EACH USE CASE:
1. Find the corresponding spec section in 22_API_CONTRACTS.md
2. Compare EXACTLY:
   - Input class fields (names, types, required vs optional)
   - Default values (@Default annotations)
   - Authorization check is FIRST (before validation)
   - Validation logic matches spec
   - Return type matches spec

3. Document ANY deviation with:
   - File path and line number
   - What spec says
   - What implementation has

OUTPUT FORMAT:
## Use Case Implementation Report

### Exact Matches
- [List use cases that match spec exactly]

### Deviations Found
| Use Case | Input/Logic | Spec Says | Code Has | Type |
|----------|-------------|-----------|----------|------|
```

### Agent 4: DAO Implementations

```
Prompt for Task agent (subagent_type: Explore):

Compare DAO implementations in lib/data/datasources/local/daos/ against 10_DATABASE_SCHEMA.md and 22_API_CONTRACTS.md.

FOR EACH DAO:
1. Verify table columns match 10_DATABASE_SCHEMA.md
2. Verify all 9 sync metadata columns present
3. Verify CRUD methods wrap operations in Result<T, AppError>
4. Verify no raw exceptions thrown

OUTPUT FORMAT:
## DAO Implementation Report

### Exact Matches
- [List DAOs that match spec exactly]

### Deviations Found
| DAO | Issue | Spec Says | Code Has | Type |
|-----|-------|-----------|----------|------|
```

### Agent 5: Input Class Implementations

```
Prompt for Task agent (subagent_type: Explore):

Compare input class implementations (lib/domain/usecases/**/*_inputs.dart) against 22_API_CONTRACTS.md.

FOR EACH INPUT CLASS:
1. Find the corresponding spec section in 22_API_CONTRACTS.md
2. Compare EXACTLY:
   - Field names and types
   - Required vs optional fields
   - @Default annotations and their values
   - @freezed annotation present

3. Document ANY deviation with:
   - File path and line number
   - What spec says
   - What implementation has

OUTPUT FORMAT:
## Input Class Implementation Report

### Exact Matches
- [List input classes that match spec exactly]

### Deviations Found
| Input Class | Field | Spec Says | Code Has | Type |
|-------------|-------|-----------|----------|------|
```

---

## Phase 2: Evaluate Each Deviation (PATH A vs PATH B)

After all 5 agents complete, for EACH deviation found:

### Step 2.1: Launch Evaluation Agent

For each SEMANTIC deviation (not cosmetic), launch a Task agent:

```
Prompt for Task agent (subagent_type: Explore):

Evaluate this implementation deviation against 02_CODING_STANDARDS.md:

**Deviation:**
- Location: [file:line]
- Spec says: [spec version]
- Implementation has: [code version]

**Questions to answer:**
1. Does the IMPLEMENTATION comply with 02_CODING_STANDARDS.md?
2. Does the SPEC version comply with 02_CODING_STANDARDS.md?
3. Is the implementation approach OBJECTIVELY BETTER? Consider:
   - More type-safe?
   - More defensive (handles edge cases)?
   - More consistent with existing patterns?
   - Follows Dart/Flutter idioms better?
4. What is the relevant section in Coding Standards?

**Provide verdict:**
- PATH_A: Implementation is better AND complies with standards. Update spec.
- PATH_B: Spec is correct. Fix implementation.
- AMBIGUOUS: Cannot determine. Needs human decision.

Include the specific Coding Standards section that justifies your verdict.
```

### Step 2.2: Decision Matrix

| Evaluation Result | Action |
|-------------------|--------|
| **PATH_A** | Implementation wins - update spec to match code |
| **PATH_B** | Spec wins - fix code to match spec |
| **AMBIGUOUS** | Flag for user decision |

---

## Phase 3: Execute PATH B Fixes

For each PATH_B deviation:

1. **Edit the implementation file** to EXACTLY match the spec
2. **Document the change** in the report

```
Pattern for PATH B fix:
- Read the spec version from 22_API_CONTRACTS.md
- Edit the implementation to match EXACTLY
- No interpretation, no "improvements"
```

---

## Phase 4: Execute PATH A Spec Updates

For each PATH_A deviation:

### Step 4.1: Cross-Codebase Consistency Check (MANDATORY)

Before updating the spec, verify the change won't break existing code:

```
Prompt for Task agent (subagent_type: Explore):

Analyze cross-codebase consistency for this proposed spec change:

**Proposed change:**
- Pattern being adopted: [implementation pattern]
- Original spec pattern: [spec pattern]

**Search the codebase for:**
1. Other implementations using the ORIGINAL spec pattern
   - Search lib/ for similar patterns
   - List all files that would need updating if spec changes

2. Other implementations already using the NEW pattern
   - Does this pattern exist elsewhere in the codebase?
   - Is it used consistently where it appears?

3. Dependent code that might break
   - What code calls/uses this entity/method/input?
   - Would those callers break with the new pattern?
   - Are there tests that would fail?

**Answer these questions:**
1. How many files use the original pattern? (List them)
2. How many files already use the new pattern? (List them)
3. Will any existing code BREAK if we adopt the new pattern?
4. Should this pattern change be applied to ALL similar code for consistency?

**Provide verdict:**
- SAFE: No breaking changes, can proceed with PATH A
- REQUIRES_UPDATES: Other code needs updating for consistency (list files)
- BREAKING: Would break existing code, recommend PATH B instead
```

### Step 4.2: Handle Consistency Check Result

| Result | Action |
|--------|--------|
| **SAFE** | Proceed to spec update |
| **REQUIRES_UPDATES** | Update ALL affected code first, then update spec |
| **BREAKING** | Abort PATH A, do PATH B instead |

### Step 4.3: Update the Spec

1. Edit 22_API_CONTRACTS.md to match the implementation
2. Add a comment explaining why (if not obvious)
3. If REQUIRES_UPDATES: Also update all other affected implementations for consistency

### Step 4.4: Run /spec-review Focused Mode (MANDATORY)

```
Prompt for Task agent (subagent_type: Explore):

Read 02_CODING_STANDARDS.md and evaluate if this spec change complies:

**Spec change made:**
[Description of what was changed in 22_API_CONTRACTS.md]

**Questions to answer:**
1. Does this pattern comply with Coding Standards?
2. Is it explicitly allowed, forbidden, or not mentioned?
3. What is the relevant section in Coding Standards?

**Provide verdict:** COMPLIANT / VIOLATING / AMBIGUOUS
```

### Step 4.5: Handle /spec-review Result

| Result | Action |
|--------|--------|
| **COMPLIANT** | Keep spec change, proceed |
| **VIOLATING** | Revert spec change AND any code updates, do PATH B instead |
| **AMBIGUOUS** | Document in 53_SPEC_CLARIFICATIONS.md, ask user |

---

## Phase 5: Final Compliance Verification

After all fixes applied:

### Step 5.1: Run Tests
```bash
flutter test
```
If tests fail: Fix before proceeding.

### Step 5.2: Run Analyzer
```bash
flutter analyze --fatal-infos --fatal-warnings
```
If issues found: Fix before proceeding.

### Step 5.3: Run Formatter
```bash
dart format --set-exit-if-changed lib/ test/
```
If changes needed: Apply and re-verify.

### Step 5.4: Final Coding Standards Check

Launch verification agent:

```
Prompt for Task agent (subagent_type: Explore):

Verify all changes made in this review comply with 02_CODING_STANDARDS.md.

Files modified: [list files]

For each file, verify:
1. All timestamps are int (epoch milliseconds)
2. All methods return Result<T, AppError>
3. Authorization checks come BEFORE validation in use cases
4. All entities have required fields (id, clientId, profileId, syncMetadata)
5. All enums have explicit integer values
6. Naming conventions followed (camelCase fields, PascalCase classes)

Report any violations found.
```

---

## Phase 6: Generate Report

Create report at `.claude/audit-reports/YYYY-MM-DD-implementation-review.md`:

```markdown
# Implementation Review Report - [DATE]

## Executive Summary
- Files reviewed: N
- Exact matches: N
- Deviations found: N
- PATH A (spec updated): N
- PATH B (code fixed): N
- Ambiguous (user decision needed): N

## Phase 1: Implementation Audit Results

### Entity Implementations
[Agent 1 findings]

### Repository Implementations
[Agent 2 findings]

### Use Case Implementations
[Agent 3 findings]

### DAO Implementations
[Agent 4 findings]

### Input Class Implementations
[Agent 5 findings]

## Phase 2-4: Deviation Resolutions

### PATH A - Spec Updated to Match Implementation
| Location | Original Spec | New Spec | Justification | /spec-review |
|----------|---------------|----------|---------------|--------------|

### PATH B - Code Fixed to Match Spec
| File | Original Code | Fixed Code | Spec Reference |
|------|---------------|------------|----------------|

### Ambiguous - Requires User Decision
| Location | Spec Says | Code Has | Why Ambiguous |
|----------|-----------|----------|---------------|

## Phase 5: Final Verification
- Tests: PASS/FAIL (N tests)
- Analyzer: PASS/FAIL
- Formatter: PASS/FAIL
- Coding Standards: COMPLIANT/VIOLATIONS

## Recommendations
1. [Prioritized action items if any remain]

## Next Steps
- [ ] Review ambiguous items
- [ ] Commit approved changes
- [ ] Re-run /implementation-review to verify
```

---

## Quick Reference

### PATH A Criteria (ALL must be true)

1. Implementation COMPLIES with 02_CODING_STANDARDS.md
2. Implementation is OBJECTIVELY BETTER:
   - More type-safe
   - More defensive
   - More idiomatic Dart/Flutter
   - More consistent with existing patterns
3. **Cross-codebase consistency check passes** (no breaking changes)
4. If other code uses old pattern: ALL affected code updated for consistency
5. /spec-review passes after spec update

### PATH B Criteria (ANY is sufficient)

1. Implementation VIOLATES 02_CODING_STANDARDS.md
2. Implementation is NOT demonstrably better
3. Spec approach is explicitly required by standards
4. **Cross-codebase consistency check returns BREAKING**
5. /spec-review fails after spec update attempt

### Common PATH A Examples

| Deviation | Why PATH A |
|-----------|------------|
| `@Default('') String notes` vs `String? notes` | Non-null with default is more defensive |
| `.isNotEmpty` check vs `!= null` only | Handles empty string edge case |
| Additional photo path fields | Implementation discovered needed data |

### Common PATH B Examples

| Deviation | Why PATH B |
|-----------|------------|
| DateTime instead of int | Violates timestamp standard |
| Throwing exceptions | Violates Result<T, AppError> standard |
| Validation before authorization | Violates use case pattern |
| Missing syncMetadata | Violates entity requirements |
| Pattern change breaks 10+ callers | Consistency check returned BREAKING |

### Consistency Check Examples

| Scenario | Result | Action |
|----------|--------|--------|
| New pattern, no other code affected | SAFE | Proceed with PATH A |
| Pattern used in 3 files, all can update | REQUIRES_UPDATES | Update all 3, then PATH A |
| Pattern change breaks test assertions | BREAKING | Use PATH B instead |
| New field added, nothing else uses it | SAFE | Proceed with PATH A |

---

## After Completion

1. **If all resolved:** Report "Implementation review passed"
2. **If ambiguous items:** Present to user for decision
3. **Always:** Save report to `.claude/audit-reports/`
4. **Always:** Ensure tests pass and analyzer clean before finishing

---

## Notes

- This skill audits IMPLEMENTATIONS against SPECS
- For auditing SPECS against STANDARDS, use `/spec-review`
- Control document is 02_CODING_STANDARDS.md
- When in doubt: PATH B (fix code to match spec)
- PATH A requires explicit justification AND /spec-review pass
