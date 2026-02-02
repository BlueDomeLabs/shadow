# Shadow Diet System Specification

**Version:** 1.0
**Last Updated:** January 31, 2026
**Purpose:** Complete specification for diet types, rules, compliance tracking, and violation alerts

---

## 1. Overview

Shadow provides comprehensive diet tracking that goes beyond simple food logging. The system:

- **Supports preset diets** with pre-configured rules
- **Allows custom diet creation** with user-defined restrictions
- **Tracks compliance in real-time** with percentage scoring
- **Alerts users to violations** as they log food
- **Handles time-based diets** (intermittent fasting)
- **Generates compliance reports** with trend analysis

---

## 2. Diet Categories

### 2.1 Diet Type Classification

| Category | Description | Examples |
|----------|-------------|----------|
| **Food Restriction** | Excludes specific food types | Vegan, Vegetarian, Paleo, Keto |
| **Time Restriction** | Controls when eating occurs | Intermittent Fasting (16:8, 18:6, OMAD) |
| **Macronutrient Ratio** | Specific macro percentages | Keto (75/20/5), Zone (40/30/30) |
| **Combination** | Both food and time rules | Paleo + 16:8, Clean Keto |
| **Elimination** | Temporary exclusions for testing | Whole30, AIP, Low-FODMAP |
| **Custom** | User-defined rules | Any combination |

### 2.2 Preset Diet Library

| Diet ID | Diet Name | Category | Key Rules |
|---------|-----------|----------|-----------|
| `vegan` | Vegan | Food Restriction | No animal products |
| `vegetarian` | Vegetarian | Food Restriction | No meat/fish, allows dairy/eggs |
| `pescatarian` | Pescatarian | Food Restriction | No meat, allows fish/dairy/eggs |
| `paleo` | Paleo | Food Restriction | No grains, legumes, dairy, processed foods |
| `keto` | Ketogenic | Macronutrient | <20g net carbs, 70-75% fat |
| `keto_strict` | Strict Keto | Macronutrient | <20g total carbs, 75% fat |
| `low_carb` | Low Carb | Macronutrient | <100g carbs daily |
| `mediterranean` | Mediterranean | Food Preference | Emphasis on fish, olive oil, vegetables |
| `whole30` | Whole30 | Elimination | No sugar, grains, dairy, legumes, alcohol (30 days) |
| `aip` | Autoimmune Protocol | Elimination | Paleo + no nightshades, eggs, nuts, seeds |
| `low_fodmap` | Low-FODMAP | Elimination | No high-FODMAP foods |
| `gluten_free` | Gluten-Free | Food Restriction | No gluten-containing grains |
| `dairy_free` | Dairy-Free | Food Restriction | No dairy products |
| `if_16_8` | Intermittent Fasting 16:8 | Time Restriction | 16hr fast, 8hr eating window |
| `if_18_6` | Intermittent Fasting 18:6 | Time Restriction | 18hr fast, 6hr eating window |
| `if_20_4` | Intermittent Fasting 20:4 | Time Restriction | 20hr fast, 4hr eating window |
| `omad` | One Meal A Day | Time Restriction | 23hr fast, 1hr eating window |
| `5_2` | 5:2 Diet | Time Restriction | 5 normal days, 2 fasting days (<500 cal) |
| `zone` | Zone Diet | Macronutrient | 40% carb, 30% protein, 30% fat |
| `custom` | Custom Diet | Custom | User-defined |

---

## 3. Diet Rule Engine

### 3.1 Rule Types

```dart
enum DietRuleType {
  // Food-based rules
  excludeCategory,      // Exclude entire food category
  excludeIngredient,    // Exclude specific ingredient
  requireCategory,      // Must include category (e.g., vegetables)
  limitCategory,        // Max servings per day/week

  // Macronutrient rules
  maxCarbs,             // Maximum carbs (grams)
  maxFat,               // Maximum fat (grams)
  maxProtein,           // Maximum protein (grams)
  minCarbs,             // Minimum carbs (grams)
  minFat,               // Minimum fat (grams)
  minProtein,           // Minimum protein (grams)
  carbPercentage,       // Carbs as % of calories
  fatPercentage,        // Fat as % of calories
  proteinPercentage,    // Protein as % of calories
  maxCalories,          // Maximum daily calories

  // Time-based rules
  eatingWindowStart,    // Earliest eating time
  eatingWindowEnd,      // Latest eating time
  fastingHours,         // Required consecutive fasting hours
  fastingDays,          // Specific fasting days (for 5:2)
  maxMealsPerDay,       // Maximum number of meals

  // Combination rules
  mealSpacing,          // Minimum hours between meals
  noEatingBefore,       // No food before time
  noEatingAfter,        // No food after time
}
```

