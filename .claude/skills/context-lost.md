---
name: context-lost
description: Re-orient after context compaction. Read briefing and resume work.
---

Run this when you realize your context was just compacted or you
have lost track of where you are.

## Steps

1. Read ARCHITECT_BRIEFING.md — this is the single source of
   truth for current project state
2. Note the handoff header: Status, Last Action, Next Action,
   Tests, Schema
3. Run flutter test and flutter analyze — verify the codebase is
   in the state the briefing claims
4. Check git log --oneline -5 to see the last 5 commits and
   confirm you understand recent history
5. Re-read the phase prompt Reid gave you at the start of this
   session (scroll up if needed)
6. Resume work from exactly where you left off — do not restart
   or repeat completed steps

## What NOT to Do

- Do not start over from scratch
- Do not re-implement anything already committed
- Do not ask Reid to repeat instructions that are in the briefing
- Do not guess — read the files
