// lib/domain/usecases/health/health_types.dart
// Phase 16 — Shared input types for health use cases
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'health_types.freezed.dart';

// =============================================================================
// GET IMPORTED VITALS
// =============================================================================

@freezed
class GetImportedVitalsInput with _$GetImportedVitalsInput {
  const factory GetImportedVitalsInput({
    required String profileId,
    int? startEpoch, // Epoch ms; null = no lower bound
    int? endEpoch, // Epoch ms; null = no upper bound
    HealthDataType? dataType, // null = all types
  }) = _GetImportedVitalsInput;
}

// =============================================================================
// GET LAST SYNC STATUS
// =============================================================================

@freezed
class GetLastSyncStatusInput with _$GetLastSyncStatusInput {
  const factory GetLastSyncStatusInput({required String profileId}) =
      _GetLastSyncStatusInput;
}

// =============================================================================
// UPDATE HEALTH SYNC SETTINGS
// =============================================================================

@freezed
class UpdateHealthSyncSettingsInput with _$UpdateHealthSyncSettingsInput {
  const factory UpdateHealthSyncSettingsInput({
    required String profileId,
    List<HealthDataType>? enabledDataTypes, // null = no change
    int? dateRangeDays, // null = no change
  }) = _UpdateHealthSyncSettingsInput;
}
