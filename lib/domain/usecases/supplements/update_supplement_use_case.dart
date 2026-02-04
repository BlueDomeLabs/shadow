// lib/domain/usecases/supplements/update_supplement_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 4.5

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/supplement_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/supplements/supplement_inputs.dart';

/// Use case to update an existing supplement.
///
/// Follows the standard pattern:
/// 1. Authorization - Check profile access FIRST
/// 2. Fetch existing - Get current entity
/// 3. Verify ownership - Ensure entity belongs to profile
/// 4. Apply updates - Using copyWith pattern
/// 5. Validate - Validate updated entity
/// 6. Repository Call - Execute operation
class UpdateSupplementUseCase
    implements UseCase<UpdateSupplementInput, Supplement> {
  final SupplementRepository _repository;
  final ProfileAuthorizationService _authService;

  UpdateSupplementUseCase(this._repository, this._authService);

  @override
  Future<Result<Supplement, AppError>> call(UpdateSupplementInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch existing
    final existingResult = await _repository.getById(input.id);
    if (existingResult.isFailure) {
      return Failure(existingResult.errorOrNull!);
    }
    final existing = existingResult.valueOrNull!;

    // 3. Verify ownership
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 4. Apply updates (copyWith pattern)
    final updated = existing.copyWith(
      name: input.name ?? existing.name,
      form: input.form ?? existing.form,
      customForm: input.customForm ?? existing.customForm,
      dosageQuantity: input.dosageQuantity ?? existing.dosageQuantity,
      dosageUnit: input.dosageUnit ?? existing.dosageUnit,
      brand: input.brand ?? existing.brand,
      notes: input.notes ?? existing.notes,
      ingredients: input.ingredients ?? existing.ingredients,
      schedules: input.schedules ?? existing.schedules,
      startDate: input.startDate ?? existing.startDate,
      endDate: input.endDate ?? existing.endDate,
      isArchived: input.isArchived ?? existing.isArchived,
      syncMetadata: existing.syncMetadata.copyWith(
        syncUpdatedAt: DateTime.now().millisecondsSinceEpoch,
        syncVersion: existing.syncMetadata.syncVersion + 1,
        syncIsDirty: true,
      ),
    );

    // 5. Validate updated entity
    final validationError = _validateUpdated(updated);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 6. Persist
    return _repository.update(updated);
  }

  ValidationError? _validateUpdated(Supplement supplement) {
    final errors = <String, List<String>>{};

    final nameError = ValidationRules.supplementName(supplement.name);
    if (nameError != null) errors['name'] = [nameError];

    if (supplement.form == SupplementForm.other &&
        (supplement.customForm == null || supplement.customForm!.isEmpty)) {
      errors['customForm'] = [
        'Custom form name is required when form is "Other"',
      ];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
