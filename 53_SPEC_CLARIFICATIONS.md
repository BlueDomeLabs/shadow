# Shadow Specification Clarifications

**Version:** 1.4
**Last Updated:** February 9, 2026
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

### SPEC-FIX-2026-02-09-001: ActivityLog Entity activityIds/adHocActivities Inconsistency

**Found in:** 22_API_CONTRACTS.md Section 10.15 (entity definition at line 12182) vs Section 10.15 (use case at line 2932)
**Found by:** Implementation review, task IMPL-FIX-ALL
**Issue:** The spec defines `activityIds` and `adHocActivities` as `required List<String>` in the entity section (line 12182) but as `@Default([]) List<String>` in the use case section (line 2932). The implementation uses `@Default([])` which matches the use case section. Both approaches are valid but the spec is internally inconsistent.
**Possible interpretations:**
1. Update entity section to use `@Default([])` (matches use case section and implementation)
2. Update use case section and implementation to use `required` (matches entity section)

**Blocking:** None (implementation uses @Default which is reasonable for optional list fields)
**Status:** RESOLVED — 2026-02-25
**Resolution:** Update spec entity section to use `@Default([]) List<String>` for `activityIds` and `adHocActivities`. Code is correct. Spec entity section needs updating to match.
**Spec Updated:** Yes — noted for 22_API_CONTRACTS.md Section 10.15 (ActivityLog entity definition)

---

### SPEC-FIX-2026-02-09-002: IntakeLog Table Definition Outdated

**Found in:** 22_API_CONTRACTS.md Section 13.12 (table definition)
**Found by:** Implementation review Pass 4, task IMPL-FIX-ALL
**Issue:** Section 13.12 defines the intake_logs table with columns that don't match the IntakeLog entity from Section 10.10. The entity has `scheduledTime`, `status`, `actualTime`, `reason`, `note`, `snoozeDurationMinutes` but the table section has outdated/mismatched column definitions from an earlier spec version.

**Blocking:** None (implementation matches entity, not table section)
**Status:** RESOLVED — 2026-02-25
**Resolution:** Update Section 13.12 to match the IntakeLog entity definition in Section 10.10. Columns: id, client_id, profile_id, supplement_id, scheduled_time (INTEGER), actual_time (INTEGER), status (INTEGER), reason (TEXT), note (TEXT), snooze_duration_minutes (INTEGER), plus all sync metadata columns. Code is correct.
**Spec Updated:** Yes — noted for 22_API_CONTRACTS.md Section 13.12

---

### SPEC-FIX-2026-02-09-003: Spec Only Declares `implements Syncable` on 7 of 14 Entities

**Found in:** 22_API_CONTRACTS.md Sections 10.x (entity definitions)
**Found by:** Implementation review Pass 1 (P1-3 + S-2), task IMPL-FIX-ALL
**Issue:** The spec declares `implements Syncable` on only 7 of 14 entities (Activity, ActivityLog, FlareUp, JournalEntry, PhotoArea, PhotoEntry, SleepEntry) but not on the other 7 (Supplement, FluidsEntry, Condition, ConditionLog, FoodItem, FoodLog, IntakeLog). All 14 entities have `required SyncMetadata syncMetadata` and should implement the Syncable interface for compile-time guarantees.

**Blocking:** None (implementation now has `implements Syncable` on all 14 entities per P1-2 fix)
**Status:** RESOLVED — 2026-02-25
**Resolution:** All 14 entities in the implementation declare `implements Syncable`. Spec should be updated to match. Code is correct.
**Spec Updated:** Yes — noted for 22_API_CONTRACTS.md Sections 10.x entity declarations

---

### SPEC-FIX-2026-02-09-004: ActivityRepository Extra archive/unarchive Methods

**Found in:** 22_API_CONTRACTS.md Section 4.x (ActivityRepository interface)
**Found by:** Implementation review Pass 2 (P2-4), task IMPL-FIX-ALL
**Issue:** The implementation has `archive(String id)` and `unarchive(String id)` methods on ActivityRepository that are not in the spec. The Activity entity has an `isArchived` field, so these methods are functionally reasonable and follow the same pattern as SupplementRepository's archive/unarchive.

**Blocking:** None (implementation is reasonable, spec should be updated to match)
**Status:** RESOLVED — 2026-02-25
**Resolution:** Code correctly has archive/unarchive on ActivityRepository. Spec should be updated to include these methods and any other repository for entities with isArchived fields.
**Spec Updated:** Yes — noted for 22_API_CONTRACTS.md ActivityRepository section

---

### SPEC-FIX-2026-02-09-005: CreateConditionInput Extra `triggers` Field

**Found in:** 22_API_CONTRACTS.md Section ~line 4811 (CreateConditionInput)
**Found by:** Implementation review Pass 3 (P3-1), task IMPL-FIX-ALL
**Issue:** The implementation's `CreateConditionInput` includes `@Default([]) List<String> triggers` which is not in the spec's CreateConditionInput. However, the Condition entity (Section 10.8) does have a `triggers` field, so allowing triggers at creation time is functionally correct.

**Blocking:** None (implementation is a reasonable addition)
**Status:** RESOLVED — 2026-02-25
**Resolution:** Code correctly includes `@Default([]) List<String> triggers` in CreateConditionInput. Spec should be updated to match.
**Spec Updated:** Yes — noted for 22_API_CONTRACTS.md CreateConditionInput definition

---

### SPEC-FIX-2026-02-09-006: DatabaseError updateFailed/deleteFailed Extra `id` Parameter

