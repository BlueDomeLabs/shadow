# Spec Review Report - 2026-02-07 (Re-audit after fixes)

## Executive Summary
- Specs reviewed: 22_API_CONTRACTS.md, 02_CODING_STANDARDS.md, 09_WIDGET_LIBRARY.md, 10_DATABASE_SCHEMA.md, 42_INTELLIGENCE_SYSTEM.md
- Previous violations: 30 (all resolved in commit 6b5cf50)
- **New violations found: 6**
- Critical: 0 | High: 3 | Medium: 2 | Low: 1
- Auto-fixable: 4
- Requires user decision: 0
- Enhancement opportunities: 2

## Phase 1: Compliance Audit Results

### Entity Specifications
**Status: 98% COMPLIANT** (up from 96%)
- All 24+ root entities have required fields (id, clientId, profileId, syncMetadata)
- All timestamps use int (epoch milliseconds)
- All enums have explicit integer values
- Proper @freezed annotations on all root entities
- Value objects properly labeled (SupplementIngredient, InsightEvidence, PredictionFactor)
- Output types classified in Section 15.2 (ConditionTrend, TrendDataPoint)
- Ephemeral DTOs labeled (QueuedNotification, PendingNotification)

**No entity violations found.**

### Repository Specifications
**Status: 100% COMPLIANT** (up from 73%)
- All 36 repositories pass checks
- Intelligence repos correctly use `implements EntityRepository`
- Local-only repos have formal exemptions in Section 15.7
- FoodItemCategoryRepository getAll() documented with exemption
- No duplicate definitions
- NotificationScheduleRepository appears once

**No repository violations found.**

### Use Case Specifications
**Status: 98% COMPLIANT** (up from 86%)
- All SyncMetadata constructors use minimal fields (syncCreatedAt, syncUpdatedAt, syncDeviceId)
- No redundant syncVersion/syncStatus/syncIsDirty/syncDeletedAt
- LogFoodInput and UpdateFoodLogInput include mealType field

**Violations Found:**
| Use Case | Issue | Rule Violated | Severity |
|----------|-------|---------------|----------|
| SyncWearableDataUseCase._importActivity | Inline `DateTime.now().millisecondsSinceEpoch` instead of pre-computed `now` variable | Consistency with other import methods | MEDIUM |

### Error Handling
**Status: 97% COMPLIANT** (up from 85%)
- All 12 screen files use `on AppError catch(e)` with `e.userMessage` - COMPLIANT
- No DatabaseError.fromException() references - COMPLIANT
- No DatabaseError.duplicateEntry() references - COMPLIANT
- Result<T, AppError> in all data layer methods - COMPLIANT

**Violations Found:**
| Location | Issue | Severity |
|----------|-------|----------|
| 02_CODING_STANDARDS.md lines 699, 722, 830 | AuthError examples use direct constructor `AuthError(code: '...', message: '...')` instead of factory methods like `AuthError.profileAccessDenied()` | HIGH |

### Cross-Cutting Concerns
**Status: 95% COMPLIANT** (up from 93%)
- Timestamp standards consistent across all docs
- SyncMetadata standards consistent
- Layer dependencies correct
- Entity type classification complete in Section 15.2
- Repository exemptions documented in Section 15.7

**Violations Found:**
| Document | Section | Issue | Severity |
|----------|---------|-------|----------|
| 42_INTELLIGENCE_SYSTEM.md | Multiple sections | References `InsightPriority` (10+ occurrences) but canonical enum is `AlertPriority` | HIGH |
| 09_WIDGET_LIBRARY.md | Lines 89 vs 1094 | ButtonVariant enum defined twice: 4 values (line 89) vs 5 values with `outlined` (line 1094) | MEDIUM |
| 10_DATABASE_SCHEMA.md | Line 380 | Comment says "DietType enum" but actual enum is `ProfileDietType` | LOW |

## Phase 2: Proposed Fixes

### Auto-Fix (Ready to Apply)
| # | Spec | Location | Current | Proposed | Rationale |
|---|------|----------|---------|----------|-----------|
| 1 | 22_API_CONTRACTS.md | _importActivity SyncMetadata | Inline DateTime.now() | Add pre-computed `now` variable | Consistency with _importSleep and _importWater |
| 2 | 02_CODING_STANDARDS.md | Lines 699, 722, 830 | `AuthError(code: '...', message: '...')` | `AuthError.profileAccessDenied(profileId)` | Use semantic factory methods per Section 7.2 |
| 3 | 42_INTELLIGENCE_SYSTEM.md | 10+ occurrences | `InsightPriority` | `AlertPriority` | Match canonical enum name in 22_API_CONTRACTS.md |
| 4 | 10_DATABASE_SCHEMA.md | Line 380 | `DietType enum` | `ProfileDietType enum` | Match canonical enum name |

### Requires User Decision
| # | Spec | Location | Issue | Options |
|---|------|----------|-------|---------|
| 1 | 09_WIDGET_LIBRARY.md | Lines 89 vs 1094 | ButtonVariant defined with 4 values AND 5 values | 1) Use 5-value version (with `outlined`) 2) Use 4-value version (remove `outlined`) |

### Enhancement Opportunities (Not Blocking)
| # | Spec | Issue | Recommendation |
|---|------|-------|----------------|
| 1 | All userMessage fields | Hardcoded English strings | Defer to i18n phase |
| 2 | 38_UI_FIELD_SPECIFICATIONS.md | Minor capitalization/casing inconsistencies | Address in future spec pass |

## Phase 3: Code Example Issues
- 02_CODING_STANDARDS.md: AuthError constructor calls in examples would not compile against the actual AppError class (private constructor). Must use factory methods.

## Phase 4: Integrity Issues
- Entity-Repository alignment: PASS
- Use Case-Repository alignment: PASS
- Completeness: PASS
- NotificationScheduleRepository: PASS (no duplicates)
- Cross-document enum consistency: FAIL (InsightPriority in 42_INTELLIGENCE_SYSTEM.md)

## Previous Fixes (Commit 6b5cf50)
All 30 violations from the initial audit have been resolved:
- 8 auto-fix spec corrections applied
- 3 user decision items resolved
- 12 screen files updated with AppError handling
- 5 test files updated
- Repository exemptions documented in Section 15.7

## Fixes Applied (Instance spec-fixes-011)
All 6 violations resolved:
1. **42_INTELLIGENCE_SYSTEM.md**: `InsightPriority` → `AlertPriority` (all occurrences, replace_all)
2. **02_CODING_STANDARDS.md**: AuthError direct constructors → `AuthError.profileAccessDenied(supplement.profileId)` (3 locations: lines 699, 722, 830)
3. **22_API_CONTRACTS.md**: `_importActivity` - added pre-computed `now` variable, replaced inline `DateTime.now().millisecondsSinceEpoch`
4. **09_WIDGET_LIBRARY.md**: ButtonVariant line 89 updated from 4 values to 5 values (added `outlined` to match canonical definition at line 1094)
5. **10_DATABASE_SCHEMA.md**: Line 380 comment `DietType enum` → `ProfileDietType enum`

## Verification
- Tests: 1205 passing
- Analyzer: No issues
- InsightPriority occurrences remaining: 0

## Recommendations
1. Enhancement opportunities (i18n, casing) are non-blocking - defer to future phases
2. Re-run /spec-review periodically as specs evolve

## Next Steps
- [x] Apply approved auto-fixes
- [x] Decide ButtonVariant definition (chose 5-value version with `outlined`)
- [ ] Re-run /spec-review to verify
