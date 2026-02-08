// lib/presentation/screens/food_items/food_item_edit_screen.dart
// Implements 38_UI_FIELD_SPECIFICATIONS.md Section 5.2 - Add/Edit Food Item

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/food_items/food_items_usecases.dart';
import 'package:shadow_app/presentation/providers/food_items/food_item_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Screen for adding or editing a food item.
///
/// Follows 38_UI_FIELD_SPECIFICATIONS.md Section 5.2 exactly.
/// Uses [ConsumerStatefulWidget] for form state management.
class FoodItemEditScreen extends ConsumerStatefulWidget {
  final String profileId;
  final FoodItem? foodItem;

  const FoodItemEditScreen({super.key, required this.profileId, this.foodItem});

  @override
  ConsumerState<FoodItemEditScreen> createState() => _FoodItemEditScreenState();
}

class _FoodItemEditScreenState extends ConsumerState<FoodItemEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;
  late FoodItemType _selectedType;
  List<String> _selectedIngredientIds = [];
  bool _isSaving = false;

  bool get _isEditing => widget.foodItem != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.foodItem?.name ?? '');
    _notesController = TextEditingController(
      text: widget.foodItem?.servingSize ?? '',
    );
    _selectedType = widget.foodItem?.type ?? FoodItemType.simple;
    _selectedIngredientIds = List<String>.from(
      widget.foodItem?.simpleItemIds ?? [],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Food Item' : 'Add Food Item'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveForm,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Food Name field - Required, Min 2 chars, Max 200
            Semantics(
              label: 'Food name, required',
              child: ShadowTextField(
                controller: _nameController,
                label: 'Food Name',
                hintText: 'e.g., Grilled Chicken',
                maxLength: 200,
                textInputAction: TextInputAction.next,
                errorText: _getNameError(),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 24),

            // Type segment - Required, Simple/Composed, Default Simple
            Semantics(
              label: 'Food category, optional',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Type', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  SegmentedButton<FoodItemType>(
                    segments: const [
                      ButtonSegment(
                        value: FoodItemType.simple,
                        label: Text('Simple'),
                        icon: Icon(Icons.restaurant),
                      ),
                      ButtonSegment(
                        value: FoodItemType.complex,
                        label: Text('Composed'),
                        icon: Icon(Icons.menu_book),
                      ),
                    ],
                    selected: {_selectedType},
                    onSelectionChanged: (selected) {
                      if (selected.isNotEmpty) {
                        setState(() => _selectedType = selected.first);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Ingredients (conditional - only for Composed type)
            if (_selectedType == FoodItemType.complex) ...[
              Semantics(
                label: 'Ingredients, required for composed items',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ingredients', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    _buildIngredientsSelector(context),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Notes field - Optional, Max 1000
            Semantics(
              label: 'Food notes, optional',
              child: ShadowTextField(
                controller: _notesController,
                label: 'Notes',
                hintText: 'Notes about this food',
                maxLength: 1000,
                maxLines: 4,
                textInputAction: TextInputAction.done,
              ),
            ),
            const SizedBox(height: 32),

            // Save button
            ShadowButton(
              onPressed: _isSaving ? null : _saveForm,
              label: _isEditing ? 'Update food item' : 'Save food item',
              child: Text(_isEditing ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsSelector(BuildContext context) {
    final theme = Theme.of(context);
    final foodItemsAsync = ref.watch(foodItemListProvider(widget.profileId));

    return foodItemsAsync.when(
      data: (foodItems) {
        final simpleItems = foodItems
            .where((f) => f.isSimple && f.isActive)
            .toList();

        if (simpleItems.isEmpty) {
          return Text(
            'No simple food items available. Create simple items first.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          );
        }

        return ShadowPicker.multiSelect(
          label: 'Select ingredients...',
          selectedItems: _selectedIngredientIds,
          availableItems: simpleItems.map((f) => f.id).toList(),
          onSelectionChanged: (selected) {
            setState(() => _selectedIngredientIds = selected);
          },
        );
      },
      loading: () => const Center(
        child: ShadowStatus.loading(label: 'Loading ingredients'),
      ),
      error: (error, _) => Text(
        'Failed to load ingredients',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
    );
  }

  String? _getNameError() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return null;
    if (name.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  bool _validateForm() {
    final name = _nameController.text.trim();
    if (name.isEmpty || name.length < 2) {
      showAccessibleSnackBar(
        context: context,
        message: 'Food name is required (min 2 characters)',
      );
      return false;
    }
    if (name.length > 200) {
      showAccessibleSnackBar(
        context: context,
        message: 'Food name must be 200 characters or less',
      );
      return false;
    }
    if (_selectedType == FoodItemType.complex &&
        _selectedIngredientIds.isEmpty) {
      showAccessibleSnackBar(
        context: context,
        message: 'Composed items require at least one ingredient',
      );
      return false;
    }
    return true;
  }

  Future<void> _saveForm() async {
    if (!_validateForm()) return;
    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(
        foodItemListProvider(widget.profileId).notifier,
      );
      final name = _nameController.text.trim();
      final notes = _notesController.text.trim();

      if (_isEditing) {
        await notifier.updateItem(
          UpdateFoodItemInput(
            id: widget.foodItem!.id,
            profileId: widget.profileId,
            name: name,
            type: _selectedType,
            simpleItemIds: _selectedType == FoodItemType.complex
                ? _selectedIngredientIds
                : [],
            servingSize: notes.isNotEmpty ? notes : null,
          ),
        );
      } else {
        await notifier.create(
          CreateFoodItemInput(
            profileId: widget.profileId,
            clientId: const Uuid().v4(),
            name: name,
            type: _selectedType,
            simpleItemIds: _selectedType == FoodItemType.complex
                ? _selectedIngredientIds
                : [],
            servingSize: notes.isNotEmpty ? notes : null,
          ),
        );
      }

      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: _isEditing ? 'Food item updated' : 'Food item created',
        );
        Navigator.of(context).pop();
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
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
