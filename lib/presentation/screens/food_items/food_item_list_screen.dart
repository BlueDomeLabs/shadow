// lib/presentation/screens/food_items/food_item_list_screen.dart
// Implements 38_UI_FIELD_SPECIFICATIONS.md Section 5 - Food Item Screens

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/food_items/food_items_usecases.dart';
import 'package:shadow_app/presentation/providers/food_items/food_item_list_provider.dart';
import 'package:shadow_app/presentation/screens/food_items/food_item_edit_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Screen displaying the list of food items for a profile.
///
/// Follows 38_UI_FIELD_SPECIFICATIONS.md Section 5 exactly.
/// Uses [FoodItemListProvider] for state management.
class FoodItemListScreen extends ConsumerWidget {
  final String profileId;

  const FoodItemListScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodItemsAsync = ref.watch(foodItemListProvider(profileId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context),
            tooltip: 'Search food items',
          ),
        ],
      ),
      body: Semantics(
        label: 'Food item list',
        child: foodItemsAsync.when(
          data: (foodItems) => _buildFoodItemList(context, ref, foodItems),
          loading: () => const Center(
            child: ShadowStatus.loading(label: 'Loading food items'),
          ),
          error: (error, stack) => _buildErrorState(context, ref, error),
        ),
      ),
      floatingActionButton: Semantics(
        label: 'Add new food item',
        child: FloatingActionButton(
          onPressed: () => _navigateToAddFoodItem(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildFoodItemList(
    BuildContext context,
    WidgetRef ref,
    List<FoodItem> foodItems,
  ) {
    if (foodItems.isEmpty) {
      return _buildEmptyState(context);
    }

    final activeItems = foodItems.where((f) => f.isActive).toList();
    final archivedItems = foodItems.where((f) => f.isArchived).toList();

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(foodItemListProvider(profileId));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (activeItems.isNotEmpty) ...[
            _buildSectionHeader(context, 'Food Items'),
            const SizedBox(height: 8),
            ...activeItems.map(
              (foodItem) => _buildFoodItemCard(context, ref, foodItem),
            ),
          ],
          if (archivedItems.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Archived'),
            const SizedBox(height: 8),
            ...archivedItems.map(
              (foodItem) => _buildFoodItemCard(context, ref, foodItem),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Semantics(
      header: true,
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFoodItemCard(
    BuildContext context,
    WidgetRef ref,
    FoodItem foodItem,
  ) {
    final theme = Theme.of(context);
    final typeLabel = foodItem.type == FoodItemType.simple
        ? 'Simple'
        : 'Composed';

    return Padding(
      key: ValueKey(foodItem.id),
      padding: const EdgeInsets.only(bottom: 8),
      child: ShadowCard.listItem(
        onTap: () => _navigateToEditFoodItem(context, foodItem),
        semanticLabel: '${foodItem.name}, $typeLabel',
        semanticHint: 'Double tap to edit',
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getTypeIcon(foodItem.type),
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodItem.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: foodItem.isArchived
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    typeLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (foodItem.servingSize != null &&
                      foodItem.servingSize!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      foodItem.servingSize!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (foodItem.hasNutritionalInfo)
              Semantics(
                label: 'Has nutritional info',
                child: Icon(
                  Icons.info_outline,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              tooltip: 'More options',
              onSelected: (value) =>
                  _handleFoodItemAction(context, ref, foodItem, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: foodItem.isArchived ? 'unarchive' : 'archive',
                  child: ListTile(
                    leading: Icon(
                      foodItem.isArchived ? Icons.unarchive : Icons.archive,
                    ),
                    title: Text(foodItem.isArchived ? 'Unarchive' : 'Archive'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
              child: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text('No food items yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first food item',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load food items',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error is AppError
                  ? error.userMessage
                  : 'Something went wrong. Please try again.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ShadowButton(
              onPressed: () => ref.invalidate(foodItemListProvider(profileId)),
              label: 'Retry',
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(FoodItemType type) => switch (type) {
    FoodItemType.simple => Icons.restaurant,
    FoodItemType.complex => Icons.menu_book,
  };

  void _showSearch(BuildContext context) {
    // TODO: Wire to SearchFoodItemsUseCase with search delegate
    showAccessibleSnackBar(context: context, message: 'Coming soon');
  }

  void _navigateToAddFoodItem(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => FoodItemEditScreen(profileId: profileId),
      ),
    );
  }

  void _navigateToEditFoodItem(BuildContext context, FoodItem foodItem) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) =>
            FoodItemEditScreen(profileId: profileId, foodItem: foodItem),
      ),
    );
  }

  Future<void> _handleFoodItemAction(
    BuildContext context,
    WidgetRef ref,
    FoodItem foodItem,
    String action,
  ) async {
    switch (action) {
      case 'edit':
        _navigateToEditFoodItem(context, foodItem);
      case 'archive':
      case 'unarchive':
        await _toggleArchive(context, ref, foodItem);
    }
  }

  Future<void> _toggleArchive(
    BuildContext context,
    WidgetRef ref,
    FoodItem foodItem,
  ) async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: foodItem.isArchived
          ? 'Unarchive Food Item?'
          : 'Archive Food Item?',
      contentText: foodItem.isArchived
          ? 'This food item will appear in your active list again.'
          : 'This food item will be moved to the archived section.',
      confirmButtonText: foodItem.isArchived ? 'Unarchive' : 'Archive',
    );

    if (confirmed ?? false) {
      try {
        await ref
            .read(foodItemListProvider(profileId).notifier)
            .archive(
              ArchiveFoodItemInput(
                id: foodItem.id,
                profileId: profileId,
                archive: !foodItem.isArchived,
              ),
            );
        if (context.mounted) {
          showAccessibleSnackBar(
            context: context,
            message: foodItem.isArchived
                ? 'Food item unarchived'
                : 'Food item archived',
          );
        }
      } on AppError catch (e) {
        if (context.mounted) {
          showAccessibleSnackBar(context: context, message: e.userMessage);
        }
      } on Exception {
        if (context.mounted) {
          showAccessibleSnackBar(
            context: context,
            message: 'An unexpected error occurred',
          );
        }
      }
    }
  }
}
