// lib/presentation/providers/food_logs/food_log_list_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/food_log.dart';
import 'package:shadow_app/domain/usecases/food_logs/food_logs_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'food_log_list_provider.g.dart';

/// Provider for managing food log list with profile scope.
@riverpod
class FoodLogList extends _$FoodLogList {
  static final _log = logger.scope('FoodLogList');

  @override
  Future<List<FoodLog>> build(String profileId) async {
    _log.debug('Loading food logs for profile: $profileId');

    final useCase = ref.read(getFoodLogsUseCaseProvider);
    final result = await useCase(GetFoodLogsInput(profileId: profileId));

    return result.when(
      success: (logs) {
        _log.debug('Loaded ${logs.length} food logs');
        return logs;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Logs a new food entry.
  Future<void> log(LogFoodInput input) async {
    _log.debug('Logging food');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(logFoodUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Food logged successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Log failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Updates an existing food log.
  Future<void> updateLog(UpdateFoodLogInput input) async {
    _log.debug('Updating food log: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(updateFoodLogUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Food log updated successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Update failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Deletes a food log.
  Future<void> delete(DeleteFoodLogInput input) async {
    _log.debug('Deleting food log: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(deleteFoodLogUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Food log deleted successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Delete failed: ${error.message}');
        throw error;
      },
    );
  }
}
