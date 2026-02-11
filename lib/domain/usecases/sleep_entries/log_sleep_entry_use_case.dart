// lib/domain/usecases/sleep_entries/log_sleep_entry_use_case.dart
// Following 22_API_CONTRACTS.md Section 4.5 CRUD Use Case Templates

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/sleep_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/sleep_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/sleep_entries/sleep_entry_inputs.dart';
import 'package:uuid/uuid.dart';

/// Use case to log a new sleep entry.
///
/// Follows the standard pattern:
/// 1. Authorization - Check profile access FIRST
/// 2. Validation - Validate input
/// 3. Create entity
/// 4. Repository Call - Execute operation
class LogSleepEntryUseCase implements UseCase<LogSleepEntryInput, SleepEntry> {
  final SleepEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  LogSleepEntryUseCase(this._repository, this._authService);

  @override
  Future<Result<SleepEntry, AppError>> call(LogSleepEntryInput input) async {
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

    final entry = SleepEntry(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      bedTime: input.bedTime,
      wakeTime: input.wakeTime,
      deepSleepMinutes: input.deepSleepMinutes,
      lightSleepMinutes: input.lightSleepMinutes,
      restlessSleepMinutes: input.restlessSleepMinutes,
      dreamType: input.dreamType,
      wakingFeeling: input.wakingFeeling,
      notes: input.notes,
      importSource: input.importSource,
      importExternalId: input.importExternalId,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(entry);
  }

  ValidationError? _validate(LogSleepEntryInput input) {
    final errors = <String, List<String>>{};

    // Bed time must be in the past or near present (allow up to 1 hour in future for timezone issues)
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneHourFromNow = now + (60 * 60 * 1000);
    if (input.bedTime > oneHourFromNow) {
      errors['bedTime'] = ['Bed time cannot be more than 1 hour in the future'];
    }

    // If wake time provided, it must be after bed time
    if (input.wakeTime != null) {
      if (input.wakeTime! <= input.bedTime) {
        errors['wakeTime'] = ['Wake time must be after bed time'];
      }

      // Wake time should not be more than 24 hours after bed time
      final maxWakeTime = input.bedTime + (24 * 60 * 60 * 1000);
      if (input.wakeTime! > maxWakeTime) {
        errors['wakeTime'] = ['Sleep duration cannot exceed 24 hours'];
      }
    }

    // Sleep stage minutes must be non-negative
    if (input.deepSleepMinutes < 0) {
      errors['deepSleepMinutes'] = ['Deep sleep minutes cannot be negative'];
    }
    if (input.lightSleepMinutes < 0) {
      errors['lightSleepMinutes'] = ['Light sleep minutes cannot be negative'];
    }
    if (input.restlessSleepMinutes < 0) {
      errors['restlessSleepMinutes'] = [
        'Restless sleep minutes cannot be negative',
      ];
    }

    // If sleep stages provided, total should not exceed total sleep time
    if (input.wakeTime != null) {
      final totalSleepMinutes = ((input.wakeTime! - input.bedTime) / 60000)
          .round();
      final stagesTotal =
          input.deepSleepMinutes +
          input.lightSleepMinutes +
          input.restlessSleepMinutes;
      if (stagesTotal > totalSleepMinutes) {
        errors['sleepStages'] = [
          'Sleep stage minutes cannot exceed total sleep time',
        ];
      }
    }

    // Notes length validation
    if (input.notes.length > ValidationRules.notesMaxLength) {
      errors['notes'] = [
        'Notes must be ${ValidationRules.notesMaxLength} characters or less',
      ];
    }

    // Import source validation (if provided)
    if (input.importSource != null && input.importSource!.isNotEmpty) {
      final validSources = [
        'healthkit',
        'googlefit',
        'apple_watch',
        'fitbit',
        'garmin',
        'manual',
      ];
      if (!validSources.contains(input.importSource!.toLowerCase())) {
        errors['importSource'] = [
          'Invalid import source. Valid: ${validSources.join(", ")}',
        ];
      }
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
