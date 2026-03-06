# Shadow Sample Data Generator Specification

**Version:** 1.0
**Last Updated:** January 31, 2026
**Purpose:** Complete specification for generating realistic test data

---

## 1. Overview

The Sample Data Generator creates realistic health tracking data for:
- Development testing
- UI/UX review with populated screens
- Performance testing with large datasets
- Demo and presentation purposes
- QA testing scenarios

---

## 2. Generator Architecture

### 2.1 Structure

```
lib/
└── core/
    └── utils/
        └── generators/
            ├── sample_data_generator.dart       # Main orchestrator
            ├── profile_generator.dart           # Profiles with realistic demographics
            ├── supplement_generator.dart        # Supplements with schedules
            ├── condition_generator.dart         # Conditions with logs
            ├── food_generator.dart              # Food items and meals
            ├── fluids_generator.dart            # Fluids entries
            ├── sleep_generator.dart             # Sleep patterns
            ├── activity_generator.dart          # Activities
            ├── journal_generator.dart           # Journal entries
            └── data/
                ├── supplement_catalog.dart      # Real supplement names
                ├── food_catalog.dart            # Real food items
                ├── condition_catalog.dart       # Real condition names
                └── name_catalog.dart            # Realistic names
```

### 2.2 Main Generator

```dart
// lib/core/utils/generators/sample_data_generator.dart

class SampleDataGenerator {
  final Random _random = Random();
  final ProfileGenerator _profileGenerator;
  final SupplementGenerator _supplementGenerator;
  final ConditionGenerator _conditionGenerator;
  final FoodGenerator _foodGenerator;
  final FluidsGenerator _fluidsGenerator;
  final SleepGenerator _sleepGenerator;
  final ActivityGenerator _activityGenerator;
  final JournalGenerator _journalGenerator;

  /// Generate a complete dataset for testing
  Future<SampleDataset> generate({
    required SampleDataConfig config,
    void Function(double progress)? onProgress,
  }) async {
    final dataset = SampleDataset();

    // 1. Generate profiles
    onProgress?.call(0.1);
    dataset.profiles = await _profileGenerator.generate(
      count: config.profileCount,
    );

    // 2. For each profile, generate health data
    for (int i = 0; i < dataset.profiles.length; i++) {
      final profile = dataset.profiles[i];
      final progress = 0.1 + (0.8 * (i / dataset.profiles.length));
      onProgress?.call(progress);

      // Generate supplements
      dataset.supplements.addAll(await _supplementGenerator.generate(
        profileId: profile.id,
        count: config.supplementsPerProfile,
        dateRange: config.dateRange,
      ));

      // Generate conditions
      dataset.conditions.addAll(await _conditionGenerator.generate(
        profileId: profile.id,
        count: config.conditionsPerProfile,
        dateRange: config.dateRange,
      ));

      // Generate food logs
      dataset.foodLogs.addAll(await _foodGenerator.generate(
        profileId: profile.id,
        daysOfData: config.dateRange.duration.inDays,
      ));

      // Generate fluids entries
      dataset.fluidsEntries.addAll(await _fluidsGenerator.generate(
        profileId: profile.id,
        profile: profile,
        daysOfData: config.dateRange.duration.inDays,
      ));

      // Generate sleep entries
      dataset.sleepEntries.addAll(await _sleepGenerator.generate(
        profileId: profile.id,
        daysOfData: config.dateRange.duration.inDays,
      ));

      // Generate activities
      dataset.activityLogs.addAll(await _activityGenerator.generate(
        profileId: profile.id,
        daysOfData: config.dateRange.duration.inDays,
      ));

      // Generate journal entries
      dataset.journalEntries.addAll(await _journalGenerator.generate(
        profileId: profile.id,
        count: config.journalEntriesPerProfile,
        dateRange: config.dateRange,
      ));
    }

    onProgress?.call(1.0);
    return dataset;
  }

  /// Quick preset: Single profile with 30 days of data
  Future<SampleDataset> generateQuickDemo() {
    return generate(config: SampleDataConfig.quickDemo());
  }

  /// Full preset: Multiple profiles with 90 days of comprehensive data
  Future<SampleDataset> generateFullDemo() {
    return generate(config: SampleDataConfig.fullDemo());
  }

  /// Performance test: Large dataset for stress testing
  Future<SampleDataset> generatePerformanceTest() {
    return generate(config: SampleDataConfig.performanceTest());
  }
}

@freezed
class SampleDataConfig with _$SampleDataConfig {
  factory SampleDataConfig({
    required int profileCount,
    required int supplementsPerProfile,
    required int conditionsPerProfile,
    required int journalEntriesPerProfile,
    required DateTimeRange dateRange,
    required bool includePhotos,
  }) = _SampleDataConfig;

  factory SampleDataConfig.quickDemo() => SampleDataConfig(
    profileCount: 1,
    supplementsPerProfile: 5,
    conditionsPerProfile: 2,
    journalEntriesPerProfile: 10,
    dateRange: DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 30)),
      end: DateTime.now(),
    ),
    includePhotos: false,
  );

  factory SampleDataConfig.fullDemo() => SampleDataConfig(
    profileCount: 3,
    supplementsPerProfile: 10,
    conditionsPerProfile: 3,
    journalEntriesPerProfile: 30,
    dateRange: DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 90)),
      end: DateTime.now(),
    ),
    includePhotos: true,
  );

  factory SampleDataConfig.performanceTest() => SampleDataConfig(
    profileCount: 10,
    supplementsPerProfile: 20,
    conditionsPerProfile: 5,
    journalEntriesPerProfile: 100,
    dateRange: DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 365)),
      end: DateTime.now(),
    ),
    includePhotos: false,
  );
}
```

