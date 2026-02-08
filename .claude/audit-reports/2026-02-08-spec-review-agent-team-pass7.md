# Spec Review Report - 2026-02-08 (Agent Team Pass 7)

## Executive Summary
- **Method:** 6 parallel agents, each reviewing a different aspect
- **Document:** 22_API_CONTRACTS.md (13,675 lines)
- **Baseline:** 78 issues from passes 1-6 (fix plan at `.claude/plans/spec-review-fix-plan-post-phase2.md`)
- **New issues found:** ~85 unique (after cross-agent deduplication)
- **Combined total:** ~163 known issues across all 7 passes

### Severity Breakdown (deduplicated)

| Severity | Count |
|----------|-------|
| CRITICAL | ~28 |
| HIGH | ~34 |
| MEDIUM | ~18 |
| LOW | ~3 |

---

## Agent Team Composition

| Agent | Focus Area | Issues Found | Key Findings |
|-------|-----------|-------------|--------------|
| behavioral-review | Sections 11-15, DB alignment tables | 15 new | Section 13 mapping tables systematically wrong |
| type-safety | Compilability of dart code blocks | 34 new | Undefined types, wrong signatures, missing factories |
| standards-compliance | 02_CODING_STANDARDS.md rules | 10 new | syncMetadata contradictions, DateTime in domain layer |
| naming-consistency | Field/method name consistency | 18 new | Intelligence subsystem field name divergence |
| completeness | Missing/orphaned definitions | 11 new | Model\<T\> interface, wearable DTOs, 30 orphaned inputs |
| cross-references | Internal cross-reference integrity | 12 new | Provider→UseCase breaks, enum value mismatches |

---

## Cross-Agent Confirmed Issues (found by 2+ agents independently)

These issues were found by multiple agents, confirming their accuracy:

1. **ConditionLog.severity / Severity type** — TS-1/2/3 + XR-1/2
2. **NotificationType enum values** — TS-10/11 + XR-12
3. **SupplementListState missing fields** — TS-6 + XR-3
4. **FluidsEntry input type mismatch** — TS-8 + XR-4
5. **DataQualityReport field names** — TS-15 + NC-5/6/7
6. **Intelligence field mismatches** — TS-12/13/14 + NC-1/2/9
7. **Section 11 numbering** — BR-1 + SC-3

---

## Systemic Findings (Root Causes)

### 1. Section 13 (DB Alignment) — Wholesale Drift
Nearly every mapping table in Section 13 has mismatches vs canonical entity definitions. Root cause: entity definitions were updated in passes 1-6 but Section 13 was never reconciled. Affects 15+ entities.

**Entities with wrong DB mappings:** FlareUp, PhotoEntry, MLModel, PredictionFeedback, ImportedDataLog, FhirExport, HipaaAuthorization, ProfileAccessLog, BowelUrineLog, WearableConnection, Pattern, PredictiveAlert, PhotoArea, Document, UserAccount

### 2. Intelligence Subsystem — Dual Authorship
Sections 4.5.5 (use case implementations, ~lines 5300-5900) and Section 7.5 (input/output definitions, ~lines 9910-10080) were written at different times with completely different field naming conventions. This produces ~15 CRITICAL field name mismatches.

### 3. Missing Foundational Types
- `Model<T>` interface + 6 XxxModel classes — blocks entire data layer
- 4 wearable DTO types (WearableActivity, WearableSleep, WearableWaterIntake, WearablePlatformData) — blocks wearable import
- 12 service interfaces (from pass 6) — blocks intelligence, notification, auth, sync, and wearable subsystems
- SignInWithAppleInput + UseCase — blocks Apple Sign-In

### 4. NotificationType Enum — Granularity Mismatch
Enum defined with 20+ granular types (supplementIndividual, supplementGrouped, mealBreakfast, mealLunch, etc.) but use case code written assuming coarse types (supplement, food, fluids, water). Affects 6+ code locations.

### 5. Cross-Document Contradictions
- FhirExport entity has `syncMetadata` but 02_CODING_STANDARDS.md Section 8.2.1 explicitly exempts it
- MLModel entity has `syncMetadata` with a comment claiming compliance with a standard that actually exempts it
- MLModel also has comment "NOTE: Local-only entity - does NOT sync to cloud" contradicting syncMetadata

