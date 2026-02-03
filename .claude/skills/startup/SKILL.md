---
name: startup
description: MANDATORY startup protocol for every Shadow instance. Run before ANY work to verify previous instance compliance and determine next action.
---

# Shadow Instance Startup Skill

## MANDATORY: Execute Before ANY Work

**You are a stateless agent.** Before writing any code or making any changes, complete this protocol.

---

## Step 1: Read Work Status

```bash
cat .claude/work-status/current.json
```

This tells you what the previous instance was doing:

```json
{
  "lastInstanceId": "previous-instance-id",
  "lastAction": "implementing|completed|blocked",
  "taskId": "SHADOW-XXX",
  "status": "in_progress|complete|blocked|failed",
  "timestamp": "2026-02-02T10:30:00Z",
  "filesModified": ["lib/domain/entities/example.dart"],
  "testsStatus": "passing|failing|not_run",
  "complianceStatus": "verified|unverified|failed",
  "notes": "Description of current state and next steps"
}
```

---

## Step 2: Verify Previous Work

Run compliance checks:

```bash
flutter test
flutter analyze
```

**If tests fail or analyzer has errors:**
- FIX FIRST before proceeding
- Do not start new work on top of broken code
- Update status file when fixed

---

## Step 3: Determine Next Action

### If `status == "in_progress"` AND `testsStatus == "failing"`:
```
Previous instance left broken code.
→ Run tests, identify failures
→ Fix the failures
→ Update status to "complete" or document why blocked
```

### If `status == "in_progress"` AND `testsStatus == "passing"`:
```
Previous instance was interrupted mid-task.
→ Review filesModified to understand context
→ Read the notes field for guidance
→ Continue the task from where they stopped
```

### If `status == "complete"`:
```
Previous task is done.
→ Read 34_PROJECT_TRACKER.md
→ Pick next available task (check dependencies)
→ Update status file with new task
→ Begin work
```

### If `status == "blocked"`:
```
Previous instance hit a blocker.
→ Read notes for blocking reason
→ If you can resolve: do so, then continue
→ If not: pick alternate task, leave blocked status
```

### If `status == "failed"`:
```
Previous instance encountered failure.
→ Read notes for failure reason
→ Attempt to resolve
→ If unresolvable: escalate to user
```

---

## Step 4: Update Status File

Before making ANY changes, claim your work:

```json
{
  "lastInstanceId": "<generate-unique-id>",
  "lastAction": "starting",
  "taskId": "SHADOW-XXX",
  "status": "in_progress",
  "timestamp": "<current-iso-timestamp>",
  "filesModified": [],
  "testsStatus": "not_run",
  "complianceStatus": "verified",
  "notes": "Starting [description]. See [spec reference]."
}
```

---

## Step 5: Read Required Documents

Before writing code, read in this order:

1. **`52_INSTANCE_COORDINATION_PROTOCOL.md`** - Coordination rules
2. **`/coding` skill** - Code production rules
3. **`22_API_CONTRACTS.md`** - Exact interface definitions
4. **`02_CODING_STANDARDS.md`** - Mandatory patterns
5. **Task-specific specs** - As referenced in tracker

---

## Startup Checklist

```
□ Read .claude/work-status/current.json
□ Run flutter test (fix failures if any)
□ Run flutter analyze (fix issues if any)
□ Determine next action based on status
□ Update status file to claim task
□ Read relevant specification documents
□ Ready to begin work
```

---

## Common Startup Scenarios

### Scenario: Fresh start (status == "complete")
1. Check `34_PROJECT_TRACKER.md` for next task
2. Verify task dependencies are met
3. Update status file with new task
4. Read task-specific specs
5. Begin implementation

### Scenario: Continue interrupted work (status == "in_progress")
1. Review `filesModified` list
2. Read the `notes` field carefully
3. Check referenced spec sections
4. Continue from where previous instance stopped
5. Update status file with your progress

### Scenario: Fix broken code (testsStatus == "failing")
1. Run `flutter test` to see failures
2. Identify which tests fail
3. Check if code violates spec → fix code
4. Check if test is wrong → verify against spec, fix test
5. Get all tests passing
6. Then proceed with normal startup

### Scenario: Blocked work (status == "blocked")
1. Read `53_SPEC_CLARIFICATIONS.md` for the blocker
2. Check if the ambiguity has been resolved
3. If resolved: continue the blocked task
4. If not resolved: pick different task

---

## After Startup

Once startup is complete:
- Use `/coding` skill when writing code
- Use `/compliance` skill before claiming work is done
- Use `/handoff` skill when conversation is ending
