# 59 — Diet Tracking
**Status:** COMPLETE — Phase 15b implemented
**Target Phase:** Phase 15
**Created:** 2026-02-22
**Completed:** 2026-02-24

---

## Overview

Shadow includes a comprehensive diet tracking system that supports standard preset diets, a fully configurable custom diet builder, intermittent fasting with multiple protocols, and complete macro and micronutrient tracking. Diet compliance checking happens in real-time at the point of food logging — the user is alerted immediately when a food violates their active diet and can decide to cancel or proceed. The Compliance Dashboard provides a historical summary of adherence over time.

---

## Core Compliance Flow

This is the most important behavioral pattern in diet tracking. Every food logging action runs through this flow:

1. User adds a food item (manually, via barcode scan, or via ingredient photo scan)
2. Shadow checks the food against the active diet rules in real-time
3. **If no violation:** food is logged normally
4. **If violation detected:** violation alert appears before saving
   - Alert shows which rule was violated and why
   - User chooses: **"Add Anyway"** or **"Cancel"**
   - "Add Anyway" logs the food with a visible violation flag attached
   - "Cancel" returns to the food log without saving
5. Flagged entries are visible in the food log with a warning indicator and tracked in the Compliance Dashboard

---

## Food Logging — Input Methods

Shadow supports three ways to add a food item to the log. All three feed into the same compliance checking flow above.

### Method 1: Manual Entry
Standard food search and selection from the Shadow food database. Existing functionality.

### Method 2: Barcode Scanner
- User taps barcode icon in the food log screen
- Camera opens in barcode scanning mode
- User points camera at product barcode
- Shadow looks up the barcode in the **Open Food Facts** database (openfoodfacts.org)
- If found: product name, ingredients, and full nutritional data are pre-populated
- User reviews pre-populated data and taps "Add to Log"
- Compliance check runs before saving
- If not found in Open Food Facts: user is prompted to enter manually or take an ingredient photo scan
- Nutritional data from Open Food Facts is cached locally after first lookup
- **In-store use:** works anywhere with connectivity — user can scan a product before purchasing to check diet compliance

### Method 3: Ingredient Photo Scan
- User taps camera icon and selects "Scan Ingredients Label"
- Camera opens in photo capture mode
- User photographs the ingredients label or nutrition facts panel
- Photo is sent to the **Claude API** to extract structured data
- Shadow displays extracted data for user review and correction
- User confirms or edits, then taps "Add to Log"
- Compliance check runs before saving
- **In-store use:** works for any product — international items, bulk foods, handwritten menus, anything without a standard barcode
- If Claude API is unavailable (no connectivity): shows "Unavailable offline" message, user falls back to manual entry

---

## Screen 1: Diet Selection Screen

### Purpose
Entry point for diet tracking. Shows the user's current active diet and allows selection of a new one or creation of a custom diet.

### Layout
- **Current Diet** section at top — shows active diet name, start date, compliance percentage this week
- **Preset Diets** section — scrollable list of standard diets
- **Custom Diets** section — list of user-created diets with option to create new
- **No Diet** option — turns off diet tracking while keeping historical data

### Preset Diets Available

> **Canonical source:** `41_DIET_SYSTEM.md` Section 2.2 and the `DietPresetType` enum in `22_API_CONTRACTS.md` Section 3.3. The list below matches the 20 implemented enum values. "Carnivore" and "DASH" were removed; intermittent fasting variants and Zone were added.

| Diet | DietPresetType enum | Description |
|---|---|---|
| Vegan | vegan | No animal products |
| Vegetarian | vegetarian | No meat, allows dairy and eggs |
| Pescatarian | pescatarian | No meat, allows fish/dairy/eggs |
| Paleo | paleo | No grains, legumes, dairy, processed foods |
| Ketogenic | keto | <20g net carbs, 70-75% fat |
| Strict Keto | ketoStrict | <20g total carbs, 75% fat |
| Low Carb | lowCarb | <100g carbs daily |
| Mediterranean | mediterranean | Emphasis on fish, olive oil, vegetables |
| Whole30 | whole30 | 30-day elimination diet |
| AIP (Autoimmune Protocol) | aip | Paleo + no nightshades, eggs, nuts, seeds |
| Low-FODMAP | lowFodmap | Excludes high-FODMAP foods for IBS management |
| Gluten-Free | glutenFree | No gluten-containing grains |
| Dairy-Free | dairyFree | No dairy products |
| Intermittent Fasting 16:8 | if168 | 16hr fast, 8hr eating window |
| Intermittent Fasting 18:6 | if186 | 18hr fast, 6hr eating window |
| Intermittent Fasting 20:4 | if204 | 20hr fast, 4hr eating window |
| One Meal A Day | omad | 23hr fast, 1hr eating window |
| 5:2 Diet | fiveTwoDiet | 5 normal days, 2 fasting days (<500 cal) |
| Zone Diet | zone | 40% carb, 30% protein, 30% fat |
| Custom | custom | User-defined rules |

