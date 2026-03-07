// test/unit/data/datasources/local/daos/voice_session_history_dao_test.dart

import 'package:drift/drift.dart' hide DatabaseConnection, isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/datasources/local/database.dart';

void main() {
  group('VoiceSessionHistoryDao', () {
    late AppDatabase database;

    const profileId = 'profile-001';
    const sessionId = 'session-abc';
    const baseTime = 1700000000000;

    VoiceSessionHistoryTableCompanion makeTurn({
      required String id,
      required int createdAt,
      String pId = profileId,
      String sId = sessionId,
      int turnIndex = 0,
      int role = 0,
      String content = 'Hello',
      int? loggedItemType,
    }) => VoiceSessionHistoryTableCompanion(
      id: Value(id),
      profileId: Value(pId),
      sessionId: Value(sId),
      turnIndex: Value(turnIndex),
      role: Value(role),
      content: Value(content),
      loggedItemType: Value(loggedItemType),
      createdAt: Value(createdAt),
    );

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    test('insertTurn_insertsRowSuccessfully', () async {
      await database.voiceSessionHistoryDao.insertTurn(
        makeTurn(id: 't1', createdAt: baseTime),
      );
      final rows = await database.voiceSessionHistoryDao.getRecentTurns(
        profileId,
        0,
      );
      expect(rows.length, 1);
      expect(rows.first.id, 't1');
    });

    test('getRecentTurns_respectsSinceEpochMs', () async {
      await database.voiceSessionHistoryDao.insertTurn(
        makeTurn(id: 'old', createdAt: baseTime - 1000),
      );
      await database.voiceSessionHistoryDao.insertTurn(
        makeTurn(id: 'new', createdAt: baseTime + 1000),
      );

      // Only fetch turns at or after baseTime
      final rows = await database.voiceSessionHistoryDao.getRecentTurns(
        profileId,
        baseTime,
      );
      expect(rows.length, 1);
      expect(rows.first.id, 'new');
    });

    test('getRecentTurns_returnsEmpty_whenNoneMatch', () async {
      await database.voiceSessionHistoryDao.insertTurn(
        makeTurn(id: 't1', createdAt: baseTime),
      );
      // Cutoff far in the future — no turns qualify
      final rows = await database.voiceSessionHistoryDao.getRecentTurns(
        profileId,
        baseTime + 9999999,
      );
      expect(rows, isEmpty);
    });

    test('getRecentTurns_filtersToCorrectProfile', () async {
      await database.voiceSessionHistoryDao.insertTurn(
        makeTurn(id: 'p1-turn', createdAt: baseTime),
      );
      await database.voiceSessionHistoryDao.insertTurn(
        makeTurn(id: 'p2-turn', createdAt: baseTime, pId: 'profile-002'),
      );

      final rows = await database.voiceSessionHistoryDao.getRecentTurns(
        'profile-001',
        0,
      );
      expect(rows.length, 1);
      expect(rows.first.id, 'p1-turn');
    });

    test('deleteOlderThan_removesCorrectRows', () async {
      await database.voiceSessionHistoryDao.insertTurn(
        makeTurn(id: 'old', createdAt: baseTime - 1000),
      );
      await database.voiceSessionHistoryDao.insertTurn(
        makeTurn(id: 'new', createdAt: baseTime + 1000),
      );

      await database.voiceSessionHistoryDao.deleteOlderThan(
        profileId,
        baseTime, // cutoff: delete rows with createdAt < baseTime
      );

      final rows = await database.voiceSessionHistoryDao.getRecentTurns(
        profileId,
        0,
      );
      expect(rows.length, 1);
      expect(rows.first.id, 'new');
    });

    test('deleteOlderThan_onlyDeletesForCorrectProfile', () async {
      await database.voiceSessionHistoryDao.insertTurn(
        makeTurn(id: 't1', createdAt: baseTime - 1000),
      );
      await database.voiceSessionHistoryDao.insertTurn(
        makeTurn(id: 't2', createdAt: baseTime - 1000, pId: 'profile-002'),
      );

      await database.voiceSessionHistoryDao.deleteOlderThan(
        'profile-001',
        baseTime,
      );

      final p1Rows = await database.voiceSessionHistoryDao.getRecentTurns(
        'profile-001',
        0,
      );
      final p2Rows = await database.voiceSessionHistoryDao.getRecentTurns(
        'profile-002',
        0,
      );
      expect(p1Rows, isEmpty);
      expect(p2Rows.length, 1); // profile-002's row untouched
    });

    test('getRecentTurns_returnsChronologicalOrder', () async {
      await database.voiceSessionHistoryDao.insertTurn(
        makeTurn(id: 'later', createdAt: baseTime + 2000),
      );
      await database.voiceSessionHistoryDao.insertTurn(
        makeTurn(id: 'earlier', createdAt: baseTime + 1000),
      );

      final rows = await database.voiceSessionHistoryDao.getRecentTurns(
        profileId,
        0,
      );
      expect(rows.first.id, 'earlier');
      expect(rows.last.id, 'later');
    });
  });
}
