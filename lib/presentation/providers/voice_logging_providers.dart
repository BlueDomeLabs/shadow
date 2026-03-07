// lib/presentation/providers/voice_logging_providers.dart
// Per VOICE_LOGGING_SPEC.md Section 4

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/domain/repositories/voice_logging_repository.dart';
import 'package:shadow_app/domain/usecases/voice_logging/get_recent_session_turns_use_case.dart';
import 'package:shadow_app/domain/usecases/voice_logging/get_voice_logging_settings_use_case.dart';
import 'package:shadow_app/domain/usecases/voice_logging/prune_session_history_use_case.dart';
import 'package:shadow_app/domain/usecases/voice_logging/save_session_turn_use_case.dart';
import 'package:shadow_app/domain/usecases/voice_logging/save_voice_logging_settings_use_case.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'voice_logging_providers.g.dart';

/// Voice logging repository provider — override in ProviderScope with
/// VoiceLoggingRepositoryImpl wired to AppDatabase DAOs.
@Riverpod(keepAlive: true)
VoiceLoggingRepository voiceLoggingRepository(Ref ref) {
  throw UnimplementedError(
    'Override voiceLoggingRepositoryProvider in ProviderScope',
  );
}

/// GetVoiceLoggingSettingsUseCase provider.
@riverpod
GetVoiceLoggingSettingsUseCase getVoiceLoggingSettingsUseCase(Ref ref) =>
    GetVoiceLoggingSettingsUseCase(
      ref.read(voiceLoggingRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// SaveVoiceLoggingSettingsUseCase provider.
@riverpod
SaveVoiceLoggingSettingsUseCase saveVoiceLoggingSettingsUseCase(Ref ref) =>
    SaveVoiceLoggingSettingsUseCase(
      ref.read(voiceLoggingRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// GetRecentSessionTurnsUseCase provider.
@riverpod
GetRecentSessionTurnsUseCase getRecentSessionTurnsUseCase(Ref ref) =>
    GetRecentSessionTurnsUseCase(
      ref.read(voiceLoggingRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// SaveSessionTurnUseCase provider.
@riverpod
SaveSessionTurnUseCase saveSessionTurnUseCase(Ref ref) =>
    SaveSessionTurnUseCase(
      ref.read(voiceLoggingRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );

/// PruneSessionHistoryUseCase provider.
@riverpod
PruneSessionHistoryUseCase pruneSessionHistoryUseCase(Ref ref) =>
    PruneSessionHistoryUseCase(
      ref.read(voiceLoggingRepositoryProvider),
      ref.read(profileAuthorizationServiceProvider),
    );
