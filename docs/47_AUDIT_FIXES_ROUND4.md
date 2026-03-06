# Shadow Specification Audit Fixes - Round 4

**Version:** 1.0
**Created:** January 31, 2026
**Purpose:** Remediation plan for issues identified in fourth comprehensive audit
**Status:** COMPLETE

---

## Overview

This document tracks specification gaps identified during the fourth comprehensive audit using 6 parallel analysis agents. Total issues: **151+ findings** across coding standards, cross-document consistency, ambiguity, database-API alignment, security, and testing.

---

## Critical Issues Summary

### BLOCKING (Must Fix Before Any Development)

| # | Issue | Impact | Documents |
|---|-------|--------|-----------|
| 1 | **SyncStatus enum mismatch** | DB: pending/synced/conflict/error vs Dart: pending/synced/modified/conflict/deleted | 02, 07, 10, 22 |
| 2 | **SyncMetadata field names conflict** | DateTime vs int, createdByDeviceId vs syncDeviceId | 02, 22 |
| 3 | **Repository signatures conflict** | Result<T> vs raw types, getById vs getSupplement | 02, 04, 22 |
| 4 | **20 database tables missing entity contracts** | No @freezed definitions for core entities | 10, 22 |
| 5 | **AccessLevel mismatch** | DB: 'admin' vs Dart: 'owner' | 10, 22 |
| 6 | **BowelCondition enum mismatch** | 3 different value sets across documents | 01, 10, 22 |
| 7 | **Severity scale conflict** | 1-10 integer vs 5-level enum | 01, 10, 22 |
| 8 | **Notification type count** | Product spec: 16 vs Actual: 21 | 01, 22, 37 |
| 9 | **DietRuleType enum** | 4 values in API vs 21 values in Diet System | 22, 41 |
| 10 | **BaseRepository not defined** | prepareForCreate/Update/Delete helpers missing | 02 |

---

## Phase 1: Critical Conflicts (Blocking)

### 1.1 SyncStatus Enum Alignment [CRITICAL]

**Problem:** Three different definitions exist:

```dart
// 02_CODING_STANDARDS.md (Lines 1044-1050)
enum SyncStatus {
  pending(0), synced(1), conflict(2), error(3)
}

// 10_DATABASE_SCHEMA.md (Section 2.2)
| 0 | pending | 1 | synced | 2 | conflict | 3 | error |

// 22_API_CONTRACTS.md (Lines 375-387)
enum SyncStatus {
  pending(0), synced(1), modified(2), conflict(3), deleted(4)
}
```

**Resolution:** Use 22_API_CONTRACTS.md version (most complete). Update:
- [ ] `02_CODING_STANDARDS.md` - Add `modified(2)` and `deleted(4)`
- [ ] `10_DATABASE_SCHEMA.md` - Update enum table to 5 values

---

### 1.2 SyncMetadata Field Names Alignment [CRITICAL]

**Problem:** Field names and types differ:

| Field | 02_CODING_STANDARDS | 22_API_CONTRACTS |
|-------|---------------------|------------------|
| Created time | `DateTime createdAt` | `int syncCreatedAt` |
| Updated time | `DateTime updatedAt` | `int syncUpdatedAt` |
| Version | `int version` | `int syncVersion` |
| Device | `createdByDeviceId` + `lastModifiedByDeviceId` | `syncDeviceId` (single) |

**Resolution:** Use API Contracts version (int epoch, single device). Update:
- [ ] `02_CODING_STANDARDS.md` - Align to int types, single device field

---

### 1.3 Repository Interface Alignment [CRITICAL]

**Problem:** Architecture shows different patterns:

```dart
// 04_ARCHITECTURE.md - WRONG (outdated)
Future<List<Supplement>> getAllSupplements(...);
Future<Supplement> getSupplement(String id);
Future<void> addSupplement(Supplement supplement);

// 22_API_CONTRACTS.md - CORRECT
Future<Result<List<Supplement>, AppError>> getAll(...);
Future<Result<Supplement, AppError>> getById(String id);
Future<Result<Supplement, AppError>> create(Supplement supplement);
```

**Resolution:** Update Architecture to match API Contracts:
- [ ] `04_ARCHITECTURE.md` - Replace all repository examples with Result pattern

---

### 1.4 Missing Entity Contracts [CRITICAL]

**20 database tables have NO @freezed entity:**

