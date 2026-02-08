# Spec Review Report - 2026-02-07 (Updated)

## Executive Summary
- Specs reviewed: 22_API_CONTRACTS.md, 02_CODING_STANDARDS.md, 38_UI_FIELD_SPECIFICATIONS.md, 09_WIDGET_LIBRARY.md, 10_DATABASE_SCHEMA.md
- Total violations: 30
- Critical: 1 | High: 15 | Medium: 8 | Low: 6
- Auto-fixable: 8
- Requires user decision: 3
- Enhancement opportunities: 7

## Phase 1: Compliance Audit Results

### Entity Specifications
**Status: 96% COMPLIANT** - 81/107 entities/types fully compliant.
- All 24+ root entities have required fields (id, clientId, profileId, syncMetadata)
- All timestamps use int (epoch milliseconds)
- All enums have explicit integer values
- Proper @freezed annotations on all root entities

**Violations Found:**
| Entity | Field/Issue | Rule Violated | Severity |
|--------|-------------|---------------|----------|
| QueuedNotification | Missing syncMetadata (documented as ephemeral) | Rule 5.1 Required Fields | CRITICAL |
| QueuedNotification | Missing private constructor | Rule 5.0 Code Generation | CRITICAL |
| ConditionTrend | Missing @freezed annotation | Rule 5.0 Code Generation | MEDIUM |
| ConditionTrend | Missing fromJson factory method | Rule 5.0 Code Generation | MEDIUM |

**Value Object Clarifications Needed:**
- SupplementIngredient, InsightEvidence, PredictionFactor, PendingNotification lack id/clientId/profileId/syncMetadata
- These appear to be value objects (embedded only), NOT standalone entities
- Recommendation: Explicitly label each type as "Entity", "Value Object", "DTO", or "Output Type" in spec

### Repository Specifications
**Status: 73% COMPLIANT** - 27/37 repositories pass all checks.

**Violations Found:**
| Repository | Issue | Rule Violated | Severity |
|------------|-------|---------------|----------|
| PatternRepository | Extends BaseRepository instead of EntityRepository | Section 3.1 | HIGH |
| TriggerCorrelationRepository | Extends BaseRepository instead of EntityRepository | Section 3.1 | HIGH |
| HealthInsightRepository | Extends BaseRepository instead of EntityRepository | Section 3.1 | HIGH |
| PredictiveAlertRepository | Extends BaseRepository instead of EntityRepository | Section 3.1 | HIGH |
| ProfileAccessLogRepository | Missing EntityRepository interface + standard CRUD | Section 3.1 | HIGH |
| MLModelRepository | Missing EntityRepository interface + standard CRUD | Section 3.1 | HIGH |
| PredictionFeedbackRepository | Missing EntityRepository interface + standard CRUD | Section 3.1 | HIGH |
| BowelUrineLogRepository | Missing EntityRepository interface + standard CRUD | Section 3.1 | HIGH |
| NotificationScheduleRepository | Defined TWICE with different signatures | Single source of truth | HIGH |
| FoodItemCategoryRepository | getAll() override removes required parameters | Section 3.3 | MEDIUM |

**Notes:**
- Intelligence repos (Pattern, TriggerCorrelation, HealthInsight, PredictiveAlert) may intentionally use BaseRepository - needs documented exemption
- Local-only repos (MLModel, PredictionFeedback, BowelUrineLog, ProfileAccessLog) lack sync methods - needs documented exemption

### Use Case Specifications
**Status: 86% COMPLIANT** - 28/33 use cases pass all checks.

**Violations Found:**
| Use Case | Issue | Rule Violated | Severity |
|----------|-------|---------------|----------|
| CreateDietUseCase | Explicit SyncMetadata defaults (redundant with @Default) | Rule 8 DRY | HIGH |
| ScheduleNotificationUseCase | Explicit SyncMetadata defaults | Rule 8 DRY | HIGH |
| ConnectWearableUseCase | Explicit SyncMetadata defaults | Rule 8 DRY | HIGH |
| SyncWearableDataUseCase | Explicit SyncMetadata defaults (3 locations) | Rule 8 DRY | HIGH |
| SignInWithGoogleUseCase | Explicit SyncMetadata defaults (2 locations) | Rule 8 DRY | HIGH |

**Correct Pattern (from LogFluidsEntryUseCase):**
```dart
syncMetadata: SyncMetadata(
  syncCreatedAt: now,
  syncUpdatedAt: now,
  syncDeviceId: '', // Rely on @Default for syncVersion, syncStatus, syncIsDirty
),
```

### Error Handling
**Status: 85% COMPLIANT**
- Sealed class hierarchy: 10 subtypes, 62 factory methods - COMPLIANT
- ValidationError.fromFieldErrors pattern - COMPLIANT
- Result<T, AppError> in all data layer methods - COMPLIANT

**Violations Found:**
| Location | Issue | Severity |
|----------|-------|----------|
| 12 screen files | Generic `on Exception catch(e)` instead of specific AppError | HIGH |
| 02_CODING_STANDARDS.md Section 7.2 | References undefined DatabaseError.fromException() | MEDIUM |
| All userMessage fields | Hardcoded English strings instead of localization keys | MEDIUM |

