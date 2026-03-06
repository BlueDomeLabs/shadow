# Stateless Instance Coordination Strategy

**Version:** 1.0
**Last Updated:** February 2, 2026
**Purpose:** Explain the strategy for coordinating 1000+ stateless Claude instances

---

## 1. The Core Problem

Shadow is developed by 1000+ independent Claude instances. Each instance:

- Has **zero memory** of previous instances' work
- Has **no communication channel** to concurrent instances
- Cannot make **verbal agreements** or share opinions
- Starts fresh with **no context** of what came before

Traditional software teams rely on:
- Slack conversations
- Daily standups
- Shared memory of past discussions
- Real-time collaboration

**None of these work for stateless agents.**

---

## 2. The Solution: File-Based Communication

The **only** way instances communicate is through committed files:

```
┌─────────────────────────────────────────────────────────────────┐
│                    INTER-INSTANCE COMMUNICATION                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   Instance A                    Instance B                      │
│   ┌─────────┐                  ┌─────────┐                     │
│   │ Works   │                  │ Starts  │                     │
│   │ on task │                  │ fresh   │                     │
│   └────┬────┘                  └────┬────┘                     │
│        │                            │                          │
│        ▼                            │                          │
│   ┌─────────────────┐               │                          │
│   │ .claude/work-   │───────────────┼──────────────────────►   │
│   │ status/current  │               │     Reads status         │
│   │ .json           │               │     before ANY work      │
│   └─────────────────┘               │                          │
│        │                            │                          │
│        ▼                            ▼                          │
│   ┌─────────────────┐         ┌─────────────────┐              │
│   │ Committed Code  │─────────│ Verifies        │              │
│   │ (Repository)    │         │ Compliance      │              │
│   └─────────────────┘         └─────────────────┘              │
│        │                            │                          │
│        ▼                            ▼                          │
│   ┌─────────────────┐         ┌─────────────────┐              │
│   │ Test Results    │─────────│ Continues       │              │
│   │ (Pass/Fail)     │         │ or Fixes        │              │
│   └─────────────────┘         └─────────────────┘              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Communication Channels

| Channel | Purpose | Location |
|---------|---------|----------|
| Work Status File | Handoff state between instances | `.claude/work-status/current.json` |
| Committed Code | Actual implementation | Git repository |
| Specification Docs | All decisions and contracts | `*.md` files in project root |
| Test Results | Compliance verification | `flutter test` output |
| Ambiguity Tracker | Unresolved spec questions | `53_SPEC_CLARIFICATIONS.md` |

### What CANNOT Be Communicated

- Real-time status ("I'm working on X right now")
- Opinions or preferences ("I think approach A is better")
- Uncommitted work-in-progress
- Verbal agreements ("Let's do it this way")

---

## 3. The Four Pillars

### Pillar 1: Work Status File

Location: `.claude/work-status/current.json`

This is the "handoff note" between instances:

```json
{
  "lastInstanceId": "abc123",
  "lastAction": "implementing",
  "taskId": "SHADOW-042",
  "status": "in_progress",
  "timestamp": "2026-02-02T10:30:00Z",
  "filesModified": [
    "lib/domain/entities/fluids_entry.dart",
    "lib/domain/repositories/fluids_repository.dart"
  ],
  "testsStatus": "passing",
  "complianceStatus": "verified",
  "notes": "Entity and repository interface complete. Next: implement repository, create datasource, write tests. See 22_API_CONTRACTS.md Section 5."
}
```

#### Status Decision Tree

Every new instance reads this file **FIRST** and follows this logic:

```
IF status == "in_progress" AND testsStatus == "failing":
    → Previous instance left broken code
    → Run tests, identify failures, fix them
    → Update status to "complete" or document why blocked

IF status == "in_progress" AND testsStatus == "passing":
    → Previous instance was interrupted mid-task
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

### Pillar 2: Zero-Interpretation Specifications

