---
name: handoff
description: End-of-conversation protocol. Commit work, update status, prepare for next instance.
---

Run this when your conversation is ending or about to be compacted.

## Steps

1. Commit all work — nothing uncommitted should exist
2. Run flutter test — all tests must pass
3. Run flutter analyze — no issues
4. Update ARCHITECT_BRIEFING.md:
   - Add a timestamped session log entry (reverse chronological)
   - Update the handoff header: Status, Last Action, Next Action,
     Open Items, Tests, Schema, Analyzer
5. Update DECISIONS.md if you made any implementation choices not
   already covered by the spec
6. Deliver the completion report to Reid:
   - Plain-language summary (what the user can now do)
   - File change table (every file created, modified, or deleted)
   See COMPLETION REPORT FORMAT in CLAUDE.md for the exact format.

## If Conversation Is Ending Suddenly

Minimum viable handoff:
1. Commit whatever is in a passing state
2. Update ARCHITECT_BRIEFING.md even briefly
3. Never leave the test count in ARCHITECT_BRIEFING.md wrong
