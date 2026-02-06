// lib/domain/usecases/activities/activity_inputs.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_inputs.freezed.dart';

/// Input for CreateActivityUseCase.
@freezed
class CreateActivityInput with _$CreateActivityInput {
  const factory CreateActivityInput({
    required String profileId,
    required String clientId,
    required String name,
    String? description,
    String? location,
    String? triggers, // Comma-separated trigger descriptions
    required int durationMinutes,
  }) = _CreateActivityInput;
}

/// Input for GetActivitiesUseCase.
@freezed
class GetActivitiesInput with _$GetActivitiesInput {
  const factory GetActivitiesInput({
    required String profileId,
    @Default(false) bool includeArchived,
    int? limit,
    int? offset,
  }) = _GetActivitiesInput;
}

/// Input for UpdateActivityUseCase.
@freezed
class UpdateActivityInput with _$UpdateActivityInput {
  const factory UpdateActivityInput({
    required String id,
    required String profileId,
    String? name,
    String? description,
    String? location,
    String? triggers,
    int? durationMinutes,
  }) = _UpdateActivityInput;
}

/// Input for ArchiveActivityUseCase.
@freezed
class ArchiveActivityInput with _$ArchiveActivityInput {
  const factory ArchiveActivityInput({
    required String id,
    required String profileId,
    @Default(true) bool archive, // false to unarchive
  }) = _ArchiveActivityInput;
}
