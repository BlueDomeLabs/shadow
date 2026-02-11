// lib/domain/usecases/photo_areas/update_photo_area_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/repositories/photo_area_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/photo_areas/photo_area_inputs.dart';

/// Use case to update an existing photo area.
class UpdatePhotoAreaUseCase
    implements UseCase<UpdatePhotoAreaInput, PhotoArea> {
  final PhotoAreaRepository _repository;
  final ProfileAuthorizationService _authService;

  UpdatePhotoAreaUseCase(this._repository, this._authService);

  @override
  Future<Result<PhotoArea, AppError>> call(UpdatePhotoAreaInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch existing entity
    final existingResult = await _repository.getById(input.id);
    if (existingResult.isFailure) {
      return Failure(existingResult.errorOrNull!);
    }

    final existing = existingResult.valueOrNull!;

    // Verify the area belongs to the profile
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Apply updates
    final updated = existing.copyWith(
      name: input.name ?? existing.name,
      description: input.description ?? existing.description,
      consistencyNotes: input.consistencyNotes ?? existing.consistencyNotes,
    );

    // 4. Validation
    final validationError = _validate(updated);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 5. Persist
    return _repository.update(updated);
  }

  ValidationError? _validate(PhotoArea area) {
    final errors = <String, List<String>>{};

    // Name validation
    if (area.name.length < ValidationRules.nameMinLength ||
        area.name.length > ValidationRules.photoAreaNameMaxLength) {
      errors['name'] = [
        'Area name must be ${ValidationRules.nameMinLength}-${ValidationRules.photoAreaNameMaxLength} characters',
      ];
    }

    // Description max length
    if (area.description != null &&
        area.description!.length > ValidationRules.descriptionMaxLength) {
      errors['description'] = [
        'Description must be ${ValidationRules.descriptionMaxLength} characters or less',
      ];
    }

    // Consistency notes max length
    if (area.consistencyNotes != null &&
        area.consistencyNotes!.length >
            ValidationRules.consistencyNotesMaxLength) {
      errors['consistencyNotes'] = [
        'Consistency notes must be ${ValidationRules.consistencyNotesMaxLength} characters or less',
      ];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
