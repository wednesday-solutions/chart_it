import 'package:chart_it/src/interactions/data/touch_interactions.dart';
import 'package:equatable/equatable.dart';

/// {@template TouchInteractionEvents}
/// [TouchInteractionEvents] provides callback to receive interaction events
/// for the chart.
/// {@endtemplate}
abstract class TouchInteractionEvents<T extends TouchInteractionResult>
    with EquatableMixin {

  /// Set if interaction is enabled.
  final bool isEnabled;

  /// [onRawInteraction] receives all types of interaction events.
  final void Function(T interactionResult)? onRawInteraction;

  /// [onTap] is be called after a tap gesture is completed.
  /// It is called right after [onTapUp].
  final void Function(T interactionResult)? onTap;

  /// [onTapUp] is called when the pointer that will trigger a tap gesture
  /// stops making contact with the screen.
  final void Function(T interactionResult)? onTapUp;

  /// [onTapDown] is called when the pointer that will trigger a tap gesture
  /// comes in contact with the screen.
  final void Function(T interactionResult)? onTapDown;

  /// [onDoubleTap] is be called after a double tap gesture is detected.
  final void Function(T interactionResult)? onDoubleTap;

  /// [onDragStart] is called when a pointer comes in contact with the screen
  /// and starts moving triggering a drag gesture.
  final void Function(T interactionResult)? onDragStart;

  /// [onDrag] is called when the pointer location is updated for the pointer that started
  /// the drag gesture.
  final void Function(T interactionResult)? onDrag;

  /// [onDragEnd] is called when the pointer that triggered the drag gesture
  /// stop moving ending the drag gesture.
  final void Function(T interactionResult)? onDragEnd;

  /// {@macro TouchInteractionEvents}
  const TouchInteractionEvents({
    required this.isEnabled,
    this.onTap,
    this.onTapUp,
    this.onTapDown,
    this.onDoubleTap,
    this.onDragStart,
    this.onDrag,
    this.onDragEnd,
    this.onRawInteraction,
  });

  void onInteraction(T interactionResult) {
    onRawInteraction?.call(interactionResult);
    switch (interactionResult.interactionType) {
      case TouchInteractionType.doubleTap:
        onDoubleTap?.call(interactionResult);
        break;
      case TouchInteractionType.dragUpdate:
        onDrag?.call(interactionResult);
        break;
      case TouchInteractionType.dragStart:
        onDragStart?.call(interactionResult);
        break;
      case TouchInteractionType.dragEnd:
        onDragEnd?.call(interactionResult);
        break;
      case TouchInteractionType.tapUp:
        onTap?.call(interactionResult);
        break;
      case TouchInteractionType.tapDown:
        onTapDown?.call(interactionResult);
        break;
      case TouchInteractionType.tap:
        onTap?.call(interactionResult);
        break;
    }
  }

  bool get shouldHitTest =>
      isEnabled &&
      (onRawInteraction != null ||
          onTap != null ||
          onTapDown != null ||
          onTapUp != null ||
          onDoubleTap != null ||
          onDragStart != null ||
          onDragEnd != null ||
          onDrag != null);
}
