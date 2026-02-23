// lib/domain/usecases/settings/update_user_settings_use_case.dart
// Per 58_SETTINGS_SCREENS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/user_settings.dart';
import 'package:shadow_app/domain/repositories/user_settings_repository.dart';

/// Persists updated app-wide user settings.
class UpdateUserSettingsUseCase {
  final UserSettingsRepository _repository;

  const UpdateUserSettingsUseCase(this._repository);

  Future<Result<UserSettings, AppError>> call(UserSettings settings) =>
      _repository.updateSettings(settings);
}
