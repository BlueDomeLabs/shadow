// lib/data/repositories/voice_logging_repository_impl.dart
// Per VOICE_LOGGING_SPEC.md Section 4

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/voice_logging_settings_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/voice_session_history_dao.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/voice_logging/voice_logging_settings.dart';
import 'package:shadow_app/domain/entities/voice_logging/voice_session_turn.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/voice_logging_repository.dart';

/// Repository implementation for voice logging persistence.
class VoiceLoggingRepositoryImpl implements VoiceLoggingRepository {
  final VoiceLoggingSettingsDao _settingsDao;
  final VoiceSessionHistoryDao _historyDao;

  VoiceLoggingRepositoryImpl(this._settingsDao, this._historyDao);

  // 90 days in milliseconds
  static const int _retentionMs = 90 * 24 * 60 * 60 * 1000;

  @override
  Future<Result<VoiceLoggingSettings?, AppError>> getSettings(
    String profileId,
  ) async {
    try {
      final row = await _settingsDao.getByProfileId(profileId);
      return Success(row == null ? null : _rowToSettings(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed(
          'voice_logging_settings',
          e.toString(),
          stack,
        ),
      );
    }
  }

  @override
  Future<Result<void, AppError>> saveSettings(
    VoiceLoggingSettings settings,
  ) async {
    try {
      await _settingsDao.upsert(_settingsToCompanion(settings));
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.insertFailed('voice_logging_settings', e, stack),
      );
    }
  }

  @override
  Future<Result<List<VoiceSessionTurn>, AppError>> getRecentTurns(
    String profileId, {
    int daysBack = 14,
  }) async {
    try {
      final cutoff =
          DateTime.now().millisecondsSinceEpoch -
          (daysBack * 24 * 60 * 60 * 1000);
      final rows = await _historyDao.getRecentTurns(profileId, cutoff);
      return Success(rows.map(_rowToTurn).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('voice_session_history', e.toString(), stack),
      );
    }
  }

  @override
  Future<Result<void, AppError>> saveTurn(VoiceSessionTurn turn) async {
    try {
      await _historyDao.insertTurn(_turnToCompanion(turn));
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.insertFailed('voice_session_history', e, stack),
      );
    }
  }

  @override
  Future<Result<void, AppError>> pruneOldTurns(String profileId) async {
    try {
      final cutoff = DateTime.now().millisecondsSinceEpoch - _retentionMs;
      await _historyDao.deleteOlderThan(profileId, cutoff);
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.deleteFailed(
          'voice_session_history',
          profileId,
          e,
          stack,
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Conversions
  // ---------------------------------------------------------------------------

  VoiceLoggingSettings _rowToSettings(VoiceLoggingSettingsRow row) {
    List<int>? priorityOrder;
    if (row.categoryPriorityOrder != null) {
      final decoded = jsonDecode(row.categoryPriorityOrder!) as List<dynamic>;
      priorityOrder = decoded.cast<int>();
    }

    return VoiceLoggingSettings(
      id: row.id,
      profileId: row.profileId,
      closingStyle: ClosingStyle.fromInt(row.closingStyle),
      fixedFarewell: row.fixedFarewell,
      categoryPriorityOrder: priorityOrder,
      defaultInputMode: DefaultInputMode.fromInt(row.defaultInputMode),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  VoiceLoggingSettingsTableCompanion _settingsToCompanion(
    VoiceLoggingSettings s,
  ) {
    final encodedOrder = s.categoryPriorityOrder != null
        ? jsonEncode(s.categoryPriorityOrder)
        : null;

    return VoiceLoggingSettingsTableCompanion(
      id: Value(s.id),
      profileId: Value(s.profileId),
      closingStyle: Value(s.closingStyle.toInt()),
      fixedFarewell: Value(s.fixedFarewell),
      categoryPriorityOrder: Value(encodedOrder),
      defaultInputMode: Value(s.defaultInputMode.toInt()),
      createdAt: Value(s.createdAt),
      updatedAt: Value(s.updatedAt),
    );
  }

  VoiceSessionTurn _rowToTurn(VoiceSessionHistoryRow row) => VoiceSessionTurn(
    id: row.id,
    profileId: row.profileId,
    sessionId: row.sessionId,
    turnIndex: row.turnIndex,
    role: VoiceTurnRole.fromInt(row.role),
    content: row.content,
    loggedItemType: row.loggedItemType != null
        ? LoggableItemType.fromInt(row.loggedItemType!)
        : null,
    createdAt: row.createdAt,
  );

  VoiceSessionHistoryTableCompanion _turnToCompanion(VoiceSessionTurn turn) =>
      VoiceSessionHistoryTableCompanion(
        id: Value(turn.id),
        profileId: Value(turn.profileId),
        sessionId: Value(turn.sessionId),
        turnIndex: Value(turn.turnIndex),
        role: Value(turn.role.toInt()),
        content: Value(turn.content),
        loggedItemType: Value(turn.loggedItemType?.toInt()),
        createdAt: Value(turn.createdAt),
      );
}
