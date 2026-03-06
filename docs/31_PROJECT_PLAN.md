# Shadow Project Execution Plan

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Detailed work breakdown, timeline, and team coordination

---

## 1. Project Overview

### 1.1 Timeline Summary

| Phase | Duration | Teams Active | Key Deliverable |
|-------|----------|--------------|-----------------|
| **Phase 0** | Weeks 1-2 | Core (3) | Foundation, tooling, base classes |
| **Phase 1** | Weeks 3-6 | Core (3) + UI (4) | All entities, repositories, database |
| **Phase 2** | Weeks 7-12 | All teams (64) | Core features, screens, providers |
| **Phase 3** | Weeks 13-18 | All teams (64) | Enhanced features, sync, notifications |
| **Phase 4** | Weeks 19-22 | All + QA (4) | Integration, polish, beta |
| **Phase 5** | Weeks 23-26 | All (100) | Launch prep, rollout, monitoring |

### 1.2 Team Ramp-Up Schedule

```
Week 1-2:   Core Team (3)
Week 3-4:   + UI Team (4) = 7 engineers
Week 5-6:   + Quality Team (4) = 11 engineers
Week 7-8:   + Team Conditions (8) + Team Supplements (8) = 27 engineers
Week 9-10:  + Team Nutrition (8) + Team Wellness (8) = 43 engineers
Week 11-12: + Team Sync (8) + Team Platform (8) = 59 engineers
Week 13+:   + Staff Engineers (3) + Remaining (38) = 100 engineers
```

---

## 2. Work Breakdown Structure

### 2.1 Phase 0: Foundation (Weeks 1-2)

**Owner:** Core Team (3 engineers)

| ID | Task | Assignee | Duration | Dependencies | Deliverable |
|----|------|----------|----------|--------------|-------------|
| P0-001 | Project setup, Flutter config | Core-1 | 2 days | None | Running app shell |
| P0-002 | Folder structure per architecture | Core-1 | 1 day | P0-001 | Directory structure |
| P0-003 | Dependencies in pubspec.yaml | Core-2 | 1 day | P0-001 | All packages installed |
| P0-004 | Freezed/Drift/Riverpod setup | Core-2 | 2 days | P0-003 | Code gen working |
| P0-005 | Result type implementation | Core-1 | 1 day | P0-002 | lib/core/types/result.dart |
| P0-006 | AppError hierarchy | Core-1 | 2 days | P0-005 | All error classes |
| P0-007 | Base repository class | Core-2 | 1 day | P0-006 | BaseRepository |
| P0-008 | Database helper (Drift) | Core-3 | 3 days | P0-004 | AppDatabase class |
| P0-009 | Encryption service | Core-3 | 2 days | P0-002 | EncryptionService |
| P0-010 | Logger service | Core-1 | 1 day | P0-002 | LoggerService |
| P0-011 | Device info service | Core-2 | 1 day | P0-003 | DeviceInfoService |
| P0-012 | Localization setup | Core-3 | 1 day | P0-002 | l10n.yaml, base ARB |
| P0-013 | CI/CD pipeline setup | Core-3 | 2 days | P0-004 | GitHub Actions |
| P0-014 | Pre-commit hooks | Core-1 | 1 day | P0-013 | .git/hooks |
| P0-015 | Custom lint rules | Core-2 | 2 days | P0-004 | analysis_options.yaml |

**Milestone P0:** Foundation complete, code generation working, CI passing

---

### 2.2 Phase 1: Domain Layer (Weeks 3-6)

**Owners:** Core Team (3) + UI Team (4) joining Week 3

#### Week 3-4: Core Entities

