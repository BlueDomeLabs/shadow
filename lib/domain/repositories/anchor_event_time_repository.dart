// lib/domain/repositories/anchor_event_time_repository.dart
// Per 57_NOTIFICATION_SYSTEM.md — AnchorEventTime repository interface

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/anchor_event_time.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';

/// Repository contract for AnchorEventTime entities.
///
/// The 5 anchor events (Wake, Breakfast, Lunch, Dinner, Bedtime) are
/// pre-seeded at first run with spec defaults. This repository allows
/// the settings screen to read and update their times and enabled states.
abstract class AnchorEventTimeRepository {
  /// Get all 5 anchor event times, ordered by event name.
  Future<Result<List<AnchorEventTime>, AppError>> getAll();

  /// Get a single anchor event time by its enum name.
  Future<Result<AnchorEventTime?, AppError>> getByName(AnchorEventName name);

  /// Get a single anchor event time by ID.
  Future<Result<AnchorEventTime, AppError>> getById(String id);

  /// Create a new anchor event time (used during seeding only).
  Future<Result<AnchorEventTime, AppError>> create(AnchorEventTime event);

  /// Update an existing anchor event time (time or enabled state).
  Future<Result<AnchorEventTime, AppError>> update(AnchorEventTime event);
}
