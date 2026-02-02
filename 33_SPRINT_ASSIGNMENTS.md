# Shadow Sprint Assignments & Coordination

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Detailed task assignments with coordination instructions

---

## 1. Sprint Structure

### 1.1 Sprint Cadence

| Sprint | Weeks | Phase | Focus |
|--------|-------|-------|-------|
| Sprint 1 | 1-2 | Phase 0 | Foundation |
| Sprint 2 | 3-4 | Phase 1A | Core entities |
| Sprint 3 | 5-6 | Phase 1B | All entities + widgets |
| Sprint 4 | 7-8 | Phase 2A | First features |
| Sprint 5 | 9-10 | Phase 2B | More features |
| Sprint 6 | 11-12 | Phase 2C | Sync + Platform |
| Sprint 7 | 13-14 | Phase 3A | Enhanced features |
| Sprint 8 | 15-16 | Phase 3B | Enhanced features |
| Sprint 9 | 17-18 | Phase 3C | Final features |
| Sprint 10 | 19-20 | Phase 4A | Integration |
| Sprint 11 | 21-22 | Phase 4B | Beta |
| Sprint 12 | 23-24 | Phase 5A | Launch prep |
| Sprint 13 | 25-26 | Phase 5B | Launch + monitoring |

---

## 2. Sprint 1: Foundation (Weeks 1-2)

### 2.1 Team: Core (3 engineers)

| Engineer | Task ID | Task | Days | Output | Coordination |
|----------|---------|------|------|--------|--------------|
| **Core-1** | P0-001 | Project setup | 2 | App shell running | None |
| | P0-002 | Folder structure | 1 | Directories created | After P0-001 |
| | P0-005 | Result type | 1 | result.dart | After P0-002 |
| | P0-006 | AppError hierarchy | 2 | All error classes | After P0-005 |
| | P0-010 | Logger service | 1 | LoggerService | After P0-002 |
| | P0-014 | Pre-commit hooks | 1 | Hooks installed | After P0-013 |
| **Core-2** | P0-003 | Dependencies | 1 | pubspec.yaml | After P0-001 |
| | P0-004 | Code gen setup | 2 | build_runner working | After P0-003 |
| | P0-007 | Base repository | 1 | BaseRepository | After P0-006 |
| | P0-011 | Device info service | 1 | DeviceInfoService | After P0-003 |
| | P0-015 | Custom lint rules | 2 | analysis_options | After P0-004 |
| **Core-3** | P0-008 | Database helper | 3 | AppDatabase | After P0-004 |
| | P0-009 | Encryption service | 2 | EncryptionService | After P0-002 |
| | P0-012 | Localization setup | 1 | l10n.yaml, base ARB | After P0-002 |
| | P0-013 | CI/CD pipeline | 2 | GitHub Actions | After P0-004 |

### 2.2 Coordination Instructions - Sprint 1

```
Day 1 Morning:
├── Core-1: Start P0-001 (project setup)
├── Core-2: WAIT for Core-1 to complete P0-001
└── Core-3: WAIT for Core-1 to complete P0-001

Day 1 Afternoon:
├── Core-1: Continue P0-001
├── Core-2: Start P0-003 once P0-001 merged
└── Core-3: WAIT

Day 2:
├── Core-1: Complete P0-001, start P0-002
├── Core-2: Complete P0-003, start P0-004
└── Core-3: Start P0-008 once P0-004 has Drift configured

Day 3-4:
├── Core-1: P0-005, P0-006 (Result type, errors)
├── Core-2: Complete P0-004, start P0-007
└── Core-3: Continue P0-008

Day 5-6:
├── Core-1: P0-010, P0-014
├── Core-2: P0-011, P0-015
└── Core-3: P0-009, P0-012, P0-013

HANDOFF: At end of Sprint 1, Core Team posts in #shadow-engineering:
"Sprint 1 Complete: Foundation ready. UI Team can begin Sprint 2."
```

### 2.3 Sprint 1 Checklist

- [ ] App builds on iOS, Android, macOS
- [ ] Code generation (freezed, drift, riverpod) working
- [ ] Pre-commit hooks installed and tested
- [ ] CI pipeline runs on PR
- [ ] Result type with all error classes
- [ ] Database helper with encryption
- [ ] Logger service with scoped logging

---

## 3. Sprint 2: Core Entities (Weeks 3-4)

### 3.1 Team: Core (3 engineers)

