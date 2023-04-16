import 'package:chart_it/src/interactions/data/touch_interactions.dart';

abstract class TouchInteractionEvents<T extends TouchInteractionResult> {
  final bool isEnabled;
  final void Function(T interactionResult)? onRawInteraction;
  final void Function(T interactionResult)? onTap;
  final void Function(T interactionResult)? onDoubleTap;
  final void Function(T interactionResult)? onDragStart;
  final void Function(T interactionResult)? onDrag;
  final void Function(T interactionResult)? onDragEnd;

  const TouchInteractionEvents({
    required this.isEnabled,
    this.onTap,
    this.onDoubleTap,
    this.onDragStart,
    this.onDrag,
    this.onDragEnd,
    this.onRawInteraction,
  });

  void onInteraction(T interactionResult) {
    switch (interactionResult.interactionType) {
      case TouchInteractionType.tap:
        onTap?.call(interactionResult);
        break;
      case TouchInteractionType.doubleTap:
        onDoubleTap?.call(interactionResult);
        break;
      case TouchInteractionType.dragUpdate:
        onDragStart?.call(interactionResult);
        break;
      case TouchInteractionType.dragStart:
        onDrag?.call(interactionResult);
        break;
      case TouchInteractionType.dragEnd:
        onDragEnd?.call(interactionResult);
        break;
    }
  }

  bool get shouldHitTest =>
      isEnabled &&
      (onRawInteraction != null ||
          onTap != null ||
          onDoubleTap != null ||
          onDragStart != null ||
          onDragEnd != null ||
          onDrag != null);
}
