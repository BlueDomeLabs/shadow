// test/unit/domain/enums/health_enums_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('BowelCondition', () {
    test('has correct integer values (0-6)', () {
      expect(BowelCondition.diarrhea.value, equals(0));
      expect(BowelCondition.runny.value, equals(1));
      expect(BowelCondition.loose.value, equals(2));
      expect(BowelCondition.normal.value, equals(3));
      expect(BowelCondition.firm.value, equals(4));
      expect(BowelCondition.hard.value, equals(5));
      expect(BowelCondition.custom.value, equals(6));
    });

    test('fromValue returns correct enum', () {
      expect(BowelCondition.fromValue(0), equals(BowelCondition.diarrhea));
      expect(BowelCondition.fromValue(3), equals(BowelCondition.normal));
      expect(BowelCondition.fromValue(6), equals(BowelCondition.custom));
    });

    test('fromValue returns normal for invalid value', () {
      expect(BowelCondition.fromValue(-1), equals(BowelCondition.normal));
      expect(BowelCondition.fromValue(99), equals(BowelCondition.normal));
    });
  });

  group('UrineCondition', () {
    test('has correct integer values (0-7)', () {
      expect(UrineCondition.clear.value, equals(0));
      expect(UrineCondition.lightYellow.value, equals(1));
      expect(UrineCondition.yellow.value, equals(2));
      expect(UrineCondition.darkYellow.value, equals(3));
      expect(UrineCondition.amber.value, equals(4));
      expect(UrineCondition.brown.value, equals(5));
      expect(UrineCondition.red.value, equals(6));
      expect(UrineCondition.custom.value, equals(7));
    });

    test('fromValue returns lightYellow for invalid value', () {
      expect(UrineCondition.fromValue(-1), equals(UrineCondition.lightYellow));
      expect(UrineCondition.fromValue(99), equals(UrineCondition.lightYellow));
    });
  });

  group('MovementSize', () {
    test('has correct integer values (0-4)', () {
      expect(MovementSize.tiny.value, equals(0));
      expect(MovementSize.small.value, equals(1));
      expect(MovementSize.medium.value, equals(2));
      expect(MovementSize.large.value, equals(3));
      expect(MovementSize.huge.value, equals(4));
    });

    test('fromValue returns medium for invalid value', () {
      expect(MovementSize.fromValue(-1), equals(MovementSize.medium));
      expect(MovementSize.fromValue(99), equals(MovementSize.medium));
    });
  });

  group('MenstruationFlow', () {
    test('has correct integer values (0-4)', () {
      expect(MenstruationFlow.none.value, equals(0));
      expect(MenstruationFlow.spotty.value, equals(1));
      expect(MenstruationFlow.light.value, equals(2));
      expect(MenstruationFlow.medium.value, equals(3));
      expect(MenstruationFlow.heavy.value, equals(4));
    });

    test('fromValue returns none for invalid value', () {
      expect(MenstruationFlow.fromValue(-1), equals(MenstruationFlow.none));
      expect(MenstruationFlow.fromValue(99), equals(MenstruationFlow.none));
    });
  });

  group('SleepQuality', () {
    test('has correct integer values (1-5)', () {
      expect(SleepQuality.veryPoor.value, equals(1));
      expect(SleepQuality.poor.value, equals(2));
      expect(SleepQuality.fair.value, equals(3));
      expect(SleepQuality.good.value, equals(4));
      expect(SleepQuality.excellent.value, equals(5));
    });

    test('fromValue returns fair for invalid value', () {
      expect(SleepQuality.fromValue(0), equals(SleepQuality.fair));
      expect(SleepQuality.fromValue(99), equals(SleepQuality.fair));
    });
  });

  group('ActivityIntensity', () {
    test('has correct integer values (0-2)', () {
      expect(ActivityIntensity.light.value, equals(0));
      expect(ActivityIntensity.moderate.value, equals(1));
      expect(ActivityIntensity.vigorous.value, equals(2));
    });

    test('fromValue returns moderate for invalid value', () {
      expect(
        ActivityIntensity.fromValue(-1),
        equals(ActivityIntensity.moderate),
      );
      expect(
        ActivityIntensity.fromValue(99),
        equals(ActivityIntensity.moderate),
      );
    });
  });

  group('ConditionSeverity', () {
    test('has correct integer values (0-4)', () {
      expect(ConditionSeverity.none.value, equals(0));
      expect(ConditionSeverity.mild.value, equals(1));
      expect(ConditionSeverity.moderate.value, equals(2));
      expect(ConditionSeverity.severe.value, equals(3));
      expect(ConditionSeverity.extreme.value, equals(4));
    });

    test('fromValue returns none for invalid value', () {
      expect(ConditionSeverity.fromValue(-1), equals(ConditionSeverity.none));
      expect(ConditionSeverity.fromValue(99), equals(ConditionSeverity.none));
    });

    group('toStorageScale()', () {
      test('converts to 1-10 scale correctly', () {
        expect(ConditionSeverity.none.toStorageScale(), equals(1));
        expect(ConditionSeverity.mild.toStorageScale(), equals(3));
        expect(ConditionSeverity.moderate.toStorageScale(), equals(5));
        expect(ConditionSeverity.severe.toStorageScale(), equals(7));
        expect(ConditionSeverity.extreme.toStorageScale(), equals(10));
      });
    });

    group('fromStorageScale()', () {
      test('converts from 1-10 scale correctly', () {
        // none: 1
        expect(
          ConditionSeverity.fromStorageScale(0),
          equals(ConditionSeverity.none),
        );
        expect(
          ConditionSeverity.fromStorageScale(1),
          equals(ConditionSeverity.none),
        );

        // mild: 2-3
        expect(
          ConditionSeverity.fromStorageScale(2),
          equals(ConditionSeverity.mild),
        );
        expect(
          ConditionSeverity.fromStorageScale(3),
          equals(ConditionSeverity.mild),
        );

        // moderate: 4-5
        expect(
          ConditionSeverity.fromStorageScale(4),
          equals(ConditionSeverity.moderate),
        );
        expect(
          ConditionSeverity.fromStorageScale(5),
          equals(ConditionSeverity.moderate),
        );

        // severe: 6-8
        expect(
          ConditionSeverity.fromStorageScale(6),
          equals(ConditionSeverity.severe),
        );
        expect(
          ConditionSeverity.fromStorageScale(7),
          equals(ConditionSeverity.severe),
        );
        expect(
          ConditionSeverity.fromStorageScale(8),
          equals(ConditionSeverity.severe),
        );

        // extreme: 9-10
        expect(
          ConditionSeverity.fromStorageScale(9),
          equals(ConditionSeverity.extreme),
        );
        expect(
          ConditionSeverity.fromStorageScale(10),
          equals(ConditionSeverity.extreme),
        );
      });

      test('round-trip conversion preserves severity', () {
        for (final severity in ConditionSeverity.values) {
          final storageValue = severity.toStorageScale();
          final restored = ConditionSeverity.fromStorageScale(storageValue);
          expect(
            restored,
            equals(severity),
            reason: '$severity -> $storageValue -> $restored',
          );
        }
      });
    });
  });

  group('MoodLevel', () {
    test('has correct integer values (1-5)', () {
      expect(MoodLevel.veryLow.value, equals(1));
      expect(MoodLevel.low.value, equals(2));
      expect(MoodLevel.neutral.value, equals(3));
      expect(MoodLevel.good.value, equals(4));
      expect(MoodLevel.veryGood.value, equals(5));
    });

    test('fromValue returns neutral for invalid value', () {
      expect(MoodLevel.fromValue(0), equals(MoodLevel.neutral));
      expect(MoodLevel.fromValue(99), equals(MoodLevel.neutral));
    });
  });

  group('DietRuleType', () {
    test('has correct integer values (0-21)', () {
      expect(DietRuleType.excludeCategory.value, equals(0));
      expect(DietRuleType.excludeIngredient.value, equals(1));
      expect(DietRuleType.requireCategory.value, equals(2));
      expect(DietRuleType.limitCategory.value, equals(3));
      expect(DietRuleType.maxCarbs.value, equals(4));
      expect(DietRuleType.minProtein.value, equals(9));
      expect(DietRuleType.maxCalories.value, equals(13));
      expect(DietRuleType.eatingWindowStart.value, equals(14));
      expect(DietRuleType.fastingHours.value, equals(16));
      expect(DietRuleType.noEatingAfter.value, equals(21));
    });

    test('fromValue returns excludeCategory for invalid value', () {
      expect(DietRuleType.fromValue(-1), equals(DietRuleType.excludeCategory));
      expect(DietRuleType.fromValue(99), equals(DietRuleType.excludeCategory));
    });
  });

  group('PatternType', () {
    test('has correct integer values (0-4)', () {
      expect(PatternType.temporal.value, equals(0));
      expect(PatternType.cyclical.value, equals(1));
      expect(PatternType.sequential.value, equals(2));
      expect(PatternType.cluster.value, equals(3));
      expect(PatternType.dosage.value, equals(4));
    });

    test('fromValue returns temporal for invalid value', () {
      expect(PatternType.fromValue(-1), equals(PatternType.temporal));
      expect(PatternType.fromValue(99), equals(PatternType.temporal));
    });
  });

  group('DietPresetType', () {
    test('has all expected preset types', () {
      expect(DietPresetType.values.length, equals(20));
      expect(DietPresetType.values.contains(DietPresetType.vegan), isTrue);
      expect(DietPresetType.values.contains(DietPresetType.keto), isTrue);
      expect(DietPresetType.values.contains(DietPresetType.if168), isTrue);
      expect(DietPresetType.values.contains(DietPresetType.omad), isTrue);
      expect(DietPresetType.values.contains(DietPresetType.custom), isTrue);
    });
  });

  group('InsightCategory', () {
    test('has all expected categories', () {
      expect(InsightCategory.values.contains(InsightCategory.daily), isTrue);
      expect(InsightCategory.values.contains(InsightCategory.summary), isTrue);
      expect(InsightCategory.values.contains(InsightCategory.pattern), isTrue);
      expect(InsightCategory.values.contains(InsightCategory.trigger), isTrue);
      expect(InsightCategory.values.contains(InsightCategory.progress), isTrue);
      expect(
        InsightCategory.values.contains(InsightCategory.compliance),
        isTrue,
      );
      expect(InsightCategory.values.contains(InsightCategory.anomaly), isTrue);
      expect(
        InsightCategory.values.contains(InsightCategory.milestone),
        isTrue,
      );
      expect(
        InsightCategory.values.contains(InsightCategory.recommendation),
        isTrue,
      );
    });
  });

  group('AlertPriority', () {
    test('has correct integer values (0-3)', () {
      expect(AlertPriority.low.value, equals(0));
      expect(AlertPriority.medium.value, equals(1));
      expect(AlertPriority.high.value, equals(2));
      expect(AlertPriority.critical.value, equals(3));
    });

    test('fromValue returns low for invalid value', () {
      expect(AlertPriority.fromValue(-1), equals(AlertPriority.low));
      expect(AlertPriority.fromValue(99), equals(AlertPriority.low));
    });
  });

  group('WearablePlatform', () {
    test('has all expected platforms', () {
      expect(WearablePlatform.values.length, equals(6));
      expect(
        WearablePlatform.values.contains(WearablePlatform.healthkit),
        isTrue,
      );
      expect(
        WearablePlatform.values.contains(WearablePlatform.googlefit),
        isTrue,
      );
      expect(WearablePlatform.values.contains(WearablePlatform.fitbit), isTrue);
      expect(WearablePlatform.values.contains(WearablePlatform.garmin), isTrue);
      expect(WearablePlatform.values.contains(WearablePlatform.oura), isTrue);
      expect(WearablePlatform.values.contains(WearablePlatform.whoop), isTrue);
    });
  });

  group('NotificationType', () {
    test('has correct integer values (0-24)', () {
      expect(NotificationType.supplementIndividual.value, equals(0));
      expect(NotificationType.supplementGrouped.value, equals(1));
      expect(NotificationType.mealBreakfast.value, equals(2));
      expect(NotificationType.mealLunch.value, equals(3));
      expect(NotificationType.mealDinner.value, equals(4));
      expect(NotificationType.mealSnacks.value, equals(5));
      expect(NotificationType.waterInterval.value, equals(6));
      expect(NotificationType.bbtMorning.value, equals(9));
      expect(NotificationType.conditionCheckIn.value, equals(13));
      expect(NotificationType.fastingWindowOpen.value, equals(17));
      expect(NotificationType.dietStreak.value, equals(20));
      expect(NotificationType.inactivity.value, equals(24));
    });

    test('fromValue returns supplementIndividual for invalid value', () {
      expect(
        NotificationType.fromValue(-1),
        equals(NotificationType.supplementIndividual),
      );
      expect(
        NotificationType.fromValue(99),
        equals(NotificationType.supplementIndividual),
      );
    });

    group('allowsSnooze', () {
      test('returns false for non-snoozable types', () {
        expect(NotificationType.bbtMorning.allowsSnooze, isFalse);
        expect(NotificationType.dietStreak.allowsSnooze, isFalse);
        expect(NotificationType.dietWeeklySummary.allowsSnooze, isFalse);
        expect(NotificationType.inactivity.allowsSnooze, isFalse);
      });

      test('returns true for snoozable types', () {
        expect(NotificationType.supplementIndividual.allowsSnooze, isTrue);
        expect(NotificationType.mealBreakfast.allowsSnooze, isTrue);
        expect(NotificationType.waterInterval.allowsSnooze, isTrue);
        expect(NotificationType.sleepBedtime.allowsSnooze, isTrue);
        expect(NotificationType.fastingWindowOpen.allowsSnooze, isTrue);
      });
    });

    group('defaultSnoozeMinutes', () {
      test('returns 0 for non-snoozable types', () {
        expect(NotificationType.bbtMorning.defaultSnoozeMinutes, equals(0));
        expect(NotificationType.dietStreak.defaultSnoozeMinutes, equals(0));
        expect(
          NotificationType.dietWeeklySummary.defaultSnoozeMinutes,
          equals(0),
        );
        expect(NotificationType.inactivity.defaultSnoozeMinutes, equals(0));
      });

      test('returns 15 for supplement types', () {
        expect(
          NotificationType.supplementIndividual.defaultSnoozeMinutes,
          equals(15),
        );
        expect(
          NotificationType.supplementGrouped.defaultSnoozeMinutes,
          equals(15),
        );
      });

      test('returns 30 for meal types', () {
        expect(NotificationType.mealBreakfast.defaultSnoozeMinutes, equals(30));
        expect(NotificationType.mealLunch.defaultSnoozeMinutes, equals(30));
        expect(NotificationType.mealDinner.defaultSnoozeMinutes, equals(30));
        expect(NotificationType.mealSnacks.defaultSnoozeMinutes, equals(30));
      });

      test('returns 30 for water types', () {
        expect(NotificationType.waterInterval.defaultSnoozeMinutes, equals(30));
        expect(NotificationType.waterFixed.defaultSnoozeMinutes, equals(30));
        expect(NotificationType.waterSmart.defaultSnoozeMinutes, equals(30));
      });

      test('returns 60 for condition and tracking types', () {
        expect(
          NotificationType.menstruationTracking.defaultSnoozeMinutes,
          equals(60),
        );
        expect(
          NotificationType.conditionCheckIn.defaultSnoozeMinutes,
          equals(60),
        );
        expect(NotificationType.photoReminder.defaultSnoozeMinutes, equals(60));
        expect(NotificationType.journalPrompt.defaultSnoozeMinutes, equals(60));
        expect(NotificationType.fluidsBowel.defaultSnoozeMinutes, equals(60));
      });

      test('returns 120 for sync reminder', () {
        expect(NotificationType.syncReminder.defaultSnoozeMinutes, equals(120));
      });

      test('returns 5 for sleep wakeup', () {
        expect(NotificationType.sleepWakeup.defaultSnoozeMinutes, equals(5));
      });

      test('returns 15 for sleep bedtime and fasting windows', () {
        expect(NotificationType.sleepBedtime.defaultSnoozeMinutes, equals(15));
        expect(
          NotificationType.fastingWindowOpen.defaultSnoozeMinutes,
          equals(15),
        );
        expect(
          NotificationType.fastingWindowClose.defaultSnoozeMinutes,
          equals(15),
        );
        expect(
          NotificationType.fastingWindowClosed.defaultSnoozeMinutes,
          equals(15),
        );
      });
    });
  });
}
