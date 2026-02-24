// lib/presentation/providers/diet/fasting_session_provider.dart
// Active fasting session state management — Phase 15b-3
// Per 02_CODING_STANDARDS.md Section 6

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/fasting_session.dart';
import 'package:shadow_app/domain/usecases/fasting/fasting_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'fasting_session_provider.g.dart';

/// Provider for managing the active fasting session for a profile.
///
/// Returns the current active FastingSession, or null if no fast is in progress.
/// Follows the UseCase delegation pattern — never calls repository directly.
@riverpod
class FastingSessionNotifier extends _$FastingSessionNotifier {
  static final _log = logger.scope('FastingSessionNotifier');

  @override
  Future<FastingSession?> build(String profileId) async {
    _log.debug('Loading active fast for profile: $profileId');

    final useCase = ref.read(getActiveFastUseCaseProvider);
    final result = await useCase(GetActiveFastInput(profileId: profileId));

    return result.when(
      success: (session) {
        _log.debug('Active fast: ${session?.id ?? "none"}');
        return session;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Starts a new fasting session.
  Future<void> startFast(StartFastInput input) async {
    _log.debug('Starting fast for profile: ${input.profileId}');

    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(startFastUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Fast started successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Start fast failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Ends the active fasting session.
  Future<void> endFast(EndFastInput input) async {
    _log.debug('Ending fast: ${input.sessionId}');

    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(endFastUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Fast ended successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('End fast failed: ${error.message}');
        throw error;
      },
    );
  }
}
