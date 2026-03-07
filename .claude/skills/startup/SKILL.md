---
name: startup
description: Cold-start procedure for every new session — both Shadow
  and the Architect. Read orientation documents in order, then run
  role-specific verification. Run this before any work begins.
---

## Overview

This skill is for both Shadow (Claude Code) and the Architect
(Claude.ai). Run every step in order. Do not begin any work until
all steps are complete.

---

## Orientation — Read These Documents In Order

Every team member reads these before doing anything else. The order
matters — each document builds on the last.

### 1. Read docs/VISION.md
Understand what Blue Dome Labs is building and why. This is the
foundation everything else rests on.

### 2. Read docs/ROADMAP.md
Understand the full build history — where the project started,
what has been built, and where it is going. Orient yourself in
the timeline before reading current state.

### 3. Read CLAUDE.md
These are the Architect's standing instructions to Shadow. Both
roles read this — Shadow to know its operating rules, the
Architect to know what instructions it has given Shadow.

If you are the Architect: flag any inconsistencies between
CLAUDE.md and your Project Instructions to Reid before proceeding.
CLAUDE.md is your document — you own it.

### 4. Read docs/ARCHITECT_BRIEFING.md
This is the current claimed state of the project. Note the handoff
header: Status, Last Commit, Next Action, Tests, Schema, Analyzer.
This is a claim — not a fact. Verify it in the steps below before
trusting it.

### 5. Read docs/TEAM_PROTOCOL.md
How the team operates — roles, responsibilities, communication
standards, the review gate, what done means. Read this last so
it is fresh before you begin work. It is the most actionable
document in the project.

### 6. Invoke /coding

Read the control documents listed in the /coding skill. These define
the standards every instance must know before working. Both Shadow
and the Architect read them — Shadow to know what to build, the
Architect to know what to enforce.

---

## Verification — Shadow (Claude Code)

Run these steps after completing the orientation reading above.

### Step 1 — Run flutter test
All tests must pass before new work begins. If any tests fail,
investigate and fix before proceeding. Do not begin a new phase
on top of a broken test suite.

### Step 2 — Run flutter analyze
Must be clean. Zero issues. Fix before proceeding.

### Step 3 — Check git status
If there are uncommitted changes from a previous session, assess
them:
- If complete and correct, commit them now
- If incomplete or incorrect, investigate before proceeding
- Never begin new work on top of uncommitted changes without
  understanding what they are

### Step 4 — Confirm state matches briefing
The test count, schema version, and analyzer status you just
observed must match what ARCHITECT_BRIEFING.md claims. If they
do not match, note the discrepancy and do not proceed until it
is resolved.

---

## Verification — The Architect (Claude.ai)

Run these steps after completing the orientation reading above.

### Step 1 — Confirm Project Knowledge baseline is visible
Verify you can see these files in Project Knowledge:

  CLAUDE.md
  docs/VISION.md
  docs/ROADMAP.md
  docs/TEAM_PROTOCOL.md
  docs/ARCHITECT_BRIEFING.md
  docs/AUDIT_FINDINGS.md
  docs/DECISIONS.md
  docs/standards/01_CODING_STANDARDS.md
  docs/specs/02_DATABASE_SCHEMA.md
  docs/specs/03_API_CONTRACTS.md
  .claude/settings.json
  .claude/skills/handoff/SKILL.md
  .claude/skills/startup/SKILL.md

If any baseline files are missing, tell Reid before proceeding.
Do not attempt to work from an incomplete knowledge base.

### Step 2 — Flag any CLAUDE.md inconsistencies
You own CLAUDE.md. If anything in it conflicts with your Project
Instructions, raise it with Reid before proceeding. Do not assume
either document is correct — surface the conflict.

### Step 3 — Verify ARCHITECT_BRIEFING.md against actual files
The briefing tells you what Shadow claims the current state is.
Read the actual files in Project Knowledge to verify. If the
briefing and the files disagree, that is a finding — report it
to Reid and issue a correction prompt to Shadow before any new
work proceeds.

---

## You Are Now Ready

Shadow: Read the phase prompt Reid has given you. Follow it
exactly. If anything is ambiguous, stop and ask — do not
interpret.

Architect: You are ready to review Shadow's last session or
write the next prompt. Never write a prompt without first
completing the verification steps above.
