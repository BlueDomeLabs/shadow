// lib/domain/enums/health_enums.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 3.3

enum BowelCondition {
  diarrhea(0),
  runny(1),
  loose(2),
  normal(3),
  firm(4),
  hard(5),
  custom(6);

  final int value;
  const BowelCondition(this.value);

  static BowelCondition fromValue(int value) => BowelCondition.values
      .firstWhere((e) => e.value == value, orElse: () => normal);
}

enum UrineCondition {
  clear(0),
  lightYellow(1),
  yellow(2),
  darkYellow(3),
  amber(4),
  brown(5),
  red(6),
  custom(7);

  final int value;
  const UrineCondition(this.value);

  static UrineCondition fromValue(int value) => UrineCondition.values
      .firstWhere((e) => e.value == value, orElse: () => lightYellow);
}

enum MovementSize {
  tiny(0),
  small(1),
  medium(2),
  large(3),
  huge(4);

  final int value;
  const MovementSize(this.value);

  static MovementSize fromValue(int value) => MovementSize.values.firstWhere(
    (e) => e.value == value,
    orElse: () => medium,
  );
}

enum MenstruationFlow {
  none(0),
  spotty(1),
  light(2),
  medium(3),
  heavy(4);

  final int value;
  const MenstruationFlow(this.value);

  static MenstruationFlow fromValue(int value) => MenstruationFlow.values
      .firstWhere((e) => e.value == value, orElse: () => none);
}

enum SleepQuality {
  veryPoor(1),
  poor(2),
  fair(3),
  good(4),
  excellent(5);

  final int value;
  const SleepQuality(this.value);

  static SleepQuality fromValue(int value) => SleepQuality.values.firstWhere(
    (e) => e.value == value,
    orElse: () => fair,
  );
}

enum ActivityIntensity {
  light(0),
  moderate(1),
  vigorous(2);

  final int value;
  const ActivityIntensity(this.value);

  static ActivityIntensity fromValue(int value) => ActivityIntensity.values
      .firstWhere((e) => e.value == value, orElse: () => moderate);
}

enum ConditionSeverity {
  none(0),
  mild(1),
  moderate(2),
  severe(3),
  extreme(4);

  final int value;
  const ConditionSeverity(this.value);

  static ConditionSeverity fromValue(int value) => ConditionSeverity.values
      .firstWhere((e) => e.value == value, orElse: () => none);

  /// Convert 5-level enum to 1-10 storage scale
  /// Mapping: none=1, mild=2-3, moderate=4-5, severe=6-8, extreme=9-10
  int toStorageScale() => switch (this) {
    ConditionSeverity.none => 1,
    ConditionSeverity.mild => 3,
    ConditionSeverity.moderate => 5,
    ConditionSeverity.severe => 7,
    ConditionSeverity.extreme => 10,
  };

  /// Create from 1-10 storage scale
  static ConditionSeverity fromStorageScale(int value) {
    if (value <= 1) return ConditionSeverity.none;
    if (value <= 3) return ConditionSeverity.mild;
    if (value <= 5) return ConditionSeverity.moderate;
    if (value <= 8) return ConditionSeverity.severe;
    return ConditionSeverity.extreme;
  }
}

enum MoodLevel {
  veryLow(1),
  low(2),
  neutral(3),
  good(4),
  veryGood(5);

  final int value;
  const MoodLevel(this.value);

  static MoodLevel fromValue(int value) => MoodLevel.values.firstWhere(
    (e) => e.value == value,
    orElse: () => neutral,
  );
}

enum DietRuleType {
  // Food-based rules
  excludeCategory(0), // Exclude entire food category
  excludeIngredient(1), // Exclude specific ingredient
  requireCategory(2), // Must include category (e.g., vegetables)
  limitCategory(3), // Max servings per day/week

  // Macronutrient rules
  maxCarbs(4), // Maximum carbs (grams)
  maxFat(5), // Maximum fat (grams)
  maxProtein(6), // Maximum protein (grams)
  minCarbs(7), // Minimum carbs (grams)
  minFat(8), // Minimum fat (grams)
  minProtein(9), // Minimum protein (grams)
  carbPercentage(10), // Carbs as % of calories
  fatPercentage(11), // Fat as % of calories
  proteinPercentage(12), // Protein as % of calories
  maxCalories(13), // Maximum daily calories

  // Time-based rules
  eatingWindowStart(14), // Earliest eating time
  eatingWindowEnd(15), // Latest eating time
  fastingHours(16), // Required consecutive fasting hours
  fastingDays(17), // Specific fasting days (for 5:2)
  maxMealsPerDay(18), // Maximum number of meals

  // Combination rules
  mealSpacing(19), // Minimum hours between meals
  noEatingBefore(20), // No food before time
  noEatingAfter(21); // No food after time

  final int value;
  const DietRuleType(this.value);

  static DietRuleType fromValue(int value) => DietRuleType.values.firstWhere(
    (e) => e.value == value,
    orElse: () => excludeCategory,
  );
}

