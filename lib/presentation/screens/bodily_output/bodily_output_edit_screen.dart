// lib/presentation/screens/bodily_output/bodily_output_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/entities/bodily_output_enums.dart';
import 'package:shadow_app/domain/entities/bodily_output_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/presentation/providers/bodily_output_providers.dart';

/// Screen for logging a new bodily output event or editing an existing one.
class BodilyOutputEditScreen extends ConsumerStatefulWidget {
  final String profileId;
  final BodilyOutputLog? existingLog;

  const BodilyOutputEditScreen({
    super.key,
    required this.profileId,
    required this.existingLog,
  });

  @override
  ConsumerState<BodilyOutputEditScreen> createState() =>
      _BodilyOutputEditScreenState();
}

class _BodilyOutputEditScreenState
    extends ConsumerState<BodilyOutputEditScreen> {
  late BodyOutputType _outputType;
  late DateTime _occurredAt;
  final _notesController = TextEditingController();
  final _customLabelController = TextEditingController();
  final _customUrineConditionController = TextEditingController();
  final _customBowelConditionController = TextEditingController();
  final _tempController = TextEditingController();

  GasSeverity? _gasSeverity;
  UrineCondition? _urineCondition;
  BowelCondition? _bowelCondition;
  MenstruationFlow? _menstruationFlow;
  double? _temperatureValue;

  bool _isSaving = false;
  String? _errorMessage;

  bool get _isEditing => widget.existingLog != null;

  @override
  void initState() {
    super.initState();
    final log = widget.existingLog;
    if (log != null) {
      _outputType = log.outputType;
      _occurredAt = DateTime.fromMillisecondsSinceEpoch(log.occurredAt);
      _notesController.text = log.notes ?? '';
      _customLabelController.text = log.customTypeLabel ?? '';
      _gasSeverity = log.gasSeverity;
      _urineCondition = log.urineCondition;
      _bowelCondition = log.bowelCondition;
      _menstruationFlow = log.menstruationFlow;
      _temperatureValue = log.temperatureValue;
      _tempController.text = log.temperatureValue?.toString() ?? '';
      _customUrineConditionController.text = log.urineCustomCondition ?? '';
      _customBowelConditionController.text = log.bowelCustomCondition ?? '';
    } else {
      _outputType = BodyOutputType.urine;
      _occurredAt = DateTime.now();
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _customLabelController.dispose();
    _customUrineConditionController.dispose();
    _customBowelConditionController.dispose();
    _tempController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(_isEditing ? 'Edit Event' : 'Log Event'),
      actions: [
        if (_isSaving)
          const Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else
          TextButton(onPressed: _save, child: const Text('Save')),
      ],
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_errorMessage != null) ...[
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          _buildTypeSelector(),
          const SizedBox(height: 24),
          _buildDateTimePicker(context),
          const SizedBox(height: 24),
          _buildTypeSpecificFields(),
          const SizedBox(height: 24),
          _buildNotesField(),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: _isSaving ? null : _save,
                  child: const Text('Save'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSaving ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildTypeSelector() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Event type', style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: BodyOutputType.values
            .map(
              (type) => ChoiceChip(
                label: Text(_typeLabel(type)),
                selected: _outputType == type,
                onSelected: (_) => setState(() {
                  _outputType = type;
                  _errorMessage = null;
                }),
              ),
            )
            .toList(),
      ),
    ],
  );

  Widget _buildDateTimePicker(BuildContext context) {
    final formatted =
        '${_occurredAt.year}-${_occurredAt.month.toString().padLeft(2, '0')}-'
        '${_occurredAt.day.toString().padLeft(2, '0')} '
        '${_occurredAt.hour.toString().padLeft(2, '0')}:'
        '${_occurredAt.minute.toString().padLeft(2, '0')}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date & time', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _pickDateTime(context),
          icon: const Icon(Icons.schedule),
          label: Text(formatted),
        ),
      ],
    );
  }

  Widget _buildTypeSpecificFields() => switch (_outputType) {
    BodyOutputType.gas => _buildGasFields(),
    BodyOutputType.urine => _buildUrineFields(),
    BodyOutputType.bowel => _buildBowelFields(),
    BodyOutputType.menstruation => _buildMenstruationFields(),
    BodyOutputType.bbt => _buildBbtFields(),
    BodyOutputType.custom => _buildCustomFields(),
  };

  Widget _buildGasFields() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Severity', style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        children: GasSeverity.values
            .map(
              (s) => ChoiceChip(
                label: Text(_gasSeverityLabel(s)),
                selected: _gasSeverity == s,
                onSelected: (_) => setState(() => _gasSeverity = s),
              ),
            )
            .toList(),
      ),
    ],
  );

  Widget _buildUrineFields() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Color / condition', style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: UrineCondition.values
            .map(
              (c) => ChoiceChip(
                label: Text(_urineConditionLabel(c)),
                selected: _urineCondition == c,
                onSelected: (_) => setState(() => _urineCondition = c),
              ),
            )
            .toList(),
      ),
      if (_urineCondition == UrineCondition.custom) ...[
        const SizedBox(height: 12),
        TextField(
          controller: _customUrineConditionController,
          decoration: const InputDecoration(
            labelText: 'Describe condition',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    ],
  );

  Widget _buildBowelFields() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Consistency', style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: BowelCondition.values
            .map(
              (c) => ChoiceChip(
                label: Text(_bowelConditionLabel(c)),
                selected: _bowelCondition == c,
                onSelected: (_) => setState(() => _bowelCondition = c),
              ),
            )
            .toList(),
      ),
      if (_bowelCondition == BowelCondition.custom) ...[
        const SizedBox(height: 12),
        TextField(
          controller: _customBowelConditionController,
          decoration: const InputDecoration(
            labelText: 'Describe consistency',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    ],
  );

  Widget _buildMenstruationFields() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Flow', style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        children: MenstruationFlow.values
            .map(
              (f) => ChoiceChip(
                label: Text(_flowLabel(f)),
                selected: _menstruationFlow == f,
                onSelected: (_) => setState(() => _menstruationFlow = f),
              ),
            )
            .toList(),
      ),
    ],
  );

  Widget _buildBbtFields() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Temperature', style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 8),
      TextField(
        controller: _tempController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(
          labelText: 'Temperature value',
          hintText: 'e.g. 36.5',
          border: OutlineInputBorder(),
        ),
        onChanged: (v) => _temperatureValue = double.tryParse(v),
      ),
    ],
  );

  Widget _buildCustomFields() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Custom label', style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 8),
      TextField(
        controller: _customLabelController,
        maxLength: 60,
        decoration: const InputDecoration(
          labelText: 'Label (required)',
          border: OutlineInputBorder(),
        ),
      ),
    ],
  );

  Widget _buildNotesField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Notes', style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 8),
      TextField(
        controller: _notesController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Optional notes',
          border: OutlineInputBorder(),
        ),
      ),
    ],
  );

  Future<void> _pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _occurredAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context, // ignore: use_build_context_synchronously
      initialTime: TimeOfDay.fromDateTime(_occurredAt),
    );
    if (time == null || !mounted) return;
    setState(() {
      _occurredAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final now = DateTime.now().millisecondsSinceEpoch;
    final log = BodilyOutputLog(
      id: widget.existingLog?.id ?? '',
      clientId: widget.existingLog?.clientId ?? '',
      profileId: widget.profileId,
      occurredAt: _occurredAt.millisecondsSinceEpoch,
      outputType: _outputType,
      customTypeLabel: _outputType == BodyOutputType.custom
          ? _customLabelController.text.trim()
          : null,
      gasSeverity: _outputType == BodyOutputType.gas ? _gasSeverity : null,
      urineCondition: _outputType == BodyOutputType.urine
          ? _urineCondition
          : null,
      urineCustomCondition: _urineCondition == UrineCondition.custom
          ? _customUrineConditionController.text.trim()
          : null,
      bowelCondition: _outputType == BodyOutputType.bowel
          ? _bowelCondition
          : null,
      bowelCustomCondition: _bowelCondition == BowelCondition.custom
          ? _customBowelConditionController.text.trim()
          : null,
      menstruationFlow: _outputType == BodyOutputType.menstruation
          ? _menstruationFlow
          : null,
      temperatureValue: _outputType == BodyOutputType.bbt
          ? _temperatureValue
          : null,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      syncMetadata:
          widget.existingLog?.syncMetadata ??
          SyncMetadata(
            syncCreatedAt: now,
            syncUpdatedAt: now,
            syncDeviceId: '',
          ),
    );

    final nav = Navigator.of(context);
    final result = _isEditing
        ? await ref.read(updateBodilyOutputUseCaseProvider)(log)
        : await ref.read(logBodilyOutputUseCaseProvider)(log);

    if (!mounted) return;

    result.when(
      success: (_) => nav.pop(),
      failure: (e) => setState(() {
        _isSaving = false;
        _errorMessage = e.toString();
      }),
    );
  }

  String _typeLabel(BodyOutputType type) => switch (type) {
    BodyOutputType.urine => 'Urine',
    BodyOutputType.bowel => 'Bowel',
    BodyOutputType.gas => 'Gas',
    BodyOutputType.menstruation => 'Menstruation',
    BodyOutputType.bbt => 'BBT',
    BodyOutputType.custom => 'Custom',
  };

  String _gasSeverityLabel(GasSeverity s) => switch (s) {
    GasSeverity.mild => 'Mild',
    GasSeverity.moderate => 'Moderate',
    GasSeverity.severe => 'Severe',
  };

  String _urineConditionLabel(UrineCondition c) => switch (c) {
    UrineCondition.clear => 'Clear',
    UrineCondition.lightYellow => 'Light yellow',
    UrineCondition.yellow => 'Yellow',
    UrineCondition.darkYellow => 'Dark yellow',
    UrineCondition.amber => 'Amber',
    UrineCondition.brown => 'Brown',
    UrineCondition.red => 'Red',
    UrineCondition.custom => 'Custom',
  };

  String _bowelConditionLabel(BowelCondition c) => switch (c) {
    BowelCondition.diarrhea => 'Diarrhea',
    BowelCondition.runny => 'Runny',
    BowelCondition.loose => 'Loose',
    BowelCondition.normal => 'Normal',
    BowelCondition.firm => 'Firm',
    BowelCondition.hard => 'Hard',
    BowelCondition.custom => 'Custom',
  };

  String _flowLabel(MenstruationFlow f) => switch (f) {
    MenstruationFlow.spotting => 'Spotting',
    MenstruationFlow.light => 'Light',
    MenstruationFlow.medium => 'Medium',
    MenstruationFlow.heavy => 'Heavy',
  };
}
