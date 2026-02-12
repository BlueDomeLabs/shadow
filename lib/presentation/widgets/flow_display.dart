// lib/presentation/widgets/flow_display.dart
// Shared menstruation flow display utilities for picker and input widgets.

import 'package:flutter/material.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

/// Display properties for menstruation flow levels.
class FlowDisplay {
  FlowDisplay._();

  /// Color for flow level indicator.
  static Color color(MenstruationFlow flow) => switch (flow) {
    MenstruationFlow.none => Colors.grey,
    MenstruationFlow.spotty => Colors.pink.shade200,
    MenstruationFlow.light => Colors.pink.shade300,
    MenstruationFlow.medium => Colors.pink.shade400,
    MenstruationFlow.heavy => Colors.pink.shade600,
  };

  /// Icon for flow level indicator.
  static IconData icon(MenstruationFlow flow) => switch (flow) {
    MenstruationFlow.none => Icons.remove_circle_outline,
    MenstruationFlow.spotty => Icons.water_drop_outlined,
    MenstruationFlow.light => Icons.water_drop,
    MenstruationFlow.medium => Icons.opacity,
    MenstruationFlow.heavy => Icons.water,
  };

  /// Human-readable label for flow level.
  static String label(MenstruationFlow flow) => switch (flow) {
    MenstruationFlow.none => 'None',
    MenstruationFlow.spotty => 'Spotty',
    MenstruationFlow.light => 'Light',
    MenstruationFlow.medium => 'Medium',
    MenstruationFlow.heavy => 'Heavy',
  };
}
