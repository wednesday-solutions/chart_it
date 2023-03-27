import 'package:chart_it/src/interactions/config/chart_interaction_config.dart';
import 'package:chart_it/src/interactions/data/bar_interaction_result.dart';

class BarInteractionConfig extends ChartInteractionConfig<BarInteractionResult> {
  const BarInteractionConfig({
    required super.isEnabled,
    super.onTap,
    super.onDoubleTap,
    super.onRawInteraction,
    super.onDragStart,
    super.onDrag,
    super.onDragEnd,
  });
}