---

## All New Issues by Agent

### behavioral-review (15 new)

| ID | Severity | Line(s) | Issue |
|----|----------|---------|-------|
| NEW-BR-1 | MEDIUM | 12099, 12118 | Section 11 sub-headings numbered 8.1/8.2 instead of 11.1/11.2 |
| NEW-BR-2 | HIGH | 12568-12583 | Diet DB mapping missing `rules` documentation |
| NEW-BR-3 | CRITICAL | 12886-12900 | FlareUp DB mapping has `timestamp` instead of `startDate`/`endDate`, missing `photoPath` |
| NEW-BR-4 | HIGH | 12916-12925 | PhotoArea DB mapping missing `description`, `sortOrder`, `isArchived` |
| NEW-BR-5 | CRITICAL | 12934 | PhotoEntry DB mapping uses `areaId` vs entity `photoAreaId` |
| NEW-BR-6 | CRITICAL | 13072-13088 | MLModel DB mapping completely wrong fields |
| NEW-BR-7 | CRITICAL | 13090-13104 | PredictionFeedback DB mapping completely wrong fields |
| NEW-BR-8 | HIGH | 13126-13141 | ImportedDataLog DB mapping wrong field names + missing syncMetadata |
| NEW-BR-9 | HIGH | 13142-13158 | FhirExport DB mapping wrong field names + missing syncMetadata |
| NEW-BR-10 | HIGH | 13169 | HipaaAuthorization DB mapping has `accessLevel` not in entity |
| NEW-BR-11 | HIGH | 13183-13198 | ProfileAccessLog DB mapping missing `clientId` + syncMetadata |
| NEW-BR-12 | MEDIUM | 13217-13229 | BowelUrineLog DB mapping has 2 fields instead of 12 |
| NEW-BR-13 | MEDIUM | 13113, 13123 | WearableConnection DB mapping type mismatch + extra field |
| NEW-BR-14 | HIGH | 12987 | Pattern DB mapping `patternType` vs entity `type` |
| NEW-BR-15 | HIGH | 13058 | PredictiveAlert DB mapping `predictionType` vs entity `type` |

### type-safety (34 new)

| ID | Severity | Line(s) | Issue |
|----|----------|---------|-------|
| TS-1 | CRITICAL | 4635 | Undefined type `Severity` in `_detectFlare` |
| TS-2 | CRITICAL | 4690 | Undefined type `Severity?` in `ConditionTrend` |
| TS-3 | CRITICAL | 4760, 4805 | `.toStorageScale()` called on `int` |
| TS-4 | CRITICAL | 4654 | Wrong args to `getByCondition` (4 positional) |
| TS-5 | CRITICAL | 4729-4733 | Wrong named args to `getByCondition` |
| TS-6 | CRITICAL | 8257-8273 | Missing fields on `SupplementListState` |
| TS-7 | CRITICAL | 8609, 8656 | `Failure(StateError(...))` not AppError |
| TS-8 | CRITICAL | 8577 | Wrong input type for `GetTodayFluidsEntryUseCase` |
| TS-9 | HIGH | 8419-8422 | `activeOnly` not a field on `GetConditionsInput` |
| TS-10 | CRITICAL | 6009, 6017, 6143 | `NotificationType.supplement` not defined |
| TS-11 | CRITICAL | 6154-6164 | `NotificationType.food/fluids/water` not defined |
| TS-12 | HIGH | 5350 vs 9913 | `DetectPatternsInput` field name mismatch |
| TS-13 | HIGH | 5454 vs 9929 | `AnalyzeTriggersInput` field name mismatch |
| TS-14 | HIGH | 5571 | `.categories` vs `.insightTypes` |
| TS-15 | CRITICAL | 5898-5905 | `DataQualityReport` wrong field names |
| TS-16 | HIGH | 5891 | `.score` not on `DataTypeQuality` |
| TS-17 | HIGH | 5857 | `.sleepStart` should be `.bedTime` |
| TS-18 | CRITICAL | 12329-12339 | Missing required fields in QueuedNotification constructor |
| TS-19 | CRITICAL | 12333 | `DateTime` where `int` expected |
| TS-20 | HIGH | 3810 | Undefined factory `DatabaseError.transactionFailed` |
| TS-21 | HIGH | 3872, 3900 | Wrong signature for `DatabaseError.updateFailed` |
| TS-22 | HIGH | 1904 | Wrong signature for `DatabaseError.deleteFailed` |
| TS-23 | MEDIUM | 1767 | Error string handling loses original error |
| TS-24 | CRITICAL | 5647, 6417 | Undefined `NetworkError.rateLimited` |
| TS-25 | CRITICAL | 6301, 6315, 6433 | Wrong `WearableError` factory names |
| TS-26 | HIGH | 6336 | Missing `enableBackgroundSync` on input |
| TS-27 | HIGH | 6438-6448 | Missing fields on `SyncWearableDataInput` |
| TS-28 | HIGH | 5578 | Undefined `getByProfile` on HealthInsight repository |
| TS-29 | HIGH | 5583 | Undefined `.insightKey` on HealthInsight entity |
| TS-30 | HIGH | 8515 | Riverpod optional named param unsupported |
| TS-31 | HIGH | 8671 | Riverpod optional named param unsupported |
| TS-32 | MEDIUM | 2128 | Missing constructor on LogFluidsEntryUseCase |
| TS-33 | MEDIUM | 2324 | Missing constructor on LogSleepEntryUseCase |
| TS-34 | HIGH | 9590 | Inconsistent param type `int` vs `DateTime` |

