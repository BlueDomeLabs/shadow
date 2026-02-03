// lib/core/repositories/base_repository.dart - EXACT IMPLEMENTATION FROM 05_IMPLEMENTATION_ROADMAP.md Section 2.6

import 'package:uuid/uuid.dart';

import '../../domain/entities/sync_metadata.dart';
import '../services/device_info_service.dart';

/// Base class for all repositories with sync support.
/// ALL repository implementations MUST extend this class.
abstract class BaseRepository<T> {
  final Uuid _uuid;
  final DeviceInfoService _deviceInfoService;

  BaseRepository(this._uuid, this._deviceInfoService);

  /// Generate ID if not provided or empty
  String generateId(String? existingId) {
    return existingId?.isNotEmpty == true ? existingId! : _uuid.v4();
  }

  /// Create fresh SyncMetadata for new entities
  Future<SyncMetadata> createSyncMetadata() async {
    final deviceId = await _deviceInfoService.getDeviceId();
    return SyncMetadata.create(deviceId: deviceId);
  }

  /// Prepare entity for creation (generate ID, create sync metadata)
  /// NOTE: These helpers return the prepared entity; the calling repository
  /// method wraps the result in `Result<T, AppError>`
  Future<E> prepareForCreate<E>(
    E entity,
    E Function(String id, SyncMetadata syncMetadata) copyWith, {
    String? existingId,
  }) async {
    final id = generateId(existingId);
    final syncMetadata = await createSyncMetadata();
    return copyWith(id, syncMetadata);
  }

  /// Prepare entity for update (update sync metadata)
  /// NOTE: These helpers return the prepared entity; the calling repository
  /// method wraps the result in `Result<T, AppError>`
  Future<E> prepareForUpdate<E>(
    E entity,
    E Function(SyncMetadata syncMetadata) copyWith, {
    bool markDirty = true,
    required SyncMetadata Function(E) getSyncMetadata,
  }) async {
    if (!markDirty) return entity;

    final deviceId = await _deviceInfoService.getDeviceId();
    final existingMetadata = getSyncMetadata(entity);
    final updatedMetadata = existingMetadata.markModified(deviceId);
    return copyWith(updatedMetadata);
  }

  /// Prepare entity for soft delete
  /// NOTE: These helpers return the prepared entity; the calling repository
  /// method wraps the result in `Result<T, AppError>`
  Future<E> prepareForDelete<E>(
    E entity,
    E Function(SyncMetadata syncMetadata) copyWith, {
    required SyncMetadata Function(E) getSyncMetadata,
  }) async {
    final deviceId = await _deviceInfoService.getDeviceId();
    final existingMetadata = getSyncMetadata(entity);
    final deletedMetadata = existingMetadata.markDeleted(deviceId);
    return copyWith(deletedMetadata);
  }
}
