// lib/presentation/screens/settings/voice_logging_settings_screen.dart
// Per VOICE_LOGGING_SPEC.md Section 10

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/entities/voice_logging/voice_logging_settings.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/providers/profile/profile_provider.dart';
import 'package:shadow_app/presentation/providers/voice_logging_providers.dart';

/// Settings screen for configuring the Voice Logging assistant.
///
/// Sections:
///   1. Closing Message (ClosingStyle + custom farewell text)
///   2. Default Input (voice vs text)
///   3. Notification Priority (reorderable category list)
///
/// Settings save automatically on change — no explicit save button.
class VoiceLoggingSettingsScreen extends ConsumerStatefulWidget {
  const VoiceLoggingSettingsScreen({super.key, this.profileId});

  /// Profile to load/save settings for. If null, reads from profileProvider.
  final String? profileId;

  @override
  ConsumerState<VoiceLoggingSettingsScreen> createState() =>
      _VoiceLoggingSettingsScreenState();
}

class _VoiceLoggingSettingsScreenState
    extends ConsumerState<VoiceLoggingSettingsScreen> {
  late VoiceLoggingSettings? _settings;
  bool _loading = true;
  String? _error;
  final TextEditingController _farewellController = TextEditingController();

  // Default category order per VOICE_LOGGING_SPEC.md Section 3.2
  static const List<_CategoryItem> _defaultOrder = [
    _CategoryItem(icon: Icons.bedtime_outlined, label: 'Sleep'),
    _CategoryItem(icon: Icons.water_drop_outlined, label: 'Fluids'),
    _CategoryItem(icon: Icons.restaurant_outlined, label: 'Food'),
    _CategoryItem(icon: Icons.medication_outlined, label: 'Medications'),
    _CategoryItem(icon: Icons.spa_outlined, label: 'Supplements'),
    _CategoryItem(icon: Icons.favorite_outline, label: 'Conditions'),
    _CategoryItem(
      icon: Icons.local_fire_department_outlined,
      label: 'Flare-ups',
    ),
    _CategoryItem(icon: Icons.book_outlined, label: 'Journal'),
    _CategoryItem(icon: Icons.directions_run_outlined, label: 'Activity'),
    _CategoryItem(icon: Icons.photo_camera_outlined, label: 'Photos'),
  ];

  final List<_CategoryItem> _priorityOrder = List.of(_defaultOrder);

  String? get _effectiveProfileId =>
      widget.profileId ?? ref.read(profileProvider).currentProfileId;

  @override
  void initState() {
    super.initState();
    _settings = null;
    _loadSettings();
  }

  @override
  void dispose() {
    _farewellController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final profileId = _effectiveProfileId;
    if (profileId == null) {
      setState(() {
        _loading = false;
        _error = 'No active profile.';
      });
      return;
    }
    final useCase = ref.read(getVoiceLoggingSettingsUseCaseProvider);
    final result = await useCase.execute(profileId);
    result.when(
      success: (settings) {
        setState(() {
          _settings = settings;
          _loading = false;
          _farewellController.text = settings.fixedFarewell ?? '';
        });
      },
      failure: (e) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      },
    );
  }

  Future<void> _save(VoiceLoggingSettings updated) async {
    setState(() => _settings = updated);
    final useCase = ref.read(saveVoiceLoggingSettingsUseCaseProvider);
    await useCase.execute(updated);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Voice Logging')),
    body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
        ? Center(child: Text('Error: $_error'))
        : _buildContent(context),
  );

  Widget _buildContent(BuildContext context) {
    final settings = _settings!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section 1: Closing Message ────────────────────────────────────
          const _SectionHeader(title: 'Closing Message'),
          RadioGroup<ClosingStyle>(
            groupValue: settings.closingStyle,
            onChanged: (v) {
              if (v != null) _save(settings.copyWith(closingStyle: v));
            },
            child: const Column(
              children: [
                _RadioRow<ClosingStyle>(
                  value: ClosingStyle.none,
                  label: 'No closing comment',
                ),
                _RadioRow<ClosingStyle>(
                  value: ClosingStyle.random,
                  label: 'Random farewell',
                ),
                _RadioRow<ClosingStyle>(
                  value: ClosingStyle.fixed,
                  label: 'Custom farewell',
                ),
              ],
            ),
          ),
          if (settings.closingStyle == ClosingStyle.fixed)
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 16, 16),
              child: TextField(
                controller: _farewellController,
                decoration: const InputDecoration(
                  labelText: 'Your farewell phrase',
                  hintText: 'e.g. Go in peace.',
                  border: OutlineInputBorder(),
                ),
                maxLength: 60,
                onChanged: (value) =>
                    _save(settings.copyWith(fixedFarewell: value)),
              ),
            ),

          const Divider(),

          // ── Section 2: Default Input ──────────────────────────────────────
          const _SectionHeader(title: 'Default input'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<DefaultInputMode>(
              segments: const [
                ButtonSegment(
                  value: DefaultInputMode.voice,
                  label: Text('Voice'),
                  icon: Icon(Icons.mic_outlined),
                ),
                ButtonSegment(
                  value: DefaultInputMode.text,
                  label: Text('Text'),
                  icon: Icon(Icons.keyboard_outlined),
                ),
              ],
              selected: {settings.defaultInputMode},
              onSelectionChanged: (selection) =>
                  _save(settings.copyWith(defaultInputMode: selection.first)),
            ),
          ),

          const Divider(),

          // ── Section 3: Notification Priority ─────────────────────────────
          const _SectionHeader(title: 'Shadow asks about items in this order.'),
          SizedBox(
            height: _defaultOrder.length * 56.0,
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = _priorityOrder.removeAt(oldIndex);
                  _priorityOrder.insert(newIndex, item);
                });
                final encoded = _priorityOrder
                    .map((item) => _defaultOrder.indexOf(item))
                    .toList();
                _save(settings.copyWith(categoryPriorityOrder: encoded));
              },
              children: [
                for (final item in _priorityOrder)
                  ListTile(
                    key: ValueKey(item.label),
                    leading: Icon(item.icon),
                    title: Text(item.label),
                    trailing: const Icon(Icons.drag_handle),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RadioRow<T> extends StatelessWidget {
  const _RadioRow({required this.value, required this.label});
  final T value;
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Row(
      children: [
        Radio<T>(value: value),
        Text(label),
      ],
    ),
  );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

class _CategoryItem {
  const _CategoryItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
