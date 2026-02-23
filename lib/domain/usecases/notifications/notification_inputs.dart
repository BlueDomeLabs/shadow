// lib/domain/usecases/notifications/notification_inputs.dart
// Input types for notification use cases per 57_NOTIFICATION_SYSTEM.md

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';

part 'notification_inputs.freezed.dart';

/// Input for UpdateAnchorEventTimeUseCase.
@freezed
class UpdateAnchorEventTimeInput with _$UpdateAnchorEventTimeInput {
  const factory UpdateAnchorEventTimeInput({
    required String id,
    // New time in "HH:mm" 24-hour format, e.g. "08:30"
    String? timeOfDay,
    bool? isEnabled,
  }) = _UpdateAnchorEventTimeInput;
}

/// Input for UpdateNotificationCategorySettingsUseCase.
@freezed
class UpdateNotificationCategorySettingsInput
    with _$UpdateNotificationCategorySettingsInput {
  const factory UpdateNotificationCategorySettingsInput({
    required String id,
    bool? isEnabled,
    NotificationSchedulingMode? schedulingMode,
    List<int>? anchorEventValues,
    int? intervalHours,
    String? intervalStartTime,
    String? intervalEndTime,
    List<String>? specificTimes,
    int? expiresAfterMinutes,
  }) = _UpdateNotificationCategorySettingsInput;
}