| ID | Task | Assignee | Duration | Dependencies | Deliverable |
|----|------|----------|----------|--------------|-------------|
| P1-001 | SyncMetadata entity | Core-1 | 1 day | P0-005 | sync_metadata.dart |
| P1-002 | Profile entity + model | Core-1 | 2 days | P1-001 | profile.dart, profile.freezed.dart |
| P1-003 | Profile repository interface | Core-1 | 1 day | P1-002 | profile_repository.dart |
| P1-004 | Profile repository impl | Core-2 | 2 days | P1-003, P0-008 | profile_repository_impl.dart |
| P1-005 | Profile database table | Core-3 | 1 day | P0-008 | profiles table in Drift |
| P1-006 | Profile contract tests | Core-2 | 1 day | P1-004 | profile_contract_test.dart |
| P1-007 | UserAccount entity | Core-1 | 1 day | P1-001 | user_account.dart |
| P1-008 | DeviceRegistration entity | Core-2 | 1 day | P1-001 | device_registration.dart |
| P1-009 | ProfileAccess entity | Core-3 | 1 day | P1-002 | profile_access.dart |
| P1-010 | Auth repository interface | Core-1 | 1 day | P1-007 | auth_repository.dart |
| P1-011 | AppTheme setup | UI-1 | 2 days | P0-002 | app_theme.dart |
| P1-012 | AppColors (earth tones) | UI-1 | 1 day | P1-011 | app_colors.dart |
| P1-013 | ShadowButton widget | UI-2 | 2 days | P1-011 | shadow_button.dart |
| P1-014 | ShadowTextField widget | UI-2 | 2 days | P1-011 | shadow_text_field.dart |
| P1-015 | ShadowCard widget | UI-3 | 1 day | P1-011 | shadow_card.dart |
| P1-016 | ShadowImage widget | UI-3 | 1 day | P1-011 | shadow_image.dart |
| P1-017 | ShadowDialog widget | UI-4 | 2 days | P1-011 | shadow_dialog.dart |
| P1-018 | ShadowStatus widget | UI-4 | 1 day | P1-011 | shadow_status.dart |

#### Week 5-6: Health Entities

| ID | Task | Assignee | Duration | Dependencies | Deliverable |
|----|------|----------|----------|--------------|-------------|
| P1-019 | Condition entity | Core-1 | 2 days | P1-002 | condition.dart |
| P1-020 | Condition repository | Core-1 | 2 days | P1-019 | condition_repository.dart |
| P1-021 | Supplement entity | Core-2 | 2 days | P1-002 | supplement.dart |
| P1-022 | Supplement repository | Core-2 | 2 days | P1-021 | supplement_repository.dart |
| P1-023 | FoodItem entity | Core-3 | 2 days | P1-002 | food_item.dart |
| P1-024 | FoodLog entity | Core-3 | 1 day | P1-023 | food_log.dart |
| P1-025 | Activity entity | Core-1 | 1 day | P1-002 | activity.dart |
| P1-026 | SleepEntry entity | Core-2 | 1 day | P1-002 | sleep_entry.dart |
| P1-027 | FluidsEntry entity | Core-3 | 2 days | P1-002 | fluids_entry.dart |
| P1-028 | PhotoArea entity | Core-1 | 1 day | P1-002 | photo_area.dart |
| P1-029 | JournalEntry entity | Core-2 | 1 day | P1-002 | journal_entry.dart |
| P1-030 | NotificationSchedule entity | Core-3 | 2 days | P1-002 | notification_schedule.dart |
| P1-031 | All entity contract tests | Core-1,2,3 | 3 days | P1-019-030 | *_contract_test.dart |
| P1-032 | ShadowPicker widget | UI-1 | 3 days | P1-013 | shadow_picker.dart |
| P1-033 | ShadowChart widget | UI-2 | 3 days | P1-011 | shadow_chart.dart |
| P1-034 | ShadowInput widget | UI-3 | 2 days | P1-014 | shadow_input.dart |
| P1-035 | ShadowBadge widget | UI-4 | 1 day | P1-011 | shadow_badge.dart |
| P1-036 | Widget accessibility audit | UI-1 | 2 days | P1-032-035 | Audit report |

**Milestone P1:** All entities defined, all repositories interfaced, widget library complete

---

### 2.3 Phase 2: Core Features (Weeks 7-12)

**Owners:** All feature teams join

#### Week 7-8: Team Onboarding + First Features

