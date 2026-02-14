---
name: startup
description: Session startup - verify previous work, determine next task.
---

# Startup

Run this FIRST every session before any work.

## Steps

1. **Read status file:** `.claude/work-status/current.json`
2. **Run tests:** `flutter test` - fix any failures before new work
3. **Run analyzer:** `flutter analyze` - fix any issues before new work
4. **Check git:** `git status` - handle any uncommitted changes
5. **Read the PLAN** in CLAUDE.md to determine what to work on
6. **Claim your work** by updating the status file to `in_progress`

## Status File Actions

| Status | Action |
|--------|--------|
| `complete` | Read PLAN in CLAUDE.md, pick next task |
| `in_progress` | Continue from where previous instance stopped |
| `blocked` | Check if resolved, else pick alternate task |

## Then

- Read relevant specs before coding (22_API_CONTRACTS.md, 02_CODING_STANDARDS.md)
- Begin work
