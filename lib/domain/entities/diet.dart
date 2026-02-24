// lib/domain/entities/diet.dart
// Phase 15b — Diet configuration entity
// Per 59_DIET_TRACKING.md

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'diet.freezed.dart';
part 'diet.g.dart';

/// A diet configuration (preset or custom) for a profile.
///
/// Per 59_DIET_TRACKING.md — supports preset diets (keto, paleo, etc.)
/// and fully custom diets with macro targets and food rules.
@Freezed(toJson: true, fromJson: true)
class Diet with _$Diet implements Syncable {
  const Diet._();

  @JsonSerializable(explicitToJson: true)
  const factory Diet({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    @Default('') String description,
    DietPresetType? presetType, // null = fully custom diet
    @Default(false) bool isActive,
    required int startDate, // Epoch ms
    int? endDate, // Epoch ms, null = no end
    @Default(false) bool isDraft,
    required SyncMetadata syncMetadata,
  }) = _Diet;

  factory Diet.fromJson(Map<String, dynamic> json) => _$DietFromJson(json);

  /// Whether this is a preset diet (not fully custom).
  bool get isPreset =>
      presetType != null && presetType != DietPresetType.custom;
}
