// lib/domain/usecases/flare_ups/end_flare_up_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/domain/repositories/flare_up_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/flare_ups/flare_up_inputs.dart';

/// Use case to end an ongoing flare-up.
class EndFlareUpUseCase implements UseCase<EndFlareUpInput, FlareUp> {
  final FlareUpRepository _repository;
  final ProfileAuthorizationService _authService;

  EndFlareUpUseCase(this._repository, this._authService);

  @override
  Future<Result<FlareUp, AppError>> call(EndFlareUpInput input) async {
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

    // Verify the flare-up belongs to the profile
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Validation
    final validationError = _validate(input, existing);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 4. End flare-up
    return _repository.endFlareUp(input.id, input.endDate);
  }

  ValidationError? _validate(EndFlareUpInput input, FlareUp existing) {
    final errors = <String, List<String>>{};

    // Already ended
    if (existing.endDate != null) {
      errors['endDate'] = ['Flare-up has already ended'];
    }

    // End date must be after start date
    if (input.endDate <= existing.startDate) {
      errors['endDate'] = ['End date must be after start date'];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
