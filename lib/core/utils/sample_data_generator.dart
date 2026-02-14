// lib/core/utils/sample_data_generator.dart
// Generates sample data for all entities in debug mode.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/activities/activity_inputs.dart';
import 'package:shadow_app/domain/usecases/activity_logs/activity_log_inputs.dart';
import 'package:shadow_app/domain/usecases/conditions/condition_inputs.dart';
import 'package:shadow_app/domain/usecases/fluids_entries/fluids_entry_inputs.dart';
import 'package:shadow_app/domain/usecases/food_items/food_item_inputs.dart';
import 'package:shadow_app/domain/usecases/food_logs/food_log_inputs.dart';
import 'package:shadow_app/domain/usecases/journal_entries/journal_entry_inputs.dart';
import 'package:shadow_app/domain/usecases/photo_areas/photo_area_inputs.dart';
import 'package:shadow_app/domain/usecases/sleep_entries/sleep_entry_inputs.dart';
import 'package:shadow_app/domain/usecases/supplements/supplement_inputs.dart';
import 'package:shadow_app/presentation/providers/activities/activity_list_provider.dart';
import 'package:shadow_app/presentation/providers/activity_logs/activity_log_list_provider.dart';
import 'package:shadow_app/presentation/providers/conditions/condition_list_provider.dart';
import 'package:shadow_app/presentation/providers/fluids_entries/fluids_entry_list_provider.dart';
import 'package:shadow_app/presentation/providers/food_items/food_item_list_provider.dart';
import 'package:shadow_app/presentation/providers/food_logs/food_log_list_provider.dart';
import 'package:shadow_app/presentation/providers/journal_entries/journal_entry_list_provider.dart';
import 'package:shadow_app/presentation/providers/photo_areas/photo_area_list_provider.dart';
import 'package:shadow_app/presentation/providers/sleep_entries/sleep_entry_list_provider.dart';
import 'package:shadow_app/presentation/providers/supplements/supplement_list_provider.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Generates sample data for all entities using existing providers.
class SampleDataGenerator {
  final WidgetRef ref;
  final String profileId;

  SampleDataGenerator({required this.ref, required this.profileId});

  /// Generate all sample data. Returns a summary string.
  Future<String> generateAll() async {
    final counts = <String, int>{};

    await _generateSupplements(counts);
    await _generateConditions(counts);
    await _generateFoodItems(counts);
    await _generateActivities(counts);
    await _generateFluidsEntries(counts);
    await _generateSleepEntries(counts);
    await _generatePhotoAreas(counts);
    await _generateJournalEntries(counts);
    await _generateFoodLogs(counts);
    await _generateConditionLogs(counts);
    await _generateFlareUps(counts);
    await _generateActivityLogs(counts);

    final total = counts.values.fold(0, (a, b) => a + b);
    final parts = counts.entries.map((e) => '${e.value} ${e.key}').join(', ');
    return 'Created $total items: $parts';
  }

