// lib/domain/usecases/flare_ups/flare_up_inputs.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:freezed_annotation/freezed_annotation.dart';

part 'flare_up_inputs.freezed.dart';

@freezed
class LogFlareUpInput with _$LogFlareUpInput {
  const factory LogFlareUpInput({
    required String profileId,
    required String clientId,
    required String conditionId,
    required int startDate, // Epoch milliseconds
    int? endDate, // Null = ongoing
    required int severity, // 1-10
    String? notes,
    @Default([]) List<String> triggers,
    String? activityId,
    String? photoPath,
  }) = _LogFlareUpInput;
}

@freezed
class GetFlareUpsInput with _$GetFlareUpsInput {
  const factory GetFlareUpsInput({
    required String profileId,
    String? conditionId,
    int? startDate, // Epoch milliseconds
    int? endDate, // Epoch milliseconds
    bool? ongoingOnly,
    int? limit,
    int? offset,
  }) = _GetFlareUpsInput;
}

@freezed
class UpdateFlareUpInput with _$UpdateFlareUpInput {
  const factory UpdateFlareUpInput({
    required String id,
    required String profileId,
    int? severity,
    String? notes,
    List<String>? triggers,
    String? photoPath,
  }) = _UpdateFlareUpInput;
}

@freezed
class EndFlareUpInput with _$EndFlareUpInput {
  const factory EndFlareUpInput({
    required String id,
    required String profileId,
    required int endDate, // Epoch milliseconds
  }) = _EndFlareUpInput;
}

@freezed
class DeleteFlareUpInput with _$DeleteFlareUpInput {
  const factory DeleteFlareUpInput({
    required String id,
    required String profileId,
  }) = _DeleteFlareUpInput;
}
