// lib/presentation/providers/photo_areas/photo_area_list_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/usecases/photo_areas/photo_areas_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'photo_area_list_provider.g.dart';

/// Provider for managing photo area list with profile scope.
@riverpod
class PhotoAreaList extends _$PhotoAreaList {
  static final _log = logger.scope('PhotoAreaList');

  @override
  Future<List<PhotoArea>> build(String profileId) async {
    _log.debug('Loading photo areas for profile: $profileId');

    final useCase = ref.read(getPhotoAreasUseCaseProvider);
    final result = await useCase(GetPhotoAreasInput(profileId: profileId));

    return result.when(
      success: (areas) {
        _log.debug('Loaded ${areas.length} photo areas');
        return areas;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Creates a new photo area.
  Future<void> create(CreatePhotoAreaInput input) async {
    _log.debug('Creating photo area: ${input.name}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(createPhotoAreaUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Photo area created successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Create failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Updates an existing photo area.
  Future<void> updateArea(UpdatePhotoAreaInput input) async {
    _log.debug('Updating photo area: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(updatePhotoAreaUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Photo area updated successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Update failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Archives or unarchives a photo area.
  Future<void> archive(ArchivePhotoAreaInput input) async {
    _log.debug(
      '${input.archive ? "Archiving" : "Unarchiving"} photo area: ${input.id}',
    );

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(archivePhotoAreaUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info(
          'Photo area ${input.archive ? "archived" : "unarchived"} successfully',
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
