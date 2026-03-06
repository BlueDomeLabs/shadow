# Shadow Localization Guide

**Version:** 1.0
**Last Updated:** January 30, 2026
**Supported Languages:** English, Spanish, French, German, Chinese, Arabic

---

## Overview

Shadow uses Flutter's built-in localization system with ARB (Application Resource Bundle) files. This guide covers implementation, adding translations, and testing localization.

---

## 1. Supported Locales

### 1.1 Current Languages

| Language | Locale Code | Direction | Status |
|----------|-------------|-----------|--------|
| English | `en` | LTR | Complete (Template) |
| Spanish | `es` | LTR | Complete |
| French | `fr` | LTR | Partial |
| German | `de` | LTR | Partial |
| Chinese (Simplified) | `zh` | LTR | Partial |
| Arabic | `ar` | RTL | Partial |

### 1.2 File Locations

```
lib/l10n/
├── l10n.yaml                 # Generation configuration
├── app_en.arb                # English (template)
├── app_es.arb                # Spanish
├── app_fr.arb                # French
├── app_de.arb                # German
├── app_zh.arb                # Chinese
├── app_ar.arb                # Arabic (RTL)
├── app_localizations.dart    # Generated base class
└── app_localizations_*.dart  # Generated locale classes
```

---

## 2. Configuration

### 2.1 l10n.yaml

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
synthetic-package: true
nullable-getter: false
```

### 2.2 App Configuration (main.dart)

```dart
MaterialApp(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('de'),
    Locale('zh'),
    Locale('ar'),
  ],
)
```

### 2.3 Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2
```

---

## 3. ARB File Structure

### 3.1 Basic Strings

```json
{
  "@@locale": "en",

  "appTitle": "Shadow",
  "@appTitle": {
    "description": "The application title"
  },

  "cancel": "Cancel",
  "@cancel": {
    "description": "Cancel button text"
  },

  "save": "Save",
  "@save": {
    "description": "Save button text"
  }
}
```

### 3.2 Parameterized Strings

```json
{
  "signedInAs": "Signed in as {email}",
  "@signedInAs": {
    "description": "Shows the signed in user email",
    "placeholders": {
      "email": {
        "type": "String",
        "example": "user@example.com"
      }
    }
  },

  "errorLoadingData": "Error loading {dataType}: {error}",
  "@errorLoadingData": {
    "description": "Error message with data type and error details",
    "placeholders": {
      "dataType": {
        "type": "String"
      },
      "error": {
        "type": "String"
      }
    }
  }
}
```

### 3.3 Pluralization

```json
{
  "itemsCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
  "@itemsCount": {
    "description": "Number of items with proper pluralization",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  },

  "daysAgo": "{count, plural, =1{1 day ago} other{{count} days ago}}",
  "@daysAgo": {
    "description": "Relative time in days",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

### 3.4 Arabic Pluralization (Extended Rules)

Arabic requires special plural rules:

```json
{
  "itemsCount": "{count, plural, =0{لا توجد عناصر} =1{عنصر واحد} =2{عنصران} few{{count} عناصر} many{{count} عنصرًا} other{{count} عنصر}}",
  "@itemsCount": {
    "description": "Number of items with Arabic plural rules",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

Arabic plural categories:
- `=0` - zero
- `=1` - one
- `=2` - two
- `few` - 3-10
- `many` - 11-99
- `other` - 100+

---

## 4. Using Translations

### 4.1 Basic Usage

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Text(l10n.appTitle),           // "Shadow"
        Text(l10n.cancel),             // "Cancel"
        Text(l10n.save),               // "Save"
      ],
    );
  }
}
```

### 4.2 Parameterized Strings

```dart
final l10n = AppLocalizations.of(context)!;

// With parameters
Text(l10n.signedInAs('user@example.com'))
// "Signed in as user@example.com"

Text(l10n.errorLoadingData('supplements', 'Network error'))
// "Error loading supplements: Network error"
```

### 4.3 Pluralization

```dart
final l10n = AppLocalizations.of(context)!;

Text(l10n.itemsCount(0))   // "No items"
Text(l10n.itemsCount(1))   // "1 item"
Text(l10n.itemsCount(5))   // "5 items"

Text(l10n.daysAgo(1))      // "1 day ago"
Text(l10n.daysAgo(7))      // "7 days ago"
```

### 4.4 Getting Current Locale

```dart
Locale currentLocale = Localizations.localeOf(context);

if (currentLocale.languageCode == 'ar') {
  // Handle Arabic-specific logic
}
```

---

## 5. Adding New Translations

### 5.1 Step 1: Add to Template (app_en.arb)

```json
{
  "newFeatureTitle": "New Feature",
  "@newFeatureTitle": {
    "description": "Title for the new feature screen"
  }
}
```

### 5.2 Step 2: Add to All Locale Files

**app_es.arb:**
```json
{
  "newFeatureTitle": "Nueva Función"
}
```

**app_fr.arb:**
```json
{
  "newFeatureTitle": "Nouvelle Fonctionnalité"
}
```

### 5.3 Step 3: Regenerate

```bash
flutter gen-l10n
# or
flutter pub get
```

### 5.4 Step 4: Use in Code

```dart
Text(l10n.newFeatureTitle)
```

---

## 6. Key Naming Conventions

### 6.1 Naming Patterns

| Category | Pattern | Example |
|----------|---------|---------|
| Screen titles | `{screen}Title` | `addSupplementTitle` |
| Button labels | `{action}Button` or just `{action}` | `saveButton`, `cancel` |
| Field labels | `{field}Label` | `nameLabel` |
| Field hints | `{field}Hint` | `nameHint` |
| Validation errors | `{field}Required` or `validation{Error}` | `nameRequired` |
| Empty states | `{feature}EmptyState` | `supplementsEmptyState` |
| Error messages | `error{Description}` | `errorLoadingSupplements` |
| Confirmations | `confirm{Action}` | `confirmDeleteSupplement` |
| Accessibility | `a11y{Element}{Action}` | `a11yAddSupplementButton` |

### 6.2 Examples

```json
{
  "addSupplementTitle": "Add Supplement",
  "editSupplementTitle": "Edit Supplement",
  "supplementsTitle": "Supplements",

  "saveButton": "Save",
  "cancelButton": "Cancel",
  "deleteButton": "Delete",

  "nameLabel": "Name",
  "dosageLabel": "Dosage",

  "nameHint": "Enter supplement name",
  "dosageHint": "Enter dosage amount",

  "nameRequired": "Name is required",
  "validationRequired": "{field} is required",

  "supplementsEmptyState": "No supplements yet",
  "supplementsEmptyStateHint": "Tap + to add your first supplement",

  "errorLoadingSupplements": "Failed to load supplements",
  "errorSavingSupplement": "Failed to save supplement",

  "confirmDeleteSupplement": "Delete this supplement?",
  "confirmDeleteSupplementMessage": "This action cannot be undone.",

  "a11yAddSupplementButton": "Add new supplement",
  "a11ySupplementCard": "Supplement: {name}, {dosage}"
}
```

---

## 7. RTL Support (Arabic)

### 7.1 Directional Widgets

Use directional variants for RTL compatibility:

```dart
// CORRECT: Directional
Padding(
  padding: EdgeInsetsDirectional.only(start: 16, end: 8),
  child: Row(
    children: [
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text('Label'),
      ),
    ],
  ),
)

