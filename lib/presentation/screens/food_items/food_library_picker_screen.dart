// lib/presentation/screens/food_items/food_library_picker_screen.dart
// Multi-select food library picker for use in food log screen.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/providers/food_items/food_item_list_provider.dart';
import 'package:shadow_app/presentation/screens/food_items/food_item_edit_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Multi-select food library picker screen.
///
/// Allows the user to select multiple food items from their library.
/// Returns a [List<String>] of selected food item IDs when popped via Done.
class FoodLibraryPickerScreen extends ConsumerStatefulWidget {
  final String profileId;
  final List<String> initialSelectedIds;

  const FoodLibraryPickerScreen({
    super.key,
    required this.profileId,
    required this.initialSelectedIds,
  });

  @override
  ConsumerState<FoodLibraryPickerScreen> createState() =>
      _FoodLibraryPickerScreenState();
}

class _FoodLibraryPickerScreenState
    extends ConsumerState<FoodLibraryPickerScreen> {
  late Set<String> _selectedIds;
  bool _isSearching = false;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedIds = Set<String>.from(widget.initialSelectedIds);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodItemsAsync = ref.watch(foodItemListProvider(widget.profileId));

    final titleText =
        'Select Foods${_selectedIds.isEmpty ? '' : ' (${_selectedIds.length})'}';

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search food items…',
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged,
              )
            : Text(titleText),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _clearSearch,
              tooltip: 'Clear search',
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _startSearch,
              tooltip: 'Search food items',
            ),
          TextButton(onPressed: _onDone, child: const Text('Done')),
        ],
      ),
      body: Semantics(
        label: 'Food item picker',
        child: foodItemsAsync.when(
          data: (foodItems) => _buildItemList(context, foodItems),
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

  Widget _buildItemList(BuildContext context, List<FoodItem> foodItems) {
    final activeItems = foodItems.where((f) => !f.isArchived).toList();

    final displayItems = _searchQuery.isEmpty
        ? activeItems
        : activeItems
              .where(
                (f) =>
                    f.name.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();

    if (displayItems.isEmpty) {
      return _buildEmptyState(context, _searchQuery.isNotEmpty);
    }

    return ListView.builder(
      itemCount: displayItems.length,
      itemBuilder: (context, index) =>
          _buildFoodItemRow(context, displayItems[index]),
    );
  }

  Widget _buildFoodItemRow(BuildContext context, FoodItem item) {
    final isSelected = _selectedIds.contains(item.id);
    final typeLabel = switch (item.type) {
      FoodItemType.simple => 'Simple',
      FoodItemType.composed => 'Composed',
      FoodItemType.packaged => 'Packaged',
    };

    return CheckboxListTile(
      key: ValueKey(item.id),
      value: isSelected,
      onChanged: (_) => _toggleItem(item.id),
      title: Text(item.name),
      subtitle: Text(typeLabel),
      secondary: Icon(_getTypeIcon(item.type)),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isFiltered) {
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
            Text(
              isFiltered ? 'No matching foods' : 'No foods in your library',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              isFiltered ? 'Try a different search term' : 'Tap + to add one.',
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
            const Text('Failed to load food items'),
            const SizedBox(height: 24),
            ShadowButton(
              onPressed: () =>
                  ref.invalidate(foodItemListProvider(widget.profileId)),
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
    FoodItemType.composed => Icons.menu_book,
    FoodItemType.packaged => Icons.shopping_bag,
  };

  void _toggleItem(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _onDone() {
    Navigator.of(context).pop(_selectedIds.toList());
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
      _searchQuery = '';
    });
  }

  void _clearSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  Future<void> _navigateToAddFoodItem(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => FoodItemEditScreen(profileId: widget.profileId),
      ),
    );
    if (mounted) {
      ref.invalidate(foodItemListProvider(widget.profileId));
    }
  }
}
