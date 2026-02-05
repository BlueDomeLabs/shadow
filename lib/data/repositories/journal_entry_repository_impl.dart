// lib/data/repositories/journal_entry_repository_impl.dart
// EXACT IMPLEMENTATION FROM 02_CODING_STANDARDS.md Section 3.2

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/repositories/base_repository.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/journal_entry_dao.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/repositories/journal_entry_repository.dart';
import 'package:uuid/uuid.dart';

/// Repository implementation for JournalEntry entities.
///
/// Extends BaseRepository for sync support and implements JournalEntryRepository
/// interface per 02_CODING_STANDARDS.md Section 3.2.
class JournalEntryRepositoryImpl extends BaseRepository<JournalEntry>
    implements JournalEntryRepository {
  final JournalEntryDao _dao;

  JournalEntryRepositoryImpl(
    this._dao,
    Uuid uuid,
    DeviceInfoService deviceInfoService,
  ) : super(uuid, deviceInfoService);

  @override
  Future<Result<List<JournalEntry>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) => _dao.getAll(profileId: profileId, limit: limit, offset: offset);

  @override
  Future<Result<JournalEntry, AppError>> getById(String id) => _dao.getById(id);

  @override
  Future<Result<JournalEntry, AppError>> create(JournalEntry entity) async {
    // Prepare entity with ID and sync metadata if needed
    final preparedEntity = await prepareForCreate(
      entity,
      (id, syncMetadata) => entity.copyWith(id: id, syncMetadata: syncMetadata),
      existingId: entity.id.isEmpty ? null : entity.id,
    );

    return _dao.create(preparedEntity);
  }

  @override
  Future<Result<JournalEntry, AppError>> update(
    JournalEntry entity, {
    bool markDirty = true,
  }) async {
    // Prepare entity with updated sync metadata
    final preparedEntity = await prepareForUpdate(
      entity,
      (syncMetadata) => entity.copyWith(syncMetadata: syncMetadata),
      markDirty: markDirty,
      getSyncMetadata: (e) => e.syncMetadata,
    );

    return _dao.updateEntity(preparedEntity, markDirty: markDirty);
  }

  @override
  Future<Result<void, AppError>> delete(String id) => _dao.softDelete(id);

  @override
  Future<Result<void, AppError>> hardDelete(String id) => _dao.hardDelete(id);

  @override
  Future<Result<List<JournalEntry>, AppError>> getModifiedSince(int since) =>
      _dao.getModifiedSince(since);

  @override
  Future<Result<List<JournalEntry>, AppError>> getPendingSync() =>
      _dao.getPendingSync();

  @override
  Future<Result<List<JournalEntry>, AppError>> getByProfile(
    String profileId, {
    int? startDate,
    int? endDate,
    List<String>? tags,
    int? mood,
    int? limit,
    int? offset,
  }) => _dao.getByProfile(
    profileId,
    startDate: startDate,
    endDate: endDate,
    tags: tags,
    mood: mood,
    limit: limit,
    offset: offset,
  );

  @override
  Future<Result<List<JournalEntry>, AppError>> search(
    String profileId,
    String query,
  ) => _dao.search(profileId, query);

  @override
  Future<Result<Map<int, int>, AppError>> getMoodDistribution(
    String profileId, {
    required int startDate,
    required int endDate,
  }) => _dao.getMoodDistribution(
    profileId,
    startDate: startDate,
    endDate: endDate,
  );
}
