// lib/data/datasources/local/daos/notification_category_settings_dao.dart
// Data Access Object for notification_category_settings table per 57_NOTIFICATION_SYSTEM.md

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/notification_category_settings_table.dart';
import 'package:shadow_app/domain/entities/notification_category_settings.dart'
    as domain;
import 'package:shadow_app/domain/enums/notification_enums.dart';

part 'notification_category_settings_dao.g.dart';

/// Data Access Object for the notification_category_settings table.
///
/// Implements all database operations for NotificationCategorySettings entities.
/// Returns Result types for all operations per 22_API_CONTRACTS.md.
@DriftAccessor(tables: [NotificationCategorySettings])
class NotificationCategorySettingsDao extends DatabaseAccessor<AppDatabase>
    with _$NotificationCategorySettingsDaoMixin {
  NotificationCategorySettingsDao(super.db);

  /// Get all category settings, ordered by category value.
  Future<Result<List<domain.NotificationCategorySettings>, AppError>>
  getAll() async {
    try {
      final query = select(notificationCategorySettings)
        ..orderBy([(s) => OrderingTerm.asc(s.category)]);
      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed(
          'notification_category_settings',
          e.toString(),
          stack,
        ),
      );
    }
  }

  /// Get settings for a single category.
  Future<Result<domain.NotificationCategorySettings?, AppError>> getByCategory(
    NotificationCategory category,
  ) async {
    try {
      final query = select(notificationCategorySettings)
        ..where((s) => s.category.equals(category.value));
      final row = await query.getSingleOrNull();
      return Success(row == null ? null : _rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed(
          'notification_category_settings',
          e.toString(),
          stack,
        ),
      );
    }
  }

  /// Get settings by ID.
  Future<Result<domain.NotificationCategorySettings, AppError>> getById(
    String id,
  ) async {
    try {
      final query = select(notificationCategorySettings)
        ..where((s) => s.id.equals(id));
      final row = await query.getSingleOrNull();
      if (row == null) {
        return Failure(
          DatabaseError.notFound('NotificationCategorySettings', id),
        );
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed(
          'notification_category_settings',
          e.toString(),
          stack,
        ),
      );
    }
  }

  /// Insert a new settings row (used during initial seeding).
  Future<Result<domain.NotificationCategorySettings, AppError>> insert(
    domain.NotificationCategorySettings entity,
  ) async {
    try {
      await into(
        notificationCategorySettings,
      ).insert(_entityToCompanion(entity));
      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.insertFailed('notification_category_settings', e, stack),
      );
    }
  }

  /// Update an existing settings row.
  Future<Result<domain.NotificationCategorySettings, AppError>> updateEntity(
    domain.NotificationCategorySettings entity,
  ) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) return existsResult;

      await (update(notificationCategorySettings)
            ..where((s) => s.id.equals(entity.id)))
          .write(_entityToCompanion(entity));
      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed(
          'notification_category_settings',
          entity.id,
          e,
          stack,
        ),
      );
    }
  }

  /// Convert database row to domain entity.
  domain.NotificationCategorySettings _rowToEntity(
    NotificationCategorySettingsRow row,
  ) {
    final anchorValues = (jsonDecode(row.anchorEventValues) as List<dynamic>)
        .map((v) => v as int)
        .toList();
    final times = (jsonDecode(row.specificTimes) as List<dynamic>)
        .map((v) => v as String)
        .toList();

    return domain.NotificationCategorySettings(
      id: row.id,
      category: NotificationCategory.fromValue(row.category),
      isEnabled: row.isEnabled,
      schedulingMode: NotificationSchedulingMode.fromValue(row.schedulingMode),
      anchorEventValues: anchorValues,
      intervalHours: row.intervalHours,
      intervalStartTime: row.intervalStartTime,
      intervalEndTime: row.intervalEndTime,
      specificTimes: times,
      expiresAfterMinutes: row.expiresAfterMinutes,
    );
  }

  /// Convert domain entity to database companion.
  NotificationCategorySettingsCompanion _entityToCompanion(
    domain.NotificationCategorySettings entity,
  ) => NotificationCategorySettingsCompanion(
    id: Value(entity.id),
    category: Value(entity.category.value),
    isEnabled: Value(entity.isEnabled),
    schedulingMode: Value(entity.schedulingMode.value),
    anchorEventValues: Value(jsonEncode(entity.anchorEventValues)),
    intervalHours: Value(entity.intervalHours),
    intervalStartTime: Value(entity.intervalStartTime),
    intervalEndTime: Value(entity.intervalEndTime),
    specificTimes: Value(jsonEncode(entity.specificTimes)),
    expiresAfterMinutes: Value(entity.expiresAfterMinutes),
  );
}
