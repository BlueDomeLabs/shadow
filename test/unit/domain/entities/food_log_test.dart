// test/unit/domain/entities/food_log_test.dart

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/food_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('FoodLog', () {
    late FoodLog foodLog;
    late SyncMetadata syncMetadata;

    setUp(() {
      syncMetadata = SyncMetadata.create(deviceId: 'test-device');
      foodLog = FoodLog(
        id: 'flog-001',
        clientId: 'client-001',
        profileId: 'profile-001',
        timestamp: 1704067200000,
        mealType: MealType.breakfast,
        foodItemIds: ['food-001', 'food-002'],
        adHocItems: ['Toast'],
        notes: 'Light breakfast',
        syncMetadata: syncMetadata,
      );
    });

    group('required fields per 22_API_CONTRACTS.md', () {
      test('has id field', () {
        expect(foodLog.id, equals('flog-001'));
      });

      test('has clientId field', () {
        expect(foodLog.clientId, equals('client-001'));
      });

      test('has profileId field', () {
        expect(foodLog.profileId, equals('profile-001'));
      });

      test('has timestamp field', () {
        expect(foodLog.timestamp, equals(1704067200000));
      });

      test('has syncMetadata field', () {
        expect(foodLog.syncMetadata, isNotNull);
      });
    });

    group('optional fields per 22_API_CONTRACTS.md', () {
      test('mealType is nullable', () {
        expect(foodLog.mealType, equals(MealType.breakfast));

        final noMeal = FoodLog(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          timestamp: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(noMeal.mealType, isNull);
      });

      test('foodItemIds defaults to empty list', () {
        final minimal = FoodLog(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          timestamp: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(minimal.foodItemIds, isEmpty);
      });

      test('adHocItems defaults to empty list', () {
        final minimal = FoodLog(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          timestamp: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(minimal.adHocItems, isEmpty);
      });

      test('notes is nullable', () {
        expect(foodLog.notes, equals('Light breakfast'));
      });
    });

    group('computed properties', () {
      test('hasItems returns true when foodItemIds present', () {
        expect(foodLog.hasItems, isTrue);
      });

      test('hasItems returns true when adHocItems present', () {
        final adHocOnly = FoodLog(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          timestamp: 1704067200000,
          adHocItems: ['Salad'],
          syncMetadata: syncMetadata,
        );
        expect(adHocOnly.hasItems, isTrue);
      });

      test('hasItems returns false when both empty', () {
        final empty = FoodLog(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          timestamp: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(empty.hasItems, isFalse);
      });

      test('totalItems returns sum of all items', () {
        expect(foodLog.totalItems, equals(3));
      });

      test('totalItems returns 0 when empty', () {
        final empty = FoodLog(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          timestamp: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(empty.totalItems, equals(0));
      });
    });

    group('JSON serialization', () {
      test('toJson produces valid JSON', () {
        final json = foodLog.toJson();
        expect(json, isA<Map<String, dynamic>>());
        expect(json['id'], equals('flog-001'));
        expect(json['timestamp'], equals(1704067200000));
      });

      test('fromJson parses correctly', () {
        final json = foodLog.toJson();
        final parsed = FoodLog.fromJson(json);

        expect(parsed.id, equals(foodLog.id));
        expect(parsed.mealType, equals(foodLog.mealType));
        expect(parsed.foodItemIds, equals(foodLog.foodItemIds));
      });

      test('round-trip serialization preserves data', () {
        final json = foodLog.toJson();
        final jsonString = jsonEncode(json);
        final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        final parsed = FoodLog.fromJson(decoded);

        expect(parsed, equals(foodLog));
      });
    });

    group('copyWith', () {
      test('creates new instance with changed values', () {
        final updated = foodLog.copyWith(mealType: MealType.lunch);

        expect(updated.mealType, equals(MealType.lunch));
        expect(updated.id, equals(foodLog.id));
        expect(foodLog.mealType, equals(MealType.breakfast));
      });
    });
  });
}
