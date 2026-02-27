// lib/presentation/screens/food_logs/food_log_screen.dart
// Implements 38_UI_FIELD_SPECIFICATIONS.md Section 5.1 - Food Log Screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/diet_rule.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/food_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/diet/diets_usecases.dart';
import 'package:shadow_app/domain/usecases/food_logs/food_logs_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/food_items/food_item_list_provider.dart';
import 'package:shadow_app/presentation/providers/food_logs/food_log_list_provider.dart';
import 'package:shadow_app/presentation/screens/diet/diet_violation_dialog.dart';
import 'package:shadow_app/presentation/screens/food_items/food_library_picker_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Screen for creating or editing a food log entry.
///
/// Follows 38_UI_FIELD_SPECIFICATIONS.md Section 5.1 exactly.
/// Uses [FoodLogList] provider for state management via log/updateLog.
///
/// Fields:
/// - Date & Time: DateTime picker (required, not future)
/// - Meal Type: Segmented button (optional, auto-detected from time)
/// - Food Items: Multi-select via FoodLibraryPickerScreen
/// - Ad-hoc Items: Tag input with chips
/// - Notes: Text area
class FoodLogScreen extends ConsumerStatefulWidget {
  final String profileId;
  final FoodLog? foodLog;

  const FoodLogScreen({super.key, required this.profileId, this.foodLog});

  @override
  ConsumerState<FoodLogScreen> createState() => _FoodLogScreenState();
}

