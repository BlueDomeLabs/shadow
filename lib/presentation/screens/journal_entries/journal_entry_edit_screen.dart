// lib/presentation/screens/journal_entries/journal_entry_edit_screen.dart
// Journal entry edit screen following ConditionEditScreen pattern.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/usecases/journal_entries/journal_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/journal_entries/journal_entry_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Screen for creating or editing a journal entry.
///
/// Fields from [CreateJournalEntryInput]:
/// - title (optional)
/// - content (required, multiline)
/// - mood (1-10 slider, optional)
/// - tags (chip input, optional)
/// - timestamp (date/time picker)
/// - audioUrl skipped (requires native plugin config)
class JournalEntryEditScreen extends ConsumerStatefulWidget {
  final String profileId;
  final JournalEntry? entry;

  const JournalEntryEditScreen({
    super.key,
    required this.profileId,
    this.entry,
  });

  @override
  ConsumerState<JournalEntryEditScreen> createState() =>
      _JournalEntryEditScreenState();
}

class _JournalEntryEditScreenState
    extends ConsumerState<JournalEntryEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _tagController;

  late DateTime _selectedDateTime;
  double? _selectedMood;
  late List<String> _tags;

  bool _isDirty = false;
  bool _isSaving = false;

  String? _contentError;

  bool get _isEditing => widget.entry != null;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;

    _titleController = TextEditingController(text: entry?.title ?? '');
    _contentController = TextEditingController(text: entry?.content ?? '');
    _tagController = TextEditingController();

    _selectedDateTime = entry != null
        ? DateTime.fromMillisecondsSinceEpoch(entry.timestamp)
        : DateTime.now();

    _selectedMood = entry?.mood?.toDouble();
    _tags = entry?.tags?.toList() ?? [];

    _titleController.addListener(_markDirty);
    _contentController.addListener(_markDirty);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
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
          title: Text(_isEditing ? 'Edit Entry' : 'New Entry'),
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
              ? 'Edit journal entry form'
              : 'New journal entry form',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Date & Time
                _buildSectionHeader(theme, 'Date & Time'),
                const SizedBox(height: 16),
                _buildDateTimePicker(theme),
                const SizedBox(height: 24),
                // Title
                Semantics(
                  label: 'Entry title, optional',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _titleController,
                      label: 'Title',
                      hintText: 'Optional title for this entry',
                      maxLength: ValidationRules.titleMaxLength,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Content
                Semantics(
                  label: 'Entry content, required',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _contentController,
                      label: 'Content',
                      hintText: 'Write your thoughts...',
                      errorText: _contentError,
                      maxLength: ValidationRules.journalContentMaxLength,
                      maxLines: 8,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onChanged: (_) => _validateContent(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Mood
                _buildSectionHeader(theme, 'Mood'),
                const SizedBox(height: 16),
                _buildMoodSlider(theme),
                const SizedBox(height: 24),
                // Tags
                _buildSectionHeader(theme, 'Tags'),
                const SizedBox(height: 16),
                _buildTagsSection(theme),
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
                            ? 'Save journal entry changes'
                            : 'Save new journal entry',
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
      label: 'Entry date and time',
      child: ExcludeSemantics(
        child: Row(
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
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
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
      });
    }
  }

  Widget _buildMoodSlider(ThemeData theme) {
    final moodLabel = _selectedMood != null
        ? '${_selectedMood!.round()}/10'
        : 'Not set';

    return Semantics(
      label: 'Mood rating, optional, $moodLabel',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mood: $moodLabel', style: theme.textTheme.bodyMedium),
                if (_selectedMood != null)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedMood = null;
                        _isDirty = true;
                      });
                    },
                    child: const Text('Clear'),
                  ),
              ],
            ),
            Slider(
              value: _selectedMood ?? 5,
              min: 1,
              max: 10,
              divisions: 9,
              label: _selectedMood?.round().toString() ?? '5',
              onChanged: (value) {
                setState(() {
                  _selectedMood = value;
                  _isDirty = true;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsSection(ThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Semantics(
              label: 'Tag name',
              textField: true,
              child: ExcludeSemantics(
                child: ShadowTextField(
                  controller: _tagController,
                  label: 'Add Tag',
                  hintText: 'e.g., gratitude',
                  maxLength: ValidationRules.tagMaxLength,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addTag(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ShadowButton.icon(
            icon: Icons.add,
            label: 'Add tag',
            onPressed: _addTag,
          ),
        ],
      ),
      if (_tags.isNotEmpty) ...[
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _tags.asMap().entries.map((entry) {
            final index = entry.key;
            final tag = entry.value;
            return Chip(
              label: Text(tag),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () => _removeTag(index),
            );
          }).toList(),
        ),
      ],
    ],
  );

  void _addTag() {
    final text = _tagController.text.trim();
    if (text.isEmpty || text.length < ValidationRules.nameMinLength) return;

    setState(() {
      _tags.add(text);
      _tagController.clear();
      _isDirty = true;
    });
  }

  void _removeTag(int index) {
    setState(() {
      _tags.removeAt(index);
      _isDirty = true;
    });
  }

  bool _validateContent() {
    final content = _contentController.text.trim();
    String? error;
    if (content.isEmpty) {
      error = 'Content is required';
    } else if (content.length < ValidationRules.journalContentMinLength) {
      error =
          'Content must be at least ${ValidationRules.journalContentMinLength} characters';
    } else if (content.length > ValidationRules.journalContentMaxLength) {
      error =
          'Content must not exceed ${ValidationRules.journalContentMaxLength} characters';
    }
    setState(() => _contentError = error);
    return error == null;
  }

  bool _validateAll() => _validateContent();

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
        await ref
            .read(journalEntryListProvider(widget.profileId).notifier)
            .updateEntry(
              UpdateJournalEntryInput(
                id: widget.entry!.id,
                profileId: widget.profileId,
                title: _titleController.text.trim().isNotEmpty
                    ? _titleController.text.trim()
                    : null,
                content: _contentController.text.trim(),
                mood: _selectedMood?.round(),
                tags: _tags.isNotEmpty ? _tags : null,
              ),
            );
      } else {
        await ref
            .read(journalEntryListProvider(widget.profileId).notifier)
            .create(
              CreateJournalEntryInput(
                profileId: widget.profileId,
                clientId: const Uuid().v4(),
                timestamp: timestamp,
                content: _contentController.text.trim(),
                title: _titleController.text.trim().isNotEmpty
                    ? _titleController.text.trim()
                    : null,
                mood: _selectedMood?.round(),
                tags: _tags,
              ),
            );
      }

      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: _isEditing
              ? 'Journal entry updated successfully'
              : 'Journal entry created successfully',
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
