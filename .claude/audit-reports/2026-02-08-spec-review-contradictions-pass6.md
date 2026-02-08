# Spec Review Report - 2026-02-08 (Contradiction-Focused Pass 6)

## Executive Summary
- Focus: Service interfaces, intelligence subsystem input/output mismatches, notification subsystem
- New contradictions found: 9 (but CRITICAL-1 alone contains 12 missing class definitions)
- Severity: 9 CRITICAL (would-not-compile)
- **This is the highest-impact pass yet** — CRITICAL-1 represents the single largest gap found in any pass

---

## New Contradictions Found

### CRITICAL-1: 12 Service Interfaces Used But Never Defined (MEGA-GAP)

**Severity:** CRITICAL — would not compile (12 classes, ~25 methods, referenced from ~20 use cases)

Use cases depend on service interfaces via constructor injection, but the abstract class definitions are completely absent from the spec. During implementation, we cannot write ANY of these use cases.

| # | Service Class | Used At Lines | Methods Called | Use Case Count |
|---|---------------|--------------|----------------|----------------|
| 1 | NotificationService | 5920, 6043, 6214, 6842 | scheduleNotifications, cancelNotifications, cancelAllNotifications, showNow | 4 |
| 2 | WearablePlatformService | 6280, 6380 | isAvailable, requestPermissions, fetchData | 2 |
| 3 | AuthTokenService | 6715, 6841 | storeTokens, clearTokens | 2 |
| 4 | SyncService | 6843, 6902, 6991, 7085 | pushPendingChanges, getPendingChanges, pushChanges, getLastSyncVersion, pullChanges, applyChanges, resolveConflict | 4 |
| 5 | DeviceInfoService | 6717, 6844 | registerCurrentDevice, unregisterCurrentDevice | 2 |
| 6 | GoogleAuthService | 6716 | verifyIdToken | 1 |
| 7 | TriggerAnalysisService | 5435 | analyzeCorrelations | 1 |
| 8 | InsightGeneratorService | 5524 | generateInsights | 1 |
| 9 | PredictionService | 5614 | predictFlareUps, predictMenstrualCycle, generateTriggerWarnings, predictMissedSupplements | 1 |
| 10 | DataQualityService | 5751 | assessConditionLogging, assessFoodLogging, assessSleepLogging, assessFluidsLogging, assessSupplementLogging, findGaps, generateRecommendations | 1 |
| 11 | DietComplianceService | 5053, 9563 | checkFoodAgainstRules, calculateImpact | 2 |
| 12 | PatternDetectionService | 5329 | detectPatterns | 1 |

**Fix:** Add a new Section "11. Service Interface Contracts" to 22_API_CONTRACTS.md defining all 12 abstract classes with their method signatures, extracted from usage patterns in the use case code. This is a large addition (~150-200 lines) but absolutely necessary.

---

### CRITICAL-2: GrantedPermissions Type Never Defined (line 6312)

**Severity:** CRITICAL — would not compile

ConnectWearableUseCase at line 6312: `final grantedPermissions = permissionsResult.valueOrNull!;`
Then accesses `grantedPermissions.read` (line 6334) and `grantedPermissions.write` (line 6335) as `List<String>`.

The return type of `WearablePlatformService.requestPermissions()` is never defined.

**Fix:** Add class definition (adjacent to WearablePlatformService):
```dart
@freezed
class GrantedPermissions with _$GrantedPermissions {
  const factory GrantedPermissions({
    required List<String> read,
    required List<String> write,
  }) = _GrantedPermissions;
}
```

---

### CRITICAL-3: GetPendingNotificationsUseCase — calls getByProfile with nonexistent param (line 6070-6072)

