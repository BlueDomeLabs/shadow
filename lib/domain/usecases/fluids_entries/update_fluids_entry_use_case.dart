// lib/domain/usecases/fluids_entries/update_fluids_entry_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 4.5.1

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/repositories/fluids_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/fluids_entries/fluids_entry_inputs.dart';

/// Use case to update an existing fluids entry.
///
/// Follows the standard pattern:
/// 1. Authorization - Check profile access FIRST
/// 2. Fetch existing - Verify entity exists and belongs to profile
/// 3. Validation - Validate input
/// 4. Apply updates - Merge changes
/// 5. Repository Call - Execute operation
class UpdateFluidsEntryUseCase
    implements UseCase<UpdateFluidsEntryInput, FluidsEntry> {
  final FluidsEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  UpdateFluidsEntryUseCase(this._repository, this._authService);

  @override
  Future<Result<FluidsEntry, AppError>> call(
    UpdateFluidsEntryInput input,
  ) async {
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

    // Verify entity belongs to the profile
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Validation
    final validationError = _validate(input, existing);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 4. Apply updates (only non-null values)
    final updated = existing.copyWith(
      waterIntakeMl: input.waterIntakeMl ?? existing.waterIntakeMl,
      waterIntakeNotes: input.waterIntakeNotes ?? existing.waterIntakeNotes,
      bowelCondition: input.bowelCondition ?? existing.bowelCondition,
      bowelSize: input.bowelSize ?? existing.bowelSize,
      bowelPhotoPath: input.bowelPhotoPath ?? existing.bowelPhotoPath,
      urineCondition: input.urineCondition ?? existing.urineCondition,
      urineSize: input.urineSize ?? existing.urineSize,
      urinePhotoPath: input.urinePhotoPath ?? existing.urinePhotoPath,
      menstruationFlow: input.menstruationFlow ?? existing.menstruationFlow,
      basalBodyTemperature:
          input.basalBodyTemperature ?? existing.basalBodyTemperature,
      bbtRecordedTime: input.bbtRecordedTime ?? existing.bbtRecordedTime,
      otherFluidName: input.otherFluidName ?? existing.otherFluidName,
      otherFluidAmount: input.otherFluidAmount ?? existing.otherFluidAmount,
      otherFluidNotes: input.otherFluidNotes ?? existing.otherFluidNotes,
      notes: input.notes ?? existing.notes,
    );

    // 5. Persist
    return _repository.update(updated);
  }

  ValidationError? _validate(
    UpdateFluidsEntryInput input,
    FluidsEntry existing,
  ) {
    final errors = <String, List<String>>{};

    // Water intake validation (0 - 10,000 mL)
    final waterIntake = input.waterIntakeMl ?? existing.waterIntakeMl;
    if (waterIntake != null) {
      if (waterIntake < 0 || waterIntake > 10000) {
        errors['waterIntakeMl'] = [
          'Water intake must be between 0 and 10,000 mL',
        ];
      }
    }

    // BBT validation (95.0 - 105.0°F)
    final bbt = input.basalBodyTemperature ?? existing.basalBodyTemperature;
    if (bbt != null) {
      if (bbt < 95.0 || bbt > 105.0) {
        errors['basalBodyTemperature'] = [
          'BBT must be between 95.0 and 105.0°F',
        ];
      }
      // Recording time is required for BBT
      final recordedTime = input.bbtRecordedTime ?? existing.bbtRecordedTime;
      if (recordedTime == null) {
        errors['bbtRecordedTime'] = ['Recording time is required for BBT'];
      }
    }

    // Other fluid validation
    final otherAmount = input.otherFluidAmount ?? existing.otherFluidAmount;
    final otherNotes = input.otherFluidNotes ?? existing.otherFluidNotes;
    final otherName = input.otherFluidName ?? existing.otherFluidName;

    if ((otherAmount != null && otherAmount.isNotEmpty) ||
        (otherNotes != null && otherNotes.isNotEmpty)) {
      if (otherName == null || otherName.isEmpty) {
        errors['otherFluidName'] = [
          'Fluid name is required when amount or notes are provided',
        ];
      }
    }

    if (otherName != null && otherName.isNotEmpty) {
      if (otherName.length < 2 || otherName.length > 100) {
        errors['otherFluidName'] = ['Fluid name must be 2-100 characters'];
      } else if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(otherName)) {
        errors['otherFluidName'] = [
          'Fluid name can only contain letters, spaces, hyphens, and apostrophes',
        ];
      }
    }

    if (otherAmount != null && otherAmount.length > 50) {
      errors['otherFluidAmount'] = ['Amount must be 50 characters or less'];
    }

    if (otherNotes != null && otherNotes.length > 5000) {
      errors['otherFluidNotes'] = ['Notes must be 5000 characters or less'];
    }

    // General notes validation
    final notes = input.notes ?? existing.notes;
    if (notes.length > 2000) {
      errors['notes'] = ['Notes must be 2000 characters or less'];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
