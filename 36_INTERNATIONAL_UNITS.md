# Shadow International Units Specification

**Version:** 1.0
**Last Updated:** January 31, 2026
**Purpose:** Complete specification for international unit support and localization

---

## 1. Overview

Shadow supports users worldwide with automatic locale-based unit defaults and manual override options. All measurements can be displayed in either metric or imperial units based on user preference.

---

## 2. Unit Categories

### 2.1 Supported Unit Types

| Category | Metric Units | Imperial Units | Used For |
|----------|--------------|----------------|----------|
| **Temperature** | Celsius (°C) | Fahrenheit (°F) | Basal body temperature |
| **Volume (Large)** | Liters (L) | Gallons (gal) | Daily water goal |
| **Volume (Small)** | Milliliters (mL) | Fluid ounces (fl oz) | Water intake, liquid supplements |
| **Weight (Large)** | Kilograms (kg) | Pounds (lb) | Body weight |
| **Weight (Small)** | Grams (g) | Ounces (oz) | Food portions |
| **Weight (Tiny)** | Milligrams (mg) | Milligrams (mg) | Supplement dosages |
| **Length** | Centimeters (cm) | Inches (in) | Body measurements |
| **Energy** | Kilojoules (kJ) | Calories (kcal) | Food energy (future) |

### 2.2 Unit Enumeration

```dart
// lib/core/types/units.dart

enum TemperatureUnit {
  celsius('°C'),
  fahrenheit('°F');

  final String symbol;
  const TemperatureUnit(this.symbol);
}

enum VolumeUnit {
  milliliters('mL'),
  liters('L'),
  fluidOunces('fl oz'),
  cups('cup'),
  gallons('gal');

  final String symbol;
  const VolumeUnit(this.symbol);
}

enum WeightUnit {
  milligrams('mg'),
  grams('g'),
  kilograms('kg'),
  ounces('oz'),
  pounds('lb');

  final String symbol;
  const WeightUnit(this.symbol);
}

enum LengthUnit {
  centimeters('cm'),
  meters('m'),
  inches('in'),
  feet('ft');

  final String symbol;
  const LengthUnit(this.symbol);
}

enum MeasurementSystem {
  metric,
  imperial,
}
```

---

## 3. Locale-Based Defaults

### 3.1 Country to Unit Mapping

```dart
// lib/core/config/locale_units.dart

class LocaleUnitDefaults {
  /// Countries that use Imperial system by default
  static const Set<String> imperialCountries = {
    'US',  // United States
    'LR',  // Liberia
    'MM',  // Myanmar
  };

  /// Countries that use Fahrenheit (may differ from imperial)
  static const Set<String> fahrenheitCountries = {
    'US',  // United States
    'BS',  // Bahamas
    'BZ',  // Belize
    'KY',  // Cayman Islands
    'PW',  // Palau
    'PR',  // Puerto Rico
    'VI',  // US Virgin Islands
  };

  /// Get default measurement system for locale
  static MeasurementSystem getDefaultSystem(String countryCode) {
    return imperialCountries.contains(countryCode.toUpperCase())
        ? MeasurementSystem.imperial
        : MeasurementSystem.metric;
  }

  /// Get default temperature unit for locale
  static TemperatureUnit getDefaultTemperatureUnit(String countryCode) {
    return fahrenheitCountries.contains(countryCode.toUpperCase())
        ? TemperatureUnit.fahrenheit
        : TemperatureUnit.celsius;
  }

  /// Get complete unit preferences for locale
  static UnitPreferences getDefaultPreferences(String countryCode) {
    final system = getDefaultSystem(countryCode);
    final isImperial = system == MeasurementSystem.imperial;

    return UnitPreferences(
      measurementSystem: system,
      temperature: getDefaultTemperatureUnit(countryCode),
      volumeLarge: isImperial ? VolumeUnit.gallons : VolumeUnit.liters,
      volumeSmall: isImperial ? VolumeUnit.fluidOunces : VolumeUnit.milliliters,
      weightLarge: isImperial ? WeightUnit.pounds : WeightUnit.kilograms,
      weightSmall: isImperial ? WeightUnit.ounces : WeightUnit.grams,
      length: isImperial ? LengthUnit.inches : LengthUnit.centimeters,
    );
  }
}
```

