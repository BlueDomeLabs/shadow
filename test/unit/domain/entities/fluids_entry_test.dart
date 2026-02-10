// test/unit/domain/entities/fluids_entry_test.dart

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('FluidsEntry', () {
    late FluidsEntry fluidsEntry;
    late SyncMetadata syncMetadata;

    setUp(() {
      syncMetadata = SyncMetadata.create(deviceId: 'test-device');
      fluidsEntry = FluidsEntry(
        id: 'fluid-001',
        clientId: 'client-001',
        profileId: 'profile-001',
        entryDate: 1704067200000,
        waterIntakeMl: 2000,
        waterIntakeNotes: 'Good hydration',
        bowelCondition: BowelCondition.normal,
        bowelSize: MovementSize.medium,
        urineCondition: UrineCondition.lightYellow,
        urineSize: MovementSize.medium,
        menstruationFlow: MenstruationFlow.light,
        basalBodyTemperature: 97.6,
        bbtRecordedTime: 1704070800000,
        notes: 'Normal day',
        syncMetadata: syncMetadata,
      );
    });

    group('required fields per 22_API_CONTRACTS.md', () {
      test('has id field', () {
        expect(fluidsEntry.id, equals('fluid-001'));
      });

      test('has clientId field', () {
        expect(fluidsEntry.clientId, equals('client-001'));
      });

      test('has profileId field', () {
        expect(fluidsEntry.profileId, equals('profile-001'));
      });

      test('has entryDate field', () {
        expect(fluidsEntry.entryDate, equals(1704067200000));
      });

      test('has syncMetadata field', () {
        expect(fluidsEntry.syncMetadata, isNotNull);
      });
    });

    group('optional fields per 22_API_CONTRACTS.md', () {
      test('waterIntakeMl is nullable', () {
        expect(fluidsEntry.waterIntakeMl, equals(2000));
      });

      test('bowelCondition is nullable', () {
        expect(fluidsEntry.bowelCondition, equals(BowelCondition.normal));
      });

      test('urineCondition is nullable', () {
        expect(fluidsEntry.urineCondition, equals(UrineCondition.lightYellow));
      });

      test('menstruationFlow is nullable', () {
        expect(fluidsEntry.menstruationFlow, equals(MenstruationFlow.light));
      });

      test('basalBodyTemperature is nullable', () {
        expect(fluidsEntry.basalBodyTemperature, equals(97.6));
      });

      test('notes defaults to empty string', () {
        final minimal = FluidsEntry(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          entryDate: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(minimal.notes, equals(''));
      });

      test('photoIds defaults to empty list', () {
        final minimal = FluidsEntry(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          entryDate: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(minimal.photoIds, isEmpty);
      });

      test('isFileUploaded defaults to false', () {
        expect(fluidsEntry.isFileUploaded, isFalse);
      });
    });

    group('computed properties', () {
      test('hasWaterData returns true when waterIntakeMl set', () {
        expect(fluidsEntry.hasWaterData, isTrue);
      });

      test('hasWaterData returns false when waterIntakeMl null', () {
        final noWater = FluidsEntry(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          entryDate: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(noWater.hasWaterData, isFalse);
      });

      test('hasBowelData returns true when bowelCondition set', () {
        expect(fluidsEntry.hasBowelData, isTrue);
      });

      test('hasUrineData returns true when urineCondition set', () {
        expect(fluidsEntry.hasUrineData, isTrue);
      });

      test('hasMenstruationData returns true when menstruationFlow set', () {
        expect(fluidsEntry.hasMenstruationData, isTrue);
      });

      test('hasBBTData returns true when basalBodyTemperature set', () {
        expect(fluidsEntry.hasBBTData, isTrue);
      });

      test('hasOtherFluidData returns true when otherFluidName set', () {
        final withOther = fluidsEntry.copyWith(otherFluidName: 'Coffee');
        expect(withOther.hasOtherFluidData, isTrue);
      });

      test('bbtCelsius converts from Fahrenheit', () {
        final entry = FluidsEntry(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          entryDate: 1704067200000,
          basalBodyTemperature: 98.6,
          syncMetadata: syncMetadata,
        );
        expect(entry.bbtCelsius, closeTo(37.0, 0.1));
      });

      test('bbtCelsius returns null when no temperature', () {
        final noTemp = FluidsEntry(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          entryDate: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(noTemp.bbtCelsius, isNull);
      });
    });

    group('JSON serialization', () {
      test('toJson produces valid JSON', () {
        final json = fluidsEntry.toJson();
        expect(json, isA<Map<String, dynamic>>());
        expect(json['id'], equals('fluid-001'));
        expect(json['waterIntakeMl'], equals(2000));
      });

      test('fromJson parses correctly', () {
        final json = fluidsEntry.toJson();
        final parsed = FluidsEntry.fromJson(json);

        expect(parsed.id, equals(fluidsEntry.id));
        expect(parsed.waterIntakeMl, equals(fluidsEntry.waterIntakeMl));
        expect(parsed.bowelCondition, equals(fluidsEntry.bowelCondition));
      });

      test('round-trip serialization preserves data', () {
        final json = fluidsEntry.toJson();
        final jsonString = jsonEncode(json);
        final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        final parsed = FluidsEntry.fromJson(decoded);

        expect(parsed, equals(fluidsEntry));
      });
    });

    group('copyWith', () {
      test('creates new instance with changed values', () {
        final updated = fluidsEntry.copyWith(waterIntakeMl: 3000);

        expect(updated.waterIntakeMl, equals(3000));
        expect(updated.id, equals(fluidsEntry.id));
        expect(fluidsEntry.waterIntakeMl, equals(2000));
      });
    });
  });
}
