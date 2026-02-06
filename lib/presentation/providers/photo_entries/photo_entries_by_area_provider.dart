// lib/presentation/providers/photo_entries/photo_entries_by_area_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/photo_entry.dart';
import 'package:shadow_app/domain/usecases/photo_entries/photo_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'photo_entries_by_area_provider.g.dart';

/// Provider for fetching photo entries filtered by area with profile scope.
///
/// Takes both profileId and areaId as build parameters.
@riverpod
class PhotoEntriesByArea extends _$PhotoEntriesByArea {
  static final _log = logger.scope('PhotoEntriesByArea');

  @override
  Future<List<PhotoEntry>> build(String profileId, String photoAreaId) async {
    _log.debug('Loading photo entries for area: $photoAreaId');

    final useCase = ref.read(getPhotoEntriesByAreaUseCaseProvider);
    final result = await useCase(
      GetPhotoEntriesByAreaInput(
        profileId: profileId,
        photoAreaId: photoAreaId,
      ),
    );

    return result.when(
      success: (entries) {
        _log.debug('Loaded ${entries.length} photo entries for area');
        return entries;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }
}
