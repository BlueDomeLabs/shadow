// lib/presentation/providers/condition_logs/condition_log_list_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/condition_log.dart';
import 'package:shadow_app/domain/usecases/condition_logs/condition_logs_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'condition_log_list_provider.g.dart';

/// Provider for managing condition log list with profile scope.
@riverpod
class ConditionLogList extends _$ConditionLogList {
  static final _log = logger.scope('ConditionLogList');

  @override
  Future<List<ConditionLog>> build(String profileId, String conditionId) async {
    _log.debug('Loading condition logs for condition: $conditionId');

    final useCase = ref.read(getConditionLogsUseCaseProvider);
    final result = await useCase(
      GetConditionLogsInput(profileId: profileId, conditionId: conditionId),
    );

    return result.when(
      success: (logs) {
        _log.debug('Loaded ${logs.length} condition logs');
        return logs;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Updates an existing condition log entry.
  Future<void> updateLog(UpdateConditionLogInput input) async {
    _log.debug('Updating condition log: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(updateConditionLogUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Condition log updated successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Update failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Logs a condition entry.
  Future<void> log(LogConditionInput input) async {
    _log.debug('Logging condition: ${input.conditionId}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(logConditionUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Condition logged successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Log failed: ${error.message}');
        throw error;
      },
    );
  }
}
