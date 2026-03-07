// lib/domain/entities/bodily_output_log.dart
// Per FLUIDS_RESTRUCTURING_SPEC.md Section 1.4

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/bodily_output_enums.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/settings_enums.dart';

part 'bodily_output_log.freezed.dart';
part 'bodily_output_log.g.dart';

/// A single bodily output event (urine, bowel, gas, menstruation, BBT, custom).
///
/// One row per event — not a daily aggregate.
/// All timestamps are epoch milliseconds.
@Freezed(toJson: true, fromJson: true)
class BodilyOutputLog with _$BodilyOutputLog implements Syncable {
  const BodilyOutputLog._();

  @JsonSerializable(explicitToJson: true)
  const factory BodilyOutputLog({
    required String id,
    required String clientId,
    required String profileId,
    required int occurredAt, // Epoch ms when event occurred
    required BodyOutputType outputType,

    // Custom type (outputType = custom only)
    String? customTypeLabel,

    // Urine fields (outputType = urine)
    UrineCondition? urineCondition,
    String? urineCustomCondition,
    OutputSize? urineSize,

    // Bowel fields (outputType = bowel)
    BowelCondition? bowelCondition,
    String? bowelCustomCondition,
    OutputSize? bowelSize,

    // Gas fields (outputType = gas)
    // gasSeverity is required for gas — enforced in use case, not entity.
    // Default for migrated rows: moderate(1).
    GasSeverity? gasSeverity,

    // Menstruation fields (outputType = menstruation)
    MenstruationFlow? menstruationFlow,

    // BBT fields (outputType = bbt)
    double? temperatureValue,
    TemperatureUnit? temperatureUnit,

    // Shared optional fields
    String? notes,
    String? photoPath,

    // Photo sync
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    @Default(false) bool isFileUploaded,

    // Import tracking
    String? importSource,
    String? importExternalId,

    required SyncMetadata syncMetadata,
  }) = _BodilyOutputLog;

  factory BodilyOutputLog.fromJson(Map<String, dynamic> json) =>
      _$BodilyOutputLogFromJson(json);
}