### 3.2 Food Categories

```dart
enum FoodCategory {
  // Animal products
  meat,                 // Beef, pork, lamb, etc.
  poultry,              // Chicken, turkey, duck
  fish,                 // All fish and shellfish
  eggs,
  dairy,                // Milk, cheese, yogurt, butter

  // Plant-based
  vegetables,
  fruits,
  grains,               // Wheat, rice, oats, corn
  legumes,              // Beans, lentils, peanuts
  nuts,                 // Tree nuts
  seeds,

  // Specific restrictions
  gluten,               // Wheat, barley, rye
  nightshades,          // Tomatoes, peppers, eggplant, potatoes
  fodmaps,              // Fermentable carbs
  sugar,                // Added sugars
  alcohol,
  caffeine,
  processedFoods,
  artificialSweeteners,

  // Cooking methods
  friedFoods,
  rawFoods,
}
```

### 3.3 Diet Rule Definition

```dart
@freezed
class DietRule with _$DietRule {
  const factory DietRule({
    required String id,
    required DietRuleType type,
    required RuleSeverity severity,    // violation, warning, info
    FoodCategory? category,
    String? ingredientName,
    double? numericValue,              // For limits/percentages
    TimeOfDay? timeValue,              // For time-based rules
    List<int>? daysOfWeek,             // For day-specific rules
    String? description,               // Human-readable description
    String? violationMessage,          // Message shown on violation
  }) = _DietRule;
}

enum RuleSeverity {
  violation,    // Breaks the diet (red)
  warning,      // Discouraged but allowed (yellow)
  info,         // Informational tracking (blue)
}
```

### 3.4 Preset Diet Rule Definitions

#### Vegan
```dart
const veganRules = [
  DietRule(type: excludeCategory, category: meat, severity: violation,
    violationMessage: "Meat is not allowed on a vegan diet"),
  DietRule(type: excludeCategory, category: poultry, severity: violation,
    violationMessage: "Poultry is not allowed on a vegan diet"),
  DietRule(type: excludeCategory, category: fish, severity: violation,
    violationMessage: "Fish is not allowed on a vegan diet"),
  DietRule(type: excludeCategory, category: eggs, severity: violation,
    violationMessage: "Eggs are not allowed on a vegan diet"),
  DietRule(type: excludeCategory, category: dairy, severity: violation,
    violationMessage: "Dairy is not allowed on a vegan diet"),
];
```

#### Keto
```dart
const ketoRules = [
  DietRule(type: maxCarbs, numericValue: 20, severity: violation,
    violationMessage: "Daily carbs exceed 20g keto limit"),
  DietRule(type: fatPercentage, numericValue: 70, severity: warning,
    violationMessage: "Fat intake below 70% target"),
  DietRule(type: excludeCategory, category: sugar, severity: violation,
    violationMessage: "Added sugar not allowed on keto"),
  DietRule(type: excludeCategory, category: grains, severity: violation,
    violationMessage: "Grains not allowed on keto"),
  DietRule(type: limitCategory, category: fruits, numericValue: 1, severity: warning,
    violationMessage: "Limit fruit to 1 serving on keto"),
];
```

#### Intermittent Fasting 16:8
```dart
const if168Rules = [
  DietRule(type: fastingHours, numericValue: 16, severity: violation,
    violationMessage: "Eating outside your 8-hour window"),
  DietRule(type: eatingWindowStart, timeValue: TimeOfDay(12, 0), severity: info,
    description: "Default eating window starts at 12:00 PM"),
  DietRule(type: eatingWindowEnd, timeValue: TimeOfDay(20, 0), severity: info,
    description: "Default eating window ends at 8:00 PM"),
];
```

