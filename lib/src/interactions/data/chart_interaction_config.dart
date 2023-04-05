import 'package:chart_it/src/interactions/data/chart_interactions.dart';

abstract class ChartInteractionConfig<T extends ChartInteractionResult> {
  final bool isEnabled;
  final void Function(T interactionResult)? onRawInteraction;
  final void Function(T interactionResult)? onTap;
  final void Function(T interactionResult)? onDoubleTap;
  final void Function(T interactionResult)? onDragStart;
  final void Function(T interactionResult)? onDrag;
  final void Function(T interactionResult)? onDragEnd;

  const ChartInteractionConfig({
    this.onRawInteraction,
    required this.onTap,
    required this.onDoubleTap,
    required this.onDragStart,
    required this.onDrag,
    required this.onDragEnd,
    required this.isEnabled,
  });

  void onInteraction(T interactionResult) {
    switch (interactionResult.interactionType) {
      case ChartInteractionType.tap:
        onTap?.call(interactionResult);
        break;
      case ChartInteractionType.doubleTap:
        onDoubleTap?.call(interactionResult);
        break;
      case ChartInteractionType.drag:
        onDragStart?.call(interactionResult);
        break;
      case ChartInteractionType.dragStart:
        onDrag?.call(interactionResult);
        break;
      case ChartInteractionType.dragEnd:
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
