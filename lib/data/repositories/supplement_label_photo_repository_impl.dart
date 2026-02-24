// lib/data/repositories/supplement_label_photo_repository_impl.dart
// Phase 15a — Data layer implementation for supplement label photos

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/supplement_label_photo_dao.dart';
import 'package:shadow_app/domain/entities/supplement_label_photo.dart';
import 'package:shadow_app/domain/repositories/supplement_label_photo_repository.dart';

/// Repository implementation delegating to [SupplementLabelPhotoDao].
class SupplementLabelPhotoRepositoryImpl
    implements SupplementLabelPhotoRepository {
  final SupplementLabelPhotoDao _dao;

  SupplementLabelPhotoRepositoryImpl(this._dao);

  @override
  Future<Result<List<SupplementLabelPhoto>, AppError>> getForSupplement(
    String supplementId,
  ) => _dao.getForSupplement(supplementId);

  @override
  Future<Result<SupplementLabelPhoto, AppError>> add(
    SupplementLabelPhoto photo,
  ) => _dao.add(photo);

  @override
  Future<Result<void, AppError>> deleteById(String id) => _dao.deleteById(id);

  @override
  Future<void> deleteForSupplement(String supplementId) =>
      _dao.deleteForSupplement(supplementId);
}
