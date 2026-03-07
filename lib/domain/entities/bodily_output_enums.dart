// lib/domain/entities/bodily_output_enums.dart
// Enums for the BodilyOutputLog domain per FLUIDS_RESTRUCTURING_SPEC.md Section 1.2–1.3

/// The type of bodily output event being logged.
enum BodyOutputType {
  urine(0),
  bowel(1),
  gas(2),
  menstruation(3),
  bbt(4),
  custom(5);

  const BodyOutputType(this.value);
  final int value;

  static BodyOutputType fromValue(int value) => BodyOutputType.values
      .firstWhere((e) => e.value == value, orElse: () => custom);
}

/// Color/clarity of a urine sample.
enum UrineCondition {
  clear(0),
  lightYellow(1),
  yellow(2),
  darkYellow(3),
  amber(4),
  brown(5),
  red(6),
  custom(7);

  const UrineCondition(this.value);
  final int value;

  static UrineCondition fromValue(int value) => UrineCondition.values
      .firstWhere((e) => e.value == value, orElse: () => lightYellow);
}

/// Bristol stool scale classification for a bowel movement.
enum BowelCondition {
  diarrhea(0),
  runny(1),
  loose(2),
  normal(3),
  firm(4),
  hard(5),
  custom(6);

  const BowelCondition(this.value);
  final int value;

  static BowelCondition fromValue(int value) => BowelCondition.values
      .firstWhere((e) => e.value == value, orElse: () => normal);
}

/// Menstrual flow intensity.
/// Note: differs from legacy health_enums.MenstruationFlow.
/// No 'none' value — absence of flow means no log entry.
enum MenstruationFlow {
  spotting(0),
  light(1),
  medium(2),
  heavy(3);

  const MenstruationFlow(this.value);
  final int value;

  static MenstruationFlow fromValue(int value) => MenstruationFlow.values
      .firstWhere((e) => e.value == value, orElse: () => light);
}

/// Size estimate for a urine or bowel output.
enum OutputSize {
  tiny(0),
  small(1),
  medium(2),
  large(3),
  huge(4);

  const OutputSize(this.value);
  final int value;

  static OutputSize fromValue(int value) => OutputSize.values.firstWhere(
    (e) => e.value == value,
    orElse: () => medium,
  );
}

/// Severity of a gas event.
/// Required when outputType == gas (enforced in use case, not entity).
/// Default for migration of legacy gas rows: moderate(1).
enum GasSeverity {
  mild(0),
  moderate(1),
  severe(2);

  const GasSeverity(this.value);
  final int value;

  static GasSeverity fromValue(int value) => GasSeverity.values.firstWhere(
    (e) => e.value == value,
    orElse: () => moderate,
  );
}
