// lib/domain/usecases/health/health_types.dart
// Phase 16 — Shared input/result types for health use cases
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

// =============================================================================
// SYNC FROM HEALTH PLATFORM
// =============================================================================

@freezed
class SyncFromHealthPlatformInput with _$SyncFromHealthPlatformInput {
  const factory SyncFromHealthPlatformInput({required String profileId}) =
      _SyncFromHealthPlatformInput;
}

/// Summary result from a health platform sync operation.
///
/// A successful return does NOT mean all data types were imported — check
/// [deniedTypes] and [platformUnavailable] to understand partial failures.
@freezed
class SyncFromHealthPlatformResult with _$SyncFromHealthPlatformResult {
  const factory SyncFromHealthPlatformResult({
    /// Number of records imported per data type.
    /// Only contains entries for data types that were successfully read.
    @Default({}) Map<HealthDataType, int> importedCountByType,

    /// Data types the user denied permission for.
    /// Denied types are skipped — the sync continues for granted types.
    @Default([]) List<HealthDataType> deniedTypes,

    /// True if the health platform is not available on this device.
    /// On Android: Health Connect is not installed.
    /// On iOS: always false (HealthKit is always available).
    @Default(false) bool platformUnavailable,
  }) = _SyncFromHealthPlatformResult;

  const SyncFromHealthPlatformResult._();

  /// Total number of records imported across all data types.
  int get totalImported =>
      importedCountByType.values.fold(0, (sum, count) => sum + count);
}