### 3.2 Automatic Detection

```dart
class UnitPreferenceService {
  final SharedPreferences _prefs;

  /// Get current unit preferences (user overrides or locale defaults)
  Future<UnitPreferences> getPreferences() async {
    // Check for user-saved preferences
    final saved = _prefs.getString('unit_preferences');
    if (saved != null) {
      return UnitPreferences.fromJson(json.decode(saved));
    }

    // Fall back to locale-based defaults
    final locale = Platform.localeName; // e.g., "en_US"
    final countryCode = _extractCountryCode(locale); // "US"

    return LocaleUnitDefaults.getDefaultPreferences(countryCode);
  }

  /// Save user's unit preferences
  Future<void> savePreferences(UnitPreferences prefs) async {
    await _prefs.setString('unit_preferences', json.encode(prefs.toJson()));
  }

  String _extractCountryCode(String locale) {
    // "en_US" -> "US", "de_DE" -> "DE"
    final parts = locale.split('_');
    return parts.length > 1 ? parts[1] : parts[0].toUpperCase();
  }
}
```

---

## 4. Unit Conversion

### 4.1 Conversion Functions

```dart
// lib/core/utils/unit_converter.dart

class UnitConverter {
  // ============ TEMPERATURE ============

  /// Convert Celsius to Fahrenheit
  static double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  /// Convert Fahrenheit to Celsius
  static double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  /// Convert temperature between units
  static double convertTemperature(
    double value,
    TemperatureUnit from,
    TemperatureUnit to,
  ) {
    if (from == to) return value;

    if (from == TemperatureUnit.celsius) {
      return celsiusToFahrenheit(value);
    } else {
      return fahrenheitToCelsius(value);
    }
  }

  // ============ VOLUME ============

  /// Base unit: milliliters
  static const Map<VolumeUnit, double> _volumeToMl = {
    VolumeUnit.milliliters: 1.0,
    VolumeUnit.liters: 1000.0,
    VolumeUnit.fluidOunces: 29.5735,
    VolumeUnit.cups: 236.588,
    VolumeUnit.gallons: 3785.41,
  };

  static double convertVolume(
    double value,
    VolumeUnit from,
    VolumeUnit to,
  ) {
    if (from == to) return value;

    // Convert to milliliters, then to target unit
    final ml = value * _volumeToMl[from]!;
    return ml / _volumeToMl[to]!;
  }

  // ============ WEIGHT ============

  /// Base unit: grams
  static const Map<WeightUnit, double> _weightToGrams = {
    WeightUnit.milligrams: 0.001,
    WeightUnit.grams: 1.0,
    WeightUnit.kilograms: 1000.0,
    WeightUnit.ounces: 28.3495,
    WeightUnit.pounds: 453.592,
  };

  static double convertWeight(
    double value,
    WeightUnit from,
    WeightUnit to,
  ) {
    if (from == to) return value;

    // Convert to grams, then to target unit
    final grams = value * _weightToGrams[from]!;
    return grams / _weightToGrams[to]!;
  }

  // ============ LENGTH ============

  /// Base unit: centimeters
  static const Map<LengthUnit, double> _lengthToCm = {
    LengthUnit.centimeters: 1.0,
    LengthUnit.meters: 100.0,
    LengthUnit.inches: 2.54,
    LengthUnit.feet: 30.48,
  };

  static double convertLength(
    double value,
    LengthUnit from,
    LengthUnit to,
  ) {
    if (from == to) return value;

    final cm = value * _lengthToCm[from]!;
    return cm / _lengthToCm[to]!;
  }
}
```

### 4.2 Formatting

