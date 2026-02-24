// lib/presentation/screens/diet/diet_edit_screen.dart
// Custom diet creation/editing screen — Phase 15b-3
// Per 38_UI_FIELD_SPECIFICATIONS.md Section 17.2 + 59_DIET_TRACKING.md

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/diet.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/diet/diets_usecases.dart';
import 'package:shadow_app/presentation/providers/diet/diet_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Screen for creating or editing a custom diet.
///
/// Per 38_UI_FIELD_SPECIFICATIONS.md Section 17.2:
/// - Name: required, min 2, max 50 characters
/// - Description: optional
/// - Eating window toggle with start/end time pickers
/// - Food exclusion checkboxes
/// - Macro limit switches
class DietEditScreen extends ConsumerStatefulWidget {
  final String profileId;
  final Diet? existingDiet;

  const DietEditScreen({super.key, required this.profileId, this.existingDiet});

  @override
  ConsumerState<DietEditScreen> createState() => _DietEditScreenState();
}

class _DietEditScreenState extends ConsumerState<DietEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  bool _isDirty = false;
  bool _isSaving = false;
  String? _nameError;

  // Eating window
  bool _hasEatingWindow = false;
  TimeOfDay _windowStart = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay _windowEnd = const TimeOfDay(hour: 20, minute: 0);

  // Food exclusions (per 38_UI_FIELD_SPECIFICATIONS.md Section 17.2)
  final Map<String, bool> _exclusions = {
    'meat': false,
    'poultry': false,
    'fish': false,
    'eggs': false,
    'dairy': false,
    'grains': false,
    'legumes': false,
    'nuts': false,
    'sugar': false,
    'gluten': false,
    'processed': false,
    'alcohol': false,
  };

  // Macro limits
  bool _hasCalorieLimit = false;
  bool _hasCarbLimit = false;
  bool _hasFatLimit = false;
  bool _hasProteinLimit = false;
  final TextEditingController _calorieLimitController = TextEditingController();
  final TextEditingController _carbLimitController = TextEditingController();
  final TextEditingController _fatLimitController = TextEditingController();
  final TextEditingController _proteinLimitController = TextEditingController();

  bool get _isEditing => widget.existingDiet != null;

  @override
  void initState() {
    super.initState();
    final diet = widget.existingDiet;
    _nameController = TextEditingController(text: diet?.name ?? '');
    _descriptionController = TextEditingController(
      text: diet?.description ?? '',
    );
    _nameController.addListener(_markDirty);
    _descriptionController.addListener(_markDirty);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _calorieLimitController.dispose();
    _carbLimitController.dispose();
    _fatLimitController.dispose();
    _proteinLimitController.dispose();
    super.dispose();
  }

  void _markDirty() {
    if (!_isDirty) setState(() => _isDirty = true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldLeave = await _confirmDiscard();
        if (shouldLeave && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Edit Diet' : 'Custom Diet'),
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
          label: _isEditing ? 'Edit diet form' : 'Create custom diet form',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _sectionHeader(theme, 'Diet Name'),
                const SizedBox(height: 16),
                Semantics(
                  label: 'Diet name, required',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _nameController,
                      label: 'Name',
                      hintText: 'e.g. My Keto Plan',
                      errorText: _nameError,
                      maxLength: ValidationRules.nameMaxLength,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => _validateName(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Semantics(
                  label: 'Diet description, optional',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      hintText: 'Optional notes about this diet',
                      maxLength: ValidationRules.notesMaxLength,
                      maxLines: 2,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Eating window
                _sectionHeader(theme, 'Eating Window'),
                const SizedBox(height: 8),
                Semantics(
                  label: 'Enable eating window',
                  toggled: _hasEatingWindow,
                  child: SwitchListTile(
                    title: const Text('Restrict eating hours'),
                    subtitle: _hasEatingWindow
                        ? Text(
                            '${_windowStart.format(context)} – ${_windowEnd.format(context)}',
                          )
                        : const Text('No time restriction'),
                    value: _hasEatingWindow,
                    onChanged: (value) =>
                        setState(() => _hasEatingWindow = value),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                if (_hasEatingWindow) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickTime(isStart: true),
                          icon: const Icon(Icons.access_time),
                          label: Text('Start: ${_windowStart.format(context)}'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickTime(isStart: false),
                          icon: const Icon(Icons.access_time),
                          label: Text('End: ${_windowEnd.format(context)}'),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),

                // Food exclusions
                _sectionHeader(theme, 'Food Exclusions'),
                const SizedBox(height: 8),
                Text(
                  'Select foods to exclude from your diet:',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                ..._exclusions.entries.map(
                  (entry) => Semantics(
                    label: 'Exclude ${entry.key}',
                    toggled: entry.value,
                    child: CheckboxListTile(
                      title: Text(_exclusionLabel(entry.key)),
                      value: entry.value,
                      onChanged: (value) => setState(() {
                        _exclusions[entry.key] = value ?? false;
                        _isDirty = true;
                      }),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Macro limits
                _sectionHeader(theme, 'Macro Limits'),
                const SizedBox(height: 8),
                _buildMacroSwitch(
                  theme,
                  label: 'Daily calorie limit',
                  enabled: _hasCalorieLimit,
                  controller: _calorieLimitController,
                  unit: 'kcal',
                  onToggle: (v) => setState(() => _hasCalorieLimit = v),
                ),
                _buildMacroSwitch(
                  theme,
                  label: 'Daily carb limit',
                  enabled: _hasCarbLimit,
                  controller: _carbLimitController,
                  unit: 'g',
                  onToggle: (v) => setState(() => _hasCarbLimit = v),
                ),
                _buildMacroSwitch(
                  theme,
                  label: 'Daily fat limit',
                  enabled: _hasFatLimit,
                  controller: _fatLimitController,
                  unit: 'g',
                  onToggle: (v) => setState(() => _hasFatLimit = v),
                ),
                _buildMacroSwitch(
                  theme,
                  label: 'Daily protein limit',
                  enabled: _hasProteinLimit,
                  controller: _proteinLimitController,
                  unit: 'g',
                  onToggle: (v) => setState(() => _hasProteinLimit = v),
                ),
                const SizedBox(height: 32),

                // Action buttons
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
                            ? 'Save diet changes'
                            : 'Save new custom diet',
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

  Widget _sectionHeader(ThemeData theme, String title) => Semantics(
    header: true,
    child: Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildMacroSwitch(
    ThemeData theme, {
    required String label,
    required bool enabled,
    required TextEditingController controller,
    required String unit,
    required ValueChanged<bool> onToggle,
  }) => Column(
    children: [
      Semantics(
        label: label,
        toggled: enabled,
        child: SwitchListTile(
          title: Text(label),
          value: enabled,
          onChanged: (v) {
            onToggle(v);
            _isDirty = true;
          },
          contentPadding: EdgeInsets.zero,
        ),
      ),
      if (enabled)
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 16),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                child: ShadowTextField(
                  controller: controller,
                  label: unit,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => _isDirty = true,
                ),
              ),
              const SizedBox(width: 8),
              Text(unit, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
    ],
  );

  Future<void> _pickTime({required bool isStart}) async {
    final initial = isStart ? _windowStart : _windowEnd;
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      setState(() {
        if (isStart) {
          _windowStart = picked;
        } else {
          _windowEnd = picked;
        }
        _isDirty = true;
      });
    }
  }

  bool _validateName() {
    final name = _nameController.text.trim();
    String? error;
    if (name.length < ValidationRules.nameMinLength) {
      error =
          'Name must be at least ${ValidationRules.nameMinLength} characters';
    } else if (name.length > ValidationRules.nameMaxLength) {
      error =
          'Name must not exceed ${ValidationRules.nameMaxLength} characters';
    }
    setState(() => _nameError = error);
    return error == null;
  }

  Future<void> _handleCancel() async {
    if (_isDirty) {
      final shouldLeave = await _confirmDiscard();
      if (!shouldLeave || !mounted) return;
    }
    if (mounted) Navigator.of(context).pop();
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
    if (!_validateName()) return;

    setState(() => _isSaving = true);

    try {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();

      await ref
          .read(dietListProvider(widget.profileId).notifier)
          .create(
            CreateDietInput(
              profileId: widget.profileId,
              clientId: const Uuid().v4(),
              name: name,
              description: description,
              presetType: DietPresetType.custom,
              startDateEpoch: DateTime.now().millisecondsSinceEpoch,
            ),
          );

      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: _isEditing ? 'Diet updated' : 'Custom diet created',
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
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String _exclusionLabel(String key) {
    switch (key) {
      case 'meat':
        return 'Meat (beef, pork, lamb)';
      case 'poultry':
        return 'Poultry (chicken, turkey)';
      case 'fish':
        return 'Fish & seafood';
      case 'eggs':
        return 'Eggs';
      case 'dairy':
        return 'Dairy (milk, cheese, yogurt)';
      case 'grains':
        return 'Grains (wheat, rice, oats)';
      case 'legumes':
        return 'Legumes (beans, lentils, peanuts)';
      case 'nuts':
        return 'Tree nuts';
      case 'sugar':
        return 'Added sugar';
      case 'gluten':
        return 'Gluten';
      case 'processed':
        return 'Processed / packaged foods';
      case 'alcohol':
        return 'Alcohol';
      default:
        return key;
    }
  }
}