### Selecting a Preset Diet
- Tap diet → detail screen showing full rules and excluded foods
- "Start This Diet" button → sets as active diet with today as start date
- Optional: set an end date

---

## Screen 2: Custom Diet Builder

### Purpose
Build a fully customized diet with macro targets, food rules, and exceptions.

### Section 1: Diet Basics
- Diet name (required)
- Description (optional)
- Start date
- End date (optional)

### Section 2: Macro Targets
Daily targets for each macronutrient. Each can be set as grams per day, percentage of total calories, a range, or not tracked.

**Macros tracked:**
- Calories (total)
- Protein
- Total Carbohydrates
- Net Carbohydrates (Total Carbs minus Fiber)
- Dietary Fiber
- Total Fat
- Saturated Fat
- Unsaturated Fat
- Sugar
- Sodium
- Cholesterol

### Section 3: Micronutrient Targets
Optional daily targets for vitamins and minerals. Uses standard RDA/DRI values as defaults. Collapsed by default — expandable for power users.

**Vitamins:** A, B1 (Thiamine), B2 (Riboflavin), B3 (Niacin), B5 (Pantothenic Acid), B6, B7 (Biotin), B9 (Folate), B12, C, D, E, K

**Minerals:** Calcium, Chromium, Copper, Fluoride, Iodine, Iron, Magnesium, Manganese, Molybdenum, Phosphorus, Potassium, Selenium, Zinc

### Section 4: Food Rules
Rules define what foods are allowed, restricted, or forbidden.

**Rule types:**
- **Forbidden:** Food or category not allowed at all
- **Limited:** Allowed up to a quantity per day/week
- **Required:** Must be consumed at minimum quantity
- **Preferred:** Encouraged but not required (informational only)

**Rule targets:**
- Specific foods from the food database
- Food categories (grains, dairy, meat, fish, vegetables, fruits, legumes, nuts, etc.)
- Specific ingredients (free-text — used for precise compliance checking against barcode and photo scan results)

**Exceptions:**
- Any rule can have exceptions (e.g. "No dairy — EXCEPT hard aged cheeses")
- Exceptions are respected during real-time compliance validation

**Rule builder UI:**
- "Add Rule" button → bottom sheet with rule type selector, food/category/ingredient picker, quantity fields, exception builder
- Rules displayed as readable plain-English list
- Tap to edit, swipe to delete

### Section 5: Save / Activate
- "Save as Draft" — saves without activating
- "Save and Activate" — saves and sets as current active diet

---

## Screen 3: Compliance Dashboard

### Purpose
Historical summary of diet adherence. Real-time compliance happens at point of logging — this screen shows the results.

### Layout

**Today's Summary:**
- Calorie progress bar (consumed vs. target)
- Macro rings (protein, carbs, fat — consumed vs. target)
- Rule compliance indicators per rule (green check / red X)
- Micronutrient summary (expandable)
- Count and list of flagged entries today (foods logged despite violations)

**Weekly Overview:**
- 7-day compliance chart (percentage per day)
- Best day / worst day
- Current streak (days fully compliant)

**Monthly Trends:**
- Line chart of compliance percentage over 30 days
- Macro averages vs. targets

**Rule Violations:**
- List of rules violated today with the food that caused each
- History of violations by rule over past 30 days
- Distinction between flagged entries (user added anyway) vs. cancelled (user did not add)

**Nutritional Gaps:**
- Micronutrients consistently below target (flagged red)
- Micronutrients consistently above target (flagged yellow)

---

## Screen 4: Fasting Timer

### Purpose
Track intermittent fasting windows with support for multiple protocols.

### Supported Protocols
| Protocol | Description |
|---|---|
| 16:8 | 16 hours fasting, 8 hour eating window |
| 18:6 | 18 hours fasting, 6 hour eating window |
| 20:4 | 20 hours fasting, 4 hour eating window |
| 5:2 | Normal eating 5 days, 500–600 calories 2 fast days/week |
| OMAD | One meal a day |
| 24-hour | Full 24-hour fast |
| 36-hour | Extended 36-hour fast |
| Custom | User-defined fasting and eating window durations |

### Timer Screen Layout
- Large circular timer showing time remaining in current phase
- Phase label: "Fasting" or "Eating Window"
- Start/Stop button
- Scheduled eating window open/close times for today
- Current fast stats: hours fasted, percentage of target complete
- Recent fasts: last 7 with duration and protocol

### Fasting + Food Log Integration
- If food is logged during a fasting window: violation alert fires
- Alert options: "End Fast Now", "Mark as Exception", "Cancel Food Entry"
- Fasting violations tracked separately in Compliance Dashboard

### 5:2 Protocol
- User designates which days of the week are fast days
- On fast days: calorie target switches to 500 calories in the dashboard
- On normal days: regular macro targets apply

---

