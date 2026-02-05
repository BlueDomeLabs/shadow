// lib/data/datasources/local/daos/journal_entry_dao.dart
// Data Access Object for journal_entries table per 22_API_CONTRACTS.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/journal_entries_table.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';

part 'journal_entry_dao.g.dart';

/// Data Access Object for the journal_entries table.
@DriftAccessor(tables: [JournalEntries])
class JournalEntryDao extends DatabaseAccessor<AppDatabase>
    with _$JournalEntryDaoMixin {
  JournalEntryDao(super.db);

  /// Get all journal entries.
  Future<Result<List<domain.JournalEntry>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(journalEntries)
        ..where((j) => j.syncDeletedAt.isNull())
        ..orderBy([(j) => OrderingTerm.desc(j.timestamp)]);

      if (profileId != null) {
        query = query..where((j) => j.profileId.equals(profileId));
      }
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('journal_entries', e.toString(), stack),
      );
    }
  }

  /// Get a single journal entry by ID.
  Future<Result<domain.JournalEntry, AppError>> getById(String id) async {
    try {
      final query = select(journalEntries)
        ..where((j) => j.id.equals(id) & j.syncDeletedAt.isNull());

      final row = await query.getSingleOrNull();
      if (row == null) {
        return Failure(DatabaseError.notFound('JournalEntry', id));
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('journal_entries', e.toString(), stack),
      );
    }
  }

  /// Create a new journal entry.
  Future<Result<domain.JournalEntry, AppError>> create(
    domain.JournalEntry entity,
  ) async {
    try {
      final companion = _entityToCompanion(entity);
      await into(journalEntries).insert(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('journal_entries', e, stack));
    }
  }

  /// Update an existing journal entry.
  Future<Result<domain.JournalEntry, AppError>> updateEntity(
    domain.JournalEntry entity, {
    bool markDirty = true,
  }) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) return existsResult;

      final companion = _entityToCompanion(entity);
      await (update(
        journalEntries,
      )..where((j) => j.id.equals(entity.id))).write(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('journal_entries', entity.id, e, stack),
      );
    }
  }

  /// Soft delete a journal entry.
  Future<Result<void, AppError>> softDelete(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            journalEntries,
          )..where((j) => j.id.equals(id) & j.syncDeletedAt.isNull())).write(
            JournalEntriesCompanion(
              syncDeletedAt: Value(now),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.deleted.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('JournalEntry', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.deleteFailed('journal_entries', id, e, stack),
      );
    }
  }

  /// Hard delete a journal entry.
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        journalEntries,
      )..where((j) => j.id.equals(id))).go();
      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('JournalEntry', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.deleteFailed('journal_entries', id, e, stack),
      );
    }
  }

  /// Get journal entries by profile with filtering.
  Future<Result<List<domain.JournalEntry>, AppError>> getByProfile(
    String profileId, {
    int? startDate,
    int? endDate,
    List<String>? tags,
    int? mood,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(journalEntries)
        ..where((j) => j.profileId.equals(profileId) & j.syncDeletedAt.isNull())
        ..orderBy([(j) => OrderingTerm.desc(j.timestamp)]);

      if (startDate != null) {
        query = query
          ..where((j) => j.timestamp.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query = query..where((j) => j.timestamp.isSmallerOrEqualValue(endDate));
      }
      if (mood != null) {
        query = query..where((j) => j.mood.equals(mood));
      }
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();

      // Filter by tags if provided (done in memory since tags are comma-separated)
      var entries = rows.map(_rowToEntity).toList();
      if (tags != null && tags.isNotEmpty) {
        entries = entries
            .where(
              (e) => e.tags != null && tags.any((tag) => e.tags!.contains(tag)),
            )
            .toList();
      }

      return Success(entries);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('journal_entries', e.toString(), stack),
      );
    }
  }

  /// Search journal entries by content/title.
  Future<Result<List<domain.JournalEntry>, AppError>> search(
    String profileId,
    String query,
  ) async {
    try {
      final searchQuery = select(journalEntries)
        ..where(
          (j) =>
              j.profileId.equals(profileId) &
              j.syncDeletedAt.isNull() &
              (j.content.like('%$query%') | j.title.like('%$query%')),
        )
        ..orderBy([(j) => OrderingTerm.desc(j.timestamp)]);

      final rows = await searchQuery.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('journal_entries', e.toString(), stack),
      );
    }
  }

  /// Get mood distribution for a date range.
  Future<Result<Map<int, int>, AppError>> getMoodDistribution(
    String profileId, {
    required int startDate,
    required int endDate,
  }) async {
    try {
      final query = select(journalEntries)
        ..where(
          (j) =>
              j.profileId.equals(profileId) &
              j.syncDeletedAt.isNull() &
              j.mood.isNotNull() &
              j.timestamp.isBiggerOrEqualValue(startDate) &
              j.timestamp.isSmallerOrEqualValue(endDate),
        );

      final rows = await query.get();
      final distribution = <int, int>{};
      for (final row in rows) {
        if (row.mood != null) {
          distribution[row.mood!] = (distribution[row.mood!] ?? 0) + 1;
        }
      }
      return Success(distribution);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('journal_entries', e.toString(), stack),
      );
    }
  }

  /// Get modified since timestamp.
  Future<Result<List<domain.JournalEntry>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final query = select(journalEntries)
        ..where((j) => j.syncUpdatedAt.isBiggerThanValue(since))
        ..orderBy([(j) => OrderingTerm.asc(j.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('journal_entries', e.toString(), stack),
      );
    }
  }

  /// Get entries pending sync.
  Future<Result<List<domain.JournalEntry>, AppError>> getPendingSync() async {
    try {
      final query = select(journalEntries)
        ..where((j) => j.syncIsDirty.equals(true))
        ..orderBy([(j) => OrderingTerm.asc(j.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('journal_entries', e.toString(), stack),
      );
    }
  }

  /// Convert database row to domain entity.
  domain.JournalEntry _rowToEntity(JournalEntryRow row) => domain.JournalEntry(
    id: row.id,
    clientId: row.clientId,
    profileId: row.profileId,
    timestamp: row.timestamp,
    content: row.content,
    title: row.title,
    mood: row.mood,
    tags: _parseList(row.tags),
    audioUrl: row.audioUrl,
    syncMetadata: SyncMetadata(
      syncCreatedAt: row.syncCreatedAt,
      syncUpdatedAt: row.syncUpdatedAt ?? row.syncCreatedAt,
      syncDeletedAt: row.syncDeletedAt,
      syncLastSyncedAt: row.syncLastSyncedAt,
      syncStatus: SyncStatus.fromValue(row.syncStatus),
      syncVersion: row.syncVersion,
      syncDeviceId: row.syncDeviceId ?? '',
      syncIsDirty: row.syncIsDirty,
      conflictData: row.conflictData,
    ),
  );

  /// Convert domain entity to database companion.
  JournalEntriesCompanion _entityToCompanion(domain.JournalEntry entity) =>
      JournalEntriesCompanion(
        id: Value(entity.id),
        clientId: Value(entity.clientId),
        profileId: Value(entity.profileId),
        timestamp: Value(entity.timestamp),
        content: Value(entity.content),
        title: Value(entity.title),
        mood: Value(entity.mood),
        tags: Value(
          (entity.tags?.isNotEmpty ?? false) ? entity.tags!.join(',') : null,
        ),
        audioUrl: Value(entity.audioUrl),
        syncCreatedAt: Value(entity.syncMetadata.syncCreatedAt),
        syncUpdatedAt: Value(entity.syncMetadata.syncUpdatedAt),
        syncDeletedAt: Value(entity.syncMetadata.syncDeletedAt),
        syncLastSyncedAt: Value(entity.syncMetadata.syncLastSyncedAt),
        syncStatus: Value(entity.syncMetadata.syncStatus.value),
        syncVersion: Value(entity.syncMetadata.syncVersion),
        syncDeviceId: Value(entity.syncMetadata.syncDeviceId),
        syncIsDirty: Value(entity.syncMetadata.syncIsDirty),
        conflictData: Value(entity.syncMetadata.conflictData),
      );

  /// Parse comma-separated string to list, returning null if empty.
  List<String>? _parseList(String? value) {
    if (value == null || value.isEmpty) return null;
    final result = value.split(',').where((s) => s.isNotEmpty).toList();
    return result.isEmpty ? null : result;
  }
}
