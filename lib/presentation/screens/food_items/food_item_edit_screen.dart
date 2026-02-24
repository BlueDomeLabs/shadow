// lib/presentation/screens/food_items/food_item_edit_screen.dart
// Implements 38_UI_FIELD_SPECIFICATIONS.md Section 5.2 + 59a_FOOD_DATABASE_EXTENSION.md
// Updated in Phase 15a: 3-segment type, nutritional fields, Packaged type, scan flows

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/food_items/food_items_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/food_items/food_item_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// A component being edited in the Composed type ingredient list.
class _ComponentEntry {
  final String simpleFoodItemId;
  double quantity;

  _ComponentEntry({required this.simpleFoodItemId, required this.quantity});
}

/// Screen for adding or editing a food item.
///
/// Follows 38_UI_FIELD_SPECIFICATIONS.md Section 5.2 + 59a_FOOD_DATABASE_EXTENSION.md.
/// Supports Simple, Composed (with quantity multipliers), and Packaged types.
class FoodItemEditScreen extends ConsumerStatefulWidget {
  final String profileId;
  final FoodItem? foodItem;

  const FoodItemEditScreen({super.key, required this.profileId, this.foodItem});

  @override
  ConsumerState<FoodItemEditScreen> createState() => _FoodItemEditScreenState();
}

