// lib/presentation/providers/supplements/supplement_list_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/usecases/supplements/supplements_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'supplement_list_provider.g.dart';

/// Provider for managing supplement list with profile scope.
///
/// Follows the UseCase delegation pattern:
/// - ALWAYS delegates to UseCases (never calls repository directly)
/// - Uses `result.when()` for Result handling
/// - Calls `ref.invalidateSelf()` after successful mutations
/// - Logs errors and throws for AsyncValue error state
/// - Checks write access before mutations (defense-in-depth)
@riverpod
class SupplementList extends _$SupplementList {
  static final _log = logger.scope('SupplementList');

  @override
  Future<List<Supplement>> build(String profileId) async {
    _log.debug('Loading supplements for profile: $profileId');

    final useCase = ref.read(getSupplementsUseCaseProvider);
    final result = await useCase(GetSupplementsInput(profileId: profileId));

    return result.when(
      success: (supplements) {
        _log.debug('Loaded ${supplements.length} supplements');
        return supplements;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Creates a new supplement.
  Future<void> create(CreateSupplementInput input) async {
    _log.debug('Creating supplement: ${input.name}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(createSupplementUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Supplement created successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Create failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Updates an existing supplement.
  Future<void> updateSupplement(UpdateSupplementInput input) async {
    _log.debug('Updating supplement: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(updateSupplementUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Supplement updated successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Update failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Archives or unarchives a supplement.
  Future<void> archive(ArchiveSupplementInput input) async {
    _log.debug(
      '${input.archive ? "Archiving" : "Unarchiving"} supplement: ${input.id}',
    );

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(archiveSupplementUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info(
          'Supplement ${input.archive ? "archived" : "unarchived"} successfully',
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
