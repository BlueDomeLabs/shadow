// lib/domain/entities/diet_exception.dart
// Phase 15b — Exception to a diet rule
// Per 59_DIET_TRACKING.md

import 'package:freezed_annotation/freezed_annotation.dart';

part 'diet_exception.freezed.dart';

/// An exception to a DietRule.
///
/// Per 59_DIET_TRACKING.md — any rule can have exceptions
/// (e.g. "No dairy — EXCEPT hard aged cheeses").
/// Exceptions are respected during real-time compliance validation.
@freezed
class DietException with _$DietException {
  const factory DietException({
    required String id,
    required String ruleId,
    required String description, // Free text (e.g. "Hard aged cheeses")
    @Default(0) int sortOrder,
  }) = _DietException;
}
