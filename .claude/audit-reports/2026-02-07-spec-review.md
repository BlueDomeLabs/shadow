# Spec Review Report - 2026-02-07 (Third audit - post all fixes)

## Executive Summary
- Specs reviewed: 22_API_CONTRACTS.md, 02_CODING_STANDARDS.md, 09_WIDGET_LIBRARY.md, 10_DATABASE_SCHEMA.md, 42_INTELLIGENCE_SYSTEM.md, 38_UI_FIELD_SPECIFICATIONS.md
- Previous violations: 36 (all resolved in commits 6b5cf50, e1b2473)
- **New violations found: 8**
- Critical: 1 | High: 6 | Medium: 1 | Low: 0
- Auto-fixable: 7
- Requires user decision: 1
- Enhancement opportunities: 2

## Phase 1: Compliance Audit Results

### Entity Specifications
**Status: 95% COMPLIANT**
- All 35+ root entities have required fields (id, clientId, profileId, syncMetadata)
- All timestamps use int (epoch milliseconds)
- Proper @freezed annotations on all root entities
- Value objects properly labeled in Section 15.2
- Output types classified in Section 15.2
- Ephemeral DTOs labeled

**Violations Found:**
| Entity | Field/Issue | Rule Violated | Severity |
|--------|-------------|---------------|----------|
| Activity (line ~11252) | Missing `const Activity._()` private constructor | Section 5.0: private constructor REQUIRED for computed properties | HIGH |
| ActivityLog (line ~11287) | Missing `const ActivityLog._()` private constructor | Section 5.0: private constructor REQUIRED for computed properties | HIGH |
| RecoveryAction enum (line ~64) | Missing explicit integer values for database storage | All enums must have explicit int values | HIGH |
| TrendGranularity enum (line ~4577) | Missing explicit integer values (daily, weekly, monthly) | All enums must have explicit int values | HIGH |
| CorrelationType enum (lines 9646 + 42_INTELLIGENCE_SYSTEM.md:581) | Missing explicit integer values (positive, negative, neutral, doseResponse) | All enums must have explicit int values | HIGH |
| PredictionType enum (lines 9720 + 42_INTELLIGENCE_SYSTEM.md:1117) | Missing explicit integer values (flareUp, menstrualStart, ovulation, triggerExposure, missedSupplement, poorSleep) | All enums must have explicit int values | HIGH |
| AccessLevel enum (line 10388) | Duplicate definition WITHOUT integer values; conflicts with canonical definition at line 1621 which HAS values | Enum consistency + explicit int values | CRITICAL |

### Repository Specifications
**Status: 100% COMPLIANT**
- All 34+ repositories pass all checks
- Intelligence repos correctly use `implements EntityRepository`
- Local-only repos have formal exemptions in Section 15.7
- FoodItemCategoryRepository getAll() documented with exemption
- No duplicate definitions
- NotificationScheduleRepository appears once

**No repository violations found.**

### Use Case Specifications
**Status: 100% COMPLIANT**
- All SyncMetadata constructors use minimal fields (syncCreatedAt, syncUpdatedAt, syncDeviceId)
- No redundant syncVersion/syncStatus/syncIsDirty/syncDeletedAt
- All DateTime.now() calls use pre-computed `now` variable
- Authorization checks come first in all use cases
- All input classes use @freezed annotation
- All use cases return Result<T, AppError>

**No use case violations found.**

**Ambiguity (non-blocking):**
- SyncMetadata constructors use `syncDeviceId: ''` with comment "Will be populated by repository". This is the established pattern per Section 3.4 (BaseRepository.prepareForCreate). Not a violation.

### Error Handling
**Status: 98% COMPLIANT**
- All 12 screen files use `on AppError catch(e)` with `e.userMessage` - COMPLIANT
- All AuthError examples use factory methods - COMPLIANT (fixed in e1b2473)
- No DatabaseError.fromException() references - COMPLIANT
- No DatabaseError.duplicateEntry() references - COMPLIANT
- Result<T, AppError> in all data layer methods - COMPLIANT
- Sealed class pattern correct with 10 subtypes and 62+ factory methods

**Violations Found:**
| Location | Issue | Severity |
|----------|-------|----------|
| 02_CODING_STANDARDS.md lines 158, 160-162 | References `NotFoundError` in repository error table, but NotFoundError is not defined in 22_API_CONTRACTS.md. Canonical approach is `DatabaseError.notFound()` factory method. | MEDIUM |

### Cross-Cutting Concerns
**Status: 100% COMPLIANT**
- Timestamp standards consistent across all docs (all int, no DateTime)
- SyncMetadata standards consistent
- Layer dependencies correct (presentation -> domain -> data)
- Entity type classification complete in Section 15.2
- Repository exemptions documented in Section 15.7
- Enum names consistent across documents (AlertPriority, ProfileDietType, ButtonVariant)
- ButtonVariant consistently 5 values in all locations
- Import ordering correct in all examples

