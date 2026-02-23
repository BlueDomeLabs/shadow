// lib/data/repositories/anchor_event_time_repository_impl.dart
// Repository implementation for AnchorEventTime per 57_NOTIFICATION_SYSTEM.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/anchor_event_time_dao.dart';
import 'package:shadow_app/domain/entities/anchor_event_time.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';
import 'package:shadow_app/domain/repositories/anchor_event_time_repository.dart';

/// Implementation of AnchorEventTimeRepository.
///
/// Delegates directly to AnchorEventTimeDao. AnchorEventTime is a
/// local settings entity with no sync metadata.
class AnchorEventTimeRepositoryImpl implements AnchorEventTimeRepository {
  final AnchorEventTimeDao _dao;

  AnchorEventTimeRepositoryImpl(this._dao);

  @override
  Future<Result<List<AnchorEventTime>, AppError>> getAll() => _dao.getAll();

  @override
  Future<Result<AnchorEventTime?, AppError>> getByName(AnchorEventName name) =>
      _dao.getByName(name);

  @override
  Future<Result<AnchorEventTime, AppError>> getById(String id) =>
      _dao.getById(id);

  @override
  Future<Result<AnchorEventTime, AppError>> create(AnchorEventTime event) =>
      _dao.insert(event);

  @override
  Future<Result<AnchorEventTime, AppError>> update(AnchorEventTime event) =>
      _dao.updateEntity(event);
}