```dart
// lib/core/utils/unit_formatter.dart

class UnitFormatter {
  final UnitPreferences _preferences;

  UnitFormatter(this._preferences);

  /// Format temperature with unit symbol
  String formatTemperature(double celsius, {int decimals = 1}) {
    final value = _preferences.temperature == TemperatureUnit.celsius
        ? celsius
        : UnitConverter.celsiusToFahrenheit(celsius);

    return '${value.toStringAsFixed(decimals)}${_preferences.temperature.symbol}';
  }

  /// Format volume (water intake) with unit symbol
  String formatVolume(double ml, {int decimals = 0}) {
    final unit = _preferences.volumeSmall;
    final value = UnitConverter.convertVolume(
      ml,
      VolumeUnit.milliliters,
      unit,
    );

    return '${value.toStringAsFixed(decimals)} ${unit.symbol}';
  }

  /// Format weight with appropriate unit
  String formatWeight(double grams, {int decimals = 1}) {
    // Choose appropriate unit based on size
    if (grams < 1) {
      // Use milligrams
      final mg = grams * 1000;
      return '${mg.toStringAsFixed(0)} mg';
    } else if (grams < 1000) {
      // Use grams or ounces
      final unit = _preferences.weightSmall;
      final value = UnitConverter.convertWeight(
        grams,
        WeightUnit.grams,
        unit,
      );
      return '${value.toStringAsFixed(decimals)} ${unit.symbol}';
    } else {
      // Use kg or lbs
      final unit = _preferences.weightLarge;
      final value = UnitConverter.convertWeight(
        grams,
        WeightUnit.grams,
        unit,
      );
      return '${value.toStringAsFixed(decimals)} ${unit.symbol}';
    }
  }
}
```

---

## 5. Database Storage

### 5.1 Canonical Units (Always Stored)

All values are stored in **metric base units** regardless of display preference:

| Measurement | Storage Unit | Database Column Type |
|-------------|--------------|---------------------|
| Temperature | Celsius | REAL |
| Volume | Milliliters | INTEGER |
| Weight (large) | Grams | REAL |
| Weight (small) | Milligrams | INTEGER |
| Length | Centimeters | REAL |

### 5.2 Example: Water Intake

```dart
// User enters "16 fl oz" in imperial mode
// Stored as: 473 mL

class WaterIntakeEntry {
  // Always stored in mL
  final int waterIntakeMl;

  // Display value converts based on user preference
  String getDisplayValue(UnitFormatter formatter) {
    return formatter.formatVolume(waterIntakeMl.toDouble());
  }
}
```

### 5.3 Example: Basal Body Temperature

```dart
// User enters "98.6°F" in Fahrenheit mode
// Stored as: 37.0°C

class FluidsEntry {
  // Always stored in Celsius
  final double? basalBodyTemperature;

  // Display converts based on user preference
  String getBBTDisplay(UnitFormatter formatter) {
    if (basalBodyTemperature == null) return '--';
    return formatter.formatTemperature(basalBodyTemperature!);
  }
}
```

---

## 6. User Interface

### 6.1 Unit Settings Screen