  Future<void> _generateSupplements(Map<String, int> counts) async {
    final notifier = ref.read(supplementListProvider(profileId).notifier);

    final supplements = [
      CreateSupplementInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Vitamin D3',
        form: SupplementForm.capsule,
        dosageQuantity: 5000,
        dosageUnit: DosageUnit.iu,
        brand: 'NOW Foods',
        notes: 'Take with fatty meal for absorption',
        ingredients: const [
          SupplementIngredient(
            name: 'Cholecalciferol',
            quantity: 5000,
            unit: DosageUnit.iu,
          ),
        ],
        schedules: const [
          SupplementSchedule(
            anchorEvent: SupplementAnchorEvent.breakfast,
            timingType: SupplementTimingType.withEvent,
            frequencyType: SupplementFrequencyType.daily,
          ),
        ],
      ),
      CreateSupplementInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Magnesium Glycinate',
        form: SupplementForm.capsule,
        dosageQuantity: 400,
        dosageUnit: DosageUnit.mg,
        brand: "Doctor's Best",
        notes: 'Helps with sleep',
        ingredients: const [
          SupplementIngredient(
            name: 'Magnesium',
            quantity: 400,
            unit: DosageUnit.mg,
          ),
        ],
        schedules: const [
          SupplementSchedule(
            anchorEvent: SupplementAnchorEvent.bed,
            timingType: SupplementTimingType.beforeEvent,
            offsetMinutes: 30,
            frequencyType: SupplementFrequencyType.daily,
          ),
        ],
      ),
      CreateSupplementInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Omega-3 Fish Oil',
        form: SupplementForm.liquid,
        dosageQuantity: 1,
        dosageUnit: DosageUnit.tsp,
        brand: 'Nordic Naturals',
        ingredients: const [
          SupplementIngredient(name: 'EPA', quantity: 825, unit: DosageUnit.mg),
          SupplementIngredient(name: 'DHA', quantity: 550, unit: DosageUnit.mg),
        ],
        schedules: const [
          SupplementSchedule(
            anchorEvent: SupplementAnchorEvent.lunch,
            timingType: SupplementTimingType.withEvent,
            frequencyType: SupplementFrequencyType.daily,
          ),
        ],
      ),
      CreateSupplementInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Probiotics',
        form: SupplementForm.capsule,
        dosageQuantity: 50,
        dosageUnit: DosageUnit.mg,
        brand: 'Seed',
        notes: 'Take on empty stomach',
        schedules: const [
          SupplementSchedule(
            anchorEvent: SupplementAnchorEvent.wake,
            timingType: SupplementTimingType.withEvent,
            frequencyType: SupplementFrequencyType.daily,
          ),
        ],
      ),
      CreateSupplementInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Zinc',
        form: SupplementForm.tablet,
        dosageQuantity: 30,
        dosageUnit: DosageUnit.mg,
        brand: 'Thorne',
        schedules: const [
          SupplementSchedule(
            anchorEvent: SupplementAnchorEvent.dinner,
            timingType: SupplementTimingType.withEvent,
            frequencyType: SupplementFrequencyType.daily,
          ),
        ],
      ),
    ];

    for (final input in supplements) {
      await notifier.create(input);
    }
    counts['supplements'] = supplements.length;
  }

  Future<void> _generateConditions(Map<String, int> counts) async {
    final notifier = ref.read(conditionListProvider(profileId).notifier);

    final now = DateTime.now().millisecondsSinceEpoch;
    final thirtyDaysAgo = DateTime.now()
        .subtract(const Duration(days: 30))
        .millisecondsSinceEpoch;
    final sixMonthsAgo = DateTime.now()
        .subtract(const Duration(days: 180))
        .millisecondsSinceEpoch;

    final conditions = [
      CreateConditionInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Eczema',
        category: 'Skin',
        bodyLocations: const ['Left arm', 'Right arm', 'Hands'],
        triggers: const ['Stress', 'Dairy', 'Dry weather'],
        description: 'Chronic atopic dermatitis',
        startTimeframe: sixMonthsAgo,
      ),
      CreateConditionInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Seasonal Allergies',
        category: 'Respiratory',
        bodyLocations: const ['Sinuses', 'Eyes'],
        triggers: const ['Pollen', 'Dust'],
        description: 'Allergic rhinitis, worse in spring',
        startTimeframe: thirtyDaysAgo,
      ),
      CreateConditionInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Lower Back Pain',
        category: 'Musculoskeletal',
        bodyLocations: const ['Lower back', 'Left hip'],
        triggers: const ['Sitting', 'Poor posture', 'Heavy lifting'],
        startTimeframe: now,
      ),
    ];

    for (final input in conditions) {
      await notifier.create(input);
    }
    counts['conditions'] = conditions.length;
  }

  Future<void> _generateFoodItems(Map<String, int> counts) async {
    final notifier = ref.read(foodItemListProvider(profileId).notifier);

    final items = [
      CreateFoodItemInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Oatmeal',
        servingSize: '1 cup',
        calories: 150,
        carbsGrams: 27,
        proteinGrams: 5,
        fatGrams: 3,
        fiberGrams: 4,
      ),
      CreateFoodItemInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Grilled Chicken Breast',
        servingSize: '6 oz',
        calories: 280,
        proteinGrams: 53,
        fatGrams: 6,
        carbsGrams: 0,
      ),
      CreateFoodItemInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Brown Rice',
        servingSize: '1 cup cooked',
        calories: 216,
        carbsGrams: 45,
        proteinGrams: 5,
        fatGrams: 2,
        fiberGrams: 4,
      ),
      CreateFoodItemInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Mixed Greens Salad',
        servingSize: '2 cups',
        calories: 20,
        carbsGrams: 4,
        proteinGrams: 2,
        fatGrams: 0,
        fiberGrams: 2,
      ),
      CreateFoodItemInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Banana',
        servingSize: '1 medium',
        calories: 105,
        carbsGrams: 27,
        proteinGrams: 1,
        fatGrams: 0,
        sugarGrams: 14,
      ),
      CreateFoodItemInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Chicken Rice Bowl',
        servingSize: '1 bowl',
        calories: 496,
        carbsGrams: 45,
        proteinGrams: 58,
        fatGrams: 8,
      ),
    ];

    for (final input in items) {
      await notifier.create(input);
    }
    counts['food items'] = items.length;
  }

  Future<void> _generateActivities(Map<String, int> counts) async {
    final notifier = ref.read(activityListProvider(profileId).notifier);

    final activities = [
      CreateActivityInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Morning Walk',
        description: '30 min walk around the neighborhood',
        location: 'Outdoor',
        durationMinutes: 30,
      ),
      CreateActivityInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Yoga',
        description: 'Vinyasa flow session',
        location: 'Home',
        triggers: 'Stretching,Breathing',
        durationMinutes: 45,
      ),
      CreateActivityInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Strength Training',
        description: 'Upper body focus',
        location: 'Gym',
        triggers: 'Heavy lifting,Strain',
        durationMinutes: 60,
      ),
      CreateActivityInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Swimming',
        location: 'Pool',
        durationMinutes: 45,
      ),
    ];

    for (final input in activities) {
      await notifier.create(input);
    }
    counts['activities'] = activities.length;
  }

  Future<void> _generateFluidsEntries(Map<String, int> counts) async {
    final now = DateTime.now();
    final notifier = ref.read(
      fluidsEntryListProvider(
        profileId,
        now.subtract(const Duration(days: 30)).millisecondsSinceEpoch,
        now.millisecondsSinceEpoch,
      ).notifier,
    );

    final entries = [
      LogFluidsEntryInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        entryDate: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
        waterIntakeMl: 2500,
        bowelCondition: BowelCondition.normal,
        bowelSize: MovementSize.medium,
        urineCondition: UrineCondition.lightYellow,
        urineSize: MovementSize.medium,
        notes: 'Good hydration day',
      ),
      LogFluidsEntryInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        entryDate: now.subtract(const Duration(days: 2)).millisecondsSinceEpoch,
        waterIntakeMl: 1800,
        bowelCondition: BowelCondition.firm,
        bowelSize: MovementSize.small,
        urineCondition: UrineCondition.yellow,
        urineSize: MovementSize.large,
      ),
      LogFluidsEntryInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        entryDate: now.millisecondsSinceEpoch,
        waterIntakeMl: 2000,
        bowelCondition: BowelCondition.normal,
        bowelSize: MovementSize.medium,
        urineCondition: UrineCondition.lightYellow,
        urineSize: MovementSize.medium,
      ),
    ];

    for (final input in entries) {
      await notifier.log(input);
    }
    counts['fluid entries'] = entries.length;
  }

  Future<void> _generateSleepEntries(Map<String, int> counts) async {
    final now = DateTime.now();
    final notifier = ref.read(sleepEntryListProvider(profileId).notifier);

    final entries = [
      LogSleepEntryInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        bedTime: DateTime(
          now.year,
          now.month,
          now.day - 1,
          22,
          30,
        ).millisecondsSinceEpoch,
        wakeTime: DateTime(
          now.year,
          now.month,
          now.day,
          6,
          45,
        ).millisecondsSinceEpoch,
        deepSleepMinutes: 90,
        lightSleepMinutes: 180,
        restlessSleepMinutes: 30,
        dreamType: DreamType.vague,
        wakingFeeling: WakingFeeling.rested,
        notes: 'Slept well, no disturbances',
      ),
      LogSleepEntryInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        bedTime: DateTime(
          now.year,
          now.month,
          now.day - 2,
          23,
          15,
        ).millisecondsSinceEpoch,
        wakeTime: DateTime(
          now.year,
          now.month,
          now.day - 1,
          7,
        ).millisecondsSinceEpoch,
        deepSleepMinutes: 60,
        lightSleepMinutes: 200,
        restlessSleepMinutes: 45,
        dreamType: DreamType.vivid,
      ),
      LogSleepEntryInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        bedTime: DateTime(
          now.year,
          now.month,
          now.day - 3,
          21,
          45,
        ).millisecondsSinceEpoch,
        wakeTime: DateTime(
          now.year,
          now.month,
          now.day - 2,
          5,
          30,
        ).millisecondsSinceEpoch,
        deepSleepMinutes: 100,
        lightSleepMinutes: 160,
        restlessSleepMinutes: 20,
        wakingFeeling: WakingFeeling.rested,
        notes: 'Early to bed, early to rise',
      ),
    ];

    for (final input in entries) {
      await notifier.log(input);
    }
    counts['sleep entries'] = entries.length;
  }

  Future<void> _generatePhotoAreas(Map<String, int> counts) async {
    final notifier = ref.read(photoAreaListProvider(profileId).notifier);

    final areas = [
      CreatePhotoAreaInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Left Arm',
        description: 'Track eczema on left forearm',
        consistencyNotes: 'Same lighting, arm extended',
      ),
      CreatePhotoAreaInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Right Arm',
        description: 'Track eczema on right forearm',
        consistencyNotes: 'Same lighting, arm extended',
      ),
      CreatePhotoAreaInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        name: 'Face',
        description: 'Track skin condition on face',
        consistencyNotes: 'Front-facing, natural light',
      ),
    ];

    for (final input in areas) {
      await notifier.create(input);
    }
    counts['photo areas'] = areas.length;
  }

  Future<void> _generateJournalEntries(Map<String, int> counts) async {
    final now = DateTime.now();
    final notifier = ref.read(journalEntryListProvider(profileId).notifier);

    final entries = [
      CreateJournalEntryInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        timestamp: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
        title: 'Good Energy Day',
        content:
            'Felt great today. Slept well last night, took all supplements on time. '
            'Had a productive morning walk and noticed less stiffness in my back.',
        mood: 8,
        tags: const ['energy', 'exercise', 'good-day'],
      ),
      CreateJournalEntryInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        timestamp: now.subtract(const Duration(days: 2)).millisecondsSinceEpoch,
        title: 'Allergy Flare',
        content:
            'Allergies acting up today. Sneezing and itchy eyes all morning. '
            'Took antihistamine which helped after an hour.',
        mood: 4,
        tags: const ['allergies', 'flare', 'medication'],
      ),
      CreateJournalEntryInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        timestamp: now.millisecondsSinceEpoch,
        title: 'Weekly Check-in',
        content:
            'Overall a good week. Eczema is improving with the new supplement routine. '
            'Sleep has been consistent. Need to drink more water.',
        mood: 7,
        tags: const ['weekly', 'progress', 'review'],
      ),
    ];

    for (final input in entries) {
      await notifier.create(input);
    }
    counts['journal entries'] = entries.length;
  }

  Future<void> _generateFoodLogs(Map<String, int> counts) async {
    final now = DateTime.now();
    final notifier = ref.read(foodLogListProvider(profileId).notifier);

    final logs = [
      LogFoodInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        timestamp: DateTime(
          now.year,
          now.month,
          now.day,
          8,
        ).millisecondsSinceEpoch,
        mealType: MealType.breakfast,
        adHocItems: const ['Oatmeal with banana', 'Green tea'],
        notes: 'Light breakfast',
      ),
      LogFoodInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        timestamp: DateTime(
          now.year,
          now.month,
          now.day,
          12,
          30,
        ).millisecondsSinceEpoch,
        mealType: MealType.lunch,
        adHocItems: const ['Chicken rice bowl', 'Side salad'],
      ),
      LogFoodInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        timestamp: DateTime(
          now.year,
          now.month,
          now.day - 1,
          18,
          30,
        ).millisecondsSinceEpoch,
        mealType: MealType.dinner,
        adHocItems: const ['Grilled salmon', 'Brown rice', 'Steamed broccoli'],
        notes: 'Home cooked',
      ),
    ];

    for (final input in logs) {
      await notifier.log(input);
    }
    counts['food logs'] = logs.length;
  }

  Future<void> _generateConditionLogs(Map<String, int> counts) async {
    // We can't reference exact condition IDs without reading from state,
    // so we skip condition logs that require a conditionId FK.
    // They would need to be wired after conditions are fetched from state.
    counts['condition logs'] = 0;
  }

  Future<void> _generateFlareUps(Map<String, int> counts) async {
    // Same as condition logs - requires conditionId FK.
    counts['flare-ups'] = 0;
  }

  Future<void> _generateActivityLogs(Map<String, int> counts) async {
    final now = DateTime.now();
    final notifier = ref.read(activityLogListProvider(profileId).notifier);

    final logs = [
      LogActivityInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        timestamp: DateTime(
          now.year,
          now.month,
          now.day,
          7,
        ).millisecondsSinceEpoch,
        adHocActivities: const ['Morning walk'],
        duration: 30,
        notes: 'Nice weather today',
      ),
      LogActivityInput(
        profileId: profileId,
        clientId: _uuid.v4(),
        timestamp: DateTime(
          now.year,
          now.month,
          now.day - 1,
          17,
        ).millisecondsSinceEpoch,
        adHocActivities: const ['Yoga session'],
        duration: 45,
      ),
    ];

    for (final input in logs) {
      await notifier.log(input);
    }
    counts['activity logs'] = logs.length;
  }
}
