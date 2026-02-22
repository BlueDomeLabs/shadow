# 60 — Supplement Extension (Import Methods, Source, and Price)
**Status:** PLANNED — Not yet implemented
**Target Phase:** Phase 15a pre-work (implement alongside or just before 59a_FOOD_DATABASE_EXTENSION.md)
**Created:** 2026-02-22
**Depends on:** Existing supplements table and Supplement Edit Screen (Phase 5)
**Related to:** 59a_FOOD_DATABASE_EXTENSION.md (parallel pattern for food)

---

## Overview

The current supplement entry process requires fully manual data entry. This extension adds three import methods — barcode scanning via the NIH Dietary Supplement Label Database, photo scanning of supplement facts or prescription labels via Claude API, and photo capture for label documentation — alongside two new fields: source and price. Manual entry remains fully supported alongside all new methods.

Prescription drugs are treated identically to supplements. There is no separate type. A prescription drug is simply a supplement where the source field contains the prescribing doctor's name or clinic.

---

## New Fields

### Source
- **Type:** String? (nullable, free text)
- **Purpose:** Where the supplement was obtained — a URL, store name, doctor's name, pharmacy, or any other reference
- **Examples:** "amazon.com/dp/B001234", "Whole Foods", "Dr. Sarah Chen", "Costco", "compoundingpharmacy.com"
- **UI:** Single-line text field labeled "Source" in the supplement edit screen
- **No validation:** Any text is accepted. The field is purely informational.

### Price Paid
- **Type:** double? (nullable)
- **Purpose:** The total price paid for the package or bottle
- **UI:** Numeric field with currency symbol, labeled "Price Paid"
- **Currency:** Uses the device locale currency by default. No currency conversion.

### Price Per Serving (Calculated, Read-Only)
- **Type:** Calculated — not stored separately
- **Formula:** Price Paid ÷ (Total Servings in package)
- **Total Servings** = Quantity on Hand ÷ Quantity Per Dose (both already in the supplement entity)
- **UI:** Read-only field shown below Price Paid, labeled "Price Per Serving"
- **Shown only when:** Price Paid is entered AND Quantity on Hand AND Quantity Per Dose are both set
- **If any value is missing:** Price Per Serving field is hidden entirely

### Label Photo
- **Type:** String? (nullable) — local file path to stored photo
- **Purpose:** Photo of the supplement label, prescription label, or bottle for reference
- **UI:** Photo thumbnail in the supplement edit screen with "Take Photo" / "Choose Photo" options
- **Storage:** Stored locally alongside other supplement photos, not synced to Drive by default (too large)
- **Multiple photos:** Up to 3 label photos per supplement (front label, supplement facts panel, prescription label)

### Barcode
- **Type:** String? (nullable)
- **Purpose:** UPC or EAN barcode for DSLD lookup and deduplication
- **UI:** Text field with scan button, same pattern as food

### Import Source
- **Type:** String? (nullable, enum-like)
- **Values:** "dsld", "claude_scan", "manual"
- **Purpose:** Tracks where supplement data originated
- **UI:** Read-only badge shown when data was imported

---

## Import Methods

All four methods are available in the Supplement Edit Screen. The user can use any combination — for example, scan the barcode to get basic product info, then take a photo of the label for reference.

### Method 1: Manual Entry (Existing)
All fields entered by hand. No changes to existing behavior. This remains the default and is always available.

### Method 2: Barcode Scan — NIH DSLD
- User taps barcode scan button
- Camera opens in barcode scanning mode
- On successful scan: barcode looked up in the NIH Dietary Supplement Label Database
- **DSLD API endpoint:** `https://dsld.od.nih.gov/api/v8/dsld/supplement?upc={barcode}`
- If found: product name, brand, serving size, ingredients, and supplement facts data pre-populated
- User reviews and confirms before saving
- importSource set to "dsld"
- If not found in DSLD: user informed, offered photo scan or manual entry as alternatives
- Successful lookups cached locally (same pattern as food barcode cache, 30-day expiry)

### Method 3: Photo Scan — Supplement Facts Panel or Prescription Label
- User taps "Scan Label" button
- Camera opens in photo capture mode
- User photographs the Supplement Facts panel or prescription label
- Photo sent to Claude API with extraction prompt
- Extracted data pre-populated for user review and correction
- importSource set to "claude_scan"
- If API unavailable offline: shows "Unavailable offline" message, user falls back to manual

**Claude API prompt for supplement scanning:**
> "This is a photo of a supplement facts panel or prescription medication label. Please extract and return the following as JSON: product_name (string or null), brand (string or null), serving_size (string or null), servings_per_container (number or null), ingredients (array of objects with 'name' and 'amount_per_serving' strings), is_prescription (boolean — true if this appears to be a prescription medication label). Return only valid JSON with no additional text."

### Method 4: Label Photo Capture (Documentation Only)
- User taps camera icon in the Label Photos section
- Camera opens for photo capture
- Photo saved locally as a reference image attached to the supplement record
- No data extraction — this is for visual documentation only
- Up to 3 photos per supplement
- Useful for: capturing the full bottle label, prescription label, or any other reference image

---

## Supplement Edit Screen Changes

### New Section: Source & Price
Added as a new section in the supplement edit screen, after the existing Notes section.

**Fields:**
- Source (free text, optional)
- Price Paid (numeric with currency symbol, optional)
- Price Per Serving (read-only calculated field, shown when calculable)

### New Section: Label Photos
Added after Source & Price.

**Fields:**
- Photo thumbnails (up to 3)
- "Take Photo" button (opens camera)
- "Choose from Library" button (opens photo picker)
- Tap thumbnail to view full size or delete

