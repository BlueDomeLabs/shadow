// lib/data/repositories/food_item_repository_impl.dart - EXACT IMPLEMENTATION FROM 02_CODING_STANDARDS.md Section 3.2

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/repositories/base_repository.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/food_item_dao.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/food_item_repository.dart';
import 'package:uuid/uuid.dart';

/// Repository implementation for FoodItem entities.
///
/// Extends BaseRepository for sync support and implements FoodItemRepository
/// interface per 02_CODING_STANDARDS.md Section 3.2.
class FoodItemRepositoryImpl extends BaseRepository<FoodItem>
    implements FoodItemRepository {
  final FoodItemDao _dao;

  FoodItemRepositoryImpl(
    this._dao,
    Uuid uuid,
    DeviceInfoService deviceInfoService,
  ) : super(uuid, deviceInfoService);

  @override
  Future<Result<List<FoodItem>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) => _dao.getAll(profileId: profileId, limit: limit, offset: offset);

  @override
  Future<Result<FoodItem, AppError>> getById(String id) => _dao.getById(id);

  @override
  Future<Result<FoodItem, AppError>> create(FoodItem entity) async {
    // Prepare entity with ID and sync metadata if needed
    final preparedEntity = await prepareForCreate(
      entity,
      (id, syncMetadata) => entity.copyWith(id: id, syncMetadata: syncMetadata),
      existingId: entity.id.isEmpty ? null : entity.id,
    );

    return _dao.create(preparedEntity);
  }

  @override
  Future<Result<FoodItem, AppError>> update(
    FoodItem entity, {
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
  Future<Result<List<FoodItem>, AppError>> getModifiedSince(int since) =>
      _dao.getModifiedSince(since);

  @override
  Future<Result<List<FoodItem>, AppError>> getPendingSync() =>
      _dao.getPendingSync();

  @override
  Future<Result<List<FoodItem>, AppError>> getByProfile(
    String profileId, {
    FoodItemType? type,
    bool includeArchived = false,
  }) => _dao.getByProfile(
    profileId,
    type: type,
    includeArchived: includeArchived,
  );

  @override
  Future<Result<List<FoodItem>, AppError>> search(
    String profileId,
    String query, {
    int limit = 20,
  }) => _dao.search(profileId, query, limit: limit);

  @override
  Future<Result<void, AppError>> archive(String id) => _dao.archive(id);

  @override
  Future<Result<List<FoodItem>, AppError>> searchExcludingCategories(
    String profileId,
    String query, {
    required List<String> excludeCategories,
    int limit = 20,
  }) =>
      // TODO: Implement category filtering when FoodItemCategory junction is available
      _dao.search(profileId, query, limit: limit);
}