#### Paleo
```dart
const paleoRules = [
  DietRule(type: excludeCategory, category: grains, severity: violation,
    violationMessage: "Grains not allowed on paleo"),
  DietRule(type: excludeCategory, category: legumes, severity: violation,
    violationMessage: "Legumes not allowed on paleo"),
  DietRule(type: excludeCategory, category: dairy, severity: violation,
    violationMessage: "Dairy not allowed on paleo"),
  DietRule(type: excludeCategory, category: processedFoods, severity: violation,
    violationMessage: "Processed foods not allowed on paleo"),
  DietRule(type: excludeCategory, category: sugar, severity: violation,
    violationMessage: "Added sugar not allowed on paleo"),
];
```

#### Mediterranean
```dart
const mediterraneanRules = [
  DietRule(type: requireCategory, category: vegetables, numericValue: 3, severity: warning,
    violationMessage: "Try to eat at least 3 servings of vegetables"),
  DietRule(type: requireCategory, category: fish, numericValue: 2, severity: warning,
    violationMessage: "Include fish at least 2x per week"),
  DietRule(type: limitCategory, category: meat, numericValue: 2, severity: warning,
    violationMessage: "Limit red meat to 2 servings per week"),
  DietRule(type: excludeCategory, category: processedFoods, severity: warning,
    violationMessage: "Minimize processed foods"),
];
```

---

## 4. Food Item Tagging

### 4.1 Food Item Categories

Each food item in the library must be tagged with applicable categories:

```dart
@freezed
class FoodItem with _$FoodItem {
  const factory FoodItem({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    required FoodItemType type,
    required Set<FoodCategory> categories,  // NEW: Category tags

    // Nutritional info (optional but enables macro tracking)
    NutritionalInfo? nutrition,

    // For composed items
    List<String>? ingredientIds,

    // Sync metadata
    required SyncMetadata syncMetadata,
  }) = _FoodItem;
}

@freezed
class NutritionalInfo with _$NutritionalInfo {
  const factory NutritionalInfo({
    required double servingSize,
    required String servingUnit,      // "g", "oz", "cup", "piece"
    required double calories,
    required double carbsGrams,
    required double fatGrams,
    required double proteinGrams,
    double? fiberGrams,               // For net carbs calculation
    double? sugarGrams,
    double? sodiumMg,
  }) = _NutritionalInfo;
}
```

### 4.2 Auto-Categorization

Common foods are pre-tagged in the system database:

```dart
// Example food item definitions
const chickenBreast = FoodItem(
  name: "Chicken Breast",
  categories: {FoodCategory.poultry, FoodCategory.meat},
  nutrition: NutritionalInfo(
    servingSize: 100, servingUnit: "g",
    calories: 165, carbsGrams: 0, fatGrams: 3.6, proteinGrams: 31,
  ),
);

const brownRice = FoodItem(
  name: "Brown Rice",
  categories: {FoodCategory.grains},
  nutrition: NutritionalInfo(
    servingSize: 100, servingUnit: "g",
    calories: 112, carbsGrams: 24, fatGrams: 0.8, proteinGrams: 2.3,
    fiberGrams: 1.8,
  ),
);

const almonds = FoodItem(
  name: "Almonds",
  categories: {FoodCategory.nuts},
  nutrition: NutritionalInfo(
    servingSize: 28, servingUnit: "g",
    calories: 164, carbsGrams: 6, fatGrams: 14, proteinGrams: 6,
    fiberGrams: 3.5,
  ),
);
```

### 4.3 User Category Override

Users can adjust categories if auto-detection is incorrect:

