# Manager Skill

## Purpose

Monitor Claude instance behavior and context usage. Ensure instances follow core skills protocol. Trigger self-review before context compression.

## Invocation

- Command: `/manager`
- **MANDATORY:** Run at least once per session (mid-session checkpoint)
- **MANDATORY:** Run before context compression
- **MANDATORY:** Run when deviation from protocols is discovered

**This is a CORE SKILL - required every session.**

---

## THE 6 CORE SKILLS

Every Shadow Claude instance MUST use these skills:

```
┌─────────────────────────────────────────────────────────────────┐
│                     6 CORE SKILLS                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  /startup     → Run FIRST, every session                        │
│               → Read work status, verify previous work          │
│               → Determine what to do next                       │
│                                                                 │
│  /coding      → Run when writing ANY code                       │
│               → Follow specs EXACTLY                            │
│               → Zero interpretation                             │
│                                                                 │
│  /compliance  → Run BEFORE claiming work complete               │
│               → Tests pass, analyzer clean                      │
│               → Verify against spec                             │
│                                                                 │
│  /team        → Understand you're one of 1000+ instances        │
│               → Files are your only communication               │
│               → Status file is the baton                        │
│                                                                 │
│  /manager     → Run MID-SESSION for self-review                 │
│               → Verify following all other skills               │
│               → Prepare for potential context compression       │
│                                                                 │
│  /handoff     → Run when session ending                         │
│               → Commit all work                                 │
│               → Update status file with clear notes             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

SESSION FLOW:
/startup → /coding → /manager → /compliance → /handoff
              ↑          │
              └──────────┘ (iterate as needed)
```

---

## Context Monitoring

### Context Usage Awareness

Claude instances have limited context. As conversation grows:
- Early session: Full context available
- Mid session: Context filling up ← **RUN /manager HERE**
- Late session: Approaching compression ← **RUN /manager AGAIN**
- Compression: Conversation summarized, details lost

### Auto-Compact Warning

**CRITICAL: Watch for the "Context left until auto-compact" message.**

This message appears in system reminders as context fills up. When you see it:

```
┌─────────────────────────────────────────────────────────────────┐
│              AUTO-COMPACT RESPONSE PROTOCOL                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. STOP starting new work immediately                          │
│  2. Finish ONLY the current in-progress edit (if safe to do so) │
│  3. Run /handoff NOW — do NOT wait for the user to ask          │
│     → Commit all work                                           │
│     → Update status file with detailed notes                    │
│     → Verify tests pass                                         │
│  4. Tell the user: "Context approaching limit. All work         │
│     committed and status file updated for next instance."        │
│                                                                 │
│  ⚠️  If you wait too long, auto-compact WILL fire and you       │
│     will lose uncommitted work and context. The next instance   │
│     will have NO memory of your uncommitted changes.             │
│                                                                 │
│  ⚠️  Do NOT start a new task, new test file, or new feature     │
│     when this warning appears. Handoff is the ONLY priority.    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Thresholds:**
- **> 50% context remaining:** Continue working normally
- **25-50% context remaining:** Run /manager self-review, plan wrap-up
- **< 25% context remaining:** STOP new work, execute /handoff immediately
- **Auto-compact warning visible:** /handoff is OVERDUE — do it NOW

### Pre-Compression Self-Review

**BEFORE context compression occurs, instance MUST:**

1. Check: Am I following all 6 core skills?
2. Check: Is my work committed?
3. Check: Is status file updated?
4. Check: Are there clear notes for next instance?

---

## Self-Review Checklist

When `/manager` is invoked:

```
┌─────────────────────────────────────────────────────────────────┐
│                 INSTANCE SELF-REVIEW                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  /startup COMPLIANCE                                            │
│  □ Did I read .claude/work-status/current.json at start?        │
│  □ Did I verify previous instance's work?                       │
│  □ Did I run tests/analyzer before starting new work?           │
│                                                                 │
│  /coding COMPLIANCE                                             │
│  □ Am I following specs EXACTLY?                                │
│  □ Am I avoiding "interpretations" or "improvements"?           │
│  □ Have I checked my code against 22_API_CONTRACTS.md?          │
│                                                                 │
│  /compliance COMPLIANCE                                         │
│  □ Have I run flutter test before claiming complete?            │
│  □ Have I run flutter analyze --fatal-infos?                    │
│  □ Have I verified against spec, not just "it works"?           │
│                                                                 │
│  /team COMPLIANCE                                               │
│  □ Am I treating files as my only communication channel?        │
│  □ Am I updating status file for next instance?                 │
│  □ Am I avoiding decisions not in specs?                        │
│                                                                 │
│  /handoff READINESS                                             │
│  □ Is all my work committed (or ready to commit)?               │
│  □ Is status file current with my progress?                     │
│  □ Are notes clear enough for next instance?                    │
│  □ Could another instance continue my work seamlessly?          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Violation Detection

