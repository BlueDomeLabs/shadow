// lib/domain/usecases/diet/check_compliance_use_case.dart
// Phase 15b-2 — Real-time pre-log compliance check
// Per 22_API_CONTRACTS.md Section 7.5 Diet Compliance Use Cases

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/repositories/diet_repository.dart';
import 'package:shadow_app/domain/repositories/food_item_repository.dart';
import 'package:shadow_app/domain/services/diet_compliance_service.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/diet/diet_types.dart';

/// Use case: check a food item against the active diet before saving.
///
/// Returns [ComplianceCheckResult] with:
/// - [isCompliant] = true if no rules are violated
/// - [violatedRules] = the rules that would be violated
/// - [complianceImpact] = estimated % reduction in daily compliance score
/// - [alternatives] = suggested compliant food items (if violations exist)
class CheckComplianceUseCase
    implements UseCase<CheckComplianceInput, ComplianceCheckResult> {
  final DietRepository _dietRepository;
  final FoodItemRepository _foodItemRepository;
  final DietComplianceService _complianceService;
  final ProfileAuthorizationService _authService;

  CheckComplianceUseCase(
    this._dietRepository,
    this._foodItemRepository,
    this._complianceService,
    this._authService,
  );

  @override
  Future<Result<ComplianceCheckResult, AppError>> call(
    CheckComplianceInput input,
  ) async {
    // 1. Authorization (read access sufficient for checking)
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch the diet and its rules
    final dietResult = await _dietRepository.getById(input.dietId);
    if (dietResult.isFailure) return Failure(dietResult.errorOrNull!);

    final diet = dietResult.valueOrNull!;
    final rulesResult = await _dietRepository.getRules(input.dietId);
    if (rulesResult.isFailure) return Failure(rulesResult.errorOrNull!);

    final rules = rulesResult.valueOrNull!;

    // Verify ownership
    if (diet.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Check food against all rules
    final violations = _complianceService.checkFoodAgainstRules(
      input.foodItem,
      rules,
      input.logTimeEpoch,
    );

    // 4. Calculate impact
    final impact = _complianceService.calculateImpact(
      input.profileId,
      violations,
    );

    // 5. Find alternatives if violations exist
    var alternatives = <FoodItem>[];
    if (violations.isNotEmpty) {
      final excludeCategories = violations
          .map((r) => r.targetCategory)
          .whereType<String>()
          .toList();

      if (excludeCategories.isNotEmpty) {
        final altResult = await _foodItemRepository.searchExcludingCategories(
          input.profileId,
          input.foodItem.name,
          excludeCategories: excludeCategories,
          limit: 5,
        );
        if (altResult.isSuccess) {
          alternatives = altResult.valueOrNull!;
        }
      }
    }

    return Success(
      ComplianceCheckResult(
        isCompliant: violations.isEmpty,
        violatedRules: violations,
        complianceImpact: impact,
        alternatives: alternatives,
      ),
    );
  }
}
