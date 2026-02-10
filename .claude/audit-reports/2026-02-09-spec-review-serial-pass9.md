# Spec Review Report - 2026-02-09 (Serial Pass 9)

## Executive Summary
- **Method:** Serial review by single instance (per user request — no parallel agents)
- **Document:** 22_API_CONTRACTS.md (14,000+ lines)
- **Control Document:** 02_CODING_STANDARDS.md
- **Baseline:** All CRITICAL and HIGH issues from passes 1-8 have been resolved
- **New issues found this pass:** 12
- **Verdict: READY TO PROCEED** — no remaining CRITICAL issues, only MEDIUM/LOW items

---

## Severity Breakdown

| Severity | Count | Blocking? |
|----------|-------|-----------|
| CRITICAL | 0 | N/A |
| HIGH | 2 | No — missing use case definitions that can be added during implementation |
| MEDIUM | 4 | No — style/pattern issues |
| LOW | 6 | No — cosmetic/numbering issues |

---

## Findings

### HIGH — Missing Use Case Definitions (2)

| ID | Line | Issue | Impact |
|----|------|-------|--------|
| P9-1 | 8810 | `getNotificationSchedulesUseCaseProvider` references `GetNotificationSchedulesUseCase` — class never defined | Provider cannot compile without use case definition |
| P9-2 | 8230, 8262, 8268, 8302, 8754, 8965 | 6 profile/auth use case providers reference undefined use cases: `GetCurrentUserUseCase`, `GetAccessibleProfilesUseCase`, `SetCurrentProfileUseCase`, `CreateProfileUseCase`, `DeleteProfileUseCase`, `UpdateProfileUseCase` | Profile management providers cannot compile |

**Note on P9-2:** These 6 use cases are tightly coupled to the auth/profile subsystem and have not yet been implementation-specced. They can be defined during the profile management implementation phase without blocking other work.

---

### MEDIUM — Enum Int Values Missing (1)

| ID | Lines | Issue | Fix |
|----|-------|-------|-----|
| P9-3 | 4759, 4784, 7168 | 3 enums missing `final int value;` per Rule 9.1.1: `TrendGranularity`, `TrendDirection`, `ConflictResolution` | Add `(0)`, `(1)`, `(2)` values + `final int value;` + constructor + `fromValue()` |

---

### MEDIUM — DateTime.now() Style (1)

| ID | Lines | Issue | Fix |
|----|-------|-------|-----|
| P9-4 | 4381, 4468, 4643, 5038, 5073 | 5 use cases use `final now = DateTime.now();` then access `.millisecondsSinceEpoch` later. Should be `final now = DateTime.now().millisecondsSinceEpoch;` per Rule 5.2.1 | Change to pre-computed epoch int |

**Note:** These are functionally correct — the DateTime is always converted to epoch ms at point of use. This is a style consistency issue only.

**Acceptable uses of `DateTime.now()` (NOT violations):**
- Computed getters that need calendar math: `ageYears` (11496), `isActiveToday` (10773), `isStale` (12268), `isExpired` (12541)
- Provider date boundary calculations: lines 8663, 8916 (need year/month/day decomposition)
- Data source date boundary: line 3802 (same reason)
- Validation helpers: lines 7766, 7776 (date comparison logic)

---

### MEDIUM — Duplicate Section Numbers (1)

| ID | Lines | Issue |
|----|-------|-------|
| P9-5 | Various | Two sections numbered "## 4." (lines 1688 and 2048), two sections numbered "## 7.5" (lines 9462 and 9791) |

---

### MEDIUM — Generic Template Providers (1)

| ID | Lines | Issue |
|----|-------|-------|
| P9-6 | 8051, 8082, 8109, 8143, 8177 | Generic CRUD template (EntityList) references `getEntitiesUseCaseProvider`, `createEntityUseCaseProvider`, etc. — these are placeholder names in the generic template, not concrete providers. This is acceptable as a pattern document, but implementers need to know to substitute concrete provider names. |

