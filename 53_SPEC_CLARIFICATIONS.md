# Shadow Specification Clarifications

**Version:** 1.1
**Last Updated:** February 7, 2026
**Purpose:** Track spec ambiguities and their resolutions for instance communication

---

## Purpose

When a Claude instance encounters an ambiguity in the specifications, it documents the ambiguity here. This allows:
1. The user to see what needs clarification
2. Other instances to know what is blocked
3. Resolution to be tracked

---

## Ambiguity Format

```markdown
## AMBIGUITY-YYYY-MM-DD-NNN: [Brief Title]

**Found in:** [Document name and section]
**Found by:** Instance during task [SHADOW-XXX]
**Issue:** [Clear description of the ambiguity]
**Possible interpretations:**
1. [Interpretation 1]
2. [Interpretation 2]
3. [Interpretation 3]

**Blocking:** [Task ID or "None"]
**Status:** AWAITING_CLARIFICATION | RESOLVED
**Resolution:** [If resolved, what was decided]
**Resolution Date:** [Date]
**Spec Updated:** [Yes/No - which document]
```

---

## Active Ambiguities

### RESOLVED-2026-02-07-001: IntakeLog Missing `snoozed` Status

**Found in:** 38_UI_FIELD_SPECIFICATIONS.md Section 4.2 vs 22_API_CONTRACTS.md Section 10.10
**Found by:** Instance during Tier 1 Logging Screens implementation
**Issue:** UI spec defines Status segment with Taken/Skipped/Snoozed + Snooze Duration dropdown (5/10/15/30/60 min), but IntakeLogStatus enum only had pending/taken/skipped/missed. No snoozeDurationMinutes field existed.

**Status:** RESOLVED
**Resolution:** Added `snoozed(4)` to IntakeLogStatus enum, added `int? snoozeDurationMinutes` to IntakeLog entity, added `markSnoozed` repository method and MarkSnoozedUseCase. Snooze is standard in medication reminder apps (Apple Health, Medisafe).
**Resolution Date:** 2026-02-07
**Spec Updated:** Yes - 22_API_CONTRACTS.md Section 10.10, 10_DATABASE_SCHEMA.md Section 4.2

---

### RESOLVED-2026-02-07-002: FoodLog Missing `mealType` Field

**Found in:** 38_UI_FIELD_SPECIFICATIONS.md Section 5.1 vs 22_API_CONTRACTS.md Section 10.12
**Found by:** Instance during Tier 1 Logging Screens implementation
**Issue:** UI spec defines Meal Type segment (Breakfast/Lunch/Dinner/Snack) with auto-detect logic, but FoodLog entity had no mealType field.

**Status:** RESOLVED
**Resolution:** Added `MealType` enum (breakfast(0)/lunch(1)/dinner(2)/snack(3)) and `MealType? mealType` field to FoodLog entity. Meal classification is standard in food logging apps (MyFitnessPal, Cronometer).
**Resolution Date:** 2026-02-07
**Spec Updated:** Yes - 22_API_CONTRACTS.md Section 10.12, 10_DATABASE_SCHEMA.md Section 5.2

---

### RESOLVED-2026-02-07-003: Condition Missing `triggers` List

**Found in:** 38_UI_FIELD_SPECIFICATIONS.md Section 8.2 vs 22_API_CONTRACTS.md Section 10.8
**Found by:** Instance during Tier 1 Logging Screens implementation
**Issue:** UI spec says ConditionLog triggers should populate "from condition's trigger list + Add new", but Condition entity had no `triggers` field. ConditionLog.triggers was free-form String only.

**Status:** RESOLVED
**Resolution:** Added `@Default([]) List<String> triggers` to Condition entity. Stored as JSON array in DB (same pattern as bodyLocations). Predefined trigger lists are standard in condition tracking apps (Flaredown, Symple).
**Resolution Date:** 2026-02-07
**Spec Updated:** Yes - 22_API_CONTRACTS.md Section 10.8, 10_DATABASE_SCHEMA.md Section 9.1

---

### RESOLVED-2026-02-05-001: AppError and `only_throw_errors` Lint Rule Conflict

**Found in:** 22_API_CONTRACTS.md Section 2, 02_CODING_STANDARDS.md Section 6.3
**Found by:** Instance during Phase 3 UI/Presentation Layer implementation
**Issue:** The Riverpod provider pattern throws `AppError` to integrate with `AsyncValue` error handling, but the `only_throw_errors` lint rule requires thrown objects to implement `Exception`.

**Status:** RESOLVED
**Resolution:** Updated spec and implementation to make `AppError implements Exception`. This aligns with:
- Dart best practice (thrown objects should implement Exception)
- The existing pattern in 02_CODING_STANDARDS.md Section 6.3 that throws AppError
- Proper type safety for error handling
**Resolution Date:** 2026-02-05
**Spec Updated:** Yes - 22_API_CONTRACTS.md Section 2

