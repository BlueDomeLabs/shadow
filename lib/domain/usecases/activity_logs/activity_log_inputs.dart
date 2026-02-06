// lib/domain/usecases/activity_logs/activity_log_inputs.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_log_inputs.freezed.dart';

/// Input for LogActivityUseCase (create).
@freezed
class LogActivityInput with _$LogActivityInput {
  const factory LogActivityInput({
    required String profileId,
    required String clientId,
    required int timestamp, // Epoch milliseconds
    @Default([]) List<String> activityIds,
    @Default([]) List<String> adHocActivities,
    int? duration, // Actual duration if different from planned
    @Default('') String notes,
    String? importSource,
    String? importExternalId,
  }) = _LogActivityInput;
}

/// Input for GetActivityLogsUseCase.
@freezed
class GetActivityLogsInput with _$GetActivityLogsInput {
  const factory GetActivityLogsInput({
    required String profileId,
    int? startDate, // Epoch milliseconds
    int? endDate, // Epoch milliseconds
    int? limit,
    int? offset,
  }) = _GetActivityLogsInput;
}

/// Input for UpdateActivityLogUseCase.
@freezed
class UpdateActivityLogInput with _$UpdateActivityLogInput {
  const factory UpdateActivityLogInput({
    required String id,
    required String profileId,
    List<String>? activityIds,
    List<String>? adHocActivities,
    int? duration,
    String? notes,
  }) = _UpdateActivityLogInput;
}

/// Input for DeleteActivityLogUseCase.
@freezed
class DeleteActivityLogInput with _$DeleteActivityLogInput {
  const factory DeleteActivityLogInput({
    required String id,
    required String profileId,
  }) = _DeleteActivityLogInput;
}
