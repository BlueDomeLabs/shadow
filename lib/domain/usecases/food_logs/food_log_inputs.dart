// lib/domain/usecases/food_logs/food_log_inputs.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_log_inputs.freezed.dart';

@freezed
class LogFoodInput with _$LogFoodInput {
  const factory LogFoodInput({
    required String profileId,
    required String clientId,
    required int timestamp, // Epoch milliseconds
    @Default([]) List<String> foodItemIds,
    @Default([]) List<String> adHocItems,
    @Default('') String notes,
  }) = _LogFoodInput;
}

@freezed
class GetFoodLogsInput with _$GetFoodLogsInput {
  const factory GetFoodLogsInput({
    required String profileId,
    int? startDate, // Epoch milliseconds
    int? endDate, // Epoch milliseconds
    int? limit,
    int? offset,
  }) = _GetFoodLogsInput;
}

@freezed
class UpdateFoodLogInput with _$UpdateFoodLogInput {
  const factory UpdateFoodLogInput({
    required String id,
    required String profileId,
    List<String>? foodItemIds,
    List<String>? adHocItems,
    String? notes,
  }) = _UpdateFoodLogInput;
}

@freezed
class DeleteFoodLogInput with _$DeleteFoodLogInput {
  const factory DeleteFoodLogInput({
    required String id,
    required String profileId,
  }) = _DeleteFoodLogInput;
}