### standards-compliance (10 new)

| ID | Severity | Line(s) | Issue |
|----|----------|---------|-------|
| SC-1 | HIGH | 64-81 | RecoveryAction enum missing explicit int values |
| SC-2 | MEDIUM | 10522-10533 | RateLimitOperation enum missing int value field |
| SC-3 | LOW | 12099, 12118 | Section 11 sub-headings numbered 8.1/8.2 |
| SC-4 | HIGH | 12358-12366 | SyncReminderService uses DateTime params |
| SC-5 | MEDIUM | 11795-11797 | DeviceRegistration.isStale uses DateTime internally |
| SC-6 | MEDIUM | 12067-12068 | ProfileAccessEntity.isExpired uses DateTime.now() |
| SC-8 | HIGH | 8833 | pendingNotifications provider silently drops errors |
| SC-9 | MEDIUM | 9160-9189 | ProviderErrorDisplay non-exhaustive switch on RecoveryAction |
| SC-10 | HIGH | 10941 | FhirExport has syncMetadata despite coding standards exemption |
| SC-11 | HIGH | 11895 | MLModel has syncMetadata despite coding standards exemption |

### naming-consistency (18 new)

| ID | Severity | Line(s) | Issue |
|----|----------|---------|-------|
| NC-1 | CRITICAL | 9919 vs 5396 | `significanceThreshold` vs `minimumConfidence` |
| NC-2 | CRITICAL | 9916-17 vs 5350 | `startDate/endDate` vs `lookbackDays` |
| NC-3 | HIGH | 9935 vs 5494 | `timeWindowsHours` vs `timeWindowHours` |
| NC-4 | HIGH | 9932 vs 5459 | `conditionId` required vs nullable |
| NC-5 | CRITICAL | 9975 vs 5899 | `overallQualityScore` vs `overallScore` |
| NC-6 | CRITICAL | 9976 vs 5900 | `byDataType` vs `scoresByDataType` |
| NC-7 | CRITICAL | 9970-78 vs 5903-04 | DataQualityReport missing/extra fields |
| NC-8 | HIGH | 9991-92 vs 5891 | `completenessScore/consistencyScore` vs `score` |
| NC-9 | CRITICAL | 9953 vs 5571 | `insightTypes` vs `categories` |
| NC-10 | CRITICAL | 11482 vs 5857, 6619 | `bedTime/wakeTime` vs `sleepStart/sleepEnd` |
| NC-11 | HIGH | 10368 vs 6071 | `getEnabled()` vs `getByProfile(enabledOnly:)` |
| NC-12 | HIGH | 9756-77 vs 5583 | `insightKey` field missing from HealthInsight |
| NC-13 | HIGH | 9682-9701 vs 5413-14 | Pattern missing `observationCount`/`lastObservedAt` |
| NC-14 | MEDIUM | 9682-9701 vs 5403 | `relatedConditionId` vs `entityId` |
| NC-15 | HIGH | 9872 vs 5408 | PatternRepository.findSimilar signature mismatch |
| NC-16 | CRITICAL | 9453 vs 5249/5299 | DietViolation `violatedAt`/`wasDismissed` vs `timestamp` |
| NC-17 | HIGH | 11147 vs 4654/4729 | ConditionLogRepository.getByCondition 3 different signatures |
| NC-18 | HIGH | multiple | Section 13 DB alignment entity field name drifts |

