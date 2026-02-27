// lib/domain/usecases/conditions/condition_inputs.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.8

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'condition_inputs.freezed.dart';

/// Input for GetConditionsUseCase.
@freezed
class GetConditionsInput with _$GetConditionsInput {
  const factory GetConditionsInput({
    required String profileId,
    ConditionStatus? status,
    @Default(false) bool includeArchived,
  }) = _GetConditionsInput;
}

/// Input for CreateConditionUseCase.
@freezed
class CreateConditionInput with _$CreateConditionInput {
  const factory CreateConditionInput({
    required String profileId,
    required String clientId,
    required String name,
    required String category,
    @Default([]) List<String> bodyLocations,
    @Default([]) List<String> triggers,
    String? description,
    String? baselinePhotoPath,
    required int startTimeframe, // Epoch ms
    int? endDate, // Epoch ms
    String? activityId,
  }) = _CreateConditionInput;
}

/// Input for ArchiveConditionUseCase.
@freezed
class ArchiveConditionInput with _$ArchiveConditionInput {
  const factory ArchiveConditionInput({
    required String id,
    required String profileId,
    required bool archive, // true = archive, false = unarchive
  }) = _ArchiveConditionInput;
}

/// Input for UpdateConditionUseCase.
@freezed
class UpdateConditionInput with _$UpdateConditionInput {
  const factory UpdateConditionInput({
    required String id,
    required String profileId,
    String? name,
    String? category,
    List<String>? bodyLocations,
    String? description,
    String? baselinePhotoPath,
    int? startTimeframe, // Epoch ms
    int? endDate, // Epoch ms
    ConditionStatus? status,
  }) = _UpdateConditionInput;
}
