# Spec Review Report - 2026-02-04

**Auditor Instance:** audit-001
**Scope:** 22_API_CONTRACTS.md compliance with 02_CODING_STANDARDS.md

---

## Executive Summary

| Metric | Count |
|--------|-------|
| Sections audited | 3 (Entities, Use Cases, Error Handling) |
| Compliant areas | 12 |
| Violations found | 15 |
| Ambiguities | 10 |
| Critical issues | 3 |

**Overall Assessment:** SIGNIFICANT INCONSISTENCIES between spec documents require resolution.

---

## Critical Finding: Document Architectural Mismatches

The two primary specification documents (22_API_CONTRACTS.md and 02_CODING_STANDARDS.md) have **fundamental inconsistencies** in several areas:

1. **Error Handling Architecture** - Two incompatible systems defined
2. **SyncMetadata/ID Generation** - Conflicting responsibility assignments
3. **Enum Value Standards** - Inconsistent application

These must be resolved before implementations can be considered fully compliant.

---

## Phase 1: Entity Audit Results

### Compliant (7 entities)
- Supplement - All required fields, int timestamps, proper @freezed
- SyncMetadata - Proper @JsonKey annotations, int timestamps
- FluidsEntry - All required fields present
- Diet - Proper structure
- DietRule - Proper structure with enum values
- DietViolation - Proper structure
- SupplementSchedule - Valid as embedded value object

### Violations (6 enums missing explicit int values)

| Enum | Location | Fix Required |
|------|----------|--------------|
| DietPresetType | Line 1356-1377 | Add `final int value` with explicit values |
| DataScope | Line 1594-1606 | Add `final int value` with explicit values |
| AccessLevel | Line 1609-1613 | Add `final int value` (first definition) |
| AuthorizationDuration | Line 1616-1625 | Add `final int value` (first definition - duplicate exists) |
| RuleSeverity | Line 7997 | Add `final int value` with explicit values |
| FoodCategory | Line 7999-8004 | Add `final int value` with explicit values |

### Ambiguities (2)
1. **SupplementIngredient** - Missing id/clientId/profileId/syncMetadata. Is this intentionally a value object?
2. **InsightCategory/InsightPriority** - Missing int values, appears twice in document

---

## Phase 2: Use Case Audit Results

### Compliant (4 areas)
- Authorization check is FIRST step in all use cases
- All methods return Result<T, AppError>
- Input classes use @freezed
- Validation follows authorization

### Violations (3 critical patterns)

#### VIOLATION 1: ID Generation Responsibility Mismatch
**Severity:** HIGH

**API_CONTRACTS pattern (15+ use cases):**
```dart
final id = const Uuid().v4();  // Use case generates ID
```

**CODING_STANDARDS pattern (Section 3.4):**
```dart
final entity = await prepareForCreate(entity, ...);  // Repository generates ID
```

**Affected:** CreateSupplementUseCase, CreateConditionUseCase, LogConditionUseCase, CreateDietUseCase, and 11+ more

#### VIOLATION 2: SyncMetadata Construction Location
**Severity:** HIGH

Use cases construct SyncMetadata with `syncDeviceId: ''` expecting repository to populate it, but this conflicts with the `prepareForCreate()` pattern in CODING_STANDARDS which creates fresh SyncMetadata.

#### VIOLATION 3: SyncVersion Increment in Use Cases
**Severity:** HIGH

Update use cases directly increment `syncVersion` and set `syncIsDirty`, but CODING_STANDARDS delegates this to `prepareForUpdate()` in BaseRepository.

### Ambiguities (3)
1. Which document's architecture is canonical for ID/SyncMetadata handling?
2. Should empty `syncDeviceId` trigger validation errors?
3. Should use cases generate timestamps or delegate to repository?

---

## Phase 3: Error Handling Audit Results

### CRITICAL: Incompatible Error Systems

The two documents define **completely different** error handling architectures:

| Aspect | 22_API_CONTRACTS | 02_CODING_STANDARDS |
|--------|------------------|---------------------|
| Error codes | Semantic (`DB_QUERY_FAILED`) | Numeric (`DB_001`) |
| Construction | Factory methods | Constructors |
| Error classes | 10 classes | 8 classes |
| User messages | 60+ contextual examples | 3 generic examples |

### Violations (6)

1. **Error Code System Mismatch** - CRITICAL
   - API_CONTRACTS: `DB_QUERY_FAILED`, `AUTH_TOKEN_EXPIRED`
   - CODING_STANDARDS: `DB_001`, `AUTH_002`
   - These are completely incompatible