---

## 3. Profile Generator

### 3.1 Realistic Name Database

```dart
// lib/core/utils/generators/data/name_catalog.dart

class NameCatalog {
  static const List<String> firstNames = [
    // Common US names
    'James', 'Mary', 'Robert', 'Patricia', 'John', 'Jennifer',
    'Michael', 'Linda', 'David', 'Elizabeth', 'William', 'Barbara',
    'Richard', 'Susan', 'Joseph', 'Jessica', 'Thomas', 'Sarah',
    'Christopher', 'Karen', 'Charles', 'Lisa', 'Daniel', 'Nancy',
    'Matthew', 'Betty', 'Anthony', 'Margaret', 'Mark', 'Sandra',
    // Additional diverse names
    'Maria', 'Wei', 'Aisha', 'Raj', 'Fatima', 'Carlos', 'Yuki',
    'Olga', 'Ahmed', 'Priya', 'Luis', 'Kim', 'Dmitri', 'Aaliyah',
  ];

  static const List<String> lastNames = [
    'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia',
    'Miller', 'Davis', 'Rodriguez', 'Martinez', 'Hernandez',
    'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 'Thomas', 'Taylor',
    'Moore', 'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson',
    'White', 'Harris', 'Sanchez', 'Clark', 'Ramirez', 'Lewis',
    'Robinson', 'Walker', 'Young', 'Allen', 'King', 'Wright',
    'Chen', 'Patel', 'Kim', 'Nguyen', 'Singh', 'Ivanov', 'Yamamoto',
  ];
}
```

### 3.2 Profile Generator

```dart
// lib/core/utils/generators/profile_generator.dart

class ProfileGenerator {
  final Random _random = Random();

  List<Profile> generate({required int count}) {
    return List.generate(count, (_) => _generateProfile());
  }

  Profile _generateProfile() {
    final firstName = _randomFrom(NameCatalog.firstNames);
    final lastName = _randomFrom(NameCatalog.lastNames);
    final biologicalSex = _randomBiologicalSex();

    return Profile(
      id: const Uuid().v4(),
      clientId: const Uuid().v4(),
      name: '$firstName $lastName',
      birthDate: _randomBirthDate(),
      biologicalSex: biologicalSex,
      ethnicity: _randomEthnicity(),
      dietType: _randomDietType(),
      notes: _maybeGenerateNotes(),
      syncMetadata: SyncMetadata.create(),
    );
  }

  DateTime _randomBirthDate() {
    // Ages 18-80
    final age = 18 + _random.nextInt(62);
    final now = DateTime.now();
    return DateTime(now.year - age, _random.nextInt(12) + 1, _random.nextInt(28) + 1);
  }

  BiologicalSex _randomBiologicalSex() {
    final weights = [0.48, 0.48, 0.03, 0.01]; // M, F, Other, Prefer not to say
    return BiologicalSex.values[_weightedRandom(weights)];
  }

  DietType _randomDietType() {
    // Most people have no specific diet
    if (_random.nextDouble() < 0.7) return DietType.none;
    return DietType.values[_random.nextInt(DietType.values.length)];
  }

  String? _maybeGenerateNotes() {
    if (_random.nextDouble() < 0.3) {
      return _randomFrom([
        'Primary care patient',
        'Referred by nutritionist',
        'Managing chronic conditions',
        'Focus on gut health',
        'Tracking for wellness',
      ]);
    }
    return null;
  }

  T _randomFrom<T>(List<T> list) => list[_random.nextInt(list.length)];

  int _weightedRandom(List<double> weights) {
    final total = weights.reduce((a, b) => a + b);
    var r = _random.nextDouble() * total;
    for (int i = 0; i < weights.length; i++) {
      r -= weights[i];
      if (r <= 0) return i;
    }
    return weights.length - 1;
  }
}
```

---

## 4. Supplement Generator

### 4.1 Supplement Catalog

