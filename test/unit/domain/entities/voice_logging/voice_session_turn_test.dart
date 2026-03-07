// test/unit/domain/entities/voice_logging/voice_session_turn_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/voice_logging/voice_session_turn.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('VoiceSessionTurn', () {
    const profileId = 'profile-001';
    const sessionId = 'session-abc';
    const now = 1700000000000;

    test('construction_setsAllFields', () {
      const turn = VoiceSessionTurn(
        id: 'turn-001',
        profileId: profileId,
        sessionId: sessionId,
        turnIndex: 0,
        role: VoiceTurnRole.assistant,
        content: 'Good morning!',
        loggedItemType: LoggableItemType.supplement,
        createdAt: now,
      );

      expect(turn.id, 'turn-001');
      expect(turn.profileId, profileId);
      expect(turn.sessionId, sessionId);
      expect(turn.turnIndex, 0);
      expect(turn.role, VoiceTurnRole.assistant);
      expect(turn.content, 'Good morning!');
      expect(turn.loggedItemType, LoggableItemType.supplement);
      expect(turn.createdAt, now);
    });

    test('construction_loggedItemTypeDefaultsToNull', () {
      const turn = VoiceSessionTurn(
        id: 'turn-002',
        profileId: profileId,
        sessionId: sessionId,
        turnIndex: 1,
        role: VoiceTurnRole.user,
        content: 'Yes',
        createdAt: now,
      );

      expect(turn.loggedItemType, isNull);
    });

    group('VoiceTurnRole round-trip', () {
      test('assistant_toInt_returns0', () {
        expect(VoiceTurnRole.assistant.toInt(), 0);
      });

      test('user_toInt_returns1', () {
        expect(VoiceTurnRole.user.toInt(), 1);
      });

      test('fromInt_0_returnsAssistant', () {
        expect(VoiceTurnRole.fromInt(0), VoiceTurnRole.assistant);
      });

      test('fromInt_1_returnsUser', () {
        expect(VoiceTurnRole.fromInt(1), VoiceTurnRole.user);
      });

      test('roundTrip_assistant', () {
        const role = VoiceTurnRole.assistant;
        expect(VoiceTurnRole.fromInt(role.toInt()), role);
      });

      test('roundTrip_user', () {
        const role = VoiceTurnRole.user;
        expect(VoiceTurnRole.fromInt(role.toInt()), role);
      });
    });
  });
}