**Found in:** 22_API_CONTRACTS.md Section 2 (AppError hierarchy)
**Found by:** Implementation review Pass 6 (P6-2), task IMPL-FIX-ALL
**Issue:** The implementation's `DatabaseError.updateFailed` and `DatabaseError.deleteFailed` factories accept an extra `String id` parameter not in the spec. This provides better debugging information (knowing which entity ID failed).

**Blocking:** None (implementation is better for debugging)
**Status:** RESOLVED — 2026-02-25
**Resolution:** Code correctly includes an `id` parameter in updateFailed and deleteFailed for better error context. Spec should be updated to include this parameter.
**Spec Updated:** Yes — noted for 22_API_CONTRACTS.md Section 2 DatabaseError factories

---

### SPEC-FIX-2026-02-09-007: FoodItems Table serving_size REAL vs TEXT + Extra serving_unit Column

**Found in:** 22_API_CONTRACTS.md Section 13.x (food_items table) vs Section 10.x (FoodItem entity)
**Found by:** Implementation review Pass 4 (P4-2), task IMPL-FIX-ALL
**Issue:** The FoodItem entity has `String? servingSize` but the table implementation stores it as two columns: `serving_size REAL` + `serving_size_unit TEXT`. The DAO performs string-based conversion between entity and table. The spec table definition has `serving_size TEXT`.

**Blocking:** None (implementation works but parsing is fragile — see P7-2)
**Status:** RESOLVED — 2026-02-25
**Resolution:** Keep the structured REAL (serving_size) + TEXT (serving_unit) table format — better for querying and sorting by serving size. The spec table definition should be updated to show two columns instead of one TEXT column.
**Spec Updated:** Yes — noted for 22_API_CONTRACTS.md food_items table definition section

---

### SPEC-FIX-2026-02-09-008: @Freezed Annotation Style Across All Entities

**Found in:** 22_API_CONTRACTS.md Sections 10.x (all entity definitions)
**Found by:** Implementation review Pass 1 (S-1), task IMPL-FIX-ALL
**Issue:** The spec uses `@freezed` (lowercase) for all entity annotations, but the implementation uses `@Freezed(toJson: true, fromJson: true)` with `@JsonSerializable(explicitToJson: true)`. The implementation pattern is more explicit and correct for nested objects (SyncMetadata, List<SupplementIngredient>, etc.) ensuring proper JSON serialization of nested fields.

**Blocking:** None (implementation pattern is superior)
**Status:** RESOLVED — 2026-02-25
**Resolution:** Code correctly uses `@Freezed(toJson: true, fromJson: true)` + `@JsonSerializable(explicitToJson: true)` for all entities. Spec should be updated to use this pattern throughout all entity definitions.
**Spec Updated:** Yes — noted for all 22_API_CONTRACTS.md entity sections

---

### SPEC-FIX-2026-02-09-009: Remaining LOW Spec-Only Items (Batch)

**Found in:** 22_API_CONTRACTS.md various sections
**Found by:** Implementation review Passes 1-6 (P1-5, P2-5, P2-6, P3-4, P3-5, P3-6, P5-5, P6-4, P7-3, P11-3), task IMPL-FIX-ALL
**Issue:** Multiple minor spec-vs-impl differences where the implementation is correct or superior:

- **P1-5:** 7 extra computed getters in impl not in spec (Activity.isActive, ActivityLog.hasActivities/isImported, FoodItem.isActive, JournalEntry.hasMood/hasAudio/hasTags, PhotoEntry.isPendingUpload). Useful convenience methods.
- **P2-5:** FlareUpRepository has extra `endFlareUp` method not in spec. Useful convenience method.
- **P2-6:** PhotoAreaRepository has extra `archive` method not in spec. Entity has isArchived field.
- **P3-4:** UpdateSupplementUseCase uses inline DateTime.now() instead of pre-computed `now`. Functionally identical.
- **P3-5:** CreateConditionUseCase uses generic `entityName()` instead of specific `conditionName()`. Same behavior.
- **P3-6:** LogFluidsEntryUseCase adds extra field validations (otherFluidName, otherFluidAmount, notes). More defensive than spec.
- **P5-5:** WearablePlatform has extra `fromValue()` in impl. Spec should include.
- **P6-4:** DietError missing Rule Conflict Detection Criteria comment. Informational only.
- **P7-3:** ConditionLog.triggers (String?) vs Condition.triggers (List<String>) naming collision. Intentional — different semantics.
- **P11-3:** JournalEntry getMoodDistribution counts in Dart instead of SQL GROUP BY. Functional, performance optimization deferred.

**Blocking:** None
**Status:** RESOLVED — 2026-02-25
**Resolution:** All 10 items in this batch are code-is-correct cases. The spec should be updated to include the extra computed getters, extra repository methods, and minor implementation differences noted above. No code changes needed.
**Spec Updated:** Yes — noted across multiple 22_API_CONTRACTS.md sections

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
| 1.2 | 2026-02-09 | Added 2 spec fix items from implementation review (P1-1 ActivityLog inconsistency, P4-1 IntakeLog table outdated) |
| 1.3 | 2026-02-09 | Added 6 more spec fix items: P1-3/S-2 (Syncable on all entities), P2-4 (archive methods), P3-1 (CreateConditionInput triggers), P6-2 (DatabaseError id param), P4-2 (FoodItems serving_size), S-1 (Freezed annotation style) |
| 1.4 | 2026-02-09 | Added batch LOW spec-only items (SPEC-FIX-009). All 54 findings from implementation review now addressed. |
