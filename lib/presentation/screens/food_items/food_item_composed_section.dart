// lib/presentation/screens/food_items/food_item_composed_section.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// A component being edited in the Composed type ingredient list.
class FoodItemComponentEntry {
  final String simpleFoodItemId;
  double quantity;

  FoodItemComponentEntry({
    required this.simpleFoodItemId,
    required this.quantity,
  });
}

/// Sentinel value to indicate a nutritional field is incomplete (some
/// components are missing that value).
class _Incomplete {
  const _Incomplete();
}

/// Composed food item section: ingredient list with quantity editing and
/// read-only calculated nutrition totals.
///
/// The parent owns the [components] list and must rebuild when
/// [onComponentsChanged] fires.
class FoodItemComposedSection extends StatelessWidget {
  final List<FoodItemComponentEntry> components;
  final List<FoodItem> allItems;
  final TextEditingController servingSizeAmountController;
  final TextEditingController servingUnitController;
  final void Function(List<FoodItemComponentEntry>) onComponentsChanged;

  const FoodItemComposedSection({
    super.key,
    required this.components,
    required this.allItems,
    required this.servingSizeAmountController,
    required this.servingUnitController,
    required this.onComponentsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final simpleItems = allItems
        .where((f) => f.isSimple && f.isActive)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Ingredient rows ---
        ..._buildIngredientRows(context, theme, simpleItems),

        // Add Ingredient button or empty message
        if (simpleItems.isEmpty)
          Text(
            'No simple food items available. Create simple items first.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          TextButton.icon(
            onPressed: () => _showAddIngredientDialog(context, simpleItems),
            icon: const Icon(Icons.add),
            label: const Text('Add Ingredient'),
          ),

        const SizedBox(height: 24),

        // --- Calculated nutrition totals ---
        _buildComposedNutrition(theme),
      ],
    );
  }

  List<Widget> _buildIngredientRows(
    BuildContext context,
    ThemeData theme,
    List<FoodItem> simpleItems,
  ) => components.asMap().entries.map((entry) {
    final index = entry.key;
    final component = entry.value;
    final item = simpleItems
        .where((f) => f.id == component.simpleFoodItemId)
        .firstOrNull;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item?.name ?? '(Unknown item)',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          if (item?.servingSize != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                [
                  item!.servingSize!.toString(),
                  if (item.servingUnit != null) item.servingUnit!,
                ].join(' '),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          SizedBox(
            width: 70,
            child: TextField(
              key: ValueKey('qty_$index'),
              decoration: const InputDecoration(
                labelText: 'Qty',
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              controller: TextEditingController(
                text: component.quantity.toString(),
              )..addListener(() {}),
              onChanged: (val) {
                final qty = double.tryParse(val);
                if (qty != null && qty > 0) {
                  final updated = List<FoodItemComponentEntry>.from(components);
                  updated[index] = FoodItemComponentEntry(
                    simpleFoodItemId: component.simpleFoodItemId,
                    quantity: qty,
                  );
                  onComponentsChanged(updated);
                }
              },
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            tooltip: 'Remove ingredient',
            onPressed: () {
              onComponentsChanged(
                List<FoodItemComponentEntry>.from(components)..removeAt(index),
              );
            },
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ],
      ),
    );
  }).toList();

  Widget _buildComposedNutrition(ThemeData theme) {
    final nutrition = _calcComposedNutrition();

    if (components.isEmpty) {
      return Text(
        'Add ingredients to see nutritional totals.',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNutrientReadOnly(
          theme,
          'Serving Size',
          servingSizeAmountController.text.isEmpty
              ? null
              : servingSizeAmountController.text,
          servingUnitController.text.isEmpty
              ? null
              : servingUnitController.text,
        ),
        const SizedBox(height: 8),
        _buildNutrientReadOnly(
          theme,
          'Calories',
          nutrition['calories'],
          'kcal',
        ),
        const SizedBox(height: 8),
        _buildNutrientReadOnly(theme, 'Protein', nutrition['protein'], 'g'),
        const SizedBox(height: 8),
        _buildNutrientReadOnly(
          theme,
          'Total Carbohydrates',
          nutrition['carbs'],
          'g',
        ),
        const SizedBox(height: 8),
        _buildNutrientReadOnly(theme, 'Dietary Fiber', nutrition['fiber'], 'g'),
        const SizedBox(height: 8),
        _buildNutrientReadOnly(theme, 'Sugar', nutrition['sugar'], 'g'),
        const SizedBox(height: 8),
        _buildNutrientReadOnly(theme, 'Total Fat', nutrition['fat'], 'g'),
        const SizedBox(height: 8),
        _buildNutrientReadOnly(theme, 'Sodium', nutrition['sodium'], 'mg'),
      ],
    );
  }

  Widget _buildNutrientReadOnly(
    ThemeData theme,
    String label,
    Object? value,
    String? unit,
  ) {
    String displayValue;
    if (value == null) {
      displayValue = '—';
    } else if (value is double) {
      displayValue =
          '${value.toStringAsFixed(1)}${unit != null ? ' $unit' : ''}';
    } else {
      displayValue = value.toString();
    }

    final isIncomplete = value is _Incomplete;
    final textColor = isIncomplete ? theme.colorScheme.onSurfaceVariant : null;

    return Row(
      children: [
        SizedBox(
          width: 180,
          child: Text('$label:', style: theme.textTheme.bodyMedium),
        ),
        Expanded(
          child: Text(
            isIncomplete ? 'Incomplete' : displayValue,
            style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
          ),
        ),
      ],
    );
  }

  Map<String, Object?> _calcComposedNutrition() {
    if (components.isEmpty) return {};

    double? calories = 0;
    double? carbs = 0;
    double? fat = 0;
    double? protein = 0;
    double? fiber = 0;
    double? sugar = 0;
    double? sodium = 0;

    for (final comp in components) {
      final item = allItems
          .where((f) => f.id == comp.simpleFoodItemId)
          .firstOrNull;
      if (item == null) continue;

      final q = comp.quantity;
      calories = _addNutrient(calories, item.calories, q);
      carbs = _addNutrient(carbs, item.carbsGrams, q);
      fat = _addNutrient(fat, item.fatGrams, q);
      protein = _addNutrient(protein, item.proteinGrams, q);
      fiber = _addNutrient(fiber, item.fiberGrams, q);
      sugar = _addNutrient(sugar, item.sugarGrams, q);
      sodium = _addNutrient(sodium, item.sodiumMg, q);
    }

    return {
      'calories': calories ?? const _Incomplete(),
      'carbs': carbs ?? const _Incomplete(),
      'fat': fat ?? const _Incomplete(),
      'protein': protein ?? const _Incomplete(),
      'fiber': fiber ?? const _Incomplete(),
      'sugar': sugar ?? const _Incomplete(),
      'sodium': sodium ?? const _Incomplete(),
    };
  }

  double? _addNutrient(double? acc, double? value, double quantity) {
    if (acc == null) return null;
    if (value == null) return null;
    return acc + value * quantity;
  }

  Future<void> _showAddIngredientDialog(
    BuildContext context,
    List<FoodItem> simpleItems,
  ) async {
    final alreadyAdded = components.map((c) => c.simpleFoodItemId).toSet();
    final available = simpleItems
        .where((f) => !alreadyAdded.contains(f.id))
        .toList();

    if (available.isEmpty) {
      showAccessibleSnackBar(
        context: context,
        message: 'All available simple items are already added',
      );
      return;
    }

    final selected = await showDialog<FoodItem>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Ingredient'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: available.length,
            itemBuilder: (_, i) {
              final item = available[i];
              return ListTile(
                title: Text(item.name),
                subtitle: item.servingSize != null
                    ? Text(
                        [
                          item.servingSize!.toString(),
                          if (item.servingUnit != null) item.servingUnit!,
                        ].join(' '),
                      )
                    : null,
                onTap: () => Navigator.of(ctx).pop(item),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (selected != null) {
      onComponentsChanged([
        ...components,
        FoodItemComponentEntry(simpleFoodItemId: selected.id, quantity: 1),
      ]);
    }
  }
}
