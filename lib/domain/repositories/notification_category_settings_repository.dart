// lib/domain/repositories/notification_category_settings_repository.dart
// Per 57_NOTIFICATION_SYSTEM.md — NotificationCategorySettings repository interface

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/notification_category_settings.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';

/// Repository contract for NotificationCategorySettings entities.
///
/// One row per NotificationCategory (8 rows total), pre-seeded at v12 migration.
/// Settings are read by the NotificationService when scheduling notifications
/// and written by the Settings screen when the user changes preferences.
abstract class NotificationCategorySettingsRepository {
  /// Get all 8 category settings, ordered by category.
  Future<Result<List<NotificationCategorySettings>, AppError>> getAll();

  /// Get settings for a single category.
  Future<Result<NotificationCategorySettings?, AppError>> getByCategory(
    NotificationCategory category,
  );

  /// Get settings by ID.
  Future<Result<NotificationCategorySettings, AppError>> getById(String id);

  /// Create a new settings row (used during seeding only).
  Future<Result<NotificationCategorySettings, AppError>> create(
    NotificationCategorySettings settings,
  );

  /// Update an existing settings row.
  Future<Result<NotificationCategorySettings, AppError>> update(
    NotificationCategorySettings settings,
  );
}
