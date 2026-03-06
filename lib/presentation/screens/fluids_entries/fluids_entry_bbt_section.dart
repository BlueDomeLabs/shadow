// lib/presentation/screens/fluids_entries/fluids_entry_bbt_section.dart

import 'package:flutter/material.dart';
import 'package:shadow_app/core/utils/date_formatters.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// BBT (Basal Body Temperature) section extracted from FluidsEntryScreen.
///
/// Stateless — all state is owned by the parent. Each user action fires a
/// callback; the parent calls setState and rebuilds.
class FluidsEntryBBTSection extends StatelessWidget {
  final TextEditingController bbtController;
  final bool useMetric;
  final DateTime recordedTime;
  final String? bbtError;
  final ValueChanged<bool> onUnitChanged;
  final void Function(DateTime) onRecordedTimeChanged;
  final VoidCallback onBBTChanged;

  const FluidsEntryBBTSection({
    super.key,
    required this.bbtController,
    required this.useMetric,
    required this.recordedTime,
    required this.bbtError,
    required this.onUnitChanged,
    required this.onRecordedTimeChanged,
    required this.onBBTChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Temperature + unit row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Semantics(
                label: 'Basal body temperature, required, degrees',
                textField: true,
                child: ExcludeSemantics(
                  child: ShadowTextField.numeric(
                    controller: bbtController,
                    label: 'Temperature',
                    hintText: 'e.g., 98.6',
                    errorText: bbtError,
                    maxLength: 6,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => onBBTChanged(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: DropdownButtonFormField<bool>(
                  initialValue: useMetric,
                  decoration: const InputDecoration(labelText: 'Unit'),
                  items: const [
                    DropdownMenuItem(value: false, child: Text('\u00B0F')),
                    DropdownMenuItem(value: true, child: Text('\u00B0C')),
                  ],
                  onChanged: (value) {
                    if (value != null) onUnitChanged(value);
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Time picker
        Semantics(
          label: 'Temperature recorded time',
          child: ExcludeSemantics(
            child: InkWell(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(recordedTime),
                );
                if (time != null) {
                  onRecordedTimeChanged(
                    DateTime(
                      recordedTime.year,
                      recordedTime.month,
                      recordedTime.day,
                      time.hour,
                      time.minute,
                    ),
                  );
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Time Recorded',
                  hintText: 'Time measured',
                  suffixIcon: Icon(Icons.access_time),
                ),
                child: Text(
                  DateFormatters.time12h(TimeOfDay.fromDateTime(recordedTime)),
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
