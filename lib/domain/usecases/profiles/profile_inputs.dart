// lib/domain/usecases/profiles/profile_inputs.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 4.2

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'profile_inputs.freezed.dart';

/// Input for CreateProfileUseCase.
@freezed
class CreateProfileInput with _$CreateProfileInput {
  const factory CreateProfileInput({
    required String clientId,
    required String ownerId,
    required String name,
    BiologicalSex? biologicalSex,
    int? birthDate, // Epoch milliseconds
    @Default(ProfileDietType.none) ProfileDietType dietType,
    String? dietDescription,
    String? ethnicity,
    String? notes,
  }) = _CreateProfileInput;
}

/// Input for UpdateProfileInput.
@freezed
class UpdateProfileInput with _$UpdateProfileInput {
  const factory UpdateProfileInput({
    required String profileId,
    String? name,
    BiologicalSex? biologicalSex,
    int? birthDate, // Epoch milliseconds
    ProfileDietType? dietType,
    String? dietDescription,
    String? ethnicity,
    String? notes,
  }) = _UpdateProfileInput;
}

/// Input for DeleteProfileUseCase.
@freezed
class DeleteProfileInput with _$DeleteProfileInput {
  const factory DeleteProfileInput({required String profileId}) =
      _DeleteProfileInput;
}
