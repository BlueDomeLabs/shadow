// lib/domain/usecases/notifications/get_anchor_event_times_use_case.dart
// Per 57_NOTIFICATION_SYSTEM.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/anchor_event_time.dart';
import 'package:shadow_app/domain/repositories/anchor_event_time_repository.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';

/// Returns all 5 anchor event times ordered by event name (Wake → Bedtime).
///
/// Used by the Notification Settings screen to display and edit anchor times.
class GetAnchorEventTimesUseCase
    implements UseCaseNoInput<List<AnchorEventTime>> {
  final AnchorEventTimeRepository _repository;

  GetAnchorEventTimesUseCase(this._repository);

  @override
  Future<Result<List<AnchorEventTime>, AppError>> call() =>
      _repository.getAll();
}
