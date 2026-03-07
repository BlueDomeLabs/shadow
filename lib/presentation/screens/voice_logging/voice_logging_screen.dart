// lib/presentation/screens/voice_logging/voice_logging_screen.dart
// Per VOICE_LOGGING_SPEC.md Section 6.3 and Navigation Architecture (Section 1)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/presentation/screens/home/home_screen.dart';

/// AI assistant home screen — the app's root route.
///
/// UI shell only — no STT/TTS wiring. All logic is placeholder.
/// Session B2 will wire speech_to_text and flutter_tts.
class VoiceLoggingScreen extends ConsumerStatefulWidget {
  const VoiceLoggingScreen({super.key, this.pendingItemCount = 0});

  /// Drives the queue progress dots at the bottom of the screen.
  final int pendingItemCount;

  @override
  ConsumerState<VoiceLoggingScreen> createState() => _VoiceLoggingScreenState();
}

class _VoiceLoggingScreenState extends ConsumerState<VoiceLoggingScreen> {
  final String _assistantText = 'Good morning. How can I help?';
  final bool _isSpeaking = false;
  bool _isListening = false;
  bool _isTextMode = false;
  final int _queueAnswered = 0;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });
  }

  void _toggleTextMode() {
    setState(() {
      _isTextMode = !_isTextMode;
    });
  }

  void _sendText() {
    _textController.clear();
  }

  void _navigateToLogs() {
    Navigator.of(
      context,
    ).push<void>(MaterialPageRoute<void>(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Header row: X close + text mode toggle ──────────────────────
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

            // ── Avatar / pulse area ─────────────────────────────────────────
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated avatar — pulses while "speaking"
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      width: _isSpeaking ? 110 : 90,
                      height: _isSpeaking ? 110 : 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isSpeaking
                            ? colorScheme.primary
                            : colorScheme.primaryContainer,
                      ),
                      child: Icon(
                        Icons.mic,
                        size: 40,
                        color: _isSpeaking
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
                          _assistantText,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Mic button (large)
                    GestureDetector(
                      onTap: _toggleListening,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isListening
                              ? colorScheme.error
                              : colorScheme.primary,
                        ),
                        child: Icon(
                          _isListening ? Icons.stop : Icons.mic,
                          size: 36,
                          color: _isListening
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
                              onSubmitted: (_) => _sendText(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            icon: const Icon(Icons.arrow_forward),
                            tooltip: 'Send',
                            onPressed: _sendText,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Queue progress dots
                    if (widget.pendingItemCount > 0)
                      _QueueProgressDots(
                        total: widget.pendingItemCount,
                        answered: _queueAnswered,
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