Specifications are written so tight that instances have **no room for decisions**:

| Instead of... | We write... |
|---------------|-------------|
| "Add timestamp field" | `timestamp: int` (epoch milliseconds, never DateTime) |
| "Return errors appropriately" | `Future<Result<Supplement, AppError>>` (exact type signature) |
| "Include required fields" | `id`, `clientId`, `profileId`, `syncMetadata` (enumerated list) |
| "Use proper validation" | `0 ≤ waterIntakeMl ≤ 10000` (exact numeric range) |
| "Handle errors" | `AppError.database(code: 'DB_NOT_FOUND')` (exact error code) |

#### The Zero-Interpretation Principle

> **An ambiguity in the spec is a bug in the spec, not permission to interpret.**

If something is unclear, the instance must:
1. Stop work immediately
2. Document in `53_SPEC_CLARIFICATIONS.md`
3. Set status to "blocked"
4. Wait for spec clarification

### Pillar 3: Compliance Verification Loop

#### On Startup (Before ANY Work)

```bash
# Step 1: Verify previous instance's work
flutter test              # All tests must pass
flutter analyze           # No lint issues

# Step 2: If failures exist, FIX THEM before proceeding
# This catches any mistakes previous instances made
```

#### Before Completion (Pre-Completion Checklist)

```
□ 1. flutter test                    → All tests passing
□ 2. flutter analyze                 → No issues
□ 3. Entity fields match 22_API_CONTRACTS.md EXACTLY
□ 4. Repository methods match contracts EXACTLY
□ 5. All timestamps are int (not DateTime)
□ 6. All error codes are from approved list
□ 7. Tests cover success AND failure paths
□ 8. .claude/work-status/current.json updated
```

#### Automated Compliance Script

Run `dart run scripts/verify_spec_compliance.dart` which checks:
- All entities have required fields (id, clientId, profileId, syncMetadata)
- All repositories return `Result<T, AppError>`
- All timestamps are `int` (not DateTime)
- All enums have integer values for database storage
- No exceptions thrown from domain layer
- All error codes are from approved list

### Pillar 4: Ambiguity Tracking

Location: `53_SPEC_CLARIFICATIONS.md`

When an instance finds something unclear:

```markdown
## AMBIGUITY-2026-02-02-001: Water intake validation range

**Found in:** 22_API_CONTRACTS.md Section 5
**Found by:** Instance during task SHADOW-042
**Issue:** waterIntakeMl validation range not specified
**Possible interpretations:**
1. 0-10000 mL (reasonable daily maximum)
2. 0-5000 mL (conservative estimate)
3. No upper limit (user discretion)

**Blocking:** SHADOW-042
**Status:** AWAITING_CLARIFICATION
**Resolution:** [To be filled when resolved]
**Resolution Date:** [To be filled]
**Spec Updated:** [Yes/No - which document]
```

The instance:
1. Sets `status: "blocked"` in work status file
2. Does NOT proceed with implementation
3. Waits for user to clarify and update spec

---

## 4. The Instance Lifecycle

```
┌───────────────────────────────────────────────────────────┐
│ INSTANCE LIFECYCLE                                         │
├───────────────────────────────────────────────────────────┤
│                                                           │
│  1. START ──► Read CLAUDE.md                              │
│              │                                            │
│  2. CHECK ──► Run flutter test & flutter analyze          │
│              │ (verify previous instance's work)          │
│              │                                            │
│  3. STATUS ─► Read .claude/work-status/current.json       │
│              │ (understand what to do next)               │
│              │                                            │
│  4. CLAIM ──► Update status file with new task            │
│              │ (prevent other instances taking same task) │
│              │                                            │
│  5. WORK ───► Follow specs EXACTLY                        │
│              │ (zero interpretation allowed)              │
│              │                                            │
│  6. VERIFY ─► Run tests, compliance check                 │
│              │ (before claiming done)                     │
│              │                                            │
│  7. COMPLETE► Update status file                          │
│              │ status: "complete"                         │
│              │ testsStatus: "passing"                     │
│              │                                            │
│  8. HANDOFF─► Clear notes for next instance               │
│              "Next: implement X. See spec Y §Z."          │
│                                                           │
└───────────────────────────────────────────────────────────┘
```

