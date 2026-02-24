// lib/domain/usecases/supplements/add_supplement_label_photo_use_case.dart
// Phase 15a — Save a label photo for a supplement
// Per 60_SUPPLEMENT_EXTENSION.md

import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/supplement_label_photo.dart';
import 'package:shadow_app/domain/repositories/supplement_label_photo_repository.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:uuid/uuid.dart';

/// Input for AddSupplementLabelPhotoUseCase.
class AddSupplementLabelPhotoInput {
  final String supplementId;
  final Uint8List imageBytes;

  const AddSupplementLabelPhotoInput({
    required this.supplementId,
    required this.imageBytes,
  });
}

/// Saves a label photo to local storage and creates a database record.
///
/// Up to 3 photos per supplement (enforced at this use case level).
class AddSupplementLabelPhotoUseCase
    implements UseCase<AddSupplementLabelPhotoInput, SupplementLabelPhoto> {
  final SupplementLabelPhotoRepository _repository;

  AddSupplementLabelPhotoUseCase(this._repository);

  @override
  Future<Result<SupplementLabelPhoto, AppError>> call(
    AddSupplementLabelPhotoInput input,
  ) async {
    // 1. Check photo limit
    final existing = await _repository.getForSupplement(input.supplementId);
    if (existing.isSuccess && existing.valueOrNull!.length >= 3) {
      return Failure(
        ValidationError.fromFieldErrors({
          'photos': ['Maximum 3 label photos per supplement'],
        }),
      );
    }

    // 2. Determine sort order
    final sortOrder = existing.isSuccess ? existing.valueOrNull!.length : 0;

    // 3. Save image to local storage
    final filePath = await _saveImage(input.supplementId, input.imageBytes);
    if (filePath == null) {
      return Failure(
        DatabaseError.insertFailed(
          'supplement_label_photos',
          Exception('Failed to save photo to local storage'),
          StackTrace.current,
        ),
      );
    }

    // 4. Create and persist record
    final now = DateTime.now().millisecondsSinceEpoch;
    final photo = SupplementLabelPhoto(
      id: const Uuid().v4(),
      supplementId: input.supplementId,
      filePath: filePath,
      capturedAt: now,
      sortOrder: sortOrder,
    );

    return _repository.add(photo);
  }

  /// Saves image bytes to app documents directory.
  /// Returns the file path, or null on failure.
  Future<String?> _saveImage(String supplementId, Uint8List imageBytes) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final photoDir = Directory('${dir.path}/supplement_photos/$supplementId');
      await photoDir.create(recursive: true);

      final fileName = '${const Uuid().v4()}.jpg';
      final file = File('${photoDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);
      return file.path;
    } on Exception {
      return null;
    }
  }
}
