// lib/domain/usecases/supplements/create_supplement_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 4.5

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/supplement_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/supplements/supplement_inputs.dart';
import 'package:uuid/uuid.dart';

/// Use case to create a new supplement.
///
/// Follows the standard pattern:
/// 1. Authorization - Check profile access FIRST
/// 2. Validation - Validate input using ValidationRules
/// 3. Create entity
/// 4. Repository Call - Execute operation
class CreateSupplementUseCase
    implements UseCase<CreateSupplementInput, Supplement> {
  final SupplementRepository _repository;
  final ProfileAuthorizationService _authService;

  CreateSupplementUseCase(this._repository, this._authService);

  @override
  Future<Result<Supplement, AppError>> call(CreateSupplementInput input) async {
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

    final supplement = Supplement(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      name: input.name,
      form: input.form,
      customForm: input.customForm,
      dosageQuantity: input.dosageQuantity,
      dosageUnit: input.dosageUnit,
      brand: input.brand,
      notes: input.notes,
      ingredients: input.ingredients,
      schedules: input.schedules,
      startDate: input.startDate,
      endDate: input.endDate,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(supplement);
  }

  ValidationError? _validate(CreateSupplementInput input) {
    final errors = <String, List<String>>{};

    // Name validation
    final nameError = ValidationRules.supplementName(input.name);
    if (nameError != null) errors['name'] = [nameError];

    // Brand validation (optional but max length)
    if (input.brand.isNotEmpty) {
      final brandError = ValidationRules.brand(input.brand);
      if (brandError != null) errors['brand'] = [brandError];
    }

    // Custom form required when form is 'other'
    if (input.form == SupplementForm.other &&
        (input.customForm == null || input.customForm!.isEmpty)) {
      errors['customForm'] = [
        'Custom form name is required when form is "Other"',
      ];
    }

    // Dosage quantity must be positive
    if (input.dosageQuantity <= 0) {
      errors['dosageQuantity'] = ['Dosage quantity must be greater than 0'];
    }

    // Ingredients count limit
    final ingredientsError = ValidationRules.ingredientsCount(
      input.ingredients.length,
    );
    if (ingredientsError != null) errors['ingredients'] = [ingredientsError];

    // Schedules count limit
    final schedulesError = ValidationRules.schedulesCount(
      input.schedules.length,
    );
    if (schedulesError != null) errors['schedules'] = [schedulesError];

    // Date range validation
    if (input.startDate != null && input.endDate != null) {
      final dateError = ValidationRules.dateRange(
        input.startDate!,
        input.endDate!,
        'startDate',
        'endDate',
      );
      if (dateError != null) errors['dateRange'] = [dateError];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
