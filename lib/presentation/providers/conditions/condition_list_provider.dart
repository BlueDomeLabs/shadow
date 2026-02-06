// lib/presentation/providers/conditions/condition_list_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/usecases/conditions/conditions_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'condition_list_provider.g.dart';

/// Provider for managing condition list with profile scope.
@riverpod
class ConditionList extends _$ConditionList {
  static final _log = logger.scope('ConditionList');

  @override
  Future<List<Condition>> build(String profileId) async {
    _log.debug('Loading conditions for profile: $profileId');

    final useCase = ref.read(getConditionsUseCaseProvider);
    final result = await useCase(GetConditionsInput(profileId: profileId));

    return result.when(
      success: (conditions) {
        _log.debug('Loaded ${conditions.length} conditions');
        return conditions;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Creates a new condition.
  Future<void> create(CreateConditionInput input) async {
    _log.debug('Creating condition: ${input.name}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(createConditionUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Condition created successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Create failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Archives a condition.
  Future<void> archive(ArchiveConditionInput input) async {
    _log.debug('Archiving condition: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(archiveConditionUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Condition archived successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Archive failed: ${error.message}');
        throw error;
      },
    );
  }
}
