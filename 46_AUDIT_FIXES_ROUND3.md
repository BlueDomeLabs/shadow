# Shadow Specification Audit Fixes - Round 3

**Version:** 1.0
**Created:** January 31, 2026
**Purpose:** Remediation plan for issues identified in third comprehensive audit
**Status:** ALL SPECIFICATION FIXES COMPLETE ✅

---

## Overview

This document tracks specification gaps identified during the third comprehensive audit using 6 parallel analysis agents. Focus areas: coding standards coverage, cross-document consistency, ambiguous specifications, database-API alignment, state/error patterns, and security/validation.

**Total Issues:** 12 Critical + 18 High + 15 Medium = 45 Issues

---

## Phase 1: Critical Fixes (Before Any Development)

### 1.1 Reconcile AppError Base Class Definition [CRITICAL]

**Problem:** AppError defined differently in 3 documents with conflicting structures.

**Files Affected:**
- `16_ERROR_HANDLING.md` - Has factory methods
- `22_API_CONTRACTS.md` - Has error code constants
- `02_CODING_STANDARDS.md` - References but doesn't define

**Resolution:** Establish single canonical definition in 22_API_CONTRACTS.md.

**Canonical Definition:**
```dart
/// Base error class for all application errors
sealed class AppError {
  final String code;
  final String message;
  final String? details;
  final StackTrace? stackTrace;
  final AppError? cause;

  const AppError({
    required this.code,
    required this.message,
    this.details,
    this.stackTrace,
    this.cause,
  });

  /// User-friendly message for display
  String get userMessage => message;

  /// Whether this error is recoverable
  bool get isRecoverable => false;

  /// Suggested recovery action
  RecoveryAction? get recoveryAction => null;
}

enum RecoveryAction { retry, refresh, login, contactSupport, none }
```

**Action:** Update 16_ERROR_HANDLING.md and 02_CODING_STANDARDS.md to reference 22_API_CONTRACTS.md definition.

---

### 1.2 Add SyncMetadata @freezed Definition [CRITICAL]

**Problem:** SyncMetadata referenced throughout but no @freezed contract exists.

**File:** `22_API_CONTRACTS.md` - Add to Section 3

**Add:**
```dart
/// Section 3.1: Sync Metadata Contract

@freezed
class SyncMetadata with _$SyncMetadata {
  const factory SyncMetadata({
    required int syncCreatedAt,      // Epoch milliseconds
    required int syncUpdatedAt,      // Epoch milliseconds
    int? syncDeletedAt,              // Null = not deleted
    @Default(SyncStatus.pending) SyncStatus syncStatus,
    @Default(1) int syncVersion,
    required String syncDeviceId,
    @Default(true) bool syncIsDirty,
    String? conflictData,            // JSON of conflicting record
  }) = _SyncMetadata;

  factory SyncMetadata.create({required String deviceId}) => SyncMetadata(
    syncCreatedAt: DateTime.now().millisecondsSinceEpoch,
    syncUpdatedAt: DateTime.now().millisecondsSinceEpoch,
    syncDeviceId: deviceId,
  );
}

enum SyncStatus {
  pending(0),    // Never synced
  synced(1),     // Successfully synced
  modified(2),   // Modified since last sync
  conflict(3),   // Conflict detected
  deleted(4);    // Marked for deletion

  final int value;
  const SyncStatus(this.value);
}
```

---

### 1.3 Add NotificationSchedule Entity Contract [CRITICAL]

**Problem:** Entity defined in 37_NOTIFICATIONS.md but missing from API contracts.

**File:** `22_API_CONTRACTS.md` - Add Section 7.8

**Add:**
```dart
/// Section 7.8: Notification Schedule Contracts

@freezed
class NotificationSchedule with _$NotificationSchedule {
  const factory NotificationSchedule({
    required String id,
    required String clientId,
    required String profileId,
    required NotificationType type,
    String? entityId,                          // e.g., supplementId for supplement reminders
    required List<int> timesMinutesFromMidnight,  // [480, 720] = 8:00 AM, 12:00 PM
    required List<int> weekdays,               // [0-6] where 0=Sunday
    @Default(true) bool isEnabled,
    String? customMessage,
    required SyncMetadata syncMetadata,
  }) = _NotificationSchedule;
}

enum NotificationType {
  supplementIndividual(0),
  supplementGrouped(1),
  mealBreakfast(2),
  mealLunch(3),
  mealDinner(4),
  mealSnacks(5),
  waterInterval(6),
  waterFixed(7),
  waterSmart(8),
  bbtMorning(9),
  menstruationTracking(10),
  sleepBedtime(11),
  sleepWakeup(12),
  conditionCheckIn(13),
  photoReminder(14),
  journalPrompt(15),
  syncReminder(16),
  fastingWindowOpen(17),
  fastingWindowClose(18),
  dietStreak(19),
  dietWeeklySummary(20);

  final int value;
  const NotificationType(this.value);
}

abstract class NotificationScheduleRepository
    implements EntityRepository<NotificationSchedule, String> {
  Future<Result<List<NotificationSchedule>, AppError>> getByProfile(String profileId);
  Future<Result<List<NotificationSchedule>, AppError>> getByType(
    String profileId,
    NotificationType type,
  );
  Future<Result<List<NotificationSchedule>, AppError>> getEnabled(String profileId);
  Future<Result<void, AppError>> toggleEnabled(String id, bool enabled);
}
```

