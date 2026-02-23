// lib/presentation/screens/settings/units_settings_screen.dart
// Per 58_SETTINGS_SCREENS.md Screen 2: Units Settings

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/entities/user_settings.dart';
import 'package:shadow_app/domain/enums/settings_enums.dart';
import 'package:shadow_app/presentation/providers/settings/user_settings_provider.dart';

/// Screen for configuring display units across the app.
///
/// Changes apply globally — all data is stored in canonical units and
/// converted at display time per 58_SETTINGS_SCREENS.md.
class UnitsSettingsScreen extends ConsumerWidget {
  const UnitsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(userSettingsNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Units')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (settings) => _buildContent(context, ref, settings),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    UserSettings settings,
  ) {
    void update(UserSettings updated) {
      ref.read(userSettingsNotifierProvider.notifier).save(updated);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader('Weight'),
          _UnitToggle<WeightUnit>(
            label: 'Body weight',
            values: WeightUnit.values,
            current: settings.weightUnit,
            labelFor: (v) => v.symbol,
            onChanged: (v) => update(settings.copyWith(weightUnit: v)),
          ),
          _UnitToggle<FoodWeightUnit>(
            label: 'Food weight',
            values: FoodWeightUnit.values,
            current: settings.foodWeightUnit,
            labelFor: (v) => v.symbol,
            onChanged: (v) => update(settings.copyWith(foodWeightUnit: v)),
          ),
          const Divider(),
          const _SectionHeader('Volume'),
          _UnitToggle<FluidUnit>(
            label: 'Fluids',
            values: FluidUnit.values,
            current: settings.fluidUnit,
            labelFor: (v) => v.symbol,
            onChanged: (v) => update(settings.copyWith(fluidUnit: v)),
          ),
          const Divider(),
          const _SectionHeader('Temperature'),
          _UnitToggle<TemperatureUnit>(
            label: 'Body temperature',
            values: TemperatureUnit.values,
            current: settings.temperatureUnit,
            labelFor: (v) => v.symbol,
            onChanged: (v) => update(settings.copyWith(temperatureUnit: v)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'For accurate BBT tracking, always use the same unit consistently.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          const Divider(),
          const _SectionHeader('Nutritional Values'),
          _UnitToggle<EnergyUnit>(
            label: 'Energy',
            values: EnergyUnit.values,
            current: settings.energyUnit,
            labelFor: (v) => v.symbol,
            onChanged: (v) => update(settings.copyWith(energyUnit: v)),
          ),
          _UnitToggle<MacroDisplay>(
            label: 'Macro display',
            values: MacroDisplay.values,
            current: settings.macroDisplay,
            labelFor: (v) => v.symbol,
            onChanged: (v) => update(settings.copyWith(macroDisplay: v)),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 0.5,
      ),
    ),
  );
}

class _UnitToggle<T extends Enum> extends StatelessWidget {
  final String label;
  final List<T> values;
  final T current;
  final String Function(T) labelFor;
  final ValueChanged<T> onChanged;

  const _UnitToggle({
    required this.label,
    required this.values,
    required this.current,
    required this.labelFor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 15)),
        SegmentedButton<T>(
          segments: values
              .map((v) => ButtonSegment<T>(value: v, label: Text(labelFor(v))))
              .toList(),
          selected: {current},
          onSelectionChanged: (s) => onChanged(s.first),
          style: const ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    ),
  );
}
