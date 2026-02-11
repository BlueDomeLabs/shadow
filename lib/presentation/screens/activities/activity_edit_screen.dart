// lib/presentation/screens/activities/activity_edit_screen.dart
// Activity edit screen following ConditionEditScreen pattern.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/usecases/activities/activities_usecases.dart';
import 'package:shadow_app/presentation/providers/activities/activity_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Screen for creating or editing an activity.
///
/// Fields from [CreateActivityInput]:
/// - name (required)
/// - description (optional)
/// - location (optional)
/// - triggers (optional)
/// - durationMinutes (required)
class ActivityEditScreen extends ConsumerStatefulWidget {
  final String profileId;
  final Activity? activity;

  const ActivityEditScreen({super.key, required this.profileId, this.activity});

  @override
  ConsumerState<ActivityEditScreen> createState() => _ActivityEditScreenState();
}

class _ActivityEditScreenState extends ConsumerState<ActivityEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _triggersController;
  late final TextEditingController _durationController;

  bool _isDirty = false;
  bool _isSaving = false;

  String? _nameError;
  String? _descriptionError;
  String? _durationError;

  bool get _isEditing => widget.activity != null;

  @override
  void initState() {
    super.initState();
    final activity = widget.activity;

    _nameController = TextEditingController(text: activity?.name ?? '');
    _descriptionController = TextEditingController(
      text: activity?.description ?? '',
    );
    _locationController = TextEditingController(text: activity?.location ?? '');
    _triggersController = TextEditingController(text: activity?.triggers ?? '');
    _durationController = TextEditingController(
      text: activity != null ? activity.durationMinutes.toString() : '',
    );

    _nameController.addListener(_markDirty);
    _descriptionController.addListener(_markDirty);
    _locationController.addListener(_markDirty);
    _triggersController.addListener(_markDirty);
    _durationController.addListener(_markDirty);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _triggersController.dispose();
    _durationController.dispose();
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
          title: Text(_isEditing ? 'Edit Activity' : 'Add Activity'),
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
          label: _isEditing ? 'Edit activity form' : 'Add activity form',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionHeader(theme, 'Basic Information'),
                const SizedBox(height: 16),
                // Activity Name
                Semantics(
                  label: 'Activity name, required',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _nameController,
                      label: 'Activity Name',
                      hintText: 'e.g., Morning Run',
                      errorText: _nameError,
                      maxLength: ValidationRules.activityNameMaxLength,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => _validateName(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Duration
                Semantics(
                  label: 'Duration in minutes, required',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _durationController,
                      label: 'Duration (minutes)',
                      hintText: 'e.g., 30',
                      errorText: _durationError,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => _validateDuration(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Description
                Semantics(
                  label: 'Activity description, optional',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      hintText: 'Describe this activity',
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
                _buildSectionHeader(theme, 'Details'),
                const SizedBox(height: 16),
                // Location
                Semantics(
                  label: 'Activity location, optional',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _locationController,
                      label: 'Location',
                      hintText: 'e.g., Gym, Park',
                      maxLength: ValidationRules.locationMaxLength,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Triggers
                Semantics(
                  label: 'Activity triggers, optional',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _triggersController,
                      label: 'Triggers',
                      hintText: 'e.g., stress, weather',
                      maxLength: ValidationRules.activityTriggersMaxLength,
                      textInputAction: TextInputAction.done,
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
                            ? 'Save activity changes'
                            : 'Save new activity',
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
      error = 'Activity name is required';
    } else if (name.length < ValidationRules.nameMinLength) {
      error =
          'Name must be at least ${ValidationRules.nameMinLength} characters';
    } else if (name.length > ValidationRules.activityNameMaxLength) {
      error =
          'Name must not exceed ${ValidationRules.activityNameMaxLength} characters';
    }
    setState(() => _nameError = error);
    return error == null;
  }

  bool _validateDuration() {
    final text = _durationController.text.trim();
    String? error;
    if (text.isEmpty) {
      error = 'Duration is required';
    } else {
      final value = int.tryParse(text);
      if (value == null) {
        error = 'Duration must be a number';
      } else if (value <= 0) {
        error = 'Duration must be greater than 0';
      } else if (value > ValidationRules.activityDurationMaxMinutes) {
        error =
            'Duration must not exceed ${ValidationRules.activityDurationMaxMinutes} minutes';
      }
    }
    setState(() => _durationError = error);
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

  bool _validateAll() {
    final nameValid = _validateName();
    final durationValid = _validateDuration();
    final descriptionValid = _validateDescription();
    return nameValid && durationValid && descriptionValid;
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
      if (_isEditing) {
        await ref
            .read(activityListProvider(widget.profileId).notifier)
            .updateActivity(
              UpdateActivityInput(
                id: widget.activity!.id,
                profileId: widget.profileId,
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim().isNotEmpty
                    ? _descriptionController.text.trim()
                    : null,
                location: _locationController.text.trim().isNotEmpty
                    ? _locationController.text.trim()
                    : null,
                triggers: _triggersController.text.trim().isNotEmpty
                    ? _triggersController.text.trim()
                    : null,
                durationMinutes: int.parse(_durationController.text.trim()),
              ),
            );
      } else {
        await ref
            .read(activityListProvider(widget.profileId).notifier)
            .create(
              CreateActivityInput(
                profileId: widget.profileId,
                clientId: const Uuid().v4(),
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim().isNotEmpty
                    ? _descriptionController.text.trim()
                    : null,
                location: _locationController.text.trim().isNotEmpty
                    ? _locationController.text.trim()
                    : null,
                triggers: _triggersController.text.trim().isNotEmpty
                    ? _triggersController.text.trim()
                    : null,
                durationMinutes: int.parse(_durationController.text.trim()),
              ),
            );
      }

      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: _isEditing
              ? 'Activity updated successfully'
              : 'Activity created successfully',
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