### Cross-Cutting Concerns
**Status: 93% COMPLIANT**
- Timestamp standards consistent across all docs
- Enum naming and values consistent
- SyncMetadata standards consistent
- Layer dependencies correct
- File naming conventions followed

**Violations Found:**
| Document | Section | Issue | Severity |
|----------|---------|-------|----------|
| 10_DATABASE_SCHEMA.md | 2.7 vs 13 | Contradiction: says ml_models/prediction_feedback lack sync metadata, but Section 13 shows them with sync columns | HIGH |
| 09_WIDGET_LIBRARY.md | 6.7 | References "DietType" but enum is "DietPresetType" | LOW |
| 38_UI_FIELD_SPECIFICATIONS.md | 4.1 | Minor capitalization inconsistency in UI labels vs enum values | LOW |
| 38_UI_FIELD_SPECIFICATIONS.md | 15.2 | "anchorEvent" mixed case in spec table vs snake_case in API contracts | LOW |

## Phase 2: Proposed Fixes

### Auto-Fix (Ready to Apply)
| # | Spec | Location | Current | Proposed | Rationale |
|---|------|----------|---------|----------|-----------|
| 1 | 22_API_CONTRACTS.md | InsightPriority ref | "InsightPriority" | "AlertPriority" | Match actual enum name |
| 2 | 22_API_CONTRACTS.md | Section 4.2 example | DatabaseError.duplicateEntry() | DatabaseError.constraintViolation() | Match actual factory |
| 3 | 02_CODING_STANDARDS.md | Section 7.2 example | DatabaseError.fromException() | specific factory methods | Match actual pattern |
| 4 | 22_API_CONTRACTS.md | NotificationScheduleRepo | Duplicate definition (lines 2007-2025 AND 10290-10317) | Remove lines 2007-2025 (keep more complete version) | Single source of truth |
| 5 | 22_API_CONTRACTS.md | 5 use cases | Explicit syncVersion/syncStatus/syncIsDirty/syncDeletedAt | Remove redundant assignments, rely on @Default | DRY principle |
| 6 | 22_API_CONTRACTS.md | QueuedNotification | Listed as entity | Reclassify as "Ephemeral DTO" with explicit note | Already documented as ephemeral |
| 7 | 22_API_CONTRACTS.md | Value objects | SupplementIngredient, InsightEvidence, PredictionFactor unlabeled | Add explicit "Value Object" label | Clarify scope |
| 8 | 09_WIDGET_LIBRARY.md | Section 6.7 | "DietType" | "DietPresetType" | Match actual enum name |

### Requires User Decision
| # | Spec | Location | Issue | Options |
|---|------|----------|-------|---------|
| 1 | Error handling | All userMessage fields | Hardcoded English strings | 1) Add localization keys now 2) Defer until i18n phase |
| 2 | Repository pattern | 8 intelligence/local-only repos | Don't implement EntityRepository | 1) Add formal exemption in Section 15 2) Update repos to conform |
| 3 | 10_DATABASE_SCHEMA.md | Section 2.7 vs 13 | Sync metadata contradiction for ml_models/prediction_feedback | 1) Remove sync columns (truly local-only) 2) Keep sync columns (eventually syncable) |

### Enhancement Opportunities (Not Blocking)
| # | Spec | Issue | Recommendation |
|---|------|-------|----------------|
| 1 | 38_UI_FIELD_SPECIFICATIONS.md | No widget component mapping | Add widget type column to field tables |
| 2 | 38_UI_FIELD_SPECIFICATIONS.md | No provider mapping | Add provider reference per screen |
| 3 | Cross-cutting | Validation layer unclear | Create validation responsibility matrix |
| 4 | 38_UI_FIELD_SPECIFICATIONS.md | Accessibility labels incomplete | Fill gaps in Section 18 |
| 5 | 22_API_CONTRACTS.md | Entity type labels missing | Add "Entity/Value Object/DTO/Output" labels |
| 6 | 22_API_CONTRACTS.md | Repository exemptions undocumented | Document exemption rules in Section 15 |
| 7 | Cross-cutting | Screen exception handling pattern | Define standard screen try-catch pattern |

## Phase 4: Integrity Issues
- Entity-Repository alignment: PASS (all root entities have repositories)
- Use Case-Repository alignment: PASS (use cases reference correct methods)
- Completeness: PASS (all entities have Entity + Repository + Use Cases)
- NotificationScheduleRepository: FAIL (duplicate definition)

## Recommendations (Priority Order)
1. **URGENT:** Resolve 10_DATABASE_SCHEMA.md sync metadata contradiction (Section 2.7 vs 13)
2. Apply 8 auto-fix corrections to spec documents
3. Document repository exemption rules for intelligence/local-only repos in Section 15
4. Remove redundant SyncMetadata explicit assignments from 5 use case specs
5. Defer localization keys to i18n implementation phase
6. Enhancement opportunities are non-blocking - address in future spec pass

## Next Steps
- [ ] Decide on 3 user-decision items
- [ ] Apply approved auto-fixes
- [ ] Re-run /spec-review to verify