### Updated Import Options
The existing supplement name/brand entry area gains import shortcut buttons:
- Barcode scan icon → triggers DSLD barcode lookup
- Camera icon → triggers Claude API label scan

These appear as subtle icon buttons near the top of the edit screen, consistent with the food edit screen pattern from 59a.

---

## Database Changes

### Schema Migration (incorporated into v9 → v10 alongside 59a changes)
Add the following nullable columns to the `supplements` table:

```sql
ALTER TABLE supplements ADD COLUMN source TEXT;
ALTER TABLE supplements ADD COLUMN price_paid REAL;
ALTER TABLE supplements ADD COLUMN barcode TEXT;
ALTER TABLE supplements ADD COLUMN import_source TEXT;
```

### New Table: supplement_label_photos
```sql
CREATE TABLE supplement_label_photos (
  id TEXT PRIMARY KEY,
  supplement_id TEXT NOT NULL,
  file_path TEXT NOT NULL,
  captured_at TEXT NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY (supplement_id) REFERENCES supplements(id)
);

CREATE INDEX idx_supplement_label_photos_supplement ON supplement_label_photos(supplement_id);
```

### New Table: supplement_barcode_cache
Same structure as food_barcode_cache, specific to DSLD data:

```sql
CREATE TABLE supplement_barcode_cache (
  id TEXT PRIMARY KEY,
  barcode TEXT NOT NULL UNIQUE,
  product_name TEXT,
  brand TEXT,
  serving_size TEXT,
  servings_per_container REAL,
  ingredients_json TEXT,
  dsld_id TEXT,
  raw_response TEXT,
  fetched_at TEXT NOT NULL,
  expires_at TEXT NOT NULL
);

CREATE INDEX idx_supplement_barcode_cache_barcode ON supplement_barcode_cache(barcode);
```

**Note:** These migrations are incorporated into the same v9→v10 migration defined in 59a_FOOD_DATABASE_EXTENSION.md. Both specs are implemented together in Phase 15a.

---

## API Contract Changes

### Updated CreateSupplementInput and UpdateSupplementInput
Add new optional fields: source, pricePaid, barcode, importSource

### New Use Cases

**LookupSupplementBarcodeUseCase**
- Input: `LookupSupplementBarcodeInput(barcode: String)`
- Behavior:
  1. Check supplement_barcode_cache for unexpired record
  2. If cache hit: return cached data
  3. If cache miss: call NIH DSLD API
  4. If found: save to cache, return structured data
  5. If not found: return null (caller handles "not found" flow)
  6. If offline: return null with offline error flag
- Output: `Result<SupplementBarcodeLookupResult?, AppError>`

**ScanSupplementLabelUseCase**
- Input: `ScanSupplementLabelInput(imageBytes: Uint8List)`
- Behavior:
  1. Encode image as base64
  2. Call Claude API with supplement extraction prompt
  3. Parse JSON response
  4. Return structured data for user review
  5. If API unavailable: return null with offline error flag
- Output: `Result<SupplementLabelScanResult?, AppError>`

**AddSupplementLabelPhotoUseCase**
- Input: `AddSupplementLabelPhotoInput(supplementId: String, imageBytes: Uint8List)`
- Saves photo to local storage, creates supplement_label_photos record
- Output: `Result<SupplementLabelPhoto, AppError>`

---

## Price Per Serving Calculation

Calculated at display time, never stored. Logic:

```
if (pricePaid != null && quantityOnHand != null && quantityPerDose != null && quantityPerDose > 0):
  totalServings = quantityOnHand / quantityPerDose
  pricePerServing = pricePaid / totalServings
  display formatted to 2 decimal places with currency symbol
else:
  hide Price Per Serving field entirely
```

---

## NIH DSLD Integration Notes

- DSLD is the National Institutes of Health Dietary Supplement Label Database
- Free, no API key required for basic product lookups
- Contains over 100,000 dietary supplement products with full label data
- Does not contain prescription drugs — prescription items must use photo scan or manual entry
- Rate limiting: be respectful, cache all successful responses for 30 days
- Attribution: "Supplement data from NIH Dietary Supplement Label Database (dsld.od.nih.gov)"

---

## Implementation Notes

- Price Per Serving is a pure UI calculation — no new database fields or use cases needed
- Label photos are stored locally and not included in Google Drive sync by default (binary files, too large) — this may be revisited in a future phase
- Barcode scan and photo scan buttons are additive to the existing edit screen — manual entry is never removed or hidden
- The DSLD API may have different response structure per product — Claude Code should handle missing fields gracefully and leave them blank rather than failing
- Prescription drugs: no special handling needed. Source field = doctor's name, import via photo scan of Rx label. The Claude API prompt already handles prescription labels via the is_prescription field in the response (use this to show a subtle "Rx" badge on the supplement if true)

---

## Implementation Order

1. Add new entity fields to Supplement entity
2. Incorporate supplement columns into v9→v10 migration (coordinate with 59a)
3. Create supplement_label_photos table and DAO
4. Create supplement_barcode_cache table and DAO
5. Update CreateSupplementInput and UpdateSupplementInput
6. Implement LookupSupplementBarcodeUseCase (NIH DSLD)
7. Implement ScanSupplementLabelUseCase (Claude API)
8. Implement AddSupplementLabelPhotoUseCase
9. Update Supplement Edit Screen — add Source & Price section, Label Photos section, import buttons
10. Add Price Per Serving calculated display
11. Run build_runner
12. Write tests
13. Run flutter analyze and flutter test
14. Commit and push
