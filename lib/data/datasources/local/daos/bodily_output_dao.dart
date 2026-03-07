// lib/data/datasources/local/daos/bodily_output_dao.dart
// DAO for bodily_output_logs table per FLUIDS_RESTRUCTURING_SPEC.md Section 5

import 'package:drift/drift.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/bodily_output_logs_table.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

part 'bodily_output_dao.g.dart';

/// Data Access Object for the bodily_output_logs table.
///
/// Returns raw table rows (BodilyOutputLogRow). Conversion to domain
/// entities is handled in BodilyOutputRepositoryImpl.
@DriftAccessor(tables: [BodilyOutputLogs])
class BodilyOutputDao extends DatabaseAccessor<AppDatabase>
    with _$BodilyOutputDaoMixin {
  BodilyOutputDao(super.db);

  /// Insert a new bodily output log row.
  Future<void> insert(BodilyOutputLogsCompanion entry) =>
      into(bodilyOutputLogs).insert(entry);

  /// Query output events for a profile with optional date and type filters.
  Future<List<BodilyOutputLogRow>> getAll(
    String profileId, {
    int? from,
    int? to,
    int? outputType,
  }) {
    final query = select(bodilyOutputLogs)
      ..where((t) {
        var expr = t.profileId.equals(profileId) & t.syncDeletedAt.isNull();
        if (from != null) {
          expr = expr & t.occurredAt.isBiggerOrEqualValue(from);
        }
        if (to != null) {
          expr = expr & t.occurredAt.isSmallerOrEqualValue(to);
        }
        if (outputType != null) {
          expr = expr & t.outputType.equals(outputType);
        }
        return expr;
      })
      ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]);
    return query.get();
  }

  /// Fetch a single output log by ID (excludes soft-deleted rows).
  Future<BodilyOutputLogRow?> getById(String id) =>
      (select(bodilyOutputLogs)
            ..where((t) => t.id.equals(id) & t.syncDeletedAt.isNull()))
          .getSingleOrNull();

  /// Update an existing output log row.
  Future<void> updateEntry(BodilyOutputLogsCompanion entry) => (update(
    bodilyOutputLogs,
  )..where((t) => t.id.equals(entry.id.value))).write(entry);

  /// Soft-delete a row by setting sync_deleted_at and marking dirty.
  Future<void> softDelete(String id, int deletedAt) =>
      (update(bodilyOutputLogs)..where((t) => t.id.equals(id))).write(
        BodilyOutputLogsCompanion(
          syncDeletedAt: Value(deletedAt),
          syncUpdatedAt: Value(deletedAt),
          syncIsDirty: const Value(true),
          syncStatus: Value(SyncStatus.deleted.value),
        ),
      );

  /// Get all rows for a profile that are marked dirty (pending sync).
  Future<List<BodilyOutputLogRow>> getDirtyRecords(String profileId) =>
      (select(bodilyOutputLogs)..where(
            (t) => t.profileId.equals(profileId) & t.syncIsDirty.equals(true),
          ))
          .get();
}