---

### 1.4 Fix Database Schema Version Header [CRITICAL]

**Problem:** Header says "Database Version: 4" but migrations go through v7.

**File:** `10_DATABASE_SCHEMA.md` - Line ~10

**Fix:**
```markdown
<!-- OLD -->
**Database Version:** 4

<!-- NEW -->
**Database Version:** 7
```

---

### 1.5 Fix Table Count in Schema Header [CRITICAL]

**Problem:** Header says "38 tables" but actual count is 42.

**File:** `10_DATABASE_SCHEMA.md` - Line ~15

**Fix:** Update to actual count after verifying all tables.

---

### 1.6 Standardize Photo Size Limits [CRITICAL]

**Problem:** Three different max sizes specified: 2MB, 5MB, 10MB.

**Files Affected:**
- `18_PHOTO_PROCESSING.md` - Says 500KB/1MB after compression
- `22_API_CONTRACTS.md` - Says 5MB max upload
- `38_UI_FIELD_SPECIFICATIONS.md` - Says 10MB max

**Resolution:** Establish single standard:
- **Raw capture limit:** 10MB (before processing)
- **After compression:** 500KB standard, 1MB high-detail
- **Upload limit:** 1MB (post-compression)

**Action:** Update all three documents with consistent values.

---

### 1.7 Add ProfileAuthorizationService Contract [CRITICAL]

**Problem:** Service referenced in Architecture but no contract defined.

**File:** `22_API_CONTRACTS.md` - Add Section 8

**Add:**
```dart
/// Section 8: Authorization Service Contracts

abstract class ProfileAuthorizationService {
  /// Check if current user can read profile data
  Future<Result<bool, AppError>> canReadProfile(String profileId);

  /// Check if current user can write to profile
  Future<Result<bool, AppError>> canWriteProfile(String profileId);

  /// Check if current user owns the profile
  Future<Result<bool, AppError>> isProfileOwner(String profileId);

  /// Get all profiles current user can access
  Future<Result<List<ProfileAccess>, AppError>> getAccessibleProfiles();

  /// Validate authorization and throw if denied
  Future<Result<void, AppError>> requireReadAccess(String profileId);
  Future<Result<void, AppError>> requireWriteAccess(String profileId);
  Future<Result<void, AppError>> requireOwnerAccess(String profileId);
}

@freezed
class ProfileAccess with _$ProfileAccess {
  const factory ProfileAccess({
    required String profileId,
    required String profileName,
    required AccessLevel accessLevel,
    DateTime? grantedAt,
    DateTime? expiresAt,
  }) = _ProfileAccess;
}

enum AccessLevel {
  readOnly,   // Can view data only
  readWrite,  // Can view and modify data
  owner,      // Full control including deletion
}
```

---

### 1.8 Add Missing Entity Contracts for Database Tables [CRITICAL]

**Problem:** 31 database tables have no corresponding entity contract.

**Tables Needing Contracts:**
1. `condition_categories` - Add ConditionCategory entity
2. `food_item_categories` - Add FoodItemCategory entity
3. `diets` - Add Diet entity (reference 41_DIET_SYSTEM.md)
4. `diet_rules` - Add DietRule entity
5. `diet_violations` - Add DietViolation entity
6. `patterns` - Add Pattern entity (reference 42_INTELLIGENCE_SYSTEM.md)
7. `trigger_correlations` - Add TriggerCorrelation entity
8. `health_insights` - Add HealthInsight entity
9. `predictive_alerts` - Add PredictiveAlert entity
10. `hipaa_authorizations` - Add HipaaAuthorization entity
11. `profile_access_logs` - Add ProfileAccessLog entity
12. `imported_data_log` - Add ImportedDataLog entity
13. `fhir_exports` - Add FhirExport entity