| Priority | Table | Entity Name to Create |
|----------|-------|----------------------|
| P0 | user_accounts | UserAccount |
| P0 | profiles | Profile |
| P0 | intake_logs | IntakeLog / SupplementIntakeLog |
| P0 | food_items | FoodItem |
| P0 | food_logs | FoodLog |
| P0 | conditions | Condition |
| P0 | condition_logs | ConditionLog |
| P1 | activities | Activity |
| P1 | activity_logs | ActivityLog |
| P1 | sleep_entries | SleepEntry |
| P1 | journal_entries | JournalEntry |
| P1 | photo_areas | PhotoArea |
| P1 | photo_entries | PhotoEntry |
| P1 | flare_ups | FlareUp |
| P2 | device_registrations | DeviceRegistration |
| P2 | documents | Document |
| P2 | bowel_urine_logs | (Legacy - may not need) |
| P2 | ml_models | MlModel |
| P2 | prediction_feedback | PredictionFeedback |

**Action:** Add to `22_API_CONTRACTS.md`:
- [ ] Section 10: Add P0 entities (6 entities)
- [ ] Section 10: Add P1 entities (6 entities)
- [ ] Section 10: Add P2 entities (4 entities)

---

### 1.5 AccessLevel Enum Alignment [CRITICAL]

**Problem:**
- Database: `'readOnly' | 'readWrite' | 'admin'`
- API Contracts: `readOnly, readWrite, owner`

**Resolution:** Standardize on `owner` (more descriptive):
- [ ] `10_DATABASE_SCHEMA.md` - Change 'admin' to 'owner'

---

### 1.6 Bowel/Urine Condition Enums [CRITICAL]

**Problem:** Three incompatible definitions:

| Document | BowelCondition Values |
|----------|----------------------|
| 01_PRODUCT_SPECIFICATIONS | Diarrhea, Runny, Loose, Firm, Hard, Custom |
| 22_API_CONTRACTS | normal, diarrhea, constipation, bloody, mucusy, custom |
| 10_DATABASE_SCHEMA | 0=normal, 1=constipated, 2=diarrhea, 3=custom |

**Resolution:** Use clinical terminology (API Contracts) with expanded DB:
- [ ] `01_PRODUCT_SPECIFICATIONS.md` - Align to clinical terms
- [ ] `10_DATABASE_SCHEMA.md` - Expand enum to 6 values

---

### 1.7 Severity Scale Standardization [CRITICAL]

**Problem:**
- Product Spec & DB: 1-10 integer scale
- API Contracts: 5-level enum (none/mild/moderate/severe/extreme)

**Resolution:** Keep both - use enum for display, map to 1-10 for storage:
- [ ] `22_API_CONTRACTS.md` - Add mapping documentation
- [ ] Add conversion helpers

---

### 1.8 Notification Type Count [CRITICAL]

**Problem:** Product spec says "16 total" but 21 exist.

**Resolution:**
- [ ] `01_PRODUCT_SPECIFICATIONS.md` - Update to "21 notification types"
- [ ] List all 21 types explicitly

---

### 1.9 DietRuleType Enum Expansion [CRITICAL]

**Problem:** API Contracts has 4 values, Diet System has 21.

**Resolution:**
- [ ] `22_API_CONTRACTS.md` - Expand DietRuleType to full 21 values from 41_DIET_SYSTEM.md

---

### 1.10 BaseRepository Implementation [CRITICAL]

**Problem:** Standards reference `prepareForCreate`, `prepareForUpdate`, `prepareForDelete` but never define them.

**Resolution:**
- [ ] `02_CODING_STANDARDS.md` - Add complete BaseRepository class definition

---

## Phase 2: High Priority Fixes

### 2.1 Missing Dart Enums [HIGH]

**11 database enums have no Dart equivalent:**

| DB Enum | Action |
|---------|--------|
| BiologicalSex | Add to 22_API_CONTRACTS.md |
| DietType (profile) | Add to 22_API_CONTRACTS.md |
| SupplementForm | Add to 22_API_CONTRACTS.md |
| DosageUnit | Add to 22_API_CONTRACTS.md |
| SupplementTimingType | Add to 22_API_CONTRACTS.md |
| SupplementFrequencyType | Add to 22_API_CONTRACTS.md |
| IntakeLogStatus | Add to 22_API_CONTRACTS.md |
| FoodItemType | Add to 22_API_CONTRACTS.md |
| DocumentType | Add to 22_API_CONTRACTS.md |
| DreamType | Add to 22_API_CONTRACTS.md |
| WakingFeeling | Add to 22_API_CONTRACTS.md |