```
┌─────────────────────────────────────────────────────────────────────┐
│  EDIT FOOD ITEM                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Name: Almond Milk                                                  │
│                                                                     │
│  Categories (select all that apply):                                │
│                                                                     │
│  ☐ Meat      ☐ Poultry    ☐ Fish       ☐ Eggs                     │
│  ☐ Dairy     ☑ Nuts       ☐ Grains     ☐ Legumes                  │
│  ☐ Sugar     ☐ Gluten     ☐ Processed  ☐ Alcohol                  │
│                                                                     │
│  Note: Almond milk is nut-based, not dairy                         │
│                                                                     │
│                    [Save Changes]                                   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 5. Compliance Calculation

### 5.1 Meal Definition

> **IMPORTANT CLARIFICATION:** For compliance calculation purposes, a "meal" is defined as:
> - ANY FoodLog entry, regardless of meal type (breakfast, lunch, dinner, snack)
> - Each food log is counted as ONE compliance opportunity
> - Individual food items within a log are checked for violations, but the log itself is the unit of measurement
> - A single FoodLog with multiple violating items counts as ONE violation (not multiple)
> - Snacks count equally with main meals for compliance scoring

**Example:**
- User logs breakfast with 3 foods: 2 compliant, 1 violating → 1 violation
- User logs lunch with 5 foods: all compliant → 0 violations
- User logs snack with 1 violating food → 1 violation
- Daily score: (3 meals - 2 violations) / 3 meals = 33.3% compliance

### 5.2 Compliance Score Algorithm

```dart
class DietComplianceCalculator {
  /// Calculate compliance score for a date range
  /// Returns 0-100 percentage
  ///
  /// IMPORTANT: Each FoodLog counts as one "meal" for scoring purposes.
  /// A log with ANY violation counts as 1 violation, regardless of how
  /// many violating items it contains.
  double calculateCompliance(
    Diet diet,
    List<FoodLog> logs,
    DateTimeRange range,
  ) {
    final rules = diet.rules;
    final violations = <RuleViolation>[];

    // Check each rule type
    for (final rule in rules) {
      switch (rule.type) {
        case DietRuleType.excludeCategory:
          violations.addAll(_checkExclusionRule(rule, logs));
          break;
        case DietRuleType.maxCarbs:
          violations.addAll(_checkMacroLimit(rule, logs, range));
          break;
        case DietRuleType.eatingWindowStart:
        case DietRuleType.eatingWindowEnd:
          violations.addAll(_checkTimeRule(rule, logs));
          break;
        // ... handle all rule types
      }
    }

    // Calculate score
    final totalMeals = logs.length;
    final violationCount = violations.where((v) =>
      v.severity == RuleSeverity.violation
    ).length;

    if (totalMeals == 0) return 100.0;

    // Each violation reduces score proportionally
    final score = ((totalMeals - violationCount) / totalMeals) * 100;
    return score.clamp(0.0, 100.0);
  }

  List<RuleViolation> _checkExclusionRule(DietRule rule, List<FoodLog> logs) {
    final violations = <RuleViolation>[];

    for (final log in logs) {
      for (final foodItem in log.foodItems) {
        if (foodItem.categories.contains(rule.category)) {
          violations.add(RuleViolation(
            rule: rule,
            foodLog: log,
            foodItem: foodItem,
            message: rule.violationMessage ??
              '${foodItem.name} contains ${rule.category.name}',
          ));
        }
      }
    }

    return violations;
  }

  List<RuleViolation> _checkTimeRule(DietRule rule, List<FoodLog> logs) {
    final violations = <RuleViolation>[];

    for (final log in logs) {
      final logTime = TimeOfDay.fromDateTime(log.timestamp);

      if (rule.type == DietRuleType.eatingWindowStart) {
        if (_isTimeBefore(logTime, rule.timeValue!)) {
          violations.add(RuleViolation(
            rule: rule,
            foodLog: log,
            message: 'Eating before ${_formatTime(rule.timeValue!)} '
              'breaks your fasting window',
          ));
        }
      }

      if (rule.type == DietRuleType.eatingWindowEnd) {
        if (_isTimeAfter(logTime, rule.timeValue!)) {
          violations.add(RuleViolation(
            rule: rule,
            foodLog: log,
            message: 'Eating after ${_formatTime(rule.timeValue!)} '
              'breaks your fasting window',
          ));
        }
      }
    }

    return violations;
  }
}
```

### 5.2 Violation Severity Weighting

| Severity | Weight | Impact on Score |
|----------|--------|-----------------|
| Violation | 1.0 | Full point deduction |
| Warning | 0.5 | Half point deduction |
| Info | 0.0 | No impact (tracking only) |

### 5.3 Daily vs Weekly vs Monthly Compliance

```dart
class ComplianceMetrics {
  final double dailyScore;        // Today's compliance
  final double weeklyScore;       // Last 7 days average
  final double monthlyScore;      // Last 30 days average
  final int currentStreak;        // Days at 100% compliance
  final int longestStreak;        // Best streak ever
  final List<RuleViolation> recentViolations;
  final Map<DietRuleType, int> violationsByType;
}
```

---

## 6. Real-Time Violation Alerts

### 6.1 Pre-Log Warning

When user selects a food item, check against diet rules BEFORE logging:

```
┌─────────────────────────────────────────────────────────────────────┐
│  ⚠️  DIET ALERT                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  "Cheese Pizza" may conflict with your Paleo diet:                 │
│                                                                     │
│  ❌ Contains DAIRY (cheese)                                         │
│  ❌ Contains GRAINS (wheat crust)                                   │
│                                                                     │
│  Logging this will reduce today's compliance by ~15%               │
│                                                                     │
│  Current compliance: 92%                                            │
│  After logging: ~77%                                                │
│                                                                     │
│        [Cancel]        [Log Anyway]        [Find Alternative]      │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 6.2 Time-Based Warning (Intermittent Fasting)

