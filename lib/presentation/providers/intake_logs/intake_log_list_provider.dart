// lib/presentation/providers/intake_logs/intake_log_list_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/intake_log.dart';
import 'package:shadow_app/domain/usecases/intake_logs/intake_logs_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'intake_log_list_provider.g.dart';

/// Provider for managing intake log list with profile scope.
///
/// Supports special actions: markTaken, markSkipped.
@riverpod
class IntakeLogList extends _$IntakeLogList {
  static final _log = logger.scope('IntakeLogList');

  @override
  Future<List<IntakeLog>> build(String profileId) async {
    _log.debug('Loading intake logs for profile: $profileId');

    final useCase = ref.read(getIntakeLogsUseCaseProvider);
    final result = await useCase(GetIntakeLogsInput(profileId: profileId));

    return result.when(
      success: (logs) {
        _log.debug('Loaded ${logs.length} intake logs');
        return logs;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Marks an intake log as taken.
  Future<void> markTaken(MarkTakenInput input) async {
    _log.debug('Marking intake as taken: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(markTakenUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Intake marked as taken');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Mark taken failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Marks an intake log as skipped.
  Future<void> markSkipped(MarkSkippedInput input) async {
    _log.debug('Marking intake as skipped: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(markSkippedUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Intake marked as skipped');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Mark skipped failed: ${error.message}');
        throw error;
      },
    );
  }
}