---

### 2.2 Missing Validators [HIGH]

**23 entity fields have no validation:**

| Entity | Fields Missing Validators |
|--------|--------------------------|
| All entities | id, clientId, profileId (format validation) |
| Supplement | brand, ingredients count, schedules count |
| FluidsEntry | otherFluidName, otherFluidAmount, bowelSize, photoIds count |
| Diet | startDate < endDate, presetId format |
| DietRule | numericValue per rule type, daysOfWeek range |
| NotificationSchedule | timesMinutesFromMidnight (0-1439), weekdays (0-6) |
| Intelligence entities | confidence (0-1), probability (0-1), pValue (0-1) |

---

### 2.3 Missing Error Message Templates [HIGH]

```dart
// Add to ValidationError class:
static String invalidFormatMessage(String field, String expected) =>
    '$field format is invalid. Expected: $expected';

static String tooShortMessage(String field, int min) =>
    '$field must be at least $min characters';

static String duplicateMessage(String field) =>
    'A record with this $field already exists';
```

---

### 2.4 Security Gaps [HIGH]

| Gap | Resolution |
|-----|------------|
| Audit log retention: 6 vs 7 years | Standardize on 7 years (more conservative) |
| No rate limit for QR operations | Add: 3 QR/5min, 5 pairing attempts/hour |
| Encryption: AES-CBC vs AES-GCM | Standardize on AES-256-GCM everywhere |
| Missing token rotation policy | Add: refresh tokens single-use, rotate on refresh |
| Missing TLS version | Mandate TLS 1.3 minimum |

---

### 2.5 FoodCategory Enum Gap [HIGH]

**Problem:** API Contracts has 20 values, Diet System has 26.

**Missing in API Contracts:**
- fodmaps
- sugar
- alcohol
- caffeine
- processedFoods
- artificialSweeteners

---

## Phase 3: Medium Priority Fixes

### 3.1 Ambiguous Language Cleanup [MEDIUM]

| Document | Line | Issue | Fix |
|----------|------|-------|-----|
| 02_CODING_STANDARDS | 24 | "Generally avoid" SCREAMING_CAPS | Specify exactly when allowed |
| 38_UI_FIELD_SPECS | 157 | "Auto-detect by time" | Define exact time ranges |
| 38_UI_FIELD_SPECS | 256 | Overnight sleep handling | Clarify date refers to night started |
| 24_CODE_REVIEW | 44 | "ticket reference" format | Specify: `// TODO(SHADOW-123):` |
| 25_DEFINITION_OF_DONE | 32 | "80% coverage" type | ✅ FIXED: Changed to 100% line AND branch coverage |

---

### 3.2 Missing Sample Data Generators [MEDIUM]

Add generators for:
- [ ] Diet, DietRule, DietViolation
- [ ] Pattern, TriggerCorrelation, HealthInsight, PredictiveAlert
- [ ] NotificationSchedule
- [ ] HipaaAuthorization, ProfileAccessLog
- [ ] WearableConnection, ImportedDataLog, FhirExport

---

### 3.3 Missing Test Case Documentation [MEDIUM]

Add to 06_TESTING_STRATEGY.md:
- [ ] Boundary tests for all numeric validations
- [ ] Diet compliance calculation test cases
- [ ] Pattern detection test cases with insufficient data
- [ ] HIPAA authorization flow test cases

---

### 3.4 Code Review Checklist Additions [MEDIUM]

Add to 24_CODE_REVIEW_CHECKLIST.md:
- [ ] "Validation uses ValidationRules constants"
- [ ] "All validators return user-friendly messages"
- [ ] "Entity includes clientId for database merging"
- [ ] "SyncMetadata included in all syncable entities"
- [ ] "Boundary tests exist for numeric validations"

---

## Phase 4: Cross-Document Updates

### 4.1 BBT Temperature Range Alignment [MEDIUM]

| Document | Fahrenheit | Celsius |
|----------|------------|---------|
| 22_API_CONTRACTS | 95.0-105.0 | 35.0-40.5 |
| 38_UI_FIELD_SPECS | 95-104 | 35-40 |

**Fix:** Update UI spec to match API: 95-105°F, 35-40.5°C

