// lib/data/repositories/notification_category_settings_repository_impl.dart
// Repository implementation for NotificationCategorySettings per 57_NOTIFICATION_SYSTEM.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/notification_category_settings_dao.dart';
import 'package:shadow_app/domain/entities/notification_category_settings.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';
import 'package:shadow_app/domain/repositories/notification_category_settings_repository.dart';

/// Implementation of NotificationCategorySettingsRepository.
///
/// Delegates directly to NotificationCategorySettingsDao.
/// Settings are local-only and not synced to the cloud.
class NotificationCategorySettingsRepositoryImpl
    implements NotificationCategorySettingsRepository {
  final NotificationCategorySettingsDao _dao;

  NotificationCategorySettingsRepositoryImpl(this._dao);

  @override
  Future<Result<List<NotificationCategorySettings>, AppError>> getAll() =>
      _dao.getAll();

  @override
  Future<Result<NotificationCategorySettings?, AppError>> getByCategory(
    NotificationCategory category,
  ) => _dao.getByCategory(category);

  @override
  Future<Result<NotificationCategorySettings, AppError>> getById(String id) =>
      _dao.getById(id);

  @override
  Future<Result<NotificationCategorySettings, AppError>> create(
    NotificationCategorySettings settings,
  ) => _dao.insert(settings);

  @override
  Future<Result<NotificationCategorySettings, AppError>> update(
    NotificationCategorySettings settings,
  ) => _dao.updateEntity(settings);
}
