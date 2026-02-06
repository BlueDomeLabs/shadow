// lib/presentation/providers/photo_entries/photo_entry_list_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/photo_entry.dart';
import 'package:shadow_app/domain/usecases/photo_entries/photo_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'photo_entry_list_provider.g.dart';

/// Provider for managing photo entry list with profile scope.
@riverpod
class PhotoEntryList extends _$PhotoEntryList {
  static final _log = logger.scope('PhotoEntryList');

  @override
  Future<List<PhotoEntry>> build(String profileId) async {
    _log.debug('Loading photo entries for profile: $profileId');

    final useCase = ref.read(getPhotoEntriesUseCaseProvider);
    final result = await useCase(GetPhotoEntriesInput(profileId: profileId));

    return result.when(
      success: (entries) {
        _log.debug('Loaded ${entries.length} photo entries');
        return entries;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Creates a new photo entry.
  Future<void> create(CreatePhotoEntryInput input) async {
    _log.debug('Creating photo entry for area: ${input.photoAreaId}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(createPhotoEntryUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Photo entry created successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Create failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Deletes a photo entry.
  Future<void> delete(DeletePhotoEntryInput input) async {
    _log.debug('Deleting photo entry: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(deletePhotoEntryUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Photo entry deleted successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Delete failed: ${error.message}');
        throw error;
      },
    );
  }
}
