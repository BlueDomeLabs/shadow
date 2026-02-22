# 59a — Food Database Extension (Three Item Types)
**Status:** PLANNED — Not yet implemented
**Target Phase:** Phase 15 pre-work (implement before 59_DIET_TRACKING.md)
**Created:** 2026-02-22
**Depends on:** Existing food_items table (schema v9)
**Required by:** 59_DIET_TRACKING.md (barcode scanning and ingredient compliance checking)

---

## Overview

The Shadow food database currently supports two item types: Simple and Composed. This document defines a third type — Packaged — to support products with barcodes, manufacturer ingredients lists, and nutritional data sourced from Open Food Facts or scanned via the Claude API photo scanner.

This is a non-breaking extension. Simple and Composed items are unchanged. All new fields are optional and nullable so existing data is unaffected.

Additionally, this document corrects a gap identified in audit: nutritional fields (calories, carbs, fat, protein, fiber, sugar) exist in the entity and database but are not exposed in the UI for any food type. This extension adds full nutritional data entry to all three types.

---

## Food Item Types — Formal Definition

### Type 0: Simple
A single whole food or ingredient. User-created. No barcode. No sub-ingredients.

**Examples:** Grilled Chicken, Brown Rice, Olive Oil, Apple, Cheddar Cheese

**Required fields:** name
**Optional fields:** serving_size, calories, carbs, fat, protein, fiber, sugar, sodium, notes
**Not applicable:** barcode, brand, ingredients_text, simple_item_ids, open_food_facts_id, import_source, image_url

---

### Type 1: Composed
A recipe or dish made from Simple food items already in the Shadow library. Stores references to Simple item IDs with a quantity multiplier for each. Nutritional values are never entered manually — they are always auto-calculated by summing the component Simple items.

**Examples:** Chicken Stir Fry (composed of Chicken + Broccoli + Soy Sauce), Breakfast Smoothie

**Required fields:** name, at least one component (simple_item_id + quantity)
**Calculated read-only fields:** calories, carbs, fat, protein, fiber, sugar, sodium (auto-summed from components)
**Optional fields:** serving_size, notes
**Not applicable:** barcode, brand, ingredients_text, open_food_facts_id, import_source, image_url

### Composed — Ingredient Selection
Each component in a Composed dish is stored as a pair: a Simple item ID and a quantity multiplier (default: 1). The quantity multiplier is a positive number representing how many servings of that Simple item are used.

**Example:** A recipe using 2 tablespoons of Olive Oil where Olive Oil's serving size is 1 tablespoon → select Olive Oil once, set quantity to 2. The nutritional contribution of Olive Oil to the dish is doubled.

**UI:** Each ingredient row shows the Simple item name, its serving size label, and a quantity number field. User taps "Add Ingredient" to search and select from the Simple items library.

### Composed — Nutritional Auto-Aggregation Rules
Nutritional fields are calculated automatically and shown read-only. The following rules apply strictly:

**All-or-nothing per field:** For any given nutritional field (e.g. calories), if every component Simple item has a value for that field, the Composed dish shows the sum. If any single component is missing that field, the Composed dish shows that field as blank with the note: "Incomplete — one or more ingredients are missing this value."

**Quantity multiplier applied:** Each component's nutritional values are multiplied by its quantity before summing. A component with quantity 2 contributes double its per-serving nutritional values.

**Recalculates automatically:** When the user adds, removes, or changes the quantity of a component, all nutritional fields recalculate immediately.

**No manual override:** Nutritional fields on Composed items are always read-only. The user cannot manually enter or override them. To change the nutritional output, the user must either adjust component quantities, update the Simple item's nutritional data, or add/remove components.

---

### Type 2: Packaged
A manufactured or processed product with a barcode and a manufacturer's ingredients list. Data may be sourced from Open Food Facts (barcode scan), Claude API (photo scan of ingredients label), or entered manually.

**Examples:** KIND Bar Almond & Coconut, Organic Valley Whole Milk, Campbell's Tomato Soup

**Required fields:** name
**Recommended fields:** barcode, brand, ingredients_text
**Optional fields:** serving_size, calories, carbs, fat, protein, fiber, sugar, sodium, open_food_facts_id, import_source, image_url, notes
**Not applicable:** simple_item_ids

---

## Entity Changes

### Updated FoodItemType Enum
```
enum FoodItemType {
  simple,    // value 0 — unchanged
  composed,  // value 1 — unchanged
  packaged,  // value 2 — NEW
}
```

### New Fields on FoodItem Entity
All new fields are nullable (String? or double?) so existing records are unaffected.

| Field | Type | Description |
|---|---|---|
| barcode | String? | UPC or EAN barcode number. Packaged type only. |
| brand | String? | Manufacturer or brand name. Packaged type only. |
| ingredientsText | String? | Raw ingredients list as printed on package label. Packaged type only. Different from simpleItemIds which links to library items. |
| sodium | double? | Sodium in milligrams per serving. All types. |
| openFoodFactsId | String? | Open Food Facts product identifier for re-fetching updated data. Packaged type only. |
| importSource | String? | Where data originated: "open_food_facts", "claude_scan", "manual". Packaged type only. |
| imageUrl | String? | Product image URL from Open Food Facts. Packaged type only. Cached locally after first fetch. |

