# FLUIDS_RESTRUCTURING_SPEC.md
# Shadow — Bodily Output Tracking Restructuring
# Prerequisite Phase for Phase 19 (Voice Logging)
# Status: DRAFT — Awaiting Reid approval before implementation begins
# Last Updated: 2026-03-06
# Author: The Architect

---

## Why This Exists

`fluids_entries` was originally named `bowel_urine_entries` and was designed to track
bodily outputs. Over time it absorbed water/beverage intake, menstruation, and BBT —
items that don't belong together under one concept. Two separate problems resulted:

1. **Conceptual mismatch:** "Fluids" in the app means bodily outputs — urine, bowel
   movements, gas, menstruation, BBT. But the word "fluids" collides with the natural
   meaning of drinking water or coffee, which are food/intake items, not outputs.

2. **Structural mismatch:** `fluids_entries` is a one-row-per-day aggregate. This is
   wrong for bodily outputs — if you urinate three times in a day, that is three
   events, not a field on a daily row. The aggregate model makes querying individual
   events awkward and makes time-of-event tracking impossible.

This spec corrects both problems cleanly before Phase 19 begins. Voice logging needs
these domains to be clearly separated and correctly modeled.

---

## Summary of Changes

| Domain | Before | After |
|--------|--------|-------|
| Bowel, urine, gas, menstruation, BBT, custom | `fluids_entries` (daily aggregate) | `bodily_output_logs` (one row per event) |
| Water and beverages | `fluids_entries.water_intake_ml` | `food_logs` via `FoodItem` records (same as food) |
| Notification category | `fluids` | `bodilyOutputs` |
| Domain entity | `FluidsEntry` | `BodilyOutputLog` |
| Repository | `FluidsRepository` | `BodilyOutputRepository` |
| List screen | `FluidsListScreen` | `BodilyOutputListScreen` |
| Use cases | `LogFluidsUseCase`, `GetFluidsUseCase` etc. | `LogBodilyOutputUseCase`, `GetBodilyOutputsUseCase` etc. |

---

## 1. New Table: bodily_output_logs

Replaces `fluids_entries`. One row per individual output event.

```
Schema version: v20 (added in this phase)
Syncs to Google Drive: YES (health data)
```

### 1.1 SQL Definition

```sql
CREATE TABLE bodily_output_logs (
  id TEXT NOT NULL PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  occurred_at INTEGER NOT NULL,     -- Epoch ms when event occurred

  -- Output type (required)
  output_type INTEGER NOT NULL,     -- BodyOutputType enum — see 1.2

  -- Custom type (output_type = 5 only)
  custom_type_label TEXT,           -- User-defined label, max 60 chars

  -- Urine fields (output_type = 0)
  urine_condition INTEGER,          -- UrineCondition enum — see 1.3
  urine_custom_condition TEXT,      -- Free text when urine_condition = 7 (custom)
  urine_size INTEGER,               -- OutputSize enum: 0=tiny 1=small 2=medium 3=large 4=huge

  -- Bowel fields (output_type = 1)
  bowel_condition INTEGER,          -- BowelCondition enum — see 1.3
  bowel_custom_condition TEXT,      -- Free text when bowel_condition = 6 (custom)
  bowel_size INTEGER,               -- OutputSize enum (same as urine_size)

  -- Gas fields (output_type = 2)
  gas_severity INTEGER,             -- GasSeverity enum: 0=mild 1=moderate 2=severe (optional)

  -- Menstruation fields (output_type = 3)
  menstruation_flow INTEGER,        -- MenstruationFlow enum: 0=spotting 1=light 2=medium 3=heavy

  -- BBT fields (output_type = 4)
  temperature_value REAL,           -- Temperature reading
  temperature_unit INTEGER,         -- TemperatureUnit enum: 0=celsius 1=fahrenheit

  -- Shared optional fields (all types)
  notes TEXT,

  -- Photo (for bowel and urine documentation)
  photo_path TEXT,
  cloud_storage_url TEXT,
  file_hash TEXT,
  file_size_bytes INTEGER,
  is_file_uploaded INTEGER DEFAULT 0,

  -- Import tracking
  import_source TEXT,
  import_external_id TEXT,

  -- Sync metadata
  sync_created_at INTEGER NOT NULL,
  sync_updated_at INTEGER,
  sync_deleted_at INTEGER,
  sync_last_synced_at INTEGER,
  sync_status INTEGER DEFAULT 0,
  sync_version INTEGER DEFAULT 1,
  sync_device_id TEXT,
  sync_is_dirty INTEGER DEFAULT 1,
  conflict_data TEXT,

  FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE
);

CREATE INDEX idx_bodily_output_occurred ON bodily_output_logs(occurred_at DESC);
CREATE INDEX idx_bodily_output_profile_date ON bodily_output_logs(profile_id, occurred_at DESC);
CREATE INDEX idx_bodily_output_type ON bodily_output_logs(profile_id, output_type, occurred_at DESC);
CREATE INDEX idx_bodily_output_sync ON bodily_output_logs(sync_is_dirty, sync_status)
  WHERE sync_deleted_at IS NULL;
CREATE INDEX idx_bodily_output_menstruation ON bodily_output_logs(profile_id, occurred_at DESC)
  WHERE output_type = 3;
CREATE INDEX idx_bodily_output_bbt ON bodily_output_logs(profile_id, occurred_at DESC)
  WHERE output_type = 4;
```