---

### LOW — Cosmetic/Informational (6)

| ID | Lines | Issue |
|----|-------|-------|
| P9-7 | 2058, 2077 | Two use case interfaces: `UseCase<Input, Output>` and `UseCaseWithInput<Output, Input>` with swapped type parameter order — documented as intentional (line 2072-2076) |
| P9-8 | 7971, 8338, 14168 | `SupplementList` class defined 3 times — in generic template (7971), concrete impl (8338), and documentation example (14168). All in different code blocks/file paths. Not a collision. |
| P9-9 | 5402, 10139 | `DetectPatternsUseCase` defined twice — implementation (5402) and definition stub (10139). Different sections, same interface. |
| P9-10 | 6000, 10833 | `ScheduleNotificationUseCase` defined twice — same pattern as P9-9 |
| P9-11 | 8926-8927 | `pendingNotifications` provider throws on error (`throw result.errorOrNull!`). This is correct Riverpod pattern — async providers surface errors via `AsyncError` state. Not a bug. |
| P9-12 | Line 4 | Document "Last Updated" date says "January 30, 2026" but significant changes were made Feb 8-9, 2026. |

---

## Verification Summary (6 Core Areas)

| Area | Status | Details |
|------|--------|---------|
| 1. Entity Compliance | PASS | No `DateTime` in entity fields. All persisted entities have `const Entity._()`. FhirExport/MLModel correctly use `createdAt`/`updatedAt` per coding standards exemption. |
| 2. Repository Compliance | PASS | All methods return `Result<T, AppError>`. No `StateError` remaining. Only `throw UnimplementedError()` in Model stubs (acceptable). |
| 3. Enum Compliance | FAIL (MEDIUM) | 3 of 48 enums missing `final int value;` — see P9-3. All other 45 enums compliant. |
| 4. Cross-Reference Integrity | FAIL (HIGH) | 7 use case classes missing for profile/auth/notification providers — see P9-1, P9-2. All other provider→useCase references verified. |
| 5. DateTime Patterns | FAIL (MEDIUM) | 5 use cases use `DateTime.now()` instead of `DateTime.now().millisecondsSinceEpoch` — see P9-4. Functionally correct. |
| 6. Section 13 DB Alignment | PASS | 42 entity-to-table mappings verified. Spot-checked FlareUp and MLModel — both perfectly aligned with entity definitions. |

---

## Comparison to Previous Passes

| Pass | Issues Found | CRITICAL | Status |
|------|-------------|----------|--------|
| Passes 1-6 | 78 | Many | All fixed |
| Pass 7 (6-agent team) | ~85 | ~28 | All CRITICAL/HIGH fixed |
| Pass 8 (completeness) | 11 | 4 | All fixed |
| **Pass 9 (this review)** | **12** | **0** | **2 HIGH, 4 MEDIUM, 6 LOW** |

**Convergence achieved.** Each successive pass finds fewer and less severe issues. Pass 9 found zero CRITICAL issues — the spec is stable.

---

## Recommendation

**The spec is ready to proceed to implementation.** The remaining issues are:

1. **P9-1 and P9-2 (HIGH):** The 7 missing profile/auth/notification use cases can be defined as part of the profile management implementation phase. These providers are only used by their respective screens/flows, so other entity implementations (supplements, conditions, fluids, etc.) can proceed now.

2. **P9-3, P9-4, P9-5 (MEDIUM):** These can be fixed now in a quick pass (3 enum fixes + 5 DateTime style fixes + section renumbering) OR deferred to a pre-implementation cleanup.

3. **P9-7 through P9-12 (LOW):** Informational only. No action needed.

### Suggested Next Steps
1. Fix P9-3 (3 enums) and P9-4 (5 DateTime patterns) — quick ~10 minute fix
2. Optionally fix P9-1/P9-2 (7 missing use cases) — ~20 minute fix
3. Proceed to implementation starting with entity implementations
