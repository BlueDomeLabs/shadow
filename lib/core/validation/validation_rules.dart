// lib/core/validation/validation_rules.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 6

/// ALL validation MUST use these exact rules.
class ValidationRules {
  // ===== String length limits =====
  static const int nameMinLength = 2; // Min for all name fields
  static const int nameMaxLength = 100; // Default max for names
  static const int supplementNameMaxLength =
      200; // Supplements can have longer names
  static const int conditionNameMaxLength =
      200; // Conditions can have longer names
  static const int activityNameMaxLength =
      200; // Activities can have longer names
  static const int foodNameMaxLength = 200; // Foods can have longer names
  static const int dietNameMaxLength = 50; // Diet names are shorter
  static const int photoAreaNameMaxLength =
      200; // Photo area names can be descriptive

  // Intake log limits
  static const int skipReasonMaxLength = 200;
  static const int intakeNotesMaxLength = 500;

  // Notes and content limits
  static const int notesMaxLength = 2000; // Standard notes for most entities
  static const int waterIntakeNotesMaxLength = 200;
  static const int journalContentMinLength = 10;
  static const int journalContentMaxLength =
      50000; // Journals can be much longer
  static const int descriptionMaxLength =
      1000; // Descriptions benefit from detail
  static const int locationMaxLength = 200;
  static const int consistencyNotesMaxLength = 1000;
  static const int titleMaxLength = 200;
  static const int tagMaxLength = 50;
  static const int triggerMaxLength = 100;
  static const int activityTriggersMaxLength = 500;
  static const int servingSizeMaxLength = 50;
  static const int otherFluidNotesMaxLength = 5000;

  // ===== Activity duration =====
  static const int activityDurationMinMinutes = 1;
  static const int activityDurationMaxMinutes = 1440; // 24 hours

  // ===== Mood scale =====
  static const int moodMin = 1;
  static const int moodMax = 10;

  // Custom fluid naming
  static const int customFluidNameMinLength = 2;
  static const int customFluidNameMaxLength = 100;
  static const int otherFluidAmountMaxLength = 50;

  // ===== Compliance streak rules =====
  static const int streakResetOnMissedDays = 1;
  static const double streakMinDailyCompliancePercent = 80;
  static const int streakGracePeriodHours = 4;

  // ===== Supplement validation =====
  static const double dosageMinAmount = 0.001;
  static const double dosageMaxAmount = 999999;
  static const int dosageMaxDecimalPlaces = 6;
  static const int quantityPerDoseMin = 1;
  static const int quantityPerDoseMax = 100;
  static const int maxIngredientsPerSupplement = 20;
  static const int maxSchedulesPerSupplement = 10;

  // ===== BBT (Basal Body Temperature) =====
  static const double bbtMinFahrenheit = 95;
  static const double bbtMaxFahrenheit = 105;
  static const double bbtMinCelsius = 35;
  static const double bbtMaxCelsius = 40.6;

  // ===== Water intake =====
  static const int waterIntakeMinMl = 0;
  static const int waterIntakeMaxMl = 10000;
  static const int dailyWaterGoalMinMl = 500;
  static const int dailyWaterGoalMaxMl = 10000;

  // ===== Severity scales =====
  static const int severityMin = 1;
  static const int severityMax = 10;
  static const int menstruationFlowMin = 0;
  static const int menstruationFlowMax = 4;

  // ===== Time constraints =====
  static const int maxScheduleTimesPerDay = 10;
  static const int maxNotificationSchedules = 50;
  static const int minReminderIntervalMinutes = 5;
  static const int maxReminderIntervalMinutes = 1440;

  // ===== Collection limits =====
  static const int maxPhotosPerEntry = 10;
  static const int maxPhotosPerConditionLog = 5;
  static const int maxConditionsPerProfile = 100;
  static const int maxSupplementsPerProfile = 200;
  static const int maxDietsPerProfile = 20;
  static const int maxRulesPerDiet = 50;
  static const int maxFoodItemsPerProfile = 1000;
  static const int maxActivitiesPerProfile = 100;

  // ===== Photo size limits =====
  static const int photoInputMaxBytes = 10 * 1024 * 1024;
  static const int photoCompressedStandardBytes = 500 * 1024;
  static const int photoCompressedHighDetailBytes = 1024 * 1024;
  static const int photoAbsoluteMaxBytes = 2 * 1024 * 1024;
  static const int photoMaxDimension = 2048;
  static const int thumbnailSize = 200;
  static const int profilePhotoMaxBytes = 5 * 1024 * 1024;

  // ===== Diet system =====
  static const int macroLimitMinGrams = 0;
  static const int macroLimitMaxGrams = 10000;
  static const double calorieMinPerDay = 0;
  static const double calorieMaxPerDay = 20000;
  static const int eatingWindowMinMinutes = 60;
  static const int eatingWindowMaxMinutes = 1380;

  // ===== Intelligence system =====
  static const int minDaysForPatternDetection = 14;
  static const int minDaysForTriggerCorrelation = 30;
  static const int minDaysForPredictiveAlerts = 60;
  static const double minConfidenceForInsight = 0.65;
  static const double minRelativeRiskForCorrelation = 1.5;

  // ===== Sync limits =====
  static const int maxSyncBatchSize = 500;
  static const int maxSyncRetries = 3;
  static const int syncRetryDelaySeconds = 30;

  // ===== UI display constants =====
  static const int earliestSelectableYear = 2000;
  static const int journalSnippetMaxLength = 100;
  static const int defaultPickerMaxTimes = 5;
  static const int badgeMaxDisplayCount = 99;
  static const int photoGalleryColumns = 3;

  // ===== Validation methods =====

  /// Validate entity name with custom field name and max length.
  static String? entityName(String? value, String fieldName, int maxLength) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (value.length < nameMinLength) {
      return '$fieldName must be at least $nameMinLength characters';
    }
    if (value.length > maxLength) {
      return '$fieldName must be $maxLength characters or less';
    }
    return null;
  }

  /// Validate supplement name.
  static String? supplementName(String? value) =>
      entityName(value, 'Supplement name', supplementNameMaxLength);

  /// Validate brand name (optional but max length).
  static String? brand(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length > nameMaxLength) {
      return 'Brand must be $nameMaxLength characters or less';
    }
    return null;
  }

  /// Validate ingredients count.
  static String? ingredientsCount(int count) {
    if (count > maxIngredientsPerSupplement) {
      return 'Maximum $maxIngredientsPerSupplement ingredients allowed';
    }
    return null;
  }

  /// Validate schedules count.
  static String? schedulesCount(int count) {
    if (count > maxSchedulesPerSupplement) {
      return 'Maximum $maxSchedulesPerSupplement schedules allowed';
    }
    return null;
  }

  /// Validate date range (start must be before end).
  static String? dateRange(
    int startDate,
    int endDate,
    String startField,
    String endField,
  ) {
    if (endDate < startDate) {
      return 'End date must be after start date';
    }
    return null;
  }

  /// Validate notes length.
  static String? notes(String? value) {
    if (value != null && value.length > notesMaxLength) {
      return 'Notes must be $notesMaxLength characters or less';
    }
    return null;
  }

  /// Validate dosage quantity.
  static String? dosageQuantity(int value) {
    if (value < quantityPerDoseMin || value > quantityPerDoseMax) {
      return 'Dosage quantity must be between $quantityPerDoseMin and $quantityPerDoseMax';
    }
    return null;
  }
}
