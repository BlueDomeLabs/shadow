// lib/presentation/providers/food_items/food_item_list_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/usecases/food_items/food_items_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'food_item_list_provider.g.dart';

/// Provider for managing food item list with profile scope.
@riverpod
class FoodItemList extends _$FoodItemList {
  static final _log = logger.scope('FoodItemList');

  @override
  Future<List<FoodItem>> build(String profileId) async {
    _log.debug('Loading food items for profile: $profileId');

    final useCase = ref.read(getFoodItemsUseCaseProvider);
    final result = await useCase(GetFoodItemsInput(profileId: profileId));

    return result.when(
      success: (items) {
        _log.debug('Loaded ${items.length} food items');
        return items;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Creates a new food item.
  Future<void> create(CreateFoodItemInput input) async {
    _log.debug('Creating food item: ${input.name}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(createFoodItemUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Food item created successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Create failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Updates an existing food item.
  Future<void> updateItem(UpdateFoodItemInput input) async {
    _log.debug('Updating food item: ${input.id}');

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(updateFoodItemUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info('Food item updated successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Update failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Archives or unarchives a food item.
  Future<void> archive(ArchiveFoodItemInput input) async {
    _log.debug(
      '${input.archive ? "Archiving" : "Unarchiving"} food item: ${input.id}',
    );

    // Defense-in-depth: Provider-level auth check
    final authService = ref.read(profileAuthorizationServiceProvider);
    if (!await authService.canWrite(input.profileId)) {
      throw AuthError.profileAccessDenied(input.profileId);
    }

    final useCase = ref.read(archiveFoodItemUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) {
        _log.info(
          'Food item ${input.archive ? "archived" : "unarchived"} successfully',
        );
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Archive failed: ${error.message}');
        throw error;
      },
    );
  }
}
