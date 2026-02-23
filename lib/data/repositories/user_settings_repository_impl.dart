// lib/data/repositories/user_settings_repository_impl.dart
// Per 58_SETTINGS_SCREENS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/user_settings_dao.dart';
import 'package:shadow_app/domain/entities/user_settings.dart';
import 'package:shadow_app/domain/repositories/user_settings_repository.dart';

/// Implementation of UserSettingsRepository backed by UserSettingsDao.
class UserSettingsRepositoryImpl implements UserSettingsRepository {
  final UserSettingsDao _dao;

  UserSettingsRepositoryImpl(this._dao);

  @override
  Future<Result<UserSettings, AppError>> getSettings() => _dao.getOrCreate();

  @override
  Future<Result<UserSettings, AppError>> updateSettings(
    UserSettings settings,
  ) => _dao.updateEntity(settings);
}