### 1.2 BodyOutputType Enum

```dart
enum BodyOutputType {
  urine(0),
  bowel(1),
  gas(2),
  menstruation(3),
  bbt(4),
  custom(5);

  const BodyOutputType(this.value);
  final int value;
}
```

### 1.3 Supporting Enums (carried over from fluids_entries, unchanged)

**BowelCondition:** 0=diarrhea · 1=runny · 2=loose · 3=normal · 4=firm · 5=hard · 6=custom

**UrineCondition:** 0=clear · 1=lightYellow · 2=yellow · 3=darkYellow · 4=amber · 5=brown · 6=red · 7=custom

**MenstruationFlow:** 0=spotting · 1=light · 2=medium · 3=heavy

**OutputSize:** 0=tiny · 1=small · 2=medium · 3=large · 4=huge

**GasSeverity:** 0=mild · 1=moderate · 2=severe

**TemperatureUnit:** Already exists in `UserSettings` — reuse the same enum.

### 1.4 Domain Entity

```dart
@freezed
class BodilyOutputLog with _$BodilyOutputLog {
  const factory BodilyOutputLog({
    required String id,
    required String clientId,
    required String profileId,
    required int occurredAt,             // epoch ms
    required BodyOutputType outputType,
    String? customTypeLabel,
    // Urine
    UrineCondition? urineCondition,
    String? urineCustomCondition,
    OutputSize? urineSize,
    // Bowel
    BowelCondition? bowelCondition,
    String? bowelCustomCondition,
    OutputSize? bowelSize,
    // Gas
    GasSeverity? gasSeverity,
    // Menstruation
    MenstruationFlow? menstruationFlow,
    // BBT
    double? temperatureValue,
    TemperatureUnit? temperatureUnit,
    // Shared
    String? notes,
    String? photoPath,
    required SyncMetadata syncMetadata,
  }) = _BodilyOutputLog;
}
```

---

## 2. Beverages Move to food_logs

Water and beverages are food intake. They log exactly like food — via `FoodItem` records
and `LogFoodUseCase`. No schema change to `food_logs` is needed.

### 2.1 meal_type Enum Addition

`food_logs.meal_type` currently has: 0=breakfast · 1=lunch · 2=dinner · 3=snack

Add: **4=beverage**

This allows filtering beverage intake separately from meals in history views.
Schema migration: add `beverage` value to the `MealType` enum in Dart.
No column change needed — it's just a new enum value for the existing INTEGER column.

### 2.2 Seed FoodItem Records

At first launch (or on upgrade), seed the following default `FoodItem` records
into each profile's food_items table so users can immediately log common beverages:

| Name | Type | Notes |
|------|------|-------|
| Water | simple | serving_unit=ml, serving_size=240 |
| Coffee | simple | serving_unit=ml, serving_size=240 |
| Tea | simple | serving_unit=ml, serving_size=240 |
| Juice | simple | serving_unit=ml, serving_size=240 |

These are seeded as `is_user_created=0` so they can be distinguished from
user-created items. Users can edit, archive, or add their own variants.