2. **Missing Error Classes in CODING_STANDARDS**
   - WearableError (required for wearable features)
   - DietError (required for diet features)
   - IntelligenceError (required for AI features)
   - BusinessError (required for business logic)

3. **Factory Method Patterns Incompatible**
   - API_CONTRACTS uses semantic factories: `DatabaseError.queryFailed()`
   - CODING_STANDARDS uses constructors: `DatabaseError(code: '...')`

4. **Extra Classes in CODING_STANDARDS Not in API_CONTRACTS**
   - NotFoundError (API_CONTRACTS uses `DatabaseError.notFound()`)
   - UnknownError

5. **RecoveryAction Context Sensitivity**
   - API_CONTRACTS: Per-instance configuration via factories
   - CODING_STANDARDS: Fixed class-level defaults

6. **User Message Guidance Incomplete**
   - API_CONTRACTS: 60+ contextual, actionable examples
   - CODING_STANDARDS: 3 generic examples

### Resolution Note
CODING_STANDARDS Section 7.3 states: "See `22_API_CONTRACTS.md` Section 2 for the complete, authoritative error code registry"

**Recommendation:** Accept API_CONTRACTS Section 2 as authoritative and update CODING_STANDARDS Section 7 to match.

---

## Prioritized Action Items

### Priority 1: Critical (Must Fix)

1. **Resolve Error Handling Architecture**
   - Decision: Use API_CONTRACTS as authoritative
   - Action: Update CODING_STANDARDS Section 7 to match API_CONTRACTS Section 2
   - Add missing error classes (WearableError, DietError, IntelligenceError, BusinessError)
   - Adopt semantic error codes, remove numeric registry

2. **Resolve ID/SyncMetadata Generation Pattern**
   - Decision needed: Use case generates OR repository generates
   - Update whichever document is non-canonical
   - Current implementation follows API_CONTRACTS pattern (use case generates)

3. **Fix Enum Integer Values**
   - Add explicit `final int value` to 6 enums
   - Remove duplicate enum definitions

### Priority 2: High

4. **Clarify SyncMetadata Initialization**
   - Document the empty `syncDeviceId` pattern
   - Add repository validation requirements

5. **Standardize Update Pattern**
   - Decide if validation occurs before or after entity mutation
   - Update spec to match

6. **Document Value Object Pattern**
   - Clarify that SupplementIngredient, SupplementSchedule are value objects
   - Update CODING_STANDARDS Section 5 to distinguish entities from value objects

### Priority 3: Medium

7. **Add fromException() Factories**
   - Add explicit exception conversion factories to all error types

8. **Document Feature-Error Mapping**
   - Which error type to use for which feature area

9. **Consolidate Duplicate Definitions**
   - AuthorizationDuration appears twice
   - AccessLevel appears twice
   - InsightCategory/InsightPriority appear twice

10. **Update User Message Guidelines**
    - Reference API_CONTRACTS examples in CODING_STANDARDS

---

## Verification Status

- Tests: PASSING (implementations are functional)
- Analyzer: CLEAN
- Format: COMPLIANT

Note: Implementations currently follow API_CONTRACTS patterns, which is why they work. The CODING_STANDARDS document is the one that needs updating.

---

## Recommendations

### Immediate Actions

1. **Create ADR-001: Error Handling Architecture**
   - Document decision that API_CONTRACTS Section 2 is authoritative
   - Plan CODING_STANDARDS Section 7 update

2. **Create ADR-002: ID/SyncMetadata Generation**
   - Document decision on where IDs are generated
   - Current: Use case (API_CONTRACTS pattern)
   - Alternative: Repository (CODING_STANDARDS pattern)

3. **Fix Enum Violations**
   - Quick fix: Add int values to 6 enums in API_CONTRACTS
   - Estimated effort: 1 hour

### Follow-up Actions

4. **Update CODING_STANDARDS Section 7**
   - Major rewrite to match API_CONTRACTS
   - Estimated effort: 4-6 hours

5. **Add Value Object Documentation**
   - Update Section 5 of CODING_STANDARDS
   - Estimated effort: 1 hour

---

## Files Reviewed

- `/Users/reidbarcus/Development/Shadow/22_API_CONTRACTS.md`
- `/Users/reidbarcus/Development/Shadow/02_CODING_STANDARDS.md`

## Report Generated

- Date: 2026-02-04
- Instance: audit-001
- Phase: Spec Review (Part of Comprehensive Audit)