```dart
// lib/core/utils/generators/data/supplement_catalog.dart

class SupplementCatalog {
  static const List<SupplementTemplate> supplements = [
    // Vitamins
    SupplementTemplate(
      name: 'Vitamin D3',
      brand: 'NOW Foods',
      form: SupplementForm.softgel,
      dosageAmount: 2000,
      dosageUnit: DosageUnit.iu,
      ingredients: ['Vitamin D3 (Cholecalciferol)'],
      typicalTiming: AnchorEvent.withBreakfast,
    ),
    SupplementTemplate(
      name: 'Vitamin C',
      brand: 'Nature Made',
      form: SupplementForm.tablet,
      dosageAmount: 500,
      dosageUnit: DosageUnit.mg,
      ingredients: ['Ascorbic Acid'],
      typicalTiming: AnchorEvent.withBreakfast,
    ),
    SupplementTemplate(
      name: 'Vitamin B12',
      brand: 'Jarrow Formulas',
      form: SupplementForm.lozenge,
      dosageAmount: 1000,
      dosageUnit: DosageUnit.mcg,
      ingredients: ['Methylcobalamin'],
      typicalTiming: AnchorEvent.morning,
    ),
    // Minerals
    SupplementTemplate(
      name: 'Magnesium Glycinate',
      brand: 'Pure Encapsulations',
      form: SupplementForm.capsule,
      dosageAmount: 400,
      dosageUnit: DosageUnit.mg,
      ingredients: ['Magnesium (as Magnesium Glycinate)'],
      typicalTiming: AnchorEvent.beforeBed,
    ),
    SupplementTemplate(
      name: 'Zinc',
      brand: 'Thorne',
      form: SupplementForm.capsule,
      dosageAmount: 30,
      dosageUnit: DosageUnit.mg,
      ingredients: ['Zinc Picolinate'],
      typicalTiming: AnchorEvent.withDinner,
    ),
    // Omega-3
    SupplementTemplate(
      name: 'Fish Oil (Omega-3)',
      brand: 'Nordic Naturals',
      form: SupplementForm.softgel,
      dosageAmount: 1000,
      dosageUnit: DosageUnit.mg,
      ingredients: ['EPA', 'DHA'],
      typicalTiming: AnchorEvent.withBreakfast,
    ),
    // Probiotics
    SupplementTemplate(
      name: 'Probiotic',
      brand: 'Garden of Life',
      form: SupplementForm.capsule,
      dosageAmount: 50,
      dosageUnit: DosageUnit.billionCfu,
      ingredients: ['Lactobacillus', 'Bifidobacterium'],
      typicalTiming: AnchorEvent.beforeBreakfast,
    ),
    // Herbs
    SupplementTemplate(
      name: 'Turmeric Curcumin',
      brand: 'Gaia Herbs',
      form: SupplementForm.capsule,
      dosageAmount: 500,
      dosageUnit: DosageUnit.mg,
      ingredients: ['Curcumin', 'Black Pepper Extract'],
      typicalTiming: AnchorEvent.withLunch,
    ),
    SupplementTemplate(
      name: 'Ashwagandha',
      brand: 'Organic India',
      form: SupplementForm.capsule,
      dosageAmount: 300,
      dosageUnit: DosageUnit.mg,
      ingredients: ['Ashwagandha Root Extract'],
      typicalTiming: AnchorEvent.morning,
    ),
    // Specialty
    SupplementTemplate(
      name: 'CoQ10',
      brand: 'Life Extension',
      form: SupplementForm.softgel,
      dosageAmount: 100,
      dosageUnit: DosageUnit.mg,
      ingredients: ['Ubiquinol'],
      typicalTiming: AnchorEvent.withBreakfast,
    ),
    SupplementTemplate(
      name: 'Collagen Peptides',
      brand: 'Vital Proteins',
      form: SupplementForm.powder,
      dosageAmount: 10,
      dosageUnit: DosageUnit.g,
      ingredients: ['Bovine Collagen Peptides'],
      typicalTiming: AnchorEvent.morning,
    ),
  ];
}

@freezed
class SupplementTemplate with _$SupplementTemplate {
  const factory SupplementTemplate({
    required String name,
    required String brand,
    required SupplementForm form,
    required double dosageAmount,
    required DosageUnit dosageUnit,
    required List<String> ingredients,
    required AnchorEvent typicalTiming,
  }) = _SupplementTemplate;
}
```

### 4.2 Intake Log Generator

