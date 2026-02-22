# Shadow Health Tracking App

## ABOUT YOUR MANAGER

Reid Barcus is the owner of Blue Dome LLC and your manager. He is NOT a programmer and cannot read or write code. He understands the product vision but not the technical implementation. This means:

- **Explain plans in plain language** before coding. No file paths, no class names, no jargon. Describe what the user will see and experience.
- **Keep Reid updated** as you work. When you finish something, say what changed in terms a non-programmer can understand (e.g., "Users can now tap a supplement to edit its dosage" not "Implemented SupplementEditScreen with Riverpod provider bindings").
- **When asking Reid to verify your work**, tell him how to check it by running the app and what to look for on screen, not by reading code.
- **When you need a decision**, present options with plain-language trade-offs, not technical details.
- **Update VISION.md** if your work changes what the user sees or does. This is Reid's document - keep it in his language.
- **Update DECISIONS.md** when you make any significant choice, in plain language, so Reid has a record of why things were done a certain way.
- **ALWAYS copy your response to the clipboard** using `pbcopy` after every reply. Reid shares responses with Claude.ai (which makes decisions), so every response must be on the clipboard. No exceptions.

---

## ABSOLUTE RULES

1. **NO AGENTS.** Do NOT use the Task tool, TeamCreate, SendMessage, or spawn any subagents. All work is done by YOU directly. Violating this will terminate your session.
2. **NO DECISIONS.** Follow specs exactly. If something is ambiguous, STOP and ask the user. An ambiguity is a bug in the spec, not permission to interpret.
3. **NO UNCOMMITTED WORK.** Before your conversation ends or compacts, commit everything and update the status file.

---

## SESSION PROTOCOL

Every session follows this flow. No exceptions.

### 1. STARTUP (before any work)
- Read `.claude/work-status/current.json` to understand current state
- Run `flutter test` and `flutter analyze` - fix failures before new work
- Check `git status` for uncommitted changes from previous instance
- Read the PLAN below to determine what to work on next
- **PRESENT THE PLAN TO REID.** Before doing anything, show Reid a plain-language summary of: (a) what the previous instance completed, (b) what the current state of the project is, and (c) what you plan to work on next. Ask Reid to confirm before proceeding. Reid is not a programmer - use simple language, no jargon. **Do this at session start AND after context compaction** (compaction makes you lose details - re-read files and re-present the plan).

### 2. CLAIM YOUR WORK
Update `.claude/work-status/current.json` before making any changes:
```json
{
  "status": "in_progress",
  "task": "Brief description of what you're doing",
  "timestamp": "ISO-8601",
  "testsStatus": "passing"
}
```

### 3. CODE (follow specs exactly)
- Read `22_API_CONTRACTS.md` for interface definitions
- Read `02_CODING_STANDARDS.md` for patterns
- Read task-specific specs as needed
- Every entity: `id`, `clientId`, `profileId`, `syncMetadata`
- Every repository method: returns `Result<T, AppError>`
- Every timestamp: `int` (epoch milliseconds), never `DateTime`
- Every enum: explicit integer values
- Every use case: validate profile access first
- Every change: tests proving spec compliance

### 4. BEFORE SAYING "DONE"
```
[ ] flutter test             -> All passing
[ ] flutter analyze          -> No issues
[ ] dart format lib/ test/   -> Clean
[ ] Code matches specs EXACTLY
[ ] Status file updated
[ ] DECISIONS.md updated (if any choices were made)
[ ] Plain-language summary given to Reid
```

### 5. HANDOFF (before conversation ends)
- Commit all work with descriptive message
- Update status file with `status: "complete"` and clear next-steps
- Update PLAN checklist below (check off completed items)
- Run tests one final time
- Give Reid a plain-language summary of what was accomplished

---

## CURRENT PLAN (Updated 2026-02-14)

This is the single source of truth for what to work on. Check items off as completed.