```
┌─────────────────────────────────────────────────────────────────────┐
│                    UNITS & MEASUREMENTS                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Measurement System                                                 │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  ○ Metric (International)                                    │  │
│  │  ● Imperial (US)                                             │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  Temperature                                                        │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  ○ Celsius (°C)                                              │  │
│  │  ● Fahrenheit (°F)                                           │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  Volume (Water Intake)                                              │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  ○ Milliliters (mL)                                          │  │
│  │  ● Fluid Ounces (fl oz)                                      │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  Weight                                                             │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  ○ Kilograms / Grams (kg, g)                                 │  │
│  │  ● Pounds / Ounces (lb, oz)                                  │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  Changes apply immediately to all screens.                         │
│                                                                     │
│                       [Reset to Defaults]                          │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 6.2 Input Field Behavior

When entering values, the input field shows the user's preferred unit:

```dart
class TemperatureInputField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(unitPreferencesProvider);
    final isF = prefs.temperature == TemperatureUnit.fahrenheit;

    return AccessibleTextField(
      label: 'Temperature',
      suffix: Text(prefs.temperature.symbol),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      hint: isF ? 'e.g., 98.6' : 'e.g., 37.0',
      validator: (value) {
        final temp = double.tryParse(value ?? '');
        if (temp == null) return 'Enter a valid number';

        // Validate reasonable range
        if (isF) {
          if (temp < 95.0 || temp > 104.0) {
            return 'Temperature should be between 95°F and 104°F';
          }
        } else {
          if (temp < 35.0 || temp > 40.0) {
            return 'Temperature should be between 35°C and 40°C';
          }
        }
        return null;
      },
      onSaved: (value) {
        // Convert to Celsius for storage
        final entered = double.parse(value!);
        final celsius = isF
            ? UnitConverter.fahrenheitToCelsius(entered)
            : entered;
        // Store celsius value
      },
    );
  }
}
```

### 6.3 Water Intake Quick-Add Buttons

Buttons adapt to user's preferred units:

**Imperial (US) Mode:**
```
[8 fl oz]  [12 fl oz]  [16 fl oz]  [24 fl oz]  [Custom]
```

**Metric Mode:**
```
[250 mL]  [350 mL]  [500 mL]  [750 mL]  [Custom]
```

```dart
List<WaterQuickAdd> getQuickAddOptions(UnitPreferences prefs) {
  if (prefs.volumeSmall == VolumeUnit.fluidOunces) {
    return [
      WaterQuickAdd(label: '8 fl oz', ml: 237),
      WaterQuickAdd(label: '12 fl oz', ml: 355),
      WaterQuickAdd(label: '16 fl oz', ml: 473),
      WaterQuickAdd(label: '24 fl oz', ml: 710),
    ];
  } else {
    return [
      WaterQuickAdd(label: '250 mL', ml: 250),
      WaterQuickAdd(label: '350 mL', ml: 350),
      WaterQuickAdd(label: '500 mL', ml: 500),
      WaterQuickAdd(label: '750 mL', ml: 750),
    ];
  }
}
```

---

## 7. BBT Chart with Units

### 7.1 Temperature Range Adaptation

```dart
class BBTChartWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(unitPreferencesProvider);
    final isF = prefs.temperature == TemperatureUnit.fahrenheit;

    // Chart Y-axis range adapts to unit
    final minTemp = isF ? 96.0 : 35.5;
    final maxTemp = isF ? 100.0 : 37.8;
    final gridInterval = isF ? 0.5 : 0.2;

    return LineChart(
      LineChartData(
        minY: minTemp,
        maxY: maxTemp,
        gridData: FlGridData(
          horizontalInterval: gridInterval,
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text('${value.toStringAsFixed(1)}${prefs.temperature.symbol}');
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _convertDataPoints(entries, isF),
            // ... styling
          ),
        ],
      ),
    );
  }

  List<FlSpot> _convertDataPoints(List<FluidsEntry> entries, bool toFahrenheit) {
    return entries.map((e) {
      final temp = toFahrenheit
          ? UnitConverter.celsiusToFahrenheit(e.basalBodyTemperature!)
          : e.basalBodyTemperature!;
      return FlSpot(e.timestamp.millisecondsSinceEpoch.toDouble(), temp);
    }).toList();
  }
}
```

---

## 8. Report Generation

### 8.1 Unit Display in Reports

PDF reports use the user's preferred units:

```dart
class ReportGenerator {
  final UnitFormatter _formatter;

  String generateBBTSection(List<FluidsEntry> entries) {
    final buffer = StringBuffer();
    buffer.writeln('Basal Body Temperature Log');
    buffer.writeln('-' * 40);

    for (final entry in entries) {
      if (entry.basalBodyTemperature != null) {
        buffer.writeln(
          '${_formatDate(entry.timestamp)}: '
          '${_formatter.formatTemperature(entry.basalBodyTemperature!)}'
        );
      }
    }

    return buffer.toString();
  }