| Engineer | Task ID | Task | Days | Output |
|----------|---------|------|------|--------|
| **Core-1** | P1-001 | SyncMetadata entity | 1 | sync_metadata.dart |
| | P1-002 | Profile entity | 2 | profile.dart + .freezed |
| | P1-003 | Profile repository interface | 1 | profile_repository.dart |
| | P1-007 | UserAccount entity | 1 | user_account.dart |
| | P1-010 | Auth repository interface | 1 | auth_repository.dart |
| **Core-2** | P1-004 | Profile repository impl | 2 | profile_repository_impl.dart |
| | P1-006 | Profile contract tests | 1 | profile_contract_test.dart |
| | P1-008 | DeviceRegistration entity | 1 | device_registration.dart |
| **Core-3** | P1-005 | Profile database table | 1 | Drift table |
| | P1-009 | ProfileAccess entity | 1 | profile_access.dart |

### 3.2 Team: UI (4 engineers) - Joins Sprint 2

| Engineer | Task ID | Task | Days | Output |
|----------|---------|------|------|--------|
| **UI-1** | P1-011 | AppTheme setup | 2 | app_theme.dart |
| | P1-012 | AppColors | 1 | app_colors.dart |
| **UI-2** | P1-013 | ShadowButton | 2 | shadow_button.dart |
| | P1-014 | ShadowTextField | 2 | shadow_text_field.dart |
| **UI-3** | P1-015 | ShadowCard | 1 | shadow_card.dart |
| | P1-016 | ShadowImage | 1 | shadow_image.dart |
| **UI-4** | P1-017 | ShadowDialog | 2 | shadow_dialog.dart |
| | P1-018 | ShadowStatus | 1 | shadow_status.dart |

### 3.3 Coordination Instructions - Sprint 2

```
ONBOARDING: UI Team (Days 1-2)
├── Day 1 AM: Environment setup, read specs 01-10
├── Day 1 PM: Architecture walkthrough with Core-1
├── Day 2 AM: Read specs 11-25, quiz 1
└── Day 2 PM: Quiz 2, assign first tasks

PARALLEL WORK (Days 3-8):
├── Core Team: Entities (no UI dependency)
├── UI Team: Widgets (depends only on P0 foundation)
└── No blocking dependencies between teams

DAILY SYNC (9:30 AM):
├── Core-1 reports entity progress
├── UI-1 reports widget progress
└── Identify any blockers

END OF SPRINT:
├── Core posts: "Profile entity ready, interface frozen"
├── UI posts: "Widget library v1 ready for feature teams"
└── Both teams demo to Quality Team
```

### 3.4 Sprint 2 Acceptance Criteria

**Core Team Deliverables:**
- [ ] Profile entity with all fields (incl. dietType, dietDescription)
- [ ] Profile repository interface defined per 22_API_CONTRACTS.md
- [ ] Profile repository implementation with Result type
- [ ] Contract tests passing for Profile
- [ ] UserAccount, DeviceRegistration, ProfileAccess entities

**UI Team Deliverables:**
- [ ] AppTheme with earth tones
- [ ] ShadowButton with all variants
- [ ] ShadowTextField with accessibility
- [ ] ShadowCard, ShadowImage, ShadowDialog, ShadowStatus
- [ ] All widgets have semantic labels
- [ ] Widget tests for each widget

---

## 4. Sprint 4: First Features (Weeks 7-8)

### 4.1 Team Onboarding Schedule

| Day | Team | Activity |
|-----|------|----------|
| Day 1 | Conditions, Supplements | Environment setup, specs 01-15 |
| Day 2 | Conditions, Supplements | Specs 16-33, quizzes, architecture walkthrough |
| Day 3 | Conditions, Supplements | Quiz review, assign first tasks |
| Day 4-8 | All | Implementation |

### 4.2 Team: Conditions (8 engineers)

| Engineer | Task ID | Task | Days | Depends On |
|----------|---------|------|------|------------|
| **Cond-Lead** | - | Onboarding, planning | 3 | - |
| | P2-003 | Condition use cases | 3 | Onboarding |
| | - | Code reviews | Ongoing | - |
| **Cond-Sr1** | P2-004 | Condition provider | 2 | P2-003 |
| | P2-005a | Conditions tab UI | 2 | P2-004 |
| **Cond-Sr2** | P2-005b | Conditions tab logic | 2 | P2-004 |
| | - | Code reviews | Ongoing | - |
| **Cond-E1** | P2-006a | Add condition form | 2 | P2-004 |
| **Cond-E2** | P2-006b | Add condition validation | 2 | P2-006a |
| **Cond-E3** | Tests | Condition use case tests | 3 | P2-003 |
| **Cond-A1** | Tests | Condition provider tests | 2 | P2-004 |
| **Cond-A2** | Docs | Condition flow documentation | 2 | P2-005 |

### 4.3 Team: Supplements (8 engineers)