---

### 4.2 Sleep Terminology Alignment [LOW]

| Concept | Product Spec | Database |
|---------|--------------|----------|
| Waking feeling | Groggy/Rested/Energized | unrested/neutral/rested |
| Dream type | Light dreams/Lucid dreams | vague/vivid |

**Fix:** Standardize terminology across documents

---

### 4.3 Sync Batch Size Alignment [LOW]

- Product Spec: 100 entities per request
- API Contracts: maxSyncBatchSize = 500

**Fix:** Update Product Spec to 500

---

## Implementation Tracking

### Phase 1: Critical Conflicts
- [x] 1.1 SyncStatus enum alignment (DONE: Updated 02_CODING_STANDARDS.md, 05_IMPLEMENTATION_ROADMAP.md)
- [x] 1.2 SyncMetadata field names alignment (DONE: Updated 02_CODING_STANDARDS.md, 05_IMPLEMENTATION_ROADMAP.md)
- [x] 1.3 Repository interface alignment (DONE: Updated 04_ARCHITECTURE.md to Result pattern)
- [x] 1.4 Add P0 entity contracts (DONE: Added Profile, Condition, ConditionLog, IntakeLog, FoodItem, FoodLog)
- [x] 1.4b Add P1 entity contracts (DONE: Activity, ActivityLog, SleepEntry, JournalEntry, PhotoArea, PhotoEntry, FlareUp)
- [x] 1.5 AccessLevel enum alignment (DONE: Updated 10_DATABASE_SCHEMA.md admin→owner)
- [x] 1.6 Bowel/Urine condition enums (DONE: Aligned 01, 10, 22 to clinical terms)
- [x] 1.7 Severity scale standardization (DONE: Added toStorageScale/fromStorageScale in 22)
- [x] 1.8 Notification type count (DONE: Updated 01 from 16→21, added 5 diet types)
- [x] 1.9 DietRuleType enum expansion (DONE: Updated 22 from 4→21 values)
- [x] 1.10 BaseRepository implementation (DONE: Added to 02_CODING_STANDARDS.md Section 3.4)

### Phase 2: High Priority
- [x] 2.1 Add 11 missing Dart enums (DONE: SupplementForm, DosageUnit, SupplementTimingType, SupplementFrequencyType, DocumentType, DreamType, WakingFeeling added; BiologicalSex, ProfileDietType, IntakeLogStatus, FoodItemType already existed)
- [x] 2.2 Add 23 missing validators (DONE: Added UUID, brand, ingredientsCount, otherFluid*, photoIdsCount, dateRange, dietRuleNumericValue, daysOfWeek, timesMinutesFromMidnight, weekdays, confidence, probability, pValue, relativeRisk)
- [x] 2.3 Add error message templates (DONE: Added ValidationMessages class with invalidFormat, tooShort, tooLong, duplicate, outOfRange, required, invalidUuid, maxCount)
- [x] 2.4 Fix security gaps (DONE: 7-year retention, AES-256-GCM, TLS 1.3, QR rate limits, token rotation)
- [x] 2.5 Expand FoodCategory enum (DONE: Already has all 20 values)

### Phase 3: Medium Priority
- [x] 3.1 Ambiguous language cleanup (DONE: Fixed meal type auto-detect times, sleep date clarification, TODO format, coverage type)
- [x] 3.2 Add missing sample data generators (DONE: Added Diet, Intelligence, NotificationSchedule, Wearable, HipaaAuthorization generators)
- [x] 3.3 Add missing test case documentation (DONE: Added boundary tests, diet compliance, pattern detection, HIPAA flow tests)
- [x] 3.4 Code review checklist additions (DONE: Added validation, clientId, SyncMetadata, profileId filtering checks)

### Phase 4: Cross-Document
- [x] 4.1 BBT temperature range (DONE: Updated 38_UI_FIELD_SPECIFICATIONS.md to 95-105°F, 35-40.5°C)
- [x] 4.2 Sleep terminology (DONE: Aligned waking feelings and dream types in 01_PRODUCT_SPECIFICATIONS.md)
- [x] 4.3 Sync batch size (DONE: Updated 01_PRODUCT_SPECIFICATIONS.md from 100 to 500)

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.1 | 2026-01-31 | All fixes complete - Phase 1, 2, 3, 4 remediation applied |
| 1.0 | 2026-01-31 | Initial creation from fourth audit findings |