enum PatternType {
  temporal(0),
  cyclical(1),
  sequential(2),
  cluster(3),
  dosage(4);

  final int value;
  const PatternType(this.value);

  static PatternType fromValue(int value) => PatternType.values.firstWhere(
    (e) => e.value == value,
    orElse: () => temporal,
  );
}

/// Diet preset types - predefined diet configurations
enum DietPresetType {
  vegan(0),
  vegetarian(1),
  pescatarian(2),
  paleo(3),
  keto(4),
  ketoStrict(5),
  lowCarb(6),
  mediterranean(7),
  whole30(8),
  aip(9), // Autoimmune Protocol
  lowFodmap(10),
  glutenFree(11),
  dairyFree(12),
  if168(13), // Intermittent Fasting 16:8
  if186(14), // Intermittent Fasting 18:6
  if204(15), // Intermittent Fasting 20:4
  omad(16), // One Meal A Day
  fiveTwoDiet(17), // 5:2 Fasting
  zone(18),
  custom(19);

  final int value;
  const DietPresetType(this.value);

  static DietPresetType fromValue(int value) => DietPresetType.values
      .firstWhere((e) => e.value == value, orElse: () => custom);
}

enum InsightCategory {
  daily(0),
  summary(1), // Weekly/monthly summaries
  pattern(2),
  trigger(3),
  progress(4),
  compliance(5),
  anomaly(6),
  milestone(7),
  recommendation(8); // Actionable recommendations

  final int value;
  const InsightCategory(this.value);

  static InsightCategory fromValue(int value) => InsightCategory.values
      .firstWhere((e) => e.value == value, orElse: () => daily);
}

enum AlertPriority {
  low(0),
  medium(1),
  high(2),
  critical(3);

  final int value;
  const AlertPriority(this.value);

  static AlertPriority fromValue(int value) => AlertPriority.values.firstWhere(
    (e) => e.value == value,
    orElse: () => low,
  );
}

enum WearablePlatform {
  healthkit(0),
  googlefit(1),
  fitbit(2),
  garmin(3),
  oura(4),
  whoop(5);

  final int value;
  const WearablePlatform(this.value);

  static WearablePlatform fromValue(int value) => WearablePlatform.values
      .firstWhere((e) => e.value == value, orElse: () => healthkit);
}

/// CANONICAL: This is the authoritative definition of notification types.
/// See 37_NOTIFICATIONS.md for implementation details.
///
/// **Meal Type Mapping (API → UI):**
/// The 4 API meal types map to 6 UI meal times as follows:
/// - mealBreakfast(2) → breakfast
/// - mealLunch(3) → lunch
/// - mealDinner(4) → dinner
/// - mealSnacks(5) → morningSnack, afternoonSnack, eveningSnack (collapsed)
enum NotificationType {
  supplementIndividual(0),
  supplementGrouped(1),
  mealBreakfast(2),
  mealLunch(3),
  mealDinner(4),
  mealSnacks(5),
  waterInterval(6),
  waterFixed(7),
  waterSmart(8),
  bbtMorning(9),
  menstruationTracking(10),
  sleepBedtime(11),
  sleepWakeup(12),
  conditionCheckIn(13),
  photoReminder(14),
  journalPrompt(15),
  syncReminder(16),
  fastingWindowOpen(17),
  fastingWindowClose(18),
  fastingWindowClosed(19), // Alert when fasting period begins
  dietStreak(20),
  dietWeeklySummary(21),
  fluidsGeneral(22), // General fluids tracking reminders
  fluidsBowel(23), // Bowel movement tracking reminders
  inactivity(24); // Re-engagement after extended absence

  final int value;
  const NotificationType(this.value);

  static NotificationType fromValue(int value) => NotificationType.values
      .firstWhere((e) => e.value == value, orElse: () => supplementIndividual);

  /// Whether this notification type allows snooze action
  bool get allowsSnooze => switch (this) {
    bbtMorning => false, // Medical accuracy
    dietStreak => false, // Informational
    dietWeeklySummary => false, // Informational
    inactivity => false, // Re-engagement, not time-sensitive
    _ => true,
  };

  /// Default snooze duration in minutes for this type
  int get defaultSnoozeMinutes => switch (this) {
    supplementIndividual => 15,
    supplementGrouped => 15,
    mealBreakfast => 30,
    mealLunch => 30,
    mealDinner => 30,
    mealSnacks => 30,
    waterInterval => 30,
    waterFixed => 30,
    waterSmart => 30,
    menstruationTracking => 60,
    sleepBedtime => 15,
    sleepWakeup => 5,
    conditionCheckIn => 60,
    photoReminder => 60,
    journalPrompt => 60,
    syncReminder => 120,
    fastingWindowOpen => 15,
    fastingWindowClose => 15,
    fastingWindowClosed => 15,
    fluidsGeneral => 30,
    fluidsBowel => 60,
    _ => 0, // No snooze types
  };
}

// === Supplement Enums (22_API_CONTRACTS.md Section 3.3) ===

enum SupplementForm {
  capsule(0),
  powder(1),
  liquid(2),
  tablet(3),
  gummy(4),
  spray(5),
  other(6);