```dart
class SupplementGenerator {
  /// Generate supplements with realistic intake history
  Future<SupplementData> generate({
    required String profileId,
    required int count,
    required DateTimeRange dateRange,
  }) async {
    final supplements = <Supplement>[];
    final intakeLogs = <IntakeLog>[];

    // Select random supplements from catalog
    final selectedTemplates = _selectRandom(
      SupplementCatalog.supplements,
      count,
    );

    for (final template in selectedTemplates) {
      final supplement = _createSupplement(profileId, template);
      supplements.add(supplement);

      // Generate intake logs for each day
      final logs = _generateIntakeLogs(
        supplement: supplement,
        dateRange: dateRange,
        complianceRate: 0.7 + _random.nextDouble() * 0.25, // 70-95%
      );
      intakeLogs.addAll(logs);
    }

    return SupplementData(supplements: supplements, intakeLogs: intakeLogs);
  }

  List<IntakeLog> _generateIntakeLogs({
    required Supplement supplement,
    required DateTimeRange dateRange,
    required double complianceRate,
  }) {
    final logs = <IntakeLog>[];
    var currentDate = dateRange.start;

    while (currentDate.isBefore(dateRange.end)) {
      // Check if this day matches schedule
      if (_isScheduledDay(supplement, currentDate)) {
        final scheduledTime = _getScheduledTime(supplement, currentDate);

        // Determine if taken based on compliance rate
        final status = _random.nextDouble() < complianceRate
            ? IntakeStatus.taken
            : (_random.nextDouble() < 0.5
                ? IntakeStatus.missed
                : IntakeStatus.skipped);

        DateTime? actualTime;
        if (status == IntakeStatus.taken) {
          // Actual time varies from scheduled by -30 to +60 minutes
          final variance = Duration(minutes: -30 + _random.nextInt(90));
          actualTime = scheduledTime.add(variance);
        }

        logs.add(IntakeLog(
          id: const Uuid().v4(),
          profileId: supplement.profileId,
          supplementId: supplement.id,
          scheduledTime: scheduledTime,
          actualTime: actualTime,
          status: status,
          syncMetadata: SyncMetadata.create(),
        ));
      }

      currentDate = currentDate.add(Duration(days: 1));
    }

    return logs;
  }
}
```

---

## 5. Condition Generator

### 5.1 Condition Catalog

```dart
// lib/core/utils/generators/data/condition_catalog.dart

class ConditionCatalog {
  static const List<ConditionTemplate> conditions = [
    // Skin conditions
    ConditionTemplate(
      name: 'Eczema',
      category: 'Skin',
      bodyLocations: ['Arms', 'Hands', 'Face'],
      typicalTriggers: ['Stress', 'Dry air', 'Certain soaps', 'Food allergies'],
      severityRange: (3, 8),
      flareUpFrequency: 0.15, // 15% of days
    ),
    ConditionTemplate(
      name: 'Psoriasis',
      category: 'Skin',
      bodyLocations: ['Elbows', 'Knees', 'Scalp'],
      typicalTriggers: ['Stress', 'Cold weather', 'Infections'],
      severityRange: (2, 7),
      flareUpFrequency: 0.1,
    ),
    ConditionTemplate(
      name: 'Acne',
      category: 'Skin',
      bodyLocations: ['Face', 'Back', 'Chest'],
      typicalTriggers: ['Hormones', 'Diet', 'Stress', 'Certain products'],
      severityRange: (2, 6),
      flareUpFrequency: 0.2,
    ),
    // Digestive
    ConditionTemplate(
      name: 'IBS',
      category: 'Digestive',
      bodyLocations: ['Stomach', 'Internal'],
      typicalTriggers: ['Stress', 'Dairy', 'Gluten', 'Fatty foods'],
      severityRange: (3, 8),
      flareUpFrequency: 0.2,
    ),
    ConditionTemplate(
      name: 'Acid Reflux',
      category: 'Digestive',
      bodyLocations: ['Chest', 'Stomach'],
      typicalTriggers: ['Spicy food', 'Coffee', 'Alcohol', 'Late eating'],
      severityRange: (2, 6),
      flareUpFrequency: 0.25,
    ),
    // Allergies
    ConditionTemplate(
      name: 'Seasonal Allergies',
      category: 'Respiratory',
      bodyLocations: ['Head', 'Face'],
      typicalTriggers: ['Pollen', 'Dust', 'Pet dander'],
      severityRange: (2, 7),
      flareUpFrequency: 0.3,
    ),
    ConditionTemplate(
      name: 'Food Allergies',
      category: 'Autoimmune',
      bodyLocations: ['Internal', 'Skin'],
      typicalTriggers: ['Nuts', 'Shellfish', 'Dairy', 'Eggs'],
      severityRange: (4, 9),
      flareUpFrequency: 0.05,
    ),
    // Pain
    ConditionTemplate(
      name: 'Chronic Back Pain',
      category: 'Pain',
      bodyLocations: ['Back'],
      typicalTriggers: ['Poor posture', 'Heavy lifting', 'Sitting too long'],
      severityRange: (3, 8),
      flareUpFrequency: 0.15,
    ),
    ConditionTemplate(
      name: 'Migraine',
      category: 'Pain',
      bodyLocations: ['Head'],
      typicalTriggers: ['Stress', 'Lack of sleep', 'Dehydration', 'Bright lights'],
      severityRange: (5, 10),
      flareUpFrequency: 0.1,
    ),
    // Mental Health
    ConditionTemplate(
      name: 'Anxiety',
      category: 'Mental Health',
      bodyLocations: ['Internal'],
      typicalTriggers: ['Stress', 'Caffeine', 'Sleep deprivation', 'Work pressure'],
      severityRange: (2, 8),
      flareUpFrequency: 0.25,
    ),
  ];
}
```

