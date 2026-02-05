// lib/data/repositories/fluids_entry_repository_impl.dart - EXACT IMPLEMENTATION FROM 02_CODING_STANDARDS.md Section 3.2

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/repositories/base_repository.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/fluids_entry_dao.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/repositories/fluids_entry_repository.dart';
import 'package:uuid/uuid.dart';

/// Repository implementation for FluidsEntry entities.
///
/// Extends BaseRepository for sync support and implements FluidsEntryRepository
/// interface per 02_CODING_STANDARDS.md Section 3.2.
class FluidsEntryRepositoryImpl extends BaseRepository<FluidsEntry>
    implements FluidsEntryRepository {
  final FluidsEntryDao _dao;

  FluidsEntryRepositoryImpl(
    this._dao,
    Uuid uuid,
    DeviceInfoService deviceInfoService,
  ) : super(uuid, deviceInfoService);

  @override
  Future<Result<List<FluidsEntry>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) => _dao.getAll(profileId: profileId);

  @override
  Future<Result<FluidsEntry, AppError>> getById(String id) => _dao.getById(id);

  @override
  Future<Result<FluidsEntry, AppError>> create(FluidsEntry entity) async {
    // Prepare entity with ID and sync metadata if needed
    final preparedEntity = await prepareForCreate(
      entity,
      (id, syncMetadata) => entity.copyWith(id: id, syncMetadata: syncMetadata),
      existingId: entity.id.isEmpty ? null : entity.id,
    );

    return _dao.create(preparedEntity);
  }

  @override
  Future<Result<FluidsEntry, AppError>> update(
    FluidsEntry entity, {
    bool markDirty = true,
  }) async {
    // Prepare entity with updated sync metadata
    final preparedEntity = await prepareForUpdate(
      entity,
      (syncMetadata) => entity.copyWith(syncMetadata: syncMetadata),
      markDirty: markDirty,
      getSyncMetadata: (e) => e.syncMetadata,
    );

    return _dao.updateEntity(preparedEntity);
  }

  @override
  Future<Result<void, AppError>> delete(String id) => _dao.softDelete(id);

  @override
  Future<Result<void, AppError>> hardDelete(String id) => _dao.hardDelete(id);

  @override
  Future<Result<List<FluidsEntry>, AppError>> getModifiedSince(int since) =>
      _dao.getModifiedSince(since);

  @override
  Future<Result<List<FluidsEntry>, AppError>> getPendingSync() =>
      _dao.getPendingSync();

  @override
  Future<Result<List<FluidsEntry>, AppError>> getByDateRange(
    String profileId,
    int start,
    int end,
  ) => _dao.getByDateRange(profileId, start, end);

  @override
  Future<Result<List<FluidsEntry>, AppError>> getBBTEntries(
    String profileId,
    int start,
    int end,
  ) => _dao.getBBTEntries(profileId, start, end);

  @override
  Future<Result<List<FluidsEntry>, AppError>> getMenstruationEntries(
    String profileId,
    int start,
    int end,
  ) => _dao.getMenstruationEntries(profileId, start, end);

  @override
  Future<Result<FluidsEntry?, AppError>> getTodayEntry(String profileId) async {
    // Get start and end of today in epoch ms
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final result = await _dao.getByDateRange(
      profileId,
      startOfDay.millisecondsSinceEpoch,
      endOfDay.millisecondsSinceEpoch,
    );

    return result.when(
      success: (entries) => Success(entries.isNotEmpty ? entries.first : null),
      failure: Failure.new,
    );
  }
}
