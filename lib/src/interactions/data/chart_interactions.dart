import 'package:chart_it/chart_it.dart';
import 'package:flutter/gestures.dart';

abstract class ChartInteractionResult {
  final Offset? localPosition;
  final ChartInteractionType interactionType;

  ChartInteractionResult({
    required this.localPosition,
    required this.interactionType,
  });
}

class BarChartInteractionResult extends ChartInteractionResult {
  final BarGroup barGroup;
  final int barGroupIndex;
  final BarData barData;
  final int barDataIndex;

  BarChartInteractionResult({
    required this.barGroup,
    required this.barGroupIndex,
    required this.barData,
    required this.barDataIndex,
    required super.localPosition,
    required super.interactionType,
  });
}

enum ChartInteractionType {
  tap,
  doubleTap,
  dragStart,
  drag,
  dragEnd;
}
