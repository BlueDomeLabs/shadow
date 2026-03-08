// lib/presentation/screens/voice_logging/voice_session_state.dart
// Per VOICE_LOGGING_SPEC.md Sections 6, 11

/// The current phase of a voice logging session.
enum VoiceSessionPhase {
  idle, // no active session, showing default home UI
  speaking, // TTS is playing — mic disabled, avatar animated
  listening, // STT is active — mic button lit, timeout timer running
  processing, // placeholder; will be used by Session C for API call in-flight
  suspended, // backgrounded; state preserved in memory
  complete, // all queue items done, session ended normally
}

/// Immutable state snapshot for VoiceLoggingScreen.
class VoiceSessionState {
  const VoiceSessionState({
    required this.phase,
    this.assistantText = '',
    this.micPermissionGranted = true,
    this.isSuspended = false,
    this.suspendedQuestion = '',
    this.queueTotal = 0,
    this.queueAnswered = 0,
    this.silenceWarningGiven = false,
  });

  final VoiceSessionPhase phase;
  final String assistantText;
  final bool micPermissionGranted;

  /// True while session is backgrounded.
  final bool isSuspended;

  /// Last question asked, for re-read on resume.
  final String suspendedQuestion;

  final int queueTotal;
  final int queueAnswered;

  /// Tracks whether the first silence prompt has been given.
  final bool silenceWarningGiven;

  VoiceSessionState copyWith({
    VoiceSessionPhase? phase,
    String? assistantText,
    bool? micPermissionGranted,
    bool? isSuspended,
    String? suspendedQuestion,
    int? queueTotal,
    int? queueAnswered,
    bool? silenceWarningGiven,
  }) => VoiceSessionState(
    phase: phase ?? this.phase,
    assistantText: assistantText ?? this.assistantText,
    micPermissionGranted: micPermissionGranted ?? this.micPermissionGranted,
    isSuspended: isSuspended ?? this.isSuspended,
    suspendedQuestion: suspendedQuestion ?? this.suspendedQuestion,
    queueTotal: queueTotal ?? this.queueTotal,
    queueAnswered: queueAnswered ?? this.queueAnswered,
    silenceWarningGiven: silenceWarningGiven ?? this.silenceWarningGiven,
  );
}