// WRONG: Fixed direction
Padding(
  padding: EdgeInsets.only(left: 16, right: 8),  // Doesn't flip for RTL
)
```

### 7.2 Directional Icons

```dart
// Icons that should flip
Icon(Icons.arrow_forward)  // Automatically flips in RTL

// Or use directional variant
Icon(Icons.arrow_forward_ios)

// Check direction manually if needed
Directionality.of(context) == TextDirection.rtl
    ? Icon(Icons.arrow_back)
    : Icon(Icons.arrow_forward)
```

### 7.3 Text Alignment

```dart
Text(
  content,
  textAlign: TextAlign.start,  // Respects text direction
)
```

---

## 8. Date & Number Formatting

### 8.1 Date Formatting

Use `intl` package with locale:

```dart
import 'package:intl/intl.dart';

String formatDate(DateTime date, BuildContext context) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.yMMMd(locale).format(date);
  // English: "Jan 30, 2026"
  // German: "30. Jan. 2026"
  // Arabic: "٣٠ يناير ٢٠٢٦"
}
```

### 8.2 Number Formatting

```dart
String formatNumber(num value, BuildContext context) {
  final locale = Localizations.localeOf(context).toString();
  return NumberFormat.decimalPattern(locale).format(value);
  // English: "1,234.56"
  // German: "1.234,56"
  // Arabic: "١٬٢٣٤٫٥٦"
}
```

### 8.3 Currency Formatting

```dart
String formatCurrency(double amount, BuildContext context) {
  final locale = Localizations.localeOf(context).toString();
  return NumberFormat.currency(
    locale: locale,
    symbol: '\$',
  ).format(amount);
}
```

---

## 9. Testing Localization

### 9.1 Widget Tests

```dart
testWidgets('displays localized title', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('es'),  // Force Spanish
      home: MyScreen(),
    ),
  );

  expect(find.text('Suplementos'), findsOneWidget);  // Spanish title
});
```

### 9.2 Testing All Locales

```dart
void main() {
  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('renders in ${locale.languageCode}', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          home: MyScreen(),
        ),
      );

      // Verify no overflow or rendering errors
      expect(tester.takeException(), isNull);
    });
  }
}
```

### 9.3 Manual Testing

1. Change device language in Settings
2. Restart app
3. Verify all text displays in target language
4. Check RTL layout for Arabic
5. Verify date/number formatting

---

## 10. Translation Workflow

### 10.1 For Developers

1. Add new string to `app_en.arb` with description
2. Run `flutter gen-l10n`
3. Use generated getter in code
4. Mark PR for translation

### 10.2 For Translators

1. Copy key from `app_en.arb`
2. Add translation to target locale file
3. Preserve placeholders exactly (`{name}`, `{count}`)
4. Follow plural rules for language
5. Test in app

### 10.3 Quality Checklist

- [ ] All keys from template present in translation
- [ ] Placeholders preserved exactly
- [ ] Plural forms correct for language
- [ ] Text fits in UI (test visually)
- [ ] No hardcoded strings in code
- [ ] RTL layout tested (Arabic)

---

## 11. Common String Categories

### 11.1 Navigation

```json
{
  "home": "Home",
  "settings": "Settings",
  "profile": "Profile",
  "back": "Back",
  "close": "Close"
}
```

### 11.2 Actions

```json
{
  "add": "Add",
  "edit": "Edit",
  "delete": "Delete",
  "save": "Save",
  "cancel": "Cancel",
  "confirm": "Confirm",
  "retry": "Retry",
  "refresh": "Refresh"
}
```

### 11.3 Status

```json
{
  "loading": "Loading...",
  "saving": "Saving...",
  "syncing": "Syncing...",
  "success": "Success",
  "error": "Error",
  "noData": "No data available"
}
```

### 11.4 Time

```json
{
  "today": "Today",
  "yesterday": "Yesterday",
  "thisWeek": "This Week",
  "thisMonth": "This Month",
  "justNow": "Just now",
  "minutesAgo": "{count} minutes ago",
  "hoursAgo": "{count} hours ago",
  "daysAgo": "{count} days ago"
}
```

### 11.5 Fluids (NEW)

```json
{
  "fluids": "Fluids",
  "fluidsTab": "Fluids",
  "addFluidsEntry": "Add Fluids Entry",
  "editFluidsEntry": "Edit Fluids Entry",
  "fluidsEmptyState": "No fluids entries yet",
  "fluidsEmptyStateHint": "Track bowel movements, urination, menstruation, and temperature",

  "menstruation": "Menstruation",
  "menstruationFlow": "Flow Intensity",
  "flowNone": "None",
  "flowSpotty": "Spotty",
  "flowLight": "Light",
  "flowMedium": "Medium",
  "flowHeavy": "Heavy",

  "basalBodyTemperature": "Basal Body Temperature",
  "bbt": "BBT",
  "recordBBT": "Record Temperature",
  "bbtChart": "Temperature Chart",
  "bbtRecordedAt": "Recorded at {time}",
  "temperatureFahrenheit": "°F",
  "temperatureCelsius": "°C",

  "bowelMovement": "Bowel Movement",
  "urineMovement": "Urination"
}
```

### 11.6 Diet Types (NEW)

```json
{
  "dietType": "Diet Type",
  "dietDescription": "Diet Description",
  "selectDietType": "Select your diet type",

  "dietNone": "No specific diet",
  "dietVegan": "Vegan",
  "dietVegetarian": "Vegetarian",
  "dietPaleo": "Paleo",
  "dietKeto": "Keto",
  "dietGlutenFree": "Gluten-Free",
  "dietOther": "Other",

  "dietDescriptionHint": "Describe your diet",
  "currentDiet": "Current Diet: {diet}"
}
```

### 11.7 Notifications (NEW)

```json
{
  "notifications": "Notifications",
  "notificationSettings": "Notification Settings",
  "enableNotifications": "Enable Notifications",
  "notificationsDisabled": "Notifications are disabled",
  "enableInSettings": "Enable in device settings",

  "supplementReminders": "Supplement Reminders",
  "mealReminders": "Meal Reminders",
  "fluidsReminders": "Fluids Reminders",
  "sleepReminders": "Sleep Reminders",

  "bedtimeReminder": "Bedtime Reminder",
  "wakeUpReminder": "Wake-up Reminder",

  "addReminderTime": "Add Reminder Time",
  "removeReminderTime": "Remove",
  "reminderTimes": "Reminder Times",

  "selectWeekdays": "Select Days",
  "everyday": "Every day",
  "weekdays": "Weekdays",
  "weekends": "Weekends",
  "monday": "Monday",
  "tuesday": "Tuesday",
  "wednesday": "Wednesday",
  "thursday": "Thursday",
  "friday": "Friday",
  "saturday": "Saturday",
  "sunday": "Sunday",
  "mondayShort": "Mon",
  "tuesdayShort": "Tue",
  "wednesdayShort": "Wed",
  "thursdayShort": "Thu",
  "fridayShort": "Fri",
  "saturdayShort": "Sat",
  "sundayShort": "Sun",

  "customMessage": "Custom Message",
  "customMessageHint": "Optional reminder message",

  "notificationTimeToTake": "Time to take {supplement}",
  "notificationMealReminder": "Time to log your meal",
  "notificationFluidsReminder": "Time to log fluids",
  "notificationBedtimeReminder": "Time to prepare for bed",
  "notificationWakeUpReminder": "Good morning! Log your sleep",

  "@_DIET_SYSTEM": {},
  "diet": "Diet",
  "diets": "Diets",
  "dietSettings": "Diet Settings",
  "activeDiet": "Active Diet",
  "noDietSelected": "No diet selected",
  "selectDiet": "Select Diet",
  "createCustomDiet": "Create Custom Diet",
  "editDiet": "Edit Diet",
  "dietName": "Diet Name",

  "@_PRESET_DIETS": {},
  "dietVegan": "Vegan",
  "dietVegetarian": "Vegetarian",
  "dietPescatarian": "Pescatarian",
  "dietPaleo": "Paleo",
  "dietKeto": "Ketogenic",
  "dietKetoStrict": "Strict Keto",
  "dietLowCarb": "Low Carb",
  "dietMediterranean": "Mediterranean",
  "dietWhole30": "Whole30",
  "dietAIP": "Autoimmune Protocol",
  "dietLowFodmap": "Low-FODMAP",
  "dietGlutenFree": "Gluten-Free",
  "dietDairyFree": "Dairy-Free",
  "dietIF168": "Intermittent Fasting 16:8",
  "dietIF186": "Intermittent Fasting 18:6",
  "dietIF204": "Intermittent Fasting 20:4",
  "dietOMAD": "One Meal A Day",
  "diet52": "5:2 Diet",
  "dietZone": "Zone Diet",
  "dietCustom": "Custom Diet",

  "@_DIET_COMPLIANCE": {},
  "compliance": "Compliance",
  "dietCompliance": "Diet Compliance",
  "todayCompliance": "Today's Compliance",
  "weeklyCompliance": "Weekly Compliance",
  "monthlyCompliance": "Monthly Compliance",
  "complianceScore": "{score}% Compliance",
  "@complianceScore": {"placeholders": {"score": {"type": "int"}}},
  "complianceTrend": "Compliance Trend",
  "violations": "Violations",
  "warnings": "Warnings",
  "noViolations": "No violations",
  "streak": "Streak",
  "currentStreak": "Current Streak",
  "longestStreak": "Longest Streak",
  "daysStreak": "{days} days",
  "@daysStreak": {"placeholders": {"days": {"type": "int"}}},

  "@_DIET_RULES": {},
  "dietRules": "Diet Rules",
  "addRule": "Add Rule",
  "editRule": "Edit Rule",
  "excludeCategory": "Exclude Category",
  "limitCategory": "Limit Category",
  "maxCarbs": "Max Carbs",
  "maxCalories": "Max Calories",
  "eatingWindow": "Eating Window",
  "eatingWindowStart": "Window Opens",
  "eatingWindowEnd": "Window Closes",

  "@_FOOD_CATEGORIES": {},
  "categoryMeat": "Meat",
  "categoryPoultry": "Poultry",
  "categoryFish": "Fish",
  "categoryEggs": "Eggs",
  "categoryDairy": "Dairy",
  "categoryGrains": "Grains",
  "categoryLegumes": "Legumes",
  "categoryNuts": "Nuts",
  "categorySugar": "Sugar",
  "categoryGluten": "Gluten",
  "categoryProcessed": "Processed Foods",
  "categoryAlcohol": "Alcohol",

  "@_INTERMITTENT_FASTING": {},
  "fasting": "Fasting",
  "fastingTimer": "Fasting Timer",
  "currentlyFasting": "Currently Fasting",
  "currentlyEating": "Eating Window",
  "hoursFasted": "Hours Fasted",
  "windowOpensIn": "Window opens in {time}",
  "@windowOpensIn": {"placeholders": {"time": {"type": "String"}}},
  "windowClosesIn": "Window closes in {time}",
  "@windowClosesIn": {"placeholders": {"time": {"type": "String"}}},
  "fastComplete": "Fast Complete!",
  "endFastEarly": "End Fast Early",

  "@_VIOLATION_ALERTS": {},
  "dietAlert": "Diet Alert",
  "violationWarning": "This may conflict with your diet",
  "carbLimitWarning": "This will exceed your carb limit",
  "fastingWarning": "You're still in your fasting window",
  "logAnyway": "Log Anyway",
  "findAlternatives": "Find Alternatives",
  "complianceImpact": "Compliance Impact"
}
```

### 11.5 Intelligence System Keys (Phase 3)

```json
{
  "insights": "Insights",
  "healthInsights": "Health Insights",
  "patterns": "Patterns",
  "triggers": "Triggers",
  "predictions": "Predictions",
  "dataQuality": "Data Quality",

  "patternDetected": "Pattern detected",
  "triggerFound": "Trigger found",
  "insightGenerated": "New insight",
  "predictionAlert": "Prediction alert",

  "highPriority": "High priority",
  "mediumPriority": "Medium priority",
  "lowPriority": "Low priority",

  "correlationStrength": "Correlation strength",
  "weak": "Weak",
  "moderate": "Moderate",
  "strong": "Strong",

  "relativeRisk": "Relative risk",
  "timesMoreLikely": "{count}x more likely",
  "@timesMoreLikely": {"placeholders": {"count": {"type": "double"}}},
  "percentLessLikely": "{percent}% less likely",
  "@percentLessLikely": {"placeholders": {"percent": {"type": "int"}}},

  "confidenceInterval": "95% confidence interval",
  "statisticalSignificance": "Statistical significance",
  "sampleSize": "Sample size",
  "dataPoints": "{count} data points",
  "@dataPoints": {"placeholders": {"count": {"type": "int"}}},

  "temporalPattern": "Timing pattern",
  "cyclicalPattern": "Cycle pattern",
  "sequentialPattern": "Sequential pattern",
  "clusterPattern": "Cluster pattern",

  "dayOfWeek": "Day of week",
  "timeOfDay": "Time of day",
  "peakTime": "Peak time",

  "triggerExposures": "Trigger exposures",
  "followedBy": "Followed by",
  "averageOnset": "Average time to onset",
  "hoursLater": "{hours} hours later",
  "@hoursLater": {"placeholders": {"hours": {"type": "double"}}},

  "flarePrediction": "Flare-up prediction",
  "probabilityOfFlare": "Probability of flare",
  "contributingFactors": "Contributing factors",
  "preventiveAction": "Suggested action",

  "periodPrediction": "Period prediction",
  "ovulationPrediction": "Ovulation prediction",
  "expectedIn": "Expected in {days} days",
  "@expectedIn": {"placeholders": {"days": {"type": "int"}}},

  "dataQualityScore": "Data quality score",
  "trackingCompleteness": "Tracking completeness",
  "featureAvailability": "Feature availability",
  "needsMoreData": "Needs {count} more {type}",
  "@needsMoreData": {"placeholders": {"count": {"type": "int"}, "type": {"type": "String"}}},

  "dismiss": "Dismiss",
  "viewDetails": "View details",
  "viewPattern": "View pattern",
  "viewProgress": "View progress",
  "addToReport": "Add to report",
  "shareWithProvider": "Share with provider",

  "gotIt": "Got it",
  "remindMeLater": "Remind me later",
  "thisDidntHappen": "This didn't happen",
  "thisHappened": "This happened",

  "insufficientData": "Insufficient data",
  "needMoreDataFor": "Need more data for {feature}",
  "@needMoreDataFor": {"placeholders": {"feature": {"type": "String"}}},

  "insightDisclaimer": "These insights are based on your logged data and are not medical advice. Always consult a healthcare provider for diagnosis and treatment decisions.",

  "eliminationTrial": "Elimination trial",
  "startEliminationTrial": "Start elimination trial"
}
```

### 11.8 Notification Type Messages (Complete - 21 types)

```json
{
  "@_NOTIFICATION_MESSAGES": {},
  "notificationSupplementIndividual": "Time to take {supplementName}",
  "@notificationSupplementIndividual": {"placeholders": {"supplementName": {"type": "String"}}},
  "notificationSupplementGrouped": "Time to take {count} supplements",
  "@notificationSupplementGrouped": {"placeholders": {"count": {"type": "int"}}},
  "notificationMealBreakfast": "Time to log your breakfast",
  "notificationMealLunch": "Time to log your lunch",
  "notificationMealDinner": "Time to log your dinner",
  "notificationMealSnacks": "Time to log your snacks",
  "notificationWaterInterval": "Stay hydrated! Time for water",
  "notificationWaterFixed": "Water reminder",
  "notificationWaterSmart": "You haven't logged water in a while",
  "notificationBbtMorning": "Record your basal body temperature now",
  "notificationMenstruationTracking": "Time to log menstruation",
  "notificationSleepBedtime": "Time to prepare for bed",
  "notificationSleepWakeup": "Good morning! Log your sleep",
  "notificationConditionCheckin": "How is your {conditionName} today?",
  "@notificationConditionCheckin": {"placeholders": {"conditionName": {"type": "String"}}},
  "notificationPhotoReminder": "Time for a progress photo",
  "notificationJournalPrompt": "Take a moment to journal",
  "notificationSyncReminder": "Your data hasn't synced in {days} days",
  "@notificationSyncReminder": {"placeholders": {"days": {"type": "int"}}},
  "notificationDietFastingWindow": "Your eating window {action} in {time}",
  "@notificationDietFastingWindow": {"placeholders": {"action": {"type": "String"}, "time": {"type": "String"}}},
  "notificationDietStreak": "Congratulations! {days} day diet streak!",
  "@notificationDietStreak": {"placeholders": {"days": {"type": "int"}}},
  "notificationDietWeeklySummary": "Your weekly diet summary is ready"
}
```

### 11.9 Error Messages (Complete - 51 error factories)

```json
{
  "@_ERROR_MESSAGES_DATABASE": {},
  "errorDbQueryFailed": "Unable to load data. Please try again.",
  "errorDbInsertFailed": "Unable to save data. Please try again.",
  "errorDbUpdateFailed": "Unable to update data. Please try again.",
  "errorDbDeleteFailed": "Unable to delete data. Please try again.",
  "errorDbNotFound": "The requested item could not be found.",
  "errorDbMigrationFailed": "Database upgrade failed. Please restart the app.",
  "errorDbConnectionFailed": "Unable to connect to database. Please restart the app.",
  "errorDbConstraintViolation": "This operation conflicts with existing data.",

  "@_ERROR_MESSAGES_NETWORK": {},
  "errorNetworkConnectionFailed": "Unable to connect. Please check your internet connection.",
  "errorNetworkTimeout": "The request timed out. Please try again.",
  "errorNetworkUnauthorized": "Your session has expired. Please sign in again.",
  "errorNetworkForbidden": "You don't have permission to perform this action.",
  "errorNetworkNotFound": "The requested resource could not be found.",
  "errorNetworkServerError": "Something went wrong on our end. Please try again later.",
  "errorNetworkSslError": "Secure connection failed. Please check your network.",
  "errorNetworkRateLimited": "Too many requests. Please wait a moment and try again.",

  "@_ERROR_MESSAGES_VALIDATION": {},
  "errorValidationRequired": "{field} is required",
  "@errorValidationRequired": {"placeholders": {"field": {"type": "String"}}},
  "errorValidationMinLength": "{field} must be at least {min} characters",
  "@errorValidationMinLength": {"placeholders": {"field": {"type": "String"}, "min": {"type": "int"}}},
  "errorValidationMaxLength": "{field} must be at most {max} characters",
  "@errorValidationMaxLength": {"placeholders": {"field": {"type": "String"}, "max": {"type": "int"}}},
  "errorValidationRange": "{field} must be between {min} and {max}",
  "@errorValidationRange": {"placeholders": {"field": {"type": "String"}, "min": {"type": "String"}, "max": {"type": "String"}}},
  "errorValidationFormat": "Invalid {field} format",
  "@errorValidationFormat": {"placeholders": {"field": {"type": "String"}}},
  "errorValidationFutureDate": "Date cannot be in the future",
  "errorValidationPastDate": "Date cannot be in the past",
  "errorValidationExpired": "This has expired. Please try again.",
  "errorValidationAlreadyUsed": "This has already been used.",

  "@_ERROR_MESSAGES_AUTH": {},
  "errorAuthInvalidCredentials": "Invalid email or password.",
  "errorAuthSessionExpired": "Your session has expired. Please sign in again.",
  "errorAuthAccountLocked": "Your account has been locked. Please contact support.",
  "errorAuthAccountDisabled": "Your account has been disabled.",
  "errorAuthEmailNotVerified": "Please verify your email address.",
  "errorAuthProviderError": "Authentication failed. Please try again.",
  "errorAuthRateLimited": "Too many attempts. Please try again in {minutes} minutes.",
  "@errorAuthRateLimited": {"placeholders": {"minutes": {"type": "int"}}},
  "errorAuthTokenRefreshFailed": "Unable to refresh your session. Please sign in again.",
  "errorAuthNoAccess": "You don't have access to this profile.",
  "errorAuthInsufficientLevel": "You don't have permission to perform this action.",
  "errorAuthAccessExpired": "Your access to this profile has expired.",

  "@_ERROR_MESSAGES_SYNC": {},
  "errorSyncFailed": "Sync failed. Please try again.",
  "errorSyncConflict": "Your changes conflict with changes on another device.",
  "errorSyncQuotaExceeded": "Storage quota exceeded. Please free up space.",
  "errorSyncNotAuthenticated": "Please sign in to sync your data.",
  "errorSyncCorrupted": "Sync data appears corrupted. Please contact support.",

  "@_ERROR_MESSAGES_FILE": {},
  "errorFileTooLarge": "File is too large. Maximum size is {max}.",
  "@errorFileTooLarge": {"placeholders": {"max": {"type": "String"}}},
  "errorFileInvalidType": "This file type is not supported.",
  "errorFileReadFailed": "Unable to read file.",
  "errorFileWriteFailed": "Unable to save file.",
  "errorFileNotFound": "File not found.",
  "errorFileUploadFailed": "Unable to upload file. Please try again."
}
```

### 11.10 Quiet Hours Settings

```json
{
  "@_QUIET_HOURS": {},
  "quietHours": "Quiet Hours",
  "quietHoursEnabled": "Enable Quiet Hours",
  "quietHoursStart": "Start Time",
  "quietHoursEnd": "End Time",
  "quietHoursAction": "During Quiet Hours",
  "quietHoursActionSilent": "Silence notifications",
  "quietHoursActionHold": "Hold until quiet hours end",
  "quietHoursActionDiscard": "Discard notifications",
  "quietHoursDescription": "Notifications won't disturb you during these hours",
  "quietHoursQueuedCount": "{count} notifications held",
  "@quietHoursQueuedCount": {"placeholders": {"count": {"type": "int"}}},
  "quietHoursActiveNow": "Quiet hours active",
  "quietHoursEndsAt": "Ends at {time}",
  "@quietHoursEndsAt": {"placeholders": {"time": {"type": "String"}}}
}
```

### 11.11 Smart Water Reminders

```json
{
  "@_SMART_WATER": {},
  "smartWaterReminders": "Smart Water Reminders",
  "smartWaterEnabled": "Enable Smart Reminders",
  "smartWaterDescription": "Get reminders based on your hydration patterns",
  "smartWaterMinInterval": "Minimum interval between reminders",
  "smartWaterDailyGoal": "Daily water goal",
  "smartWaterProgress": "{current} of {goal} {unit}",
  "@smartWaterProgress": {"placeholders": {"current": {"type": "int"}, "goal": {"type": "int"}, "unit": {"type": "String"}}},
  "smartWaterGoalReached": "Daily goal reached!",
  "smartWaterNoLogsToday": "No water logged yet today",
  "smartWaterLastLogged": "Last: {time}",
  "@smartWaterLastLogged": {"placeholders": {"time": {"type": "String"}}}
}
```

### 11.12 Fasting Window Messages

```json
{
  "@_FASTING_WINDOW": {},
  "fastingWindowTitle": "Fasting Window",
  "fastingWindowActive": "Currently fasting",
  "fastingWindowInactive": "Eating window",
  "fastingWindowOpensIn": "Eating window opens in {time}",
  "@fastingWindowOpensIn": {"placeholders": {"time": {"type": "String"}}},
  "fastingWindowClosesIn": "Eating window closes in {time}",
  "@fastingWindowClosesIn": {"placeholders": {"time": {"type": "String"}}},
  "fastingHoursCompleted": "{hours}h fasted",
  "@fastingHoursCompleted": {"placeholders": {"hours": {"type": "int"}}},
  "fastingWarningTitle": "You're in your fasting window",
  "fastingWarningBody": "Logging this food will break your fast",
  "breakFast": "Break Fast",
  "continuesFasting": "Continue Fasting"
}
```

### 11.13 Streak and Compliance Messages

```json
{
  "@_STREAK_MESSAGES": {},
  "streakDays": "{days} day streak",
  "@streakDays": {"placeholders": {"days": {"type": "int"}}},
  "streakBroken": "Streak broken",
  "streakNew": "New streak started!",
  "streakMilestone": "Milestone: {days} days!",
  "@streakMilestone": {"placeholders": {"days": {"type": "int"}}},
  "streakBest": "Best streak: {days} days",
  "@streakBest": {"placeholders": {"days": {"type": "int"}}},

  "complianceToday": "Today: {score}%",
  "@complianceToday": {"placeholders": {"score": {"type": "int"}}},
  "complianceWeek": "This week: {score}%",
  "@complianceWeek": {"placeholders": {"score": {"type": "int"}}},
  "compliancePerfect": "Perfect compliance!",
  "complianceViolationCount": "{count} violations today",
  "@complianceViolationCount": {"placeholders": {"count": {"type": "int"}}},
  "complianceImpactWarning": "This will reduce today's score by {percent}%",
  "@complianceImpactWarning": {"placeholders": {"percent": {"type": "double"}}}
}
```

### 11.14 Sync and Backup Messages

```json
{
  "@_SYNC_BACKUP": {},
  "syncStatus": "Sync Status",
  "syncLastSynced": "Last synced: {time}",
  "@syncLastSynced": {"placeholders": {"time": {"type": "String"}}},
  "syncNeverSynced": "Never synced",
  "syncInProgress": "Syncing...",
  "syncComplete": "Sync complete",
  "syncFailed": "Sync failed",
  "syncRetry": "Retry sync",
  "syncNow": "Sync now",
  "syncPendingChanges": "{count} changes pending sync",
  "@syncPendingChanges": {"placeholders": {"count": {"type": "int"}}},
  "syncNoChanges": "All changes synced",
  "syncConflictTitle": "Sync Conflict",
  "syncConflictBody": "Changes on another device conflict with yours",
  "syncConflictKeepLocal": "Keep this device",
  "syncConflictKeepRemote": "Keep other device",
  "syncConflictMerge": "Merge changes",

  "backupEnabled": "Cloud backup enabled",
  "backupDisabled": "Cloud backup disabled",
  "backupSetup": "Set up cloud backup",
  "backupDescription": "Your data is backed up to {provider}",
  "@backupDescription": {"placeholders": {"provider": {"type": "String"}}}
}
```

---

## 12. Troubleshooting

### 12.1 Generation Fails

```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter gen-l10n
```

### 12.2 Missing Translations

If a key is missing from a locale file, Flutter falls back to English (template).

### 12.3 Placeholder Mismatch

Ensure placeholders in translations exactly match the template:

```json
// Template
"greeting": "Hello, {name}!"