```
┌─────────────────────────────────────────────────────────────────────┐
│  ⏰  FASTING WINDOW ALERT                                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Your eating window hasn't started yet.                            │
│                                                                     │
│  Current time: 10:30 AM                                            │
│  Eating window: 12:00 PM - 8:00 PM                                 │
│                                                                     │
│  Time until eating window: 1 hour 30 minutes                       │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ 🌙 FASTING ░░░░░░░░░░░░░░░│ 🍽️ EATING ░░░░░░░░│ 🌙 FASTING │   │
│  │ 12AM          8AM    12PM              8PM          12AM    │   │
│  │                 ▲                                            │   │
│  │              You are here                                    │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│        [Cancel]        [Log Anyway (Breaks Fast)]                  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 6.3 Macro Limit Warning (Keto)

```
┌─────────────────────────────────────────────────────────────────────┐
│  🥑  CARB LIMIT WARNING                                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Adding "Apple (medium)" will exceed your daily carb limit.        │
│                                                                     │
│  Carbs in this item: 25g                                           │
│  Already consumed today: 12g                                       │
│  Daily limit: 20g                                                  │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ Current: ████████████░░░░░░░░░░░░░░░░░░░░  12g / 20g (60%) │   │
│  │ After:   ██████████████████████████████████████  37g (185%)│   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  Keto-friendly alternatives:                                        │
│  • Berries (1/2 cup) - 6g carbs                                    │
│  • Avocado - 2g carbs                                              │
│                                                                     │
│        [Cancel]        [Log Anyway]        [View Alternatives]     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 7. Compliance Dashboard

### 7.1 Food Tab Header with Compliance

```
┌─────────────────────────────────────────────────────────────────────┐
│  FOOD                                               [+ Log Food]    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  🥗 PALEO DIET                           Today: 92%         │   │
│  │  ────────────────────────────────────────────────────────   │   │
│  │                                                             │   │
│  │  ████████████████████████████████████████████░░░░  92%     │   │
│  │                                                             │   │
│  │  This Week: 88%    This Month: 91%    Streak: 5 days       │   │
│  │                                                             │   │
│  │  ⚠️ 1 violation today: Cheese (dairy) at lunch             │   │
│  │                                                             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  TODAY'S MEALS                                                      │
│  ─────────────                                                      │
│  ...                                                                │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 7.2 Detailed Compliance View

```
┌─────────────────────────────────────────────────────────────────────┐
│  PALEO DIET COMPLIANCE                              [Edit Diet]     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  OVERALL SCORE                                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                                                             │   │
│  │                        ┌───────┐                            │   │
│  │                        │       │                            │   │
│  │                        │  91%  │                            │   │
│  │                        │       │                            │   │
│  │                        └───────┘                            │   │
│  │                      Last 30 Days                           │   │
│  │                                                             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  TREND                                                              │
│  ─────                                                              │
│  100%│          ●───●                    ●───●───●                 │
│   90%│     ●───●     ╲          ●───●───●                          │
│   80%│────●           ╲────●───●                                   │
│   70%│                                                              │
│      └──────────────────────────────────────────────────────────   │
│       Wk1    Wk2    Wk3    Wk4    Wk5    Wk6    Wk7    Wk8        │
│                                                                     │
│  RULE COMPLIANCE                                                    │
│  ───────────────                                                    │
│  ✓ No grains              100%  ████████████████████████████████   │
│  ✓ No legumes             100%  ████████████████████████████████   │
│  ⚠️ No dairy               85%  ███████████████████████████░░░░░   │
│  ✓ No processed foods      98%  ███████████████████████████████░   │
│  ✓ No added sugar         100%  ████████████████████████████████   │
│                                                                     │
│  RECENT VIOLATIONS                                                  │
│  ─────────────────                                                  │
│  • Jan 31, 12:30 PM - Cheese (dairy)                               │
│  • Jan 28, 7:00 PM - Ice cream (dairy, sugar)                      │
│  • Jan 25, 1:15 PM - Bread (grains)                                │
│                                                                     │
│  STREAK                                                             │
│  ──────                                                             │
│  Current: 2 days    Best: 14 days (Jan 5-18)                       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 7.3 Intermittent Fasting Dashboard