| ID | Task | Team | Duration | Dependencies | Deliverable |
|----|------|------|----------|--------------|-------------|
| P2-001 | Team Conditions onboarding | Conditions | 3 days | P1 complete | Team productive |
| P2-002 | Team Supplements onboarding | Supplements | 3 days | P1 complete | Team productive |
| P2-003 | Condition use cases | Conditions | 3 days | P2-001 | GetConditions, CreateCondition |
| P2-004 | Condition provider | Conditions | 2 days | P2-003 | ConditionNotifier |
| P2-005 | Conditions tab screen | Conditions | 3 days | P2-004 | conditions_tab.dart |
| P2-006 | Add condition screen | Conditions | 3 days | P2-004 | add_condition_screen.dart |
| P2-007 | Supplement use cases | Supplements | 3 days | P2-002 | GetSupplements, CreateSupplement |
| P2-008 | Supplement provider | Supplements | 2 days | P2-007 | SupplementNotifier |
| P2-009 | Supplements tab screen | Supplements | 3 days | P2-008 | supplements_tab.dart |
| P2-010 | Add supplement screen | Supplements | 3 days | P2-008 | add_supplement_screen.dart |
| P2-011 | Home screen shell | UI | 2 days | P1-011 | home_screen.dart |
| P2-012 | Tab navigation | UI | 2 days | P2-011 | Bottom nav implementation |

#### Week 9-10: Nutrition + Wellness Teams

| ID | Task | Team | Duration | Dependencies | Deliverable |
|----|------|------|----------|--------------|-------------|
| P2-013 | Team Nutrition onboarding | Nutrition | 3 days | P1 complete | Team productive |
| P2-014 | Team Wellness onboarding | Wellness | 3 days | P1 complete | Team productive |
| P2-015 | Food use cases | Nutrition | 3 days | P2-013 | GetFoodItems, LogMeal |
| P2-016 | Food provider | Nutrition | 2 days | P2-015 | FoodNotifier |
| P2-017 | Food tab screen | Nutrition | 3 days | P2-016 | food_tab.dart |
| P2-018 | Log food screen | Nutrition | 3 days | P2-016 | log_food_screen.dart |
| P2-019 | Diet type selector | Nutrition | 2 days | P1-032 | diet_type_selector.dart |
| P2-020 | Sleep use cases | Wellness | 3 days | P2-014 | LogSleep, GetSleepEntries |
| P2-021 | Sleep provider | Wellness | 2 days | P2-020 | SleepNotifier |
| P2-022 | Sleep tab screen | Wellness | 3 days | P2-021 | sleep_tab.dart |
| P2-023 | Add sleep screen | Wellness | 3 days | P2-021 | add_sleep_screen.dart |
| P2-024 | Fluids use cases | Wellness | 3 days | P2-014 | LogFluids, GetFluidsEntries |
| P2-025 | Fluids provider | Wellness | 2 days | P2-024 | FluidsNotifier |
| P2-026 | Fluids tab screen | Wellness | 3 days | P2-025 | fluids_tab.dart |
| P2-027 | Menstruation picker | Wellness | 2 days | P1-032 | flow_intensity_picker.dart |
| P2-028 | BBT input widget | Wellness | 2 days | P1-034 | bbt_input_widget.dart |
| P2-029 | BBT chart | Wellness | 3 days | P1-033 | bbt_chart.dart |

#### Week 11-12: Sync + Platform Teams

| ID | Task | Team | Duration | Dependencies | Deliverable |
|----|------|------|----------|--------------|-------------|
| P2-030 | Team Sync onboarding | Sync | 3 days | P1 complete | Team productive |
| P2-031 | Team Platform onboarding | Platform | 3 days | P1 complete | Team productive |
| P2-032 | OAuth service | Sync | 4 days | P2-030 | oauth_service.dart |
| P2-033 | Google Drive provider | Sync | 5 days | P2-032 | google_drive_provider.dart |
| P2-034 | Sync service | Sync | 5 days | P2-033 | sync_service.dart |
| P2-035 | Conflict resolver | Sync | 3 days | P2-034 | conflict_resolver.dart |
| P2-036 | Sync provider | Sync | 2 days | P2-034 | SyncNotifier |
| P2-037 | Sync settings screen | Sync | 3 days | P2-036 | sync_settings_screen.dart |
| P2-038 | Notification service | Platform | 4 days | P2-031 | notification_service.dart |
| P2-039 | Notification use cases | Platform | 3 days | P2-038 | Schedule CRUD |
| P2-040 | Notification provider | Platform | 2 days | P2-039 | NotificationNotifier |
| P2-041 | Notification settings screen | Platform | 3 days | P2-040 | notification_settings_screen.dart |
| P2-042 | Deep link handler | Platform | 3 days | P2-038 | deep_link_handler.dart |
| P2-043 | Time picker widget | Platform | 2 days | P1-032 | notification_time_picker.dart |
| P2-044 | Weekday selector widget | Platform | 2 days | P1-032 | weekday_selector.dart |

