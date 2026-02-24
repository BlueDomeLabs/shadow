// lib/domain/usecases/diet/create_diet_use_case.dart
// Phase 15b-2 — Create a diet (preset or custom)
// Per 22_API_CONTRACTS.md Section 4.5.4 + 59_DIET_TRACKING.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/diet.dart';
import 'package:shadow_app/domain/entities/diet_rule.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/diet_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/diet/diet_types.dart';
import 'package:uuid/uuid.dart';

/// Use case: create a new diet (preset or custom).
///
/// If [CreateDietInput.activateImmediately] is true, the current active diet
/// is deactivated and this diet is set as active. Otherwise the diet is saved
/// as a draft or inactive diet.
///
/// Rules provided in [CreateDietInput.initialRules] are added after the diet
/// is created (custom diets only; preset diets store rules on-demand).
class CreateDietUseCase implements UseCase<CreateDietInput, Diet> {
  final DietRepository _repository;
  final ProfileAuthorizationService _authService;
  final Uuid _uuid;

  CreateDietUseCase(
    this._repository,
    this._authService, [
    Uuid uuid = const Uuid(),
  ]) : _uuid = uuid;

  @override
  Future<Result<Diet, AppError>> call(CreateDietInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationError = _validate(input);
    if (validationError != null) return Failure(validationError);

    // 3. Deactivate current diet if activating immediately
    if (input.activateImmediately) {
      final deactivateResult = await _deactivateCurrent(input.profileId);
      if (deactivateResult.isFailure) {
        return Failure(deactivateResult.errorOrNull!);
      }
    }

    // 4. Create diet entity
    final now = DateTime.now().millisecondsSinceEpoch;
    final diet = Diet(
      id: _uuid.v4(),
      clientId: input.clientId,
      profileId: input.profileId,
      name: input.name,
      description: input.description,
      presetType: input.presetType,
      isActive: input.activateImmediately,
      isDraft: input.isDraft && !input.activateImmediately,
      startDate: input.startDateEpoch ?? now,
      endDate: input.endDateEpoch,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Populated by repository
      ),
    );

    // 5. Persist diet
    final createResult = await _repository.create(diet);
    if (createResult.isFailure) return createResult;

    final created = createResult.valueOrNull!;

    // 6. Add initial rules (custom diets only)
    for (final rule in input.initialRules) {
      final ruleWithDiet = DietRule(
        id: rule.id.isEmpty ? _uuid.v4() : rule.id,
        dietId: created.id,
        ruleType: rule.ruleType,
        targetFoodItemId: rule.targetFoodItemId,
        targetCategory: rule.targetCategory,
        targetIngredient: rule.targetIngredient,
        minValue: rule.minValue,
        maxValue: rule.maxValue,
        unit: rule.unit,
        frequency: rule.frequency,
        timeValue: rule.timeValue,
        sortOrder: rule.sortOrder,
      );
      final ruleResult = await _repository.addRule(ruleWithDiet);
      if (ruleResult.isFailure) {
        // Non-fatal: diet is created, rules failed — return diet anyway.
        break;
      }
    }

    return Success(created);
  }

  ValidationError? _validate(CreateDietInput input) {
    final errors = <String, List<String>>{};

    if (input.name.isEmpty || input.name.length > 100) {
      errors['name'] = ['Diet name must be 1-100 characters'];
    }

    if (input.startDateEpoch != null &&
        input.endDateEpoch != null &&
        input.startDateEpoch! >= input.endDateEpoch!) {
      errors['dateRange'] = ['Start date must be before end date'];
    }

    return errors.isEmpty ? null : ValidationError.fromFieldErrors(errors);
  }

  Future<Result<void, AppError>> _deactivateCurrent(String profileId) async {
    final activeResult = await _repository.getActiveDiet(profileId);
    if (activeResult.isFailure) return Failure(activeResult.errorOrNull!);

    final active = activeResult.valueOrNull;
    if (active == null) return const Success(null);

    return _repository.deactivate(profileId);
  }
}
