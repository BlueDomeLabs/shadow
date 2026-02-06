// lib/domain/usecases/photo_entries/create_photo_entry_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/photo_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/photo_area_repository.dart';
import 'package:shadow_app/domain/repositories/photo_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/photo_entries/photo_entry_inputs.dart';
import 'package:uuid/uuid.dart';

/// Use case to create a new photo entry.
class CreatePhotoEntryUseCase
    implements UseCase<CreatePhotoEntryInput, PhotoEntry> {
  final PhotoEntryRepository _repository;
  final PhotoAreaRepository _areaRepository;
  final ProfileAuthorizationService _authService;

  CreatePhotoEntryUseCase(
    this._repository,
    this._areaRepository,
    this._authService,
  );

  @override
  Future<Result<PhotoEntry, AppError>> call(CreatePhotoEntryInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationResult = await _validate(input);
    if (validationResult != null) {
      return Failure(validationResult);
    }

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final entry = PhotoEntry(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      photoAreaId: input.photoAreaId,
      timestamp: input.timestamp,
      filePath: input.filePath,
      notes: input.notes,
      fileSizeBytes: input.fileSizeBytes,
      fileHash: input.fileHash,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(entry);
  }

  Future<ValidationError?> _validate(CreatePhotoEntryInput input) async {
    final errors = <String, List<String>>{};

    // File path required
    if (input.filePath.isEmpty) {
      errors['filePath'] = ['File path is required'];
    }

    // Verify photo area exists and belongs to profile
    final areaResult = await _areaRepository.getById(input.photoAreaId);
    if (areaResult.isFailure) {
      errors['photoAreaId'] = ['Photo area not found'];
    } else {
      final area = areaResult.valueOrNull!;
      if (area.profileId != input.profileId) {
        errors['photoAreaId'] = ['Photo area does not belong to this profile'];
      }
    }

    // Timestamp validation (not more than 1 hour in future)
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneHourFromNow = now + (60 * 60 * 1000);
    if (input.timestamp > oneHourFromNow) {
      errors['timestamp'] = [
        'Timestamp cannot be more than 1 hour in the future',
      ];
    }

    // Notes max length
    if (input.notes != null && input.notes!.length > 2000) {
      errors['notes'] = ['Notes must be 2000 characters or less'];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
