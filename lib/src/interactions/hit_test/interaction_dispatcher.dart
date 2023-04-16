import 'package:chart_it/src/interactions/data/touch_interactions.dart';
import 'package:flutter/material.dart';

mixin InteractionDispatcher {
  Offset? _latestDoubleTapOffset;
  Offset? _latestPanOffset;

  @protected
  void onInteraction(
    TouchInteractionType interactionType,
    Offset localPosition,
  );

  void onTapUp(TapUpDetails details) {
    onInteraction(TouchInteractionType.tap, details.localPosition);
  }

  void onDoubleTap() {
    final latestDoubleTapOffset = _latestDoubleTapOffset;
    if (latestDoubleTapOffset != null) {
      onInteraction(TouchInteractionType.doubleTap, latestDoubleTapOffset);
    }
  }

  void onDoubleTapDown(TapDownDetails details) {
    _latestDoubleTapOffset = details.localPosition;
  }

  void onDoubleTapCancel() {
    _latestDoubleTapOffset = null;
  }

  void onPanStart(DragStartDetails details) {
    _latestPanOffset = details.localPosition;
    onInteraction(TouchInteractionType.dragUpdate, details.localPosition);
  }

  void onPanUpdate(DragUpdateDetails details) {
    _latestPanOffset = details.localPosition;
    onInteraction(TouchInteractionType.dragUpdate, details.localPosition);
  }

  void onPanCancel() {
    _latestPanOffset = null;
  }

  void onPanEnd(DragEndDetails details) {
    final latestPanOffset = _latestPanOffset;
    if (latestPanOffset != null) {
      onInteraction(TouchInteractionType.dragEnd, latestPanOffset);
    }
    _latestPanOffset = null;
  }
}
