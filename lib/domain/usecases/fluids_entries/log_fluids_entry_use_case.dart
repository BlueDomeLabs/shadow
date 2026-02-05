// lib/domain/usecases/fluids_entries/log_fluids_entry_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 4.2

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
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

    // Water intake validation (0 - 10,000 mL)
    if (input.waterIntakeMl != null) {
      if (input.waterIntakeMl! < 0 || input.waterIntakeMl! > 10000) {
        errors['waterIntakeMl'] = [
          'Water intake must be between 0 and 10,000 mL',
        ];
      }
    }

    // BBT validation (95.0 - 105.0°F)
    if (input.basalBodyTemperature != null) {
      if (input.basalBodyTemperature! < 95.0 ||
          input.basalBodyTemperature! > 105.0) {
        errors['basalBodyTemperature'] = [
          'BBT must be between 95.0 and 105.0°F',
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
      // Name: 2-100 characters, letters/spaces/hyphens/apostrophes only
      if (input.otherFluidName!.length < 2 ||
          input.otherFluidName!.length > 100) {
        errors['otherFluidName'] = ['Fluid name must be 2-100 characters'];
      } else if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(input.otherFluidName!)) {
        errors['otherFluidName'] = [
          'Fluid name can only contain letters, spaces, hyphens, and apostrophes',
        ];
      }
    }

    if (input.otherFluidAmount != null && input.otherFluidAmount!.length > 50) {
      errors['otherFluidAmount'] = ['Amount must be 50 characters or less'];
    }

    if (input.otherFluidNotes != null && input.otherFluidNotes!.length > 5000) {
      errors['otherFluidNotes'] = ['Notes must be 5000 characters or less'];
    }

    // General notes validation
    if (input.notes.length > 2000) {
      errors['notes'] = ['Notes must be 2000 characters or less'];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
