// lib/data/datasources/local/daos/anchor_event_time_dao.dart
// Data Access Object for anchor_event_times table per 57_NOTIFICATION_SYSTEM.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/anchor_event_times_table.dart';
import 'package:shadow_app/domain/entities/anchor_event_time.dart' as domain;
import 'package:shadow_app/domain/enums/notification_enums.dart';

part 'anchor_event_time_dao.g.dart';

/// Data Access Object for the anchor_event_times table.
///
/// Implements all database operations for AnchorEventTime entities.
/// Returns Result types for all operations per 22_API_CONTRACTS.md.
@DriftAccessor(tables: [AnchorEventTimes])
class AnchorEventTimeDao extends DatabaseAccessor<AppDatabase>
    with _$AnchorEventTimeDaoMixin {
  AnchorEventTimeDao(super.db);

  /// Get all anchor event times, ordered by event name value.
  Future<Result<List<domain.AnchorEventTime>, AppError>> getAll() async {
    try {
      final query = select(anchorEventTimes)
        ..orderBy([(t) => OrderingTerm.asc(t.name)]);
      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('anchor_event_times', e.toString(), stack),
      );
    }
  }

  /// Get a single anchor event time by ID.
  Future<Result<domain.AnchorEventTime, AppError>> getById(String id) async {
    try {
      final query = select(anchorEventTimes)..where((t) => t.id.equals(id));
      final row = await query.getSingleOrNull();
      if (row == null) {
        return Failure(DatabaseError.notFound('AnchorEventTime', id));
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('anchor_event_times', e.toString(), stack),
      );
    }
  }

  /// Get a single anchor event time by name.
  Future<Result<domain.AnchorEventTime?, AppError>> getByName(
    AnchorEventName name,
  ) async {
    try {
      final query = select(anchorEventTimes)
        ..where((t) => t.name.equals(name.value));
      final row = await query.getSingleOrNull();
      return Success(row == null ? null : _rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('anchor_event_times', e.toString(), stack),
      );
    }
  }

  /// Insert a new anchor event time (used during initial seeding).
  Future<Result<domain.AnchorEventTime, AppError>> insert(
    domain.AnchorEventTime entity,
  ) async {
    try {
      await into(anchorEventTimes).insert(_entityToCompanion(entity));
      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.insertFailed('anchor_event_times', e, stack),
      );
    }
  }

  /// Update an existing anchor event time.
  Future<Result<domain.AnchorEventTime, AppError>> updateEntity(
    domain.AnchorEventTime entity,
  ) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) return existsResult;

      await (update(anchorEventTimes)..where((t) => t.id.equals(entity.id)))
          .write(_entityToCompanion(entity));
      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('anchor_event_times', entity.id, e, stack),
      );
    }
  }

  /// Convert database row to domain entity.
  domain.AnchorEventTime _rowToEntity(AnchorEventTimeRow row) =>
      domain.AnchorEventTime(
        id: row.id,
        name: AnchorEventName.fromValue(row.name),
        timeOfDay: row.timeOfDay,
        isEnabled: row.isEnabled,
      );

  /// Convert domain entity to database companion.
  AnchorEventTimesCompanion _entityToCompanion(domain.AnchorEventTime entity) =>
      AnchorEventTimesCompanion(
        id: Value(entity.id),
        name: Value(entity.name.value),
        timeOfDay: Value(entity.timeOfDay),
        isEnabled: Value(entity.isEnabled),
      );
}