**Severity:** CRITICAL — would not compile (named param doesn't exist)

Use case at line 6070-6072:
```dart
final schedulesResult = await _repository.getByProfile(
  input.profileId,
  enabledOnly: true,
);
```

NotificationScheduleRepository.getByProfile (line 10363-10365): Takes only `(String profileId)` — NO `enabledOnly` param.

The repo HAS `getEnabled(String profileId)` (line 10368-10370) which does exactly what's needed.

**Fix:** Change line 6070-6072 to:
```dart
final schedulesResult = await _repository.getEnabled(input.profileId);
```

---

### CRITICAL-4: HealthInsightRepository — getByProfile with includeDismissed doesn't exist (line 5578)

**Severity:** CRITICAL — would not compile (method doesn't exist)

Use case at line 5578: `_insightRepository.getByProfile(input.profileId, includeDismissed: false)`

HealthInsightRepository (9891-9899): Only has `getActive(profileId, ...)` and `dismiss(id)`.
No `getByProfile` method exists (not even inherited — EntityRepository has `getAll`, not `getByProfile`).

**Fix:** Either:
- (a) Change to `_insightRepository.getActive(input.profileId)` (functionally equivalent — getActive returns non-dismissed), OR
- (b) Add `getByProfile` method to HealthInsightRepository

Option (a) is simpler and already defined.

---

### CRITICAL-5: DetectPatternsInput — 4 field names used in use case don't exist (lines 5350/5383/5396/5400)

**Severity:** CRITICAL — would not compile (4 nonexistent fields)

DetectPatternsInput definition (9913-9924) has: `profileId, startDate, endDate, patternTypes, significanceThreshold, minimumOccurrences, includeTemporalPatterns, includeCyclicalPatterns, includeSequentialPatterns`

Use case code accesses:
- `input.lookbackDays` (line 5350) — NOT in input (input has startDate/endDate)
- `input.minimumDataPoints` (line 5383) — NOT in input (has minimumOccurrences)
- `input.minimumConfidence` (line 5396) — NOT in input (has significanceThreshold)
- `input.conditionIds` (line 5400) — NOT in input

**Fix:** Update DetectPatternsInput to match use case:
```dart
@freezed
class DetectPatternsInput with _$DetectPatternsInput {
  const factory DetectPatternsInput({
    required String profileId,
    @Default(90) int lookbackDays,                    // Replaces startDate/endDate
    @Default([]) List<PatternType> patternTypes,
    @Default(0.6) double minimumConfidence,            // Replaces significanceThreshold
    @Default(5) int minimumDataPoints,                 // Replaces minimumOccurrences
    @Default([]) List<String> conditionIds,            // NEW: filter by condition
    @Default(true) bool includeTemporalPatterns,
    @Default(true) bool includeCyclicalPatterns,
    @Default(true) bool includeSequentialPatterns,
  }) = _DetectPatternsInput;
}
```

---

### CRITICAL-6: AnalyzeTriggersInput — 4 field mismatches + nullable vs required conflict (lines 5454-5498)

**Severity:** CRITICAL — would not compile (4+ issues)

AnalyzeTriggersInput definition (9929-9943) has: `profileId, conditionId (required), startDate, endDate, timeWindowsHours, significanceThreshold, minimumOccurrences, includeFoodTriggers, ...`

Use case code accesses:
- `input.conditionId != null` (line 5459) — treats as nullable, but input defines it as `required String`
- `input.lookbackDays` (line 5455) — NOT in input (has startDate/endDate)
- `input.timeWindowHours` (line 5494) — NOT in input (has `timeWindowsHours` — note plural 'Windows')
- `input.minimumConfidence` (line 5497) — NOT in input (has `significanceThreshold`)

**Fix:** Update AnalyzeTriggersInput to match use case:
```dart
@freezed
class AnalyzeTriggersInput with _$AnalyzeTriggersInput {
  const factory AnalyzeTriggersInput({
    required String profileId,
    String? conditionId,                              // Nullable (use case checks for null)
    @Default(90) int lookbackDays,                    // Replaces startDate/endDate
    @Default([6, 12, 24, 48, 72]) List<int> timeWindowHours,  // Renamed from timeWindowsHours
    @Default(0.6) double minimumConfidence,            // Replaces significanceThreshold
    @Default(10) int minimumOccurrences,
    @Default(true) bool includeFoodTriggers,
    @Default(true) bool includeSupplementTriggers,
    @Default(true) bool includeActivityTriggers,
    @Default(true) bool includeSleepTriggers,
    @Default(true) bool includeEnvironmentalTriggers,
  }) = _AnalyzeTriggersInput;
}
```

---

### CRITICAL-7: GenerateInsightsInput — input.categories doesn't exist (line 5571)

**Severity:** CRITICAL — would not compile

Use case at line 5571: `input.categories.isEmpty ? InsightCategory.values : input.categories`
GenerateInsightsInput (9948-9960): Has `insightTypes`, NOT `categories`.

**Fix:** Change field name in GenerateInsightsInput from `insightTypes` to `categories`:
```dart
@Default([]) List<InsightCategory> categories,    // Renamed from insightTypes
```

---

### CRITICAL-8: DataQualityReport Construction — 6 wrong field names + 4 missing required fields (lines 5898-5905)

**Severity:** CRITICAL — would not compile (10 issues in one constructor call)

Use case at lines 5898-5905 constructs:
```dart
DataQualityReport(
  overallScore: overallScore,         // Entity has: overallQualityScore
  scoresByDataType: scores,            // Entity has: byDataType
  gaps: gaps,                          // OK
  recommendations: recommendations,    // OK
  analyzedFromEpoch: startDate,        // DOES NOT EXIST in entity
  analyzedToEpoch: now,                // DOES NOT EXIST in entity
)
```

Missing required fields (per entity definition 9969-9979):
- `profileId` (required) — NOT passed
- `assessedAt` (required) — NOT passed
- `totalDaysAnalyzed` (required) — NOT passed
- `daysWithData` (required) — NOT passed

**Fix:** Update use case construction to match entity field names:
```dart
DataQualityReport(
  profileId: input.profileId,
  assessedAt: now,
  totalDaysAnalyzed: input.lookbackDays,
  daysWithData: scores.values.fold(0, (sum, q) => sum + q.daysWithData),
  overallQualityScore: overallScore,
  byDataType: scores,
  gaps: gaps,
  recommendations: recommendations,
)
```
Also remove `analyzedFromEpoch` and `analyzedToEpoch` from the use case (not in entity).

---

### CRITICAL-9: QueuedNotification Construction — DateTime vs int + missing 2 required fields (line 12329-12339)

**Severity:** CRITICAL — would not compile (3 issues)

QuietHoursQueueService `_collapseDuplicates` at line 12329-12339:
```dart
result.add(QueuedNotification(
  id: 'collapsed_${entry.key.name}',
  type: entry.key,
  originalScheduledTime: entry.value.first.originalScheduledTime,
  queuedAt: DateTime.now(),    // ← WRONG TYPE: field is int (epoch ms)
  payload: { ... },
));
```

Issues:
1. `queuedAt: DateTime.now()` — entity definition (12266) says `required int queuedAt` (epoch ms). Should be `DateTime.now().millisecondsSinceEpoch`
2. Missing `clientId` (required per line 12262)
3. Missing `profileId` (required per line 12263)

**Fix:** Change construction to:
```dart
result.add(QueuedNotification(
  id: 'collapsed_${entry.key.name}',
  clientId: entry.value.first.clientId,
  profileId: entry.value.first.profileId,
  type: entry.key,
  originalScheduledTime: entry.value.first.originalScheduledTime,
  queuedAt: DateTime.now().millisecondsSinceEpoch,
  payload: { ... },
));
```

---

## Summary Table

| # | Location | Entity/Method | Issue | Severity |
|---|----------|---------------|-------|----------|
| C1 | 12 classes across spec | 12 Service Interfaces | Never defined (~25 methods across ~20 use cases) | CRITICAL |
| C2 | 6312 | GrantedPermissions | Type never defined | CRITICAL |
| C3 | 6070 vs 10363 | getByProfile(enabledOnly:) | Named param doesn't exist, should use getEnabled() | CRITICAL |
| C4 | 5578 vs 9891 | HealthInsightRepository.getByProfile | Method doesn't exist, should use getActive() | CRITICAL |
| C5 | 5350/5383/5396/5400 vs 9913 | DetectPatternsInput | 4 field names don't exist (lookbackDays, minimumDataPoints, minimumConfidence, conditionIds) | CRITICAL |
| C6 | 5455/5459/5494/5497 vs 9929 | AnalyzeTriggersInput | 4 mismatches + required vs nullable conflict | CRITICAL |
| C7 | 5571 vs 9948 | GenerateInsightsInput.categories | Field named insightTypes, not categories | CRITICAL |
| C8 | 5898-5905 vs 9969 | DataQualityReport construction | 6 wrong field names + 4 missing required fields | CRITICAL |
| C9 | 12329-12339 vs 12259 | QueuedNotification construction | DateTime vs int + 2 missing required fields | CRITICAL |

---

## Impact Assessment

**CRITICAL-1 is the single most impactful finding across ALL 6 passes:**
- 12 service interfaces = 12 abstract classes that need to be created
- ~25 methods need signatures defined
- ~20 use cases depend on these services
- Without these definitions, the ENTIRE intelligence, notification, auth, sync, and wearable subsystems cannot be implemented

**CRITICAL-5/6/7/8 together represent a systemic issue:** The intelligence use case implementations (Section 4.5.5) were written using different field names than the input/output definitions (Section ~9910-10080). This suggests the two sections were written at different times without reconciliation.

---

## Relationship to Existing Fix Plan

- C1-C2 are entirely new classes/types — NOT related to any existing fix
- C3 is in the Notification subsystem, not previously audited for method calls
- C4 is in the Intelligence subsystem, distinct from Fix 41 (insightKey field)
- C5-C7 are intelligence input class issues — NOT previously found
- C8 is a DataQualityReport output mismatch — NOT previously found
- C9 is in the Notification quiet hours subsystem — NOT previously checked
- **All 9 are NEW** — none overlap with the 69 items already in the fix plan
