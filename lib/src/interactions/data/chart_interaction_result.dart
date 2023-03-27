import 'dart:ui';

import 'package:chart_it/src/interactions/data/chart_interaction_type.dart';

abstract class ChartInteractionResult {
  final Offset? localPosition;
  final ChartInteractionType interactionType;

  ChartInteractionResult({
    required this.localPosition,
    required this.interactionType,
  });
}
