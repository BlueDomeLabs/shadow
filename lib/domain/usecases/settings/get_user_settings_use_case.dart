// lib/domain/usecases/settings/get_user_settings_use_case.dart
// Per 58_SETTINGS_SCREENS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/user_settings.dart';
import 'package:shadow_app/domain/repositories/user_settings_repository.dart';

/// Returns the current app-wide user settings.
///
/// Creates and returns defaults on first call if no settings exist.
class GetUserSettingsUseCase {
  final UserSettingsRepository _repository;

  const GetUserSettingsUseCase(this._repository);

  Future<Result<UserSettings, AppError>> call() => _repository.getSettings();
}