### Existing Fields Confirmed Present (No Change Needed)
These fields already exist in the entity and database but are not currently exposed in the UI. This extension exposes them in the edit screen for all types.

| Field | Type | Currently |
|---|---|---|
| calories | double? | In entity/DB, not in UI |
| carbs | double? | In entity/DB, not in UI |
| fat | double? | In entity/DB, not in UI |
| protein | double? | In entity/DB, not in UI |
| fiber | double? | In entity/DB, not in UI |
| sugar | double? | In entity/DB, not in UI |

---

## Database Changes

### Composed Dish Ingredients Table (New)
The current implementation stores simpleItemIds as a JSON array on the food_items record. This extension replaces that with a proper join table to support quantity multipliers.

```sql
CREATE TABLE food_item_components (
  id TEXT PRIMARY KEY,
  composed_food_item_id TEXT NOT NULL,
  simple_food_item_id TEXT NOT NULL,
  quantity REAL NOT NULL DEFAULT 1.0,
  sort_order INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY (composed_food_item_id) REFERENCES food_items(id),
  FOREIGN KEY (simple_food_item_id) REFERENCES food_items(id)
);

CREATE INDEX idx_food_item_components_composed ON food_item_components(composed_food_item_id);
```

**quantity field:** A positive multiplier representing how many servings of the Simple item are used. Default 1.0. A value of 2.0 means the component contributes double its per-serving nutritional values to the Composed dish total.

**Migration note:** Existing Composed items using the JSON simpleItemIds array should be migrated to this table with quantity = 1.0 for each existing component.

### Migration: Schema v10 → v11

Add the following nullable columns to the `food_items` table:

```sql
ALTER TABLE food_items ADD COLUMN barcode TEXT;
ALTER TABLE food_items ADD COLUMN brand TEXT;
ALTER TABLE food_items ADD COLUMN ingredients_text TEXT;
ALTER TABLE food_items ADD COLUMN sodium REAL;
ALTER TABLE food_items ADD COLUMN open_food_facts_id TEXT;
ALTER TABLE food_items ADD COLUMN import_source TEXT;
ALTER TABLE food_items ADD COLUMN image_url TEXT;
```

### New Index
Add an index on barcode for fast lookup during barcode scanning:
```sql
CREATE INDEX idx_food_items_barcode ON food_items(barcode) WHERE barcode IS NOT NULL;
```

### Barcode Cache Table (New)
Separate table for caching Open Food Facts API responses. Prevents redundant API calls and enables offline access to previously scanned products.

```sql
CREATE TABLE food_barcode_cache (
  id TEXT PRIMARY KEY,
  barcode TEXT NOT NULL UNIQUE,
  product_name TEXT,
  brand TEXT,
  ingredients_text TEXT,
  calories REAL,
  carbs REAL,
  fat REAL,
  protein REAL,
  fiber REAL,
  sugar REAL,
  sodium REAL,
  open_food_facts_id TEXT,
  image_url TEXT,
  raw_response TEXT,  -- full JSON response stored for future re-parsing
  fetched_at TEXT NOT NULL,
  expires_at TEXT NOT NULL  -- 30 days after fetched_at
);

CREATE INDEX idx_barcode_cache_barcode ON food_barcode_cache(barcode);
CREATE INDEX idx_barcode_cache_expires ON food_barcode_cache(expires_at);
```

---

## API Contract Changes

### Updated CreateFoodItemInput
Add all new fields as optional parameters:
- barcode, brand, ingredientsText, sodium, openFoodFactsId, importSource, imageUrl

### Updated UpdateFoodItemInput
Same new optional fields as CreateFoodItemInput.

### New Use Cases

**LookupBarcodeUseCase**
- Input: `LookupBarcodeInput(barcode: String)`
- Behavior:
  1. Check `food_barcode_cache` for unexpired record matching barcode
  2. If cache hit: return cached data
  3. If cache miss: call Open Food Facts API
  4. If API returns product: save to cache, return structured data
  5. If API returns no result: return null (caller handles "not found" flow)
  6. If no connectivity: return null with offline error flag
- Output: `Result<BarcodeLookupResult?, AppError>`

**BarcodeLookupResult fields:**
- productName, brand, ingredientsText, calories, carbs, fat, protein, fiber, sugar, sodium, openFoodFactsId, imageUrl

**ScanIngredientPhotoUseCase**
- Input: `ScanIngredientPhotoInput(imageBytes: Uint8List)`
- Behavior:
  1. Encode image as base64
  2. Call Claude API with structured extraction prompt (see 59_DIET_TRACKING.md)
  3. Parse JSON response
  4. Return structured data for user review
  5. If API unavailable: return null with offline error flag
- Output: `Result<IngredientScanResult?, AppError>`

**IngredientScanResult fields:**
- productName, ingredients (List<String>), calories, carbs, fat, protein, fiber, sugar, sodium (all nullable)