## Screen 5: Violation Alert

### Purpose
Shown in real-time when a food add would violate an active diet rule. Appears before the food is saved.

### Trigger
- Fires during the food add flow after compliance check, before saving
- Applies to all three input methods: manual, barcode scan, photo scan

### Layout
- Alert title: "Diet Alert" (implemented as `DietViolationDialog` — spec originally said "Diet Rule Violation" but code uses "Diet Alert")
- Plain-English explanation: "This food contains [ingredient]. Your current diet excludes [rule]."
- The specific rule(s) violated
- The food item being added
- **Two options:**
  - **"Add Anyway"** — saves food with a visible violation flag, records violation in compliance history
  - **"Cancel"** — returns to food log without saving

### Flagged Entry Appearance
- Foods added despite a violation show a warning icon in the food log
- Tapping the warning shows which rule was violated
- Flagged entries counted separately in the Compliance Dashboard

### Multiple Violations
- If a food violates more than one rule: all violations listed in the alert
- User makes one decision that applies to all

---

## Screen 6: Custom Diet Rule Builder (Detail)

Bottom sheet used within the Custom Diet Builder for individual rule creation.

**Step 1 — Rule Type:** Forbidden / Limited / Required / Preferred with plain-English descriptions

**Step 2 — What This Rule Applies To:**
- A specific food (food database search)
- A food category (grains, dairy, meat, fish, vegetables, fruits, legumes, nuts, etc.)
- A specific ingredient (free-text — enables precise scanning compliance checks)

**Step 3 — Quantity** (Limited and Required rules only):
Amount, unit (servings/grams/ounces/cups), frequency (per meal/per day/per week)

**Step 4 — Exceptions** (optional):
Free-text description of what is allowed despite the rule. Multiple exceptions allowed.

**Step 5 — Review:**
Plain-English summary of the rule (e.g. "No dairy products, except hard aged cheeses"). "Save Rule" button.

---

## Claude API Integration for Photo Scanning

### Prompt Design
Shadow sends the label photo to the Claude API with this prompt:

> "This is a photo of a food product's ingredients label or nutrition facts panel. Please extract and return the following as JSON: product_name (string or null), ingredients (array of ingredient name strings in order as listed), nutrition_facts (object with calories, protein_g, carbs_g, fiber_g, sugar_g, fat_g, saturated_fat_g, sodium_mg, and any vitamins or minerals present). Return only valid JSON with no additional text."

### Response Handling
- Shadow parses the JSON and pre-populates the food entry form
- User reviews all extracted data before confirming
- Null fields are left blank for user to fill in
- If Claude cannot read the label (blurry, incomplete): error flag returned, user prompted to retake photo or enter manually
- Image sent as base64 via existing Anthropic API integration

### Ingredient-Level Compliance Checking
- Extracted ingredients are checked against diet rules of type "specific ingredient"
- Enables precise checking for processed foods: a Gluten-Free diet rule for "wheat" will flag any product where "wheat" appears in the extracted ingredients list
- More powerful than category-level checking for packaged and processed foods

---

## Open Food Facts Integration

### API Endpoint
`https://world.openfoodfacts.org/api/v2/product/{barcode}.json`

### Data Used
- Product name
- Ingredients list (text and parsed array)
- Nutritional values per 100g and per serving
- Allergen information
- Product image (displayed to user for confirmation)

### Caching
- Successful lookups cached locally in the Shadow database
- Cache includes: barcode, product name, ingredients, nutrition data, last_fetched timestamp
- Cache used for offline access and to reduce API calls
- Cache expires after 30 days (product formulations can change)

### Attribution
Open Food Facts requires attribution. Display "Nutritional data from Open Food Facts (openfoodfacts.org)" in the food detail screen for any product sourced from their database.

---

## Technical Implementation Notes

- Real-time compliance checking runs synchronously during food add flow — must complete in under 500ms
- Compliance check logic lives in a `DietComplianceService` in the domain layer
- `DietComplianceService` takes a food item + active diet and returns a list of violations (empty = compliant)
- Barcode scanning: use `mobile_scanner` Flutter plugin (supports iOS and Android)
- Photo capture: use existing camera infrastructure already in Shadow for photo entries
- Claude API call: use existing Anthropic API integration already in the project
- Open Food Facts: standard HTTP GET, no API key required for basic lookups
- New database tables: `diets`, `diet_rules`, `diet_exceptions`, `fasting_sessions`, `diet_violations`, `food_barcode_cache`
- New entities: `Diet`, `DietRule`, `DietException`, `FastingSession`, `DietViolation`, `BarcodeCache`
- New use cases: `GetActiveDiet`, `SetActiveDiet`, `CreateCustomDiet`, `UpdateDiet`, `CheckDietCompliance`, `GetComplianceData`, `StartFast`, `EndFast`, `GetFastingHistory`, `LogDietViolation`, `LookupBarcode`, `ScanIngredientPhoto`