  final int value;
  const SupplementForm(this.value);

  static SupplementForm fromValue(int value) => SupplementForm.values
      .firstWhere((e) => e.value == value, orElse: () => capsule);
}

enum DosageUnit {
  g(0, 'g'),
  mg(1, 'mg'),
  mcg(2, 'mcg'),
  iu(3, 'IU'),
  hdu(4, 'HDU'),
  ml(5, 'mL'),
  drops(6, 'drops'),
  tsp(7, 'tsp'),
  custom(8, '');

  final int value;
  final String abbreviation;
  const DosageUnit(this.value, this.abbreviation);

  static DosageUnit fromValue(int value) =>
      DosageUnit.values.firstWhere((e) => e.value == value, orElse: () => mg);
}

enum SupplementTimingType {
  withEvent(0),
  beforeEvent(1),
  afterEvent(2),
  specificTime(3);

  final int value;
  const SupplementTimingType(this.value);

  static SupplementTimingType fromValue(int value) => SupplementTimingType
      .values
      .firstWhere((e) => e.value == value, orElse: () => withEvent);
}

enum SupplementFrequencyType {
  daily(0),
  everyXDays(1),
  specificWeekdays(2);

  final int value;
  const SupplementFrequencyType(this.value);

  static SupplementFrequencyType fromValue(int value) => SupplementFrequencyType
      .values
      .firstWhere((e) => e.value == value, orElse: () => daily);
}

enum SupplementAnchorEvent {
  wake(0),
  breakfast(1),
  lunch(2),
  dinner(3),
  bed(4);

  final int value;
  const SupplementAnchorEvent(this.value);

  static SupplementAnchorEvent fromValue(int value) => SupplementAnchorEvent
      .values
      .firstWhere((e) => e.value == value, orElse: () => wake);
}

// === IntakeLog Enums (22_API_CONTRACTS.md Section 10.10) ===

enum IntakeLogStatus {
  pending(0),
  taken(1),
  skipped(2),
  missed(3),
  snoozed(4);

  final int value;
  const IntakeLogStatus(this.value);

  static IntakeLogStatus fromValue(int value) => IntakeLogStatus.values
      .firstWhere((e) => e.value == value, orElse: () => pending);
}

// === Profile Enums (22_API_CONTRACTS.md Section 10.7) ===

enum BiologicalSex {
  male(0),
  female(1),
  other(2);

  final int value;
  const BiologicalSex(this.value);

  static BiologicalSex fromValue(int value) => BiologicalSex.values.firstWhere(
    (e) => e.value == value,
    orElse: () => other,
  );
}

/// Simple diet indicator on Profile.
/// NOTE: This is DISTINCT from the full Diet system (see Diet entity).
/// - ProfileDietType: Simple label shown in profile, for quick reference
/// - Diet entity: Full diet with rules, compliance tracking, eating windows
/// A profile can have BOTH: dietType for display AND an active Diet for tracking
enum ProfileDietType {
  none(0),
  vegan(1),
  vegetarian(2),
  paleo(3),
  keto(4),
  glutenFree(5),
  other(6);

  final int value;
  const ProfileDietType(this.value);

  static ProfileDietType fromValue(int value) => ProfileDietType.values
      .firstWhere((e) => e.value == value, orElse: () => none);
}

// === Condition Enums (22_API_CONTRACTS.md Section 10.8) ===

enum ConditionStatus {
  active(0),
  resolved(1);

  final int value;
  const ConditionStatus(this.value);

  static ConditionStatus fromValue(int value) => ConditionStatus.values
      .firstWhere((e) => e.value == value, orElse: () => active);
}

// === Meal Type (38_UI_FIELD_SPECIFICATIONS.md Section 5.1) ===

enum MealType {
  breakfast(0),
  lunch(1),
  dinner(2),
  snack(3);

  final int value;
  const MealType(this.value);

  static MealType fromValue(int value) =>
      MealType.values.firstWhere((e) => e.value == value, orElse: () => snack);
}

// === Food Enums (22_API_CONTRACTS.md Section 10.11) ===

enum FoodItemType {
  simple(0),
  complex(1);

  final int value;
  const FoodItemType(this.value);

  static FoodItemType fromValue(int value) => FoodItemType.values.firstWhere(
    (e) => e.value == value,
    orElse: () => simple,
  );
}

// === Sleep Enums (22_API_CONTRACTS.md Section 10.15) ===

enum DreamType {
  noDreams(0),
  vague(1),
  vivid(2),
  nightmares(3);

  final int value;
  const DreamType(this.value);

  static DreamType fromValue(int value) => DreamType.values.firstWhere(
    (e) => e.value == value,
    orElse: () => noDreams,
  );
}

enum WakingFeeling {
  unrested(0),
  neutral(1),
  rested(2);

  final int value;
  const WakingFeeling(this.value);

  static WakingFeeling fromValue(int value) => WakingFeeling.values.firstWhere(
    (e) => e.value == value,
    orElse: () => neutral,
  );
}
