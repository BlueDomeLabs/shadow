// lib/domain/usecases/condition_logs/condition_log_inputs.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.9

import 'package:freezed_annotation/freezed_annotation.dart';

part 'condition_log_inputs.freezed.dart';

/// Input for GetConditionLogsUseCase.
@freezed
class GetConditionLogsInput with _$GetConditionLogsInput {
  const factory GetConditionLogsInput({
    required String profileId,
    required String conditionId,
    int? startDate, // Epoch ms
    int? endDate, // Epoch ms
    int? limit,
    int? offset,
  }) = _GetConditionLogsInput;
}

/// Input for LogConditionUseCase (creating a new condition log).
@freezed
class LogConditionInput with _$LogConditionInput {
  const factory LogConditionInput({
    required String profileId,
    required String clientId,
    required String conditionId,
    required int timestamp, // Epoch ms
    required int severity, // 1-10 scale
    String? notes,
    @Default(false) bool isFlare,
    @Default([]) List<String> flarePhotoIds,
    String? photoPath,
    String? activityId,
    String? triggers, // Comma-separated
  }) = _LogConditionInput;
}

/// Input for UpdateConditionLogUseCase (editing an existing condition log).
@freezed
class UpdateConditionLogInput with _$UpdateConditionLogInput {
  const factory UpdateConditionLogInput({
    required String id,
    required String profileId,
    int? timestamp, // Epoch ms
    int? severity, // 1-10 scale
    String? notes,
    bool? isFlare,
    String? triggers, // Comma-separated
    String? photoPath,
  }) = _UpdateConditionLogInput;
}
