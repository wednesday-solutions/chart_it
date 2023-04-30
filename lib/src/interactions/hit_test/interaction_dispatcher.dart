import 'package:chart_it/src/extensions/primitives.dart';
import 'package:chart_it/src/interactions/data/touch_interaction_events.dart';
import 'package:chart_it/src/interactions/data/touch_interactions.dart';
import 'package:flutter/material.dart';

mixin InteractionDispatcher {
  Offset? _latestTapOffset;
  Offset? _latestDoubleTapOffset;
  Offset? _latestPanOffset;

  bool get tapRecognitionEnabled => _tapRecognitionEnabled;
  bool _tapRecognitionEnabled = false;

  bool get doubleTapRecognitionEnabled => _doubleTapRecognitionEnabled;
  bool _doubleTapRecognitionEnabled = false;

  bool get dragRecognitionEnabled => _dragRecognitionEnabled;
  bool _dragRecognitionEnabled = false;

  updateInteractionDetectionStates<T extends TouchInteractionResult>(
      TouchInteractionEvents<T> interactionEvents
      ) {
    if (interactionEvents.shouldHitTest.isFalse) return;

    if (interactionEvents.onRawInteraction.isNotNull) {
      _tapRecognitionEnabled = true;
      _doubleTapRecognitionEnabled = true;
      _dragRecognitionEnabled = true;
    }

    if (_tapRecognitionEnabled.isFalse) {
      _tapRecognitionEnabled = interactionEvents.onTap.isNotNull ||
          interactionEvents.onTapUp.isNotNull ||
          interactionEvents.onTapDown.isNotNull;
    }

    if (_doubleTapRecognitionEnabled.isFalse) {
      _doubleTapRecognitionEnabled = interactionEvents.onDoubleTap.isNotNull;
    }

    if (_dragRecognitionEnabled.isFalse) {
      _dragRecognitionEnabled = interactionEvents.onDrag.isNotNull ||
          interactionEvents.onDragStart.isNotNull ||
          interactionEvents.onDragEnd.isNotNull;
    }
  }

  @protected
  void onInteraction(
    TouchInteractionType interactionType,
    Offset localPosition,
  );

  void onTapDown(TapDownDetails details) {
    _latestTapOffset = details.localPosition;
    onInteraction(TouchInteractionType.tapDown, details.localPosition);
  }

  void onTapUp(TapUpDetails details) {
    _latestTapOffset = details.localPosition;
    onInteraction(TouchInteractionType.tapUp, details.localPosition);
  }

  void onTap() {
    final latestTapOffset = _latestTapOffset;
    if (latestTapOffset != null) {
      onInteraction(TouchInteractionType.tap, latestTapOffset);
    }
    _latestTapOffset = null;
  }

  void onTapCancel() {
    _latestTapOffset = null;
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
    onInteraction(TouchInteractionType.dragStart, details.localPosition);
  }

  void onPanUpdate(DragUpdateDetails details) {
    _latestPanOffset = details.localPosition;
    onInteraction(TouchInteractionType.dragUpdate, details.localPosition);
  }

  void onPanCancel() {
    final latestPanOffset = _latestPanOffset;
    if (latestPanOffset != null) {
      onInteraction(TouchInteractionType.dragEnd, latestPanOffset);
    }
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
