// lib/data/datasources/local/daos/diet_rule_dao.dart
// Phase 15b — DAO for diet_rules table
// Per 59_DIET_TRACKING.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/diet_rules_table.dart';
import 'package:shadow_app/domain/entities/diet_rule.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'diet_rule_dao.g.dart';

/// Data Access Object for the diet_rules table.
@DriftAccessor(tables: [DietRules])
class DietRuleDao extends DatabaseAccessor<AppDatabase>
    with _$DietRuleDaoMixin {
  DietRuleDao(super.db);

  /// Get all rules for a diet, ordered by sort_order.
  Future<Result<List<DietRule>, AppError>> getForDiet(String dietId) async {
    try {
      final rows =
          await (select(dietRules)
                ..where((r) => r.dietId.equals(dietId))
                ..orderBy([(r) => OrderingTerm.asc(r.sortOrder)]))
              .get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('diet_rules', e.toString(), stack),
      );
    }
  }

  /// Get a single rule by ID.
  Future<Result<DietRule, AppError>> getById(String id) async {
    try {
      final row = await (select(
        dietRules,
      )..where((r) => r.id.equals(id))).getSingleOrNull();
      if (row == null) {
        return Failure(DatabaseError.notFound('DietRule', id));
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('diet_rules', e.toString(), stack),
      );
    }
  }

  /// Insert a new rule.
  Future<Result<DietRule, AppError>> insert(DietRule entity) async {
    try {
      await into(dietRules).insert(_entityToCompanion(entity));
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('diet_rules', e, stack));
    }
  }

  /// Update a rule.
  Future<Result<DietRule, AppError>> updateEntity(DietRule entity) async {
    try {
      await (update(dietRules)..where((r) => r.id.equals(entity.id))).write(
        _entityToCompanion(entity),
      );
      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('diet_rules', entity.id, e, stack),
      );
    }
  }

  /// Delete a rule by ID.
  Future<Result<void, AppError>> deleteById(String id) async {
    try {
      final rowsAffected = await (delete(
        dietRules,
      )..where((r) => r.id.equals(id))).go();
      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('DietRule', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('diet_rules', id, e, stack));
    }
  }

  /// Delete all rules for a diet (when diet is deleted).
  Future<void> deleteForDiet(String dietId) async {
    await (delete(dietRules)..where((r) => r.dietId.equals(dietId))).go();
  }

  DietRule _rowToEntity(DietRuleRow row) => DietRule(
    id: row.id,
    dietId: row.dietId,
    ruleType: DietRuleType.fromValue(row.ruleType),
    targetFoodItemId: row.targetFoodItemId,
    targetCategory: row.targetCategory,
    targetIngredient: row.targetIngredient,
    minValue: row.minValue,
    maxValue: row.maxValue,
    unit: row.unit,
    frequency: row.frequency,
    timeValue: row.timeValue,
    sortOrder: row.sortOrder,
  );

  DietRulesCompanion _entityToCompanion(DietRule entity) => DietRulesCompanion(
    id: Value(entity.id),
    dietId: Value(entity.dietId),
    ruleType: Value(entity.ruleType.value),
    targetFoodItemId: Value(entity.targetFoodItemId),
    targetCategory: Value(entity.targetCategory),
    targetIngredient: Value(entity.targetIngredient),
    minValue: Value(entity.minValue),
    maxValue: Value(entity.maxValue),
    unit: Value(entity.unit),
    frequency: Value(entity.frequency),
    timeValue: Value(entity.timeValue),
    sortOrder: Value(entity.sortOrder),
  );
}