### Signs of Skill Non-Compliance

**Not using /startup:**
- Started coding without reading status file
- Didn't verify previous work
- Doesn't know what task to work on

**Not using /coding:**
- Made "improvements" not in spec
- Interpreted ambiguous spec instead of asking
- Added features not requested

**Not using /compliance:**
- Claimed work complete without running tests
- Didn't verify against spec
- Left analyzer warnings

**Not using /team:**
- Made decisions without spec backing
- Left uncommitted work
- Didn't update status file

**Not using /manager:**
- Long session without self-check
- Drifted from protocols without noticing
- Context compressed without preparation

**Not using /handoff:**
- Session ending with work in progress
- Status file not updated
- Notes unclear for next instance

---

## Corrective Actions

When violation detected:

```
VIOLATION: Not following [skill]
           │
           ▼
    ┌──────────────┐
    │ STOP current │
    │ activity     │
    └──────┬───────┘
           │
           ▼
    ┌──────────────┐
    │ Execute the  │
    │ missed skill │
    └──────┬───────┘
           │
           ▼
    ┌──────────────┐
    │ Resume work  │
    │ properly     │
    └──────────────┘
```

---

## Pre-Compression Protocol

When context is approaching limit:

```
1. STOP new work

2. SELF-REVIEW
   □ Run through checklist above
   □ Identify any violations
   □ Fix violations immediately

3. PREPARE HANDOFF
   □ Commit all current work
   □ Update .claude/work-status/current.json
   □ Write detailed notes for next instance

4. DOCUMENT STATE
   Status file should contain:
   - What was being worked on
   - What's complete
   - What's remaining
   - Any blockers or issues
   - Exact file:line if mid-edit

5. VERIFY CONTINUITY
   □ Could a fresh instance read status and continue?
   □ Are all decisions documented (not just in my "memory")?
   □ Is the baton ready to pass?
```

---

## Manager Checkpoints

### Mandatory Checkpoints

Run `/manager` at these points:
- **Mid-session:** After completing first significant task
- **Before compression:** When conversation is getting long
- **After deviation found:** When any protocol violation discovered

### Natural Checkpoint Triggers

Also run self-review at:
- After completing a task
- Before starting a new task
- When user says "let's wrap up" or similar
- After any significant code changes
- Before claiming anything is "done"

### Forced Checkpoint

If you notice:
- You've been working a long time without checking
- Conversation has many back-and-forth exchanges
- You're unsure if you followed startup protocol

**STOP and run `/manager` self-review immediately.**

---

## Integration with Audit Skills

If self-review reveals significant protocol violations:

```
Minor violation (missed one check):
→ Fix it, continue

Major violation (deviated from spec):
→ Run /implementation-review on affected code

Systematic violation (multiple instances drifted):
→ Flag for /spec-review to check if specs are unclear
```

---

## Status File Template

For handoff readiness, status file should look like:

```json
{
  "lastInstanceId": "unique-id",
  "lastAction": "implementing|completed|blocked|handoff",
  "taskId": "TASK-ID",
  "status": "in_progress|complete|blocked",
  "timestamp": "ISO-timestamp",
  "filesModified": ["list", "of", "files"],
  "testsStatus": "passing|failing|not_run",
  "complianceStatus": "verified|unverified",
  "notes": "Detailed notes a fresh instance can understand. Include: what was done, what's next, any issues, exact state if mid-work."
}
```

---

## The Baton

Remember the relay race metaphor:

```
Instance N ════════════════════════► Instance N+1
              passes the baton
              (status file)

Baton contains:
- Where we are
- What's done
- What's next
- Any issues
- All context needed

DROPPED BATON = Lost work, confusion, rework

Manager skill ensures the baton is always ready to pass.
```
