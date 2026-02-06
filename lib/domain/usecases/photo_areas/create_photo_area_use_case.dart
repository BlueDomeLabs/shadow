// lib/domain/usecases/photo_areas/create_photo_area_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/photo_area_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/photo_areas/photo_area_inputs.dart';
import 'package:uuid/uuid.dart';

/// Use case to create a new photo area.
class CreatePhotoAreaUseCase
    implements UseCase<CreatePhotoAreaInput, PhotoArea> {
  final PhotoAreaRepository _repository;
  final ProfileAuthorizationService _authService;

  CreatePhotoAreaUseCase(this._repository, this._authService);

  @override
  Future<Result<PhotoArea, AppError>> call(CreatePhotoAreaInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationResult = _validate(input);
    if (validationResult != null) {
      return Failure(validationResult);
    }

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final area = PhotoArea(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      name: input.name,
      description: input.description,
      consistencyNotes: input.consistencyNotes,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(area);
  }

  ValidationError? _validate(CreatePhotoAreaInput input) {
    final errors = <String, List<String>>{};

    // Name validation: 2-100 characters
    if (input.name.length < 2 || input.name.length > 100) {
      errors['name'] = ['Area name must be 2-100 characters'];
    }

    // Description max length
    if (input.description != null && input.description!.length > 500) {
      errors['description'] = ['Description must be 500 characters or less'];
    }

    // Consistency notes max length
    if (input.consistencyNotes != null &&
        input.consistencyNotes!.length > 1000) {
      errors['consistencyNotes'] = [
        'Consistency notes must be 1000 characters or less',
      ];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
