// lib/core/services/voice_pipeline_service.dart
// Per VOICE_LOGGING_SPEC.md Section 6

import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Thin audio I/O layer wrapping speech_to_text and flutter_tts.
///
/// Has no knowledge of sessions, queues, or Claude — it only manages
/// the platform audio channels.
class VoicePipelineService {
  VoicePipelineService() : _stt = SpeechToText(), _tts = FlutterTts();

  // Allow injection for tests.
  VoicePipelineService.withDependencies(this._stt, this._tts);

  final SpeechToText _stt;
  final FlutterTts _tts;

  bool _initialised = false;

  // ── Initialisation ──────────────────────────────────────────────────────────

  /// Initialises STT and TTS. Returns true if microphone permission is granted.
  Future<bool> initialise() async {
    await _tts.awaitSpeakCompletion(true);
    return _initialised = await _stt.initialize();
  }

  // ── TTS ─────────────────────────────────────────────────────────────────────

  /// Speaks [text] aloud. Completes when TTS finishes or is stopped.
  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  /// Stops TTS immediately.
  Future<void> stopSpeaking() async {
    await _tts.stop();
  }

  // ── STT ─────────────────────────────────────────────────────────────────────

  /// Starts listening. Calls [onResult] when a final result is available.
  /// Calls [onPartial] with in-progress text (for live display).
  Future<void> startListening({
    required void Function(String transcript) onResult,
    void Function(String partial)? onPartial,
  }) async {
    if (!_initialised) return;
    await _stt.listen(
      listenFor: const Duration(seconds: 15),
      onResult: (result) {
        if (result.hasConfidenceRating && !result.finalResult) {
          onPartial?.call(result.recognizedWords);
        }
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
    );
  }

  /// Stops listening and discards any in-progress result.
  Future<void> stopListening() async {
    await _stt.stop();
  }

  // ── Audio session ────────────────────────────────────────────────────────────

  /// iOS only: configures AVAudioSession for playAndRecord + defaultToSpeaker.
  Future<void> activateAudioSession() async {
    if (!Platform.isIOS) return;
    await _tts.setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord, [
      IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
      IosTextToSpeechAudioCategoryOptions.allowBluetooth,
    ]);
  }

  /// iOS only: restores AVAudioSession to ambient category.
  Future<void> deactivateAudioSession() async {
    if (!Platform.isIOS) return;
    await _tts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.ambient,
      const [],
    );
  }

  // ── Permission ───────────────────────────────────────────────────────────────

  /// Returns true if microphone permission is currently granted.
  Future<bool> hasMicPermission() async => _initialised;

  Future<void> dispose() async {
    await _tts.stop();
    await _stt.stop();
  }
}
