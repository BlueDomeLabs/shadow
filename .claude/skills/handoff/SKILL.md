---
name: handoff
description: End-of-session protocol. Run this at the end of every
  session. This skill is the single source of truth for the complete
  procedure — do not look elsewhere for sync instructions.
---

## Overview

Run every step in order. Do not skip any step. This is required at
the end of every session without exception.

---

## Step 0 — Pre-Flight Verification

Run these checks before committing anything. All must pass.
If any fail, fix them first — do not proceed to Step 1.

  [ ] flutter test                                    → all passing
  [ ] flutter analyze                                 → no issues
  [ ] dart format --set-exit-if-changed lib/ test/   → exit 0
  [ ] Entity fields match docs/specs/03_API_CONTRACTS.md exactly
  [ ] Repository methods match contracts exactly
  [ ] All timestamps are int — never DateTime
  [ ] All error codes from approved AppError hierarchy
  [ ] Tests cover success AND failure paths
  [ ] Authorization checked first in every use case
  [ ] docs/ARCHITECT_BRIEFING.md updated with session log entry

If all checks pass, proceed to Step 1.

---

## Step 1 — Commit to GitHub

  git add -A
  git commit -m "your descriptive message here"
  git push

Both commit and push are required. A local-only commit is not done.
Resolve any push failures before proceeding.

---

## Step 2 — Update docs/ARCHITECT_BRIEFING.md

Add a timestamped session log entry (newest at top). Include:
- Header: Tests: X,XXX | Schema: vX | Analyzer: clean
- Technical Summary (for the Architect — thorough and precise)
- File Change Table (every file in the prompt, changed or not)
- Executive Summary for Reid (plain language)

See COMPLETION REPORT FORMAT in CLAUDE.md for the full format spec.

---

## Step 3 — Run flutter test

All tests must pass. Zero failures. Fix before proceeding.

---

## Step 4 — Run flutter analyze

Must be clean. Zero issues. Fix before proceeding.

---

## Step 5 — Delete stale files from Project Knowledge

Before pushing anything, run bdl-sync delete for every file that
falls into any of these three categories:

a) PATH CHANGED — file was moved or renamed this session.
   Delete the old path.

b) FILE REMOVED — file was deleted or consolidated this session.
   Delete the old path.

c) FILE MODIFIED — file content changed and will be pushed with
   new content. Delete the old version before pushing the new one.

Run all deletes before any pushes. Pushing without deleting first
leaves stale versions alongside new ones in Project Knowledge.

---

## Step 6 — Push to Project Knowledge

  bdl-sync push --files \
    CLAUDE.md \
    docs/ARCHITECT_BRIEFING.md \
    docs/AUDIT_FINDINGS.md \
    docs/DECISIONS.md \
    docs/VISION.md \
    docs/ROADMAP.md \
    docs/standards/01_CODING_STANDARDS.md \
    docs/specs/02_DATABASE_SCHEMA.md \
    docs/specs/03_API_CONTRACTS.md \
    docs/ARCHITECT_BRIEFING_ARCHIVE.md \
    .claude/settings.json \
    .claude/settings.local.json \
    .claude/work-status/current.json \
    .claude/skills/context-lost.md \
    .claude/skills/coding/SKILL.md \
    .claude/skills/factory-reset/SKILL.md \
    .claude/skills/handoff/SKILL.md \
    .claude/skills/implementation-review/SKILL.md \
    .claude/skills/launch-shadow/skill.md \
    .claude/skills/spec-review/SKILL.md \
    .claude/skills/startup/SKILL.md \
    [every file created or modified this session]

---

## Step 7 — Verify with bdl-sync ls

Run bdl-sync ls. Confirm no stale paths remain and all expected
files are present. If stale files remain, delete and re-verify.

---

## Step 8 — Update .claude/work-status/current.json

  {
    "status": "complete",
    "task": "brief description",
    "testCount": current passing count,
    "schemaVersion": current schema version
  }

---

## Step 9 — Report back to Reid

Deliver the completion report (file change table + Executive
Summary). Then stop — do not begin any new work.

---

## Emergency Handoff (compaction imminent)

1. git add -A && git commit -m "wip: [brief description]" && git push
2. Update docs/ARCHITECT_BRIEFING.md with current state
3. flutter test — note result in briefing even if failing
4. bdl-sync push --files docs/ARCHITECT_BRIEFING.md

Never leave the test count in docs/ARCHITECT_BRIEFING.md wrong.
