// lib/presentation/providers/settings/user_settings_provider.dart
// Per 58_SETTINGS_SCREENS.md

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/domain/entities/user_settings.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'user_settings_provider.g.dart';

/// Provider for app-wide user settings (units, security configuration).
///
/// Loads from [GetUserSettingsUseCase] on first access (creates defaults if
/// none exist). Updates are written back through [UpdateUserSettingsUseCase].
@riverpod
class UserSettingsNotifier extends _$UserSettingsNotifier {
  @override
  Future<UserSettings> build() async {
    final useCase = ref.read(getUserSettingsUseCaseProvider);
    final result = await useCase();
    return result.when(
      success: (settings) => settings,
      failure: (error) => throw error,
    );
  }

  /// Persists the updated settings and refreshes state.
  Future<void> save(UserSettings settings) async {
    final useCase = ref.read(updateUserSettingsUseCaseProvider);
    final result = await useCase(settings);
    result.when(
      success: (updated) => state = AsyncData(updated),
      failure: (error) => throw error,
    );
  }
}