**Note:** The existing `food_items` table already has all necessary columns for this.
No schema change required for food_items.

---

## 3. Notification Category Rename

The existing `NotificationCategory.fluids` category is renamed to
`NotificationCategory.bodilyOutputs`.

| Before | After | Notification seeded text |
|--------|-------|--------------------------|
| `fluids` | `bodilyOutputs` | "Time to log your output" |

The 8 notification categories seeded at first launch are updated accordingly.
`NotificationSeedService` is updated to seed `bodilyOutputs` in place of `fluids`.

**Migration for existing installations:**
Existing `notification_category_settings` rows with the old `fluids` category integer
value must be updated to the new `bodilyOutputs` value in the schema migration.

The old `fluids` integer value must be preserved during migration — do not reuse it
for a different category. Mark it as a tombstoned value in the enum:

```dart
enum NotificationCategory {
  // ... other categories ...
  bodilyOutputs(X),    // new value — replaces fluids
  // fluids(OLD_VALUE) — tombstoned, do not reuse
}
```

**Note:** The exact integer values for `NotificationCategory` must be read from the
actual codebase before writing the migration. Shadow must check
`lib/domain/entities/notification_category.dart` before implementing.

---

## 4. Use Cases

### New use cases in `lib/domain/usecases/bodily_output/`

| Use Case | Method signature | Description |
|----------|-----------------|-------------|
| `LogBodilyOutputUseCase` | `execute(String profileId, BodilyOutputLog log)` | Log a single output event |
| `GetBodilyOutputsUseCase` | `execute(String profileId, {int? from, int? to, BodyOutputType? type})` | Query output history with optional filters |
| `UpdateBodilyOutputUseCase` | `execute(String profileId, BodilyOutputLog log)` | Update an existing output log |
| `DeleteBodilyOutputUseCase` | `execute(String profileId, String id)` | Soft-delete an output log |

All use cases: validate profile access first. All return `Result<T, AppError>`.

### Retired use cases

`LogFluidsUseCase`, `GetFluidsUseCase`, `UpdateFluidsUseCase`, `DeleteFluidsUseCase`
are removed and replaced by the above.

---

## 5. Repository

**Interface:** `lib/domain/repositories/bodily_output_repository.dart`

```dart
abstract class BodilyOutputRepository {
  Future<Result<void, AppError>> log(BodilyOutputLog entry);
  Future<Result<List<BodilyOutputLog>, AppError>> getAll(
    String profileId, {int? from, int? to, BodyOutputType? type});
  Future<Result<BodilyOutputLog, AppError>> getById(String id);
  Future<Result<void, AppError>> update(BodilyOutputLog entry);
  Future<Result<void, AppError>> delete(String profileId, String id);
}
```

**Implementation:** `lib/data/repositories/bodily_output_repository_impl.dart`

**DAO:** `lib/data/datasources/local/daos/bodily_output_dao.dart`

**Drift table:** `lib/data/datasources/local/tables/bodily_output_logs_table.dart`

---

## 6. Migration Strategy

Schema version bumps from v19 → v20.

### Migration steps (executed in order)

