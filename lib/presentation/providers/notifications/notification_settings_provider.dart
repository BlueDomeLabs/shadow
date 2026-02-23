// lib/presentation/providers/notifications/notification_settings_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/notification_category_settings.dart';
import 'package:shadow_app/domain/usecases/notifications/notification_inputs.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'notification_settings_provider.g.dart';

/// Provider for per-category notification settings (global — not profile-scoped).
///
/// One record exists per NotificationCategory (8 total). Follows the UseCase
/// delegation pattern from 02_CODING_STANDARDS.md.
@riverpod
class NotificationSettings extends _$NotificationSettings {
  static final _log = logger.scope('NotificationSettings');

  @override
  Future<List<NotificationCategorySettings>> build() async {
    _log.debug('Loading notification category settings');

    final useCase = ref.read(getNotificationSettingsUseCaseProvider);
    final result = await useCase();

    return result.when(
      success: (settings) {
        _log.debug('Loaded ${settings.length} category settings');
        return settings;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Updates a single category's notification configuration.
  Future<void> updateSettings(
    UpdateNotificationCategorySettingsInput input,
  ) async {
    _log.debug('Updating notification settings: ${input.id}');

    final useCase = ref.read(updateNotificationCategorySettingsUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Settings updated');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Update failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Sets the notification expiry duration for all 8 categories at once.
  Future<void> setAllExpiry(int minutes) async {
    _log.debug('Setting global expiry to $minutes minutes');

    final settings = state.valueOrNull;
    if (settings == null) return;

    final useCase = ref.read(updateNotificationCategorySettingsUseCaseProvider);
    for (final s in settings) {
      await useCase(
        UpdateNotificationCategorySettingsInput(
          id: s.id,
          expiresAfterMinutes: minutes,
        ),
      );
    }
    ref.invalidateSelf();
  }
}
