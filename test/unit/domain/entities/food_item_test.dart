// test/unit/domain/entities/food_item_test.dart

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('FoodItem', () {
    late FoodItem foodItem;
    late SyncMetadata syncMetadata;

    setUp(() {
      syncMetadata = SyncMetadata.create(deviceId: 'test-device');
      foodItem = FoodItem(
        id: 'food-001',
        clientId: 'client-001',
        profileId: 'profile-001',
        name: 'Chicken Breast',
        servingSize: '100g',
        calories: 165,
        carbsGrams: 0,
        fatGrams: 3.6,
        proteinGrams: 31,
        fiberGrams: 0,
        sugarGrams: 0,
        syncMetadata: syncMetadata,
      );
    });

    group('required fields per 22_API_CONTRACTS.md', () {
      test('has id field', () {
        expect(foodItem.id, equals('food-001'));
      });

      test('has clientId field', () {
        expect(foodItem.clientId, equals('client-001'));
      });

      test('has profileId field', () {
        expect(foodItem.profileId, equals('profile-001'));
      });

      test('has name field', () {
        expect(foodItem.name, equals('Chicken Breast'));
      });

      test('has syncMetadata field', () {
        expect(foodItem.syncMetadata, isNotNull);
      });
    });

    group('optional fields per 22_API_CONTRACTS.md', () {
      test('type defaults to simple', () {
        expect(foodItem.type, equals(FoodItemType.simple));
      });

      test('simpleItemIds defaults to empty list', () {
        expect(foodItem.simpleItemIds, isEmpty);
      });

      test('isUserCreated defaults to true', () {
        expect(foodItem.isUserCreated, isTrue);
      });

      test('isArchived defaults to false', () {
        expect(foodItem.isArchived, isFalse);
      });

      test('servingSize is nullable', () {
        expect(foodItem.servingSize, equals('100g'));
      });

      test('calories is nullable', () {
        expect(foodItem.calories, equals(165));
      });

      test('nutritional fields are nullable', () {
        final minimal = FoodItem(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          name: 'Test',
          syncMetadata: syncMetadata,
        );
        expect(minimal.calories, isNull);
        expect(minimal.carbsGrams, isNull);
        expect(minimal.fatGrams, isNull);
        expect(minimal.proteinGrams, isNull);
        expect(minimal.fiberGrams, isNull);
        expect(minimal.sugarGrams, isNull);
      });
    });

    group('computed properties', () {
      test('isComposed returns true for composed type', () {
        final composed = foodItem.copyWith(type: FoodItemType.composed);
        expect(composed.isComposed, isTrue);
      });

      test('isComposed returns false for simple type', () {
        expect(foodItem.isComposed, isFalse);
      });

      test('isSimple returns true for simple type', () {
        expect(foodItem.isSimple, isTrue);
      });

      test('hasNutritionalInfo returns true when calories set', () {
        expect(foodItem.hasNutritionalInfo, isTrue);
      });

      test('hasNutritionalInfo returns true when carbsGrams set', () {
        final withCarbs = FoodItem(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          name: 'Test',
          carbsGrams: 10,
          syncMetadata: syncMetadata,
        );
        expect(withCarbs.hasNutritionalInfo, isTrue);
      });

      test('hasNutritionalInfo returns false when no nutrition', () {
        final noNutrition = FoodItem(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          name: 'Test',
          syncMetadata: syncMetadata,
        );
        expect(noNutrition.hasNutritionalInfo, isFalse);
      });

      test('isActive returns true when not archived and not deleted', () {
        expect(foodItem.isActive, isTrue);
      });

      test('isActive returns false when archived', () {
        final archived = foodItem.copyWith(isArchived: true);
        expect(archived.isActive, isFalse);
      });

      test('isActive returns false when soft deleted', () {
        final deleted = foodItem.copyWith(
          syncMetadata: syncMetadata.markDeleted('test-device'),
        );
        expect(deleted.isActive, isFalse);
      });
    });

    group('JSON serialization', () {
      test('toJson produces valid JSON', () {
        final json = foodItem.toJson();
        expect(json, isA<Map<String, dynamic>>());
        expect(json['id'], equals('food-001'));
        expect(json['name'], equals('Chicken Breast'));
      });

      test('fromJson parses correctly', () {
        final json = foodItem.toJson();
        final parsed = FoodItem.fromJson(json);

        expect(parsed.id, equals(foodItem.id));
        expect(parsed.name, equals(foodItem.name));
        expect(parsed.type, equals(foodItem.type));
        expect(parsed.calories, equals(foodItem.calories));
      });

      test('round-trip serialization preserves data', () {
        final json = foodItem.toJson();
        final jsonString = jsonEncode(json);
        final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        final parsed = FoodItem.fromJson(decoded);

        expect(parsed, equals(foodItem));
      });
    });

    group('copyWith', () {
      test('creates new instance with changed values', () {
        final updated = foodItem.copyWith(name: 'Turkey Breast');

        expect(updated.name, equals('Turkey Breast'));
        expect(updated.id, equals(foodItem.id));
        expect(foodItem.name, equals('Chicken Breast'));
      });
    });
  });
}
