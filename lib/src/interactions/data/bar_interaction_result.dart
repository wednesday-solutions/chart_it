import 'package:chart_it/src/charts/data/bars/bar_data.dart';
import 'package:chart_it/src/charts/data/bars/bar_group.dart';
import 'package:chart_it/src/interactions/data/chart_interaction_result.dart';

class BarInteractionResult extends ChartInteractionResult {
  final BarGroup barGroup;
  final int barGroupIndex;
  final BarData barData;
  final int barDataIndex;

  BarInteractionResult({
    super.localPosition,
    required super.interactionType,
    required this.barGroup,
    required this.barGroupIndex,
    required this.barData,
    required this.barDataIndex,
  });
}