---

## 5. The Seven Golden Rules

| # | Rule | Why It Matters |
|---|------|----------------|
| 1 | **NEVER make decisions** | Specs contain all decisions. If unclear, ask. One instance's guess creates chaos for all others. |
| 2 | **ALWAYS verify compliance** | Trust nothing. Test everything. Previous instances may have made mistakes. |
| 3 | **ALWAYS update status file** | Your only voice to future instances. Without it, they have no context. |
| 4 | **NEVER leave uncommitted work** | Uncommitted code is invisible. Invisible = lost = wasted effort. |
| 5 | **ALWAYS run tests** | Tests are the truth. Code must pass. Tests catch spec violations. |
| 6 | **STOP if ambiguous** | A guess by one instance creates divergent implementations across the team. |
| 7 | **Document everything** | Next instance has zero memory of you. Write as if explaining to a stranger. |

---

## 6. What Makes This Work

### 1. Specifications Are Law

Every decision is made in the specification documents, not by individual instances. The specs define:
- Exact field names and types
- Exact method signatures
- Exact validation rules
- Exact error codes
- Exact UI field specifications

### 2. Tests Enforce Specifications

Automated verification catches deviations:
- Unit tests verify behavior
- Compliance scripts verify structure
- CI/CD blocks non-compliant code

### 3. Status File Is the Handoff

Clear state transfer between instances:
- What was done
- What needs doing
- What's blocked
- Where to find more info

### 4. Ambiguity Halts Work

Prevents divergent interpretations:
- One instance guessing creates 1000 different implementations
- Blocking and asking creates one correct implementation

### 5. Git Is the Communication Channel

Only committed files are real:
- Uncommitted work doesn't exist
- Conversations don't persist
- Only the repository matters

---

## 7. Comparison: Human Team vs. Stateless Instances

| Aspect | Human Team | Stateless Instances |
|--------|------------|---------------------|
| Communication | Slack, meetings, verbal | Files only |
| Memory | Remembers past discussions | Zero memory |
| Decision making | Discuss and decide | Follow spec exactly |
| Ambiguity handling | Ask colleague, make call | Stop, document, wait |
| Handoff | Walk to desk, explain | Status file + notes |
| Coordination | Daily standup | Work status file |
| Standards enforcement | Code review | Automated tests |
| Onboarding | 4-week program | Read CLAUDE.md |

---

## 8. Key Files Summary

| File | Purpose | Read When |
|------|---------|-----------|
| `CLAUDE.md` | Entry point, startup protocol | First thing, every instance |
| `52_INSTANCE_COORDINATION_PROTOCOL.md` | Full coordination rules | After CLAUDE.md |
| `.claude/work-status/current.json` | Inter-instance state | Before any work |
| `53_SPEC_CLARIFICATIONS.md` | Ambiguity tracking | When spec is unclear |
| `22_API_CONTRACTS.md` | Canonical contracts | When implementing |
| `02_CODING_STANDARDS.md` | Code patterns | When writing code |
| `34_PROJECT_TRACKER.md` | Task assignments | When picking tasks |

---

## 9. Success Criteria

The coordination strategy succeeds when:

1. **Any instance can pick up any task** - Clear status and specs mean no tribal knowledge required
2. **No two instances implement differently** - Zero-interpretation specs ensure consistency
3. **Broken code gets fixed immediately** - Startup verification catches problems
4. **Ambiguities don't cause divergence** - Blocking prevents guessing
5. **Work is never lost** - Commit-before-handoff rule preserves all progress
6. **Tests always pass** - Compliance verification maintains quality

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-02-02 | Initial release - strategy explanation |
