// lib/presentation/providers/health/health_sync_provider.dart
// Phase 16c — Riverpod providers for health sync settings screen
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/domain/entities/health_sync_settings.dart';
import 'package:shadow_app/domain/entities/health_sync_status.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/health/health_types.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'health_sync_provider.g.dart';

// =============================================================================
// HEALTH SYNC SETTINGS NOTIFIER
// Loads + updates health sync preferences for a profile.
// =============================================================================

@riverpod
class HealthSyncSettingsNotifier extends _$HealthSyncSettingsNotifier {
  @override
  Future<HealthSyncSettings> build(String profileId) async {
    final repo = ref.read(healthSyncSettingsRepositoryProvider);
    final result = await repo.getByProfile(profileId);
    return result.when(
      success: (settings) =>
          settings ?? HealthSyncSettings.defaultsForProfile(profileId),
      failure: (error) => throw error,
    );
  }

  /// Toggles a single data type on or off and persists via the use case.
  Future<void> toggleDataType(
    HealthDataType dataType, {
    required bool enabled,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = List<HealthDataType>.from(current.enabledDataTypes);
    if (enabled) {
      if (!updated.contains(dataType)) updated.add(dataType);
    } else {
      updated.remove(dataType);
    }
    await _save(enabledDataTypes: updated);
  }

  /// Updates the date range (30, 60, or 90 days) and persists.
  Future<void> setDateRange(int days) async {
    await _save(dateRangeDays: days);
  }

  Future<void> _save({
    List<HealthDataType>? enabledDataTypes,
    int? dateRangeDays,
  }) async {
    final useCase = ref.read(updateHealthSyncSettingsUseCaseProvider);
    final result = await useCase(
      UpdateHealthSyncSettingsInput(
        profileId: state.valueOrNull?.profileId ?? '',
        enabledDataTypes: enabledDataTypes,
        dateRangeDays: dateRangeDays,
      ),
    );
    result.when(
      success: (updated) => state = AsyncData(updated),
      failure: (error) => throw error,
    );
  }
}

// =============================================================================
// HEALTH SYNC STATUS LIST
// Last-sync timestamp and record counts per data type.
// =============================================================================

@riverpod
class HealthSyncStatusList extends _$HealthSyncStatusList {
  @override
  Future<List<HealthSyncStatus>> build(String profileId) async {
    final useCase = ref.read(getLastSyncStatusUseCaseProvider);
    final result = await useCase(GetLastSyncStatusInput(profileId: profileId));
    return result.when(
      success: (statuses) => statuses,
      failure: (error) => throw error,
    );
  }
}