### 5.2 Condition Log Generator

```dart
class ConditionGenerator {
  /// Generate realistic condition data with severity patterns
  List<ConditionLog> _generateConditionLogs({
    required Condition condition,
    required DateTimeRange dateRange,
  }) {
    final logs = <ConditionLog>[];
    var currentDate = dateRange.start;

    // Generate a baseline severity that fluctuates
    var baseSeverity = condition.template.severityRange.$1 +
        _random.nextInt(condition.template.severityRange.$2 - condition.template.severityRange.$1);

    while (currentDate.isBefore(dateRange.end)) {
      // Slowly drift baseline severity
      baseSeverity += (_random.nextDouble() - 0.5) * 0.3;
      baseSeverity = baseSeverity.clamp(
        condition.template.severityRange.$1.toDouble(),
        condition.template.severityRange.$2.toDouble(),
      );

      // Determine if flare-up
      final isFlareUp = _random.nextDouble() < condition.template.flareUpFrequency;

      // Calculate severity
      var severity = baseSeverity.round();
      if (isFlareUp) {
        severity = min(10, severity + 2 + _random.nextInt(2));
      }

      // Randomly select triggers
      List<String> triggers = [];
      if (isFlareUp || severity > 5) {
        final numTriggers = 1 + _random.nextInt(3);
        triggers = _selectRandom(condition.template.typicalTriggers, numTriggers);
      }

      logs.add(ConditionLog(
        id: const Uuid().v4(),
        profileId: condition.profileId,
        conditionId: condition.id,
        timestamp: currentDate.add(Duration(hours: 20)), // Evening logging
        severity: severity,
        isFlare: isFlareUp,
        triggers: triggers,
        notes: _maybeGenerateNote(severity, isFlareUp),
        syncMetadata: SyncMetadata.create(),
      ));

      currentDate = currentDate.add(Duration(days: 1));
    }

    return logs;
  }
}
```

---

## 6. Fluids Generator

```dart
class FluidsGenerator {
  /// Generate fluids entries with realistic patterns
  Future<List<FluidsEntry>> generate({
    required String profileId,
    required Profile profile,
    required int daysOfData,
  }) async {
    final entries = <FluidsEntry>[];
    final startDate = DateTime.now().subtract(Duration(days: daysOfData));

    // Determine if this profile tracks menstruation
    final tracksMenstruation = profile.biologicalSex == BiologicalSex.female &&
        _random.nextDouble() < 0.6; // 60% of females track

    // Generate cycle start if tracking
    DateTime? cycleStart;
    if (tracksMenstruation) {
      cycleStart = startDate.add(Duration(days: _random.nextInt(28)));
    }

    for (int day = 0; day < daysOfData; day++) {
      final date = startDate.add(Duration(days: day));

      // Multiple water entries per day
      final waterEntries = _generateWaterEntries(profileId, date);
      entries.addAll(waterEntries);

      // 1-3 bowel movements per day
      final bowelCount = 1 + _random.nextInt(3);
      for (int i = 0; i < bowelCount; i++) {
        entries.add(_generateBowelEntry(profileId, date, i));
      }

      // 4-8 urination entries (we don't log all, sample)
      if (_random.nextDouble() < 0.3) { // 30% of days log urine
        entries.add(_generateUrineEntry(profileId, date));
      }

      // BBT entry if tracking
      if (tracksMenstruation && _random.nextDouble() < 0.85) { // 85% compliance
        entries.add(_generateBBTEntry(profileId, date, cycleStart!));
      }

      // Menstruation if in period window
      if (tracksMenstruation) {
        final dayInCycle = date.difference(cycleStart!).inDays % 28;
        if (dayInCycle < 5) { // Days 1-5 of cycle
          entries.add(_generateMenstruationEntry(profileId, date, dayInCycle));
        }
      }
    }

    return entries;
  }

  FluidsEntry _generateBBTEntry(
    String profileId,
    DateTime date,
    DateTime cycleStart,
  ) {
    final dayInCycle = date.difference(cycleStart).inDays % 28;

    // BBT pattern: lower in follicular phase, rises after ovulation
    double baseTemp = 97.0; // Fahrenheit
    if (dayInCycle > 14) {
      baseTemp += 0.3 + _random.nextDouble() * 0.3; // Post-ovulation rise
    }
    baseTemp += (_random.nextDouble() - 0.5) * 0.2; // Daily variation

    // Convert to Celsius for storage
    final tempCelsius = (baseTemp - 32) * 5 / 9;

    return FluidsEntry(
      id: const Uuid().v4(),
      profileId: profileId,
      timestamp: date.add(Duration(hours: 6, minutes: 30)), // Morning
      basalBodyTemperature: tempCelsius,
      bbtRecordedTime: date.add(Duration(hours: 6, minutes: 30)),
      syncMetadata: SyncMetadata.create(),
    );
  }

  List<FluidsEntry> _generateWaterEntries(String profileId, DateTime date) {
    final entries = <FluidsEntry>[];
    final targetMl = 2000 + _random.nextInt(1000); // 2000-3000 mL daily goal
    var consumedMl = 0;

    // Generate 5-10 water entries throughout the day
    final entryCount = 5 + _random.nextInt(6);
    for (int i = 0; i < entryCount; i++) {
      final hour = 7 + (i * 2) + _random.nextInt(2); // Spread 7am-9pm
      final amount = [237, 355, 473][_random.nextInt(3)]; // 8oz, 12oz, 16oz

      if (consumedMl < targetMl) {
        entries.add(FluidsEntry(
          id: const Uuid().v4(),
          profileId: profileId,
          timestamp: date.add(Duration(hours: hour)),
          waterIntakeMl: amount,
          syncMetadata: SyncMetadata.create(),
        ));
        consumedMl += amount;
      }
    }

    return entries;
  }
}
```

