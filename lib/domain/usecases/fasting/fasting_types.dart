// lib/domain/usecases/fasting/fasting_types.dart
// Phase 15b-2 — Shared input/output types for fasting use cases
// Per 59_DIET_TRACKING.md

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'fasting_types.freezed.dart';

// =============================================================================
// START FAST
// =============================================================================

@freezed
class StartFastInput with _$StartFastInput {
  const factory StartFastInput({
    required String profileId,
    required String clientId,
    required DietPresetType protocol, // e.g. DietPresetType.if168
    required int startedAt, // Epoch ms — when fast begins
    required double targetHours, // e.g. 16.0 for 16:8
  }) = _StartFastInput;
}

// =============================================================================
// END FAST
// =============================================================================

@freezed
class EndFastInput with _$EndFastInput {
  const factory EndFastInput({
    required String profileId,
    required String sessionId, // ID of the active fasting session
    required int endedAt, // Epoch ms
    @Default(false) bool isManualEnd, // true if user tapped "Stop"
  }) = _EndFastInput;
}

// =============================================================================
// GET ACTIVE FAST
// =============================================================================

@freezed
class GetActiveFastInput with _$GetActiveFastInput {
  const factory GetActiveFastInput({required String profileId}) =
      _GetActiveFastInput;
}

// =============================================================================
// GET FASTING HISTORY
// =============================================================================

@freezed
class GetFastingHistoryInput with _$GetFastingHistoryInput {
  const factory GetFastingHistoryInput({
    required String profileId,
    int? limit,
  }) = _GetFastingHistoryInput;
}
