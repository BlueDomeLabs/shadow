// lib/domain/usecases/intake_logs/intake_log_inputs.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.10

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'intake_log_inputs.freezed.dart';

/// Input for GetIntakeLogsUseCase.
@freezed
class GetIntakeLogsInput with _$GetIntakeLogsInput {
  const factory GetIntakeLogsInput({
    required String profileId,
    IntakeLogStatus? status,
    int? startDate, // Epoch ms
    int? endDate, // Epoch ms
    int? limit,
    int? offset,
  }) = _GetIntakeLogsInput;
}

/// Input for MarkTakenUseCase.
@freezed
class MarkTakenInput with _$MarkTakenInput {
  const factory MarkTakenInput({
    required String id,
    required String profileId,
    required int actualTime, // Epoch ms
  }) = _MarkTakenInput;
}

/// Input for MarkSkippedUseCase.
@freezed
class MarkSkippedInput with _$MarkSkippedInput {
  const factory MarkSkippedInput({
    required String id,
    required String profileId,
    String? reason,
  }) = _MarkSkippedInput;
}