---

## 7. Usage

### 7.1 Development Mode Toggle

```dart
// In debug mode only
class DebugMenu extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          title: Text('Generate Quick Demo Data'),
          subtitle: Text('1 profile, 30 days'),
          onTap: () async {
            final generator = ref.read(sampleDataGeneratorProvider);
            final data = await generator.generateQuickDemo();
            await ref.read(databaseProvider).insertSampleData(data);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Demo data generated!')),
            );
          },
        ),
        ListTile(
          title: Text('Generate Full Demo Data'),
          subtitle: Text('3 profiles, 90 days'),
          onTap: () => _generateWithProgress(context, ref, 'full'),
        ),
        ListTile(
          title: Text('Clear All Data'),
          subtitle: Text('Remove all generated data'),
          onTap: () => _confirmClearData(context, ref),
        ),
      ],
    );
  }
}
```

### 7.2 Command-Line Usage

```bash
# Generate sample data for development
flutter run --dart-define=GENERATE_SAMPLE_DATA=true

# Generate specific preset
flutter run --dart-define=SAMPLE_DATA_PRESET=performance
```

### 7.3 Test Usage

```dart
void main() {
  group('Supplement tracking', () {
    late SampleDataset testData;

    setUpAll(() async {
      final generator = SampleDataGenerator();
      testData = await generator.generate(
        config: SampleDataConfig(
          profileCount: 1,
          supplementsPerProfile: 3,
          conditionsPerProfile: 0,
          journalEntriesPerProfile: 0,
          dateRange: DateTimeRange(
            start: DateTime.now().subtract(Duration(days: 7)),
            end: DateTime.now(),
          ),
          includePhotos: false,
        ),
      );
    });

    test('generates supplements with intake logs', () {
      expect(testData.supplements.length, 3);
      expect(testData.intakeLogs.length, greaterThan(0));
    });
  });
}
```

---

## 7. Additional Entity Generators

### 7.1 DietGenerator

```dart
class DietGenerator {
  final Random _random;
  final Uuid _uuid;

  DietGenerator(this._random, this._uuid);

  Diet generate({required String profileId}) {
    final presets = ['keto', 'paleo', 'mediterranean', 'low_fodmap', 'aip', 'if_16_8'];
    final isPreset = _random.nextDouble() < 0.7;

    return Diet(
      id: _uuid.v4(),
      clientId: _uuid.v4(),
      profileId: profileId,
      name: isPreset ? _randomPresetName() : 'Custom Diet',
      presetId: isPreset ? presets[_random.nextInt(presets.length)] : null,
      isActive: _random.nextDouble() < 0.8,
      startDate: DateTime.now().subtract(Duration(days: _random.nextInt(90))),
      endDate: _random.nextDouble() < 0.3 ? DateTime.now().add(Duration(days: _random.nextInt(90))) : null,
      rules: List.generate(_random.nextInt(5) + 1, (_) => _generateRule()),
      syncMetadata: SyncMetadata.create(deviceId: 'test-device'),
    );
  }

  DietRule _generateRule() {
    final types = DietRuleType.values;
    final type = types[_random.nextInt(types.length)];
    return DietRule(
      id: _uuid.v4(),
      type: type,
      severity: RuleSeverity.values[_random.nextInt(3)],
      category: _random.nextDouble() < 0.5 ? FoodCategory.values[_random.nextInt(FoodCategory.values.length)] : null,
      numericValue: _numericValueForType(type),
    );
  }

  double? _numericValueForType(DietRuleType type) {
    return switch (type) {
      DietRuleType.maxCarbs => 20.0 + _random.nextDouble() * 80,
      DietRuleType.maxCalories => 1500.0 + _random.nextDouble() * 1000,
      DietRuleType.fastingHours => 12.0 + _random.nextInt(8),
      _ => null,
    };
  }

  String _randomPresetName() {
    final names = ['Keto', 'Paleo', 'Mediterranean', 'Low FODMAP', 'AIP', 'Intermittent Fasting 16:8'];
    return names[_random.nextInt(names.length)];
  }
}
```

