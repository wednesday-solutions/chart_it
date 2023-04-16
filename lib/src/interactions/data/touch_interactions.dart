import 'package:flutter/gestures.dart';

abstract class TouchInteractionResult {
  final Offset? localPosition;
  final TouchInteractionType interactionType;

  TouchInteractionResult({
    required this.localPosition,
    required this.interactionType,
  });
}

enum TouchInteractionType {
  tap,
  doubleTap,
  dragStart,
  dragUpdate,
  dragEnd,
}
