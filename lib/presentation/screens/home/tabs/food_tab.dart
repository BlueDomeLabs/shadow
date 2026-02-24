// lib/presentation/screens/home/tabs/food_tab.dart
// Food library tab with search, simple items, and composed dishes.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/food_items/food_item_inputs.dart';
import 'package:shadow_app/presentation/providers/food_items/food_item_list_provider.dart';
import 'package:shadow_app/presentation/screens/food_items/food_item_edit_screen.dart';
import 'package:shadow_app/presentation/screens/food_logs/food_log_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Food tab showing food library with search and categorized items.
class FoodTab extends ConsumerStatefulWidget {
  final String profileId;
  final String? profileName;

  const FoodTab({super.key, required this.profileId, this.profileName});

  @override
  ConsumerState<FoodTab> createState() => _FoodTabState();
}

class _FoodTabState extends ConsumerState<FoodTab> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(foodItemListProvider(widget.profileId));
    final titlePrefix = widget.profileName != null
        ? "${widget.profileName}'s "
        : '';

    return Scaffold(
      appBar: AppBar(
        title: Text('${titlePrefix}Food Library'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Food Log',
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => FoodLogScreen(profileId: widget.profileId),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search food items...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: itemsAsync.when(
              data: (items) => _buildItemList(context, items),
              loading: () => const Center(
                child: ShadowStatus.loading(label: 'Loading food items'),
              ),
              error: (error, _) =>
                  Center(child: Text('Error loading food items: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'food_fab',
        backgroundColor: Colors.orange,
        onPressed: () => _showAddOptionsSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildItemList(BuildContext context, List<FoodItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No food items yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to add your first item',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    final query = _searchQuery.toLowerCase();
    final simple =
        items
            .where(
              (i) =>
                  i.type == FoodItemType.simple &&
                  (query.isEmpty || i.name.toLowerCase().contains(query)),
            )
            .toList()
          ..sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );
    final composed =
        items
            .where(
              (i) =>
                  i.type == FoodItemType.composed &&
                  (query.isEmpty || i.name.toLowerCase().contains(query)),
            )
            .toList()
          ..sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );
    final packaged =
        items
            .where(
              (i) =>
                  i.type == FoodItemType.packaged &&
                  (query.isEmpty || i.name.toLowerCase().contains(query)),
            )
            .toList()
          ..sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );

    if (simple.isEmpty &&
        composed.isEmpty &&
        packaged.isEmpty &&
        _searchQuery.isNotEmpty) {
      return Center(
        child: Text(
          'No items match "$_searchQuery"',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: [
        if (simple.isNotEmpty) ...[
          _buildSectionHeader(
            'Simple Items',
            simple.length,
            Colors.green,
            Icons.restaurant,
          ),
          const SizedBox(height: 8),
          ...simple.map((item) => _buildFoodItemCard(context, item)),
          const SizedBox(height: 16),
        ],
        if (composed.isNotEmpty) ...[
          _buildSectionHeader(
            'Composed Dishes',
            composed.length,
            Colors.orange,
            Icons.dinner_dining,
          ),
          const SizedBox(height: 8),
          ...composed.map((item) => _buildFoodItemCard(context, item)),
          const SizedBox(height: 16),
        ],
        if (packaged.isNotEmpty) ...[
          _buildSectionHeader(
            'Packaged Foods',
            packaged.length,
            Colors.blue,
            Icons.shopping_bag,
          ),
          const SizedBox(height: 8),
          ...packaged.map((item) => _buildFoodItemCard(context, item)),
        ],
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildSectionHeader(
    String title,
    int count,
    Color color,
    IconData icon,
  ) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildFoodItemCard(BuildContext context, FoodItem item) {
    final color = switch (item.type) {
      FoodItemType.simple => Colors.green,
      FoodItemType.composed => Colors.orange,
      FoodItemType.packaged => Colors.blue,
    };
    final typeIcon = switch (item.type) {
      FoodItemType.simple => Icons.restaurant,
      FoodItemType.composed => Icons.dinner_dining,
      FoodItemType.packaged => Icons.shopping_bag,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: color.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(typeIcon, color: color, size: 18),
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.grey[400], size: 20),
          tooltip: 'Options for ${item.name}',
          onSelected: (value) {
            if (value == 'edit') {
              Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => FoodItemEditScreen(
                    profileId: widget.profileId,
                    foodItem: item,
                  ),
                ),
              );
            } else if (value == 'archive') {
              _archiveItem(item);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'archive', child: Text('Archive')),
          ],
        ),
        onTap: () => Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) =>
                FoodItemEditScreen(profileId: widget.profileId, foodItem: item),
          ),
        ),
      ),
    );
  }

  void _showAddOptionsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Food Item',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.restaurant, color: Colors.white),
                ),
                title: const Text('Simple Item'),
                subtitle: const Text('Individual ingredient'),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          FoodItemEditScreen(profileId: widget.profileId),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.dinner_dining, color: Colors.white),
                ),
                title: const Text('Composed Dish'),
                subtitle: const Text('Combination of simple items'),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          FoodItemEditScreen(profileId: widget.profileId),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _archiveItem(FoodItem item) async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: 'Archive Food Item?',
      contentText: 'This item will be moved to archives.',
      confirmButtonText: 'Archive',
    );
    if (confirmed ?? false) {
      try {
        await ref
            .read(foodItemListProvider(widget.profileId).notifier)
            .archive(
              ArchiveFoodItemInput(id: item.id, profileId: widget.profileId),
            );
        if (mounted) {
          showAccessibleSnackBar(context: context, message: 'Item archived');
        }
      } on Exception catch (e) {
        if (mounted) {
          showAccessibleSnackBar(context: context, message: 'Error: $e');
        }
      }
    }
  }
}