```
┌─────────────────────────────────────────────────────────────────────┐
│  16:8 INTERMITTENT FASTING                          [Edit Window]   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  TODAY'S FASTING TIMER                                              │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                                                             │   │
│  │  🌙 CURRENTLY FASTING                                       │   │
│  │                                                             │   │
│  │                    14:32:17                                 │   │
│  │                  Hours Fasted                               │   │
│  │                                                             │   │
│  │  ████████████████████████████████████░░░░░░░░░░  14.5/16h  │   │
│  │                                                             │   │
│  │  Eating window opens in: 1h 28m                             │   │
│  │                                                             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  TODAY'S TIMELINE                                                   │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                                                             │   │
│  │  12AM    4AM    8AM    12PM    4PM    8PM    12AM          │   │
│  │  │░░░░░░░░░░░░░░░░░░░│████████████████████│░░░░░░░│        │   │
│  │  └── Last meal ──────┘└── Window open ────┘                │   │
│  │      8:00 PM              12:00 PM - 8:00 PM               │   │
│  │                                                             │   │
│  │  ▼ Now (10:32 AM)                                          │   │
│  │                                                             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  THIS WEEK                                                          │
│  ─────────                                                          │
│  Mon: ✓ 16.2h    Tue: ✓ 17.0h    Wed: ✓ 16.5h    Thu: ⏳          │
│  Fri: -          Sat: -          Sun: -                            │
│                                                                     │
│  Weekly Compliance: 100% (3/3 days)                                │
│  Average Fast: 16.6 hours                                          │
│  Current Streak: 12 days                                           │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 8. Custom Diet Creation

### 8.1 Diet Builder UI

```
┌─────────────────────────────────────────────────────────────────────┐
│  CREATE CUSTOM DIET                                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Diet Name: [My Elimination Diet                    ]               │
│                                                                     │
│  Start From:                                                        │
│  ○ Blank (no rules)                                                │
│  ● Preset: [Paleo ▼] (then customize)                              │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  FOOD RESTRICTIONS                                                  │
│                                                                     │
│  Exclude completely:                                                │
│  ☑ Grains    ☑ Dairy    ☑ Legumes    ☑ Sugar                      │
│  ☑ Eggs      ☑ Nightshades    ☐ Nuts    ☐ Seeds                   │
│                                                                     │
│  Limit (servings per day):                                          │
│  Fruits: [1 ▼]    Nuts: [Unlimited ▼]                              │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  TIME RESTRICTIONS                                                  │
│                                                                     │
│  ☑ Enable eating window                                            │
│     Start: [12:00 PM ▼]    End: [8:00 PM ▼]                        │
│                                                                     │
│  ☐ Fasting days (for 5:2 style)                                    │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  MACRO LIMITS (optional)                                            │
│                                                                     │
│  ☐ Limit carbs: [    ] g/day                                       │
│  ☐ Limit calories: [    ] cal/day                                  │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  Duration:                                                          │
│  ○ Ongoing                                                          │
│  ● Fixed period: [30 ▼] days (for elimination diets)               │
│                                                                     │
│                    [Cancel]        [Save Diet]                      │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 8.2 Add Custom Rule

