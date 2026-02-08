// lib/presentation/screens/fluids_entries/fluids_entry_screen.dart
// Implements 38_UI_FIELD_SPECIFICATIONS.md Section 6.1 - Fluids Entry Screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/fluids_entries/fluids_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/fluids_entries/fluids_entry_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Screen for creating or editing a fluids entry.
///
/// Follows 38_UI_FIELD_SPECIFICATIONS.md Section 6.1 exactly.
/// Uses [FluidsEntryList] provider for state management via log/updateEntry.
///
/// Sections:
/// - Header: Date & Time
/// - Water Intake: amount, unit, quick add, notes
/// - Bowel Movement: toggle, condition, size, photo
/// - Urine: toggle, color, size, urgency
/// - Menstruation: flow level
/// - BBT: temperature, unit, time recorded
/// - Custom Fluid: name, amount, notes
class FluidsEntryScreen extends ConsumerStatefulWidget {
  final String profileId;
  final FluidsEntry? fluidsEntry;

  const FluidsEntryScreen({
    super.key,
    required this.profileId,
    this.fluidsEntry,
  });

  @override
  ConsumerState<FluidsEntryScreen> createState() => _FluidsEntryScreenState();
}

class _FluidsEntryScreenState extends ConsumerState<FluidsEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Header
  late DateTime _entryDateTime;

  // Water Intake
  late final TextEditingController _waterAmountController;
  late final TextEditingController _waterNotesController;
  // SPEC_REVIEW: Spec says Water Unit dropdown with mL/fl oz. Defaulting to fl oz (US default)
  // since preferences system isn't built yet.
  bool _useMetricWater = false; // false = fl oz, true = mL

  // Bowel Movement
  bool _hadBowelMovement = false;
  BowelCondition? _bowelCondition;
  late final TextEditingController _bowelCustomConditionController;
  MovementSize _bowelSize = MovementSize.medium;

  // Urine
  bool _hadUrination = false;
  UrineCondition? _urineCondition;
  late final TextEditingController _urineCustomColorController;
  MovementSize _urineSize = MovementSize.medium;
  double _urineUrgency = 3;

  // Menstruation
  MenstruationFlow _menstruationFlow = MenstruationFlow.none;

  // BBT
  late final TextEditingController _bbtController;
  bool _useMetricBBT = false; // false = F, true = C
  late DateTime _bbtRecordedTime;

  // Custom Fluid
  late final TextEditingController _otherFluidNameController;
  late final TextEditingController _otherFluidAmountController;
  late final TextEditingController _otherFluidNotesController;

  // Form state
  bool _isDirty = false;
  bool _isSaving = false;

  // Validation errors
  String? _waterAmountError;
  String? _waterNotesError;
  String? _bowelCustomConditionError;
  String? _urineCustomColorError;
  String? _bbtError;
  String? _otherFluidNameError;
  String? _otherFluidAmountError;
  String? _otherFluidNotesError;

  bool get _isEditing => widget.fluidsEntry != null;

  @override
  void initState() {
    super.initState();
    final entry = widget.fluidsEntry;

    // Header
    _entryDateTime = entry != null
        ? DateTime.fromMillisecondsSinceEpoch(entry.entryDate)
        : DateTime.now();

    // Water Intake
    final waterAmountText = entry?.waterIntakeMl != null
        ? (_useMetricWater
              ? entry!.waterIntakeMl.toString()
              : _mlToFlOz(entry!.waterIntakeMl!).toStringAsFixed(0))
        : '';
    _waterAmountController = TextEditingController(text: waterAmountText);
    _waterNotesController = TextEditingController(
      text: entry?.waterIntakeNotes ?? '',
    );

    // Bowel Movement
    _hadBowelMovement = entry?.bowelCondition != null;
    _bowelCondition = entry?.bowelCondition;
    _bowelCustomConditionController = TextEditingController();
    _bowelSize = entry?.bowelSize ?? MovementSize.medium;

    // Urine
    _hadUrination = entry?.urineCondition != null;
    _urineCondition = entry?.urineCondition;
    _urineCustomColorController = TextEditingController();
    _urineSize = entry?.urineSize ?? MovementSize.medium;
    // SPEC_REVIEW: Urgency is not stored in FluidsEntry entity. Spec section 6.1
    // lists Urgency as a Slider (1-5 scale) in Urine section but FluidsEntry has no
    // urgency field. Implementing UI as spec requires, but value will not be persisted.
    _urineUrgency = 3;

    // Menstruation
    _menstruationFlow = entry?.menstruationFlow ?? MenstruationFlow.none;

    // BBT
    _bbtController = TextEditingController(
      text: entry?.basalBodyTemperature?.toString() ?? '',
    );
    _bbtRecordedTime = entry?.bbtRecordedTime != null
        ? DateTime.fromMillisecondsSinceEpoch(entry!.bbtRecordedTime!)
        : DateTime.now();

    // Custom Fluid
    _otherFluidNameController = TextEditingController(
      text: entry?.otherFluidName ?? '',
    );
    _otherFluidAmountController = TextEditingController(
      text: entry?.otherFluidAmount ?? '',
    );
    _otherFluidNotesController = TextEditingController(
      text: entry?.otherFluidNotes ?? '',
    );

    // Listen for dirty tracking
    _waterAmountController.addListener(_markDirty);
    _waterNotesController.addListener(_markDirty);
    _bowelCustomConditionController.addListener(_markDirty);
    _urineCustomColorController.addListener(_markDirty);
    _bbtController.addListener(_markDirty);
    _otherFluidNameController.addListener(_markDirty);
    _otherFluidAmountController.addListener(_markDirty);
    _otherFluidNotesController.addListener(_markDirty);
  }

  @override
  void dispose() {
    _waterAmountController.dispose();
    _waterNotesController.dispose();
    _bowelCustomConditionController.dispose();
    _urineCustomColorController.dispose();
    _bbtController.dispose();
    _otherFluidNameController.dispose();
    _otherFluidAmountController.dispose();
    _otherFluidNotesController.dispose();
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
          title: Text(_isEditing ? 'Edit Fluids Entry' : 'Add Fluids Entry'),
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
          label: _isEditing
              ? 'Edit fluids entry form'
              : 'Add fluids entry form',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // === Header Section ===
                _buildSectionHeader(theme, 'Date & Time'),
                const SizedBox(height: 16),
                _buildDateTimePicker(theme),
                const SizedBox(height: 24),

                // === Water Intake Section ===
                _buildSectionHeader(theme, 'Water Intake'),
                const SizedBox(height: 16),
                _buildWaterAmountRow(theme),
                const SizedBox(height: 16),
                _buildQuickAddButtons(theme),
                const SizedBox(height: 16),
                _buildWaterNotes(theme),
                const SizedBox(height: 24),

                // === Bowel Movement Section ===
                _buildSectionHeader(theme, 'Bowel Movement'),
                const SizedBox(height: 16),
                _buildBowelToggle(theme),
                if (_hadBowelMovement) ...[
                  const SizedBox(height: 16),
                  _buildBowelConditionDropdown(theme),
                  if (_bowelCondition == BowelCondition.custom) ...[
                    const SizedBox(height: 16),
                    _buildBowelCustomCondition(theme),
                  ],
                  const SizedBox(height: 16),
                  _buildBowelSizeDropdown(theme),
                  const SizedBox(height: 16),
                  _buildBowelPhoto(theme),
                ],
                const SizedBox(height: 24),

                // === Urine Section ===
                _buildSectionHeader(theme, 'Urine'),
                const SizedBox(height: 16),
                _buildUrineToggle(theme),
                if (_hadUrination) ...[
                  const SizedBox(height: 16),
                  _buildUrineColorDropdown(theme),
                  if (_urineCondition == UrineCondition.custom) ...[
                    const SizedBox(height: 16),
                    _buildUrineCustomColor(theme),
                  ],
                  const SizedBox(height: 16),
                  _buildUrineSizeDropdown(theme),
                  const SizedBox(height: 16),
                  _buildUrineUrgencySlider(theme),
                ],
                const SizedBox(height: 24),

                // === Menstruation Section ===
                _buildSectionHeader(theme, 'Menstruation'),
                const SizedBox(height: 16),
                _buildMenstruationFlow(theme),
                const SizedBox(height: 24),

                // === BBT Section ===
                _buildSectionHeader(theme, 'Basal Body Temperature'),
                const SizedBox(height: 16),
                _buildBBTRow(theme),
                const SizedBox(height: 16),
                _buildBBTTimePicker(theme),
                const SizedBox(height: 24),

                // === Custom Fluid Section ===
                _buildSectionHeader(theme, 'Other Fluid'),
                const SizedBox(height: 16),
                _buildOtherFluidName(theme),
                const SizedBox(height: 16),
                _buildOtherFluidAmount(theme),
                const SizedBox(height: 16),
                _buildOtherFluidNotes(theme),
                const SizedBox(height: 32),

                // === Action Buttons ===
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
                            ? 'Save fluids entry changes'
                            : 'Save new fluids entry',
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

  // === Section Header ===

  Widget _buildSectionHeader(ThemeData theme, String title) => Semantics(
    header: true,
    child: Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    ),
  );

  // === Header Section ===

  Widget _buildDateTimePicker(ThemeData theme) => InkWell(
    onTap: () async {
      final now = DateTime.now();
      final date = await showDatePicker(
        context: context,
        initialDate: _entryDateTime,
        firstDate: DateTime(2020),
        lastDate: now,
      );
      if (date != null && mounted) {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(_entryDateTime),
        );
        if (time != null) {
          final newDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          // Validation: Not future
          if (!newDateTime.isAfter(DateTime.now())) {
            setState(() {
              _entryDateTime = newDateTime;
              _isDirty = true;
            });
          }
        }
      }
    },
    child: InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Date & Time',
        suffixIcon: Icon(Icons.calendar_today),
      ),
      child: Text(
        _formatDateTime(_entryDateTime),
        style: theme.textTheme.bodyLarge,
      ),
    ),
  );

  // === Water Intake Section ===

  Widget _buildWaterAmountRow(ThemeData theme) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 2,
        child: Semantics(
          label: 'Custom water amount, enter ounces',
          textField: true,
          child: ExcludeSemantics(
            child: ShadowTextField.numeric(
              controller: _waterAmountController,
              label: 'Water Amount',
              hintText: 'Amount',
              errorText: _waterAmountError,
              maxLength: 10,
              textInputAction: TextInputAction.next,
              onChanged: (_) => _validateWaterAmount(),
            ),
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: DropdownButtonFormField<bool>(
            initialValue: _useMetricWater,
            decoration: const InputDecoration(labelText: 'Unit'),
            items: const [
              DropdownMenuItem(value: false, child: Text('fl oz')),
              DropdownMenuItem(value: true, child: Text('mL')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _useMetricWater = value;
                  _isDirty = true;
                });
              }
            },
          ),
        ),
      ),
    ],
  );

  Widget _buildQuickAddButtons(ThemeData theme) {
    if (_useMetricWater) {
      return Row(
        children: [
          Expanded(
            child: ShadowButton.outlined(
              onPressed: () => _quickAddWater(250),
              label: 'Add 250 milliliters water',
              child: const Text('250 mL'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ShadowButton.outlined(
              onPressed: () => _quickAddWater(350),
              label: 'Add 350 milliliters water',
              child: const Text('350 mL'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ShadowButton.outlined(
              onPressed: () => _quickAddWater(500),
              label: 'Add 500 milliliters water',
              child: const Text('500 mL'),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: ShadowButton.outlined(
            onPressed: () => _quickAddWater(237),
            label: 'Add 8 ounces water',
            child: const Text('8 oz'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ShadowButton.outlined(
            onPressed: () => _quickAddWater(355),
            label: 'Add 12 ounces water',
            child: const Text('12 oz'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ShadowButton.outlined(
            onPressed: () => _quickAddWater(473),
            label: 'Add 16 ounces water',
            child: const Text('16 oz'),
          ),
        ),
      ],
    );
  }

  Widget _buildWaterNotes(ThemeData theme) => Semantics(
    label: 'Water intake notes, optional',
    textField: true,
    child: ExcludeSemantics(
      child: ShadowTextField(
        controller: _waterNotesController,
        label: 'Water Notes',
        hintText: 'e.g., with lemon',
        errorText: _waterNotesError,
        maxLength: 200,
        textInputAction: TextInputAction.next,
        onChanged: (_) => _validateWaterNotes(),
      ),
    ),
  );

  // === Bowel Movement Section ===

  Widget _buildBowelToggle(ThemeData theme) => Semantics(
    label: 'Had bowel movement, toggle',
    toggled: _hadBowelMovement,
    child: ExcludeSemantics(
      child: SwitchListTile(
        title: const Text('Had Bowel Movement'),
        value: _hadBowelMovement,
        onChanged: (value) {
          setState(() {
            _hadBowelMovement = value;
            _isDirty = true;
            if (!value) {
              _bowelCondition = null;
              _bowelCustomConditionController.clear();
              _bowelSize = MovementSize.medium;
            }
          });
        },
      ),
    ),
  );

  Widget _buildBowelConditionDropdown(ThemeData theme) => Semantics(
    // SPEC_REVIEW: Section 18.5 lists accessibility label as "Bristol stool scale, 1 to 7,
    // required if bowel movement" but Section 6.1 field table defines Condition dropdown with
    // values Diarrhea/Runny/Loose/Normal/Firm/Hard/Custom (which is BowelCondition enum, not
    // Bristol 1-7). Implementing per Section 6.1 field table, using Section 18.5 label as-is.
    label: 'Bristol stool scale, 1 to 7, required if bowel movement',
    child: ExcludeSemantics(
      child: DropdownButtonFormField<BowelCondition>(
        initialValue: _bowelCondition,
        decoration: const InputDecoration(
          labelText: 'Condition',
          hintText: 'Select',
        ),
        items: BowelCondition.values
            .map(
              (condition) => DropdownMenuItem<BowelCondition>(
                value: condition,
                child: Text(_bowelConditionLabel(condition)),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            _bowelCondition = value;
            _isDirty = true;
            if (value != BowelCondition.custom) {
              _bowelCustomConditionController.clear();
              _bowelCustomConditionError = null;
            }
          });
        },
      ),
    ),
  );

  Widget _buildBowelCustomCondition(ThemeData theme) => ShadowTextField(
    controller: _bowelCustomConditionController,
    label: 'Custom Condition',
    hintText: 'Describe',
    errorText: _bowelCustomConditionError,
    maxLength: 100,
    textInputAction: TextInputAction.next,
    onChanged: (_) => _validateBowelCustomCondition(),
  );

  Widget _buildBowelSizeDropdown(ThemeData theme) => Semantics(
    label: 'Movement size, small medium or large',
    child: ExcludeSemantics(
      child: DropdownButtonFormField<MovementSize>(
        initialValue: _bowelSize,
        decoration: const InputDecoration(labelText: 'Size'),
        items: MovementSize.values
            .map(
              (size) => DropdownMenuItem<MovementSize>(
                value: size,
                child: Text(_movementSizeLabel(size)),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _bowelSize = value;
              _isDirty = true;
            });
          }
        },
      ),
    ),
  );

  Widget _buildBowelPhoto(ThemeData theme) => ShadowButton.outlined(
    onPressed: () {
      // Photo infrastructure not built yet - stub button
    },
    label: 'Take photo of bowel movement, optional',
    child: const Text('Add photo'),
  );

  // === Urine Section ===

  Widget _buildUrineToggle(ThemeData theme) => Semantics(
    label: 'Had urination, toggle',
    toggled: _hadUrination,
    child: ExcludeSemantics(
      child: SwitchListTile(
        title: const Text('Had Urination'),
        value: _hadUrination,
        onChanged: (value) {
          setState(() {
            _hadUrination = value;
            _isDirty = true;
            if (!value) {
              _urineCondition = null;
              _urineCustomColorController.clear();
              _urineSize = MovementSize.medium;
              _urineUrgency = 3;
            }
          });
        },
      ),
    ),
  );

  Widget _buildUrineColorDropdown(ThemeData theme) => Semantics(
    label: 'Urine color, select from scale',
    child: ExcludeSemantics(
      child: DropdownButtonFormField<UrineCondition>(
        initialValue: _urineCondition,
        decoration: const InputDecoration(
          labelText: 'Color',
          hintText: 'Select color',
        ),
        items: UrineCondition.values
            .map(
              (condition) => DropdownMenuItem<UrineCondition>(
                value: condition,
                child: Text(_urineConditionLabel(condition)),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            _urineCondition = value;
            _isDirty = true;
            if (value != UrineCondition.custom) {
              _urineCustomColorController.clear();
              _urineCustomColorError = null;
            }
          });
        },
      ),
    ),
  );

  Widget _buildUrineCustomColor(ThemeData theme) => ShadowTextField(
    controller: _urineCustomColorController,
    label: 'Custom Color',
    hintText: 'Describe',
    errorText: _urineCustomColorError,
    maxLength: 100,
    textInputAction: TextInputAction.next,
    onChanged: (_) => _validateUrineCustomColor(),
  );

  Widget _buildUrineSizeDropdown(ThemeData theme) => Semantics(
    label: 'Urination volume, small medium or large',
    child: ExcludeSemantics(
      child: DropdownButtonFormField<MovementSize>(
        initialValue: _urineSize,
        decoration: const InputDecoration(labelText: 'Size'),
        items: const [
          DropdownMenuItem(value: MovementSize.small, child: Text('Small')),
          DropdownMenuItem(value: MovementSize.medium, child: Text('Medium')),
          DropdownMenuItem(value: MovementSize.large, child: Text('Large')),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _urineSize = value;
              _isDirty = true;
            });
          }
        },
      ),
    ),
  );

  Widget _buildUrineUrgencySlider(ThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Urgency: ${_urineUrgency.round()}',
        style: theme.textTheme.bodyMedium,
      ),
      Slider(
        value: _urineUrgency,
        min: 1,
        max: 5,
        divisions: 4,
        label: _urineUrgency.round().toString(),
        onChanged: (value) {
          setState(() {
            _urineUrgency = value;
            _isDirty = true;
          });
        },
      ),
    ],
  );

  // === Menstruation Section ===

  Widget _buildMenstruationFlow(ThemeData theme) => Semantics(
    label: 'Menstruation flow intensity, none to heavy',
    child: ExcludeSemantics(
      child: ShadowPicker.flow(
        label: 'Flow Level',
        flowValue: _menstruationFlow,
        onFlowChanged: (flow) {
          if (flow != null) {
            setState(() {
              _menstruationFlow = flow;
              _isDirty = true;
            });
          }
        },
      ),
    ),
  );

  // === BBT Section ===

  Widget _buildBBTRow(ThemeData theme) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 2,
        child: Semantics(
          label: 'Basal body temperature, required, degrees',
          textField: true,
          child: ExcludeSemantics(
            child: ShadowTextField.numeric(
              controller: _bbtController,
              label: 'Temperature',
              hintText: 'e.g., 98.6',
              errorText: _bbtError,
              maxLength: 6,
              textInputAction: TextInputAction.next,
              onChanged: (_) => _validateBBT(),
            ),
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: DropdownButtonFormField<bool>(
            initialValue: _useMetricBBT,
            decoration: const InputDecoration(labelText: 'Unit'),
            items: const [
              DropdownMenuItem(value: false, child: Text('\u00B0F')),
              DropdownMenuItem(value: true, child: Text('\u00B0C')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _useMetricBBT = value;
                  _isDirty = true;
                  _validateBBT();
                });
              }
            },
          ),
        ),
      ),
    ],
  );

  Widget _buildBBTTimePicker(ThemeData theme) => Semantics(
    label: 'Temperature recorded time',
    child: ExcludeSemantics(
      child: InkWell(
        onTap: () async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(_bbtRecordedTime),
          );
          if (time != null) {
            setState(() {
              _bbtRecordedTime = DateTime(
                _bbtRecordedTime.year,
                _bbtRecordedTime.month,
                _bbtRecordedTime.day,
                time.hour,
                time.minute,
              );
              _isDirty = true;
            });
          }
        },
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Time Recorded',
            hintText: 'Time measured',
            suffixIcon: Icon(Icons.access_time),
          ),
          child: Text(
            _formatTime(TimeOfDay.fromDateTime(_bbtRecordedTime)),
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ),
    ),
  );

  // === Custom Fluid Section ===

  Widget _buildOtherFluidName(ThemeData theme) => Semantics(
    label: 'Other fluid name, optional',
    textField: true,
    child: ExcludeSemantics(
      child: ShadowTextField(
        controller: _otherFluidNameController,
        label: 'Fluid Name',
        hintText: 'e.g., Sweat, Mucus',
        errorText: _otherFluidNameError,
        maxLength: 100,
        textInputAction: TextInputAction.next,
        onChanged: (_) => _validateOtherFluidName(),
      ),
    ),
  );

  Widget _buildOtherFluidAmount(ThemeData theme) => Semantics(
    label: 'Other fluid amount, optional',
    textField: true,
    child: ExcludeSemantics(
      child: ShadowTextField(
        controller: _otherFluidAmountController,
        label: 'Amount',
        hintText: 'e.g., Light, Heavy, 2 tbsp',
        errorText: _otherFluidAmountError,
        maxLength: 100,
        textInputAction: TextInputAction.next,
        onChanged: (_) => _validateOtherFluidAmount(),
      ),
    ),
  );

  Widget _buildOtherFluidNotes(ThemeData theme) => Semantics(
    label: 'Other fluid notes, optional',
    textField: true,
    child: ExcludeSemantics(
      child: ShadowTextField(
        controller: _otherFluidNotesController,
        label: 'Notes',
        hintText: 'Additional details',
        errorText: _otherFluidNotesError,
        maxLength: 500,
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        onChanged: (_) => _validateOtherFluidNotes(),
      ),
    ),
  );

  // === Label Helpers ===

  String _bowelConditionLabel(BowelCondition condition) => switch (condition) {
    BowelCondition.diarrhea => 'Diarrhea',
    BowelCondition.runny => 'Runny',
    BowelCondition.loose => 'Loose',
    BowelCondition.normal => 'Normal',
    BowelCondition.firm => 'Firm',
    BowelCondition.hard => 'Hard',
    BowelCondition.custom => 'Custom',
  };

  String _movementSizeLabel(MovementSize size) => switch (size) {
    MovementSize.tiny => 'Tiny',
    MovementSize.small => 'Small',
    MovementSize.medium => 'Medium',
    MovementSize.large => 'Large',
    MovementSize.huge => 'Huge',
  };

  String _urineConditionLabel(UrineCondition condition) => switch (condition) {
    UrineCondition.clear => 'Clear',
    UrineCondition.lightYellow => 'Light Yellow',
    UrineCondition.yellow => 'Yellow',
    UrineCondition.darkYellow => 'Dark Yellow',
    UrineCondition.amber => 'Amber',
    UrineCondition.brown => 'Brown',
    UrineCondition.red => 'Red',
    UrineCondition.custom => 'Custom',
  };

  // === Formatting Helpers ===

  String _formatDateTime(DateTime dt) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} $hour:$minute $period';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  // === Conversion Helpers ===

  double _mlToFlOz(int ml) => ml / 29.5735;

  int _flOzToMl(double flOz) => (flOz * 29.5735).round();

  double _celsiusToFahrenheit(double c) => c * 9 / 5 + 32;

  // === Quick Add ===

  void _quickAddWater(int ml) {
    final currentText = _waterAmountController.text.trim();
    double currentAmount = 0;
    if (currentText.isNotEmpty) {
      currentAmount = double.tryParse(currentText) ?? 0;
    }

    double addAmount;
    if (_useMetricWater) {
      addAmount = ml.toDouble();
    } else {
      addAmount = _mlToFlOz(ml);
    }

    final newAmount = currentAmount + addAmount;
    _waterAmountController.text = newAmount.toStringAsFixed(0);
    _isDirty = true;
    _validateWaterAmount();
  }

  // === Validation Methods ===

  bool _validateWaterAmount() {
    final text = _waterAmountController.text.trim();
    String? error;
    if (text.isNotEmpty) {
      final value = double.tryParse(text);
      if (value == null) {
        error = 'Please enter a valid number';
      } else if (value < 0) {
        error = 'Amount must be 0 or greater';
      }
    }
    setState(() => _waterAmountError = error);
    return error == null;
  }

  bool _validateWaterNotes() {
    final notes = _waterNotesController.text.trim();
    String? error;
    if (notes.length > 200) {
      error = 'Notes must not exceed 200 characters';
    }
    setState(() => _waterNotesError = error);
    return error == null;
  }

  bool _validateBowelCustomCondition() {
    if (_bowelCondition != BowelCondition.custom) {
      setState(() => _bowelCustomConditionError = null);
      return true;
    }
    final text = _bowelCustomConditionController.text.trim();
    String? error;
    if (text.isEmpty) {
      error = 'Description is required when Custom is selected';
    } else if (text.length > 100) {
      error = 'Description must not exceed 100 characters';
    }
    setState(() => _bowelCustomConditionError = error);
    return error == null;
  }

  bool _validateUrineCustomColor() {
    if (_urineCondition != UrineCondition.custom) {
      setState(() => _urineCustomColorError = null);
      return true;
    }
    final text = _urineCustomColorController.text.trim();
    String? error;
    if (text.isEmpty) {
      error = 'Description is required when Custom is selected';
    } else if (text.length > 100) {
      error = 'Description must not exceed 100 characters';
    }
    setState(() => _urineCustomColorError = error);
    return error == null;
  }

  bool _validateBBT() {
    final text = _bbtController.text.trim();
    String? error;
    if (text.isNotEmpty) {
      final value = double.tryParse(text);
      if (value == null) {
        error = 'Please enter a valid temperature';
      } else if (_useMetricBBT) {
        // Celsius: 35-40.5
        if (value < 35 || value > 40.5) {
          error = 'Temperature must be between 35 and 40.5 \u00B0C';
        }
      } else {
        // Fahrenheit: 95-105
        if (value < 95 || value > 105) {
          error = 'Temperature must be between 95 and 105 \u00B0F';
        }
      }
    }
    setState(() => _bbtError = error);
    return error == null;
  }

  bool _validateOtherFluidName() {
    final text = _otherFluidNameController.text.trim();
    String? error;
    if (text.length > 100) {
      error = 'Name must not exceed 100 characters';
    }
    setState(() => _otherFluidNameError = error);
    return error == null;
  }

  bool _validateOtherFluidAmount() {
    final text = _otherFluidAmountController.text.trim();
    String? error;
    if (text.length > 100) {
      error = 'Amount must not exceed 100 characters';
    }
    setState(() => _otherFluidAmountError = error);
    return error == null;
  }

  bool _validateOtherFluidNotes() {
    final text = _otherFluidNotesController.text.trim();
    String? error;
    if (text.length > 500) {
      error = 'Notes must not exceed 500 characters';
    }
    setState(() => _otherFluidNotesError = error);
    return error == null;
  }

  bool _validateAll() {
    final waterAmountValid = _validateWaterAmount();
    final waterNotesValid = _validateWaterNotes();
    final bowelCustomValid = _validateBowelCustomCondition();
    final urineCustomValid = _validateUrineCustomColor();
    final bbtValid = _validateBBT();
    final otherNameValid = _validateOtherFluidName();
    final otherAmountValid = _validateOtherFluidAmount();
    final otherNotesValid = _validateOtherFluidNotes();
    return waterAmountValid &&
        waterNotesValid &&
        bowelCustomValid &&
        urineCustomValid &&
        bbtValid &&
        otherNameValid &&
        otherAmountValid &&
        otherNotesValid;
  }

  // === Actions ===

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
      // Compute water intake in mL
      int? waterIntakeMl;
      final waterText = _waterAmountController.text.trim();
      if (waterText.isNotEmpty) {
        final waterValue = double.parse(waterText);
        if (_useMetricWater) {
          waterIntakeMl = waterValue.round();
        } else {
          waterIntakeMl = _flOzToMl(waterValue);
        }
      }

      // Compute BBT in Fahrenheit (stored in F per entity convention)
      double? basalBodyTemperature;
      int? bbtRecordedTime;
      final bbtText = _bbtController.text.trim();
      if (bbtText.isNotEmpty) {
        final bbtValue = double.parse(bbtText);
        if (_useMetricBBT) {
          basalBodyTemperature = _celsiusToFahrenheit(bbtValue);
        } else {
          basalBodyTemperature = bbtValue;
        }
        // bbtRecordedTime is REQUIRED when BBT is provided
        bbtRecordedTime = _bbtRecordedTime.millisecondsSinceEpoch;
      }

      final waterNotes = _waterNotesController.text.trim();
      final otherFluidName = _otherFluidNameController.text.trim();
      final otherFluidAmount = _otherFluidAmountController.text.trim();
      final otherFluidNotes = _otherFluidNotesController.text.trim();

      // Compute date range for today to read the provider
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay
          .add(const Duration(days: 1))
          .subtract(const Duration(milliseconds: 1));
      final startDate = startOfDay.millisecondsSinceEpoch;
      final endDate = endOfDay.millisecondsSinceEpoch;

      if (_isEditing) {
        await ref
            .read(
              fluidsEntryListProvider(
                widget.profileId,
                startDate,
                endDate,
              ).notifier,
            )
            .updateEntry(
              UpdateFluidsEntryInput(
                id: widget.fluidsEntry!.id,
                profileId: widget.profileId,
                waterIntakeMl: waterIntakeMl,
                waterIntakeNotes: waterNotes.isNotEmpty ? waterNotes : null,
                bowelCondition: _hadBowelMovement ? _bowelCondition : null,
                bowelSize: _hadBowelMovement ? _bowelSize : null,
                urineCondition: _hadUrination ? _urineCondition : null,
                urineSize: _hadUrination ? _urineSize : null,
                menstruationFlow: _menstruationFlow != MenstruationFlow.none
                    ? _menstruationFlow
                    : null,
                basalBodyTemperature: basalBodyTemperature,
                bbtRecordedTime: bbtRecordedTime,
                otherFluidName: otherFluidName.isNotEmpty
                    ? otherFluidName
                    : null,
                otherFluidAmount: otherFluidAmount.isNotEmpty
                    ? otherFluidAmount
                    : null,
                otherFluidNotes: otherFluidNotes.isNotEmpty
                    ? otherFluidNotes
                    : null,
              ),
            );
      } else {
        await ref
            .read(
              fluidsEntryListProvider(
                widget.profileId,
                startDate,
                endDate,
              ).notifier,
            )
            .log(
              LogFluidsEntryInput(
                profileId: widget.profileId,
                clientId: const Uuid().v4(),
                entryDate: _entryDateTime.millisecondsSinceEpoch,
                waterIntakeMl: waterIntakeMl,
                waterIntakeNotes: waterNotes.isNotEmpty ? waterNotes : null,
                bowelCondition: _hadBowelMovement ? _bowelCondition : null,
                bowelSize: _hadBowelMovement ? _bowelSize : null,
                urineCondition: _hadUrination ? _urineCondition : null,
                urineSize: _hadUrination ? _urineSize : null,
                menstruationFlow: _menstruationFlow != MenstruationFlow.none
                    ? _menstruationFlow
                    : null,
                basalBodyTemperature: basalBodyTemperature,
                bbtRecordedTime: bbtRecordedTime,
                otherFluidName: otherFluidName.isNotEmpty
                    ? otherFluidName
                    : null,
                otherFluidAmount: otherFluidAmount.isNotEmpty
                    ? otherFluidAmount
                    : null,
                otherFluidNotes: otherFluidNotes.isNotEmpty
                    ? otherFluidNotes
                    : null,
              ),
            );
      }

      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: _isEditing
              ? 'Fluids entry updated successfully'
              : 'Fluids entry created successfully',
        );
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: 'Failed to save fluids entry: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
