// lib/domain/enums/settings_enums.dart
// Unit and security preference enums per 58_SETTINGS_SCREENS.md

/// Display unit for body weight measurements.
enum WeightUnit {
  kg(0, 'kg', 'Kilograms'),
  lbs(1, 'lbs', 'Pounds');

  const WeightUnit(this.value, this.symbol, this.label);

  final int value;
  final String symbol;
  final String label;

  static WeightUnit fromValue(int v) =>
      values.firstWhere((e) => e.value == v, orElse: () => kg);
}

/// Display unit for food/ingredient weight.
enum FoodWeightUnit {
  grams(0, 'g', 'Grams'),
  ounces(1, 'oz', 'Ounces');

  const FoodWeightUnit(this.value, this.symbol, this.label);

  final int value;
  final String symbol;
  final String label;

  static FoodWeightUnit fromValue(int v) =>
      values.firstWhere((e) => e.value == v, orElse: () => grams);
}

/// Display unit for fluid volume.
enum FluidUnit {
  ml(0, 'ml', 'Millilitres'),
  flOz(1, 'fl oz', 'Fluid ounces');

  const FluidUnit(this.value, this.symbol, this.label);

  final int value;
  final String symbol;
  final String label;

  static FluidUnit fromValue(int v) =>
      values.firstWhere((e) => e.value == v, orElse: () => ml);
}

/// Display unit for body temperature.
enum TemperatureUnit {
  celsius(0, '°C', 'Celsius'),
  fahrenheit(1, '°F', 'Fahrenheit');

  const TemperatureUnit(this.value, this.symbol, this.label);

  final int value;
  final String symbol;
  final String label;

  static TemperatureUnit fromValue(int v) =>
      values.firstWhere((e) => e.value == v, orElse: () => celsius);
}

/// Display unit for energy / calorie values.
enum EnergyUnit {
  kcal(0, 'kcal', 'Kilocalories'),
  kJ(1, 'kJ', 'Kilojoules');

  const EnergyUnit(this.value, this.symbol, this.label);

  final int value;
  final String symbol;
  final String label;

  static EnergyUnit fromValue(int v) =>
      values.firstWhere((e) => e.value == v, orElse: () => kcal);
}

/// How macro nutrients are displayed.
enum MacroDisplay {
  grams(0, 'g', 'Grams'),
  percentage(1, '%', 'Percentage of daily target');

  const MacroDisplay(this.value, this.symbol, this.label);

  final int value;
  final String symbol;
  final String label;

  static MacroDisplay fromValue(int v) =>
      values.firstWhere((e) => e.value == v, orElse: () => grams);
}

/// How long after going to background the app auto-locks.
///
/// [value] is stored in the database and represents minutes.
/// [immediately] (value = 0) locks as soon as the app goes to background.
enum AutoLockDuration {
  immediately(0, 'Immediately'),
  oneMinute(1, '1 minute'),
  fiveMinutes(5, '5 minutes'),
  fifteenMinutes(15, '15 minutes'),
  oneHour(60, '1 hour');

  const AutoLockDuration(this.value, this.label);

  final int value;
  final String label;

  static AutoLockDuration fromValue(int v) =>
      values.firstWhere((e) => e.value == v, orElse: () => fiveMinutes);
}
