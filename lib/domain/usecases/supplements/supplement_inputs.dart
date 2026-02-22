// lib/domain/usecases/supplements/supplement_inputs.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 4.2

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'supplement_inputs.freezed.dart';

/// Input for GetSupplementsUseCase.
@freezed
class GetSupplementsInput with _$GetSupplementsInput {
  const factory GetSupplementsInput({
    required String profileId,
    bool? activeOnly,
    int? limit,
    int? offset,
  }) = _GetSupplementsInput;
}

/// Input for CreateSupplementUseCase.
@freezed
class CreateSupplementInput with _$CreateSupplementInput {
  const factory CreateSupplementInput({
    required String profileId,
    required String clientId,
    required String name,
    required SupplementForm form,
    String? customForm,
    required int dosageQuantity,
    required DosageUnit dosageUnit,
    String? customDosageUnit,
    @Default('') String brand,
    @Default('') String notes,
    @Default([]) List<SupplementIngredient> ingredients,
    @Default([]) List<SupplementSchedule> schedules,
    int? startDate,
    int? endDate,
  }) = _CreateSupplementInput;
}

/// Input for UpdateSupplementUseCase.
@freezed
class UpdateSupplementInput with _$UpdateSupplementInput {
  const factory UpdateSupplementInput({
    required String id,
    required String profileId,
    String? name,
    SupplementForm? form,
    String? customForm,
    int? dosageQuantity,
    DosageUnit? dosageUnit,
    String? customDosageUnit,
    String? brand,
    String? notes,
    List<SupplementIngredient>? ingredients,
    List<SupplementSchedule>? schedules,
    int? startDate,
    int? endDate,
    bool? isArchived,
  }) = _UpdateSupplementInput;
}

/// Input for ArchiveSupplementUseCase.
@freezed
class ArchiveSupplementInput with _$ArchiveSupplementInput {
  const factory ArchiveSupplementInput({
    required String id,
    required String profileId,
    required bool archive, // true = archive, false = unarchive
  }) = _ArchiveSupplementInput;
}

/// Input for DeleteSupplementUseCase.
@freezed
class DeleteSupplementInput with _$DeleteSupplementInput {
  const factory DeleteSupplementInput({
    required String id,
    required String profileId,
  }) = _DeleteSupplementInput;
}
