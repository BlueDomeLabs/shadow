// lib/data/datasources/local/daos/health_sync_status_dao.dart
// Phase 16 — DAO for health_sync_status table
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/health_sync_status_table.dart';
import 'package:shadow_app/domain/entities/health_sync_status.dart' as domain;
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'health_sync_status_dao.g.dart';

/// Data Access Object for the health_sync_status table.
@DriftAccessor(tables: [HealthSyncStatusTable])
class HealthSyncStatusDao extends DatabaseAccessor<AppDatabase>
    with _$HealthSyncStatusDaoMixin {
  HealthSyncStatusDao(super.db);

  /// Get all sync status rows for a profile.
  Future<Result<List<domain.HealthSyncStatus>, AppError>> getByProfile(
    String profileId,
  ) async {
    try {
      final rows = await (select(
        healthSyncStatusTable,
      )..where((s) => s.profileId.equals(profileId))).get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('health_sync_status', e.toString(), stack),
      );
    }
  }

  /// Get sync status for a specific (profileId, dataType) pair.
  Future<Result<domain.HealthSyncStatus?, AppError>> getByDataType(
    String profileId,
    HealthDataType dataType,
  ) async {
    try {
      final row =
          await (select(healthSyncStatusTable)..where(
                (s) =>
                    s.profileId.equals(profileId) &
                    s.dataType.equals(dataType.value),
              ))
              .getSingleOrNull();
      return Success(row == null ? null : _rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('health_sync_status', e.toString(), stack),
      );
    }
  }

  /// Insert or update a sync status row.
  Future<Result<void, AppError>> upsert(domain.HealthSyncStatus entity) async {
    try {
      await into(
        healthSyncStatusTable,
      ).insertOnConflictUpdate(_entityToCompanion(entity));
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.insertFailed('health_sync_status', e, stack),
      );
    }
  }

  domain.HealthSyncStatus _rowToEntity(HealthSyncStatusRow row) =>
      domain.HealthSyncStatus(
        id: row.id,
        profileId: row.profileId,
        dataType: HealthDataType.fromValue(row.dataType),
        lastSyncedAt: row.lastSyncedAt,
        recordCount: row.recordCount,
        lastError: row.lastError,
      );

  HealthSyncStatusTableCompanion _entityToCompanion(
    domain.HealthSyncStatus entity,
  ) => HealthSyncStatusTableCompanion(
    id: Value(entity.id),
    profileId: Value(entity.profileId),
    dataType: Value(entity.dataType.value),
    lastSyncedAt: Value(entity.lastSyncedAt),
    recordCount: Value(entity.recordCount),
    lastError: Value(entity.lastError),
  );
}
