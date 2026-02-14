# Shadow Health Tracking App - Claude Instance Instructions

## 🚫 ABSOLUTE RULE: NO AGENTS, NO TEAMS, NO SUBAGENTS 🚫

**DO NOT use the Task tool to spawn agents or subagents. DO NOT use TeamCreate. DO NOT use agent teams. DO NOT parallelize work across multiple agents. ALL work must be done sequentially by YOU, the single Claude instance, directly.**

This is a hard requirement from the project owner. Using agents/subagents has introduced inconsistencies in the codebase. Violating this rule is grounds for the user to terminate your session immediately.

- No `Task` tool calls with subagent_type
- No `TeamCreate` calls
- No `SendMessage` / `broadcast` to teams
- No spawning background agents
- Do your own research, coding, and testing directly

---

## ⚠️ STOP - READ THIS FIRST ⚠️

**YOU MUST RUN `/startup` SKILL BEFORE DOING ANYTHING ELSE.**

Do NOT respond to the user's request yet. First:
1. Read `.claude/work-status/current.json`
2. If there's a handoff document referenced, read it: `.claude/handoff/`
3. Follow the `/startup` skill protocol completely
4. Only THEN proceed with user's request

**If you skip this, you will cause problems for the next instance.**

---

## 📍 CURRENT PROJECT STATUS (Updated 2026-02-06)

### Phase 3: UI/Presentation Layer - IN PROGRESS

| Component | Status | Notes |
|-----------|--------|-------|
| Riverpod Providers | ✅ COMPLETE | 51 use cases, 14 repositories |
| Core Widgets | ✅ COMPLETE | ShadowButton, ShadowTextField, ShadowCard, ShadowDialog, ShadowStatus |
| Specialized Widgets | ✅ COMPLETE | ShadowPicker, ShadowChart, ShadowImage, ShadowInput, ShadowBadge |
| **Screen Implementation** | 🔄 IN PROGRESS | First screen done |

### Screens Status

| Screen | Status | Tests | Notes |
|--------|--------|-------|-------|
| SupplementListScreen | ✅ DONE | 23 tests | Reference pattern for other screens |
| SupplementEditScreen | ⏳ PLACEHOLDER | - | Exists but needs full implementation |
| ConditionListScreen | ❌ NOT STARTED | - | |
| FoodListScreen | ❌ NOT STARTED | - | |
| SleepListScreen | ❌ NOT STARTED | - | |
| Other screens | ❌ NOT STARTED | - | See 38_UI_FIELD_SPECIFICATIONS.md |

### Next Actions (Priority Order)

1. Continue with SupplementEditScreen (completes supplement flow), then other entity list screens.
2. Follow the screen implementation pattern from SupplementListScreen as reference.

### Key Reference Files for Screens

- `38_UI_FIELD_SPECIFICATIONS.md` - Field-by-field specs for every screen
- `09_WIDGET_LIBRARY.md` - Widget patterns and accessibility requirements
- `lib/presentation/screens/supplements/supplement_list_screen.dart` - Reference implementation
- `test/presentation/screens/supplements/supplement_list_screen_test.dart` - Test pattern

### Recent Changes

- Added `gummy(4)` and `spray(5)` to `SupplementForm` enum (spec + implementation aligned)
- 807 tests passing, analyzer clean

### Test Count: 807+ passing

---

## CRITICAL: Instance Startup Protocol

**YOU ARE A STATELESS AGENT.** Execute this protocol BEFORE any work.

### Step 1: Verify Previous Instance Compliance

```bash
# Check work status from previous instance
cat .claude/work-status/current.json

# Run compliance verification
flutter test
flutter analyze
```

If tests fail or analyzer has errors: **FIX FIRST before proceeding.**

### Step 2: Understand Your Context

Read `.claude/work-status/current.json`:
- If `status == "in_progress"`: Continue that task
- If `status == "complete"`: Pick next task from `34_PROJECT_TRACKER.md`
- If `status == "blocked"`: Review notes, resolve if possible, else pick alternate task

### Step 3: Update Status Before Working

Before making ANY changes:
```json
// Update .claude/work-status/current.json
{
  "lastInstanceId": "<generate-uuid>",
  "status": "in_progress",
  "taskId": "SHADOW-XXX",
  "notes": "Starting [description of work]"
}
```

---

## Project Overview

Shadow is a Flutter multi-platform health tracking application developed by **1000+ independent Claude instances**, each working on small pieces without memory of other instances' decisions.

**FULL PROTOCOL:** Read `52_INSTANCE_COORDINATION_PROTOCOL.md` for complete coordination rules.

---

## Required Reading (In Order)

