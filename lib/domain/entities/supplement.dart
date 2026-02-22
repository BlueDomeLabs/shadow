// lib/domain/entities/supplement.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 5

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'supplement.freezed.dart';
part 'supplement.g.dart';

/// A supplement tracked by a user.
///
/// Contains dosage information, scheduling, and sync metadata.
/// Supplements can have multiple schedules for complex dosing regimens.
@Freezed(toJson: true, fromJson: true)
class Supplement with _$Supplement implements Syncable {
  const Supplement._();

  @JsonSerializable(explicitToJson: true)
  const factory Supplement({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    required SupplementForm form,
    String? customForm,
    required int dosageQuantity,
    required DosageUnit dosageUnit,
    String? customDosageUnit,
    @Default('') String brand,
    @Default('') String notes,
    @Default([]) List<SupplementIngredient> ingredients,
    @Default([]) List<SupplementSchedule> schedules,
    int? startDate,
    int? endDate,
    @Default(false) bool isArchived,
    required SyncMetadata syncMetadata,
  }) = _Supplement;

  factory Supplement.fromJson(Map<String, dynamic> json) =>
      _$SupplementFromJson(json);

  bool get hasSchedules => schedules.isNotEmpty;

  bool get isActive => !isArchived && syncMetadata.syncDeletedAt == null;

  bool get isWithinDateRange {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (startDate != null && now < startDate!) return false;
    if (endDate != null && now > endDate!) return false;
    return true;
  }

  String get displayDosage => '$dosageQuantity ${dosageUnit.abbreviation}';
}

/// Ingredient in a supplement (e.g., Vitamin D3, Magnesium Citrate).
@freezed
class SupplementIngredient with _$SupplementIngredient {
  const SupplementIngredient._();

  const factory SupplementIngredient({
    required String name,
    double? quantity,
    DosageUnit? unit,
    String? notes,
  }) = _SupplementIngredient;

  factory SupplementIngredient.fromJson(Map<String, dynamic> json) =>
      _$SupplementIngredientFromJson(json);
}

/// Schedule for when a supplement should be taken.
///
/// DATABASE MAPPING:
/// The database table `supplements` stores timing fields directly for the PRIMARY
/// schedule. Multiple schedules per supplement are stored as a JSON array in the
/// `schedules` column (see 10_DATABASE_SCHEMA.md for details).
@freezed
class SupplementSchedule with _$SupplementSchedule {
  const SupplementSchedule._();

  const factory SupplementSchedule({
    required SupplementAnchorEvent anchorEvent,
    required SupplementTimingType timingType,
    @Default(0) int offsetMinutes,
    int? specificTimeMinutes,
    required SupplementFrequencyType frequencyType,
    @Default(1) int everyXDays,
    @Default([0, 1, 2, 3, 4, 5, 6]) List<int> weekdays,
  }) = _SupplementSchedule;

  factory SupplementSchedule.fromJson(Map<String, dynamic> json) =>
      _$SupplementScheduleFromJson(json);
}
