# Implementation Review Skill

## Purpose

Compare the entire implementation layer against Project Specification documents. Implementations must EXACTLY match specifications.

## Invocation

- Command: `/implementation-review`
- Trigger: After completing implementation work, when deviations suspected, before releases

---

## THE RULE

```
Implementation === Specification (EXACT MATCH REQUIRED)
```

No interpretations. No "improvements" without spec changes. No shortcuts.

---

## When Deviation Found: Two Paths

```
                    DEVIATION FOUND
                          │
                          ▼
         ┌────────────────────────────────┐
         │  Is implementation BETTER and  │
         │  complies with Coding Stds?    │
         └────────────────┬───────────────┘
                          │
            ┌─────────────┴─────────────┐
            │                           │
            ▼                           ▼
           YES                          NO
            │                           │
            ▼                           ▼
   ┌─────────────────┐         ┌─────────────────┐
   │ PATH A:         │         │ PATH B:         │
   │ Update Spec     │         │ Fix Code        │
   │                 │         │                 │
   │ 1. Change spec  │         │ 1. Change code  │
   │    to match     │         │    to EXACTLY   │
   │    implementation│        │    match spec   │
   │                 │         │                 │
   │ 2. RUN          │         │ 2. Run tests    │
   │    /spec-review │         │                 │
   │    (MANDATORY)  │         │ 3. Commit       │
   │                 │         │                 │
   │ 3. If passes,   │         └─────────────────┘
   │    commit       │
   │                 │
   │ 4. If fails,    │
   │    revert spec  │
   │    and do       │
   │    PATH B       │
   └─────────────────┘
```

**PATH A is the exception. PATH B is the default.**

---

## IMPLEMENTATION PLAN

**Status: NOT YET IMPLEMENTED**

---

### Phase 1: Inventory All Implementations

**Parallel Task Agents scan:**
- `lib/domain/entities/*.dart` → Entity implementations
- `lib/domain/repositories/*.dart` → Repository interfaces
- `lib/data/repositories/*.dart` → Repository implementations
- `lib/domain/usecases/**/*.dart` → Use case implementations
- `lib/data/datasources/**/*.dart` → DAO implementations
- `lib/core/**/*.dart` → Core infrastructure

**Output:** List of all files requiring spec comparison

---

### Phase 2: Compare Each Implementation to Spec

**For each implementation file:**

1. Find corresponding spec section in `22_API_CONTRACTS.md`
2. Compare EXACTLY:
   - Field names, types, order
   - Method names, signatures, return types
   - Required vs optional parameters
   - Default values
   - Annotations
   - Logic flow (for use cases)

3. Document any deviation with:
   - File and line number
   - What spec says
   - What implementation has
   - Severity (critical/high/medium/low)

---

### Phase 3: Evaluate Each Deviation

**For each deviation, determine path:**

**PATH B (Fix Code) - DEFAULT:**
- Implementation doesn't comply with Coding Standards
- Implementation is not demonstrably better
- Spec approach is correct, implementation drifted

**PATH A (Update Spec) - EXCEPTION:**
- Implementation fully complies with Coding Standards AND
- Implementation is objectively more professional AND
- Clear justification exists for why spec was suboptimal

---

### Phase 4: Execute Resolutions

**For PATH B deviations:**
1. Edit implementation to EXACTLY match spec
2. Run tests
3. Run analyzer
4. Commit fix

**For PATH A deviations:**
1. Edit spec document to match implementation
2. Document justification in spec (comment or ADR)
3. **RUN `/spec-review` - MANDATORY BEFORE COMMIT**
4. If `/spec-review` PASSES → Commit spec change
5. If `/spec-review` FAILS → Revert spec, do PATH B instead

---

### Phase 5: Final Verification

```bash
flutter test
flutter analyze --fatal-infos --fatal-warnings
dart format --set-exit-if-changed lib/ test/
```

All must pass before review is complete.

---

## Task Agent Structure

```
Agent 1: Entity Review
Agent 2: Repository Review
Agent 3: Use Case Review
Agent 4: Data Layer Review
Agent 5: Core Infrastructure Review
```

Each agent compares its domain, documents deviations, proposes resolutions.

---

## Report Format

```markdown
# Implementation Review Report - YYYY-MM-DD

## Summary
- Files reviewed: N
- Exact matches: N
- Deviations found: N
- PATH B fixes (code changed): N
- PATH A updates (spec changed): N

## PATH B Fixes Applied
| File | Deviation | Fix Applied |
|------|-----------|-------------|

## PATH A Spec Updates
| Spec Section | Change | Justification | /spec-review Result |
|--------------|--------|---------------|---------------------|

## Verification
- Tests: PASS/FAIL
- Analyzer: PASS/FAIL
```

---

## Critical Reminder

**When taking PATH A (updating spec):**

```
1. Update spec document
2. RUN /spec-review ← DO NOT SKIP THIS
3. Only commit if /spec-review passes
4. If /spec-review fails, revert and take PATH B
```

The `/spec-review` ensures your spec change didn't break internal consistency, violate Coding Standards, or introduce compilation errors in spec examples.
