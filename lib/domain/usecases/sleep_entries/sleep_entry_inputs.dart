// lib/domain/usecases/sleep_entries/sleep_entry_inputs.dart
// Following 22_API_CONTRACTS.md Section 4.5 CRUD Use Case Templates

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'sleep_entry_inputs.freezed.dart';

/// Input for LogSleepEntryUseCase (create).
@freezed
class LogSleepEntryInput with _$LogSleepEntryInput {
  const factory LogSleepEntryInput({
    required String profileId,
    required String clientId,
    required int bedTime, // Epoch milliseconds
    // Wake time is optional (user may log bed time first, wake time later)
    int? wakeTime, // Epoch milliseconds
    // Sleep stages (optional, may come from wearable import)
    @Default(0) int deepSleepMinutes,
    @Default(0) int lightSleepMinutes,
    @Default(0) int restlessSleepMinutes,

    // Dream and feeling
    @Default(DreamType.noDreams) DreamType dreamType,
    @Default(WakingFeeling.neutral) WakingFeeling wakingFeeling,

    // Notes
    @Default('') String notes,

    // Sleep quality fields
    String? timeToFallAsleep,
    int? timesAwakened,
    String? timeAwakeDuringNight,

    // Import tracking (for wearable data)
    String? importSource, // 'healthkit', 'googlefit', 'apple_watch', etc.
    String? importExternalId, // External record ID for deduplication
  }) = _LogSleepEntryInput;
}

/// Input for GetSleepEntriesUseCase (by date range).
@freezed
class GetSleepEntriesInput with _$GetSleepEntriesInput {
  const factory GetSleepEntriesInput({
    required String profileId,
    int? startDate, // Epoch milliseconds
    int? endDate, // Epoch milliseconds
    int? limit,
    int? offset,
  }) = _GetSleepEntriesInput;
}

/// Input for GetSleepEntryForNightUseCase.
@freezed
class GetSleepEntryForNightInput with _$GetSleepEntryForNightInput {
  const factory GetSleepEntryForNightInput({
    required String profileId,
    required int date, // Epoch milliseconds (start of day)
  }) = _GetSleepEntryForNightInput;
}

/// Input for GetSleepAveragesUseCase.
@freezed
class GetSleepAveragesInput with _$GetSleepAveragesInput {
  const factory GetSleepAveragesInput({
    required String profileId,
    required int startDate, // Epoch milliseconds
    required int endDate, // Epoch milliseconds
  }) = _GetSleepAveragesInput;
}

/// Input for UpdateSleepEntryUseCase.
@freezed
class UpdateSleepEntryInput with _$UpdateSleepEntryInput {
  const factory UpdateSleepEntryInput({
    required String id,
    required String profileId,

    // All fields optional for partial update
    int? bedTime, // Epoch milliseconds
    int? wakeTime, // Epoch milliseconds
    int? deepSleepMinutes,
    int? lightSleepMinutes,
    int? restlessSleepMinutes,
    DreamType? dreamType,
    WakingFeeling? wakingFeeling,
    String? notes,
    String? timeToFallAsleep,
    int? timesAwakened,
    String? timeAwakeDuringNight,
    String? importSource,
    String? importExternalId,
  }) = _UpdateSleepEntryInput;
}

/// Input for DeleteSleepEntryUseCase.
@freezed
class DeleteSleepEntryInput with _$DeleteSleepEntryInput {
  const factory DeleteSleepEntryInput({
    required String id,
    required String profileId,
  }) = _DeleteSleepEntryInput;
}
