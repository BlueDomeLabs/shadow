// lib/domain/usecases/photo_areas/photo_area_inputs.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo_area_inputs.freezed.dart';

@freezed
class CreatePhotoAreaInput with _$CreatePhotoAreaInput {
  const factory CreatePhotoAreaInput({
    required String profileId,
    required String clientId,
    required String name,
    String? description,
    String? consistencyNotes,
  }) = _CreatePhotoAreaInput;
}

@freezed
class GetPhotoAreasInput with _$GetPhotoAreasInput {
  const factory GetPhotoAreasInput({
    required String profileId,
    @Default(false) bool includeArchived,
  }) = _GetPhotoAreasInput;
}

@freezed
class UpdatePhotoAreaInput with _$UpdatePhotoAreaInput {
  const factory UpdatePhotoAreaInput({
    required String id,
    required String profileId,
    String? name,
    String? description,
    String? consistencyNotes,
  }) = _UpdatePhotoAreaInput;
}

@freezed
class ArchivePhotoAreaInput with _$ArchivePhotoAreaInput {
  const factory ArchivePhotoAreaInput({
    required String id,
    required String profileId,
    @Default(true) bool archive,
  }) = _ArchivePhotoAreaInput;
}
