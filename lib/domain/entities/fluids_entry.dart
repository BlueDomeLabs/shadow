// lib/domain/entities/fluids_entry.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.11

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'fluids_entry.freezed.dart';
part 'fluids_entry.g.dart';

/// A fluids tracking entry for a user.
///
/// Tracks water intake, bowel movements, urine, menstruation, BBT,
/// and custom fluid types. All timestamps are epoch milliseconds.
@Freezed(toJson: true, fromJson: true)
class FluidsEntry with _$FluidsEntry implements Syncable {
  const FluidsEntry._();

  @JsonSerializable(explicitToJson: true)
  const factory FluidsEntry({
    required String id,
    required String clientId,
    required String profileId,
    required int entryDate, // Epoch milliseconds
    // Water Intake
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
    int? bbtRecordedTime, // Epoch milliseconds
    // Customizable "Other" Fluid
    String? otherFluidName,
    String? otherFluidAmount,
    String? otherFluidNotes,

    // Import tracking (for wearable data)
    String? importSource,
    String? importExternalId,

    // File sync metadata (for bowel/urine photos)
    String? cloudStorageUrl,
    String? fileHash,
    int? fileSizeBytes,
    @Default(false) bool isFileUploaded,

    // General notes
    @Default('') String notes,
    @Default([]) List<String> photoIds,
    required SyncMetadata syncMetadata,
  }) = _FluidsEntry;

  factory FluidsEntry.fromJson(Map<String, dynamic> json) =>
      _$FluidsEntryFromJson(json);

  // Computed properties
  bool get hasWaterData => waterIntakeMl != null;
  bool get hasBowelData => bowelCondition != null;
  bool get hasUrineData => urineCondition != null;
  bool get hasMenstruationData => menstruationFlow != null;
  bool get hasBBTData => basalBodyTemperature != null;
  bool get hasOtherFluidData => otherFluidName != null;

  /// Temperature in Celsius (converts if stored in Fahrenheit)
  double? get bbtCelsius => basalBodyTemperature != null
      ? (basalBodyTemperature! - 32) * 5 / 9
      : null;
}
