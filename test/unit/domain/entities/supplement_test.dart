// test/unit/domain/entities/supplement_test.dart

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('Supplement', () {
    late Supplement supplement;
    late SyncMetadata syncMetadata;

    setUp(() {
      syncMetadata = SyncMetadata.create(deviceId: 'test-device');
      supplement = Supplement(
        id: 'supp-001',
        clientId: 'client-001',
        profileId: 'profile-001',
        name: 'Vitamin D3',
        form: SupplementForm.capsule,
        dosageQuantity: 2,
        dosageUnit: DosageUnit.iu,
        brand: 'TestBrand',
        notes: 'Take with food',
        syncMetadata: syncMetadata,
      );
    });

    group('required fields per 22_API_CONTRACTS.md', () {
      test('has id field', () {
        expect(supplement.id, equals('supp-001'));
      });

      test('has clientId field', () {
        expect(supplement.clientId, equals('client-001'));
      });

      test('has profileId field', () {
        expect(supplement.profileId, equals('profile-001'));
      });

      test('has name field', () {
        expect(supplement.name, equals('Vitamin D3'));
      });

      test('has form field', () {
        expect(supplement.form, equals(SupplementForm.capsule));
      });

      test('has dosageQuantity field', () {
        expect(supplement.dosageQuantity, equals(2));
      });

      test('has dosageUnit field', () {
        expect(supplement.dosageUnit, equals(DosageUnit.iu));
      });

      test('has syncMetadata field', () {
        expect(supplement.syncMetadata, isNotNull);
      });
    });

    group('optional fields per 22_API_CONTRACTS.md', () {
      test('customForm is nullable', () {
        expect(supplement.customForm, isNull);

        final withCustomForm = supplement.copyWith(
          form: SupplementForm.other,
          customForm: 'Gummy',
        );
        expect(withCustomForm.customForm, equals('Gummy'));
      });

      test('brand defaults to empty string', () {
        final minimal = Supplement(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          name: 'Test',
          form: SupplementForm.tablet,
          dosageQuantity: 1,
          dosageUnit: DosageUnit.mg,
          syncMetadata: syncMetadata,
        );
        expect(minimal.brand, equals(''));
      });

      test('notes defaults to empty string', () {
        final minimal = Supplement(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          name: 'Test',
          form: SupplementForm.tablet,
          dosageQuantity: 1,
          dosageUnit: DosageUnit.mg,
          syncMetadata: syncMetadata,
        );
        expect(minimal.notes, equals(''));
      });

      test('ingredients defaults to empty list', () {
        expect(supplement.ingredients, isEmpty);
      });

      test('schedules defaults to empty list', () {
        expect(supplement.schedules, isEmpty);
      });

      test('startDate is nullable', () {
        expect(supplement.startDate, isNull);
      });

      test('endDate is nullable', () {
        expect(supplement.endDate, isNull);
      });

      test('isArchived defaults to false', () {
        expect(supplement.isArchived, isFalse);
      });
    });

    group('computed properties', () {
      test('hasSchedules returns false when empty', () {
        expect(supplement.hasSchedules, isFalse);
      });

      test('hasSchedules returns true when schedules present', () {
        final withSchedules = supplement.copyWith(
          schedules: [
            const SupplementSchedule(
              anchorEvent: SupplementAnchorEvent.breakfast,
              timingType: SupplementTimingType.withEvent,
              frequencyType: SupplementFrequencyType.daily,
            ),
          ],
        );
        expect(withSchedules.hasSchedules, isTrue);
      });

      test('isActive returns true when not archived and not deleted', () {
        expect(supplement.isActive, isTrue);
      });

      test('isActive returns false when archived', () {
        final archived = supplement.copyWith(isArchived: true);
        expect(archived.isActive, isFalse);
      });

      test('isActive returns false when soft deleted', () {
        final deleted = supplement.copyWith(
          syncMetadata: syncMetadata.markDeleted('test-device'),
        );
        expect(deleted.isActive, isFalse);
      });

      test('isWithinDateRange returns true when no dates set', () {
        expect(supplement.isWithinDateRange, isTrue);
      });

      test('isWithinDateRange returns false when before startDate', () {
        final futureStart = supplement.copyWith(
          startDate: DateTime.now()
              .add(const Duration(days: 30))
              .millisecondsSinceEpoch,
        );
        expect(futureStart.isWithinDateRange, isFalse);
      });

      test('isWithinDateRange returns false when after endDate', () {
        final pastEnd = supplement.copyWith(
          endDate: DateTime.now()
              .subtract(const Duration(days: 30))
              .millisecondsSinceEpoch,
        );
        expect(pastEnd.isWithinDateRange, isFalse);
      });

      test('displayDosage formats correctly', () {
        expect(supplement.displayDosage, equals('2 IU'));

        final mgSupplement = supplement.copyWith(
          dosageQuantity: 500,
          dosageUnit: DosageUnit.mg,
        );
        expect(mgSupplement.displayDosage, equals('500 mg'));
      });
    });

    group('JSON serialization', () {
      test('toJson produces valid JSON', () {
        final json = supplement.toJson();
        expect(json, isA<Map<String, dynamic>>());
        expect(json['id'], equals('supp-001'));
        expect(json['name'], equals('Vitamin D3'));
      });

      test('fromJson parses correctly', () {
        final json = supplement.toJson();
        final parsed = Supplement.fromJson(json);

        expect(parsed.id, equals(supplement.id));
        expect(parsed.name, equals(supplement.name));
        expect(parsed.form, equals(supplement.form));
        expect(parsed.dosageQuantity, equals(supplement.dosageQuantity));
      });

      test('round-trip serialization preserves data', () {
        final json = supplement.toJson();
        final jsonString = jsonEncode(json);
        final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        final parsed = Supplement.fromJson(decoded);

        expect(parsed, equals(supplement));
      });
    });

    group('copyWith', () {
      test('creates new instance with changed values', () {
        final updated = supplement.copyWith(name: 'Updated Name');

        expect(updated.name, equals('Updated Name'));
        expect(updated.id, equals(supplement.id));
        expect(supplement.name, equals('Vitamin D3'));
      });
    });
  });

  group('SupplementIngredient', () {
    test('creates with required fields', () {
      const ingredient = SupplementIngredient(name: 'Vitamin D3');
      expect(ingredient.name, equals('Vitamin D3'));
    });

    test('all fields are optional except name', () {
      const ingredient = SupplementIngredient(
        name: 'Magnesium Citrate',
        quantity: 200,
        unit: DosageUnit.mg,
        notes: 'Chelated form',
      );

      expect(ingredient.quantity, equals(200));
      expect(ingredient.unit, equals(DosageUnit.mg));
      expect(ingredient.notes, equals('Chelated form'));
    });

    test('JSON round-trip preserves data', () {
      const ingredient = SupplementIngredient(
        name: 'Zinc',
        quantity: 15,
        unit: DosageUnit.mg,
      );

      final json = ingredient.toJson();
      final parsed = SupplementIngredient.fromJson(json);

      expect(parsed, equals(ingredient));
    });
  });

  group('SupplementSchedule', () {
    test('creates with required fields', () {
      const schedule = SupplementSchedule(
        anchorEvent: SupplementAnchorEvent.breakfast,
        timingType: SupplementTimingType.withEvent,
        frequencyType: SupplementFrequencyType.daily,
      );

      expect(schedule.anchorEvent, equals(SupplementAnchorEvent.breakfast));
      expect(schedule.timingType, equals(SupplementTimingType.withEvent));
      expect(schedule.frequencyType, equals(SupplementFrequencyType.daily));
    });

    test('offsetMinutes defaults to 0', () {
      const schedule = SupplementSchedule(
        anchorEvent: SupplementAnchorEvent.lunch,
        timingType: SupplementTimingType.beforeEvent,
        frequencyType: SupplementFrequencyType.daily,
      );
      expect(schedule.offsetMinutes, equals(0));
    });

    test('everyXDays defaults to 1', () {
      const schedule = SupplementSchedule(
        anchorEvent: SupplementAnchorEvent.dinner,
        timingType: SupplementTimingType.afterEvent,
        frequencyType: SupplementFrequencyType.everyXDays,
      );
      expect(schedule.everyXDays, equals(1));
    });

    test('weekdays defaults to all days', () {
      const schedule = SupplementSchedule(
        anchorEvent: SupplementAnchorEvent.wake,
        timingType: SupplementTimingType.specificTime,
        frequencyType: SupplementFrequencyType.specificWeekdays,
      );
      expect(schedule.weekdays, equals([0, 1, 2, 3, 4, 5, 6]));
    });

    test('specificTimeMinutes is nullable', () {
      const schedule = SupplementSchedule(
        anchorEvent: SupplementAnchorEvent.bed,
        timingType: SupplementTimingType.specificTime,
        frequencyType: SupplementFrequencyType.daily,
        specificTimeMinutes: 480,
      );
      expect(schedule.specificTimeMinutes, equals(480));
    });

    test('JSON round-trip preserves data', () {
      const schedule = SupplementSchedule(
        anchorEvent: SupplementAnchorEvent.breakfast,
        timingType: SupplementTimingType.beforeEvent,
        offsetMinutes: 30,
        frequencyType: SupplementFrequencyType.specificWeekdays,
        weekdays: [1, 2, 3, 4, 5],
      );

      final json = schedule.toJson();
      final parsed = SupplementSchedule.fromJson(json);

      expect(parsed, equals(schedule));
    });
  });

  group('Supplement enums', () {
    test('SupplementForm has correct values', () {
      expect(SupplementForm.capsule.value, equals(0));
      expect(SupplementForm.powder.value, equals(1));
      expect(SupplementForm.liquid.value, equals(2));
      expect(SupplementForm.tablet.value, equals(3));
      expect(SupplementForm.gummy.value, equals(4));
      expect(SupplementForm.spray.value, equals(5));
      expect(SupplementForm.other.value, equals(6));
    });

    test('SupplementForm.fromValue returns correct enum', () {
      expect(SupplementForm.fromValue(0), equals(SupplementForm.capsule));
      expect(SupplementForm.fromValue(3), equals(SupplementForm.tablet));
      expect(SupplementForm.fromValue(4), equals(SupplementForm.gummy));
      expect(SupplementForm.fromValue(5), equals(SupplementForm.spray));
      expect(SupplementForm.fromValue(99), equals(SupplementForm.capsule));
    });

    test('DosageUnit has correct values and abbreviations', () {
      expect(DosageUnit.g.value, equals(0));
      expect(DosageUnit.g.abbreviation, equals('g'));
      expect(DosageUnit.mg.value, equals(1));
      expect(DosageUnit.mg.abbreviation, equals('mg'));
      expect(DosageUnit.iu.value, equals(3));
      expect(DosageUnit.iu.abbreviation, equals('IU'));
    });

    test('SupplementTimingType has correct values', () {
      expect(SupplementTimingType.withEvent.value, equals(0));
      expect(SupplementTimingType.beforeEvent.value, equals(1));
      expect(SupplementTimingType.afterEvent.value, equals(2));
      expect(SupplementTimingType.specificTime.value, equals(3));
    });

    test('SupplementFrequencyType has correct values', () {
      expect(SupplementFrequencyType.daily.value, equals(0));
      expect(SupplementFrequencyType.everyXDays.value, equals(1));
      expect(SupplementFrequencyType.specificWeekdays.value, equals(2));
    });

    test('SupplementAnchorEvent has correct values', () {
      expect(SupplementAnchorEvent.wake.value, equals(0));
      expect(SupplementAnchorEvent.breakfast.value, equals(1));
      expect(SupplementAnchorEvent.lunch.value, equals(2));
      expect(SupplementAnchorEvent.dinner.value, equals(3));
      expect(SupplementAnchorEvent.bed.value, equals(4));
    });
  });
}