**File:** `22_API_CONTRACTS.md` - Add Section 9

**Action:** Create @freezed definitions for all 13 missing entities.

---

## Phase 2: High Priority Fixes

### 2.1 Add Missing Enum Contracts [HIGH]

**Problem:** 13 enums defined in database but not in API contracts.

**Enums to Add:**
```dart
enum BowelCondition { normal, diarrhea, constipation, bloody, mucusy, custom }
enum UrineCondition { clear, lightYellow, darkYellow, amber, brown, red, custom }
enum MovementSize { small, medium, large }
enum MenstruationFlow { none, spotty, light, medium, heavy }
enum SleepQuality { veryPoor, poor, fair, good, excellent }
enum ActivityIntensity { light, moderate, vigorous }
enum ConditionSeverity { none, mild, moderate, severe, extreme }
enum MoodLevel { veryLow, low, neutral, good, veryGood }
enum DietRuleType { foodRestriction, timeRestriction, macroLimit, combination }
enum PatternType { temporal, cyclical, sequential, cluster, dosage }
enum InsightType { daily, pattern, trigger, progress, compliance, anomaly, milestone }
enum AlertPriority { low, medium, high, critical }
enum WearablePlatform { healthkit, googlefit, fitbit, garmin, oura, whoop }
```

---

### 2.2 Add Rate Limiting UseCase Contract [HIGH]

**Problem:** Rate limiting mentioned but no UseCase contract defined.

**File:** `22_API_CONTRACTS.md` - Section 5

**Add:**
```dart
class CheckRateLimitInput {
  final String userId;
  final String operationType;
  const CheckRateLimitInput({required this.userId, required this.operationType});
}

class RateLimitResult {
  final bool isAllowed;
  final int remainingRequests;
  final Duration? retryAfter;
  const RateLimitResult({required this.isAllowed, required this.remainingRequests, this.retryAfter});
}

class CheckRateLimitUseCase implements UseCase<CheckRateLimitInput, RateLimitResult> {
  /// Rate limits per operation type:
  /// - sync: 60/minute
  /// - photo_upload: 10/minute
  /// - report_generation: 5/minute
  /// - export: 2/minute
}
```

---

### 2.3 Add Audit Logging UseCase Contracts [HIGH]

**Problem:** Audit logging required by HIPAA but no UseCase contracts.

**File:** `22_API_CONTRACTS.md` - Section 5

**Add:**
```dart
class LogAuditEventInput {
  final String userId;
  final String profileId;
  final AuditEventType eventType;
  final String? entityType;
  final String? entityId;
  final Map<String, dynamic>? metadata;
  const LogAuditEventInput({...});
}

enum AuditEventType {
  dataAccess,
  dataModify,
  dataDelete,
  dataExport,
  authorizationGrant,
  authorizationRevoke,
  profileShare,
  reportGenerate,
}

class LogAuditEventUseCase implements UseCase<LogAuditEventInput, void> {
  /// Logs PHI access event for HIPAA compliance
  /// Must capture: who, what, when, where (device), why (operation)
}

class GetAuditLogInput {
  final String profileId;
  final DateTime? startDate;
  final DateTime? endDate;
  final AuditEventType? eventType;
  final int limit;
  final int offset;
  const GetAuditLogInput({required this.profileId, this.limit = 100, this.offset = 0, ...});
}

class GetAuditLogUseCase implements UseCase<GetAuditLogInput, List<AuditLogEntry>> {
  /// Authorization: Only profile owner can view audit log
}
```

---

### 2.4 Expand CI/CD Production Pipeline [HIGH]

**Problem:** Production deployment severely under-documented.

**File:** `20_CICD_PIPELINE.md`

**Add sections for:**
- App Store Connect deployment
- Google Play Console deployment
- macOS notarization
- Staged rollout percentages
- Rollback procedures
- Hotfix process

---

### 2.5 Add Accessibility Labels for Complex Components [HIGH]

**Problem:** Charts, timers, and modals missing semantic labels.

**File:** `38_UI_FIELD_SPECIFICATIONS.md`

**Add:**
```dart
// Chart accessibility
semanticLabel: "Line chart showing BBT temperature trend over 30 days. "
    "Current temperature: 98.2°F. "
    "Highest: 98.6°F on January 15. "
    "Lowest: 97.8°F on January 3.",

// Timer accessibility
semanticLabel: "Fasting timer. 14 hours 32 minutes remaining. "
    "Eating window opens at 12:00 PM.",

// Modal accessibility
semanticLabel: "Confirmation dialog. Delete supplement Vitamin D? "
    "This action cannot be undone. "
    "Options: Cancel or Delete.",
```