---

### RESOLVED-2026-02-05-002: Riverpod Generated Code Uses Deprecated `FooRef` Types

**Found in:** lib/presentation/providers/di/di_providers.dart (hand-written code using generated types)
**Found by:** Instance during Phase 3 UI/Presentation Layer implementation
**Issue:** Hand-written provider functions were using deprecated `FooRef` parameter types from generated code.

**Status:** RESOLVED
**Resolution:** Updated all hand-written provider functions in `di_providers.dart` to use `Ref` instead of the deprecated `FooRef` types. This is the Riverpod 3.0 forward-compatible pattern. The generated `.g.dart` files are already excluded from lint analysis.
**Resolution Date:** 2026-02-05
**Spec Updated:** No - this was an implementation fix, not a spec issue

---

### RESOLVED-2026-02-03-002: Supplements Table Schema Mismatch

**Found in:** 10_DATABASE_SCHEMA.md Section 4.1
**Found by:** Instance during task IMPLEMENT-SUPPLEMENT-DATA-LAYER
**Issue:** The supplements table schema did not match the Supplement entity definition in 22_API_CONTRACTS.md:
- Missing `name` column (required in entity)
- Missing `notes` column (optional in entity)
- `brand` was NOT NULL but entity has @Default('')
- `ingredients` was NOT NULL but entity has @Default([])
- Schedule columns were denormalized but entity uses `schedules` JSON array
- Enum fields used TEXT instead of INTEGER

**Resolution:** Updated 10_DATABASE_SCHEMA.md supplements table to match entity definition:
- Added `name TEXT NOT NULL`
- Added `notes TEXT DEFAULT ''`
- Changed `brand` to `TEXT DEFAULT ''`
- Changed `ingredients` to `TEXT DEFAULT '[]'`
- Added `schedules TEXT DEFAULT '[]'`
- Changed enum columns to INTEGER type with enum values
- Removed denormalized schedule columns (using JSON array instead)

**Resolution Date:** 2026-02-03
**Spec Updated:** Yes - 10_DATABASE_SCHEMA.md Section 4.1

---

### RESOLVED-2026-02-03-001: BaseRepository Typedef Naming Conflict

**Found in:** 22_API_CONTRACTS.md Section 4.1
**Found by:** Instance during task IMPLEMENT-REPOSITORY-INTERFACES
**Issue:** The spec defined `typedef BaseRepository<T, ID> = EntityRepository<T, ID>` but a class named `BaseRepository<T>` already exists in `lib/core/repositories/base_repository.dart` (helper class with generateId, createSyncMetadata methods). These cannot coexist with the same name.

**Possible interpretations:**
1. Rename the typedef to avoid conflict
2. Rename the existing helper class
3. Move one to a different namespace

**Blocking:** IMPLEMENT-REPOSITORY-INTERFACES
**Status:** RESOLVED
**Resolution:** Renamed typedef from `BaseRepository` to `BaseRepositoryContract` in the spec. The existing helper class in core/repositories keeps its name since it's already in use.
**Resolution Date:** 2026-02-03
**Spec Updated:** Yes - 22_API_CONTRACTS.md Section 4.1

---

## Resolved Ambiguities

### EXAMPLE-2026-02-02-001: Notification Type Count

**Found in:** 01_PRODUCT_SPECIFICATIONS.md, 22_API_CONTRACTS.md, 37_NOTIFICATIONS.md
**Found by:** Audit process
**Issue:** Different documents showed different notification type counts (5, 21, 25)
**Possible interpretations:**
1. Use 5 simple types from database schema
2. Use 21 types from API contracts
3. Use 25 types with full granularity

**Blocking:** SHADOW-038 Notification Service
**Status:** RESOLVED
**Resolution:** Use 25 notification types as defined in 22_API_CONTRACTS.md Section 3.2. All other documents updated to reference this canonical source.
**Resolution Date:** 2026-02-02
**Spec Updated:** Yes - 01_PRODUCT_SPECIFICATIONS.md, 10_DATABASE_SCHEMA.md, 37_NOTIFICATIONS.md all updated to match 22_API_CONTRACTS.md

---

## How to Add a New Ambiguity

1. Create a new section with ID: `AMBIGUITY-{YYYY-MM-DD}-{NNN}`
2. Fill in all fields
3. Update `.claude/work-status/current.json` with blocked status if blocking your work
4. Ask the user for clarification
5. DO NOT proceed with implementation until resolved

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-02-02 | Initial release with resolved notification type example |
| 1.1 | 2026-02-07 | Added 3 UI-spec-to-API-spec gap resolutions (snoozed status, mealType, triggers) |
