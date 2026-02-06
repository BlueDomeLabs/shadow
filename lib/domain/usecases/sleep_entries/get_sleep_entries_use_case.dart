// lib/domain/usecases/sleep_entries/get_sleep_entries_use_case.dart
// Following 22_API_CONTRACTS.md Section 4.5 CRUD Use Case Templates

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/sleep_entry.dart';
import 'package:shadow_app/domain/repositories/sleep_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/sleep_entries/sleep_entry_inputs.dart';

/// Use case to get sleep entries by date range.
class GetSleepEntriesUseCase
    implements UseCase<GetSleepEntriesInput, List<SleepEntry>> {
  final SleepEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  GetSleepEntriesUseCase(this._repository, this._authService);

  @override
  Future<Result<List<SleepEntry>, AppError>> call(
    GetSleepEntriesInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    if (input.startDate != null &&
        input.endDate != null &&
        input.startDate! > input.endDate!) {
      return Failure(
        ValidationError.fromFieldErrors({
          'dateRange': ['Start date must be before or equal to end date'],
        }),
      );
    }

    // 3. Repository call
    return _repository.getByProfile(
      input.profileId,
      startDate: input.startDate,
      endDate: input.endDate,
      limit: input.limit,
      offset: input.offset,
    );
  }
}

/// Use case to get sleep entry for a specific night.
class GetSleepEntryForNightUseCase
    implements UseCase<GetSleepEntryForNightInput, SleepEntry?> {
  final SleepEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  GetSleepEntryForNightUseCase(this._repository, this._authService);

  @override
  Future<Result<SleepEntry?, AppError>> call(
    GetSleepEntryForNightInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Repository call
    return _repository.getForNight(input.profileId, input.date);
  }
}

/// Use case to get sleep averages for a date range.
class GetSleepAveragesUseCase
    implements UseCase<GetSleepAveragesInput, Map<String, double>> {
  final SleepEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  GetSleepAveragesUseCase(this._repository, this._authService);

  @override
  Future<Result<Map<String, double>, AppError>> call(
    GetSleepAveragesInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    if (input.startDate > input.endDate) {
      return Failure(
        ValidationError.fromFieldErrors({
          'dateRange': ['Start date must be before or equal to end date'],
        }),
      );
    }

    // 3. Repository call
    return _repository.getAverages(
      input.profileId,
      startDate: input.startDate,
      endDate: input.endDate,
    );
  }
}
