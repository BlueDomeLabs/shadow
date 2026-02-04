# Spec Review Skill

## Purpose

Comprehensive audit of project specification documents against Coding Standards, followed by verification testing of all code examples in specs.

## Invocation

- Command: `/spec-review`
- Trigger: After Coding Standards updates, before major implementation phases, when spec drift suspected
- Control Document: `02_CODING_STANDARDS.md` (the governing authority)

---

## IMPLEMENTATION PLAN

**Status: NOT YET IMPLEMENTED**

---

### Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                      SPEC REVIEW FLOW                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  02_CODING_STANDARDS.md (Control Document)                      │
│           │                                                     │
│           ▼                                                     │
│  ┌─────────────────────────────────────────┐                   │
│  │     PHASE 1: COMPLIANCE AUDIT           │                   │
│  │  (Multiple Task Agents in Parallel)     │                   │
│  └─────────────────────────────────────────┘                   │
│           │                                                     │
│           ▼                                                     │
│  ┌─────────────────────────────────────────┐                   │
│  │     PHASE 2: VIOLATION REMEDIATION      │                   │
│  │  (Fix specs to match standards)         │                   │
│  └─────────────────────────────────────────┘                   │
│           │                                                     │
│           ▼                                                     │
│  ┌─────────────────────────────────────────┐                   │
│  │     PHASE 3: CODE EXAMPLE EXTRACTION    │                   │
│  │  (Pull all ```dart blocks from specs)   │                   │
│  └─────────────────────────────────────────┘                   │
│           │                                                     │
│           ▼                                                     │
│  ┌─────────────────────────────────────────┐                   │
│  │     PHASE 4: COMPILATION VERIFICATION   │                   │
│  │  (Verify examples compile correctly)    │                   │
│  └─────────────────────────────────────────┘                   │
│           │                                                     │
│           ▼                                                     │
│  ┌─────────────────────────────────────────┐                   │
│  │     PHASE 5: INTEGRITY VERIFICATION     │                   │
│  │  (Cross-reference, consistency checks)  │                   │
│  └─────────────────────────────────────────┘                   │
│           │                                                     │
│           ▼                                                     │
│       AUDIT REPORT                                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

### Phase 1: Compliance Audit (Parallel Task Agents)

**Objective:** Verify all spec documents comply with Coding Standards

**Task Agent Assignments:**

```
Agent 1: Entity Specifications
├── Target: 22_API_CONTRACTS.md (Entity sections)
├── Check against: Coding Standards entity rules
├── Verify:
│   ├── All entities have required fields (id, clientId, profileId, syncMetadata)
│   ├── All timestamps are int (not DateTime)
│   ├── All enums have explicit integer values
│   ├── Freezed annotations specified correctly
│   ├── JSON serialization patterns correct
│   └── Field naming follows conventions

Agent 2: Repository Specifications
├── Target: 22_API_CONTRACTS.md (Repository sections)
├── Check against: Coding Standards repository rules
├── Verify:
│   ├── All methods return Result<T, AppError>
│   ├── No exception throwing specified
│   ├── Standard CRUD methods present
│   ├── Method naming follows conventions
│   └── Parameter types are correct

Agent 3: Use Case Specifications
├── Target: 22_API_CONTRACTS.md (Use Case sections)
├── Check against: Coding Standards use case rules
├── Verify:
│   ├── Authorization check is FIRST step
│   ├── Validation follows authorization
│   ├── Input classes use @freezed
│   ├── Required vs default parameters correct
│   ├── SyncMetadata handling specified
│   └── ID generation responsibility clear

Agent 4: Error Handling Specifications
├── Target: 22_API_CONTRACTS.md (Error sections)
├── Check against: Coding Standards error rules
├── Verify:
│   ├── All error codes from approved list
│   ├── Factory methods defined for all errors
│   ├── Error hierarchy correct
│   ├── Localization keys used
│   └── Recovery actions specified

Agent 5: Cross-Cutting Concerns
├── Target: All spec documents
├── Check against: Coding Standards general rules
├── Verify:
│   ├── Naming conventions consistent
│   ├── File organization patterns correct
│   ├── Import ordering specified
│   ├── Documentation requirements met
│   └── Testing requirements specified
```

**Agent Output Format:**
```markdown
## [Agent Name] Compliance Report

### Compliant
- [List of spec sections that pass]

### Violations
| Location | Rule Violated | Description | Severity |
|----------|---------------|-------------|----------|
| file:section | Rule ID | What's wrong | Critical/High/Medium/Low |

### Ambiguities
- [Spec sections that are unclear and need clarification]
```

---

### Phase 2: Violation Remediation

**Objective:** Fix any spec violations found in Phase 1

**Process:**
1. Aggregate all violations from Phase 1 agents
2. Sort by severity (Critical first)
3. For each violation:
   - Identify the correct standard from 02_CODING_STANDARDS.md
   - Propose spec update to achieve compliance
   - Document the change with rationale
4. Generate unified diff of all spec changes
5. Request user approval before applying

**Remediation Categories:**
- **Auto-fix:** Clear violations with obvious corrections
- **Manual review:** Ambiguous cases requiring human judgment
- **Standards question:** Cases where the standard itself may need clarification

---

### Phase 3: Code Example Extraction

**Objective:** Extract all compilable code examples from specs

**Process:**
1. Parse all spec documents for ```dart code blocks
2. Categorize each block:
   - Complete class definition
   - Method implementation
   - Code fragment (not standalone)
   - Test example
3. Generate extraction manifest:
   ```
   Source: 22_API_CONTRACTS.md:2054-2075
   Type: Complete class
   Class: GetSupplementsUseCase
   Dependencies: [SupplementRepository, ProfileAuthorizationService, ...]
   ```
4. Create verification test scaffold for each extractable example

**Extraction Rules:**
- Skip code blocks marked as `// Example only` or `// Pseudocode`
- Include blocks marked as `// EXACT IMPLEMENTATION`
- Track dependencies between examples

---

### Phase 4: Compilation Verification

**Objective:** Verify all spec code examples compile correctly

**Process:**
1. Create temporary verification project structure:
   ```
   .claude/spec-verification/
   ├── lib/
   │   ├── entities/      # Extracted entity examples
   │   ├── repositories/  # Extracted repository examples
   │   └── usecases/      # Extracted use case examples
   ├── test/
   │   └── compilation_test.dart  # Import verification
   └── pubspec.yaml       # Minimal dependencies
   ```

2. For each extracted example:
   - Write to appropriate file
   - Add necessary imports
   - Add minimal stubs for dependencies

3. Run compilation check:
   ```bash
   dart analyze .claude/spec-verification/
   ```

4. Report any compilation errors:
   - Syntax errors in spec examples
   - Type mismatches
   - Missing imports/dependencies
   - Invalid Dart code

**Verification Output:**
```markdown
## Compilation Verification Report

### Passed
- [List of examples that compile]

### Failed
| Source Location | Error | Line | Description |
|-----------------|-------|------|-------------|
| spec:line | Error code | N | What's wrong |

### Skipped
- [Examples not suitable for compilation testing]
```

---

### Phase 5: Integrity Verification

**Objective:** Additional verification methods for spec integrity

**Verification Methods:**

1. **Cross-Reference Consistency**
   - Entity fields referenced in repositories match entity definitions
   - Use case inputs match entity fields they populate
   - Error codes used in examples exist in error hierarchy
   - Method signatures in repositories match use case calls

2. **Completeness Checks**
   - Every entity has a repository
   - Every repository has standard CRUD methods
   - Every entity with business logic has use cases
   - Every use case has input class defined

3. **Naming Consistency**
   - Class names follow patterns
   - Method names follow patterns
   - File names match class names
   - Test names match implementation names

4. **Dependency Graph Validation**
   - No circular dependencies in specs
   - Layer violations detected (UI → Domain → Data)
   - All referenced types are defined

5. **Version/Date Tracking**
   - Spec version numbers current
   - Last update dates reasonable
   - Change log entries present

**Integrity Output:**
```markdown
## Integrity Verification Report

### Cross-Reference Issues
- [Mismatches between spec sections]

### Completeness Gaps
- [Missing specifications]

### Naming Violations
- [Inconsistent naming]

### Dependency Issues
- [Problematic dependencies]

### Metadata Issues
- [Version/date problems]
```

---

### Final Report Generation

**Objective:** Produce comprehensive audit report

**Report Structure:**
```markdown
# Spec Review Report - YYYY-MM-DD

## Executive Summary
- Total specs reviewed: N
- Compliance rate: X%
- Code examples verified: N
- Compilation success rate: X%
- Critical issues: N
- Action items: N

## Phase 1: Compliance Audit
[Aggregated agent reports]

## Phase 2: Remediation Applied
[List of fixes made]

## Phase 3: Code Examples
[Extraction summary]

## Phase 4: Compilation Results
[Verification results]

## Phase 5: Integrity Check
[Integrity findings]

## Recommendations
[Prioritized action items]

## Appendix
[Detailed findings, diffs, logs]
```

---

## Estimated Execution Time

| Phase | Duration | Parallelizable |
|-------|----------|----------------|
| Phase 1: Compliance Audit | 15-30 min | Yes (5 agents) |
| Phase 2: Remediation | 10-30 min | Partially |
| Phase 3: Extraction | 5-10 min | Yes |
| Phase 4: Compilation | 5-15 min | No |
| Phase 5: Integrity | 10-20 min | Partially |

**Total:** 45-105 minutes depending on spec size and issues found

---

## Dependencies

- 02_CODING_STANDARDS.md must exist and be comprehensive
- Spec documents must use consistent markdown formatting
- Code blocks must be properly fenced with ```dart
- Flutter/Dart SDK available for compilation checks

---

## Notes

This skill focuses on **spec integrity** - ensuring specifications are internally consistent and match coding standards. For verifying **implementations match specs**, use a separate Implementation Audit skill.