| Engineer | Task ID | Task | Days | Depends On |
|----------|---------|------|------|------------|
| **Supp-Lead** | - | Onboarding, planning | 3 | - |
| | P2-007 | Supplement use cases | 3 | Onboarding |
| | - | Code reviews | Ongoing | - |
| **Supp-Sr1** | P2-008 | Supplement provider | 2 | P2-007 |
| | P2-009a | Supplements tab UI | 2 | P2-008 |
| **Supp-Sr2** | P2-009b | Supplements tab logic | 2 | P2-008 |
| | - | Code reviews | Ongoing | - |
| **Supp-E1** | P2-010a | Add supplement form | 2 | P2-008 |
| **Supp-E2** | P2-010b | Ingredient management | 2 | P2-010a |
| **Supp-E3** | Tests | Supplement use case tests | 3 | P2-007 |
| **Supp-A1** | Tests | Supplement provider tests | 2 | P2-008 |
| **Supp-A2** | Docs | Supplement flow documentation | 2 | P2-009 |

### 4.4 Team: UI (4 engineers) - Continues

| Engineer | Task ID | Task | Days |
|----------|---------|------|------|
| **UI-1** | P2-011 | Home screen shell | 2 |
| | P2-012 | Tab navigation | 2 |
| **UI-2** | Support | Widget support for feature teams | Ongoing |
| **UI-3** | Support | Widget support for feature teams | Ongoing |
| **UI-4** | Refinement | Widget accessibility refinement | 3 |

### 4.5 Coordination Instructions - Sprint 4

```
ONBOARDING COORDINATION:
├── Core-1 leads architecture session (Day 2, 2 hrs)
├── UI-1 leads widget library demo (Day 2, 1 hr)
└── Quality leads testing patterns session (Day 3, 1 hr)

DEPENDENCY CHECK (Daily 9:30 AM):
├── Cond-Lead: "We need Profile repository - Core status?"
├── Core-1: "Profile ready on develop, pull and verify"
├── Supp-Lead: "We need ShadowTextField - UI status?"
└── UI-1: "ShadowTextField on develop, tests passing"

HANDOFF PROTOCOL:
When Cond-Lead completes P2-003 (use cases):
1. Merge to develop
2. Post: "@team-conditions P2-003 merged, providers can start"
3. Cond-Sr1 pulls develop, begins P2-004

BLOCKED RESOLUTION:
If Cond-E1 blocked waiting for P2-004:
1. Post in #team-conditions: "Blocked on P2-004"
2. Cond-Lead assigns alternate task from backlog
3. OR pairs Cond-E1 with Cond-Sr1 on P2-004

END OF SPRINT:
├── Demo: Conditions tab with add condition flow
├── Demo: Supplements tab with add supplement flow
├── Commit: All use cases, providers, screens merged
└── Handoff: "Ready for Nutrition and Wellness teams"
```

---

## 5. Sprint 6: Sync + Platform (Weeks 11-12)

### 5.1 Team: Sync (8 engineers)

| Engineer | Task ID | Task | Days | Critical Path |
|----------|---------|------|------|---------------|
| **Sync-Lead** | - | Onboarding | 3 | - |
| | P2-032 | OAuth service | 4 | YES - blocks all sync |
| **Sync-Sr1** | P2-033 | Google Drive provider | 5 | Needs P2-032 |
| **Sync-Sr2** | P2-034 | Sync service | 5 | Needs P2-033 |
| **Sync-E1** | P2-035 | Conflict resolver | 3 | Needs P2-034 |
| **Sync-E2** | P2-036 | Sync provider | 2 | Needs P2-034 |
| **Sync-E3** | P2-037 | Sync settings screen | 3 | Needs P2-036 |
| **Sync-A1** | Tests | OAuth tests | 3 | Needs P2-032 |
| **Sync-A2** | Tests | Sync service tests | 3 | Needs P2-034 |

### 5.2 Team: Platform (8 engineers)

| Engineer | Task ID | Task | Days | Critical Path |
|----------|---------|------|------|---------------|
| **Plat-Lead** | - | Onboarding | 3 | - |
| | P2-038 | Notification service | 4 | YES - blocks notifications |
| **Plat-Sr1** | P2-039 | Notification use cases | 3 | Needs P2-038 |
| **Plat-Sr2** | P2-042 | Deep link handler | 3 | Needs P2-038 |
| **Plat-E1** | P2-040 | Notification provider | 2 | Needs P2-039 |
| **Plat-E2** | P2-041 | Notification settings screen | 3 | Needs P2-040 |
| **Plat-E3** | P2-043 | Time picker widget | 2 | Uses ShadowPicker |
| | P2-044 | Weekday selector widget | 2 | Uses ShadowPicker |
| **Plat-A1** | Tests | Notification service tests | 3 | Needs P2-038 |
| **Plat-A2** | Tests | Deep link tests | 2 | Needs P2-042 |

