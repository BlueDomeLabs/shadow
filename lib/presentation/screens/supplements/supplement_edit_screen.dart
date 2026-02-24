// lib/presentation/screens/supplements/supplement_edit_screen.dart
// Implements 38_UI_FIELD_SPECIFICATIONS.md Section 4.1 + 60_SUPPLEMENT_EXTENSION.md
// Updated in Phase 15a: Source & Price section, Label Photos section, import shortcuts

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/supplements/supplements_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/supplements/supplement_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Screen for creating or editing a supplement.
///
/// Follows 38_UI_FIELD_SPECIFICATIONS.md Section 4.1 exactly.
/// Uses [SupplementListProvider] for state management via create/update.
///
/// Fields:
/// - Basic Information: name, brand, form, customForm
/// - Dosage: dosageAmount, dosageUnit, quantityPerDose
/// - Notes: notes
class SupplementEditScreen extends ConsumerStatefulWidget {
  final String profileId;
  final Supplement? supplement;

  const SupplementEditScreen({
    super.key,
    required this.profileId,
    this.supplement,
  });

  @override
  ConsumerState<SupplementEditScreen> createState() =>
      _SupplementEditScreenState();
}

class _SupplementEditScreenState extends ConsumerState<SupplementEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers - Basic Information
  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _customFormController;

  // Controllers - Dosage
  late final TextEditingController _dosageAmountController;
  late final TextEditingController _quantityPerDoseController;

  // Controllers - Dosage (continued)
  late final TextEditingController _customDosageUnitController;

  // Controllers - Ingredients
  late final TextEditingController _ingredientController;

  // Controllers - Schedule
  late final TextEditingController _everyXDaysController;

  // Controllers - Notes
  late final TextEditingController _notesController;

  // Controllers - Source & Price (Phase 15a)
  late final TextEditingController _sourceController;
  late final TextEditingController _pricePaidController;

  // State - Label photos (Phase 15a)
  final List<String> _labelPhotoPaths = [];

  // State - Dropdown values
  late SupplementForm _selectedForm;
  late DosageUnit _selectedDosageUnit;

  // State - Ingredients
  late List<String> _ingredients;

  // State - Schedule
  late SupplementFrequencyType _selectedFrequency;
  late List<int> _selectedWeekdays;
  late SupplementAnchorEvent _selectedAnchorEvent;
  late SupplementTimingType _selectedTimingType;
  late int _offsetMinutes;
  int? _specificTimeMinutes;
  DateTime? _startDate;
  DateTime? _endDate;

  // State - Form dirty tracking
  bool _isDirty = false;
  bool _isSaving = false;

  // Validation error messages
  String? _nameError;
  String? _brandError;
  String? _customFormError;
  String? _dosageAmountError;
  String? _customDosageUnitError;
  String? _quantityPerDoseError;
  String? _everyXDaysError;
  String? _specificDaysError;
  String? _offsetMinutesError;
  String? _specificTimeError;
  String? _endDateError;
  String? _notesError;

  bool get _isEditing => widget.supplement != null;

  @override
  void initState() {
    super.initState();
    final supplement = widget.supplement;
    final primarySchedule =
        (supplement != null && supplement.schedules.isNotEmpty)
        ? supplement.schedules.first
        : null;

    _nameController = TextEditingController(text: supplement?.name ?? '');
    _brandController = TextEditingController(text: supplement?.brand ?? '');
    _customFormController = TextEditingController(
      text: supplement?.customForm ?? '',
    );
    _dosageAmountController = TextEditingController(
      text: supplement != null ? supplement.dosageQuantity.toString() : '',
    );
    _customDosageUnitController = TextEditingController(
      text: supplement?.customDosageUnit ?? '',
    );
    _quantityPerDoseController = TextEditingController(text: '1');
    _ingredientController = TextEditingController();
    _everyXDaysController = TextEditingController(
      text: primarySchedule != null
          ? primarySchedule.everyXDays.toString()
          : '2',
    );
    _notesController = TextEditingController(text: supplement?.notes ?? '');
    _sourceController = TextEditingController(text: supplement?.source ?? '');
    _pricePaidController = TextEditingController(
      text: supplement?.pricePaid != null
          ? supplement!.pricePaid!.toStringAsFixed(2)
          : '',
    );

    _selectedForm = supplement?.form ?? SupplementForm.capsule;
    _selectedDosageUnit = supplement?.dosageUnit ?? DosageUnit.mg;

    // Ingredients state
    _ingredients = supplement?.ingredients.map((i) => i.name).toList() ?? [];

    // Schedule state from primary schedule
    _selectedFrequency =
        primarySchedule?.frequencyType ?? SupplementFrequencyType.daily;
    _selectedWeekdays =
        primarySchedule?.weekdays.toList() ?? [0, 1, 2, 3, 4, 5, 6];
    _selectedAnchorEvent =
        primarySchedule?.anchorEvent ?? SupplementAnchorEvent.breakfast;
    _selectedTimingType =
        primarySchedule?.timingType ?? SupplementTimingType.withEvent;
    _offsetMinutes = primarySchedule?.offsetMinutes ?? 30;
    _specificTimeMinutes = primarySchedule?.specificTimeMinutes;
    _startDate = supplement?.startDate != null
        ? DateTime.fromMillisecondsSinceEpoch(supplement!.startDate!)
        : null;
    _endDate = supplement?.endDate != null
        ? DateTime.fromMillisecondsSinceEpoch(supplement!.endDate!)
        : null;

    _nameController.addListener(_markDirty);
    _brandController.addListener(_markDirty);
    _customFormController.addListener(_markDirty);
    _dosageAmountController.addListener(_markDirty);
    _customDosageUnitController.addListener(_markDirty);
    _quantityPerDoseController.addListener(_markDirty);
    _ingredientController.addListener(_markDirty);
    _everyXDaysController.addListener(_markDirty);
    _notesController.addListener(_markDirty);
    _sourceController.addListener(_markDirty);
    _pricePaidController.addListener(_markDirty);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _customFormController.dispose();
    _dosageAmountController.dispose();
    _customDosageUnitController.dispose();
    _quantityPerDoseController.dispose();
    _ingredientController.dispose();
    _everyXDaysController.dispose();
    _notesController.dispose();
    _sourceController.dispose();
    _pricePaidController.dispose();
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
          title: Text(_isEditing ? 'Edit Supplement' : 'Add Supplement'),
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
          label: _isEditing ? 'Edit supplement form' : 'Add supplement form',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionHeader(theme, 'Basic Information'),
                const SizedBox(height: 8),
                // Import shortcut buttons (Phase 15a)
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: _scanBarcode,
                      icon: const Icon(Icons.qr_code_scanner, size: 18),
                      label: const Text('Scan Barcode'),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: _scanLabel,
                      icon: const Icon(Icons.camera_alt, size: 18),
                      label: const Text('Scan Label'),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Semantics(
                  label: 'Supplement name, required',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _nameController,
                      label: 'Supplement Name',
                      hintText: 'e.g., Vitamin D3',
                      errorText: _nameError,
                      maxLength: ValidationRules.supplementNameMaxLength,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => _validateName(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Semantics(
                  label: 'Brand name, optional',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _brandController,
                      label: 'Brand',
                      hintText: 'e.g., NOW Foods',
                      errorText: _brandError,
                      maxLength: ValidationRules.nameMaxLength,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => _validateBrand(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Semantics(
                  label:
                      'Supplement form, required, capsule tablet powder or other',
                  child: ExcludeSemantics(
                    child: DropdownButtonFormField<SupplementForm>(
                      initialValue: _selectedForm,
                      decoration: const InputDecoration(labelText: 'Form'),
                      items: SupplementForm.values
                          .map(
                            (form) => DropdownMenuItem<SupplementForm>(
                              value: form,
                              child: Text(_supplementFormLabel(form)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedForm = value;
                            _isDirty = true;
                            if (value != SupplementForm.other) {
                              _customFormError = null;
                              _customFormController.clear();
                            }
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_selectedForm == SupplementForm.other) ...[
                  ShadowTextField(
                    controller: _customFormController,
                    label: 'Custom Form',
                    semanticLabel: 'Custom supplement form, required',
                    hintText: 'e.g., Lozenge',
                    errorText: _customFormError,
                    maxLength: ValidationRules.nameMaxLength,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => _validateCustomForm(),
                  ),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 8),
                _buildSectionHeader(theme, 'Dosage'),
                const SizedBox(height: 16),
                Semantics(
                  label: 'Dosage amount, required, enter number',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField.numeric(
                      controller: _dosageAmountController,
                      label: 'Dosage Amount',
                      hintText: 'e.g., 2000',
                      errorText: _dosageAmountError,
                      maxLength: 15,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => _validateDosageAmount(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Semantics(
                  label: 'Dosage unit, required, select unit',
                  child: ExcludeSemantics(
                    child: DropdownButtonFormField<DosageUnit>(
                      initialValue: _selectedDosageUnit,
                      decoration: const InputDecoration(
                        labelText: 'Dosage Unit',
                      ),
                      items: DosageUnit.values
                          .map(
                            (unit) => DropdownMenuItem<DosageUnit>(
                              value: unit,
                              child: Text(_dosageUnitLabel(unit)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedDosageUnit = value;
                            _isDirty = true;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_selectedDosageUnit == DosageUnit.custom) ...[
                  ShadowTextField(
                    controller: _customDosageUnitController,
                    label: 'Custom Unit',
                    semanticLabel: 'Custom dosage unit, required',
                    hintText: 'e.g., billion CFU',
                    errorText: _customDosageUnitError,
                    maxLength: 50,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => _validateCustomDosageUnit(),
                  ),
                  const SizedBox(height: 16),
                ],
                Semantics(
                  label: 'Quantity per dose, required, default is 1',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField.numeric(
                      controller: _quantityPerDoseController,
                      label: 'Quantity Per Dose',
                      hintText: '1',
                      errorText: _quantityPerDoseError,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) => _validateQuantityPerDose(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                _buildSectionHeader(theme, 'Ingredients'),
                const SizedBox(height: 16),
                _buildIngredientsSection(theme),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                _buildSectionHeader(theme, 'Schedule'),
                const SizedBox(height: 16),
                _buildScheduleSection(theme),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                _buildSectionHeader(theme, 'Notes'),
                const SizedBox(height: 16),
                Semantics(
                  label: 'Supplement notes, optional',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _notesController,
                      label: 'Notes',
                      hintText: 'Any notes about this supplement',
                      errorText: _notesError,
                      maxLength: ValidationRules.notesMaxLength,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onChanged: (_) => _validateNotes(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                _buildSectionHeader(theme, 'Source & Price'),
                const SizedBox(height: 16),
                _buildSourceAndPriceSection(theme),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                _buildSectionHeader(theme, 'Label Photos'),
                const SizedBox(height: 16),
                _buildLabelPhotosSection(theme),
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
                            ? 'Save supplement changes'
                            : 'Save new supplement',
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

  Widget _buildIngredientsSection(ThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Semantics(
        label: 'Ingredient list, optional, type and press enter to add',
        child: ExcludeSemantics(
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ingredientController,
                  decoration: const InputDecoration(
                    labelText: 'Add ingredient...',
                    hintText: 'Add ingredient...',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 100,
                  textInputAction: TextInputAction.done,
                  onSubmitted: _addIngredient,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _addIngredient(_ingredientController.text),
                icon: const Icon(Icons.add),
                tooltip: 'Add ingredient',
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              ),
            ],
          ),
        ),
      ),
      if (_ingredients.isNotEmpty) ...[
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _ingredients
              .map(
                (name) => Semantics(
                  label: '$name ingredient, tap to remove',
                  child: InputChip(
                    label: Text(name),
                    onDeleted: () {
                      setState(() {
                        _ingredients.remove(name);
                        _isDirty = true;
                      });
                    },
                    deleteButtonTooltipMessage: 'Remove $name',
                  ),
                ),
              )
              .toList(),
        ),
      ],
    ],
  );

  void _addIngredient(String value) {
    final name = value.trim();
    if (name.isEmpty) return;
    if (name.length < 2) return;
    if (_ingredients.length >= ValidationRules.maxIngredientsPerSupplement) {
      showAccessibleSnackBar(
        context: context,
        message:
            'Maximum ${ValidationRules.maxIngredientsPerSupplement} ingredients allowed',
      );
      return;
    }
    if (_ingredients.contains(name)) {
      showAccessibleSnackBar(
        context: context,
        message: 'Ingredient already added',
      );
      return;
    }
    setState(() {
      _ingredients.add(name);
      _ingredientController.clear();
      _isDirty = true;
    });
  }

  Widget _buildScheduleSection(ThemeData theme) {
    final isSpecificTime =
        _selectedTimingType == SupplementTimingType.specificTime;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Frequency
        Semantics(
          label: 'How often to take, required',
          child: ExcludeSemantics(
            child: DropdownButtonFormField<SupplementFrequencyType>(
              initialValue: _selectedFrequency,
              decoration: const InputDecoration(labelText: 'Frequency'),
              items: SupplementFrequencyType.values
                  .map(
                    (freq) => DropdownMenuItem<SupplementFrequencyType>(
                      value: freq,
                      child: Text(_frequencyLabel(freq)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedFrequency = value;
                    _isDirty = true;
                    _everyXDaysError = null;
                    _specificDaysError = null;
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Every X Days (conditional)
        if (_selectedFrequency == SupplementFrequencyType.everyXDays) ...[
          Semantics(
            label: 'Every how many days, required, 2 to 365',
            textField: true,
            child: ExcludeSemantics(
              child: ShadowTextField.numeric(
                controller: _everyXDaysController,
                label: 'Every X Days',
                hintText: '2',
                errorText: _everyXDaysError,
                maxLength: 3,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => _validateEveryXDays(),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Specific Days (conditional)
        if (_selectedFrequency == SupplementFrequencyType.specificWeekdays) ...[
          ShadowPicker.weekday(
            label: 'Which days to take',
            selectedDays: _selectedWeekdays,
            onDaysChanged: (days) {
              setState(() {
                _selectedWeekdays = days;
                _isDirty = true;
                _specificDaysError = null;
              });
            },
          ),
          if (_specificDaysError != null) ...[
            const SizedBox(height: 4),
            Text(
              _specificDaysError!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],

        // Anchor Event
        Semantics(
          label: 'When to take supplement, required',
          child: ExcludeSemantics(
            child: DropdownButtonFormField<String>(
              initialValue: isSpecificTime
                  ? 'specificTime'
                  : _selectedAnchorEvent.name,
              decoration: const InputDecoration(labelText: 'Anchor Event'),
              items: [
                ...SupplementAnchorEvent.values.map(
                  (event) => DropdownMenuItem<String>(
                    value: event.name,
                    child: Text(_anchorEventLabel(event)),
                  ),
                ),
                const DropdownMenuItem<String>(
                  value: 'specificTime',
                  child: Text('Specific Time'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _isDirty = true;
                  if (value == 'specificTime') {
                    _selectedTimingType = SupplementTimingType.specificTime;
                  } else {
                    final event = SupplementAnchorEvent.values.firstWhere(
                      (e) => e.name == value,
                    );
                    _selectedAnchorEvent = event;
                    if (_selectedTimingType ==
                        SupplementTimingType.specificTime) {
                      _selectedTimingType = SupplementTimingType.withEvent;
                    }
                  }
                  _specificTimeError = null;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Timing (With/Before/After) - hidden when Specific Time
        if (!isSpecificTime) ...[
          Semantics(
            label: 'Timing relative to anchor event, required',
            child: ExcludeSemantics(
              child: DropdownButtonFormField<SupplementTimingType>(
                initialValue: _selectedTimingType,
                decoration: const InputDecoration(labelText: 'Timing'),
                items:
                    [
                          SupplementTimingType.withEvent,
                          SupplementTimingType.beforeEvent,
                          SupplementTimingType.afterEvent,
                        ]
                        .map(
                          (type) => DropdownMenuItem<SupplementTimingType>(
                            value: type,
                            child: Text(_timingTypeLabel(type)),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedTimingType = value;
                      _isDirty = true;
                      _offsetMinutesError = null;
                      // Clear offset when switching to "With"
                      if (value == SupplementTimingType.withEvent) {
                        _offsetMinutes = 0;
                      } else if (_offsetMinutes == 0) {
                        _offsetMinutes = 30;
                      }
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Offset Minutes (conditional: Before or After)
        if (_selectedTimingType == SupplementTimingType.beforeEvent ||
            _selectedTimingType == SupplementTimingType.afterEvent) ...[
          Semantics(
            label: 'Minutes before or after, required, 5 to 120',
            child: ExcludeSemantics(
              child: DropdownButtonFormField<int>(
                initialValue: _offsetMinutes,
                decoration: const InputDecoration(labelText: 'Offset Minutes'),
                items: List.generate(24, (i) => (i + 1) * 5)
                    .map(
                      (minutes) => DropdownMenuItem<int>(
                        value: minutes,
                        child: Text('$minutes min'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _offsetMinutes = value;
                      _isDirty = true;
                      _offsetMinutesError = null;
                    });
                  }
                },
              ),
            ),
          ),
          if (_offsetMinutesError != null) ...[
            const SizedBox(height: 4),
            Text(
              _offsetMinutesError!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],

        // Specific Time picker (conditional: specificTime timing)
        if (isSpecificTime) ...[
          Semantics(
            label:
                'Specific time to take supplement, required, ${_specificTimeMinutes != null ? _formatMinutesAsTime(_specificTimeMinutes!) : "not set"}',
            child: ExcludeSemantics(
              child: InkWell(
                onTap: _pickSpecificTime,
                borderRadius: BorderRadius.circular(8),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Specific Time',
                    errorText: _specificTimeError,
                    suffixIcon: const Icon(Icons.access_time),
                    border: const OutlineInputBorder(),
                  ),
                  child: Text(
                    _specificTimeMinutes != null
                        ? _formatMinutesAsTime(_specificTimeMinutes!)
                        : 'Select time',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: _specificTimeMinutes != null
                          ? null
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Start Date
        ShadowPicker.date(
          label: 'Start Date',
          hint: 'When to start taking this supplement',
          dateValue: _startDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          onDateChanged: (date) {
            setState(() {
              _startDate = date;
              _isDirty = true;
              _endDateError = null;
            });
          },
        ),
        const SizedBox(height: 16),

        // End Date
        ShadowPicker.date(
          label: 'End Date',
          hint: 'When to stop taking this supplement (optional)',
          dateValue: _endDate,
          firstDate: _startDate ?? DateTime(2020),
          lastDate: DateTime(2100),
          onDateChanged: (date) {
            setState(() {
              _endDate = date;
              _isDirty = true;
              _endDateError = null;
            });
          },
        ),
        if (_endDateError != null) ...[
          const SizedBox(height: 4),
          Text(
            _endDateError!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  // ---- Phase 15a: Source & Price section ----

  Widget _buildSourceAndPriceSection(ThemeData theme) {
    final pricePaid = double.tryParse(_pricePaidController.text.trim());
    // Price per serving: requires pricePaid, quantityOnHand, quantityPerDose
    // quantityOnHand is not in the supplement entity in this phase — calculate
    // when the supplement has enough data. For now show when pricePaid is entered.
    final qPerDose = int.tryParse(_quantityPerDoseController.text.trim());
    final showPricePerServing =
        pricePaid != null && qPerDose != null && qPerDose > 0;
    // Use dosage quantity as a proxy for quantity on hand (1 unit = 1 bottle serving)
    // Real price-per-serving calc needs quantity_on_hand which is not implemented yet
    // Show placeholder calculation using pricePaid / quantity_per_dose for now
    final pricePerServing = showPricePerServing ? pricePaid / qPerDose : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: 'Source, optional, where this supplement was obtained',
          textField: true,
          child: ExcludeSemantics(
            child: ShadowTextField(
              controller: _sourceController,
              label: 'Source',
              hintText: 'e.g., amazon.com, Whole Foods, Dr. Smith',
              maxLength: ValidationRules.nameMaxLength,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Semantics(
          label: 'Price paid, optional, total price for the package',
          textField: true,
          child: ExcludeSemantics(
            child: ShadowTextField.numeric(
              controller: _pricePaidController,
              label: 'Price Paid',
              hintText: '0.00',
              maxLength: 10,
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),
        if (pricePerServing != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Price Per Serving:', style: theme.textTheme.bodyMedium),
              const SizedBox(width: 8),
              Text(
                '\$${pricePerServing.toStringAsFixed(2)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // ---- Phase 15a: Label Photos section ----

  Widget _buildLabelPhotosSection(ThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (_labelPhotoPaths.isNotEmpty) ...[
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _labelPhotoPaths
              .asMap()
              .entries
              .map(
                (entry) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        entry.value,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        tooltip: 'Remove photo',
                        onPressed: () {
                          setState(() {
                            _labelPhotoPaths.removeAt(entry.key);
                            _isDirty = true;
                          });
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.surface.withAlpha(
                            180,
                          ),
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(24, 24),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
      ],
      if (_labelPhotoPaths.length < 3) ...[
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.camera_alt, size: 18),
              label: const Text('Take Photo'),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: _pickPhoto,
              icon: const Icon(Icons.photo_library, size: 18),
              label: const Text('Choose from Library'),
            ),
          ],
        ),
      ] else ...[
        Text(
          'Maximum 3 label photos per supplement',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ],
  );

  Future<void> _takePhoto() async {
    final picker = image_picker.ImagePicker();
    try {
      final photo = await picker.pickImage(
        source: image_picker.ImageSource.camera,
      );
      if (photo != null && mounted) {
        setState(() {
          _labelPhotoPaths.add(photo.path);
          _isDirty = true;
        });
      }
    } on Exception {
      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: 'Camera not available on this device',
        );
      }
    }
  }

  Future<void> _pickPhoto() async {
    final picker = image_picker.ImagePicker();
    try {
      final photo = await picker.pickImage(
        source: image_picker.ImageSource.gallery,
      );
      if (photo != null && mounted) {
        setState(() {
          _labelPhotoPaths.add(photo.path);
          _isDirty = true;
        });
      }
    } on Exception {
      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: 'Photo library not available',
        );
      }
    }
  }

  // ---- Phase 15a: Barcode scan and label scan ----

  Future<void> _scanBarcode() async {
    final scanned = await _openBarcodeScanner();
    if (scanned == null || !mounted) return;

    setState(() => _isSaving = true);
    try {
      final useCase = ref.read(lookupSupplementBarcodeUseCaseProvider);
      final result = await useCase(
        LookupSupplementBarcodeInput(barcode: scanned),
      );

      if (!mounted) return;

      result.when(
        success: (data) {
          if (data == null) {
            showAccessibleSnackBar(
              context: context,
              message: 'Product not found in NIH DSLD — enter details manually',
            );
            return;
          }
          setState(() {
            if (data.productName != null) {
              _nameController.text = data.productName!;
            }
            if (data.brand != null) _brandController.text = data.brand!;
            if (data.servingSize != null) {
              // Store in notes as a hint since supplement doesn't have servingSize field
              if (_notesController.text.isEmpty) {
                _notesController.text = 'Serving size: ${data.servingSize}';
              }
            }
            _isDirty = true;
          });
          showAccessibleSnackBar(
            context: context,
            message: 'Product found — review and save',
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
      final useCase = ref.read(scanSupplementLabelUseCaseProvider);
      final result = await useCase(ScanSupplementLabelInput(imageBytes: bytes));

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
            if (data.brand != null) _brandController.text = data.brand!;
            _isDirty = true;
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

  Future<void> _pickSpecificTime() async {
    final initialTime = _specificTimeMinutes != null
        ? TimeOfDay(
            hour: _specificTimeMinutes! ~/ 60,
            minute: _specificTimeMinutes! % 60,
          )
        : const TimeOfDay(hour: 8, minute: 0);

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        _specificTimeMinutes = picked.hour * 60 + picked.minute;
        _isDirty = true;
        _specificTimeError = null;
      });
    }
  }

  String _formatMinutesAsTime(int minutes) {
    final hour = minutes ~/ 60;
    final minute = minutes % 60;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0
        ? 12
        : hour > 12
        ? hour - 12
        : hour;
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  Widget _buildSectionHeader(ThemeData theme, String title) => Semantics(
    header: true,
    child: Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    ),
  );

  String _supplementFormLabel(SupplementForm form) => switch (form) {
    SupplementForm.capsule => 'Capsule',
    SupplementForm.tablet => 'Tablet',
    SupplementForm.powder => 'Powder',
    SupplementForm.liquid => 'Liquid',
    SupplementForm.gummy => 'Gummy',
    SupplementForm.spray => 'Spray',
    SupplementForm.other => 'Other',
  };

  String _dosageUnitLabel(DosageUnit unit) => switch (unit) {
    DosageUnit.mg => 'mg',
    DosageUnit.mcg => 'mcg',
    DosageUnit.g => 'g',
    DosageUnit.iu => 'IU',
    DosageUnit.hdu => 'HDU',
    DosageUnit.ml => 'mL',
    DosageUnit.drops => 'drops',
    DosageUnit.tsp => 'tsp',
    DosageUnit.custom => 'custom',
  };

  String _frequencyLabel(SupplementFrequencyType freq) => switch (freq) {
    SupplementFrequencyType.daily => 'Daily',
    SupplementFrequencyType.everyXDays => 'Every X Days',
    SupplementFrequencyType.specificWeekdays => 'Specific Days',
  };

  String _anchorEventLabel(SupplementAnchorEvent event) => switch (event) {
    SupplementAnchorEvent.wake => 'Morning',
    SupplementAnchorEvent.breakfast => 'Breakfast',
    SupplementAnchorEvent.lunch => 'Lunch',
    SupplementAnchorEvent.dinner => 'Dinner',
    SupplementAnchorEvent.bed => 'Bedtime',
  };

  String _timingTypeLabel(SupplementTimingType type) => switch (type) {
    SupplementTimingType.withEvent => 'With',
    SupplementTimingType.beforeEvent => 'Before',
    SupplementTimingType.afterEvent => 'After',
    SupplementTimingType.specificTime => 'At Specific Time',
  };

  bool _validateName() {
    final name = _nameController.text.trim();
    String? error;
    if (name.isEmpty) {
      error = 'Supplement name is required';
    } else if (name.length < ValidationRules.nameMinLength) {
      error =
          'Name must be at least ${ValidationRules.nameMinLength} characters';
    } else if (name.length > ValidationRules.supplementNameMaxLength) {
      error =
          'Name must not exceed ${ValidationRules.supplementNameMaxLength} characters';
    }
    setState(() => _nameError = error);
    return error == null;
  }

  bool _validateBrand() {
    final brand = _brandController.text.trim();
    String? error;
    if (brand.length > ValidationRules.nameMaxLength) {
      error =
          'Brand must not exceed ${ValidationRules.nameMaxLength} characters';
    }
    setState(() => _brandError = error);
    return error == null;
  }

  bool _validateCustomForm() {
    if (_selectedForm != SupplementForm.other) {
      setState(() => _customFormError = null);
      return true;
    }
    final customForm = _customFormController.text.trim();
    String? error;
    if (customForm.isEmpty) {
      error = 'Custom form is required when Form is Other';
    } else if (customForm.length > ValidationRules.nameMaxLength) {
      error =
          'Custom form must not exceed ${ValidationRules.nameMaxLength} characters';
    }
    setState(() => _customFormError = error);
    return error == null;
  }

  bool _validateCustomDosageUnit() {
    if (_selectedDosageUnit != DosageUnit.custom) {
      setState(() => _customDosageUnitError = null);
      return true;
    }
    final customUnit = _customDosageUnitController.text.trim();
    String? error;
    if (customUnit.isEmpty) {
      error = 'Custom unit is required when Dosage Unit is custom';
    } else if (customUnit.length > 50) {
      error = 'Custom unit must not exceed 50 characters';
    }
    setState(() => _customDosageUnitError = error);
    return error == null;
  }

  bool _validateDosageAmount() {
    final text = _dosageAmountController.text.trim();
    String? error;
    if (text.isEmpty) {
      error = 'Dosage amount is required';
    } else {
      final value = int.tryParse(text);
      if (value == null) {
        error = 'Please enter a valid number';
      } else if (value <= 0) {
        error = 'Dosage must be greater than 0';
      }
    }
    setState(() => _dosageAmountError = error);
    return error == null;
  }

  bool _validateQuantityPerDose() {
    final text = _quantityPerDoseController.text.trim();
    String? error;
    if (text.isEmpty) {
      error = 'Quantity per dose is required';
    } else {
      final value = int.tryParse(text);
      if (value == null) {
        error = 'Please enter a valid whole number';
      } else if (value < 1) {
        error = 'Quantity must be at least 1';
      }
    }
    setState(() => _quantityPerDoseError = error);
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

  bool _validateEveryXDays() {
    if (_selectedFrequency != SupplementFrequencyType.everyXDays) {
      setState(() => _everyXDaysError = null);
      return true;
    }
    final text = _everyXDaysController.text.trim();
    String? error;
    if (text.isEmpty) {
      error = 'Number of days is required';
    } else {
      final value = int.tryParse(text);
      if (value == null) {
        error = 'Please enter a valid number';
      } else if (value < 2 || value > 365) {
        error = 'Must be between 2 and 365';
      }
    }
    setState(() => _everyXDaysError = error);
    return error == null;
  }

  bool _validateSpecificDays() {
    if (_selectedFrequency != SupplementFrequencyType.specificWeekdays) {
      setState(() => _specificDaysError = null);
      return true;
    }
    String? error;
    if (_selectedWeekdays.isEmpty) {
      error = 'At least 1 day must be selected';
    }
    setState(() => _specificDaysError = error);
    return error == null;
  }

  bool _validateOffsetMinutes() {
    if (_selectedTimingType != SupplementTimingType.beforeEvent &&
        _selectedTimingType != SupplementTimingType.afterEvent) {
      setState(() => _offsetMinutesError = null);
      return true;
    }
    String? error;
    if (_offsetMinutes < 5 || _offsetMinutes > 120) {
      error = 'Must be between 5 and 120 minutes';
    }
    setState(() => _offsetMinutesError = error);
    return error == null;
  }

  bool _validateSpecificTime() {
    if (_selectedTimingType != SupplementTimingType.specificTime) {
      setState(() => _specificTimeError = null);
      return true;
    }
    String? error;
    if (_specificTimeMinutes == null) {
      error = 'Please select a time';
    } else if (_specificTimeMinutes! < 0 || _specificTimeMinutes! >= 1440) {
      error = 'Invalid time';
    }
    setState(() => _specificTimeError = error);
    return error == null;
  }

  bool _validateEndDate() {
    if (_startDate == null || _endDate == null) {
      setState(() => _endDateError = null);
      return true;
    }
    String? error;
    if (_endDate!.isBefore(_startDate!)) {
      error = 'End date must be after start date';
    }
    setState(() => _endDateError = error);
    return error == null;
  }

  bool _validateAll() {
    final nameValid = _validateName();
    final brandValid = _validateBrand();
    final customFormValid = _validateCustomForm();
    final dosageAmountValid = _validateDosageAmount();
    final customDosageUnitValid = _validateCustomDosageUnit();
    final quantityPerDoseValid = _validateQuantityPerDose();
    final everyXDaysValid = _validateEveryXDays();
    final specificDaysValid = _validateSpecificDays();
    final offsetMinutesValid = _validateOffsetMinutes();
    final specificTimeValid = _validateSpecificTime();
    final endDateValid = _validateEndDate();
    final notesValid = _validateNotes();
    return nameValid &&
        brandValid &&
        customFormValid &&
        dosageAmountValid &&
        customDosageUnitValid &&
        quantityPerDoseValid &&
        everyXDaysValid &&
        specificDaysValid &&
        offsetMinutesValid &&
        specificTimeValid &&
        endDateValid &&
        notesValid;
  }

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
      final dosageAmount =
          int.tryParse(_dosageAmountController.text.trim()) ??
          ValidationRules.quantityPerDoseMin;

      final ingredients = _ingredients
          .map((name) => SupplementIngredient(name: name))
          .toList();

      final schedule = SupplementSchedule(
        anchorEvent: _selectedAnchorEvent,
        timingType: _selectedTimingType,
        offsetMinutes: _offsetMinutes,
        specificTimeMinutes: _specificTimeMinutes,
        frequencyType: _selectedFrequency,
        everyXDays: _selectedFrequency == SupplementFrequencyType.everyXDays
            ? (int.tryParse(_everyXDaysController.text.trim()) ?? 2)
            : 1,
        weekdays: _selectedFrequency == SupplementFrequencyType.specificWeekdays
            ? _selectedWeekdays
            : [0, 1, 2, 3, 4, 5, 6],
      );

      final startDateMs = _startDate?.millisecondsSinceEpoch;
      final endDateMs = _endDate?.millisecondsSinceEpoch;

      final sourceTrimmed = _sourceController.text.trim();
      final pricePaid = double.tryParse(_pricePaidController.text.trim());

      if (_isEditing) {
        await ref
            .read(supplementListProvider(widget.profileId).notifier)
            .updateSupplement(
              UpdateSupplementInput(
                id: widget.supplement!.id,
                profileId: widget.profileId,
                name: _nameController.text.trim(),
                form: _selectedForm,
                customForm: _selectedForm == SupplementForm.other
                    ? _customFormController.text.trim()
                    : null,
                dosageQuantity: dosageAmount,
                dosageUnit: _selectedDosageUnit,
                customDosageUnit: _selectedDosageUnit == DosageUnit.custom
                    ? _customDosageUnitController.text.trim()
                    : null,
                brand: _brandController.text.trim(),
                notes: _notesController.text.trim(),
                ingredients: ingredients,
                schedules: [schedule],
                startDate: startDateMs,
                endDate: endDateMs,
                source: sourceTrimmed.isNotEmpty ? sourceTrimmed : null,
                pricePaid: pricePaid,
              ),
            );
      } else {
        await ref
            .read(supplementListProvider(widget.profileId).notifier)
            .create(
              CreateSupplementInput(
                profileId: widget.profileId,
                clientId: const Uuid().v4(),
                name: _nameController.text.trim(),
                form: _selectedForm,
                customForm: _selectedForm == SupplementForm.other
                    ? _customFormController.text.trim()
                    : null,
                dosageQuantity: dosageAmount,
                dosageUnit: _selectedDosageUnit,
                customDosageUnit: _selectedDosageUnit == DosageUnit.custom
                    ? _customDosageUnitController.text.trim()
                    : null,
                brand: _brandController.text.trim(),
                notes: _notesController.text.trim(),
                ingredients: ingredients,
                schedules: [schedule],
                startDate: startDateMs,
                endDate: endDateMs,
                source: sourceTrimmed.isNotEmpty ? sourceTrimmed : null,
                pricePaid: pricePaid,
              ),
            );
      }

      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: _isEditing
              ? 'Supplement updated successfully'
              : 'Supplement created successfully',
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