```
┌─────────────────────────────────────────────────────────────────────┐
│  ADD CUSTOM RULE                                                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Rule Type: [Exclude specific ingredient ▼]                        │
│                                                                     │
│  Ingredient Name: [Histamine-rich foods            ]               │
│                                                                     │
│  Examples (for matching):                                           │
│  [aged cheese, fermented foods, wine, cured meats  ]               │
│                                                                     │
│  Severity:                                                          │
│  ● Violation (strict - affects compliance score)                   │
│  ○ Warning (discouraged but allowed)                               │
│  ○ Info (tracking only)                                            │
│                                                                     │
│  Custom message when violated:                                      │
│  [This food may trigger histamine reactions        ]               │
│                                                                     │
│                    [Cancel]        [Add Rule]                       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 9. Diet Reports

### 9.1 Compliance Report (PDF)

```
┌─────────────────────────────────────────────────────────────────────┐
│  DIET COMPLIANCE REPORT                                             │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  Profile: [Name]                                                    │
│  Diet: Paleo + 16:8 Intermittent Fasting                           │
│  Period: January 1-31, 2026                                        │
│                                                                     │
│  ═══════════════════════════════════════════════════════════════   │
│                                                                     │
│  EXECUTIVE SUMMARY                                                  │
│  ─────────────────                                                  │
│                                                                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                │
│  │   OVERALL   │  │    FOOD     │  │   TIMING    │                │
│  │             │  │   RULES     │  │   RULES     │                │
│  │    88%      │  │    91%      │  │    85%      │                │
│  │  Compliance │  │  Compliance │  │  Compliance │                │
│  └─────────────┘  └─────────────┘  └─────────────┘                │
│                                                                     │
│  ═══════════════════════════════════════════════════════════════   │
│                                                                     │
│  FOOD RULE COMPLIANCE                                               │
│  ─────────────────────                                              │
│                                                                     │
│  Rule                    Compliance    Violations                   │
│  ────────────────────────────────────────────────                  │
│  No grains               100%          0                           │
│  No legumes              100%          0                           │
│  No dairy                 85%          5                           │
│  No processed foods       98%          1                           │
│  No added sugar          100%          0                           │
│                                                                     │
│  ═══════════════════════════════════════════════════════════════   │
│                                                                     │
│  FASTING COMPLIANCE                                                 │
│  ───────────────────                                                │
│                                                                     │
│  Days with 16+ hour fast: 26/31 (84%)                              │
│  Average fasting duration: 16.2 hours                              │
│  Longest fast: 18.5 hours (Jan 15)                                 │
│  Eating window violations: 5                                        │
│                                                                     │
│  ═══════════════════════════════════════════════════════════════   │
│                                                                     │
│  VIOLATION LOG                                                      │
│  ─────────────                                                      │
│                                                                     │
│  Date       Time     Violation                                      │
│  ─────────────────────────────────────────────                     │
│  Jan 31    12:30 PM  Cheese (dairy)                                │
│  Jan 28     7:00 PM  Ice cream (dairy, sugar)                      │
│  Jan 25     1:15 PM  Bread (grains)                                │
│  Jan 22    10:30 AM  Coffee with cream before window               │
│  Jan 18     9:45 PM  Late snack outside eating window              │
│  ...                                                                │
│                                                                     │
│  ═══════════════════════════════════════════════════════════════   │
│                                                                     │
│  TRENDS                                                             │
│  ──────                                                             │
│                                                                     │
│  [Weekly compliance trend chart]                                    │
│                                                                     │
│  Improvement: +8% from previous month                              │
│  Best week: Week 3 (96% compliance)                                │
│  Worst week: Week 1 (78% compliance)                               │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 10. Database Schema

### 10.1 New Tables