// CORRECT
"greeting": "¡Hola, {name}!"

// WRONG (different placeholder)
"greeting": "¡Hola, {nombre}!"  // Will fail
```

### 12.4 RTL Issues

```dart
// Force LTR for specific content (e.g., phone numbers)
Directionality(
  textDirection: TextDirection.ltr,
  child: Text('+1 (555) 123-4567'),
)
```

---

## 13. Adding a New Language

### 13.1 Step 1: Create ARB File

Create `lib/l10n/app_XX.arb` where XX is the locale code:

```json
{
  "@@locale": "XX",
  "appTitle": "Translated App Title",
  ...
}
```

### 13.2 Step 2: Add to Supported Locales

In `main.dart`:

```dart
supportedLocales: const [
  Locale('en'),
  Locale('es'),
  Locale('XX'),  // New locale
],
```

### 13.3 Step 3: Regenerate

```bash
flutter gen-l10n
```

### 13.4 Step 4: Test

Test app with new locale selected in device settings.

---

## 14. UI Field Localization Keys (287 keys)

This section contains all user-visible strings from UI screens that require localization. Keys are organized by screen/section. See `38_UI_FIELD_SPECIFICATIONS.md` for field specifications.

### 14.1 Authentication Screens (5 keys)

```json
{
  "tagline": "Your private health companion",
  "signInWithApple": "Sign in with Apple",
  "signInWithGoogle": "Sign in with Google",
  "continueOffline": "Continue Offline",
  "learnMore": "Learn More"
}
```

### 14.2 Profile Screens (15 keys)

```json
{
  "profileNamePlaceholder": "e.g., John Smith",
  "selectDatePlaceholder": "Select date",
  "biologicalSexSelect": "Select",
  "biologicalSexMale": "Male",
  "biologicalSexFemale": "Female",
  "biologicalSexOther": "Other",
  "biologicalSexPreferNotToSay": "Prefer not to say",
  "ethnicityPlaceholder": "e.g., Caucasian",
  "profileNotesPlaceholder": "Any additional notes about this profile",
  "selectDietPlaceholder": "Select diet",
  "dietDescriptionPlaceholder": "Describe your diet",
  "profileNameRequired": "Profile name is required",
  "profileNameMinLength": "Profile name must be at least 2 characters",
  "birthDateFutureError": "Birth date cannot be in the future"
}
```

### 14.3 Supplement Screens (42 keys)

```json
{
  "supplementNamePlaceholder": "e.g., Vitamin D3",
  "brandPlaceholder": "e.g., NOW Foods",
  "formCapsule": "Capsule",
  "formTablet": "Tablet",
  "formPowder": "Powder",
  "formLiquid": "Liquid",
  "formGummy": "Gummy",
  "formSpray": "Spray",
  "formOther": "Other",
  "describeFormPlaceholder": "Describe form",
  "dosageAmountPlaceholder": "e.g., 2000",
  "customUnitPlaceholder": "e.g., billion CFU",
  "addIngredientPlaceholder": "Add ingredient...",
  "frequencyDaily": "Daily",
  "frequencyEveryXDays": "Every X Days",
  "frequencySpecificDays": "Specific Days",
  "anchorWithBreakfast": "With Breakfast",
  "anchorWithLunch": "With Lunch",
  "anchorWithDinner": "With Dinner",
  "anchorMorning": "Morning",
  "anchorEvening": "Evening",
  "anchorBedtime": "Bedtime",
  "anchorSpecificTime": "Specific Time",
  "timingWith": "With",
  "timingBefore": "Before",
  "timingAfter": "After",
  "selectTimePlaceholder": "Select time",
  "startDatePlaceholder": "Start date",
  "endDateOptionalPlaceholder": "End date (optional)",
  "supplementNotesPlaceholder": "Any notes about this supplement",
  "statusTaken": "Taken",
  "statusSkipped": "Skipped",
  "statusSnoozed": "Snoozed",
  "timeTakenPlaceholder": "Time taken",
  "snoozeDuration5Min": "5 min",
  "snoozeDuration10Min": "10 min",
  "snoozeDuration15Min": "15 min",
  "snoozeDuration30Min": "30 min",
  "snoozeDuration60Min": "60 min",
  "skipReasonForgot": "Forgot",
  "skipReasonSideEffects": "Side Effects",
  "skipReasonOutOfStock": "Out of Stock"
}
```

### 14.4 Food Screens (10 keys)

```json
{
  "mealTypeBreakfast": "Breakfast",
  "mealTypeLunch": "Lunch",
  "mealTypeDinner": "Dinner",
  "mealTypeSnack": "Snack",
  "searchFoodsPlaceholder": "Search foods...",
  "addItemNotInLibraryPlaceholder": "Add item not in library...",
  "mealNotesPlaceholder": "Any notes about this meal",
  "foodNamePlaceholder": "e.g., Grilled Chicken",
  "foodTypeSimple": "Simple",
  "foodTypeComposed": "Composed"
}
```

### 14.5 Fluids Screens (37 keys)

```json
{
  "amountPlaceholder": "Amount",
  "waterNotesPlaceholder": "e.g., with lemon",
  "hadBowelMovement": "Had Bowel Movement",
  "conditionDiarrhea": "Diarrhea",
  "conditionRunny": "Runny",
  "conditionLoose": "Loose",
  "conditionNormal": "Normal",
  "conditionFirm": "Firm",
  "conditionHard": "Hard",
  "conditionCustom": "Custom",
  "describePlaceholder": "Describe",
  "sizeTiny": "Tiny",
  "sizeSmall": "Small",
  "sizeMedium": "Medium",
  "sizeLarge": "Large",
  "sizeHuge": "Huge",
  "addPhotoPlaceholder": "Add photo",
  "hadUrination": "Had Urination",
  "colorClear": "Clear",
  "colorLightYellow": "Light Yellow",
  "colorYellow": "Yellow",
  "colorDarkYellow": "Dark Yellow",
  "colorAmber": "Amber",
  "colorCustom": "Custom",
  "selectColorPlaceholder": "Select color",
  "flowLevelNone": "None",
  "flowLevelSpotty": "Spotty",
  "flowLevelLight": "Light",
  "flowLevelMedium": "Medium",
  "flowLevelHeavy": "Heavy",
  "temperaturePlaceholder": "e.g., 98.6",
  "timeMeasuredPlaceholder": "Time measured",
  "fluidNamePlaceholder": "e.g., Sweat, Mucus",
  "fluidAmountPlaceholder": "e.g., Light, Heavy, 2 tbsp",
  "additionalDetailsPlaceholder": "Additional details"
}
```

### 14.6 Sleep Screens (28 keys)

```json
{
  "bedTimePlaceholder": "When did you go to bed?",
  "wakeTimePlaceholder": "When did you wake up?",
  "timeToFallAsleepPlaceholder": "How long to fall asleep?",
  "fallAsleepImmediately": "Immediately",
  "fallAsleep5Min": "5 min",
  "fallAsleep15Min": "15 min",
  "fallAsleep30Min": "30 min",
  "fallAsleep1Hour": "1 hour",
  "fallAsleep1PlusHours": "1+ hours",
  "timesAwakenedPlaceholder": "Number of times",
  "timeAwakeNone": "None",
  "timeAwakeFewMin": "A few min",
  "timeAwake15Min": "15 min",
  "timeAwake30Min": "30 min",
  "timeAwake1Hour": "1 hour",
  "timeAwake1PlusHours": "1+ hours",
  "deepSleepPlaceholder": "Hours of deep sleep",
  "lightSleepPlaceholder": "Hours of light sleep",
  "restlessSleepPlaceholder": "Hours of restless sleep",
  "wakingFeelingGroggy": "Groggy",
  "wakingFeelingNeutral": "Neutral",
  "wakingFeelingRested": "Rested",
  "wakingFeelingEnergized": "Energized",
  "dreamTypeNone": "No Dreams",
  "dreamTypeVague": "Vague",
  "dreamTypeVivid": "Vivid",
  "dreamTypeNightmares": "Nightmares",
  "sleepNotesPlaceholder": "Any notes about your sleep"
}
```

### 14.7 Condition Screens (42 keys)

```json
{
  "conditionNamePlaceholder": "e.g., Eczema",
  "selectCategoryPlaceholder": "Select category",
  "categorySkin": "Skin",
  "categoryDigestive": "Digestive",
  "categoryRespiratory": "Respiratory",
  "categoryAutoimmune": "Autoimmune",
  "categoryMentalHealth": "Mental Health",
  "categoryPain": "Pain",
  "categoryOther": "Other",
  "selectAffectedAreas": "Select affected areas",
  "bodyLocationHead": "Head",
  "bodyLocationFace": "Face",
  "bodyLocationNeck": "Neck",
  "bodyLocationChest": "Chest",
  "bodyLocationBack": "Back",
  "bodyLocationStomach": "Stomach",
  "bodyLocationArms": "Arms",
  "bodyLocationHands": "Hands",
  "bodyLocationLegs": "Legs",
  "bodyLocationFeet": "Feet",
  "bodyLocationJoints": "Joints",
  "bodyLocationInternal": "Internal",
  "bodyLocationWholeBody": "Whole Body",
  "bodyLocationOther": "Other",
  "conditionDescriptionPlaceholder": "Describe the condition",
  "startTimeframeThisWeek": "This week",
  "startTimeframeThisMonth": "This month",
  "startTimeframeThisYear": "This year",
  "startTimeframe1To2Years": "1-2 years",
  "startTimeframe2To5Years": "2-5 years",
  "startTimeframe5PlusYears": "5+ years",
  "startTimeframeSinceBirth": "Since birth",
  "startTimeframeUnknown": "Unknown",
  "statusActive": "Active",
  "statusResolved": "Resolved",
  "addBaselinePhoto": "Add baseline photo",
  "severityMinimal": "Minimal",
  "severityModerate": "Moderate",
  "severitySevere": "Severe",
  "isFlareUp": "Is Flare-up",
  "selectTriggersPlaceholder": "Select triggers",
  "notesAboutTodayPlaceholder": "Notes about today"
}
```

### 14.8 Activity Screens (9 keys)

```json
{
  "activityNamePlaceholder": "e.g., Morning Jog",
  "describeActivityPlaceholder": "Describe this activity",
  "typicalDurationPlaceholder": "Typical duration",
  "locationPlaceholder": "e.g., Local park",
  "addPotentialTriggerPlaceholder": "Add potential trigger",
  "selectActivitiesPlaceholder": "Select activities",
  "addUnlistedActivityPlaceholder": "Add unlisted activity",
  "actualDurationPlaceholder": "Actual duration",
  "activityNotesPlaceholder": "Notes about this activity"
}
```

### 14.9 Journal Screens (12 keys)

```json
{
  "entryTitlePlaceholder": "Entry title (optional)",
  "journalContentPlaceholder": "Write your thoughts...",
  "addTagsPlaceholder": "Add tags",
  "howAreYouFeelingPlaceholder": "How are you feeling?",
  "moodGreat": "Great",
  "moodGood": "Good",
  "moodNeutral": "Neutral",
  "moodLow": "Low",
  "moodDifficult": "Difficult",
  "recordAudioNotePlaceholder": "Record audio note"
}
```

### 14.10 Photo Screens (4 keys)

```json
{
  "areaNamePlaceholder": "e.g., Left Arm",
  "consistencyNotesPlaceholder": "Tips for consistent photos (lighting, angle)",
  "photoNotesPlaceholder": "Notes about this photo",
  "linkToConditionPlaceholder": "Link to condition"
}
```

### 14.11 Notification Settings (8 keys)

```json
{
  "enableAllNotifications": "Enable All Notifications",
  "mealRemindersToggle": "Meal Reminders",
  "waterRemindersToggle": "Water Reminders",
  "sleepRemindersToggle": "Sleep Reminders",
  "fluidsRemindersToggle": "Fluids Reminders",
  "conditionCheckInsToggle": "Condition Check-ins",
  "photoRemindersToggle": "Photo Reminders",
  "respectSystemDND": "Respect System DND"
}
```

### 14.12 Settings Screens (25 keys)

```json
{
  "measurementSystemLabel": "Measurement System",
  "measurementMetric": "Metric",
  "measurementImperial": "Imperial",
  "temperatureLabel": "Temperature",
  "volumeLabel": "Volume",
  "weightLabel": "Weight",
  "cloudProviderLabel": "Cloud Provider",
  "cloudICloud": "iCloud",
  "cloudGoogleDrive": "Google Drive",
  "cloudOffline": "Offline",
  "autoSyncLabel": "Auto-Sync",
  "syncOnWiFiOnly": "Sync on WiFi Only",
  "lastSyncLabel": "Last Sync",
  "syncNowButton": "Sync Now",
  "appLockLabel": "App Lock",
  "lockMethodLabel": "Lock Method",
  "lockMethodBiometric": "Biometric",
  "lockMethodPIN": "PIN",
  "lockMethodBoth": "Both",
  "enterPINPlaceholder": "Enter PIN",
  "lockTimeoutLabel": "Lock Timeout",
  "lockTimeoutImmediately": "Immediately",
  "lockTimeout1Min": "1 min",
  "lockTimeout5Min": "5 min",
  "lockTimeout15Min": "15 min",
  "showInRecentApps": "Show in Recent Apps"
}
```

### 14.13 Diet Screens (50 keys)

```json
{
  "searchDietsPlaceholder": "Search diets...",
  "dietCategoryFilterAll": "All",
  "dietCategoryFoodRestriction": "Food Restriction",
  "dietCategoryTimeBased": "Time-Based",
  "dietCategoryMacronutrient": "Macronutrient",
  "dietCategoryElimination": "Elimination",
  "myDietPlaceholder": "My Diet",
  "startFromLabel": "Start From",
  "startFromBlank": "Blank",
  "selectDateLabel": "Select date",
  "ongoingPlaceholder": "Ongoing",
  "enableEatingWindowLabel": "Enable Eating Window",
  "windowStartLabel": "Window Start",
  "windowEndLabel": "Window End",
  "excludeMeatLabel": "Exclude Meat",
  "excludePoultryLabel": "Exclude Poultry",
  "excludeFishLabel": "Exclude Fish",
  "excludeEggsLabel": "Exclude Eggs",
  "excludeDairyLabel": "Exclude Dairy",
  "excludeGrainsLabel": "Exclude Grains",
  "excludeLegumesLabel": "Exclude Legumes",
  "excludeNutsLabel": "Exclude Nuts",
  "excludeSugarLabel": "Exclude Sugar",
  "excludeGlutenLabel": "Exclude Gluten",
  "excludeProcessedLabel": "Exclude Processed",
  "excludeAlcoholLabel": "Exclude Alcohol",
  "enableCarbLimitLabel": "Enable Carb Limit",
  "maxCarbsLabel": "Max Carbs",
  "enableCalorieLimitLabel": "Enable Calorie Limit",
  "maxCaloriesLabel": "Max Calories",
  "gramsUnit": "grams",
  "kcalUnit": "kcal",
  "overallScoreLabel": "Overall Score",
  "dailyScoreLabel": "Today: {score}%",
  "weeklyScoreLabel": "This Week: {score}%",
  "monthlyScoreLabel": "This Month: {score}%",
  "currentStreakLabel": "Current Streak",
  "xDaysLabel": "{count} days",
  "trendChartLabel": "Trend Chart",
  "ruleBreakdownLabel": "Rule Breakdown",
  "recentViolationsLabel": "Recent Violations",
  "currentlyFastingLabel": "Currently Fasting",
  "eatingWindowLabel": "Eating Window",
  "windowOpensInLabel": "Window opens in {time}",
  "endFastButtonLabel": "End Fast",
  "weeklyLogLabel": "Weekly Log",
  "dietAlertTitle": "Diet Alert",
  "cancelLoggingButton": "Cancel",
  "logAnywayButton": "Log Anyway",
  "findAlternativesButton": "Find Alternatives"
}
```

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
| 1.1 | 2026-01-30 | Added localization keys for: Fluids (menstruation, BBT), Diet types, Notifications system |
| 1.2 | 2026-02-01 | Added complete notification type messages (21 types), error messages (51 factories), quiet hours settings, smart water reminders, fasting window messages, streak/compliance messages, sync/backup messages (100% Audit) |
| 1.3 | 2026-02-01 | Added 287 UI field localization keys from 38_UI_FIELD_SPECIFICATIONS.md (Section 14) |