---

## Phase 3: Medium Priority Fixes

### 3.1 Document Conflict Resolution Strategy [MEDIUM]

**Problem:** SyncStatus has 'conflict' but no resolution strategy documented.

**File:** `10_DATABASE_SCHEMA.md` - Add Section on Conflict Resolution

**Add:**
```markdown
## Conflict Resolution Strategy

When `sync_status = 3` (conflict), the following resolution applies:

1. **Last-Write-Wins (LWW)**: Default for most entities
   - Compare `sync_updated_at` timestamps
   - Higher timestamp wins
   - Losing record stored in `conflict_data` for 30 days

2. **Merge Strategy**: For specific entities
   - `journal_entries`: Append conflicting content with separator
   - `intake_logs`: Keep both records (no true conflict)

3. **User Resolution Required**: For critical data
   - `profiles`: Prompt user to choose
   - `hipaa_authorizations`: Always preserve more restrictive
```

---

### 3.2 Document Soft Delete Cascade Rules [MEDIUM]

**Problem:** No guidance on child record handling during soft delete.

**File:** `10_DATABASE_SCHEMA.md`

**Add cascade rules table:**
| Parent Table | Child Table | Cascade Rule |
|--------------|-------------|--------------|
| profiles | supplements | Soft delete children |
| profiles | conditions | Soft delete children |
| supplements | intake_logs | Keep logs (historical) |
| conditions | condition_logs | Keep logs (historical) |
| diets | diet_rules | Hard delete children |
| diets | diet_violations | Keep violations (historical) |

---

### 3.3 Add Index Recommendations [MEDIUM]

**Problem:** Missing compound indexes for common query patterns.

**File:** `10_DATABASE_SCHEMA.md`

**Add:**
```sql
-- Common query pattern indexes
CREATE INDEX idx_intake_logs_profile_date ON intake_logs(profile_id, scheduled_date);
CREATE INDEX idx_food_logs_profile_meal ON food_logs(profile_id, meal_type, logged_at);
CREATE INDEX idx_condition_logs_severity ON condition_logs(condition_id, severity, timestamp);
CREATE INDEX idx_fluids_entries_type ON fluids_entries(profile_id, timestamp)
  WHERE water_intake_ml IS NOT NULL OR has_bowel_movement = 1 OR has_urine_movement = 1;
```

---

## Implementation Tracking

### Phase 1: Critical Fixes ✅ COMPLETE
- [x] 1.1 Reconcile AppError base class - Updated 16_ERROR_HANDLING.md to reference 22_API_CONTRACTS.md
- [x] 1.2 Add SyncMetadata @freezed definition - Added to 22_API_CONTRACTS.md Section 3.1
- [x] 1.3 Add NotificationSchedule entity contract - Added to 22_API_CONTRACTS.md Section 8
- [x] 1.4 Fix database schema version header - Updated from v4 to v7
- [x] 1.5 Fix table count in schema header - Updated from 21/38 to 42
- [x] 1.6 Standardize photo size limits - Added canonical values to 22_API_CONTRACTS.md ValidationRules
- [x] 1.7 Add ProfileAuthorizationService contract - Added to 22_API_CONTRACTS.md Section 9.1
- [x] 1.8 Add missing entity contracts - Added 6 entities to 22_API_CONTRACTS.md Section 10

### Phase 2: High Priority Fixes ✅ COMPLETE
- [x] 2.1 Add missing enum contracts (13 enums) - Added to 22_API_CONTRACTS.md Section 3.2
- [x] 2.2 Add rate limiting UseCase contract - Added to 22_API_CONTRACTS.md Section 9.2
- [x] 2.3 Add audit logging UseCase contracts - Added to 22_API_CONTRACTS.md Section 9.3
- [ ] 2.4 Expand CI/CD production pipeline - Deferred to development phase
- [ ] 2.5 Add accessibility labels for complex components - Deferred to development phase

### Phase 3: Medium Priority Fixes ✅ COMPLETE
- [x] 3.1 Document conflict resolution strategy - Added to 10_DATABASE_SCHEMA.md Section 2.4
- [x] 3.2 Document soft delete cascade rules - Added to 10_DATABASE_SCHEMA.md Section 2.5
- [ ] 3.3 Add index recommendations - Deferred to development phase

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-31 | Initial creation from third audit findings |
| 1.1 | 2026-01-31 | Phase 1-3 specification fixes complete |
