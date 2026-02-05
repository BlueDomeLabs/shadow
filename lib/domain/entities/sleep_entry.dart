// lib/domain/entities/sleep_entry.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.15

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'sleep_entry.freezed.dart';
part 'sleep_entry.g.dart';

/// A sleep tracking entry for a user.
///
/// Tracks bed time, wake time, sleep stages, dreams, and waking feeling.
/// All timestamps are epoch milliseconds.
@Freezed(toJson: true, fromJson: true)
class SleepEntry with _$SleepEntry {
  const SleepEntry._();

  @JsonSerializable(explicitToJson: true)
  const factory SleepEntry({
    required String id,
    required String clientId,
    required String profileId,
    required int bedTime, // Epoch milliseconds
    int? wakeTime, // Epoch milliseconds
    @Default(0) int deepSleepMinutes,
    @Default(0) int lightSleepMinutes,
    @Default(0) int restlessSleepMinutes,
    @Default(DreamType.noDreams) DreamType dreamType,
    @Default(WakingFeeling.neutral) WakingFeeling wakingFeeling,
    String? notes,
    // Import tracking (for wearable data)
    String? importSource,
    String? importExternalId,
    required SyncMetadata syncMetadata,
  }) = _SleepEntry;

  factory SleepEntry.fromJson(Map<String, dynamic> json) =>
      _$SleepEntryFromJson(json);

  // Computed properties
  int? get totalSleepMinutes {
    if (wakeTime == null) return null;
    return ((wakeTime! - bedTime) / 60000).round();
  }
}
