import 'package:chart_it/src/interactions/data/chart_interactions.dart';
import 'package:flutter/material.dart';

mixin InteractionDispatcher {
  Offset? _latestDoubleTapOffset;
  Offset? _latestPanOffset;

  @protected
  void onInteraction(
    ChartInteractionType interactionType,
    Offset localPosition,
  );

  void onTapUp(Offset localPosition) {
    onInteraction(ChartInteractionType.tap, localPosition);
  }

  void onDoubleTapDown(Offset localPosition) {
    _latestDoubleTapOffset = localPosition;
  }

  void onDoubleTapCancel() {
    _latestDoubleTapOffset = null;
  }

  void onDoubleTap() {
    final latestDoubleTapOffset = _latestDoubleTapOffset;
    if (latestDoubleTapOffset != null) {
      onInteraction(ChartInteractionType.doubleTap, latestDoubleTapOffset);
    }
  }

  void onPanStart(Offset localPosition) {
    _latestPanOffset = localPosition;
    onInteraction(ChartInteractionType.drag, localPosition);
  }

  void onPanUpdate(Offset localPosition) {
    _latestPanOffset = localPosition;
    onInteraction(ChartInteractionType.drag, localPosition);
  }

  void onPanCancel() {
    _latestPanOffset = null;
  }

  void onPanEnd() {
    final latestPanOffset = _latestPanOffset;
    if (latestPanOffset != null) {
      onInteraction(ChartInteractionType.dragEnd, latestPanOffset);
    }
    _latestPanOffset = null;
  }
}
