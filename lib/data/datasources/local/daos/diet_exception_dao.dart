// lib/data/datasources/local/daos/diet_exception_dao.dart
// Phase 15b — DAO for diet_exceptions table
// Per 59_DIET_TRACKING.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/diet_exceptions_table.dart';
import 'package:shadow_app/domain/entities/diet_exception.dart';

part 'diet_exception_dao.g.dart';

/// Data Access Object for the diet_exceptions table.
@DriftAccessor(tables: [DietExceptions])
class DietExceptionDao extends DatabaseAccessor<AppDatabase>
    with _$DietExceptionDaoMixin {
  DietExceptionDao(super.db);

  /// Get all exceptions for a rule, ordered by sort_order.
  Future<Result<List<DietException>, AppError>> getForRule(
    String ruleId,
  ) async {
    try {
      final rows =
          await (select(dietExceptions)
                ..where((e) => e.ruleId.equals(ruleId))
                ..orderBy([(e) => OrderingTerm.asc(e.sortOrder)]))
              .get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('diet_exceptions', e.toString(), stack),
      );
    }
  }

  /// Get a single exception by ID.
  Future<Result<DietException, AppError>> getById(String id) async {
    try {
      final row = await (select(
        dietExceptions,
      )..where((e) => e.id.equals(id))).getSingleOrNull();
      if (row == null) {
        return Failure(DatabaseError.notFound('DietException', id));
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('diet_exceptions', e.toString(), stack),
      );
    }
  }

  /// Insert a new exception.
  Future<Result<DietException, AppError>> insert(DietException entity) async {
    try {
      await into(dietExceptions).insert(_entityToCompanion(entity));
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('diet_exceptions', e, stack));
    }
  }

  /// Delete an exception by ID.
  Future<Result<void, AppError>> deleteById(String id) async {
    try {
      final rowsAffected = await (delete(
        dietExceptions,
      )..where((e) => e.id.equals(id))).go();
      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('DietException', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.deleteFailed('diet_exceptions', id, e, stack),
      );
    }
  }

  /// Delete all exceptions for a rule (when rule is deleted).
  Future<void> deleteForRule(String ruleId) async {
    await (delete(dietExceptions)..where((e) => e.ruleId.equals(ruleId))).go();
  }

  DietException _rowToEntity(DietExceptionRow row) => DietException(
    id: row.id,
    ruleId: row.ruleId,
    description: row.description,
    sortOrder: row.sortOrder,
  );

  DietExceptionsCompanion _entityToCompanion(DietException entity) =>
      DietExceptionsCompanion(
        id: Value(entity.id),
        ruleId: Value(entity.ruleId),
        description: Value(entity.description),
        sortOrder: Value(entity.sortOrder),
      );
}
