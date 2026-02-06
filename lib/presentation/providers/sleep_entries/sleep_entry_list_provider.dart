// lib/presentation/providers/sleep_entries/sleep_entry_list_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/sleep_entry.dart';
import 'package:shadow_app/domain/usecases/sleep_entries/sleep_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'sleep_entry_list_provider.g.dart';

/// Provider for managing sleep entry list with profile scope.
@riverpod
class SleepEntryList extends _$SleepEntryList {
  static final _log = logger.scope('SleepEntryList');

  @override
  Future<List<SleepEntry>> build(String profileId) async {
    _log.debug('Loading sleep entries for profile: $profileId');

    final useCase = ref.read(getSleepEntriesUseCaseProvider);
    final result = await useCase(GetSleepEntriesInput(profileId: profileId));

    return result.when(
      success: (entries) {
        _log.debug('Loaded ${entries.length} sleep entries');
        return entries;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Logs a new sleep entry.
  Future<void> log(LogSleepEntryInput input) async {
    _log.debug('Logging sleep entry');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(logSleepEntryUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Sleep entry logged successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Log failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Updates an existing sleep entry.
  Future<void> updateEntry(UpdateSleepEntryInput input) async {
    _log.debug('Updating sleep entry: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(updateSleepEntryUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Sleep entry updated successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Update failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Deletes a sleep entry.
  Future<void> delete(DeleteSleepEntryInput input) async {
    _log.debug('Deleting sleep entry: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(deleteSleepEntryUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Sleep entry deleted successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Delete failed: ${error.message}');
        throw error;
      },
    );
  }
}