### 7.2 IntelligenceGenerator

```dart
class IntelligenceGenerator {
  final Random _random;
  final Uuid _uuid;

  IntelligenceGenerator(this._random, this._uuid);

  Pattern generatePattern({required String profileId}) {
    return Pattern(
      id: _uuid.v4(),
      clientId: _uuid.v4(),
      profileId: profileId,
      type: PatternType.values[_random.nextInt(PatternType.values.length)],
      description: 'Sample pattern detected',
      confidence: 0.65 + _random.nextDouble() * 0.35,
      pValue: _random.nextDouble() * 0.05,
      sampleSize: 30 + _random.nextInt(100),
      detectedAt: DateTime.now().millisecondsSinceEpoch,
      syncMetadata: SyncMetadata.create(deviceId: 'test-device'),
    );
  }

  TriggerCorrelation generateTriggerCorrelation({required String profileId, required String conditionId}) {
    return TriggerCorrelation(
      id: _uuid.v4(),
      clientId: _uuid.v4(),
      profileId: profileId,
      conditionId: conditionId,
      triggerType: ['food', 'activity', 'sleep', 'stress'][_random.nextInt(4)],
      triggerValue: 'Sample trigger',
      relativeRisk: 1.5 + _random.nextDouble() * 2.5,
      confidenceIntervalLow: 1.2 + _random.nextDouble() * 0.5,
      confidenceIntervalHigh: 2.5 + _random.nextDouble() * 2.0,
      pValue: _random.nextDouble() * 0.05,
      sampleSize: 30 + _random.nextInt(100),
      timeWindowHours: [6, 12, 24, 48][_random.nextInt(4)],
      syncMetadata: SyncMetadata.create(deviceId: 'test-device'),
    );
  }

  HealthInsight generateHealthInsight({required String profileId}) {
    return HealthInsight(
      id: _uuid.v4(),
      clientId: _uuid.v4(),
      profileId: profileId,
      type: InsightType.values[_random.nextInt(InsightType.values.length)],
      title: 'Sample Insight',
      description: 'This is a sample health insight for testing.',
      priority: AlertPriority.values[_random.nextInt(AlertPriority.values.length)],
      generatedAt: DateTime.now().millisecondsSinceEpoch,
      isRead: _random.nextBool(),
      isDismissed: false,
      syncMetadata: SyncMetadata.create(deviceId: 'test-device'),
    );
  }

  PredictiveAlert generatePredictiveAlert({required String profileId}) {
    return PredictiveAlert(
      id: _uuid.v4(),
      clientId: _uuid.v4(),
      profileId: profileId,
      alertType: ['flare_prediction', 'cycle_prediction', 'trigger_warning'][_random.nextInt(3)],
      title: 'Predictive Alert',
      message: 'Sample predictive alert for testing.',
      probability: 0.5 + _random.nextDouble() * 0.4,
      predictedAt: DateTime.now().millisecondsSinceEpoch,
      predictedFor: DateTime.now().add(Duration(hours: 24 + _random.nextInt(48))).millisecondsSinceEpoch,
      isAcknowledged: false,
      syncMetadata: SyncMetadata.create(deviceId: 'test-device'),
    );
  }
}
```

### 7.3 NotificationScheduleGenerator

```dart
class NotificationScheduleGenerator {
  final Random _random;
  final Uuid _uuid;

  NotificationScheduleGenerator(this._random, this._uuid);

  NotificationSchedule generate({required String profileId, String? entityId}) {
    final type = NotificationType.values[_random.nextInt(NotificationType.values.length)];
    final timesCount = 1 + _random.nextInt(3);

    return NotificationSchedule(
      id: _uuid.v4(),
      clientId: _uuid.v4(),
      profileId: profileId,
      type: type,
      entityId: entityId,
      timesMinutesFromMidnight: List.generate(timesCount, (_) => _random.nextInt(1440)),
      weekdays: List.generate(7, (i) => i).where((_) => _random.nextDouble() < 0.7).toList(),
      isEnabled: _random.nextDouble() < 0.9,
      customMessage: _random.nextDouble() < 0.2 ? 'Custom reminder message' : null,
      syncMetadata: SyncMetadata.create(deviceId: 'test-device'),
    );
  }
}
```

