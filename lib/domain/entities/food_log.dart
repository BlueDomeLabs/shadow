// lib/domain/entities/food_log.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.12

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

part 'food_log.freezed.dart';
part 'food_log.g.dart';

/// FoodLog entity for tracking food consumption.
///
/// Per 22_API_CONTRACTS.md Section 10.12.
/// Supports both predefined food items (by ID) and ad-hoc items.
@Freezed(toJson: true, fromJson: true)
class FoodLog with _$FoodLog {
  const FoodLog._();

  @JsonSerializable(explicitToJson: true)
  const factory FoodLog({
    required String id,
    required String clientId,
    required String profileId,
    required int timestamp, // Epoch milliseconds
    @Default([]) List<String> foodItemIds, // References to FoodItem entities
    @Default([]) List<String> adHocItems, // Free-form food names (quick entry)
    String? notes,
    required SyncMetadata syncMetadata,
  }) = _FoodLog;

  factory FoodLog.fromJson(Map<String, dynamic> json) =>
      _$FoodLogFromJson(json);

  /// Whether this log has any food items (predefined or ad-hoc).
  bool get hasItems => foodItemIds.isNotEmpty || adHocItems.isNotEmpty;

  /// Total number of items logged.
  int get totalItems => foodItemIds.length + adHocItems.length;
}
