// lib/presentation/providers/diet/diet_list_provider.dart
// Diet list state management — Phase 15b-3
// Per 02_CODING_STANDARDS.md Section 6

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/diet.dart';
import 'package:shadow_app/domain/usecases/diet/diets_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'diet_list_provider.g.dart';

/// Provider for managing diet list with profile scope.
///
/// Follows the UseCase delegation pattern — never calls repository directly.
@riverpod
class DietList extends _$DietList {
  static final _log = logger.scope('DietList');

  @override
  Future<List<Diet>> build(String profileId) async {
    _log.debug('Loading diets for profile: $profileId');

    final useCase = ref.read(getDietsUseCaseProvider);
    final result = await useCase(GetDietsInput(profileId: profileId));

    return result.when(
      success: (diets) {
        _log.debug('Loaded ${diets.length} diets');
        return diets;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Creates a new diet (custom or preset).
  Future<void> create(CreateDietInput input) async {
    _log.debug('Creating diet: ${input.name}');

    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(createDietUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Diet created successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Create failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Activates a diet (deactivates any currently active diet).
  Future<void> activate(ActivateDietInput input) async {
    _log.debug('Activating diet: ${input.dietId}');

    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(activateDietUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Diet activated successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Activate failed: ${error.message}');
        throw error;
      },
    );
  }
}
