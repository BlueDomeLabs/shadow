// lib/presentation/providers/flare_ups/flare_up_list_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/domain/usecases/flare_ups/flare_ups_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'flare_up_list_provider.g.dart';

/// Provider for managing flare up list with profile scope.
@riverpod
class FlareUpList extends _$FlareUpList {
  static final _log = logger.scope('FlareUpList');

  @override
  Future<List<FlareUp>> build(String profileId) async {
    _log.debug('Loading flare ups for profile: $profileId');

    final useCase = ref.read(getFlareUpsUseCaseProvider);
    final result = await useCase(GetFlareUpsInput(profileId: profileId));

    return result.when(
      success: (flareUps) {
        _log.debug('Loaded ${flareUps.length} flare ups');
        return flareUps;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Logs a new flare up.
  Future<void> log(LogFlareUpInput input) async {
    _log.debug('Logging flare up for condition: ${input.conditionId}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(logFlareUpUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Flare up logged successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Log failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Updates an existing flare up.
  Future<void> updateFlareUp(UpdateFlareUpInput input) async {
    _log.debug('Updating flare up: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(updateFlareUpUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Flare up updated successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Update failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Ends a flare up.
  Future<void> end(EndFlareUpInput input) async {
    _log.debug('Ending flare up: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(endFlareUpUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Flare up ended successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('End failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Deletes a flare up.
  Future<void> delete(DeleteFlareUpInput input) async {
    _log.debug('Deleting flare up: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(deleteFlareUpUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Flare up deleted successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Delete failed: ${error.message}');
        throw error;
      },
    );
  }
}