### completeness (11 new)

| ID | Severity | Line(s) | Issue |
|----|----------|---------|-------|
| CG-1 | CRITICAL | 1732 | `Model<T>` interface never defined |
| CG-2 | CRITICAL | 3608-3907 | 6 XxxModel classes never defined |
| CG-3 | CRITICAL | 6568/6603/6638 | 4 wearable DTO types never defined |
| CG-4 | CRITICAL | 6538 vs 10200 | SyncWearableDataOutput 5 wrong fields + type mismatch |
| CG-5 | HIGH | 10756 | HipaaAuthorization entity has no repository |
| CG-6 | HIGH | 13261 | UserFoodCategory in DB table mapping but entity never defined |
| CG-7 | HIGH | 12275 | QuietHoursQueueService missing constructor and fields |
| CG-8 | HIGH | 2425-3593 | 30 input classes defined with no UseCase implementations |
| CG-9 | MEDIUM | 8365/8801 | 2 provider registrations never defined |
| CG-10 | MEDIUM | 13273 vs 10568 | AuditLog vs AuditLogEntry naming mismatch |
| CG-11 | MEDIUM | 13275 | PairingSession entity defined in external doc only |

### cross-references (12 new)

| ID | Severity | Line(s) | Issue |
|----|----------|---------|-------|
| XR-1 | CRITICAL | 4760/4805 vs 11114 | `.toStorageScale()` on int |
| XR-2 | CRITICAL | 4690 | ConditionTrend uses undefined Severity type |
| XR-3 | CRITICAL | 8258/8273 vs 7870 | SupplementListState missing 2 fields |
| XR-4 | CRITICAL | 8577 vs 2276 | String passed where Input class expected |
| XR-5 | CRITICAL | 8548/8973 | Missing Freezed private constructors |
| XR-6 | HIGH | 8679-8680 | getBBTEntriesUseCaseProvider + Input never defined |
| XR-7 | HIGH | 8383 | getSupplementByIdUseCaseProvider never defined |
| XR-8 | HIGH | 8916/8921 | SignInWithAppleInput + UseCase never defined |
| XR-9 | HIGH | 8993-8995 | SyncService missing 3 convenience methods |
| XR-10 | MEDIUM | 8862 | AuthTokenService.hasValidToken() missing |
| XR-11 | MEDIUM | 3685/3707/3731 vs 7251 | SQL uses `timestamp` but entity uses `entryDate` |
| XR-12 | CRITICAL | 6009/6017/6144/6154/6159/6164 | 4 nonexistent NotificationType enum values |

---

## Recommendations

1. **Highest priority:** Fix Section 13 DB alignment tables wholesale — every table should be regenerated from canonical entity definitions
2. **Second priority:** Reconcile intelligence subsystem (Sections 4.5.5 vs 7.5) — choose canonical field names and update all references
3. **Third priority:** Add missing foundational types (Model\<T\>, wearable DTOs, service interfaces)
4. **Fourth priority:** Fix NotificationType enum usage across notification use cases
5. **Fifth priority:** Resolve cross-document contradictions (syncMetadata exemptions)
6. **Consider:** Adding the 30 missing use case implementations or generic templates

## Next Steps
- [ ] Review this report and previous fix plan
- [ ] Decide on user-decision items (SC-10/SC-11 syncMetadata, CG-8 use case approach)
- [ ] Apply fixes to 22_API_CONTRACTS.md
- [ ] Re-run /spec-review to verify convergence