**Milestone P2:** All core features functional, all tabs working, sync operational

---

### 2.4 Phase 3: Enhanced Features (Weeks 13-18)

| ID | Task | Team | Duration | Dependencies | Deliverable |
|----|------|------|----------|--------------|-------------|
| P3-001 | Condition logging flow | Conditions | 5 days | P2-006 | Full CRUD + photos |
| P3-002 | Flare-up reporting | Conditions | 4 days | P3-001 | Report flareup screen |
| P3-003 | Condition history view | Conditions | 3 days | P3-001 | History with charts |
| P3-004 | Intake logging flow | Supplements | 5 days | P2-010 | Full CRUD + scheduling |
| P3-005 | Intake history | Supplements | 3 days | P3-004 | Compliance tracking |
| P3-006 | Food library management | Nutrition | 4 days | P2-018 | Library CRUD |
| P3-007 | Composed dishes | Nutrition | 4 days | P3-006 | Recipe creation |
| P3-008 | Diet type in profile | Nutrition | 3 days | P2-019 | Profile + food integration |
| P3-009 | Activity tracking | Wellness | 5 days | P2-014 | Full activity flow |
| P3-010 | Photo documentation | Wellness | 5 days | P1-028 | Photo areas + capture |
| P3-011 | Journal entries | Wellness | 4 days | P1-029 | Journal CRUD |
| P3-012 | Multi-device sync | Sync | 5 days | P2-037 | QR pairing |
| P3-013 | Offline queue | Sync | 4 days | P2-034 | Offline-first |
| P3-014 | File sync (photos) | Sync | 5 days | P3-012 | Photo upload/download |
| P3-015 | Supplement reminders | Platform | 4 days | P2-041 | Per-supplement notifications |
| P3-016 | All notification types | Platform | 5 days | P3-015 | Food, fluids, sleep |
| P3-017 | Report generation | Core | 5 days | P3-001-016 | PDF export |
| P3-018 | Profile management | Core | 4 days | P1-004 | Multi-profile UI |

**Milestone P3:** All features complete, notifications working, multi-device sync

---

### 2.5 Phase 4: Integration & Polish (Weeks 19-22)

| ID | Task | Team | Duration | Dependencies | Deliverable |
|----|------|------|----------|--------------|-------------|
| P4-001 | Integration testing | Quality | 10 days | P3 complete | Integration test suite |
| P4-002 | Performance optimization | Core | 5 days | P3 complete | Meet perf targets |
| P4-003 | Accessibility audit | UI | 5 days | P3 complete | WCAG compliance |
| P4-004 | Security audit | Core | 5 days | P3 complete | Security sign-off |
| P4-005 | Localization complete | All | 5 days | P3 complete | All languages |
| P4-006 | Bug bash | All | 3 days | P4-001 | Bug fixes |
| P4-007 | Beta TestFlight build | Quality | 2 days | P4-006 | Beta available |
| P4-008 | Beta testing | All | 10 days | P4-007 | Beta feedback |
| P4-009 | Beta bug fixes | All | 5 days | P4-008 | Stable beta |

**Milestone P4:** Beta complete, all quality gates passed

---

### 2.6 Phase 5: Launch (Weeks 23-26)

| ID | Task | Team | Duration | Dependencies | Deliverable |
|----|------|------|----------|--------------|-------------|
| P5-001 | App Store assets | UI | 3 days | P4-009 | Screenshots, descriptions |
| P5-002 | Privacy policy | Core | 2 days | P4-004 | Published policy |
| P5-003 | Release candidate | Quality | 2 days | P4-009 | RC build |
| P5-004 | App Store submission | Quality | 3 days | P5-001-003 | Submitted |
| P5-005 | Feature flag rollout plan | All leads | 2 days | P5-003 | Rollout schedule |
| P5-006 | Monitoring setup | Core | 3 days | P5-003 | Dashboards live |
| P5-007 | On-call training | All | 2 days | P5-006 | Teams ready |
| P5-008 | Launch day | All | 1 day | P5-004 approved | App live |
| P5-009 | Post-launch monitoring | All | 5 days | P5-008 | Stable launch |

