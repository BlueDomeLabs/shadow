// test/unit/presentation/screens/voice_logging/voice_session_state_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/voice_logging/voice_session_state.dart';

void main() {
  group('VoiceSessionState', () {
    test('construction_defaults', () {
      const s = VoiceSessionState(phase: VoiceSessionPhase.idle);
      expect(s.phase, VoiceSessionPhase.idle);
      expect(s.assistantText, '');
      expect(s.micPermissionGranted, isTrue);
      expect(s.isSuspended, isFalse);
      expect(s.suspendedQuestion, '');
      expect(s.queueTotal, 0);
      expect(s.queueAnswered, 0);
      expect(s.silenceWarningGiven, isFalse);
    });

    test('copyWith_updatesPhase', () {
      const original = VoiceSessionState(phase: VoiceSessionPhase.idle);
      final updated = original.copyWith(phase: VoiceSessionPhase.listening);
      expect(updated.phase, VoiceSessionPhase.listening);
      expect(updated.assistantText, ''); // unchanged
    });

    test('copyWith_updatesSilenceWarningGiven', () {
      const original = VoiceSessionState(phase: VoiceSessionPhase.listening);
      final updated = original.copyWith(silenceWarningGiven: true);
      expect(updated.silenceWarningGiven, isTrue);
      expect(updated.phase, VoiceSessionPhase.listening); // unchanged
    });

    test('copyWith_preservesUnchangedFields', () {
      const original = VoiceSessionState(
        phase: VoiceSessionPhase.speaking,
        assistantText: 'Hello?',
        micPermissionGranted: false,
        isSuspended: true,
        suspendedQuestion: 'Did you sleep well?',
        queueTotal: 5,
        queueAnswered: 2,
        silenceWarningGiven: true,
      );
      final updated = original.copyWith(phase: VoiceSessionPhase.listening);
      expect(updated.assistantText, 'Hello?');
      expect(updated.micPermissionGranted, isFalse);
      expect(updated.isSuspended, isTrue);
      expect(updated.suspendedQuestion, 'Did you sleep well?');
      expect(updated.queueTotal, 5);
      expect(updated.queueAnswered, 2);
      expect(updated.silenceWarningGiven, isTrue);
    });
  });
}
