// test/unit/data/datasources/local/daos/fasting_session_dao_test.dart
// Phase 15b-1 — Tests for FastingSessionDao
// Per 59_DIET_TRACKING.md

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/fasting_session.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('FastingSessionDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    FastingSession createTestSession({
      String? id,
      String profileId = 'profile-001',
      DietPresetType protocol = DietPresetType.if168,
      int? startedAt,
      int? endedAt,
      double targetHours = 16.0,
      bool isManualEnd = false,
      int? syncCreatedAt,
      bool syncIsDirty = true,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return FastingSession(
        id: id ?? 'fast-${DateTime.now().microsecondsSinceEpoch}',
        clientId: 'client-001',
        profileId: profileId,
        protocol: protocol,
        startedAt: startedAt ?? now,
        endedAt: endedAt,
        targetHours: targetHours,
        isManualEnd: isManualEnd,
        syncMetadata: SyncMetadata(
          syncCreatedAt: syncCreatedAt ?? now,
          syncUpdatedAt: syncCreatedAt ?? now,
          syncDeviceId: 'test-device',
          syncIsDirty: syncIsDirty,
        ),
      );
    }

    group('create', () {
      test('create_validSession_returnsSuccess', () async {
        final session = createTestSession(id: 'fast-001');

        final result = await database.fastingSessionDao.create(session);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'fast-001');
        expect(result.valueOrNull?.protocol, DietPresetType.if168);
        expect(result.valueOrNull?.targetHours, 16.0);
      });

      test('create_duplicateId_returnsFailure', () async {
        final s1 = createTestSession(id: 'fast-dup');
        final s2 = createTestSession(id: 'fast-dup');

        await database.fastingSessionDao.create(s1);
        final result = await database.fastingSessionDao.create(s2);

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeConstraintViolation,
        );
      });

      test('create_activeSession_hasNullEndedAt', () async {
        final session = createTestSession(id: 'fast-active');

        final result = await database.fastingSessionDao.create(session);

        expect(result.valueOrNull?.endedAt, isNull);
        expect(result.valueOrNull?.isActive, isTrue);
      });
    });

    group('getById', () {
      test('getById_existingSession_returnsSuccess', () async {
        final session = createTestSession(id: 'fast-get');
        await database.fastingSessionDao.create(session);

        final result = await database.fastingSessionDao.getById('fast-get');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'fast-get');
      });

      test('getById_notFound_returnsFailure', () async {
        final result = await database.fastingSessionDao.getById('nonexistent');

        expect(result.isFailure, isTrue);
        expect(
          (result.errorOrNull! as DatabaseError).code,
          DatabaseError.codeNotFound,
        );
      });
    });

    group('getByProfile', () {
      test('getByProfile_returnsSessionsForProfile', () async {
        final s1 = createTestSession(id: 'fast-p1a');
        final s2 = createTestSession(id: 'fast-p1b');
        final s3 = createTestSession(id: 'fast-p2', profileId: 'profile-002');

        await database.fastingSessionDao.create(s1);
        await database.fastingSessionDao.create(s2);
        await database.fastingSessionDao.create(s3);

        final result = await database.fastingSessionDao.getByProfile(
          'profile-001',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.length, 2);
      });

      test('getByProfile_withLimit_limitsResults', () async {
        for (var i = 0; i < 5; i++) {
          await database.fastingSessionDao.create(
            createTestSession(id: 'fast-limit-$i'),
          );
        }

        final result = await database.fastingSessionDao.getByProfile(
          'profile-001',
          limit: 3,
        );

        expect(result.valueOrNull?.length, 3);
      });
    });

    group('getActiveFast', () {
      test('getActiveFast_activeSessionExists_returnsIt', () async {
        final ended = createTestSession(
          id: 'fast-ended',
          endedAt: DateTime.now().millisecondsSinceEpoch,
        );
        final active = createTestSession(id: 'fast-active');

        await database.fastingSessionDao.create(ended);
        await database.fastingSessionDao.create(active);

        final result = await database.fastingSessionDao.getActiveFast(
          'profile-001',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'fast-active');
      });

      test('getActiveFast_noActiveFast_returnsNull', () async {
        final ended = createTestSession(
          id: 'fast-done',
          endedAt: DateTime.now().millisecondsSinceEpoch,
        );
        await database.fastingSessionDao.create(ended);

        final result = await database.fastingSessionDao.getActiveFast(
          'profile-001',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });
    });

    group('updateEntity', () {
      test('updateEntity_setsEndedAt', () async {
        final session = createTestSession(id: 'fast-upd');
        await database.fastingSessionDao.create(session);

        final endTime = DateTime.now().millisecondsSinceEpoch;
        final updated = session.copyWith(endedAt: endTime, isManualEnd: true);
        final result = await database.fastingSessionDao.updateEntity(updated);

        expect(result.valueOrNull?.endedAt, endTime);
        expect(result.valueOrNull?.isManualEnd, isTrue);
        expect(result.valueOrNull?.isActive, isFalse);
      });
    });

    group('softDelete', () {
      test('softDelete_existingSession_hidesFromQueries', () async {
        final session = createTestSession(id: 'fast-del');
        await database.fastingSessionDao.create(session);

        await database.fastingSessionDao.softDelete('fast-del');

        final result = await database.fastingSessionDao.getById('fast-del');
        expect(result.isFailure, isTrue);
      });

      test('softDelete_notFound_returnsFailure', () async {
        final result = await database.fastingSessionDao.softDelete(
          'nonexistent',
        );

        expect(result.isFailure, isTrue);
      });
    });

    group('hardDelete', () {
      test('hardDelete_existingSession_returnsSuccess', () async {
        final session = createTestSession(id: 'fast-hard');
        await database.fastingSessionDao.create(session);

        final result = await database.fastingSessionDao.hardDelete('fast-hard');

        expect(result.isSuccess, isTrue);
      });

      test('hardDelete_notFound_returnsFailure', () async {
        final result = await database.fastingSessionDao.hardDelete(
          'nonexistent',
        );

        expect(result.isFailure, isTrue);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_returnsModifiedAfterTimestamp', () async {
        final past = DateTime.now().millisecondsSinceEpoch - 10000;
        final old = createTestSession(id: 'fast-old', syncCreatedAt: past);
        final fresh = createTestSession(
          id: 'fast-fresh',
          syncCreatedAt: DateTime.now().millisecondsSinceEpoch,
        );
        await database.fastingSessionDao.create(old);
        await database.fastingSessionDao.create(fresh);

        final result = await database.fastingSessionDao.getModifiedSince(
          past + 5000,
        );

        expect(result.valueOrNull?.any((s) => s.id == 'fast-fresh'), isTrue);
        expect(result.valueOrNull?.any((s) => s.id == 'fast-old'), isFalse);
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_returnsOnlyDirtySessions', () async {
        final dirty = createTestSession(id: 'fast-dirty');
        final clean = createTestSession(id: 'fast-clean', syncIsDirty: false);
        await database.fastingSessionDao.create(dirty);
        await database.fastingSessionDao.create(clean);

        final result = await database.fastingSessionDao.getPendingSync();

        expect(result.valueOrNull?.any((s) => s.id == 'fast-dirty'), isTrue);
        expect(result.valueOrNull?.any((s) => s.id == 'fast-clean'), isFalse);
      });
    });
  });
}
