// lib/domain/usecases/notifications/update_anchor_event_time_use_case.dart
// Per 57_NOTIFICATION_SYSTEM.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/anchor_event_time.dart';
import 'package:shadow_app/domain/repositories/anchor_event_time_repository.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/notifications/notification_inputs.dart';

/// Updates a single anchor event time (time of day or enabled state).
///
/// Called when the user adjusts an anchor event in Notification Settings.
/// After this, the caller should reschedule all notifications.
class UpdateAnchorEventTimeUseCase
    implements UseCase<UpdateAnchorEventTimeInput, AnchorEventTime> {
  final AnchorEventTimeRepository _repository;

  UpdateAnchorEventTimeUseCase(this._repository);

  @override
  Future<Result<AnchorEventTime, AppError>> call(
    UpdateAnchorEventTimeInput input,
  ) async {
    final getResult = await _repository.getById(input.id);
    if (getResult.isFailure) return getResult;

    final existing = getResult.valueOrNull!;
    final updated = existing.copyWith(
      timeOfDay: input.timeOfDay ?? existing.timeOfDay,
      isEnabled: input.isEnabled ?? existing.isEnabled,
    );

    return _repository.update(updated);
  }
}
