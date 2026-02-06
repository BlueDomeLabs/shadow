// lib/presentation/providers/fluids_entries/fluids_entry_list_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/usecases/fluids_entries/fluids_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'fluids_entry_list_provider.g.dart';

/// Provider for managing fluids entry list with profile scope and date range.
@riverpod
class FluidsEntryList extends _$FluidsEntryList {
  static final _log = logger.scope('FluidsEntryList');

  @override
  Future<List<FluidsEntry>> build(
    String profileId,
    int startDate,
    int endDate,
  ) async {
    _log.debug('Loading fluids entries for profile: $profileId');

    final useCase = ref.read(getFluidsEntriesUseCaseProvider);
    final result = await useCase(
      GetFluidsEntriesInput(
        profileId: profileId,
        startDate: startDate,
        endDate: endDate,
      ),
    );

    return result.when(
      success: (entries) {
        _log.debug('Loaded ${entries.length} fluids entries');
        return entries;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Logs a new fluids entry.
  Future<void> log(LogFluidsEntryInput input) async {
    _log.debug('Logging fluids entry');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(logFluidsEntryUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Fluids entry logged successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Log failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Updates an existing fluids entry.
  Future<void> updateEntry(UpdateFluidsEntryInput input) async {
    _log.debug('Updating fluids entry: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(updateFluidsEntryUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Fluids entry updated successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Update failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Deletes a fluids entry.
  Future<void> delete(DeleteFluidsEntryInput input) async {
    _log.debug('Deleting fluids entry: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(deleteFluidsEntryUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Fluids entry deleted successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Delete failed: ${error.message}');
        throw error;
      },
    );
  }
}
