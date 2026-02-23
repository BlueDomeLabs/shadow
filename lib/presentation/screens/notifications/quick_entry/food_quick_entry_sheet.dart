// lib/presentation/screens/notifications/quick_entry/food_quick_entry_sheet.dart
// Per 57_NOTIFICATION_SYSTEM.md — Food / Meals quick-entry sheet

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/food_logs/food_log_inputs.dart';
import 'package:shadow_app/presentation/providers/food_items/food_item_list_provider.dart';
import 'package:shadow_app/presentation/providers/food_logs/food_log_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Quick-entry sheet for Food / Meals notification category.
///
/// Opened when the user taps a Food/Meals notification.
/// Shows a searchable, multi-select list of known food items (recently logged
/// first), an "Add new food" text field for ad-hoc items, and a "Log Meal"
/// button that creates a FoodLog for all selected items.
/// Per 57_NOTIFICATION_SYSTEM.md section: Food / Meals.
class FoodQuickEntrySheet extends ConsumerStatefulWidget {
  final String profileId;

  /// Optional meal label from the anchor event (e.g. "Breakfast").
  final String? mealLabel;

  const FoodQuickEntrySheet({
    super.key,
    required this.profileId,
    this.mealLabel,
  });

  /// Shows the sheet as a modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required String profileId,
    String? mealLabel,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) =>
        FoodQuickEntrySheet(profileId: profileId, mealLabel: mealLabel),
  );

  @override
  ConsumerState<FoodQuickEntrySheet> createState() =>
      _FoodQuickEntrySheetState();
}

class _FoodQuickEntrySheetState extends ConsumerState<FoodQuickEntrySheet> {
  final _searchController = TextEditingController();
  final _adHocController = TextEditingController();
  final Set<String> _selectedFoodIds = {};
  bool _isSaving = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _adHocController.dispose();
    super.dispose();
  }

  MealType? _mealTypeFromLabel(String? label) => switch (label?.toLowerCase()) {
    'breakfast' => MealType.breakfast,
    'lunch' => MealType.lunch,
    'dinner' => MealType.dinner,
    _ => null,
  };

  List<FoodItem> _filterItems(List<FoodItem> items) {
    final q = _searchQuery.toLowerCase();
    if (q.isEmpty) return items;
    return items.where((f) => f.name.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foodItemsAsync = ref.watch(foodItemListProvider(widget.profileId));
    final title = widget.mealLabel != null
        ? 'Log ${widget.mealLabel}'
        : 'Log Meal';

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Semantics(
        label: 'Food quick-entry sheet',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              header: true,
              child: Text(title, style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 16),
            // Search field
            Semantics(
              label: 'Search food items',
              textField: true,
              child: ExcludeSemantics(
                child: ShadowTextField(
                  controller: _searchController,
                  label: 'Search foods',
                  hintText: 'Type to filter...',
                  textInputAction: TextInputAction.search,
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Food item list
            foodItemsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
              data: (items) {
                final active = items.where((f) => f.isActive).toList();
                final filtered = _filterItems(active);
                if (filtered.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _searchQuery.isNotEmpty
                          ? 'No matches for "$_searchQuery"'
                          : 'No food items defined yet.',
                      style: theme.textTheme.bodySmall,
                    ),
                  );
                }
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final food = filtered[index];
                      final isSelected = _selectedFoodIds.contains(food.id);
                      return CheckboxListTile(
                        title: Text(food.name),
                        value: isSelected,
                        onChanged: (_) => setState(() {
                          if (isSelected) {
                            _selectedFoodIds.remove(food.id);
                          } else {
                            _selectedFoodIds.add(food.id);
                          }
                        }),
                        controlAffinity: ListTileControlAffinity.leading,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            // Ad-hoc food entry
            Semantics(
              label: 'Add new food not in list, optional',
              textField: true,
              child: ExcludeSemantics(
                child: ShadowTextField(
                  controller: _adHocController,
                  label: 'Add new food',
                  hintText: 'Type a food not in the list',
                  textInputAction: TextInputAction.done,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ShadowButton.elevated(
              onPressed: _isSaving ? null : _handleSave,
              label: 'Log meal',
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Log Meal'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    final adHoc = _adHocController.text.trim();
    if (_selectedFoodIds.isEmpty && adHoc.isEmpty) {
      showAccessibleSnackBar(
        context: context,
        message: 'Select at least one food item or add a new food',
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(foodLogListProvider(widget.profileId).notifier);

      await notifier.log(
        LogFoodInput(
          profileId: widget.profileId,
          clientId: const Uuid().v4(),
          timestamp: DateTime.now().millisecondsSinceEpoch,
          mealType: _mealTypeFromLabel(widget.mealLabel),
          foodItemIds: _selectedFoodIds.toList(),
          adHocItems: adHoc.isNotEmpty ? [adHoc] : [],
        ),
      );

      if (mounted) {
        Navigator.of(context).pop();
        showAccessibleSnackBar(context: context, message: 'Meal logged');
      }
    } on AppError catch (e) {
      if (mounted) {
        showAccessibleSnackBar(context: context, message: e.userMessage);
      }
    } on Exception {
      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: 'An unexpected error occurred',
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
