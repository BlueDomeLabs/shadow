// lib/presentation/providers/food_items/food_item_search_provider.dart
// Implements 02_CODING_STANDARDS.md Section 6 - Provider Pattern

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/usecases/food_items/food_items_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'food_item_search_provider.g.dart';

/// Provider for searching food items with profile scope.
///
/// Takes both profileId and query as build parameters.
@riverpod
class FoodItemSearch extends _$FoodItemSearch {
  static final _log = logger.scope('FoodItemSearch');

  @override
  Future<List<FoodItem>> build(String profileId, String query) async {
    // Return empty list for empty query
    if (query.isEmpty) {
      return [];
    }

    _log.debug('Searching food items for query: $query');

    final useCase = ref.read(searchFoodItemsUseCaseProvider);
    final result = await useCase(
      SearchFoodItemsInput(profileId: profileId, query: query),
    );

    return result.when(
      success: (items) {
        _log.debug('Found ${items.length} food items matching query');
        return items;
      },
      failure: (error) {
        _log.error('Search failed: ${error.message}');
        throw error;
      },
    );
  }
}
