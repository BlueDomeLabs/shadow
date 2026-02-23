// lib/domain/repositories/user_settings_repository.dart
// Repository interface for UserSettings per 58_SETTINGS_SCREENS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/user_settings.dart';

/// Repository for reading and writing the singleton UserSettings record.
abstract class UserSettingsRepository {
  /// Returns the current user settings, creating defaults if none exist.
  Future<Result<UserSettings, AppError>> getSettings();

  /// Persists updated settings.
  Future<Result<UserSettings, AppError>> updateSettings(UserSettings settings);
}