```
Step 1: CREATE TABLE bodily_output_logs (new schema — Section 1.1)

Step 2: Migrate existing fluids_entries rows to bodily_output_logs
        For each fluids_entries row:

        a) If has_bowel_movement = 1:
           INSERT one bodily_output_logs row with output_type=1 (bowel),
           occurred_at = entry_date,
           bowel_condition, bowel_custom_condition, bowel_size copied directly,
           notes from fluids_entries.notes,
           photo_path from bowel_photo_path

        b) If has_urine_movement = 1:
           INSERT one bodily_output_logs row with output_type=0 (urine),
           occurred_at = entry_date,
           urine_condition, urine_custom_condition, urine_size copied directly,
           photo_path from urine_photo_path

        c) If menstruation_flow IS NOT NULL AND menstruation_flow > 0:
           INSERT one bodily_output_logs row with output_type=3 (menstruation),
           occurred_at = entry_date,
           menstruation_flow copied directly

        d) If basal_body_temperature IS NOT NULL:
           INSERT one bodily_output_logs row with output_type=4 (bbt),
           occurred_at = bbt_recorded_time (if not null) else entry_date,
           temperature_value = basal_body_temperature,
           temperature_unit = user's current temperature_unit from user_settings

        e) If other_fluid_name IS NOT NULL:
           INSERT one bodily_output_logs row with output_type=5 (custom),
           occurred_at = entry_date,
           custom_type_label = other_fluid_name,
           notes = other_fluid_amount || ' — ' || other_fluid_notes (concatenated)

        All migrated rows: sync_created_at from fluids_entries.sync_created_at,
        sync_status = 0 (pending re-sync), sync_is_dirty = 1, id = new UUID v4

Step 3: water_intake_ml data is NOT migrated to food_logs.
        Reason: FoodItem records don't exist yet for water, and the daily aggregate
        amount (e.g. 1200ml) cannot be meaningfully split into individual food_log
        entries retroactively. Historical water intake data from fluids_entries is
        silently dropped on migration. This is acceptable — it is legacy data under
        the old model. A migration note is logged to the app's diagnostic log.

Step 4: UPDATE notification_category_settings SET category = <bodilyOutputs value>
        WHERE category = <old fluids value>

Step 5: fluids_entries table is NOT dropped — it is left in place as a tombstone
        so the migration can be verified and rolled back if needed. It will be
        dropped in a future cleanup phase (v21 or later).
```

### Rollback

If migration fails at any step, the transaction rolls back entirely.
`bodily_output_logs` is dropped. `fluids_entries` is untouched.

---

## 7. UI Changes

### Screens to update

| Screen | Change |
|--------|--------|
| `FluidsListScreen` | Rename to `BodilyOutputListScreen`. Update to display one row per event (not daily aggregate). Group by day for readability. |
| `FluidsEditScreen` (if exists) | Rename to `BodilyOutputEditScreen`. Update form for new per-event model. |
| Quick-entry sheet (Phase 13c) | Update the fluids quick-entry sheet to log per-event via `LogBodilyOutputUseCase`. |
| Home tab | Rename "Fluids" tab label to "Output" or "Body Output" — Reid to confirm final label. **OPEN DECISION #1** |
| Notification category settings | Update label from "Fluids" to "Body Output" (matching tab label). |

### New UI: Beverage logging

No new screen needed. Water and beverages are logged through the existing
`FoodLogScreen` using `MealType.beverage`. The food log history view should
optionally filter by `MealType.beverage` to show a clean "Beverages" view.
This filtering is a UI improvement that can be deferred — not required for this phase.

---

## 8. Tests Required

| Area | Minimum test count |
|------|--------------------|
| `BodilyOutputLog` entity (freezed) | 5 |
| `BodilyOutputDao` (CRUD + filters by type, by date) | 15 |
| `BodilyOutputRepositoryImpl` | 10 |
| `LogBodilyOutputUseCase` | 8 |
| `GetBodilyOutputsUseCase` | 8 |
| `UpdateBodilyOutputUseCase` | 5 |
| `DeleteBodilyOutputUseCase` | 5 |
| Migration (v19 → v20 data integrity) | 8 |
| `BodilyOutputListScreen` widget tests | 10 |
| **Total minimum** | **~74** |

---

## 9. Open Decisions

| # | Decision | Owner | Blocking? |
|---|----------|-------|-----------|
| 1 | What is the final label for the renamed tab? "Output"? "Body Output"? "Outputs"? | Reid | No — can be decided during implementation |
| 2 | Should gas severity be required or optional when logging gas? | Reid | No — spec'd as optional; confirm during implementation |

---

## 10. Phase Sequencing

This restructuring is a **prerequisite for Phase 19 (Voice Logging)**. The sequencing is:

```
[Groups A, B, L audit fixes] → [Fluids Restructuring] → [Phase 19: Voice Logging]
```

Phase 19 implementation does not begin until this phase is complete and verified
by the Architect.

This phase is also a prerequisite for the Groups A, B, L audit fixes only if those
fixes touch `fluids_entries` or related use cases. Shadow must check the audit
findings register before starting to determine if ordering matters.

---

## Document Control

| Version | Date | Author | Notes |
|---------|------|--------|-------|
| 0.1 DRAFT | 2026-03-06 | Architect | Initial draft — awaiting Reid approval |
