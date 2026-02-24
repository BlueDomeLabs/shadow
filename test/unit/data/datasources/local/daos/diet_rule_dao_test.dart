// test/unit/data/datasources/local/daos/diet_rule_dao_test.dart
// Phase 15b-1 — Tests for DietRuleDao
// Per 59_DIET_TRACKING.md

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/diet_rule.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('DietRuleDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    DietRule createTestRule({
      String? id,
      String dietId = 'diet-001',
      DietRuleType ruleType = DietRuleType.excludeCategory,
      String? targetCategory,
      String? targetIngredient,
      double? maxValue,
      int sortOrder = 0,
    }) => DietRule(
      id: id ?? 'rule-${DateTime.now().microsecondsSinceEpoch}',
      dietId: dietId,
      ruleType: ruleType,
      targetCategory: targetCategory,
      targetIngredient: targetIngredient,
      maxValue: maxValue,
      sortOrder: sortOrder,
    );

    group('insert', () {
      test('insert_validRule_returnsSuccess', () async {
        final rule = createTestRule(id: 'rule-001', targetCategory: 'dairy');

        final result = await database.dietRuleDao.insert(rule);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'rule-001');
        expect(result.valueOrNull?.targetCategory, 'dairy');
      });

      test('insert_duplicateId_returnsFailure', () async {
        final r1 = createTestRule(id: 'rule-dup');
        final r2 = createTestRule(id: 'rule-dup');

        await database.dietRuleDao.insert(r1);
        final result = await database.dietRuleDao.insert(r2);

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeConstraintViolation,
        );
      });

      test('insert_allRuleTypes_roundTripsCorrectly', () async {
        final rule = createTestRule(
          id: 'rule-macro',
          ruleType: DietRuleType.maxCarbs,
          maxValue: 20,
        );

        final result = await database.dietRuleDao.insert(rule);

        expect(result.valueOrNull?.ruleType, DietRuleType.maxCarbs);
        expect(result.valueOrNull?.maxValue, 20.0);
      });
    });

    group('getById', () {
      test('getById_existingRule_returnsSuccess', () async {
        final rule = createTestRule(id: 'rule-get');
        await database.dietRuleDao.insert(rule);

        final result = await database.dietRuleDao.getById('rule-get');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'rule-get');
      });

      test('getById_notFound_returnsFailure', () async {
        final result = await database.dietRuleDao.getById('nonexistent');

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeNotFound,
        );
      });
    });

    group('getForDiet', () {
      test('getForDiet_returnsRulesOrderedBySortOrder', () async {
        final r1 = createTestRule(id: 'rule-so2', sortOrder: 2);
        final r2 = createTestRule(id: 'rule-so0');
        final r3 = createTestRule(id: 'rule-so1', sortOrder: 1);

        await database.dietRuleDao.insert(r1);
        await database.dietRuleDao.insert(r2);
        await database.dietRuleDao.insert(r3);

        final result = await database.dietRuleDao.getForDiet('diet-001');

        expect(result.isSuccess, isTrue);
        final ids = result.valueOrNull?.map((r) => r.id).toList();
        expect(ids, ['rule-so0', 'rule-so1', 'rule-so2']);
      });

      test('getForDiet_differentDiet_returnsDietRulesOnly', () async {
        final r1 = createTestRule(id: 'rule-d1');
        final r2 = createTestRule(id: 'rule-d2', dietId: 'diet-002');
        await database.dietRuleDao.insert(r1);
        await database.dietRuleDao.insert(r2);

        final result = await database.dietRuleDao.getForDiet('diet-001');

        expect(result.valueOrNull?.length, 1);
        expect(result.valueOrNull?.first.id, 'rule-d1');
      });
    });

    group('updateEntity', () {
      test('updateEntity_existingRule_updatesFields', () async {
        final rule = createTestRule(id: 'rule-upd', targetCategory: 'dairy');
        await database.dietRuleDao.insert(rule);

        final updated = rule.copyWith(targetCategory: 'grains', maxValue: 50);
        final result = await database.dietRuleDao.updateEntity(updated);

        expect(result.valueOrNull?.targetCategory, 'grains');
        expect(result.valueOrNull?.maxValue, 50.0);
      });
    });

    group('deleteById', () {
      test('deleteById_existingRule_returnsSuccess', () async {
        final rule = createTestRule(id: 'rule-del');
        await database.dietRuleDao.insert(rule);

        final result = await database.dietRuleDao.deleteById('rule-del');

        expect(result.isSuccess, isTrue);
        final getResult = await database.dietRuleDao.getById('rule-del');
        expect(getResult.isFailure, isTrue);
      });

      test('deleteById_notFound_returnsFailure', () async {
        final result = await database.dietRuleDao.deleteById('nonexistent');

        expect(result.isFailure, isTrue);
      });
    });

    group('deleteForDiet', () {
      test('deleteForDiet_removesAllRulesForDiet', () async {
        final r1 = createTestRule(id: 'rule-fd1', dietId: 'diet-del');
        final r2 = createTestRule(id: 'rule-fd2', dietId: 'diet-del');
        final other = createTestRule(id: 'rule-other', dietId: 'diet-keep');
        await database.dietRuleDao.insert(r1);
        await database.dietRuleDao.insert(r2);
        await database.dietRuleDao.insert(other);

        await database.dietRuleDao.deleteForDiet('diet-del');

        final deleted = await database.dietRuleDao.getForDiet('diet-del');
        expect(deleted.valueOrNull, isEmpty);

        final kept = await database.dietRuleDao.getForDiet('diet-keep');
        expect(kept.valueOrNull?.length, 1);
      });
    });
  });
}
