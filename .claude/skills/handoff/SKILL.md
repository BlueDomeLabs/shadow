---
name: handoff
description: End-of-session protocol. GitHub commit, briefing update,
  Project Knowledge sync. Run this at the end of every session.
---

## Overview

This skill is the authoritative end-of-session procedure. Run it in
full at the end of every session without skipping steps. Every step
is required.

---

## Step 1 — Commit to GitHub

Stage all changed files, commit with a descriptive message, and push
to the remote:

  git add -A
  git commit -m "your descriptive message here"
  git push

Both commit and push are required. A local-only commit is not done.
If git push fails, resolve it before proceeding.

---

## Step 2 — Update docs/ARCHITECT_BRIEFING.md

Add a timestamped session log entry in reverse chronological order
(newest at top). The entry must include:
- Header line: Tests: X,XXX | Schema: vX | Analyzer: clean
- Technical Summary (for the Architect — thorough and precise)
- File Change Table (every file in the prompt, changed or not)
- Executive Summary for Reid (plain language)

See COMPLETION REPORT FORMAT in CLAUDE.md for the full format spec.

---

## Step 3 — Run flutter test

All tests must pass. Zero failures. If any tests fail, fix them before
proceeding. Do not sync or report until the test suite is clean.

---

## Step 4 — Run flutter analyze

Must be clean. Zero issues. If any issues are found, fix them before
proceeding.

---

## Step 5 — Identify files to delete from Project Knowledge

Before pushing anything, identify every file that falls into any of
these three categories and run bdl-sync delete for each:

a) PATH CHANGED — the file was moved or renamed this session.
   The old path is now stale in Project Knowledge.
   Action: bdl-sync delete <old path>

b) FILE REMOVED — the file was deleted or consolidated into another
   file this session. The old path is now stale.
   Action: bdl-sync delete <old path>

c) FILE MODIFIED — the file's content changed this session and it
   will be pushed with new content. The old version must be removed
   before the new one is pushed.
   Action: bdl-sync delete <path>, then push the new version in Step 6

Run all deletes before any pushes. Pushing without deleting first
leaves stale versions in Project Knowledge alongside new ones.

If no files fall into any of these categories, skip to Step 6.

---

## Step 6 — Push to Project Knowledge

Push the standard baseline files plus every file created or modified
this session:

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
    .claude/skills/compliance/SKILL.md \
    .claude/skills/factory-reset/SKILL.md \
    .claude/skills/handoff/SKILL.md \
    .claude/skills/implementation-review/SKILL.md \
    .claude/skills/launch-shadow/skill.md \
    .claude/skills/spec-review/SKILL.md \
    .claude/skills/startup/SKILL.md \
    [every file created or modified this session]

---

## Step 7 — Verify with bdl-sync ls

Run bdl-sync ls and confirm:
- No stale paths from this session remain
- All expected new or modified files are present

If stale files are still present, delete them and re-verify.

---

## Step 8 — Update .claude/work-status/current.json

Update the status file to reflect the completed session state:
- status: "complete"
- task: brief description of what was done
- testCount: current passing test count
- schemaVersion: current schema version

---

## Step 9 — Report back to Reid

Deliver the completion report:
- File change table (every file touched — changed, moved, or checked)
- Plain-language Executive Summary

Then stop. Do not begin any new work.

---

## Emergency Handoff (context compaction imminent)

If compaction is about to occur and there is no time for the full
procedure, execute this minimum viable handoff in order:

1. git add -A && git commit -m "wip: compaction — [brief description]" && git push
2. Update docs/ARCHITECT_BRIEFING.md with current state, even briefly
3. Run flutter test — if failing, note it explicitly in the briefing
4. Push docs/ARCHITECT_BRIEFING.md to Project Knowledge:
     bdl-sync push --files docs/ARCHITECT_BRIEFING.md

The Architect must be able to reconstruct state from the briefing.
Never leave the test count in docs/ARCHITECT_BRIEFING.md wrong.
