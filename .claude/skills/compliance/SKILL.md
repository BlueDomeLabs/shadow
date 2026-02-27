---
name: compliance
description: Pre-completion checklist. Run before claiming work is done.
---

# Compliance

Run this BEFORE telling the user work is complete.

## Checklist

```
[ ] flutter test                       -> All passing
[ ] flutter analyze                    -> No issues
[ ] dart format --set-exit-if-changed lib/ test/  -> Exit 0
[ ] Entity fields match 22_API_CONTRACTS.md EXACTLY
[ ] Repository methods match contracts EXACTLY
[ ] All timestamps are int (not DateTime)
[ ] All error codes from approved list
[ ] Tests cover success AND failure paths
[ ] Authorization checked where required (every use case)
[ ] ARCHITECT_BRIEFING.md updated with session log entry
```

## If Any Check Fails

Fix the issue, re-run the check. Do NOT claim complete until all pass.

## After All Pass

1. Commit your work
2. Deliver the completion report to Reid (see COMPLETION REPORT FORMAT in CLAUDE.md)
3. Update ARCHITECT_BRIEFING.md handoff header with current status, test count, and next action