class _FoodItemEditScreenState extends ConsumerState<FoodItemEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Basic fields
  late final TextEditingController _nameController;
  late final TextEditingController _servingSizeController;

  // Nutritional fields (Simple + Packaged only — Composed are calculated)
  late final TextEditingController _caloriesController;
  late final TextEditingController _proteinController;
  late final TextEditingController _carbsController;
  late final TextEditingController _fiberController;
  late final TextEditingController _sugarController;
  late final TextEditingController _fatController;
  late final TextEditingController _sodiumController;

  // Packaged-type fields
  late final TextEditingController _brandController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _ingredientsTextController;
  String? _importSource; // "open_food_facts", "claude_scan", "manual"
  String? _imageUrl;
  String? _openFoodFactsId;

  // Composed-type state
  List<_ComponentEntry> _components = [];

  // Type selector
  late FoodItemType _selectedType;

  bool _isSaving = false;
  bool get _isEditing => widget.foodItem != null;

  String? get _nameError {
    final name = _nameController.text;
    if (name.isEmpty) return null;
    if (name.length < ValidationRules.nameMinLength) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    final item = widget.foodItem;

    _nameController = TextEditingController(text: item?.name ?? '');
    _servingSizeController = TextEditingController(
      text: item?.servingSize ?? '',
    );

    // Nutritional controllers
    _caloriesController = TextEditingController(
      text: item?.calories?.toString() ?? '',
    );
    _proteinController = TextEditingController(
      text: item?.proteinGrams?.toString() ?? '',
    );
    _carbsController = TextEditingController(
      text: item?.carbsGrams?.toString() ?? '',
    );
    _fiberController = TextEditingController(
      text: item?.fiberGrams?.toString() ?? '',
    );
    _sugarController = TextEditingController(
      text: item?.sugarGrams?.toString() ?? '',
    );
    _fatController = TextEditingController(
      text: item?.fatGrams?.toString() ?? '',
    );
    _sodiumController = TextEditingController(
      text: item?.sodiumMg?.toString() ?? '',
    );

    // Packaged controllers
    _brandController = TextEditingController(text: item?.brand ?? '');
    _barcodeController = TextEditingController(text: item?.barcode ?? '');
    _ingredientsTextController = TextEditingController(
      text: item?.ingredientsText ?? '',
    );
    _importSource = item?.importSource;
    _imageUrl = item?.imageUrl;
    _openFoodFactsId = item?.openFoodFactsId;

    _selectedType = item?.type ?? FoodItemType.simple;

    // Build initial component entries from simpleItemIds
    if (item != null && item.isComposed) {
      _components = item.simpleItemIds
          .map((id) => _ComponentEntry(simpleFoodItemId: id, quantity: 1))
          .toList();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _servingSizeController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fiberController.dispose();
    _sugarController.dispose();
    _fatController.dispose();
    _sodiumController.dispose();
    _brandController.dispose();
    _barcodeController.dispose();
    _ingredientsTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foodItemsAsync = ref.watch(foodItemListProvider(widget.profileId));

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
            // Food Name field
            Semantics(
              label: 'Food name, required',
              child: ShadowTextField(
                controller: _nameController,
                label: 'Food Name',
                hintText: 'e.g., Grilled Chicken',
                maxLength: ValidationRules.foodNameMaxLength,
                textInputAction: TextInputAction.next,
                onChanged: (_) => setState(() {}),
                errorText: _nameError,
              ),
            ),
            const SizedBox(height: 24),

            // Type segment — 3 options
            Semantics(
              label: 'Food type, required',
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
                        value: FoodItemType.composed,
                        label: Text('Composed'),
                        icon: Icon(Icons.menu_book),
                      ),
                      ButtonSegment(
                        value: FoodItemType.packaged,
                        label: Text('Packaged'),
                        icon: Icon(Icons.inventory_2),
                      ),
                    ],
                    selected: {_selectedType},
                    onSelectionChanged: (selected) {
                      if (selected.isNotEmpty) {
                        setState(() {
                          _selectedType = selected.first;
                          // Clear components if switching away from Composed
                          if (_selectedType != FoodItemType.composed) {
                            _components = [];
                          }
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Packaged-type scan shortcuts
            if (_selectedType == FoodItemType.packaged) ...[
              _buildScanShortcuts(theme),
              const SizedBox(height: 24),
            ],

            // Composed ingredient list
            if (_selectedType == FoodItemType.composed) ...[
              Semantics(
                label: 'Ingredients, required for composed items',
                header: true,
                child: Text(
                  'Ingredients',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              foodItemsAsync.when(
                data: (items) => _buildComposedIngredients(theme, items),
                loading: () => const Center(
                  child: ShadowStatus.loading(label: 'Loading items'),
                ),
                error: (_, _) => Text(
                  'Failed to load food items',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Nutritional Data section
            _buildSectionHeader(theme, 'Nutritional Data'),
            const SizedBox(height: 12),
            if (_selectedType == FoodItemType.composed)
              foodItemsAsync.when(
                data: (items) => _buildComposedNutrition(theme, items),
                loading: () => const Center(
                  child: ShadowStatus.loading(label: 'Calculating'),
                ),
                error: (_, _) => const SizedBox.shrink(),
              )
            else
              _buildEditableNutrition(theme),
            const SizedBox(height: 24),

            // Packaged-type additional fields
            if (_selectedType == FoodItemType.packaged) ...[
              _buildSectionHeader(theme, 'Product Information'),
              const SizedBox(height: 12),
              _buildPackagedFields(theme),
              const SizedBox(height: 24),
            ],

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

  // --- Section builders ---

  Widget _buildSectionHeader(ThemeData theme, String title) => Semantics(
    header: true,
    child: Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildScanShortcuts(ThemeData theme) => Row(
    children: [
      Expanded(
        child: OutlinedButton.icon(
          onPressed: _scanBarcode,
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Scan Barcode'),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: OutlinedButton.icon(
          onPressed: _scanLabel,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Scan Label'),
        ),
      ),
    ],
  );

  Widget _buildEditableNutrition(ThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ShadowTextField(
        controller: _servingSizeController,
        label: 'Serving Size',
        hintText: 'e.g., 1 cup, 100g',
        maxLength: ValidationRules.servingSizeMaxLength,
        textInputAction: TextInputAction.next,
      ),
      const SizedBox(height: 12),
      _buildNutrientRow(_caloriesController, 'Calories', 'kcal'),
      const SizedBox(height: 12),
      _buildNutrientRow(_proteinController, 'Protein', 'g'),
      const SizedBox(height: 12),
      _buildNutrientRow(_carbsController, 'Total Carbohydrates', 'g'),
      const SizedBox(height: 12),
      _buildNutrientRow(_fiberController, 'Dietary Fiber', 'g'),
      const SizedBox(height: 12),
      _buildNutrientRow(_sugarController, 'Sugar', 'g'),
      const SizedBox(height: 12),
      _buildNutrientRow(_fatController, 'Total Fat', 'g'),
      const SizedBox(height: 12),
      _buildNutrientRow(_sodiumController, 'Sodium', 'mg'),
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
          onChanged: (_) => setState(() {}),
        ),
      ),
      const SizedBox(width: 8),
      Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Text(unit, style: const TextStyle(fontSize: 14)),
      ),
    ],
  );

  Widget _buildComposedNutrition(ThemeData theme, List<FoodItem> allItems) {
    final nutrition = _calcComposedNutrition(allItems);

    if (_components.isEmpty) {
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
          _servingSizeController.text.isEmpty
              ? null
              : _servingSizeController.text,
          null,
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

  Widget _buildComposedIngredients(ThemeData theme, List<FoodItem> allItems) {
    final simpleItems = allItems
        .where((f) => f.isSimple && f.isActive)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Component rows
        ..._components.asMap().entries.map((entry) {
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
                      item!.servingSize!,
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
                        setState(() => _components[index].quantity = qty);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  tooltip: 'Remove ingredient',
                  onPressed: () {
                    setState(() => _components.removeAt(index));
                  },
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              ],
            ),
          );
        }),

        // Add ingredient button
        if (simpleItems.isEmpty)
          Text(
            'No simple food items available. Create simple items first.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          TextButton.icon(
            onPressed: () => _showAddIngredientDialog(simpleItems),
            icon: const Icon(Icons.add),
            label: const Text('Add Ingredient'),
          ),
      ],
    );
  }

  Widget _buildPackagedFields(ThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ShadowTextField(
        controller: _brandController,
        label: 'Brand',
        hintText: 'e.g., Organic Valley',
        maxLength: ValidationRules.nameMaxLength,
        textInputAction: TextInputAction.next,
      ),
      const SizedBox(height: 12),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ShadowTextField(
              controller: _barcodeController,
              label: 'Barcode',
              hintText: 'e.g., 012345678901',
              maxLength: 13,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: IconButton(
              onPressed: _scanBarcode,
              icon: const Icon(Icons.qr_code_scanner),
              tooltip: 'Scan barcode',
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.secondaryContainer,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      ShadowTextField(
        controller: _ingredientsTextController,
        label: 'Ingredients',
        hintText: 'Ingredients list as printed on label',
        maxLength: 5000,
        maxLines: 4,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
      ),
      if (_importSource != null) ...[
        const SizedBox(height: 12),
        _buildImportSourceBadge(theme),
      ],
    ],
  );

  Widget _buildImportSourceBadge(ThemeData theme) {
    final label = switch (_importSource) {
      'open_food_facts' => 'Open Food Facts',
      'claude_scan' => 'Photo Scan',
      'manual' => 'Manual Entry',
      _ => _importSource!,
    };

    return Row(
      children: [
        Icon(
          Icons.info_outline,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          'Source: $label',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // --- Nutritional calculation for Composed type ---

  /// Returns a map of field name → calculated value (or _Incomplete sentinel).
  Map<String, Object?> _calcComposedNutrition(List<FoodItem> allItems) {
    if (_components.isEmpty) return {};

    double? calories = 0;
    double? carbs = 0;
    double? fat = 0;
    double? protein = 0;
    double? fiber = 0;
    double? sugar = 0;
    double? sodium = 0;

    for (final comp in _components) {
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

  /// If accumulator is null (already incomplete) → stays null.
  /// If value is null → null (mark incomplete).
  /// Otherwise: accumulator + value * quantity.
  double? _addNutrient(double? acc, double? value, double quantity) {
    if (acc == null) return null;
    if (value == null) return null;
    return acc + value * quantity;
  }

  // --- Dialogs ---

  Future<void> _showAddIngredientDialog(List<FoodItem> simpleItems) async {
    // Filter out already-added items
    final alreadyAdded = _components.map((c) => c.simpleFoodItemId).toSet();
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
                    ? Text(item.servingSize!)
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
      setState(() {
        _components.add(
          _ComponentEntry(simpleFoodItemId: selected.id, quantity: 1),
        );
      });
    }
  }

  // --- Scan actions ---

  Future<void> _scanBarcode() async {
    if (_selectedType != FoodItemType.packaged) return;

    final scanned = await _openBarcodeScanner();
    if (scanned == null || !mounted) return;

    setState(() => _barcodeController.text = scanned);

    // Look up the barcode
    final useCase = ref.read(lookupBarcodeUseCaseProvider);
    final result = await useCase(LookupBarcodeInput(barcode: scanned));

    if (!mounted) return;

    result.when(
      success: (data) {
        if (data == null) {
          showAccessibleSnackBar(
            context: context,
            message: 'Product not found in database — enter details manually',
          );
          return;
        }
        _confirmBarcodeImport(data);
      },
      failure: (error) =>
          showAccessibleSnackBar(context: context, message: error.userMessage),
    );
  }

  Future<String?> _openBarcodeScanner() => showDialog<String>(
    context: context,
    builder: (ctx) {
      final controller = MobileScannerController();
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: 300,
          height: 300,
          child: MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final barcode = capture.barcodes.firstOrNull?.rawValue;
              if (barcode != null) {
                controller.dispose();
                Navigator.of(ctx).pop(barcode);
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.dispose();
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );

  void _confirmBarcodeImport(BarcodeLookupResult data) {
    final name = data.productName ?? 'Unknown product';
    final brand = data.brand ?? '';
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Import Product Data?'),
        content: Text(
          'Found: $name${brand.isNotEmpty ? ' by $brand' : ''}.\nImport nutritional data?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    ).then((confirmed) {
      if ((confirmed ?? false) && mounted) {
        setState(() {
          if (data.productName != null) {
            _nameController.text = data.productName!;
          }
          if (data.brand != null) _brandController.text = data.brand!;
          if (data.ingredientsText != null) {
            _ingredientsTextController.text = data.ingredientsText!;
          }
          if (data.calories != null) {
            _caloriesController.text = data.calories!.toStringAsFixed(1);
          }
          if (data.protein != null) {
            _proteinController.text = data.protein!.toStringAsFixed(1);
          }
          if (data.carbs != null) {
            _carbsController.text = data.carbs!.toStringAsFixed(1);
          }
          if (data.fiber != null) {
            _fiberController.text = data.fiber!.toStringAsFixed(1);
          }
          if (data.sugar != null) {
            _sugarController.text = data.sugar!.toStringAsFixed(1);
          }
          if (data.fat != null) {
            _fatController.text = data.fat!.toStringAsFixed(1);
          }
          if (data.sodiumMg != null) {
            _sodiumController.text = data.sodiumMg!.toStringAsFixed(1);
          }
          _openFoodFactsId = data.openFoodFactsId;
          _imageUrl = data.imageUrl;
          _importSource = 'open_food_facts';
        });
      }
    });
  }

  Future<void> _scanLabel() async {
    final picker = image_picker.ImagePicker();
    image_picker.XFile? photo;
    try {
      photo = await picker.pickImage(source: image_picker.ImageSource.camera);
    } on Exception {
      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: 'Camera not available on this device',
        );
      }
      return;
    }

    if (photo == null || !mounted) return;

    setState(() => _isSaving = true);
    try {
      final bytes = await photo.readAsBytes();
      final useCase = ref.read(scanIngredientPhotoUseCaseProvider);
      final result = await useCase(ScanIngredientPhotoInput(imageBytes: bytes));

      if (!mounted) return;

      result.when(
        success: (data) {
          if (data == null) {
            showAccessibleSnackBar(
              context: context,
              message: 'Could not extract data — enter details manually',
            );
            return;
          }
          setState(() {
            if (data.productName != null) {
              _nameController.text = data.productName!;
            }
            if (data.calories != null) {
              _caloriesController.text = data.calories!.toStringAsFixed(1);
            }
            if (data.protein != null) {
              _proteinController.text = data.protein!.toStringAsFixed(1);
            }
            if (data.carbs != null) {
              _carbsController.text = data.carbs!.toStringAsFixed(1);
            }
            if (data.fiber != null) {
              _fiberController.text = data.fiber!.toStringAsFixed(1);
            }
            if (data.sugar != null) {
              _sugarController.text = data.sugar!.toStringAsFixed(1);
            }
            if (data.fat != null) {
              _fatController.text = data.fat!.toStringAsFixed(1);
            }
            if (data.sodiumMg != null) {
              _sodiumController.text = data.sodiumMg!.toStringAsFixed(1);
            }
            _importSource = 'claude_scan';
          });
          showAccessibleSnackBar(
            context: context,
            message: 'Label scanned — review extracted data',
          );
        },
        failure: (error) => showAccessibleSnackBar(
          context: context,
          message: error.userMessage,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // --- Validation ---

  bool _validateForm() {
    final name = _nameController.text.trim();
    if (name.isEmpty || name.length < ValidationRules.nameMinLength) {
      showAccessibleSnackBar(
        context: context,
        message: 'Food name is required (min 2 characters)',
      );
      return false;
    }
    if (name.length > ValidationRules.foodNameMaxLength) {
      showAccessibleSnackBar(
        context: context,
        message:
            'Food name must be ${ValidationRules.foodNameMaxLength} characters or less',
      );
      return false;
    }
    if (_selectedType == FoodItemType.composed && _components.isEmpty) {
      showAccessibleSnackBar(
        context: context,
        message: 'Composed items require at least one ingredient',
      );
      return false;
    }
    final barcode = _barcodeController.text.trim();
    if (_selectedType == FoodItemType.packaged &&
        barcode.isNotEmpty &&
        barcode.length != 8 &&
        barcode.length != 12 &&
        barcode.length != 13) {
      showAccessibleSnackBar(
        context: context,
        message: 'Barcode must be 8, 12, or 13 digits',
      );
      return false;
    }
    return true;
  }

  // --- Save ---

  Future<void> _saveForm() async {
    if (!_validateForm()) return;
    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(
        foodItemListProvider(widget.profileId).notifier,
      );
      final name = _nameController.text.trim();
      final servingSize = _servingSizeController.text.trim();
      final calories = double.tryParse(_caloriesController.text.trim());
      final protein = double.tryParse(_proteinController.text.trim());
      final carbs = double.tryParse(_carbsController.text.trim());
      final fiber = double.tryParse(_fiberController.text.trim());
      final sugar = double.tryParse(_sugarController.text.trim());
      final fat = double.tryParse(_fatController.text.trim());
      final sodium = double.tryParse(_sodiumController.text.trim());
      final brand = _brandController.text.trim();
      final barcode = _barcodeController.text.trim();
      final ingredientsText = _ingredientsTextController.text.trim();

      // For composed items, build components list and simpleItemIds
      final componentInputs = _selectedType == FoodItemType.composed
          ? _components
                .map(
                  (c) => FoodItemComponentInput(
                    simpleFoodItemId: c.simpleFoodItemId,
                    quantity: c.quantity,
                  ),
                )
                .toList()
          : <FoodItemComponentInput>[];
      final simpleItemIds = _selectedType == FoodItemType.composed
          ? _components.map((c) => c.simpleFoodItemId).toList()
          : <String>[];

      if (_isEditing) {
        await notifier.updateItem(
          UpdateFoodItemInput(
            id: widget.foodItem!.id,
            profileId: widget.profileId,
            name: name,
            type: _selectedType,
            simpleItemIds: simpleItemIds,
            components: componentInputs,
            servingSize: servingSize.isNotEmpty ? servingSize : null,
            calories: calories,
            proteinGrams: protein,
            carbsGrams: carbs,
            fiberGrams: fiber,
            sugarGrams: sugar,
            fatGrams: fat,
            sodiumMg: sodium,
            brand: brand.isNotEmpty ? brand : null,
            barcode: barcode.isNotEmpty ? barcode : null,
            ingredientsText: ingredientsText.isNotEmpty
                ? ingredientsText
                : null,
            openFoodFactsId: _openFoodFactsId,
            importSource: _importSource,
            imageUrl: _imageUrl,
          ),
        );
      } else {
        await notifier.create(
          CreateFoodItemInput(
            profileId: widget.profileId,
            clientId: const Uuid().v4(),
            name: name,
            type: _selectedType,
            simpleItemIds: simpleItemIds,
            components: componentInputs,
            servingSize: servingSize.isNotEmpty ? servingSize : null,
            calories: calories,
            proteinGrams: protein,
            carbsGrams: carbs,
            fiberGrams: fiber,
            sugarGrams: sugar,
            fatGrams: fat,
            sodiumMg: sodium,
            brand: brand.isNotEmpty ? brand : null,
            barcode: barcode.isNotEmpty ? barcode : null,
            ingredientsText: ingredientsText.isNotEmpty
                ? ingredientsText
                : null,
            openFoodFactsId: _openFoodFactsId,
            importSource: _importSource,
            imageUrl: _imageUrl,
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

/// Sentinel value to indicate a nutritional field is incomplete (some
/// components are missing that value).
class _Incomplete {
  const _Incomplete();
}