```sql
-- Diet definitions
CREATE TABLE diets (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  name TEXT NOT NULL,
  preset_id TEXT,                    -- NULL for custom diets
  is_active INTEGER NOT NULL DEFAULT 1,
  start_date INTEGER,                -- For fixed-duration diets
  end_date INTEGER,
  eating_window_start INTEGER,       -- Minutes from midnight
  eating_window_end INTEGER,

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

-- Diet rules (for custom diets)
CREATE TABLE diet_rules (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  diet_id TEXT NOT NULL,
  rule_type INTEGER NOT NULL,        -- DietRuleType enum
  severity INTEGER NOT NULL,         -- RuleSeverity enum
  category INTEGER,                  -- FoodCategory enum (if applicable)
  ingredient_name TEXT,              -- For ingredient-specific rules
  numeric_value REAL,                -- For limits
  time_value INTEGER,                -- Minutes from midnight
  days_of_week TEXT,                 -- Comma-separated (for day-specific)
  description TEXT,
  violation_message TEXT,

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

  FOREIGN KEY (diet_id) REFERENCES diets(id) ON DELETE CASCADE
);

-- Food item category tags
CREATE TABLE food_item_categories (
  food_item_id TEXT NOT NULL,
  category INTEGER NOT NULL,         -- FoodCategory enum

  PRIMARY KEY (food_item_id, category),
  FOREIGN KEY (food_item_id) REFERENCES food_items(id) ON DELETE CASCADE
);

-- Diet violations log
CREATE TABLE diet_violations (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  diet_id TEXT NOT NULL,
  food_log_id TEXT NOT NULL,
  rule_id TEXT,                      -- NULL for preset rules
  rule_type INTEGER NOT NULL,
  severity INTEGER NOT NULL,
  message TEXT NOT NULL,
  timestamp INTEGER NOT NULL,

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

  FOREIGN KEY (diet_id) REFERENCES diets(id) ON DELETE CASCADE,
  FOREIGN KEY (food_log_id) REFERENCES food_logs(id) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX idx_diets_profile ON diets(profile_id, is_active);
CREATE INDEX idx_diet_rules_diet ON diet_rules(diet_id);
CREATE INDEX idx_food_categories_item ON food_item_categories(food_item_id);
CREATE INDEX idx_diet_violations_diet ON diet_violations(diet_id, timestamp DESC);
CREATE INDEX idx_diet_violations_profile ON diet_violations(profile_id, timestamp DESC);
```

### 10.2 Food Items Update

```sql
-- Add nutritional info columns to food_items
ALTER TABLE food_items ADD COLUMN serving_size REAL;
ALTER TABLE food_items ADD COLUMN serving_unit TEXT;
ALTER TABLE food_items ADD COLUMN calories REAL;
ALTER TABLE food_items ADD COLUMN carbs_grams REAL;
ALTER TABLE food_items ADD COLUMN fat_grams REAL;
ALTER TABLE food_items ADD COLUMN protein_grams REAL;
ALTER TABLE food_items ADD COLUMN fiber_grams REAL;
ALTER TABLE food_items ADD COLUMN sugar_grams REAL;
```

---

## 11. Notifications Integration

### 11.1 Diet-Related Notifications

| Notification Type | Trigger | Message |
|-------------------|---------|---------|
| `fasting_window_start` | Eating window opens | "Your eating window is now open (12 PM - 8 PM)" |
| `fasting_window_end` | 30 min before close | "Your eating window closes in 30 minutes" |
| `fasting_window_closed` | Window closes | "Fasting period has begun. Stay strong!" |
| `diet_streak` | Milestone reached | "Amazing! You've been 100% compliant for 7 days!" |
| `diet_weekly_summary` | Weekly | "Last week: 92% diet compliance. Great work!" |

---

## 12. Acceptance Criteria

### Diet Setup
- [ ] User can select from 20+ preset diets
- [ ] User can create custom diet with food/time/macro rules
- [ ] User can combine multiple diet types (e.g., Paleo + 16:8)
- [ ] User can set diet duration (ongoing or fixed period)
- [ ] User can modify eating window times

### Food Tagging
- [ ] Food items have category tags (meat, dairy, grains, etc.)
- [ ] Common foods are pre-tagged in system database
- [ ] User can edit category tags on custom food items
- [ ] Nutritional info is optional but enables macro tracking

### Compliance Tracking
- [ ] Real-time compliance percentage displayed
- [ ] Daily, weekly, monthly compliance scores calculated
- [ ] Compliance streak tracking with milestone alerts
- [ ] Trend charts show compliance over time

### Violation Alerts
- [ ] Pre-log warning shows before adding violating food
- [ ] Warning shows impact on compliance score
- [ ] Fasting window violations show countdown timer
- [ ] Macro limit warnings show current vs limit
- [ ] User can choose to log anyway or find alternatives

### Intermittent Fasting
- [ ] Live fasting timer shows hours/minutes fasted
- [ ] Visual timeline shows fasting vs eating periods
- [ ] "Current status" shows fasting or eating mode
- [ ] Weekly fasting log shows each day's fast duration

### Reporting
- [ ] Diet compliance report available as standalone PDF
- [ ] Report shows rule-by-rule compliance breakdown
- [ ] Report includes violation log with dates/times
- [ ] Report shows trend analysis and improvement

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-31 | Initial release |
