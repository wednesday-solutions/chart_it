import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';

/// {@template TouchInteractionResult}
/// [TouchInteractionResult] is the base class for interaction result of charts.
/// {@endtemplate}
abstract class TouchInteractionResult with EquatableMixin {

  /// The offset of the interaction relative to the chart.
  final Offset? localPosition;

  /// The [TouchInteractionType] of this interaction.
  final TouchInteractionType interactionType;

  /// {@macro TouchInteractionResult}
  TouchInteractionResult({
    required this.localPosition,
    required this.interactionType,
  });
}

/// [TouchInteractionType] represents the type of interaction for [TouchInteractionResult].
enum TouchInteractionType {
  tap,
  tapUp,
  tapDown,
  doubleTap,
  dragStart,
  dragUpdate,
  dragEnd,
}
