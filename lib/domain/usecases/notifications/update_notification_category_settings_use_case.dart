// lib/domain/usecases/notifications/update_notification_category_settings_use_case.dart
// Per 57_NOTIFICATION_SYSTEM.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/notification_category_settings.dart';
import 'package:shadow_app/domain/repositories/notification_category_settings_repository.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/notifications/notification_inputs.dart';

/// Updates a single category's notification settings.
///
/// Called when the user changes any configuration in Notification Settings
/// (enable/disable, mode change, anchor event assignments, interval, times).
/// After this, the caller should reschedule notifications for that category.
class UpdateNotificationCategorySettingsUseCase
    implements
        UseCase<
          UpdateNotificationCategorySettingsInput,
          NotificationCategorySettings
        > {
  final NotificationCategorySettingsRepository _repository;

  UpdateNotificationCategorySettingsUseCase(this._repository);

  @override
  Future<Result<NotificationCategorySettings, AppError>> call(
    UpdateNotificationCategorySettingsInput input,
  ) async {
    final getResult = await _repository.getById(input.id);
    if (getResult.isFailure) return getResult;

    final existing = getResult.valueOrNull!;
    final updated = existing.copyWith(
      isEnabled: input.isEnabled ?? existing.isEnabled,
      schedulingMode: input.schedulingMode ?? existing.schedulingMode,
      anchorEventValues: input.anchorEventValues ?? existing.anchorEventValues,
      intervalHours: input.intervalHours ?? existing.intervalHours,
      intervalStartTime: input.intervalStartTime ?? existing.intervalStartTime,
      intervalEndTime: input.intervalEndTime ?? existing.intervalEndTime,
      specificTimes: input.specificTimes ?? existing.specificTimes,
      expiresAfterMinutes:
          input.expiresAfterMinutes ?? existing.expiresAfterMinutes,
    );

    return _repository.update(updated);
  }
}