### Completed
- [x] Domain layer (14 entities, 14 repositories, 51 use cases)
- [x] Data layer (DAOs, tables, repository implementations)
- [x] Riverpod providers (51 use cases, 14 repositories)
- [x] Core widgets (ShadowButton, ShadowTextField, ShadowCard, ShadowDialog, ShadowStatus)
- [x] Specialized widgets (ShadowPicker, ShadowChart, ShadowImage, ShadowInput, ShadowBadge)
- [x] SupplementListScreen (reference pattern, 23 tests)
- [x] Hardcoded values audit
- [x] Bootstrap / app initialization
- [x] Home screen refactor (9-tab navigation)
- [x] Profile management UI (welcome, list, add/edit screens)
- [x] Cloud sync UI shells (setup + settings screens)
- [x] Cloud storage provider abstract interface
- [x] Sample data generator
- [x] Cloud sync research (reviewed archived code, reported findings to Reid)

### Cloud Sync (4-Phase Plan)

Each phase follows: (a) update & validate specs, (b) implement code, (c) test

**Phase 1: Google Drive Provider (sign in + talk to Google Drive)**
- [x] 1a. Update and validate spec documents against Coding Standards
- [x] 1b. Implement GoogleDriveProvider (authentication, file operations) + 86 unit tests
- [x] 1c. Wire up Cloud Sync Setup screen to real sign-in
- [x] 1d. Guided integration test with Reid (factory-reset, step-by-step sign-in, log verification)

**Phase 2: Upload data (push encrypted health data to Google Drive)**
- [x] 2a. Update and validate spec documents against Coding Standards
- [x] 2b. Implement SyncService upload path (encrypt + push dirty records)
- [x] 2c. Tests proving spec compliance (29 tests)

**Phase 3: Download data (pull data from Google Drive)**
- [x] 3a. Update and validate spec documents against Coding Standards
- [x] 3b. Implement SyncService download path (pull + decrypt + merge)
- [x] 3c. Tests proving spec compliance (15 pull path tests)

**Phase 4: Full sync with conflict handling**
- [x] 4a. Update and validate spec documents against Coding Standards
- [x] 4b. Implement conflict detection, resolution, and bidirectional sync
- [x] 4c. Wire up Cloud Sync Settings screen to real status/controls (sync status, conflict banner, last sync time)
- [x] 4d. Tests proving spec compliance (2192 total; 5 new screen tests + 15 sync service conflict tests + 10 SyncMetadata tests)

### After Cloud Sync (Priority Order)
- [x] 5. SupplementEditScreen (full implementation)
  - Pre-work DONE: customDosageUnit field added to entity + database (schema v9)
  - DONE: Custom Unit field, Ingredients tag input, full Schedule section (79 tests)
- [x] 6. ConditionListScreen (implementation existed; brought tests to reference level: 24 tests)
- [ ] 7. FoodListScreen
- [ ] 8. SleepListScreen
- [ ] 9. Remaining entity screens (see `38_UI_FIELD_SPECIFICATIONS.md`)
- [ ] 10. Domain-layer Profile entity (freezed, with codegen)
- [ ] 11. Profile repository + DAO (wire into database)

### Test Count: 2231 passing | Analyzer: clean | Schema: v9

---

## KEY REFERENCE FILES

| Document | Purpose |
|----------|---------|
| `VISION.md` | Plain-language product vision (Reid's document) |
| `DECISIONS.md` | Log of all significant decisions with reasoning |
| `22_API_CONTRACTS.md` | Exact interface definitions (canonical) |
| `02_CODING_STANDARDS.md` | Mandatory patterns |
| `38_UI_FIELD_SPECIFICATIONS.md` | Field-by-field screen specs |
| `10_DATABASE_SCHEMA.md` | Database structure |
| `lib/presentation/screens/supplements/supplement_list_screen.dart` | Screen reference implementation |

---

## SKILLS

| Skill | When | Purpose |
|-------|------|---------|
| `/startup` | Session start | Verify state, determine next work |
| `/coding` | Writing code | Spec-exact coding rules |
| `/compliance` | Before claiming done | Verify tests, analyzer, spec match |
| `/handoff` | Session ending | Commit, update status, prepare notes |
| `/factory-reset` | Testing | Clear app data for fresh start |
| `/spec-review` | Before major implementation | Verify specs against coding standards |
| `/implementation-review` | After implementation | Verify code matches specs exactly |

---

## QUICK COMMANDS

```bash
flutter test                                              # Run tests
flutter analyze                                           # Static analysis
dart format lib/ test/                                    # Format code
dart run build_runner build --delete-conflicting-outputs  # Generate code
```
