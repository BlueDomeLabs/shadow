// lib/presentation/screens/food_items/food_item_editable_nutrition_section.dart

import 'package:flutter/material.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Editable nutrition fields for Simple and Packaged food item types.
///
/// Renders serving size, unit, and all seven nutrient rows. Controllers are
/// owned by the parent screen.
class FoodItemEditableNutritionSection extends StatelessWidget {
  final TextEditingController servingSizeAmountController;
  final TextEditingController servingUnitController;
  final TextEditingController caloriesController;
  final TextEditingController proteinController;
  final TextEditingController carbsController;
  final TextEditingController fiberController;
  final TextEditingController sugarController;
  final TextEditingController fatController;
  final TextEditingController sodiumController;

  const FoodItemEditableNutritionSection({
    super.key,
    required this.servingSizeAmountController,
    required this.servingUnitController,
    required this.caloriesController,
    required this.proteinController,
    required this.carbsController,
    required this.fiberController,
    required this.sugarController,
    required this.fatController,
    required this.sodiumController,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: ShadowTextField(
              controller: servingSizeAmountController,
              label: 'Serving Size',
              hintText: 'e.g., 100',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: ShadowTextField(
              controller: servingUnitController,
              label: 'Unit',
              hintText: 'e.g., g, cup, oz',
              textInputAction: TextInputAction.next,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      _buildNutrientRow(caloriesController, 'Calories', 'kcal'),
      const SizedBox(height: 12),
      _buildNutrientRow(proteinController, 'Protein', 'g'),
      const SizedBox(height: 12),
      _buildNutrientRow(carbsController, 'Total Carbohydrates', 'g'),
      const SizedBox(height: 12),
      _buildNutrientRow(fiberController, 'Dietary Fiber', 'g'),
      const SizedBox(height: 12),
      _buildNutrientRow(sugarController, 'Sugar', 'g'),
      const SizedBox(height: 12),
      _buildNutrientRow(fatController, 'Total Fat', 'g'),
      const SizedBox(height: 12),
      _buildNutrientRow(sodiumController, 'Sodium', 'mg'),
    ],
  );

  Widget _buildNutrientRow(
    TextEditingController controller,
    String label,
    String unit,
  ) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: ShadowTextField.numeric(
          controller: controller,
          label: label,
          hintText: 'optional',
          textInputAction: TextInputAction.next,
        ),
      ),
      const SizedBox(width: 8),
      Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Text(unit, style: const TextStyle(fontSize: 14)),
      ),
    ],
  );
}
