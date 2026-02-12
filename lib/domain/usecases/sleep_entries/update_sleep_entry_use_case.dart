// lib/domain/usecases/sleep_entries/update_sleep_entry_use_case.dart
// Following 22_API_CONTRACTS.md Section 4.5 CRUD Use Case Templates

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/sleep_entry.dart';
import 'package:shadow_app/domain/repositories/sleep_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/sleep_entries/sleep_entry_inputs.dart';

/// Use case to update an existing sleep entry.
///
/// Follows the standard pattern:
/// 1. Authorization - Check profile access FIRST
/// 2. Fetch existing entity
/// 3. Validation - Validate input against existing
/// 4. Apply updates
/// 5. Repository Call - Execute operation
class UpdateSleepEntryUseCase
    implements UseCase<UpdateSleepEntryInput, SleepEntry> {
  final SleepEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  UpdateSleepEntryUseCase(this._repository, this._authService);

  @override
  Future<Result<SleepEntry, AppError>> call(UpdateSleepEntryInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch existing entity (returns Failure if not found)
    final existingResult = await _repository.getById(input.id);
    if (existingResult.isFailure) {
      return Failure(existingResult.errorOrNull!);
    }

    final existing = existingResult.valueOrNull!;

    // Verify the entry belongs to the profile
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Apply updates (using copyWith for immutable update)
    final updated = existing.copyWith(
      bedTime: input.bedTime ?? existing.bedTime,
      wakeTime: input.wakeTime ?? existing.wakeTime,
      deepSleepMinutes: input.deepSleepMinutes ?? existing.deepSleepMinutes,
      lightSleepMinutes: input.lightSleepMinutes ?? existing.lightSleepMinutes,
      restlessSleepMinutes:
          input.restlessSleepMinutes ?? existing.restlessSleepMinutes,
      dreamType: input.dreamType ?? existing.dreamType,
      wakingFeeling: input.wakingFeeling ?? existing.wakingFeeling,
      notes: input.notes ?? existing.notes,
      importSource: input.importSource ?? existing.importSource,
      importExternalId: input.importExternalId ?? existing.importExternalId,
    );

    // 4. Validation (after applying updates)
    final validationError = _validate(updated);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 5. Persist
    return _repository.update(updated);
  }

  ValidationError? _validate(SleepEntry entry) {
    final errors = <String, List<String>>{};

    // Bed time must be in the past or near present
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneHourFromNow = now + ValidationRules.maxFutureTimestampToleranceMs;
    if (entry.bedTime > oneHourFromNow) {
      errors['bedTime'] = ['Bed time cannot be more than 1 hour in the future'];
    }

    // If wake time provided, it must be after bed time
    if (entry.wakeTime != null) {
      if (entry.wakeTime! <= entry.bedTime) {
        errors['wakeTime'] = ['Wake time must be after bed time'];
      }

      // Wake time should not be more than 24 hours after bed time
      final maxWakeTime = entry.bedTime + Duration.millisecondsPerDay;
      if (entry.wakeTime! > maxWakeTime) {
        errors['wakeTime'] = ['Sleep duration cannot exceed 24 hours'];
      }
    }

    // Sleep stage minutes must be non-negative
    if (entry.deepSleepMinutes < 0) {
      errors['deepSleepMinutes'] = ['Deep sleep minutes cannot be negative'];
    }
    if (entry.lightSleepMinutes < 0) {
      errors['lightSleepMinutes'] = ['Light sleep minutes cannot be negative'];
    }
    if (entry.restlessSleepMinutes < 0) {
      errors['restlessSleepMinutes'] = [
        'Restless sleep minutes cannot be negative',
      ];
    }

    // If sleep stages provided, total should not exceed total sleep time
    if (entry.wakeTime != null) {
      final totalSleepMinutes = ((entry.wakeTime! - entry.bedTime) / 60000)
          .round();
      final stagesTotal =
          entry.deepSleepMinutes +
          entry.lightSleepMinutes +
          entry.restlessSleepMinutes;
      if (stagesTotal > totalSleepMinutes) {
        errors['sleepStages'] = [
          'Sleep stage minutes cannot exceed total sleep time',
        ];
      }
    }

    // Notes length validation
    if (entry.notes != null &&
        entry.notes!.length > ValidationRules.notesMaxLength) {
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
