// lib/presentation/screens/photo_areas/photo_area_edit_screen.dart
// Photo area edit screen following ConditionEditScreen pattern.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/usecases/photo_areas/photo_areas_usecases.dart';
import 'package:shadow_app/presentation/providers/photo_areas/photo_area_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Screen for creating or editing a photo area.
///
/// Fields from [CreatePhotoAreaInput]:
/// - name (required)
/// - description (optional)
/// - consistencyNotes (optional)
class PhotoAreaEditScreen extends ConsumerStatefulWidget {
  final String profileId;
  final PhotoArea? photoArea;

  const PhotoAreaEditScreen({
    super.key,
    required this.profileId,
    this.photoArea,
  });

  @override
  ConsumerState<PhotoAreaEditScreen> createState() =>
      _PhotoAreaEditScreenState();
}

class _PhotoAreaEditScreenState extends ConsumerState<PhotoAreaEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _consistencyNotesController;

  bool _isDirty = false;
  bool _isSaving = false;

  String? _nameError;
  String? _descriptionError;

  bool get _isEditing => widget.photoArea != null;

  @override
  void initState() {
    super.initState();
    final area = widget.photoArea;

    _nameController = TextEditingController(text: area?.name ?? '');
    _descriptionController = TextEditingController(
      text: area?.description ?? '',
    );
    _consistencyNotesController = TextEditingController(
      text: area?.consistencyNotes ?? '',
    );

    _nameController.addListener(_markDirty);
    _descriptionController.addListener(_markDirty);
    _consistencyNotesController.addListener(_markDirty);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _consistencyNotesController.dispose();
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
          title: Text(_isEditing ? 'Edit Photo Area' : 'Add Photo Area'),
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
          label: _isEditing ? 'Edit photo area form' : 'Add photo area form',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionHeader(theme, 'Basic Information'),
                const SizedBox(height: 16),
                // Name
                Semantics(
                  label: 'Photo area name, required',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _nameController,
                      label: 'Area Name',
                      hintText: 'e.g., Left Arm, Face',
                      errorText: _nameError,
                      maxLength: ValidationRules.photoAreaNameMaxLength,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => _validateName(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Description
                Semantics(
                  label: 'Photo area description, optional',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      hintText: 'Describe this area',
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
                _buildSectionHeader(theme, 'Photo Guidance'),
                const SizedBox(height: 16),
                // Consistency Notes
                Semantics(
                  label: 'Consistency notes for photo positioning, optional',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _consistencyNotesController,
                      label: 'Consistency Notes',
                      hintText:
                          'Tips for consistent photo positioning, e.g., "Hold arm at 45 degrees"',
                      maxLength: ValidationRules.consistencyNotesMaxLength,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
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
                            ? 'Save photo area changes'
                            : 'Save new photo area',
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
      error = 'Area name is required';
    } else if (name.length < ValidationRules.nameMinLength) {
      error =
          'Name must be at least ${ValidationRules.nameMinLength} characters';
    } else if (name.length > ValidationRules.photoAreaNameMaxLength) {
      error =
          'Name must not exceed ${ValidationRules.photoAreaNameMaxLength} characters';
    }
    setState(() => _nameError = error);
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
    final descriptionValid = _validateDescription();
    return nameValid && descriptionValid;
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
            .read(photoAreaListProvider(widget.profileId).notifier)
            .updateArea(
              UpdatePhotoAreaInput(
                id: widget.photoArea!.id,
                profileId: widget.profileId,
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim().isNotEmpty
                    ? _descriptionController.text.trim()
                    : null,
                consistencyNotes:
                    _consistencyNotesController.text.trim().isNotEmpty
                    ? _consistencyNotesController.text.trim()
                    : null,
              ),
            );
      } else {
        await ref
            .read(photoAreaListProvider(widget.profileId).notifier)
            .create(
              CreatePhotoAreaInput(
                profileId: widget.profileId,
                clientId: const Uuid().v4(),
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim().isNotEmpty
                    ? _descriptionController.text.trim()
                    : null,
                consistencyNotes:
                    _consistencyNotesController.text.trim().isNotEmpty
                    ? _consistencyNotesController.text.trim()
                    : null,
              ),
            );
      }

      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: _isEditing
              ? 'Photo area updated successfully'
              : 'Photo area created successfully',
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