**Milestone P5:** App launched, monitoring active, on-call operational

---

## 3. Dependency Matrix

### 3.1 Team Dependencies

```
             Core  UI  Quality  Conditions  Supplements  Nutrition  Wellness  Sync  Platform
Core          -    →      →         →            →           →          →       →       →
UI            ←    -      ↔         →            →           →          →       →       →
Quality       ←    ↔      -         ↔            ↔           ↔          ↔       ↔       ↔
Conditions    ←    ←      ↔         -            ↔           ↔          ↔       →       →
Supplements   ←    ←      ↔         ↔            -           ↔          ↔       →       →
Nutrition     ←    ←      ↔         ↔            ↔           -          ↔       →       →
Wellness      ←    ←      ↔         ↔            ↔           ↔          -       →       →
Sync          ←    ←      ↔         ←            ←           ←          ←       -       ↔
Platform      ←    ←      ↔         ←            ←           ←          ←       ↔       -

Legend: → provides to, ← receives from, ↔ bidirectional
```

### 3.2 Critical Path

```
P0-001 → P0-004 → P0-008 → P1-002 → P1-004 → P2-003 → P2-034 → P3-012 → P4-007 → P5-008
  │                  │         │         │         │         │
  └─ Foundation      └─ DB     └─ Entity └─ Feature└─ Sync   └─ Multi-device
```

### 3.3 Blocking Dependencies

| Blocked Task | Blocking Task | Risk | Mitigation |
|--------------|---------------|------|------------|
| All features | P0-004 (Freezed setup) | High | Core starts Day 1 |
| All DB access | P0-008 (Drift setup) | High | Core priority |
| All features | P1-002 (Profile entity) | High | Core completes Week 3 |
| Sync | P2-032 (OAuth) | Medium | Start early Week 11 |
| Notifications | P2-038 (Service) | Medium | Platform starts Week 11 |
| Launch | P4-004 (Security audit) | High | Schedule external audit early |

---

## 4. Coordination Protocols

### 4.1 Daily Sync Points

| Time | Meeting | Attendees | Purpose |
|------|---------|-----------|---------|
| 9:00 AM | Team Standups | Each team | Daily progress |
| 9:30 AM | Cross-team Sync | Team leads | Dependencies, blockers |

### 4.2 Handoff Protocol

When Team A completes work that Team B depends on:

```
1. Team A completes task
   └── Verifies contract tests pass
   └── Merges to develop

2. Team A notifies Team B
   └── Slack: "@team-b [DEP-XXX] Profile entity ready for use"
   └── Update dependencies.yml

3. Team B acknowledges
   └── Pulls latest develop
   └── Verifies integration
   └── Responds: "Confirmed, integrating"

4. If issues found
   └── Team B creates bug ticket
   └── Tags Team A for resolution
   └── Blocks on resolution before proceeding
```

### 4.3 Interface Freeze Points

| Date | Interface | Owner | Consumers |
|------|-----------|-------|-----------|
| End of Week 4 | All entity interfaces | Core | All feature teams |
| End of Week 6 | Widget library API | UI | All feature teams |
| End of Week 10 | Sync service API | Sync | All feature teams |
| End of Week 12 | Notification service API | Platform | All feature teams |

After freeze: Changes require ADR + all consumer approval

---

## 5. Risk Mitigation

### 5.1 Schedule Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Core team delayed | Medium | Critical | Buffer in Phase 0, can extend |
| Team onboarding slow | Medium | High | Structured program, mentors ready |
| Integration issues | High | High | Continuous integration, contract tests |
| OAuth complexity | Medium | Medium | Start early, have fallback |
| App Store rejection | Low | High | Follow guidelines, pre-review |

### 5.2 Contingency Plans

| Scenario | Response |
|----------|----------|
| Core delayed 1 week | Feature teams start with mock repositories |
| Entity interface changes | ADR + emergency sync meeting |
| Critical bug in beta | Hotfix track, delay launch if needed |
| Security audit fails | Block launch, fix findings, re-audit |

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