### 5.3 Coordination Instructions - Sprint 6

```
CRITICAL PATH ALERT:
├── P2-032 (OAuth) is on critical path - PRIORITY
├── P2-038 (Notifications) is on critical path - PRIORITY
└── Both Lead engineers focus exclusively on these

CROSS-TEAM DEPENDENCIES:
├── ALL feature teams need P2-034 (Sync service) by Week 13
├── Wellness team needs P2-043/P2-044 for notification settings
└── Core team provides sync metadata helpers

DAILY SYNC (9:30 AM) - CRITICAL:
├── Sync-Lead: OAuth progress, blockers
├── Plat-Lead: Notification service progress
├── Core-Lead: Any support needed?
└── Escalate immediately if behind

INTERFACE FREEZE:
├── Week 12 End: Sync service interface FROZEN
├── Week 12 End: Notification service interface FROZEN
└── Changes after freeze require ADR + emergency approval

HANDOFF TO PHASE 3:
When P2-034 complete:
├── Post: "@all-feature-teams Sync service ready"
├── Document: Sync integration guide
└── Office hours: Sync team available for questions
```

---

## 6. Agent/Engineer Coordination Protocol

### 6.1 Before Starting Any Task

```
CHECKLIST:
□ Pull latest from develop branch
□ Check dependencies.yml for blocking issues
□ Verify dependent tasks are complete
□ Read the specification for this task
□ Understand acceptance criteria
□ Check API Contracts for interface requirements
```

### 6.2 During Task Execution

```
COORDINATION COMMANDS:

"I need {X} from {Team/Person}":
1. Check if X is complete (dependencies.yml, develop branch)
2. If not complete, post in their team channel
3. If blocked >4 hours, escalate to team lead
4. Pick up alternate task while waiting

"I completed {TaskID}":
1. Ensure all tests pass
2. Ensure contract tests pass
3. Create PR with complete description
4. Post: "@team {TaskID} ready for review"
5. Update dependencies.yml if this unblocks others
6. Notify blocked teams: "@{team} {TaskID} complete, you're unblocked"

"I'm blocked on {TaskID}":
1. Post in team channel immediately
2. Tag the blocking person/team
3. Escalate to team lead if no response in 2 hours
4. Team lead assigns alternate work

"I have a question about {interface/pattern}":
1. Check specs (01-33) first
2. Check API Contracts (22)
3. If not answered, ask in #shadow-architecture
4. If urgent, DM Core team lead
```

### 6.3 Cross-Team Coordination

```
REQUESTING WORK FROM ANOTHER TEAM:

1. Create ticket in their backlog (if not exists)
2. Post in their team channel with ticket link
3. Attend their standup to discuss (if >1 day effort)
4. Track in dependencies.yml

Example:
"@team-sync SHADOW-456: Wellness team needs sync metadata helpers for BBT entries.
Can this be prioritized this sprint? Blocks P3-029 due Week 15."

PROVIDING WORK TO ANOTHER TEAM:

1. Complete task with full tests
2. Document usage with examples
3. Post in their channel with location
4. Offer office hours for questions

Example:
"@team-wellness P2-043 (NotificationTimePicker) is on develop.
Usage: `NotificationTimePicker(times: [], onTimesChanged: (t) => {})`
Full docs in widget library. Ping me with questions."
```

### 6.4 End of Sprint Protocol

```
THURSDAY (2 days before sprint end):
□ All code PRs submitted
□ All PRs in review
□ Identify any at-risk items
□ Escalate blockers to leads

FRIDAY (1 day before):
□ All PRs merged or exception documented
□ Demo prepared for sprint review
□ Dependencies updated for next sprint
□ Handoff notes for consuming teams

SPRINT REVIEW:
□ Demo completed work
□ Document what didn't complete (and why)
□ Update next sprint assignments
□ Retro: What blocked us? How to improve?
```

---

## 7. Escalation Matrix

| Situation | Wait Time | Escalate To | Action |
|-----------|-----------|-------------|--------|
| Blocked by PR review | 24 hours | Team Lead | Reassign reviewer |
| Blocked by other team | 4 hours | Both Team Leads | Priority discussion |
| Unclear requirements | 2 hours | Product + Tech Lead | Clarification meeting |
| Technical disagreement | 1 meeting | Staff Engineer | Decision made |
| Critical path at risk | Immediate | Engineering Director | Resource reallocation |

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
