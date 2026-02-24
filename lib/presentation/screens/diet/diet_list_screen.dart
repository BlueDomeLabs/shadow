// lib/presentation/screens/diet/diet_list_screen.dart
// Diet selection and management screen — Phase 15b-3
// Per 38_UI_FIELD_SPECIFICATIONS.md Section 17 + 59_DIET_TRACKING.md

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/diet/diets_usecases.dart';
import 'package:shadow_app/presentation/providers/diet/diet_list_provider.dart';
import 'package:shadow_app/presentation/screens/diet/diet_edit_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Screen showing available diets and allowing the user to select one.
///
/// Per 59_DIET_TRACKING.md Screen 1: Diet Selection.
/// Shows the currently active diet, preset options, and custom diets.
/// User can tap a diet to activate it or create a new custom diet.
class DietListScreen extends ConsumerWidget {
  final String profileId;

  const DietListScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dietListAsync = ref.watch(dietListProvider(profileId));

    return Scaffold(
      appBar: AppBar(title: const Text('Diet')),
      body: Semantics(
        label: 'Diet selection list',
        child: dietListAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => EmptyStateWidget(
            icon: Icons.error_outline,
            message: 'Could not load diets',
            submessage: error is AppError
                ? error.userMessage
                : error.toString(),
            action: ShadowButton.outlined(
              onPressed: () => ref.invalidate(dietListProvider(profileId)),
              label: 'Retry loading diets',
              child: const Text('Retry'),
            ),
          ),
          data: (diets) {
            final activeDiet = diets.where((d) => d.isActive).firstOrNull;
            final customDiets = diets
                .where((d) => !d.isActive && !d.isPreset)
                .toList();

            return RefreshIndicator(
              onRefresh: () async =>
                  ref.invalidate(dietListProvider(profileId)),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Current active diet
                  const _SectionHeader(title: 'Current Diet'),
                  const SizedBox(height: 8),
                  if (activeDiet != null)
                    ShadowCard.listItem(
                      child: ListTile(
                        leading: const Icon(Icons.check_circle),
                        title: Text(activeDiet.name),
                        subtitle: Text(
                          activeDiet.isPreset
                              ? _presetLabel(activeDiet.presetType!)
                              : 'Custom diet',
                        ),
                        trailing: const Chip(label: Text('Active')),
                      ),
                    )
                  else
                    const ShadowCard.listItem(
                      child: ListTile(
                        leading: Icon(Icons.no_meals),
                        title: Text('No Diet Selected'),
                        subtitle: Text(
                          'Choose a diet below to start tracking compliance',
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Preset diets
                  const _SectionHeader(title: 'Preset Diets'),
                  const SizedBox(height: 8),
                  ..._presetOptions
                      .where((p) => activeDiet?.presetType != p)
                      .map(
                        (presetType) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _PresetDietCard(
                            presetType: presetType,
                            profileId: profileId,
                          ),
                        ),
                      ),

                  // Custom diets
                  if (customDiets.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const _SectionHeader(title: 'My Custom Diets'),
                    const SizedBox(height: 8),
                    ...customDiets.map(
                      (diet) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ShadowCard.listItem(
                          child: ListTile(
                            leading: const Icon(Icons.tune),
                            title: Text(diet.name),
                            subtitle: diet.description.isNotEmpty
                                ? Text(diet.description)
                                : null,
                            trailing: PopupMenuButton<String>(
                              tooltip: 'Diet options',
                              itemBuilder: (_) => [
                                const PopupMenuItem(
                                  value: 'activate',
                                  child: Text('Activate'),
                                ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                              ],
                              onSelected: (action) {
                                if (action == 'activate') {
                                  _activateDiet(context, ref, diet.id);
                                } else if (action == 'edit') {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => DietEditScreen(
                                        profileId: profileId,
                                        existingDiet: diet,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 80), // FAB clearance
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => DietEditScreen(profileId: profileId),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Custom Diet'),
        tooltip: 'Create custom diet',
      ),
    );
  }

  Future<void> _activateDiet(
    BuildContext context,
    WidgetRef ref,
    String dietId,
  ) async {
    try {
      await ref
          .read(dietListProvider(profileId).notifier)
          .activate(ActivateDietInput(profileId: profileId, dietId: dietId));

      if (context.mounted) {
        showAccessibleSnackBar(context: context, message: 'Diet activated');
      }
    } on AppError catch (e) {
      if (context.mounted) {
        showAccessibleSnackBar(context: context, message: e.userMessage);
      }
    } on Exception {
      if (context.mounted) {
        showAccessibleSnackBar(
          context: context,
          message: 'Could not activate diet',
        );
      }
    }
  }

  /// Human-readable label for a preset diet type.
  String _presetLabel(DietPresetType type) {
    switch (type) {
      case DietPresetType.vegan:
        return 'Vegan';
      case DietPresetType.vegetarian:
        return 'Vegetarian';
      case DietPresetType.pescatarian:
        return 'Pescatarian';
      case DietPresetType.paleo:
        return 'Paleo';
      case DietPresetType.keto:
        return 'Keto';
      case DietPresetType.ketoStrict:
        return 'Strict Keto';
      case DietPresetType.lowCarb:
        return 'Low Carb';
      case DietPresetType.mediterranean:
        return 'Mediterranean';
      case DietPresetType.whole30:
        return 'Whole30';
      case DietPresetType.aip:
        return 'Autoimmune Protocol (AIP)';
      case DietPresetType.lowFodmap:
        return 'Low FODMAP';
      case DietPresetType.glutenFree:
        return 'Gluten-Free';
      case DietPresetType.dairyFree:
        return 'Dairy-Free';
      case DietPresetType.if168:
        return '16:8 Intermittent Fasting';
      case DietPresetType.if186:
        return '18:6 Intermittent Fasting';
      case DietPresetType.if204:
        return '20:4 Intermittent Fasting';
      case DietPresetType.omad:
        return 'One Meal A Day (OMAD)';
      case DietPresetType.fiveTwoDiet:
        return '5:2 Fasting';
      case DietPresetType.zone:
        return 'Zone Diet';
      case DietPresetType.custom:
        return 'Custom';
    }
  }

  static const List<DietPresetType> _presetOptions = [
    DietPresetType.keto,
    DietPresetType.paleo,
    DietPresetType.mediterranean,
    DietPresetType.vegan,
    DietPresetType.vegetarian,
    DietPresetType.glutenFree,
    DietPresetType.dairyFree,
    DietPresetType.if168,
    DietPresetType.if186,
    DietPresetType.if204,
    DietPresetType.omad,
    DietPresetType.lowCarb,
    DietPresetType.whole30,
    DietPresetType.pescatarian,
    DietPresetType.ketoStrict,
    DietPresetType.aip,
    DietPresetType.lowFodmap,
    DietPresetType.fiveTwoDiet,
    DietPresetType.zone,
  ];
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    ),
  );
}

/// Tappable card for a preset diet option.
class _PresetDietCard extends ConsumerWidget {
  final DietPresetType presetType;
  final String profileId;

  const _PresetDietCard({required this.presetType, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ShadowCard.listItem(
    child: ListTile(
      leading: Icon(_presetIcon(presetType)),
      title: Text(_presetName(presetType)),
      subtitle: Text(_presetDescription(presetType)),
      trailing: ShadowButton.outlined(
        onPressed: () => _activatePreset(context, ref),
        label: 'Activate ${_presetName(presetType)}',
        child: const Text('Use'),
      ),
    ),
  );

  Future<void> _activatePreset(BuildContext context, WidgetRef ref) async {
    try {
      // Create the preset diet then activate it
      await ref
          .read(dietListProvider(profileId).notifier)
          .create(
            CreateDietInput(
              profileId: profileId,
              clientId: const Uuid().v4(),
              name: _presetName(presetType),
              description: _presetDescription(presetType),
              presetType: presetType,
              activateImmediately: true,
              startDateEpoch: DateTime.now().millisecondsSinceEpoch,
            ),
          );

      if (context.mounted) {
        showAccessibleSnackBar(
          context: context,
          message: '${_presetName(presetType)} activated',
        );
      }
    } on AppError catch (e) {
      if (context.mounted) {
        showAccessibleSnackBar(context: context, message: e.userMessage);
      }
    } on Exception {
      if (context.mounted) {
        showAccessibleSnackBar(
          context: context,
          message: 'Could not activate diet',
        );
      }
    }
  }

  String _presetName(DietPresetType type) {
    switch (type) {
      case DietPresetType.vegan:
        return 'Vegan';
      case DietPresetType.vegetarian:
        return 'Vegetarian';
      case DietPresetType.pescatarian:
        return 'Pescatarian';
      case DietPresetType.paleo:
        return 'Paleo';
      case DietPresetType.keto:
        return 'Keto';
      case DietPresetType.ketoStrict:
        return 'Strict Keto';
      case DietPresetType.lowCarb:
        return 'Low Carb';
      case DietPresetType.mediterranean:
        return 'Mediterranean';
      case DietPresetType.whole30:
        return 'Whole30';
      case DietPresetType.aip:
        return 'AIP';
      case DietPresetType.lowFodmap:
        return 'Low FODMAP';
      case DietPresetType.glutenFree:
        return 'Gluten-Free';
      case DietPresetType.dairyFree:
        return 'Dairy-Free';
      case DietPresetType.if168:
        return '16:8 Fasting';
      case DietPresetType.if186:
        return '18:6 Fasting';
      case DietPresetType.if204:
        return '20:4 Fasting';
      case DietPresetType.omad:
        return 'OMAD';
      case DietPresetType.fiveTwoDiet:
        return '5:2 Diet';
      case DietPresetType.zone:
        return 'Zone Diet';
      case DietPresetType.custom:
        return 'Custom';
    }
  }

  String _presetDescription(DietPresetType type) {
    switch (type) {
      case DietPresetType.vegan:
        return 'No animal products';
      case DietPresetType.vegetarian:
        return 'No meat or fish';
      case DietPresetType.pescatarian:
        return 'Vegetarian + seafood';
      case DietPresetType.paleo:
        return 'No grains, dairy, or legumes';
      case DietPresetType.keto:
        return 'Very low carb, high fat';
      case DietPresetType.ketoStrict:
        return 'Strict ketogenic (< 20g carbs/day)';
      case DietPresetType.lowCarb:
        return 'Reduced carbohydrates';
      case DietPresetType.mediterranean:
        return 'Whole foods, olive oil, fish';
      case DietPresetType.whole30:
        return '30 days, no processed foods';
      case DietPresetType.aip:
        return 'Autoimmune protocol — eliminates triggers';
      case DietPresetType.lowFodmap:
        return 'Reduces digestive discomfort';
      case DietPresetType.glutenFree:
        return 'No wheat, barley, or rye';
      case DietPresetType.dairyFree:
        return 'No milk-based products';
      case DietPresetType.if168:
        return 'Eat within an 8-hour window daily';
      case DietPresetType.if186:
        return 'Eat within a 6-hour window daily';
      case DietPresetType.if204:
        return 'Eat within a 4-hour window daily';
      case DietPresetType.omad:
        return 'One meal per day';
      case DietPresetType.fiveTwoDiet:
        return '5 normal days, 2 restricted days';
      case DietPresetType.zone:
        return '40% carbs, 30% protein, 30% fat';
      case DietPresetType.custom:
        return 'Fully custom rules';
    }
  }

  IconData _presetIcon(DietPresetType type) {
    switch (type) {
      case DietPresetType.vegan:
      case DietPresetType.vegetarian:
        return Icons.eco;
      case DietPresetType.pescatarian:
        return Icons.set_meal;
      case DietPresetType.if168:
      case DietPresetType.if186:
      case DietPresetType.if204:
      case DietPresetType.omad:
      case DietPresetType.fiveTwoDiet:
        return Icons.timer;
      case DietPresetType.keto:
      case DietPresetType.ketoStrict:
      case DietPresetType.lowCarb:
        return Icons.show_chart;
      default:
        return Icons.restaurant_menu;
    }
  }
}
