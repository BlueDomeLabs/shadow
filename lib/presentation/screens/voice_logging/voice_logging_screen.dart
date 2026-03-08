// lib/presentation/screens/voice_logging/voice_logging_screen.dart
// Per VOICE_LOGGING_SPEC.md Section 6.3 and Navigation Architecture (Section 1)

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/services/voice_pipeline_service.dart';
import 'package:shadow_app/presentation/screens/home/home_screen.dart';
import 'package:shadow_app/presentation/screens/voice_logging/voice_session_state.dart';

/// AI assistant home screen — the app's root route.
///
/// Wires speech_to_text + flutter_tts via VoicePipelineService.
/// A placeholder brain echoes user input until Session C wires real Claude API.
class VoiceLoggingScreen extends ConsumerStatefulWidget {
  const VoiceLoggingScreen({super.key, this.pendingItemCount = 0});

  /// Drives the queue progress dots at the bottom of the screen.
  final int pendingItemCount;

  @override
  ConsumerState<VoiceLoggingScreen> createState() => _VoiceLoggingScreenState();
}

class _VoiceLoggingScreenState extends ConsumerState<VoiceLoggingScreen>
    with WidgetsBindingObserver {
  late final VoicePipelineService _pipeline;
  late VoiceSessionState _session;
  bool _isTextMode = false;
  Timer? _silenceTimer;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _session = VoiceSessionState(
      phase: VoiceSessionPhase.idle,
      assistantText: 'Good morning. How can I help?',
      queueTotal: widget.pendingItemCount,
    );
    _pipeline = VoicePipelineService();
    _initSession();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pipeline
      ..stopSpeaking()
      ..stopListening()
      ..deactivateAudioSession()
      ..dispose();
    _textController.dispose();
    _silenceTimer?.cancel();
    super.dispose();
  }

  Future<void> _initSession() async {
    final granted = await _pipeline.initialise();
    await _pipeline.activateAudioSession();
    if (!mounted) return;
    setState(() {
      _session = _session.copyWith(micPermissionGranted: granted);
    });
    if (!granted) {
      setState(() {
        _session = _session.copyWith(
          assistantText:
              'Microphone access is off. You can still type your answers.',
        );
      });
    } else {
      unawaited(_startSpeaking('Good morning. How can I help?'));
    }
  }

  // ── WidgetsBindingObserver ──────────────────────────────────────────────────

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _onBackground();
      case AppLifecycleState.resumed:
        _onForeground();
      default:
        break;
    }
  }

  void _onBackground() {
    if (_session.phase == VoiceSessionPhase.idle ||
        _session.phase == VoiceSessionPhase.complete) {
      return;
    }
    _pipeline
      ..stopSpeaking()
      ..stopListening()
      ..deactivateAudioSession();
    _silenceTimer?.cancel();
    setState(() {
      _session = _session.copyWith(
        phase: VoiceSessionPhase.suspended,
        isSuspended: true,
        suspendedQuestion: _session.assistantText,
      );
    });
  }

  void _onForeground() {
    // Resume banner is shown by the build method when isSuspended = true.
    // No automatic resume — user must tap Resume or Dismiss.
  }

  // ── TTS ─────────────────────────────────────────────────────────────────────

  Future<void> _startSpeaking(String text) async {
    setState(() {
      _session = _session.copyWith(
        phase: VoiceSessionPhase.speaking,
        assistantText: text,
      );
    });
    await _pipeline.speak(text);
    if (!mounted) return;
    if (_session.phase == VoiceSessionPhase.speaking) {
      _startListening();
    }
  }

  // ── Listening + silence timeout ─────────────────────────────────────────────

  void _startListening() {
    if (!_session.micPermissionGranted) return;
    setState(() {
      _session = _session.copyWith(
        phase: VoiceSessionPhase.listening,
        silenceWarningGiven: false,
      );
    });
    _resetSilenceTimer();
    _pipeline.startListening(
      onResult: _onSpeechResult,
      onPartial: (_) {
        // Cancel silence timer while user is speaking.
        _silenceTimer?.cancel();
      },
    );
  }

  void _resetSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(const Duration(seconds: 15), _onSilenceTimeout);
  }

  void _onSilenceTimeout() {
    if (_session.phase != VoiceSessionPhase.listening) return;
    if (!_session.silenceWarningGiven) {
      setState(() {
        _session = _session.copyWith(silenceWarningGiven: true);
      });
      unawaited(_startSpeaking('Still there? Take your time.'));
    } else {
      _pipeline.stopListening();
      _silenceTimer?.cancel();
      setState(() {
        _session = _session.copyWith(
          phase: VoiceSessionPhase.suspended,
          isSuspended: true,
        );
      });
      unawaited(_startSpeaking("I'll pick this up when you're ready."));
    }
  }

  // ── STT result + placeholder brain ─────────────────────────────────────────

  void _onSpeechResult(String transcript) {
    _silenceTimer?.cancel();
    _pipeline.stopListening();
    _handleUserInput(transcript);
  }

  void _onTextSend() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    _handleUserInput(text);
  }

  /// Placeholder brain. Session C replaces this with Claude API call.
  void _handleUserInput(String userText) {
    final echo = 'Got it — "$userText". Is that right?';
    _startSpeaking(echo);
  }

  // ── Resume / dismiss ────────────────────────────────────────────────────────

  void _resumeSession() {
    _pipeline.activateAudioSession();
    setState(() {
      _session = _session.copyWith(isSuspended: false);
    });
    _startSpeaking(_session.suspendedQuestion);
  }

  void _dismissSession() {
    setState(() {
      _session = _session.copyWith(
        phase: VoiceSessionPhase.idle,
        isSuspended: false,
        assistantText: 'Good morning. How can I help?',
      );
    });
  }

  // ── Navigation ──────────────────────────────────────────────────────────────

  void _toggleTextMode() {
    setState(() {
      _isTextMode = !_isTextMode;
    });
  }

  void _navigateToLogs() {
    Navigator.of(
      context,
    ).push<void>(MaterialPageRoute<void>(builder: (_) => const HomeScreen()));
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSpeaking = _session.phase == VoiceSessionPhase.speaking;
    final isListening = _session.phase == VoiceSessionPhase.listening;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Header row: X close + text mode toggle ───────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Close session',
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  TextButton(
                    onPressed: _toggleTextMode,
                    child: Text(_isTextMode ? 'Voice mode' : 'Text mode'),
                  ),
                ],
              ),
            ),

            // ── Resume card (shown when backgrounded mid-session) ────────────
            if (_session.isSuspended)
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('You were in the middle of a check-in.'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          FilledButton(
                            onPressed: _resumeSession,
                            child: const Text('Resume'),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: _dismissSession,
                            child: const Text('Dismiss'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // ── Mic permission banner ────────────────────────────────────────
            if (!_session.micPermissionGranted)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Text(
                  'Microphone access is off. You can still type your answers.',
                  style: TextStyle(color: colorScheme.error),
                ),
              ),

            // ── Avatar / pulse area ──────────────────────────────────────────
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated avatar — pulses while speaking
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      width: isSpeaking ? 110 : 90,
                      height: isSpeaking ? 110 : 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSpeaking
                            ? colorScheme.primary
                            : colorScheme.primaryContainer,
                      ),
                      child: Icon(
                        Icons.mic,
                        size: 40,
                        color: isSpeaking
                            ? colorScheme.onPrimary
                            : colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Assistant text display
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _session.assistantText,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Mic button (large)
                    GestureDetector(
                      onTap: isListening
                          ? () {
                              _silenceTimer?.cancel();
                              _pipeline.stopListening();
                            }
                          : (_session.micPermissionGranted
                                ? _startListening
                                : null),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isListening
                              ? colorScheme.error
                              : colorScheme.primary,
                        ),
                        child: Icon(
                          isListening ? Icons.stop : Icons.mic,
                          size: 36,
                          color: isListening
                              ? colorScheme.onError
                              : colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Text input row (always visible)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              decoration: const InputDecoration(
                                hintText: 'Type a response...',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _onTextSend(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            icon: const Icon(Icons.arrow_forward),
                            tooltip: 'Send',
                            onPressed: _onTextSend,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Queue progress dots
                    if (_session.queueTotal > 0)
                      _QueueProgressDots(
                        total: _session.queueTotal,
                        answered: _session.queueAnswered,
                      ),
                  ],
                ),
              ),
            ),

            // ── Bottom nav — "Logs" link to HomeScreen ───────────────────────
            BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: _navigateToLogs,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.grid_view, color: colorScheme.primary),
                          Text(
                            'Logs',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Row of filled/empty circles indicating queue progress.
class _QueueProgressDots extends StatelessWidget {
  const _QueueProgressDots({required this.total, required this.answered});

  final int total;
  final int answered;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final filled = i < answered;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? colorScheme.primary : colorScheme.outline,
            ),
          ),
        );
      }),
    );
  }
}
