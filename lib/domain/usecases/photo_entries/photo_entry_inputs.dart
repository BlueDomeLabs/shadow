// lib/domain/usecases/photo_entries/photo_entry_inputs.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo_entry_inputs.freezed.dart';

@freezed
class CreatePhotoEntryInput with _$CreatePhotoEntryInput {
  const factory CreatePhotoEntryInput({
    required String profileId,
    required String clientId,
    required String photoAreaId,
    required int timestamp, // Epoch milliseconds
    required String filePath,
    String? notes,
    int? fileSizeBytes,
    String? fileHash,
  }) = _CreatePhotoEntryInput;
}

@freezed
class GetPhotoEntriesByAreaInput with _$GetPhotoEntriesByAreaInput {
  const factory GetPhotoEntriesByAreaInput({
    required String profileId,
    required String photoAreaId,
    int? startDate, // Epoch milliseconds
    int? endDate, // Epoch milliseconds
    int? limit,
    int? offset,
  }) = _GetPhotoEntriesByAreaInput;
}

@freezed
class GetPhotoEntriesInput with _$GetPhotoEntriesInput {
  const factory GetPhotoEntriesInput({
    required String profileId,
    int? startDate, // Epoch milliseconds
    int? endDate, // Epoch milliseconds
    int? limit,
    int? offset,
  }) = _GetPhotoEntriesInput;
}

@freezed
class DeletePhotoEntryInput with _$DeletePhotoEntryInput {
  const factory DeletePhotoEntryInput({
    required String id,
    required String profileId,
  }) = _DeletePhotoEntryInput;
}
