// lib/domain/usecases/profiles/create_profile_use_case.dart

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/profile.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/profile_repository.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/profiles/profile_inputs.dart';
import 'package:uuid/uuid.dart';

/// Use case to create a new Profile.
///
/// Pattern: validate → set ownerId from device → create entity → persist.
/// ownerId is always populated from the device ID so that the sync system
/// can later filter "my profiles" by ownerId (Phase 3 foundation).
class CreateProfileUseCase implements UseCase<CreateProfileInput, Profile> {
  final ProfileRepository _repository;
  final DeviceInfoService _deviceInfoService;

  CreateProfileUseCase(this._repository, this._deviceInfoService);

  @override
  Future<Result<Profile, AppError>> call(CreateProfileInput input) async {
    // 1. Validation
    final validationError = _validate(input);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 2. Populate ownerId from device — always set at creation time.
    final ownerId = await _deviceInfoService.getDeviceId();

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final profile = Profile(
      id: id,
      clientId: input.clientId,
      name: input.name.trim(),
      birthDate: input.birthDate,
      biologicalSex: input.biologicalSex,
      dietType: input.dietType,
      dietDescription: input.dietDescription,
      ethnicity: input.ethnicity,
      notes: input.notes,
      ownerId: ownerId,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(profile);
  }

  ValidationError? _validate(CreateProfileInput input) {
    final errors = <String, List<String>>{};

    final nameError = ValidationRules.entityName(
      input.name,
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
