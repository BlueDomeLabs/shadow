// lib/domain/usecases/fluids_entries/get_fluids_entries_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/repositories/fluids_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/fluids_entries/fluids_entry_inputs.dart';

/// Use case to get fluids entries by date range.
class GetFluidsEntriesUseCase
    implements UseCase<GetFluidsEntriesInput, List<FluidsEntry>> {
  final FluidsEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  GetFluidsEntriesUseCase(this._repository, this._authService);

  @override
  Future<Result<List<FluidsEntry>, AppError>> call(
    GetFluidsEntriesInput input,
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
    return _repository.getByDateRange(
      input.profileId,
      input.startDate,
      input.endDate,
    );
  }
}

/// Use case to get today's fluids entry.
class GetTodayFluidsEntryUseCase
    implements UseCase<GetTodayFluidsEntryInput, FluidsEntry?> {
  final FluidsEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  GetTodayFluidsEntryUseCase(this._repository, this._authService);

  @override
  Future<Result<FluidsEntry?, AppError>> call(
    GetTodayFluidsEntryInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Repository call
    return _repository.getTodayEntry(input.profileId);
  }
}

/// Use case to get BBT entries for charting.
class GetBBTEntriesUseCase
    implements UseCase<GetBBTEntriesInput, List<FluidsEntry>> {
  final FluidsEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  GetBBTEntriesUseCase(this._repository, this._authService);

  @override
  Future<Result<List<FluidsEntry>, AppError>> call(
    GetBBTEntriesInput input,
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
    return _repository.getBBTEntries(
      input.profileId,
      input.startDate,
      input.endDate,
    );
  }
}

/// Use case to get menstruation entries.
class GetMenstruationEntriesUseCase
    implements UseCase<GetMenstruationEntriesInput, List<FluidsEntry>> {
  final FluidsEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  GetMenstruationEntriesUseCase(this._repository, this._authService);

  @override
  Future<Result<List<FluidsEntry>, AppError>> call(
    GetMenstruationEntriesInput input,
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
    return _repository.getMenstruationEntries(
      input.profileId,
      input.startDate,
      input.endDate,
    );
  }
}
