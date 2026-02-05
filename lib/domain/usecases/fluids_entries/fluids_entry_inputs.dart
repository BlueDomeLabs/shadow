// lib/domain/usecases/fluids_entries/fluids_entry_inputs.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 4.2

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'fluids_entry_inputs.freezed.dart';

/// Input for LogFluidsEntryUseCase (create).
@freezed
class LogFluidsEntryInput with _$LogFluidsEntryInput {
  const factory LogFluidsEntryInput({
    required String profileId,
    required String clientId,
    required int entryDate, // Epoch milliseconds
    // Water intake
    int? waterIntakeMl,
    String? waterIntakeNotes,

    // Bowel tracking
    BowelCondition? bowelCondition,
    MovementSize? bowelSize,
    String? bowelPhotoPath,

    // Urine tracking
    UrineCondition? urineCondition,
    MovementSize? urineSize,
    String? urinePhotoPath,

    // Menstruation
    MenstruationFlow? menstruationFlow,

    // BBT
    double? basalBodyTemperature,
    int? bbtRecordedTime, // Epoch milliseconds - REQUIRED when BBT provided
    // Custom "Other" fluid
    String? otherFluidName,
    String? otherFluidAmount,
    String? otherFluidNotes,

    // General notes
    @Default('') String notes,
  }) = _LogFluidsEntryInput;
}

/// Input for GetFluidsEntriesUseCase (by date range).
@freezed
class GetFluidsEntriesInput with _$GetFluidsEntriesInput {
  const factory GetFluidsEntriesInput({
    required String profileId,
    required int startDate, // Epoch milliseconds
    required int endDate, // Epoch milliseconds
  }) = _GetFluidsEntriesInput;
}

/// Input for GetTodayFluidsEntryUseCase.
@freezed
class GetTodayFluidsEntryInput with _$GetTodayFluidsEntryInput {
  const factory GetTodayFluidsEntryInput({required String profileId}) =
      _GetTodayFluidsEntryInput;
}

/// Input for GetBBTEntriesUseCase.
@freezed
class GetBBTEntriesInput with _$GetBBTEntriesInput {
  const factory GetBBTEntriesInput({
    required String profileId,
    required int startDate, // Epoch milliseconds
    required int endDate, // Epoch milliseconds
  }) = _GetBBTEntriesInput;
}

/// Input for GetMenstruationEntriesUseCase.
@freezed
class GetMenstruationEntriesInput with _$GetMenstruationEntriesInput {
  const factory GetMenstruationEntriesInput({
    required String profileId,
    required int startDate, // Epoch milliseconds
    required int endDate, // Epoch milliseconds
  }) = _GetMenstruationEntriesInput;
}

/// Input for UpdateFluidsEntryUseCase.
@freezed
class UpdateFluidsEntryInput with _$UpdateFluidsEntryInput {
  const factory UpdateFluidsEntryInput({
    required String id,
    required String profileId,

    // Water intake
    int? waterIntakeMl,
    String? waterIntakeNotes,

    // Bowel tracking
    BowelCondition? bowelCondition,
    MovementSize? bowelSize,
    String? bowelPhotoPath,

    // Urine tracking
    UrineCondition? urineCondition,
    MovementSize? urineSize,
    String? urinePhotoPath,

    // Menstruation
    MenstruationFlow? menstruationFlow,

    // BBT
    double? basalBodyTemperature,
    int? bbtRecordedTime,

    // Custom "Other" fluid
    String? otherFluidName,
    String? otherFluidAmount,
    String? otherFluidNotes,

    // General notes
    String? notes,
  }) = _UpdateFluidsEntryInput;
}

/// Input for DeleteFluidsEntryUseCase.
@freezed
class DeleteFluidsEntryInput with _$DeleteFluidsEntryInput {
  const factory DeleteFluidsEntryInput({
    required String id,
    required String profileId,
  }) = _DeleteFluidsEntryInput;
}
