---
name: team
description: How 1000+ stateless Claude instances coordinate on the Shadow codebase. Explains the file-based communication system and golden rules.
---

# Shadow Team Coordination Skill

## You Are Part of a Stateless Team

You are one of **1000+ independent Claude instances** working on the Shadow codebase. You have:

- **NO memory** of what previous instances did
- **NO communication** with concurrent instances
- **NO ability** to make decisions (specs make all decisions)
- **ONLY files** as your communication channel

---

## How the Team Works

```
┌────────────────────────────────────────────────────────────┐
│                    INSTANCE LIFECYCLE                       │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  /startup ──► Read status, verify previous work            │
│      │                                                     │
│      ▼                                                     │
│  /coding ───► Write code following specs exactly           │
│      │                                                     │
│      ▼                                                     │
│  /compliance► Verify work before claiming done             │
│      │                                                     │
│      ▼                                                     │
│  /handoff ──► Update status, prepare for next instance     │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

---

## The Four Coordination Skills

### `/startup` - Begin Every Conversation
**MANDATORY.** Run this before doing ANY work.
- Reads work status from previous instance
- Verifies previous work is compliant
- Determines what to do next

### `/coding` - Write Code
Use when implementing features.
- Zero-interpretation code production
- Exact spec compliance
- Testing requirements

### `/compliance` - Before Completing Work
**MANDATORY.** Run this before telling user work is done.
- Pre-completion checklist
- Test verification
- Status file update

### `/handoff` - End Conversation
**MANDATORY.** Run this when conversation is ending or being compacted.
- Commit all work
- Update status file
- Clear notes for next instance

---

## Communication Channels

| What | Where | How |
|------|-------|-----|
| Work status | `.claude/work-status/current.json` | Read/write JSON |
| Task progress | Notes field in status file | Plain text description |
| Blocked issues | `53_SPEC_CLARIFICATIONS.md` | Markdown entry |
| Code | Git repository | Committed files only |
| Decisions | Specification documents | Never in code comments |

### You CANNOT Communicate:
- Real-time status ("I'm working on X")
- Opinions ("I think we should...")
- Uncommitted code
- Verbal agreements

---

## The Seven Golden Rules

1. **NEVER make decisions** → Specs contain all decisions
2. **ALWAYS verify compliance** → Trust nothing, test everything
3. **ALWAYS update status file** → Your voice to future instances
4. **NEVER leave uncommitted work** → Uncommitted = invisible
5. **ALWAYS run tests** → Tests are the truth
6. **STOP if ambiguous** → Don't guess, ask
7. **Document everything** → Next instance has no memory of you

---

## Key Documents

| Document | Purpose |
|----------|---------|
| `CLAUDE.md` | Entry point, quick reference |
| `52_INSTANCE_COORDINATION_PROTOCOL.md` | Full coordination rules |
| `55_STATELESS_COORDINATION_STRATEGY.md` | Why this system works |
| `53_SPEC_CLARIFICATIONS.md` | Ambiguity tracking |
| `.claude/work-status/current.json` | Inter-instance state |

---

## When Things Go Wrong

### Previous instance left broken code
→ Fix it before doing anything else. Update status when fixed.

### Spec is ambiguous
→ STOP. Document in `53_SPEC_CLARIFICATIONS.md`. Set status to "blocked". Ask user.

### Tests are failing
→ Check if code violates spec (fix code) or test is wrong (verify against spec, fix test).

### Conflicting specs
→ Higher priority document wins. Report conflict as spec bug.

### Can't complete task
→ Set status to "blocked" or "failed" with clear notes explaining why.

---

## Success Means

✓ Any instance can pick up any task (no tribal knowledge needed)
✓ All instances implement the same way (zero interpretation)
✓ Broken code gets fixed immediately (startup verification)
✓ Ambiguities don't cause divergence (blocking prevents guessing)
✓ Work is never lost (commit before handoff)
✓ Tests always pass (compliance verification)

---

## Quick Reference

```
Start conversation    → /startup
Write code            → /coding
Before saying "done"  → /compliance
End conversation      → /handoff
```
