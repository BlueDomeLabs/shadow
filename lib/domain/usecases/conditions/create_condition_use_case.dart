// lib/domain/usecases/conditions/create_condition_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.8

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/condition_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/conditions/condition_inputs.dart';
import 'package:uuid/uuid.dart';

/// Use case to create a new condition.
///
/// Follows the standard pattern:
/// 1. Authorization - Check profile access FIRST
/// 2. Validation - Validate input using ValidationRules
/// 3. Create entity
/// 4. Repository Call - Execute operation
class CreateConditionUseCase
    implements UseCase<CreateConditionInput, Condition> {
  final ConditionRepository _repository;
  final ProfileAuthorizationService _authService;

  CreateConditionUseCase(this._repository, this._authService);

  @override
  Future<Result<Condition, AppError>> call(CreateConditionInput input) async {
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

    final condition = Condition(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      name: input.name,
      category: input.category,
      bodyLocations: input.bodyLocations,
      triggers: input.triggers,
      description: input.description,
      baselinePhotoPath: input.baselinePhotoPath,
      startTimeframe: input.startTimeframe,
      endDate: input.endDate,
      activityId: input.activityId,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(condition);
  }

  ValidationError? _validate(CreateConditionInput input) {
    final errors = <String, List<String>>{};

    // Name validation
    final nameError = ValidationRules.entityName(
      input.name,
      'Condition name',
      ValidationRules.conditionNameMaxLength,
    );
    if (nameError != null) errors['name'] = [nameError];

    // Category validation
    if (input.category.trim().isEmpty) {
      errors['category'] = ['Category is required'];
    }

    // Start timeframe validation
    if (input.startTimeframe <= 0) {
      errors['startTimeframe'] = [
        'Start timeframe must be a valid epoch timestamp',
      ];
    }

    // Date range validation
    if (input.endDate != null && input.startTimeframe > input.endDate!) {
      errors['endDate'] = ['End date must be after start timeframe'];
    }

    // Description validation (optional but max length)
    if (input.description != null &&
        input.description!.length > ValidationRules.descriptionMaxLength) {
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
