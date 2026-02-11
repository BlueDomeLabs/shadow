// lib/presentation/screens/supplements/supplement_edit_screen.dart
// Implements 38_UI_FIELD_SPECIFICATIONS.md Section 4.1 - Supplement Edit Screen

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/supplements/supplements_usecases.dart';
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

  // Controllers - Notes
  late final TextEditingController _notesController;

  // State - Dropdown values
  late SupplementForm _selectedForm;
  late DosageUnit _selectedDosageUnit;

  // State - Form dirty tracking
  bool _isDirty = false;
  bool _isSaving = false;

  // Validation error messages
  String? _nameError;
  String? _brandError;
  String? _customFormError;
  String? _dosageAmountError;
  String? _quantityPerDoseError;
  String? _notesError;

  bool get _isEditing => widget.supplement != null;

  @override
  void initState() {
    super.initState();
    final supplement = widget.supplement;

    _nameController = TextEditingController(text: supplement?.name ?? '');
    _brandController = TextEditingController(text: supplement?.brand ?? '');
    _customFormController = TextEditingController(
      text: supplement?.customForm ?? '',
    );
    _dosageAmountController = TextEditingController(
      text: supplement != null ? supplement.dosageQuantity.toString() : '',
    );
    _quantityPerDoseController = TextEditingController(text: '1');
    _notesController = TextEditingController(text: supplement?.notes ?? '');

    _selectedForm = supplement?.form ?? SupplementForm.capsule;
    _selectedDosageUnit = supplement?.dosageUnit ?? DosageUnit.mg;

    _nameController.addListener(_markDirty);
    _brandController.addListener(_markDirty);
    _customFormController.addListener(_markDirty);
    _dosageAmountController.addListener(_markDirty);
    _quantityPerDoseController.addListener(_markDirty);
    _notesController.addListener(_markDirty);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _customFormController.dispose();
    _dosageAmountController.dispose();
    _quantityPerDoseController.dispose();
    _notesController.dispose();
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
                const SizedBox(height: 16),
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

  bool _validateAll() {
    final nameValid = _validateName();
    final brandValid = _validateBrand();
    final customFormValid = _validateCustomForm();
    final dosageAmountValid = _validateDosageAmount();
    final quantityPerDoseValid = _validateQuantityPerDose();
    final notesValid = _validateNotes();
    return nameValid &&
        brandValid &&
        customFormValid &&
        dosageAmountValid &&
        quantityPerDoseValid &&
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
      final dosageAmount = int.parse(_dosageAmountController.text.trim());

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
                brand: _brandController.text.trim(),
                notes: _notesController.text.trim(),
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
                brand: _brandController.text.trim(),
                notes: _notesController.text.trim(),
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