class _FoodLogScreenState extends ConsumerState<FoodLogScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _notesController;
  late final TextEditingController _adHocItemController;

  // State - Date & Time
  late DateTime _selectedDateTime;

  // State - Meal Type
  late MealType _selectedMealType;

  // State - Food Items (stub for future food library integration)
  late List<String> _foodItemIds;

  // State - Ad-hoc Items
  late List<String> _adHocItems;

  // State - Form dirty tracking
  bool _isDirty = false;
  bool _isSaving = false;

  // Validation error messages
  String? _dateTimeError;
  String? _adHocItemError;
  String? _notesError;

  bool get _isEditing => widget.foodLog != null;

  /// Auto-detect meal type from time of day.
  ///
  /// Per 38_UI_FIELD_SPECIFICATIONS.md Section 5.1:
  /// - 5:00 - 10:59 -> Breakfast
  /// - 11:00 - 14:59 -> Lunch
  /// - 15:00 - 20:59 -> Dinner
  /// - All other times -> Snack
  static MealType _detectMealType(DateTime dateTime) {
    final hour = dateTime.hour;
    if (hour >= ValidationRules.breakfastStartHour &&
        hour <= ValidationRules.breakfastEndHour) {
      return MealType.breakfast;
    }
    if (hour >= ValidationRules.lunchStartHour &&
        hour <= ValidationRules.lunchEndHour) {
      return MealType.lunch;
    }
    if (hour >= ValidationRules.dinnerStartHour &&
        hour <= ValidationRules.dinnerEndHour) {
      return MealType.dinner;
    }
    return MealType.snack;
  }

  @override
  void initState() {
    super.initState();
    final foodLog = widget.foodLog;

    _notesController = TextEditingController(text: foodLog?.notes ?? '');
    _adHocItemController = TextEditingController();

    _selectedDateTime = foodLog != null
        ? DateTime.fromMillisecondsSinceEpoch(foodLog.timestamp)
        : DateTime.now();

    _selectedMealType = foodLog?.mealType ?? _detectMealType(_selectedDateTime);

    _foodItemIds = foodLog != null
        ? List<String>.from(foodLog.foodItemIds)
        : [];

    _adHocItems = foodLog != null ? List<String>.from(foodLog.adHocItems) : [];

    _notesController.addListener(_markDirty);
  }

  @override
  void dispose() {
    _notesController.dispose();
    _adHocItemController.dispose();
    super.dispose();
  }

  void _markDirty() {
    if (!_isDirty) {
      setState(() {
        _isDirty = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foodItemsAsync = ref.watch(foodItemListProvider(widget.profileId));

    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldLeave = await _confirmDiscard();
        if (shouldLeave && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Edit Food Log' : 'Log Food'),
          actions: [
            if (_isSaving)
              const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
        body: Semantics(
          label: _isEditing ? 'Edit food log form' : 'Log food form',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionHeader(theme, 'Date & Time'),
                const SizedBox(height: 16),
                _buildDateTimePicker(theme),
                const SizedBox(height: 24),
                _buildSectionHeader(theme, 'Meal Type'),
                const SizedBox(height: 16),
                _buildMealTypeSegment(),
                const SizedBox(height: 24),
                _buildSectionHeader(theme, 'Food Items'),
                const SizedBox(height: 16),
                _buildFoodItemsSection(theme, foodItemsAsync),
                const SizedBox(height: 24),
                _buildSectionHeader(theme, 'Ad-hoc Items'),
                const SizedBox(height: 16),
                _buildAdHocItemsSection(theme),
                const SizedBox(height: 24),
                _buildSectionHeader(theme, 'Notes'),
                const SizedBox(height: 16),
                Semantics(
                  label: 'Food notes, optional',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _notesController,
                      label: 'Notes',
                      hintText: 'Any notes about this meal',
                      errorText: _notesError,
                      maxLength: ValidationRules.notesMaxLength,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onChanged: (_) => _validateNotes(),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ShadowButton.outlined(
                        onPressed: _isSaving ? null : _handleCancel,
                        label: 'Cancel',
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ShadowButton.elevated(
                        onPressed: _isSaving ? null : _handleSave,
                        label: _isEditing
                            ? 'Save food log changes'
                            : 'Save new food log',
                        child: Text(_isEditing ? 'Save Changes' : 'Save'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) => Semantics(
    header: true,
    child: Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildDateTimePicker(ThemeData theme) {
    final dateStr =
        '${_selectedDateTime.month}/${_selectedDateTime.day}/${_selectedDateTime.year}';
    final hour = _selectedDateTime.hour % 12 == 0
        ? 12
        : _selectedDateTime.hour % 12;
    final minute = _selectedDateTime.minute.toString().padLeft(2, '0');
    final period = _selectedDateTime.hour >= 12 ? 'PM' : 'AM';
    final timeStr = '$hour:$minute $period';

    return Semantics(
      label: 'When eaten, required',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_dateTimeError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _dateTimeError!,
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(dateStr),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(timeStr),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(ValidationRules.earliestSelectableYear),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
        _isDirty = true;
        _validateDateTime();
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
        _isDirty = true;
        _validateDateTime();
      });
    }
  }

  Widget _buildMealTypeSegment() => Semantics(
    label: 'Meal type, optional',
    child: ExcludeSemantics(
      child: SegmentedButton<MealType>(
        segments: const [
          ButtonSegment<MealType>(
            value: MealType.breakfast,
            label: Text('Breakfast'),
          ),
          ButtonSegment<MealType>(value: MealType.lunch, label: Text('Lunch')),
          ButtonSegment<MealType>(
            value: MealType.dinner,
            label: Text('Dinner'),
          ),
          ButtonSegment<MealType>(value: MealType.snack, label: Text('Snack')),
        ],
        selected: {_selectedMealType},
        onSelectionChanged: (newSelection) {
          setState(() {
            _selectedMealType = newSelection.first;
            _isDirty = true;
          });
        },
      ),
    ),
  );

  /// Food Items multi-select section backed by FoodLibraryPickerScreen.
  Widget _buildFoodItemsSection(
    ThemeData theme,
    AsyncValue<List<FoodItem>> foodItemsAsync,
  ) {
    final allFoodItems = foodItemsAsync.valueOrNull ?? [];
    final idToItem = {for (final f in allFoodItems) f.id: f};

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_foodItemIds.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _foodItemIds.map((id) {
                final name = idToItem[id]?.name ?? id;
                return Chip(
                  label: Text(name),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () => _removeFoodItem(id),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
          ],
          InkWell(
            onTap: _openFoodPicker,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.search, color: theme.colorScheme.outline),
                  const SizedBox(width: 8),
                  Text(
                    'Search foods...',
                    style: TextStyle(color: theme.colorScheme.outline),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openFoodPicker() async {
    final result = await Navigator.of(context).push<List<String>>(
      MaterialPageRoute<List<String>>(
        builder: (context) => FoodLibraryPickerScreen(
          profileId: widget.profileId,
          initialSelectedIds: _foodItemIds,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _foodItemIds = result;
        _isDirty = true;
      });
    }
  }

  void _removeFoodItem(String id) {
    setState(() {
      _foodItemIds = _foodItemIds.where((f) => f != id).toList();
      _isDirty = true;
    });
  }

  Widget _buildAdHocItemsSection(ThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Semantics(
              label: 'Food name, required',
              textField: true,
              child: ExcludeSemantics(
                child: ShadowTextField(
                  controller: _adHocItemController,
                  label: 'Ad-hoc Item',
                  hintText: 'Add item not in library...',
                  errorText: _adHocItemError,
                  maxLength: ValidationRules.nameMaxLength,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addAdHocItem(),
                  onChanged: (_) {
                    // Clear error when user types
                    if (_adHocItemError != null) {
                      setState(() => _adHocItemError = null);
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ShadowButton.icon(
            icon: Icons.add,
            label: 'Add ad-hoc food item',
            onPressed: _addAdHocItem,
          ),
        ],
      ),
      if (_adHocItems.isNotEmpty) ...[
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _adHocItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Chip(
              label: Text(item),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () => _removeAdHocItem(index),
            );
          }).toList(),
        ),
      ],
    ],
  );

  void _addAdHocItem() {
    final text = _adHocItemController.text.trim();
    if (text.isEmpty) return;

    if (text.length < ValidationRules.nameMinLength) {
      setState(
        () => _adHocItemError =
            'Item name must be at least ${ValidationRules.nameMinLength} characters',
      );
      return;
    }
    if (text.length > ValidationRules.nameMaxLength) {
      setState(
        () => _adHocItemError =
            'Item name must not exceed ${ValidationRules.nameMaxLength} characters',
      );
      return;
    }

    setState(() {
      _adHocItems.add(text);
      _adHocItemController.clear();
      _adHocItemError = null;
      _isDirty = true;
    });
  }

  void _removeAdHocItem(int index) {
    setState(() {
      _adHocItems.removeAt(index);
      _isDirty = true;
    });
  }

  // --- Validation ---

  bool _validateDateTime() {
    final now = DateTime.now();
    String? error;
    if (_selectedDateTime.isAfter(now)) {
      error = 'Date and time cannot be in the future';
    }
    setState(() => _dateTimeError = error);
    return error == null;
  }

  bool _validateNotes() {
    final notes = _notesController.text.trim();
    String? error;
    if (notes.length > ValidationRules.notesMaxLength) {
      error =
          'Notes must not exceed ${ValidationRules.notesMaxLength} characters';
    }
    setState(() => _notesError = error);
    return error == null;
  }

  bool _validateAll() {
    final dateTimeValid = _validateDateTime();
    final notesValid = _validateNotes();
    return dateTimeValid && notesValid;
  }

  // --- Actions ---

  Future<void> _handleCancel() async {
    if (_isDirty) {
      final shouldLeave = await _confirmDiscard();
      if (!shouldLeave || !mounted) return;
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _confirmDiscard() async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: 'Discard Changes?',
      contentText:
          'You have unsaved changes. Are you sure you want to discard them?',
      confirmButtonText: 'Discard',
      cancelButtonText: 'Keep Editing',
    );
    return confirmed ?? false;
  }

  Future<void> _handleSave() async {
    if (!_validateAll()) return;

    setState(() => _isSaving = true);

    try {
      final timestamp = _selectedDateTime.millisecondsSinceEpoch;

      if (_isEditing) {
        // Editing an existing log — skip compliance check
        await ref
            .read(foodLogListProvider(widget.profileId).notifier)
            .updateLog(
              UpdateFoodLogInput(
                id: widget.foodLog!.id,
                profileId: widget.profileId,
                mealType: _selectedMealType,
                foodItemIds: _foodItemIds,
                adHocItems: _adHocItems,
                notes: _notesController.text.trim(),
              ),
            );

        if (mounted) {
          showAccessibleSnackBar(
            context: context,
            message: 'Food log updated successfully',
          );
          Navigator.of(context).pop();
        }
      } else {
        // New log — run compliance check first
        await _saveWithComplianceCheck(timestamp);
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

  /// Checks diet compliance before saving a new food log entry.
  ///
  /// Per 59_DIET_TRACKING.md:
  /// 1. Get the active diet (if any)
  /// 2. If no diet — save directly
  /// 3. If diet exists — build a synthetic FoodItem from ad-hoc items and run check
  /// 4. If compliant — save directly
  /// 5. If violations — show DietViolationDialog
  ///    - "Log Anyway": save food log, record violations with wasOverridden=true
  ///    - "Cancel": record violations with wasOverridden=false, do not save
  Future<void> _saveWithComplianceCheck(int timestamp) async {
    // Step 1: Get active diet
    final getActiveDiet = ref.read(getActiveDietUseCaseProvider);
    final activeDietResult = await getActiveDiet(
      GetActiveDietInput(profileId: widget.profileId),
    );

    final activeDiet = activeDietResult.when(
      success: (diet) => diet,
      failure: (_) => null,
    );

    if (activeDiet == null || _adHocItems.isEmpty) {
      // No active diet or nothing to check — save directly
      await _saveFoodLog(timestamp, violatedRules: [], wasOverridden: false);
      return;
    }

    // Step 2: Build synthetic FoodItem from ad-hoc items for compliance check
    final adHocText = _adHocItems.join(', ');
    final syntheticFood = FoodItem(
      id: 'adhoc',
      clientId: 'adhoc',
      profileId: widget.profileId,
      name: adHocText,
      ingredientsText: adHocText,
      syncMetadata: SyncMetadata.empty(),
    );

    // Step 3: Run compliance check
    final checkCompliance = ref.read(checkComplianceUseCaseProvider);
    final checkResult = await checkCompliance(
      CheckComplianceInput(
        profileId: widget.profileId,
        dietId: activeDiet.id,
        foodItem: syntheticFood,
        logTimeEpoch: timestamp,
      ),
    );

    final complianceResult = checkResult.when(
      success: (result) => result,
      failure: (_) => null,
    );

    if (complianceResult == null || complianceResult.isCompliant) {
      // Compliant — save directly
      await _saveFoodLog(timestamp, violatedRules: [], wasOverridden: false);
      return;
    }

    // Step 4: Show violation dialog before saving
    if (!mounted) return;

    final choice = await showDietViolationDialog(
      context: context,
      foodName: adHocText,
      violatedRules: complianceResult.violatedRules,
      complianceImpact: complianceResult.complianceImpact,
    );

    if (!mounted) return;

    if (choice == DietViolationChoice.logAnyway) {
      // Save food log, then record violations with wasOverridden=true
      await _saveFoodLog(
        timestamp,
        violatedRules: complianceResult.violatedRules,
        wasOverridden: true,
        dietId: activeDiet.id,
        foodName: adHocText,
      );
    } else {
      // User cancelled — record violations with wasOverridden=false, don't save
      await _recordViolations(
        dietId: activeDiet.id,
        foodName: adHocText,
        violatedRules: complianceResult.violatedRules,
        wasOverridden: false,
        timestamp: timestamp,
        foodLogId: null,
      );

      if (mounted) {
        showAccessibleSnackBar(context: context, message: 'Food not logged');
        Navigator.of(context).pop();
      }
    }
  }

  /// Saves the food log entry and optionally records violations.
  Future<void> _saveFoodLog(
    int timestamp, {
    required List<DietRule> violatedRules,
    required bool wasOverridden,
    String? dietId,
    String? foodName,
  }) async {
    final foodLogId = const Uuid().v4();
    // Use the provider notifier so this is testable via foodLogListProvider mock.
    await ref
        .read(foodLogListProvider(widget.profileId).notifier)
        .log(
          LogFoodInput(
            profileId: widget.profileId,
            clientId: foodLogId,
            timestamp: timestamp,
            mealType: _selectedMealType,
            foodItemIds: _foodItemIds,
            adHocItems: _adHocItems,
            notes: _notesController.text.trim(),
          ),
        );

    // Record violations if any
    if (wasOverridden &&
        violatedRules.isNotEmpty &&
        dietId != null &&
        foodName != null) {
      await _recordViolations(
        dietId: dietId,
        foodName: foodName,
        violatedRules: violatedRules,
        wasOverridden: true,
        timestamp: timestamp,
        foodLogId: foodLogId,
      );
    }

    if (mounted) {
      showAccessibleSnackBar(
        context: context,
        message: 'Food log created successfully',
      );
      Navigator.of(context).pop();
    }
  }

  /// Records diet violations via RecordViolationUseCase.
  Future<void> _recordViolations({
    required String dietId,
    required String foodName,
    required List<DietRule> violatedRules,
    required bool wasOverridden,
    required int timestamp,
    required String? foodLogId,
  }) async {
    final recordViolation = ref.read(recordViolationUseCaseProvider);

    for (final rule in violatedRules) {
      await recordViolation(
        RecordViolationInput(
          profileId: widget.profileId,
          clientId: const Uuid().v4(),
          dietId: dietId,
          ruleId: rule.id,
          foodName: foodName,
          ruleDescription: _ruleDescription(rule),
          wasOverridden: wasOverridden,
          timestamp: timestamp,
          foodLogId: foodLogId,
        ),
      );
    }
  }

  /// Human-readable description for a violated diet rule.
  String _ruleDescription(DietRule rule) {
    switch (rule.ruleType) {
      case DietRuleType.excludeIngredient:
        return 'Contains ${rule.targetIngredient ?? "excluded ingredient"}';
      case DietRuleType.excludeCategory:
        return 'Contains ${rule.targetCategory ?? "excluded category"}';
      case DietRuleType.eatingWindowStart:
        return 'Outside eating window (too early)';
      case DietRuleType.eatingWindowEnd:
        return 'Outside eating window (too late)';
      case DietRuleType.noEatingBefore:
        return 'Eating before allowed time';
      case DietRuleType.noEatingAfter:
        return 'Eating after allowed time';
      case DietRuleType.fastingHours:
        return 'Currently in fasting period';
      default:
        return 'Violates ${rule.ruleType.name} rule';
    }
  }
}
