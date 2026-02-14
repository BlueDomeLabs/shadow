---
name: handoff
description: End-of-conversation protocol. Commit work, update status, prepare for next instance.
---

# Handoff

Run this when your conversation is ending or being compacted.

## Steps

1. **Commit all work** - nothing uncommitted should exist
2. **Run `flutter test`** - all tests must pass
3. **Run `flutter analyze`** - no issues
4. **Update `.claude/work-status/current.json`:**
   ```json
   {
     "status": "complete",
     "task": "What you completed",
     "timestamp": "ISO-8601",
     "testsStatus": "passing",
     "notes": "Clear next-steps for the next instance"
   }
   ```
5. **Update PLAN in CLAUDE.md** - check off completed items, note any new items discovered

## Notes Best Practices

- Be specific: "Implement FluidsRepositoryImpl in lib/data/repositories/"
- Reference specs: "See 22_API_CONTRACTS.md Section 5"
- State what's verified: "All 12 tests passing"
- Do NOT reference conversation context (next instance has none)

## Emergency Handoff

If conversation ending suddenly, minimum viable:
1. Commit whatever is working
2. Update status file (even brief)
3. Set testsStatus accurately
