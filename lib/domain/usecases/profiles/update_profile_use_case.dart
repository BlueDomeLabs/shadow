// lib/domain/usecases/profiles/update_profile_use_case.dart

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/profile.dart';
import 'package:shadow_app/domain/repositories/profile_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/profiles/profile_inputs.dart';

/// Use case to update an existing Profile.
class UpdateProfileUseCase implements UseCase<UpdateProfileInput, Profile> {
  final ProfileRepository _repository;
  final ProfileAuthorizationService _authService;

  UpdateProfileUseCase(this._repository, this._authService);

  @override
  Future<Result<Profile, AppError>> call(UpdateProfileInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch existing profile (Failure returned if not found by DAO)
    final getResult = await _repository.getById(input.profileId);
    if (getResult case Failure(:final error)) {
      return Failure(error);
    }
    final existing = (getResult as Success<Profile, AppError>).value;

    // 3. Validation
    final nameToValidate = input.name ?? existing.name;
    final validationError = _validate(nameToValidate);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 4. Merge fields
    final now = DateTime.now().millisecondsSinceEpoch;
    final updated = existing.copyWith(
      name: input.name?.trim() ?? existing.name,
      birthDate: input.birthDate ?? existing.birthDate,
      biologicalSex: input.biologicalSex ?? existing.biologicalSex,
      dietType: input.dietType ?? existing.dietType,
      dietDescription: input.dietDescription ?? existing.dietDescription,
      ethnicity: input.ethnicity ?? existing.ethnicity,
      notes: input.notes ?? existing.notes,
      syncMetadata: existing.syncMetadata.copyWith(syncUpdatedAt: now),
    );

    // 5. Persist
    return _repository.update(updated);
  }

  ValidationError? _validate(String name) {
    final errors = <String, List<String>>{};

    final nameError = ValidationRules.entityName(
      name,
      'name',
      ValidationRules.nameMaxLength,
    );
    if (nameError != null) errors['name'] = [nameError];

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
