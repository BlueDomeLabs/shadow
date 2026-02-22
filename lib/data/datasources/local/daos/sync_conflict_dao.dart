// lib/data/datasources/local/daos/sync_conflict_dao.dart
// Data Access Object for sync_conflicts table per 10_DATABASE_SCHEMA.md Section 17

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/sync_conflicts_table.dart';
import 'package:shadow_app/domain/entities/sync_conflict.dart';

part 'sync_conflict_dao.g.dart';

/// Data Access Object for the sync_conflicts table.
///
/// Provides CRUD operations for SyncConflict records.
/// All methods return Result types per 22_API_CONTRACTS.md.
///
/// See 10_DATABASE_SCHEMA.md Section 17 for schema.
/// See 22_API_CONTRACTS.md Section 17.7 for resolution behavior.
@DriftAccessor(tables: [SyncConflicts])
class SyncConflictDao extends DatabaseAccessor<AppDatabase>
    with _$SyncConflictDaoMixin {
  SyncConflictDao(super.db);

  /// Insert a new conflict record.
  Future<Result<void, AppError>> insert(SyncConflict conflict) async {
    try {
      await into(syncConflicts).insert(_entityToCompanion(conflict));
      return const Success(null);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation(
            'Conflict already exists for entity: ${conflict.entityId}',
          ),
        );
      }
      return Failure(DatabaseError.insertFailed('sync_conflicts', e, stack));
    }
  }

  /// Get a single conflict by its ID.
  ///
  /// Returns Failure(notFound) if no conflict exists with this ID.
  Future<Result<SyncConflict, AppError>> getById(String id) async {
    try {
      final query = select(syncConflicts)..where((c) => c.id.equals(id));

      final row = await query.getSingleOrNull();

      if (row == null) {
        return Failure(DatabaseError.notFound('SyncConflict', id));
      }

      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('sync_conflicts', e.toString(), stack),
      );
    }
  }

  /// Count unresolved conflicts for a profile.
  ///
  /// Used by SyncService.getConflictCount() per 22_API_CONTRACTS.md Section 17.7.3.
  Future<Result<int, AppError>> countUnresolved(String profileId) async {
    try {
      final count =
          await (selectOnly(syncConflicts)
                ..addColumns([syncConflicts.id.count()])
                ..where(
                  syncConflicts.profileId.equals(profileId) &
                      syncConflicts.isResolved.equals(false),
                ))
              .map((row) => row.read(syncConflicts.id.count()) ?? 0)
              .getSingle();

      return Success(count);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('sync_conflicts', e.toString(), stack),
      );
    }
  }

  /// Get all unresolved conflicts for a profile, ordered by detection time.
  Future<Result<List<SyncConflict>, AppError>> getUnresolved(
    String profileId,
  ) async {
    try {
      final query = select(syncConflicts)
        ..where(
          (c) => c.profileId.equals(profileId) & c.isResolved.equals(false),
        )
        ..orderBy([(c) => OrderingTerm.asc(c.detectedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('sync_conflicts', e.toString(), stack),
      );
    }
  }

  /// Mark a conflict as resolved.
  ///
  /// Sets is_resolved = true, resolution = [resolution].value, resolved_at = [resolvedAt].
  /// Returns Failure(notFound) if the conflict ID does not exist.
  Future<Result<void, AppError>> markResolved(
    String id,
    ConflictResolutionType resolution,
    int resolvedAt,
  ) async {
    try {
      final rowsAffected =
          await (update(
            syncConflicts,
          )..where((c) => c.id.equals(id) & c.isResolved.equals(false))).write(
            SyncConflictsCompanion(
              isResolved: const Value(true),
              resolution: Value(resolution.value),
              resolvedAt: Value(resolvedAt),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('SyncConflict', id));
      }

      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('sync_conflicts', id, e, stack),
      );
    }
  }

  // === Private helpers ===

  SyncConflict _rowToEntity(SyncConflictRow row) => SyncConflict(
    id: row.id,
    entityType: row.entityType,
    entityId: row.entityId,
    profileId: row.profileId,
    localVersion: row.localVersion,
    remoteVersion: row.remoteVersion,
    localData: _parseJson(row.localData, 'localData', row.id),
    remoteData: _parseJson(row.remoteData, 'remoteData', row.id),
    detectedAt: row.detectedAt,
    isResolved: row.isResolved,
    resolution: row.resolution != null
        ? ConflictResolutionType.fromValue(row.resolution!)
        : null,
    resolvedAt: row.resolvedAt,
  );

  SyncConflictsCompanion _entityToCompanion(SyncConflict conflict) =>
      SyncConflictsCompanion(
        id: Value(conflict.id),
        entityType: Value(conflict.entityType),
        entityId: Value(conflict.entityId),
        profileId: Value(conflict.profileId),
        localVersion: Value(conflict.localVersion),
        remoteVersion: Value(conflict.remoteVersion),
        localData: Value(jsonEncode(conflict.localData)),
        remoteData: Value(jsonEncode(conflict.remoteData)),
        detectedAt: Value(conflict.detectedAt),
        isResolved: Value(conflict.isResolved),
        resolution: Value(conflict.resolution?.value),
        resolvedAt: Value(conflict.resolvedAt),
      );

  Map<String, dynamic> _parseJson(
    String json,
    String fieldName,
    String conflictId,
  ) {
    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } on Exception catch (e) {
      debugPrint(
        'WARNING: Failed to parse $fieldName JSON in SyncConflictDao '
        'for conflict $conflictId: $e',
      );
      return {};
    }
  }
}
