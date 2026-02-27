// lib/presentation/providers/notifications/anchor_event_times_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/anchor_event_time.dart';
import 'package:shadow_app/domain/usecases/notifications/notification_inputs.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'anchor_event_times_provider.g.dart';

/// Provider for the 8 anchor event times (global — not profile-scoped).
///
/// Anchor events (Wake, Breakfast, Morning, Lunch, Afternoon, Dinner,
/// Evening, Bedtime) are shared across
/// all profiles. Follows the UseCase delegation pattern:
/// - ALWAYS delegates to UseCases (never calls repository directly)
/// - Calls ref.invalidateSelf() after successful mutations
@riverpod
class AnchorEventTimes extends _$AnchorEventTimes {
  static final _log = logger.scope('AnchorEventTimes');

  @override
  Future<List<AnchorEventTime>> build() async {
    _log.debug('Loading anchor event times');

    final useCase = ref.read(getAnchorEventTimesUseCaseProvider);
    final result = await useCase();

    return result.when(
      success: (times) {
        _log.debug('Loaded ${times.length} anchor event times');
        return times;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Updates a single anchor event's time or enabled state.
  Future<void> updateAnchorEvent(UpdateAnchorEventTimeInput input) async {
    _log.debug('Updating anchor event: ${input.id}');

    final useCase = ref.read(updateAnchorEventTimeUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Anchor event updated');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Update failed: ${error.message}');
        throw error;
      },
    );
  }
}