### 7.4 WearableIntegrationGenerator

```dart
class WearableIntegrationGenerator {
  final Random _random;
  final Uuid _uuid;

  WearableIntegrationGenerator(this._random, this._uuid);

  WearableConnection generateConnection({required String profileId}) {
    return WearableConnection(
      id: _uuid.v4(),
      clientId: _uuid.v4(),
      profileId: profileId,
      platform: WearablePlatform.values[_random.nextInt(WearablePlatform.values.length)],
      isConnected: _random.nextDouble() < 0.8,
      lastSyncAt: DateTime.now().subtract(Duration(hours: _random.nextInt(24))).millisecondsSinceEpoch,
      accessToken: 'test_access_token_${_uuid.v4()}',
      refreshToken: 'test_refresh_token_${_uuid.v4()}',
      syncMetadata: SyncMetadata.create(deviceId: 'test-device'),
    );
  }

  ImportedDataLog generateImportLog({required String profileId, required String connectionId}) {
    return ImportedDataLog(
      id: _uuid.v4(),
      clientId: _uuid.v4(),
      profileId: profileId,
      connectionId: connectionId,
      dataType: ['steps', 'heart_rate', 'sleep', 'workout'][_random.nextInt(4)],
      importedAt: DateTime.now().millisecondsSinceEpoch,
      recordCount: 10 + _random.nextInt(100),
      startDate: DateTime.now().subtract(Duration(days: 7)).millisecondsSinceEpoch,
      endDate: DateTime.now().millisecondsSinceEpoch,
      syncMetadata: SyncMetadata.create(deviceId: 'test-device'),
    );
  }
}
```

### 7.5 HipaaAuthorizationGenerator

```dart
class HipaaAuthorizationGenerator {
  final Random _random;
  final Uuid _uuid;

  HipaaAuthorizationGenerator(this._random, this._uuid);

  HipaaAuthorization generate({required String profileId, required String authorizedUserId}) {
    final scopes = ['conditions', 'supplements', 'food', 'fluids', 'sleep', 'journal'];
    final selectedScopes = scopes.where((_) => _random.nextDouble() < 0.7).toList();

    return HipaaAuthorization(
      id: _uuid.v4(),
      clientId: _uuid.v4(),
      profileId: profileId,
      authorizedUserId: authorizedUserId,
      accessLevel: AccessLevel.values[_random.nextInt(AccessLevel.values.length)],
      scopes: selectedScopes,
      grantedAt: DateTime.now().subtract(Duration(days: _random.nextInt(30))).millisecondsSinceEpoch,
      expiresAt: _random.nextDouble() < 0.3
          ? DateTime.now().add(Duration(days: 30 + _random.nextInt(335))).millisecondsSinceEpoch
          : null,
      isRevoked: _random.nextDouble() < 0.1,
      revokedAt: null,
      deviceSignature: 'test-device-signature',
      syncMetadata: SyncMetadata.create(deviceId: 'test-device'),
    );
  }

  ProfileAccessLog generateAccessLog({required String profileId, required String userId}) {
    return ProfileAccessLog(
      id: _uuid.v4(),
      clientId: _uuid.v4(),
      profileId: profileId,
      userId: userId,
      action: ['read', 'export', 'share'][_random.nextInt(3)],
      entityType: ['condition', 'supplement', 'food_log'][_random.nextInt(3)],
      entityId: _uuid.v4(),
      accessedAt: DateTime.now().subtract(Duration(hours: _random.nextInt(720))).millisecondsSinceEpoch,
      ipAddress: '192.168.1.${_random.nextInt(256)}',
      deviceInfo: 'iPhone 15 Pro - iOS 17.4',
      syncMetadata: SyncMetadata.create(deviceId: 'test-device'),
    );
  }
}
```

---

## 8. Data Quality Rules

### 8.1 Realistic Patterns

| Data Type | Pattern Rule |
|-----------|--------------|
| Supplement compliance | 70-95% based on difficulty |
| Sleep duration | 6-9 hours with weekday/weekend variance |
| Water intake | 1500-3500 mL daily with morning spike |
| Condition severity | Gradual drift with occasional flares |
| BBT | Biphasic pattern if menstruating |
| Journal entries | More on stressful days |

### 8.2 Correlation Rules

- Higher condition severity → more likely to have journal entry
- Poor sleep → higher condition severity next day
- Missed supplements → slight severity increase
- Weekends → later sleep times

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-31 | Initial release - complete sample data generator specification |
