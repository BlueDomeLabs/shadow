// lib/domain/entities/health_sync_settings.dart
// Phase 16 — User preferences for Health Platform sync
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'health_sync_settings.freezed.dart';
part 'health_sync_settings.g.dart';

/// User preferences for importing health data from Apple Health or Google Health Connect.
///
/// One record per profile. Stored locally — not synced to Google Drive.
/// Controls which data types are imported and how far back to look.
///
/// See 61_HEALTH_PLATFORM_INTEGRATION.md Settings Screen Addition section.
@freezed
class HealthSyncSettings with _$HealthSyncSettings {
  const HealthSyncSettings._();

  const factory HealthSyncSettings({
    /// Matches profileId — one settings record per profile.
    required String id,
    required String profileId,

    /// Data types the user has enabled for import (default: all enabled).
    @Default([]) List<HealthDataType> enabledDataTypes,

    /// How many days back to import on first sync (30, 60, or 90).
    @Default(30) int dateRangeDays,
  }) = _HealthSyncSettings;

  factory HealthSyncSettings.fromJson(Map<String, dynamic> json) =>
      _$HealthSyncSettingsFromJson(json);

  /// Default settings with all data types enabled for a profile.
  factory HealthSyncSettings.defaultsForProfile(String profileId) =>
      HealthSyncSettings(
        id: profileId,
        profileId: profileId,
        enabledDataTypes: HealthDataType.values.toList(),
      );
}
