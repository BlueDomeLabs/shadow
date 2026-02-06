// lib/presentation/providers/activities/activity_list_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/usecases/activities/activities_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'activity_list_provider.g.dart';

/// Provider for managing activity list with profile scope.
@riverpod
class ActivityList extends _$ActivityList {
  static final _log = logger.scope('ActivityList');

  @override
  Future<List<Activity>> build(String profileId) async {
    _log.debug('Loading activities for profile: $profileId');

    final useCase = ref.read(getActivitiesUseCaseProvider);
    final result = await useCase(GetActivitiesInput(profileId: profileId));

    return result.when(
      success: (activities) {
        _log.debug('Loaded ${activities.length} activities');
        return activities;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Creates a new activity.
  Future<void> create(CreateActivityInput input) async {
    _log.debug('Creating activity: ${input.name}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(createActivityUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Activity created successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Create failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Updates an existing activity.
  Future<void> updateActivity(UpdateActivityInput input) async {
    _log.debug('Updating activity: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(updateActivityUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Activity updated successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Update failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Archives or unarchives an activity.
  Future<void> archive(ArchiveActivityInput input) async {
    _log.debug(
      '${input.archive ? "Archiving" : "Unarchiving"} activity: ${input.id}',
    );

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(archiveActivityUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info(
          'Activity ${input.archive ? "archived" : "unarchived"} successfully',
        );
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Archive failed: ${error.message}');
        throw error;
      },
    );
  }
}
