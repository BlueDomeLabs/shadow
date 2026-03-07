// test/unit/data/repositories/voice_logging_repository_impl_test.dart

import 'package:drift/drift.dart' hide DatabaseConnection, isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/repositories/voice_logging_repository_impl.dart';
import 'package:shadow_app/domain/entities/voice_logging/voice_logging_settings.dart';
import 'package:shadow_app/domain/entities/voice_logging/voice_session_turn.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('VoiceLoggingRepositoryImpl', () {
    late AppDatabase database;
    late VoiceLoggingRepositoryImpl repo;

    const profileId = 'profile-001';
    const now = 1700000000000;

    VoiceLoggingSettings defaultSettings() => const VoiceLoggingSettings(
      id: profileId,
      profileId: profileId,
      closingStyle: ClosingStyle.random,
      createdAt: now,
    );

    VoiceSessionTurn makeTurn({
      String id = 'turn-001',
      String pId = profileId,
      String sId = 'session-001',
      int turnIndex = 0,
      VoiceTurnRole role = VoiceTurnRole.assistant,
      String content = 'Hello!',
      LoggableItemType? loggedItemType,
      int createdAt = now,
    }) => VoiceSessionTurn(
      id: id,
      profileId: pId,
      sessionId: sId,
      turnIndex: turnIndex,
      role: role,
      content: content,
      loggedItemType: loggedItemType,
      createdAt: createdAt,
    );

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
      repo = VoiceLoggingRepositoryImpl(
        database.voiceLoggingSettingsDao,
        database.voiceSessionHistoryDao,
      );
    });

    tearDown(() async {
      await database.close();
    });

    group('getSettings', () {
      test('returnsNull_whenNoRowExists', () async {
        final result = await repo.getSettings(profileId);
        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });

      test('returnsSettings_afterSave', () async {
        await repo.saveSettings(defaultSettings());
        final result = await repo.getSettings(profileId);
        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.profileId, profileId);
      });
    });

    group('saveSettings', () {
      test('roundTrips_closingStyle', () async {
        final settings = defaultSettings().copyWith(
          closingStyle: ClosingStyle.fixed,
          fixedFarewell: 'Goodbye!',
        );
        await repo.saveSettings(settings);
        final result = await repo.getSettings(profileId);
        expect(result.valueOrNull?.closingStyle, ClosingStyle.fixed);
        expect(result.valueOrNull?.fixedFarewell, 'Goodbye!');
      });

      test('roundTrips_categoryPriorityOrder', () async {
        final settings = defaultSettings().copyWith(
          categoryPriorityOrder: [0, 2, 1],
        );
        await repo.saveSettings(settings);
        final result = await repo.getSettings(profileId);
        expect(result.valueOrNull?.categoryPriorityOrder, [0, 2, 1]);
      });

      test('updatesExistingRow', () async {
        await repo.saveSettings(defaultSettings());
        final updated = defaultSettings().copyWith(
          closingStyle: ClosingStyle.none,
        );
        await repo.saveSettings(updated);
        final result = await repo.getSettings(profileId);
        expect(result.valueOrNull?.closingStyle, ClosingStyle.none);
      });
    });

    group('getRecentTurns', () {
      test('delegatesCorrectly_withDaysBack', () async {
        final actualNow = DateTime.now().millisecondsSinceEpoch;
        // Insert a turn created 1 day ago
        final recentTurn = makeTurn(
          id: 'recent',
          createdAt: actualNow - (1 * 24 * 60 * 60 * 1000),
        );
        // Insert a turn created 20 days ago
        final oldTurn = makeTurn(
          id: 'old',
          createdAt: actualNow - (20 * 24 * 60 * 60 * 1000),
        );
        await repo.saveTurn(recentTurn);
        await repo.saveTurn(oldTurn);

        // daysBack=5: 1-day-old turn appears, 20-day-old turn excluded
        final result = await repo.getRecentTurns(profileId, daysBack: 5);
        expect(result.isSuccess, isTrue);
        final turns = result.valueOrNull!;
        final ids = turns.map((t) => t.id).toList();
        expect(ids, contains('recent'));
        expect(ids, isNot(contains('old')));
      });

      test('returnsEmpty_whenNoTurns', () async {
        final result = await repo.getRecentTurns(profileId);
        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });
    });

    group('saveTurn', () {
      test('persistsAllFields', () async {
        final recentMs = DateTime.now().millisecondsSinceEpoch;
        final turn = makeTurn(
          role: VoiceTurnRole.user,
          content: 'Yes, I did.',
          loggedItemType: LoggableItemType.supplement,
          createdAt: recentMs,
        );
        await repo.saveTurn(turn);

        final result = await repo.getRecentTurns(profileId);
        final saved = result.valueOrNull!.first;
        expect(saved.role, VoiceTurnRole.user);
        expect(saved.content, 'Yes, I did.');
        expect(saved.loggedItemType, LoggableItemType.supplement);
      });

      test('persistsNullLoggedItemType', () async {
        final recentMs = DateTime.now().millisecondsSinceEpoch;
        await repo.saveTurn(makeTurn(createdAt: recentMs));
        final result = await repo.getRecentTurns(profileId);
        expect(result.valueOrNull!.first.loggedItemType, isNull);
      });
    });

    group('pruneOldTurns', () {
      test('calculatesCutoffAs90DaysAgo', () async {
        final actualNow = DateTime.now().millisecondsSinceEpoch;
        // Insert a turn 91 days old — should be pruned
        final oldTurn = makeTurn(
          id: 'very-old',
          createdAt: actualNow - (91 * 24 * 60 * 60 * 1000),
        );
        // Insert a turn 1 day old — should NOT be pruned
        final recentTurn = makeTurn(
          id: 'recent',
          createdAt: actualNow - (1 * 24 * 60 * 60 * 1000),
        );
        await repo.saveTurn(oldTurn);
        await repo.saveTurn(recentTurn);

        final pruneResult = await repo.pruneOldTurns(profileId);
        expect(pruneResult.isSuccess, isTrue);

        // After pruning, the old turn should be gone and recent should remain
        final allRows = await database
            .customSelect(
              'SELECT id FROM voice_session_history WHERE profile_id = ?',
              variables: [Variable.withString(profileId)],
            )
            .get();
        final ids = allRows.map((r) => r.data['id'] as String).toList();
        expect(ids, isNot(contains('very-old')));
        expect(ids, contains('recent'));
      });
    });
  });
}
