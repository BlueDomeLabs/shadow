// lib/domain/usecases/conditions/update_condition_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.8

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/repositories/condition_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/conditions/condition_inputs.dart';

/// Use case to update an existing condition.
class UpdateConditionUseCase
    implements UseCase<UpdateConditionInput, Condition> {
  final ConditionRepository _repository;
  final ProfileAuthorizationService _authService;

  UpdateConditionUseCase(this._repository, this._authService);

  @override
  Future<Result<Condition, AppError>> call(UpdateConditionInput input) async {
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

    // Verify the condition belongs to the profile
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Apply updates
    final updated = existing.copyWith(
      name: input.name ?? existing.name,
      category: input.category ?? existing.category,
      bodyLocations: input.bodyLocations ?? existing.bodyLocations,
      description: input.description ?? existing.description,
      startTimeframe: input.startTimeframe ?? existing.startTimeframe,
      endDate: input.endDate ?? existing.endDate,
      status: input.status ?? existing.status,
    );

    // 4. Validation
    final validationError = _validate(updated);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 5. Persist
    return _repository.update(updated);
  }

  ValidationError? _validate(Condition condition) {
    final errors = <String, List<String>>{};

    final nameError = ValidationRules.entityName(
      condition.name,
      'Condition name',
      ValidationRules.conditionNameMaxLength,
    );
    if (nameError != null) errors['name'] = [nameError];

    if (condition.category.trim().isEmpty) {
      errors['category'] = ['Category is required'];
    }

    if (condition.startTimeframe <= 0) {
      errors['startTimeframe'] = [
        'Start timeframe must be a valid epoch timestamp',
      ];
    }

    if (condition.endDate != null &&
        condition.startTimeframe > condition.endDate!) {
      errors['endDate'] = ['End date must be after start timeframe'];
    }

    if (condition.description != null &&
        condition.description!.length > ValidationRules.descriptionMaxLength) {
      errors['description'] = [
        'Description must be ${ValidationRules.descriptionMaxLength} characters or less',
      ];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
