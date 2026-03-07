// lib/data/datasources/local/daos/voice_logging_settings_dao.dart
// Per VOICE_LOGGING_SPEC.md Section 2.1

import 'package:drift/drift.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/voice_logging_settings_table.dart';

part 'voice_logging_settings_dao.g.dart';

/// Data Access Object for the voice_logging_settings table.
///
/// Returns raw table rows. Conversion to domain entities is handled in
/// VoiceLoggingRepositoryImpl.
@DriftAccessor(tables: [VoiceLoggingSettingsTable])
class VoiceLoggingSettingsDao extends DatabaseAccessor<AppDatabase>
    with _$VoiceLoggingSettingsDaoMixin {
  VoiceLoggingSettingsDao(super.db);

  /// Fetch the settings row for a profile, or null if none exists.
  Future<VoiceLoggingSettingsRow?> getByProfileId(String profileId) => (select(
    voiceLoggingSettingsTable,
  )..where((t) => t.profileId.equals(profileId))).getSingleOrNull();

  /// Insert or update the settings row for a profile.
  Future<void> upsert(VoiceLoggingSettingsTableCompanion data) =>
      into(voiceLoggingSettingsTable).insertOnConflictUpdate(data);
}
