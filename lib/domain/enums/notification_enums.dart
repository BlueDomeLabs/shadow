// lib/domain/enums/notification_enums.dart
// Enums for the notification system per 57_NOTIFICATION_SYSTEM.md

/// The 8 notification categories that can be independently configured.
///
/// Each category maps to a specific type of health data entry.
enum NotificationCategory {
  supplements(0),
  foodMeals(1),
  fluids(2),
  photos(3),
  journalEntries(4),
  activities(5),
  conditionCheckIns(6),
  bbtVitals(7);

  final int value;
  const NotificationCategory(this.value);

  static NotificationCategory fromValue(int value) => NotificationCategory
      .values
      .firstWhere((e) => e.value == value, orElse: () => supplements);

  /// Human-readable display name for this category.
  String get displayName => switch (this) {
    supplements => 'Supplements',
    foodMeals => 'Food & Meals',
    fluids => 'Fluids',
    photos => 'Photos',
    journalEntries => 'Journal Entries',
    activities => 'Activities',
    conditionCheckIns => 'Condition Check-ins',
    bbtVitals => 'BBT & Vitals',
  };
}

/// The scheduling modes available for each notification category.
///
/// Mode 1: Anchor Events — fires when a named daily event occurs.
/// Mode 2A: Interval — fires every N hours within a time window.
/// Mode 2B: Specific Times — fires at individually listed clock times.
enum NotificationSchedulingMode {
  anchorEvents(0),
  interval(1),
  specificTimes(2);

  final int value;
  const NotificationSchedulingMode(this.value);

  static NotificationSchedulingMode fromValue(int value) =>
      NotificationSchedulingMode.values.firstWhere(
        (e) => e.value == value,
        orElse: () => anchorEvents,
      );
}

/// The 5 named anchor events used by Mode 1 scheduling.
///
/// Each anchor event has a user-configurable clock time.
/// Categories in Mode 1 fire at the times configured for their
/// assigned anchor events.
enum AnchorEventName {
  wake(0),
  breakfast(1),
  lunch(2),
  dinner(3),
  bedtime(4);

  final int value;
  const AnchorEventName(this.value);

  static AnchorEventName fromValue(int value) => AnchorEventName.values
      .firstWhere((e) => e.value == value, orElse: () => wake);

  /// Human-readable display name.
  String get displayName => switch (this) {
    wake => 'Wake',
    breakfast => 'Breakfast',
    lunch => 'Lunch',
    dinner => 'Dinner',
    bedtime => 'Bedtime',
  };

  /// Default time of day as "HH:mm" (24-hour format).
  ///
  /// Per 57_NOTIFICATION_SYSTEM.md anchor event defaults.
  String get defaultTime => switch (this) {
    wake => '07:00',
    breakfast => '08:00',
    lunch => '12:00',
    dinner => '18:00',
    bedtime => '22:00',
  };
}
