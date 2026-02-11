// lib/domain/usecases/fluids_entries/log_fluids_entry_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 4.2

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/fluids_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/fluids_entries/fluids_entry_inputs.dart';
import 'package:uuid/uuid.dart';

/// Use case to log a new fluids entry.
///
/// Follows the standard pattern:
/// 1. Authorization - Check profile access FIRST
/// 2. Validation - Validate input
/// 3. Create entity
/// 4. Repository Call - Execute operation
class LogFluidsEntryUseCase
    implements UseCase<LogFluidsEntryInput, FluidsEntry> {
  final FluidsEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  LogFluidsEntryUseCase(this._repository, this._authService);

  @override
  Future<Result<FluidsEntry, AppError>> call(LogFluidsEntryInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationError = _validate(input);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final entry = FluidsEntry(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      entryDate: input.entryDate,
      waterIntakeMl: input.waterIntakeMl,
      waterIntakeNotes: input.waterIntakeNotes,
      bowelCondition: input.bowelCondition,
      bowelSize: input.bowelSize,
      bowelPhotoPath: input.bowelPhotoPath,
      urineCondition: input.urineCondition,
      urineSize: input.urineSize,
      urinePhotoPath: input.urinePhotoPath,
      menstruationFlow: input.menstruationFlow,
      basalBodyTemperature: input.basalBodyTemperature,
      bbtRecordedTime: input.bbtRecordedTime,
      otherFluidName: input.otherFluidName,
      otherFluidAmount: input.otherFluidAmount,
      otherFluidNotes: input.otherFluidNotes,
      notes: input.notes,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(entry);
  }

  ValidationError? _validate(LogFluidsEntryInput input) {
    final errors = <String, List<String>>{};

    // At least one data point must be provided
    final hasAnyData =
        input.waterIntakeMl != null ||
        input.bowelCondition != null ||
        input.urineCondition != null ||
        input.menstruationFlow != null ||
        input.basalBodyTemperature != null ||
        input.otherFluidName != null;

    if (!hasAnyData) {
      errors['general'] = ['At least one measurement is required'];
    }

    // Water intake validation
    if (input.waterIntakeMl != null) {
      if (input.waterIntakeMl! < ValidationRules.waterIntakeMinMl ||
          input.waterIntakeMl! > ValidationRules.waterIntakeMaxMl) {
        errors['waterIntakeMl'] = [
          'Water intake must be between ${ValidationRules.waterIntakeMinMl} and ${ValidationRules.waterIntakeMaxMl} mL',
        ];
      }
    }

    // BBT validation
    if (input.basalBodyTemperature != null) {
      if (input.basalBodyTemperature! < ValidationRules.bbtMinFahrenheit ||
          input.basalBodyTemperature! > ValidationRules.bbtMaxFahrenheit) {
        errors['basalBodyTemperature'] = [
          'BBT must be between ${ValidationRules.bbtMinFahrenheit} and ${ValidationRules.bbtMaxFahrenheit}°F',
        ];
      }
      // Recording time is required for BBT
      if (input.bbtRecordedTime == null) {
        errors['bbtRecordedTime'] = ['Recording time is required for BBT'];
      }
    }

    // Other fluid validation
    if ((input.otherFluidAmount != null &&
            input.otherFluidAmount!.isNotEmpty) ||
        (input.otherFluidNotes != null && input.otherFluidNotes!.isNotEmpty)) {
      if (input.otherFluidName == null || input.otherFluidName!.isEmpty) {
        errors['otherFluidName'] = [
          'Fluid name is required when amount or notes are provided',
        ];
      }
    }

    if (input.otherFluidName != null && input.otherFluidName!.isNotEmpty) {
      // Name validation: letters/spaces/hyphens/apostrophes only
      if (input.otherFluidName!.length <
              ValidationRules.customFluidNameMinLength ||
          input.otherFluidName!.length >
              ValidationRules.customFluidNameMaxLength) {
        errors['otherFluidName'] = [
          'Fluid name must be ${ValidationRules.customFluidNameMinLength}-${ValidationRules.customFluidNameMaxLength} characters',
        ];
      } else if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(input.otherFluidName!)) {
        errors['otherFluidName'] = [
          'Fluid name can only contain letters, spaces, hyphens, and apostrophes',
        ];
      }
    }

    if (input.otherFluidAmount != null &&
        input.otherFluidAmount!.length >
            ValidationRules.otherFluidAmountMaxLength) {
      errors['otherFluidAmount'] = [
        'Amount must be ${ValidationRules.otherFluidAmountMaxLength} characters or less',
      ];
    }

    if (input.otherFluidNotes != null &&
        input.otherFluidNotes!.length >
            ValidationRules.otherFluidNotesMaxLength) {
      errors['otherFluidNotes'] = [
        'Notes must be ${ValidationRules.otherFluidNotesMaxLength} characters or less',
      ];
    }

    // General notes validation
    if (input.notes.length > ValidationRules.notesMaxLength) {
      errors['notes'] = [
        'Notes must be ${ValidationRules.notesMaxLength} characters or less',
      ];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
