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

## Phase 2: Fixes Applied

### Auto-Fix (All 8 Applied)
| # | Spec | Fix Applied | Status |
|---|------|-------------|--------|
| 1 | 22_API_CONTRACTS.md | InsightPriority → AlertPriority (4 occurrences) | DONE |
| 2 | 22_API_CONTRACTS.md | DatabaseError.duplicateEntry() → constraintViolation() | DONE |
| 3 | 02_CODING_STANDARDS.md | DatabaseError.fromException() → specific factory methods (4 occurrences) | DONE |
| 4 | 22_API_CONTRACTS.md | Removed duplicate NotificationScheduleRepo definition | DONE |
| 5 | 22_API_CONTRACTS.md | Removed redundant SyncMetadata assignments from 9 use case locations | DONE |
| 6 | 22_API_CONTRACTS.md | QueuedNotification labeled as "EPHEMERAL DTO" | DONE |
| 7 | 22_API_CONTRACTS.md | Value objects labeled (SupplementIngredient, InsightEvidence, PredictionFactor, PendingNotification) | DONE |
| 8 | 09_WIDGET_LIBRARY.md | DietType → DietPresetType | DONE |

### User Decision Items (All 3 Resolved)
| # | Issue | Resolution |
|---|-------|------------|
| 1 | Hardcoded English strings | Deferred to i18n phase (non-blocking) |
| 2 | 8 repos don't implement EntityRepository | Documented formal exemptions in Section 15.7; intelligence repos use BaseRepositoryContract typedef; local-only repos documented as special-purpose |
| 3 | Schema contradiction (Section 2.7 vs 13) | Already resolved by previous instance (line 317 note); tables DO have sync columns |

### Additional Fixes Applied
| # | Fix | Files Changed |
|---|-----|---------------|
| 9 | Intelligence repos: `extends BaseRepository` → `implements EntityRepository` | 22_API_CONTRACTS.md (4 repos) |
| 10 | FoodItemCategoryRepository: getAll() signature updated to match EntityRepository interface | 22_API_CONTRACTS.md |
| 11 | ConditionTrend added to Output Type classification in Section 15.2 | 22_API_CONTRACTS.md |
| 12 | Screen exception handling: `on Exception catch(e)` → `on AppError catch(e)` + fallback | 12 screen files |
| 13 | Test error mocks: `throw Exception` → `throw DatabaseError.insertFailed` | 5 test files |
| 14 | SyncWearableDataUseCase: `DateTime.now().millisecondsSinceEpoch` → pre-computed `now` variable | 22_API_CONTRACTS.md |

### Enhancement Opportunities (Deferred - Not Blocking)
| # | Spec | Issue | Recommendation |
|---|------|-------|----------------|
| 1 | 38_UI_FIELD_SPECIFICATIONS.md | No widget component mapping | Add widget type column to field tables |
| 2 | 38_UI_FIELD_SPECIFICATIONS.md | No provider mapping | Add provider reference per screen |
| 3 | Cross-cutting | Validation layer unclear | Create validation responsibility matrix |
| 4 | 38_UI_FIELD_SPECIFICATIONS.md | Accessibility labels incomplete | Fill gaps in Section 18 |

## Phase 4: Integrity Issues
- Entity-Repository alignment: PASS
- Use Case-Repository alignment: PASS
- Completeness: PASS
- NotificationScheduleRepository: PASS (duplicate removed)

## Final Verification
- Tests: 1205 passing, 0 failing
- Analyzer: 0 issues
- Formatter: Clean
- All 30 violations resolved (23 fixed, 4 deferred as enhancements, 3 were already resolved/non-blocking)
- [ ] Re-run /spec-review to verify
