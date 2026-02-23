// lib/domain/usecases/notifications/get_notification_settings_use_case.dart
// Per 57_NOTIFICATION_SYSTEM.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/notification_category_settings.dart';
import 'package:shadow_app/domain/repositories/notification_category_settings_repository.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';

/// Returns all 8 category notification settings ordered by category.
///
/// Used by the NotificationService to determine what to schedule and
/// by the Notification Settings screen to display current configuration.
class GetNotificationSettingsUseCase
    implements UseCaseNoInput<List<NotificationCategorySettings>> {
  final NotificationCategorySettingsRepository _repository;

  GetNotificationSettingsUseCase(this._repository);

  @override
  Future<Result<List<NotificationCategorySettings>, AppError>> call() =>
      _repository.getAll();
}