**No cross-cutting violations found.**

## Phase 2: Proposed Fixes

### Auto-Fix (Ready to Apply)
| # | Spec | Location | Current | Proposed | Rationale |
|---|------|----------|---------|----------|-----------|
| 1 | 22_API_CONTRACTS.md | Activity entity (~line 11252) | No private constructor | Add `const Activity._();` | Match all other entities (Profile, Condition, IntakeLog, etc.) |
| 2 | 22_API_CONTRACTS.md | ActivityLog entity (~line 11287) | No private constructor | Add `const ActivityLog._();` | Match all other entities |
| 3 | 22_API_CONTRACTS.md | RecoveryAction enum (~line 64) | `none, retry, refreshToken, ...` | `none(0), retry(1), refreshToken(2), ...` with `final int value; const RecoveryAction(this.value);` | All enums require explicit int values |
| 4 | 22_API_CONTRACTS.md | TrendGranularity enum (~line 4577) | `daily, weekly, monthly` | `daily(0), weekly(1), monthly(2)` with value field | All enums require explicit int values |
| 5 | 22_API_CONTRACTS.md + 42_INTELLIGENCE_SYSTEM.md | CorrelationType enum | `positive, negative, neutral, doseResponse` | `positive(0), negative(1), neutral(2), doseResponse(3)` with value field | All enums require explicit int values |
| 6 | 22_API_CONTRACTS.md + 42_INTELLIGENCE_SYSTEM.md | PredictionType enum | `flareUp, menstrualStart, ...` | `flareUp(0), menstrualStart(1), ovulation(2), triggerExposure(3), missedSupplement(4), poorSleep(5)` with value field | All enums require explicit int values |
| 7 | 22_API_CONTRACTS.md | AccessLevel enum (line 10388) | Duplicate without int values | Remove duplicate; reference canonical definition at line 1621 | Single source of truth + explicit int values |

### Requires User Decision
| # | Spec | Location | Issue | Options |
|---|------|----------|-------|---------|
| 1 | 02_CODING_STANDARDS.md | Lines 158, 160-162 | Repository error table references `NotFoundError` which doesn't exist. Canonical is `DatabaseError.notFound()` | 1) Replace `NotFoundError` with `DatabaseError` in table 2) Define `NotFoundError` as a new AppError subtype |

### Enhancement Opportunities (Not Blocking)
| # | Spec | Issue | Recommendation |
|---|------|-------|----------------|
| 1 | All userMessage fields | Hardcoded English strings | Defer to i18n phase |
| 2 | 38_UI_FIELD_SPECIFICATIONS.md | Minor capitalization/casing inconsistencies | Address in future spec pass |

## Phase 3: Code Example Issues
- No compilation issues found in current code examples
- AuthError factory method usage now correct throughout

## Phase 4: Integrity Issues
- Entity-Repository alignment: PASS
- Use Case-Repository alignment: PASS
- Completeness: PASS
- NotificationScheduleRepository: PASS (no duplicates)
- Cross-document enum consistency: PASS (InsightPriority fixed, DietType fixed, ButtonVariant fixed)
- Enum integer values: FAIL (4 enums missing + 1 duplicate AccessLevel)

## Previous Fixes
### Commit 6b5cf50 (30 violations)
- 8 auto-fix spec corrections applied
- 3 user decision items resolved
- 12 screen files updated with AppError handling
- 5 test files updated
- Repository exemptions documented in Section 15.7

### Commit e1b2473 (6 violations)
- InsightPriority → AlertPriority in 42_INTELLIGENCE_SYSTEM.md
- AuthError factory methods in 02_CODING_STANDARDS.md (3 locations)
- _importActivity pre-computed `now` variable in 22_API_CONTRACTS.md
- ButtonVariant 5 values in 09_WIDGET_LIBRARY.md
- ProfileDietType comment in 10_DATABASE_SCHEMA.md

## Recommendations (Priority Order)
1. Apply 7 auto-fix corrections (private constructors, enum integer values, duplicate AccessLevel)
2. Decide on NotFoundError: replace with DatabaseError in coding standards table OR define as new type
3. Enhancement opportunities are non-blocking

## User Decisions Made
1. **NotFoundError** → Replace with `DatabaseError.notFound()` in 02_CODING_STANDARDS.md (decided Run 1)
2. **RateLimitError** → Replace with `NetworkError.rateLimited()` factory method (decided Run 4, verified COMPLIANT with Section 7.1-7.3)
3. **DuplicateError** → Replace with `ValidationError.duplicate()` which already exists (decided Run 4, verified COMPLIANT)
4. **StateError** → Replace with `BusinessError.invalidState()` factory method (decided Run 4, verified COMPLIANT, avoids Dart naming conflict)

## Next Steps
- [ ] Apply all fixes (37 violations from Run 4 consolidated list)
- [ ] Add 2 new factory methods: NetworkError.rateLimited(), BusinessError.invalidState()
- [ ] Re-run /spec-review to verify