| Priority | Document | When to Read |
|----------|----------|--------------|
| **0** | `52_INSTANCE_COORDINATION_PROTOCOL.md` | **FIRST - Before anything** |
| **1** | `.claude/skills/coding.md` | Before writing ANY code |
| **2** | `22_API_CONTRACTS.md` | For exact interface definitions |
| **3** | `02_CODING_STANDARDS.md` | For mandatory patterns |
| **4** | Task-specific specs | As needed for your task |

---

## Non-Negotiable Rules

### Code Rules
1. **Every entity MUST have:** `id`, `clientId`, `profileId`, `syncMetadata`
2. **Every repository method MUST return:** `Result<T, AppError>`
3. **Every timestamp MUST be:** `int` (epoch milliseconds), never `DateTime`
4. **Every enum MUST have:** explicit integer values for database storage
5. **Every use case MUST:** validate profile access first
6. **Every change MUST have:** tests proving spec compliance

### Instance Rules
1. **NEVER make decisions** - Follow specs exactly
2. **ALWAYS verify compliance** - Before completing any task
3. **ALWAYS update status file** - For next instance to understand
4. **NEVER leave uncommitted work** - At end of conversation
5. **STOP if ambiguous** - Document in `53_SPEC_CLARIFICATIONS.md`, ask user

---

## Pre-Completion Checklist

**BEFORE telling user work is complete, verify ALL:**

```
[ ] 1. flutter test                    → All tests passing
[ ] 2. flutter analyze                 → No issues
[ ] 3. Entity fields match 22_API_CONTRACTS.md EXACTLY
[ ] 4. Repository methods match contracts EXACTLY
[ ] 5. All timestamps are int (not DateTime)
[ ] 6. All error codes are from approved list
[ ] 7. Tests cover success AND failure paths
[ ] 8. .claude/work-status/current.json updated with status="complete"
```

---

## If Specification is Ambiguous

**STOP. DO NOT GUESS.**

1. Document in `53_SPEC_CLARIFICATIONS.md` using the template
2. Update `.claude/work-status/current.json` with `status: "blocked"`
3. Ask user for clarification
4. Wait for spec update before proceeding

**An ambiguity is a BUG IN THE SPEC, not permission to interpret.**

---

## Handoff Protocol (End of Conversation)

When your conversation is ending or being compacted:

1. **Commit all work** to repository
2. **Run all tests** and fix any failures
3. **Update status file** with clear notes for next instance
4. **Document any decisions** in ADR if architectural
5. **Do NOT leave work-in-progress** uncommitted

---

## Quick Commands

```bash
# Run tests
flutter test

# Run analyzer
flutter analyze

# Format code
dart format lib/

# Generate freezed/riverpod code
dart run build_runner build --delete-conflicting-outputs

# Check work status
cat .claude/work-status/current.json
```

---

## Skills

### 6 Core Skills (MANDATORY Every Session)

| Skill | When to Use | Purpose |
|-------|-------------|---------|
| `/startup` | **FIRST** - Every session | Verify previous work, determine next action |
| `/coding` | When writing ANY code | Follow specs EXACTLY, zero interpretation |
| `/manager` | **MID-SESSION** - At least once | Self-review, verify following protocols |
| `/compliance` | **BEFORE** claiming work done | Tests pass, analyzer clean, verify against spec |
| `/team` | Always (mindset) | Understand stateless coordination, files are only communication |
| `/handoff` | When session ending | Commit work, update status file, prepare baton |

### 3 Audit Skills (Quality Assurance)

| Skill | When to Use | Purpose |
|-------|-------------|---------|
| `/major-audit` | Monthly | Review Coding Standards against Apple/Google best practices |
| `/spec-review` | After standards change, before major implementation | Verify specs comply with Coding Standards |
| `/implementation-review` | After implementation, when deviation found | Verify code EXACTLY matches specs |

### Session Flow

```
/startup ──► /coding ──► /manager ──► /compliance ──► /handoff
                ↑            │
                └────────────┘ (iterate as needed)
```

### Audit Flow (When Triggered)

```
/major-audit ──► /spec-review ──► /implementation-review
     │                │                    │
     ▼                ▼                    ▼
  Standards        Specs              Code matches
  current?         compliant?         specs EXACTLY?
```

---

## Document Inventory (56 Documents)

Core specifications are in the project root. Key documents:
- `01-22`: Product, architecture, standards, contracts
- `23-34`: Governance, tracking, assignments
- `35-43`: Feature-specific specs
- `44-51`: Audit fixes and trackers
- `52-55`: Instance coordination
  - `52`: Full coordination protocol
  - `53`: Spec clarifications tracker
  - `54`: Comprehensive audit results
  - `55`: Strategy explanation (why the system works)