  String generateWaterIntakeSection(List<FluidsEntry> entries) {
    final buffer = StringBuffer();
    buffer.writeln('Water Intake Log');
    buffer.writeln('-' * 40);

    for (final entry in entries) {
      if (entry.waterIntakeMl != null && entry.waterIntakeMl! > 0) {
        buffer.writeln(
          '${_formatDate(entry.timestamp)}: '
          '${_formatter.formatVolume(entry.waterIntakeMl!.toDouble())}'
        );
      }
    }

    return buffer.toString();
  }
}
```

---

## 9. Data Model

### 9.1 Unit Preferences Entity

```dart
@freezed
class UnitPreferences with _$UnitPreferences {
  const factory UnitPreferences({
    required MeasurementSystem measurementSystem,
    required TemperatureUnit temperature,
    required VolumeUnit volumeLarge,
    required VolumeUnit volumeSmall,
    required WeightUnit weightLarge,
    required WeightUnit weightSmall,
    required LengthUnit length,
  }) = _UnitPreferences;

  factory UnitPreferences.fromJson(Map<String, dynamic> json) =>
      _$UnitPreferencesFromJson(json);

  /// Metric defaults
  factory UnitPreferences.metric() => const UnitPreferences(
    measurementSystem: MeasurementSystem.metric,
    temperature: TemperatureUnit.celsius,
    volumeLarge: VolumeUnit.liters,
    volumeSmall: VolumeUnit.milliliters,
    weightLarge: WeightUnit.kilograms,
    weightSmall: WeightUnit.grams,
    length: LengthUnit.centimeters,
  );

  /// Imperial defaults
  factory UnitPreferences.imperial() => const UnitPreferences(
    measurementSystem: MeasurementSystem.imperial,
    temperature: TemperatureUnit.fahrenheit,
    volumeLarge: VolumeUnit.gallons,
    volumeSmall: VolumeUnit.fluidOunces,
    weightLarge: WeightUnit.pounds,
    weightSmall: WeightUnit.ounces,
    length: LengthUnit.inches,
  );
}
```

### 9.2 Database Storage

Unit preferences stored in `user_preferences` table:

```sql
CREATE TABLE user_preferences (
  id TEXT PRIMARY KEY,
  user_account_id TEXT NOT NULL,
  preference_key TEXT NOT NULL,
  preference_value TEXT NOT NULL,
  sync_created_at INTEGER NOT NULL,
  sync_updated_at INTEGER,
  -- ... sync metadata
  UNIQUE(user_account_id, preference_key)
);

-- Example row:
-- ('pref_1', 'user_123', 'unit_preferences', '{"measurementSystem":"imperial","temperature":"fahrenheit",...}')
```

---

## 10. Localization Integration

### 10.1 Unit Names by Language

```arb
// lib/l10n/app_en.arb
{
  "unitCelsius": "Celsius",
  "unitFahrenheit": "Fahrenheit",
  "unitMilliliters": "Milliliters",
  "unitFluidOunces": "Fluid Ounces",
  "unitLiters": "Liters",
  "unitGallons": "Gallons",
  "unitGrams": "Grams",
  "unitKilograms": "Kilograms",
  "unitOunces": "Ounces",
  "unitPounds": "Pounds",
  "measurementSystemMetric": "Metric (International)",
  "measurementSystemImperial": "Imperial (US)",
  "unitsSettingsTitle": "Units & Measurements",
  "unitsTemperature": "Temperature",
  "unitsVolume": "Volume",
  "unitsWeight": "Weight"
}

// lib/l10n/app_de.arb
{
  "unitCelsius": "Celsius",
  "unitFahrenheit": "Fahrenheit",
  "unitMilliliters": "Milliliter",
  "unitFluidOunces": "Flüssigunzen",
  "unitLiters": "Liter",
  "unitGallons": "Gallonen",
  "unitGrams": "Gramm",
  "unitKilograms": "Kilogramm",
  "unitOunces": "Unzen",
  "unitPounds": "Pfund",
  "measurementSystemMetric": "Metrisch (International)",
  "measurementSystemImperial": "Imperial (US)"
}
```

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-31 | Initial release - complete international units specification |
