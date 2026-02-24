// lib/domain/entities/imported_vital.dart
// Phase 16 — Single measurement imported from Apple Health or Google Health Connect
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'imported_vital.freezed.dart';
part 'imported_vital.g.dart';

/// A single health measurement imported from Apple Health or Google Health Connect.
///
/// Imported vitals are read-only — Shadow never modifies them after writing.
/// Re-syncing adds new records but does not overwrite existing ones.
///
/// See 61_HEALTH_PLATFORM_INTEGRATION.md for the full import spec.
@freezed
class ImportedVital with _$ImportedVital implements Syncable {
  const ImportedVital._();

  const factory ImportedVital({
    required String id,
    required String clientId,
    required String profileId,

    /// Type of health measurement (heart_rate, weight, etc.).
    required HealthDataType dataType,

    /// Numeric value in canonical unit (see [HealthDataType.canonicalUnit]).
    required double value,

    /// Canonical unit string (bpm, kg, mmHg, hours, steps, kcal, %).
    required String unit,

    /// When the measurement was recorded by the source device (epoch ms UTC).
    required int recordedAt,

    /// Source platform (Apple Health or Google Health Connect).
    required HealthSourcePlatform sourcePlatform,

    /// Device name if available (e.g. "Apple Watch Series 9").
    String? sourceDevice,

    /// When Shadow imported this record (epoch ms UTC).
    required int importedAt,

    required SyncMetadata syncMetadata,
  }) = _ImportedVital;

  factory ImportedVital.fromJson(Map<String, dynamic> json) =>
      _$ImportedVitalFromJson(json);
}
