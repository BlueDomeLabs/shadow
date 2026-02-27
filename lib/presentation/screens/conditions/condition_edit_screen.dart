// lib/presentation/screens/conditions/condition_edit_screen.dart
// Implements 38_UI_FIELD_SPECIFICATIONS.md Section 8.1 - Condition Edit Screen

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/utils/photo_picker_utils.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/conditions/conditions_usecases.dart';
import 'package:shadow_app/presentation/providers/conditions/condition_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Screen for creating or editing a condition.
///
/// Follows 38_UI_FIELD_SPECIFICATIONS.md Section 8.1 exactly.
/// Uses [ConditionListProvider] for state management via create.
///
/// Fields:
/// - Basic Information: name, category, bodyLocations, description
/// - Timeline: startTimeframe, status
/// - Photo: baselinePhoto (placeholder)
class ConditionEditScreen extends ConsumerStatefulWidget {
  final String profileId;
  final Condition? condition;

  const ConditionEditScreen({
    super.key,
    required this.profileId,
    this.condition,
  });

  @override
  ConsumerState<ConditionEditScreen> createState() =>
      _ConditionEditScreenState();
}

class _ConditionEditScreenState extends ConsumerState<ConditionEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers - Basic Information
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  // State - Dropdown values
  String? _selectedCategory;
  String? _selectedStartTimeframe;
  late ConditionStatus _selectedStatus;
  late List<String> _selectedBodyLocations;

  // State - Photo
  String? _baselinePhotoPath;

  // State - Form dirty tracking
  bool _isDirty = false;
  bool _isSaving = false;

  // Validation error messages
  String? _nameError;
  String? _categoryError;
  String? _bodyLocationsError;
  String? _descriptionError;
  String? _startTimeframeError;

  bool get _isEditing => widget.condition != null;

  static const List<String> _categoryOptions = [
    'Skin',
    'Digestive',
    'Respiratory',
    'Autoimmune',
    'Mental Health',
    'Pain',
    'Other',
  ];

  static const List<String> _startTimeframeOptions = [
    'This week',
    'This month',
    'This year',
    '1-2 years',
    '2-5 years',
    '5+ years',
    'Since birth',
    'Unknown',
  ];

  static const List<String> _bodyLocationOptions = [
    'Head',
    'Face',
    'Neck',
    'Chest',
    'Back',
    'Stomach',
    'Arms',
    'Hands',
    'Legs',
    'Feet',
    'Joints',
    'Internal',
    'Whole Body',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final condition = widget.condition;

    _nameController = TextEditingController(text: condition?.name ?? '');
    _descriptionController = TextEditingController(
      text: condition?.description ?? '',
    );

    _selectedCategory = condition?.category;
    _selectedBodyLocations = condition?.bodyLocations.toList() ?? [];
    _selectedStatus = condition?.status ?? ConditionStatus.active;
    _selectedStartTimeframe = condition != null
        ? _epochToTimeframeLabel(condition.startTimeframe)
        : null;
    _baselinePhotoPath = condition?.baselinePhotoPath;

    _nameController.addListener(_markDirty);
    _descriptionController.addListener(_markDirty);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
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
          title: Text(_isEditing ? 'Edit Condition' : 'Add Condition'),
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
          label: _isEditing ? 'Edit condition form' : 'Add condition form',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionHeader(theme, 'Basic Information'),
                const SizedBox(height: 16),
                // Condition Name
                Semantics(
                  label: 'Condition name, required',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _nameController,
                      label: 'Condition Name',
                      hintText: 'e.g., Eczema',
                      errorText: _nameError,
                      maxLength: ValidationRules.conditionNameMaxLength,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => _validateName(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Category
                Semantics(
                  label: 'Condition category, optional',
                  child: ExcludeSemantics(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        hintText: 'Select category',
                      ),
                      items: _categoryOptions
                          .map(
                            (category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                          _isDirty = true;
                          _validateCategory();
                        });
                      },
                    ),
                  ),
                ),
                if (_categoryError != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _categoryError!,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                // Body Locations - Multi-select with FilterChip
                Text('Body Locations', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _bodyLocationOptions.map((location) {
                    final isSelected = _selectedBodyLocations.contains(
                      location,
                    );
                    return FilterChip(
                      label: Text(location),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedBodyLocations.add(location);
                          } else {
                            _selectedBodyLocations.remove(location);
                          }
                          _isDirty = true;
                          _validateBodyLocations();
                        });
                      },
                    );
                  }).toList(),
                ),
                if (_bodyLocationsError != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _bodyLocationsError!,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                // Description
                Semantics(
                  label: 'Condition description, optional',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      hintText: 'Describe the condition',
                      errorText: _descriptionError,
                      maxLength: ValidationRules.descriptionMaxLength,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onChanged: (_) => _validateDescription(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                _buildSectionHeader(theme, 'Details'),
                const SizedBox(height: 16),
                // Start Timeframe
                Semantics(
                  label: 'Start timeframe, required',
                  child: ExcludeSemantics(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedStartTimeframe,
                      decoration: const InputDecoration(
                        labelText: 'Start Timeframe',
                      ),
                      items: _startTimeframeOptions
                          .map(
                            (timeframe) => DropdownMenuItem<String>(
                              value: timeframe,
                              child: Text(timeframe),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStartTimeframe = value;
                          _isDirty = true;
                          _validateStartTimeframe();
                        });
                      },
                    ),
                  ),
                ),
                if (_startTimeframeError != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _startTimeframeError!,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                // Status - SegmentedButton
                Semantics(
                  label: 'Condition status, required',
                  child: ExcludeSemantics(
                    child: SegmentedButton<ConditionStatus>(
                      segments: const [
                        ButtonSegment<ConditionStatus>(
                          value: ConditionStatus.active,
                          label: Text('Active'),
                        ),
                        ButtonSegment<ConditionStatus>(
                          value: ConditionStatus.resolved,
                          label: Text('Resolved'),
                        ),
                      ],
                      selected: {_selectedStatus},
                      onSelectionChanged: (selected) {
                        setState(() {
                          _selectedStatus = selected.first;
                          _isDirty = true;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                _buildSectionHeader(theme, 'Photo'),
                const SizedBox(height: 16),
                // Baseline Photo
                Semantics(
                  label: 'Baseline photo for comparison, optional',
                  child: ExcludeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_baselinePhotoPath != null) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_baselinePhotoPath!),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        OutlinedButton.icon(
                          onPressed: _pickBaselinePhoto,
                          icon: const Icon(Icons.photo_camera),
                          label: Text(
                            _baselinePhotoPath != null
                                ? 'Change baseline photo'
                                : 'Add baseline photo',
                          ),
                        ),
                      ],
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
                            ? 'Save condition changes'
                            : 'Save new condition',
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

  bool _validateName() {
    final name = _nameController.text.trim();
    String? error;
    if (name.isEmpty) {
      error = 'Condition name is required';
    } else if (name.length < ValidationRules.nameMinLength) {
      error =
          'Name must be at least ${ValidationRules.nameMinLength} characters';
    } else if (name.length > ValidationRules.conditionNameMaxLength) {
      error =
          'Name must not exceed ${ValidationRules.conditionNameMaxLength} characters';
    }
    setState(() => _nameError = error);
    return error == null;
  }

  bool _validateCategory() {
    String? error;
    if (_selectedCategory == null) {
      error = 'Category is required';
    }
    setState(() => _categoryError = error);
    return error == null;
  }

  bool _validateBodyLocations() {
    String? error;
    if (_selectedBodyLocations.isEmpty) {
      error = 'At least one body location is required';
    }
    setState(() => _bodyLocationsError = error);
    return error == null;
  }

  bool _validateDescription() {
    final description = _descriptionController.text.trim();
    String? error;
    if (description.length > ValidationRules.descriptionMaxLength) {
      error =
          'Description must not exceed ${ValidationRules.descriptionMaxLength} characters';
    }
    setState(() => _descriptionError = error);
    return error == null;
  }

  bool _validateStartTimeframe() {
    String? error;
    if (_selectedStartTimeframe == null) {
      error = 'Start timeframe is required';
    }
    setState(() => _startTimeframeError = error);
    return error == null;
  }

  bool _validateAll() {
    final nameValid = _validateName();
    final categoryValid = _validateCategory();
    final bodyLocationsValid = _validateBodyLocations();
    final descriptionValid = _validateDescription();
    final startTimeframeValid = _validateStartTimeframe();
    return nameValid &&
        categoryValid &&
        bodyLocationsValid &&
        descriptionValid &&
        startTimeframeValid;
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

  int _timeframeLabelToEpoch(String label) {
    final now = DateTime.now();
    final epoch = switch (label) {
      'This week' =>
        now.subtract(const Duration(days: 7)).millisecondsSinceEpoch,
      'This month' =>
        now.subtract(const Duration(days: 30)).millisecondsSinceEpoch,
      'This year' =>
        now.subtract(const Duration(days: 365)).millisecondsSinceEpoch,
      '1-2 years' =>
        now.subtract(const Duration(days: 548)).millisecondsSinceEpoch,
      '2-5 years' =>
        now.subtract(const Duration(days: 1278)).millisecondsSinceEpoch,
      '5+ years' =>
        now.subtract(const Duration(days: 1825)).millisecondsSinceEpoch,
      'Since birth' => 0,
      'Unknown' => 0,
      _ => now.millisecondsSinceEpoch,
    };
    return epoch;
  }

  String? _epochToTimeframeLabel(int epochMs) {
    if (epochMs == 0) return 'Unknown';
    final now = DateTime.now();
    final date = DateTime.fromMillisecondsSinceEpoch(epochMs);
    final diff = now.difference(date);

    if (diff.inDays <= 7) return 'This week';
    if (diff.inDays <= 30) return 'This month';
    if (diff.inDays <= 365) return 'This year';
    if (diff.inDays <= 730) return '1-2 years';
    if (diff.inDays <= 1825) return '2-5 years';
    return '5+ years';
  }

  Future<void> _pickBaselinePhoto() async {
    try {
      final path = await showPhotoPicker(context);
      if (path != null && mounted) {
        setState(() {
          _baselinePhotoPath = path;
          _isDirty = true;
        });
      }
    } on Exception {
      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: 'Could not load photo',
        );
      }
    }
  }

  Future<void> _handleSave() async {
    if (!_validateAll()) return;

    setState(() => _isSaving = true);

    try {
      final startTimeframe = _timeframeLabelToEpoch(_selectedStartTimeframe!);

      if (_isEditing) {
        await ref
            .read(conditionListProvider(widget.profileId).notifier)
            .updateCondition(
              UpdateConditionInput(
                id: widget.condition!.id,
                profileId: widget.profileId,
                name: _nameController.text.trim(),
                category: _selectedCategory,
                bodyLocations: _selectedBodyLocations,
                description: _descriptionController.text.trim().isNotEmpty
                    ? _descriptionController.text.trim()
                    : null,
                startTimeframe: startTimeframe,
                status: _selectedStatus,
                endDate: _selectedStatus == ConditionStatus.resolved
                    ? (widget.condition!.endDate ??
                          DateTime.now().millisecondsSinceEpoch)
                    : null,
              ),
            );
      } else {
        await ref
            .read(conditionListProvider(widget.profileId).notifier)
            .create(
              CreateConditionInput(
                profileId: widget.profileId,
                clientId: const Uuid().v4(),
                name: _nameController.text.trim(),
                category: _selectedCategory!,
                bodyLocations: _selectedBodyLocations,
                description: _descriptionController.text.trim().isNotEmpty
                    ? _descriptionController.text.trim()
                    : null,
                startTimeframe: startTimeframe,
                endDate: _selectedStatus == ConditionStatus.resolved
                    ? DateTime.now().millisecondsSinceEpoch
                    : null,
                baselinePhotoPath: _baselinePhotoPath,
              ),
            );
      }

      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: _isEditing
              ? 'Condition updated successfully'
              : 'Condition created successfully',
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
