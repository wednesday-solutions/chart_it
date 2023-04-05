import 'package:flutter/gestures.dart';

abstract class ChartInteractionResult {
  final Offset? localPosition;
  final ChartInteractionType interactionType;

  ChartInteractionResult({
    required this.localPosition,
    required this.interactionType,
  });
}

enum ChartInteractionType {
  tap,
  doubleTap,
  dragStart,
  drag,
  dragEnd;
}
