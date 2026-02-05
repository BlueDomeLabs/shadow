---
name: handoff
description: MANDATORY end-of-conversation protocol. Commit all work, update status file, and prepare notes for the next instance.
---

# Shadow Instance Handoff Skill

## MANDATORY: Execute When Conversation is Ending

When your conversation is being compacted, summarized, or ending, execute this protocol to ensure the next instance can continue seamlessly.

---

## Handoff Checklist

### 1. Commit All Work

**Nothing uncommitted should exist.** Uncommitted work is invisible to the next instance.

```bash
# Check for uncommitted changes
git status

# If changes exist, commit them
git add <specific-files>
git commit -m "SHADOW-XXX: Description of changes

- What was done
- What remains (if incomplete)
- Reference to spec section

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

### 2. Run Final Tests

```bash
flutter test
```

**All tests MUST pass.** If tests fail:
- Fix them before handoff
- Do NOT leave broken tests for next instance
- If you cannot fix, document clearly in status file

---

### 3. Run Final Analysis

```bash
flutter analyze
```

**No issues should exist.** If issues exist:
- Fix them before handoff
- Do NOT leave lint errors for next instance

---

### 4. Update Project Tracker (If Task Completed)

**IMPORTANT:** When completing a task or phase, update `34_PROJECT_TRACKER.md` to reflect current project state.

```bash
# Check if project tracker reflects your completed work
cat 34_PROJECT_TRACKER.md | grep -A5 "your-task-area"
```

Update the tracker to show:
- Completed tickets/phases marked as **DONE**
- Current phase status updated
- Next actions section reflects actual next work
- Test counts updated if significantly changed

**This is critical for future instances to understand project state.**

---

### 5. Update Work Status File

Update `.claude/work-status/current.json` with clear context:

#### If Work Is Complete:

```json
{
  "lastInstanceId": "<your-instance-id>",
  "lastAction": "completed",
  "taskId": "SHADOW-XXX",
  "status": "complete",
  "timestamp": "<current-iso-timestamp>",
  "filesModified": [
    "lib/domain/entities/fluids_entry.dart",
    "lib/domain/repositories/fluids_repository.dart",
    "test/domain/entities/fluids_entry_test.dart"
  ],
  "testsStatus": "passing",
  "complianceStatus": "verified",
  "notes": "Completed FluidsEntry entity and repository interface. Verified against 22_API_CONTRACTS.md Section 5. All 12 tests passing. Ready for repository implementation (SHADOW-XXX next)."
}
```

#### If Work Is In Progress:

```json
{
  "lastInstanceId": "<your-instance-id>",
  "lastAction": "handoff",
  "taskId": "SHADOW-XXX",
  "status": "in_progress",
  "timestamp": "<current-iso-timestamp>",
  "filesModified": [
    "lib/domain/entities/fluids_entry.dart",
    "lib/domain/repositories/fluids_repository.dart"
  ],
  "testsStatus": "passing",
  "complianceStatus": "verified",
  "notes": "Entity and repository interface complete. NEXT STEPS: 1) Implement FluidsRepositoryImpl in lib/data/repositories/, 2) Create FluidsLocalDataSource, 3) Write repository tests. See 22_API_CONTRACTS.md Section 5 for method signatures."
}
```

#### If Work Is Blocked:

```json
{
  "lastInstanceId": "<your-instance-id>",
  "lastAction": "blocked",
  "taskId": "SHADOW-XXX",
  "status": "blocked",
  "timestamp": "<current-iso-timestamp>",
  "filesModified": [],
  "testsStatus": "not_run",
  "complianceStatus": "unverified",
  "notes": "BLOCKED: 22_API_CONTRACTS.md Section 5.3 does not specify validation range for waterIntakeMl. Documented as AMBIGUITY-2026-02-02-001 in 53_SPEC_CLARIFICATIONS.md. Cannot proceed until spec clarified."
}
```

---

### 6. Document Decisions (If Any)

If you made any architectural decisions (even small ones):

1. Check if it should be documented
2. If yes, create ADR in `docs/decisions/ADR-XXX.md`
3. Reference the ADR in your status notes

**Note:** You should rarely make decisions. If you did, verify it was necessary.

---

### 7. Document Ambiguities (If Found)

If you encountered spec ambiguities:

1. Document in `53_SPEC_CLARIFICATIONS.md`:

```markdown
## AMBIGUITY-YYYY-MM-DD-NNN: Brief Title

**Found in:** [Document and section]
**Found by:** Instance during task SHADOW-XXX
**Issue:** [Clear description]
**Possible interpretations:**
1. [Option 1]
2. [Option 2]

**Blocking:** SHADOW-XXX
**Status:** AWAITING_CLARIFICATION
```

2. Reference in status file notes

---

## Handoff Notes Best Practices

### DO Write:
- Specific next steps ("Implement FluidsRepositoryImpl")
- Spec references ("See 22_API_CONTRACTS.md Section 5")
- File locations ("in lib/data/repositories/")
- What you verified ("All 12 tests passing")

### DON'T Write:
- Vague statements ("Continue working on fluids")
- Opinions ("I think we should...")
- Uncommitted work descriptions
- References to conversation context (next instance has none)

---

## Quick Handoff Checklist

```
□ All work committed to git
□ flutter test passes (all green)
□ flutter analyze passes (no issues)
□ 34_PROJECT_TRACKER.md updated (if task/phase completed)
□ .claude/work-status/current.json updated
□ Status field accurate (complete/in_progress/blocked)
□ Notes field has clear next steps
□ FilesModified list is accurate
□ Any ambiguities documented in 53_SPEC_CLARIFICATIONS.md
□ Any decisions documented in ADR (if architectural)
```

---

## What the Next Instance Will See

The next instance will:
1. Read `CLAUDE.md` (entry point)
2. Run `/startup` skill
3. Read your status file
4. Follow the decision tree based on status
5. Continue from your notes

**Write your notes as if explaining to a stranger who knows nothing about your conversation.**

---

## Emergency Handoff

If conversation is ending suddenly and you can't complete full handoff:

Priority order:
1. **Commit whatever is working** (even partial)
2. **Update status file** (even brief notes)
3. **Set testsStatus accurately** (passing/failing)

Minimum viable handoff:
```json
{
  "status": "in_progress",
  "notes": "Interrupted. Files modified: X, Y. Tests: passing/failing. See git log for recent commits."
}
```

---

## After Handoff

Your conversation may end. The next instance will:
- Have zero memory of this conversation
- Only know what's in files
- Follow the startup protocol
- Continue based on your notes

**Your handoff notes are your legacy. Make them count.**
