// lib/data/datasources/local/daos/health_sync_settings_dao.dart
// Phase 16 — DAO for health_sync_settings table
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/health_sync_settings_table.dart';
import 'package:shadow_app/domain/entities/health_sync_settings.dart' as domain;
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'health_sync_settings_dao.g.dart';

/// Data Access Object for the health_sync_settings table.
@DriftAccessor(tables: [HealthSyncSettingsTable])
class HealthSyncSettingsDao extends DatabaseAccessor<AppDatabase>
    with _$HealthSyncSettingsDaoMixin {
  HealthSyncSettingsDao(super.db);

  /// Get settings for a profile, or null if never configured.
  Future<Result<domain.HealthSyncSettings?, AppError>> getByProfile(
    String profileId,
  ) async {
    try {
      final row = await (select(
        healthSyncSettingsTable,
      )..where((s) => s.profileId.equals(profileId))).getSingleOrNull();
      return Success(row == null ? null : _rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('health_sync_settings', e.toString(), stack),
      );
    }
  }

  /// Create or update settings for a profile.
  Future<Result<domain.HealthSyncSettings, AppError>> save(
    domain.HealthSyncSettings entity,
  ) async {
    try {
      await into(
        healthSyncSettingsTable,
      ).insertOnConflictUpdate(_entityToCompanion(entity));
      final result = await getByProfile(entity.profileId);
      return result.when(
        success: (s) => s != null
            ? Success(s)
            : Failure(DatabaseError.notFound('HealthSyncSettings', entity.id)),
        failure: Failure.new,
      );
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.insertFailed('health_sync_settings', e, stack),
      );
    }
  }

  domain.HealthSyncSettings _rowToEntity(HealthSyncSettingsRow row) {
    // Decode JSON array of int values to List<HealthDataType>
    final rawList = jsonDecode(row.enabledDataTypes) as List<dynamic>;
    final enabledTypes = rawList
        .map((v) => HealthDataType.fromValue(v as int))
        .toList();

    return domain.HealthSyncSettings(
      id: row.id,
      profileId: row.profileId,
      enabledDataTypes: enabledTypes,
      dateRangeDays: row.dateRangeDays,
    );
  }

  HealthSyncSettingsTableCompanion _entityToCompanion(
    domain.HealthSyncSettings entity,
  ) {
    // Encode List<HealthDataType> to JSON array of int values
    final encodedTypes = jsonEncode(
      entity.enabledDataTypes.map((t) => t.value).toList(),
    );

    return HealthSyncSettingsTableCompanion(
      id: Value(entity.id),
      profileId: Value(entity.profileId),
      enabledDataTypes: Value(encodedTypes),
      dateRangeDays: Value(entity.dateRangeDays),
    );
  }
}