---

## UI Changes — Food Item Edit Screen

The food item edit screen currently has: Name, Type (Simple/Composed), Ingredients (for Composed only), Notes.

This extension adds full nutritional data entry and a new Packaged type.

### Updated Type Selector
Three-segment control: Simple | Composed | Packaged

### Nutritional Data Section (All Types)
Shown for all three types. Currently hidden — this extension exposes it.

Fields:
- Serving Size (text, e.g. "1 cup", "100g", "1 bar (40g)")
- Calories (number, kcal)
- Protein (number, grams)
- Total Carbohydrates (number, grams)
- Dietary Fiber (number, grams)
- Sugar (number, grams)
- Total Fat (number, grams)
- Sodium (number, milligrams)

For Composed type: Nutritional fields are always read-only and auto-calculated. Each field either shows the summed value (when all components have that field populated) or shows blank with the note "Incomplete — one or more ingredients are missing this value." No manual entry is possible for nutritional data on Composed items.

### Packaged Type — Additional Fields
Shown only when type = Packaged:

- **Brand** — text field
- **Barcode** — text field with a scan button (opens barcode scanner)
- **Ingredients** — multi-line text field (the raw ingredients list as printed on the label)
- **Import source badge** — read-only indicator showing "Open Food Facts", "Photo Scan", or "Manual" when data was imported. Tappable to show import details.
- **Product image** — shown when imageUrl is available (from Open Food Facts). Read-only thumbnail.

### Packaged Type — Data Import Flow
When user is on a Packaged item edit screen, two import options are available:

**Option A — Scan Barcode:**
1. User taps barcode scan button next to Barcode field
2. Camera opens in barcode scanning mode
3. On successful scan: barcode number fills the Barcode field
4. App immediately looks up barcode in cache then Open Food Facts
5. If found: confirmation dialog — "Found: [Product Name] by [Brand]. Import nutritional data?" with Yes / No options
6. On Yes: all available fields pre-populated, importSource set to "open_food_facts"
7. On No: barcode field populated only, user enters rest manually

**Option B — Scan Ingredients Label:**
1. User taps "Scan Label" button
2. Camera opens in photo capture mode
3. Photo taken and sent to Claude API
4. Extracted data returned and pre-populated for user review
5. User reviews and corrects any extraction errors
6. importSource set to "claude_scan"

**Manual Entry:**
User can always enter all fields manually without scanning. importSource set to "manual".

---

## Food Log — Display Changes

When a food item of type Packaged is shown in the food log or food detail screen:

- Brand name shown below food name (if available)
- Ingredients list accessible via expandable section or detail tap
- Import source badge shown subtly (small "OFF" label for Open Food Facts, "Scan" for photo scan)
- Product image thumbnail shown if available
- Full nutritional breakdown shown in detail view

---

## Validation Rules

| Rule | Simple | Composed | Packaged |
|---|---|---|---|
| Name required | ✅ | ✅ | ✅ |
| At least one simpleItemId | ❌ | ✅ | ❌ |
| Barcode format (if present) | N/A | N/A | Must be 8, 12, or 13 digits |
| ingredientsText allowed | ❌ | ❌ | ✅ |
| simpleItemIds allowed | ❌ | ✅ | ❌ |

---

## Diet Compliance Integration

When diet compliance checking runs against a Packaged food item (see 59_DIET_TRACKING.md):

- If ingredientsText is present: compliance check parses the ingredients list and checks each ingredient against "specific ingredient" diet rules
- If ingredientsText is absent: compliance check uses category-level rules only
- This makes Packaged items with full ingredients lists the most precisely checkable food type in the system

---

## Implementation Order

1. Add new entity fields (FoodItem, FoodItemType enum)
2. Write database migration v10 → v11
3. Create food_barcode_cache table and DAO
4. Update CreateFoodItemInput and UpdateFoodItemInput
5. Implement LookupBarcodeUseCase (Open Food Facts integration)
6. Implement ScanIngredientPhotoUseCase (Claude API integration)
7. Update food item edit screen — add Packaged type, expose nutritional fields, add scan flows
8. Update food log display for Packaged items
9. Run build_runner for code generation
10. Write tests for all new use cases and UI changes
11. Run flutter analyze and flutter test
12. Commit and push

---

## Open Food Facts Attribution

Per Open Food Facts terms of use, display the following in the food detail screen for any item with importSource = "open_food_facts":

> "Nutritional data sourced from Open Food Facts (openfoodfacts.org) — open database, licensed under ODbL"

---

## Notes for Claude Code

- All new fields are nullable — no existing records are broken by this migration
- The barcode index enables fast duplicate detection (prevent adding the same product twice)
- Cache expiry (30 days) should be enforced at read time — check expires_at before returning cached data, delete expired records during cache cleanup
- The `raw_response` field in the cache table stores the full Open Food Facts JSON for future re-parsing if the schema changes
- LookupBarcodeUseCase and ScanIngredientPhotoUseCase both return null on "not found" — this is not an error, it means the user should enter manually
- Connectivity errors should return a typed AppError so the UI can show an appropriate offline message
