// lib/presentation/providers/activity_logs/activity_log_list_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/activity_log.dart';
import 'package:shadow_app/domain/usecases/activity_logs/activity_logs_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'activity_log_list_provider.g.dart';

/// Provider for managing activity log list with profile scope.
@riverpod
class ActivityLogList extends _$ActivityLogList {
  static final _log = logger.scope('ActivityLogList');

  @override
  Future<List<ActivityLog>> build(String profileId) async {
    _log.debug('Loading activity logs for profile: $profileId');

    final useCase = ref.read(getActivityLogsUseCaseProvider);
    final result = await useCase(GetActivityLogsInput(profileId: profileId));

    return result.when(
      success: (logs) {
        _log.debug('Loaded ${logs.length} activity logs');
        return logs;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Logs a new activity.
  Future<void> log(LogActivityInput input) async {
    _log.debug('Logging activity');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(logActivityUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Activity logged successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Log failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Updates an existing activity log.
  Future<void> updateLog(UpdateActivityLogInput input) async {
    _log.debug('Updating activity log: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(updateActivityLogUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Activity log updated successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Update failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Deletes an activity log.
  Future<void> delete(DeleteActivityLogInput input) async {
    _log.debug('Deleting activity log: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(deleteActivityLogUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Activity log deleted successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Delete failed: ${error.message}');
        throw error;
      },
    );
  }
}
