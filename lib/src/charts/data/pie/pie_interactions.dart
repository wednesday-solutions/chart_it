import 'package:chart_it/chart_it.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';

/// {@template PieInteractionEvents}
///
/// [PieInteractionEvents] the interaction behaviour and callbacks for [PieChart]
///
/// {@endtemplate}
class PieInteractionEvents extends TouchInteractionEvents<PieInteractionResult>
    with EquatableMixin {
  /// {@macro PieInteractionEvents}
  const PieInteractionEvents({
    required super.isEnabled,
    super.onTap,
    super.onDoubleTap,
    super.onDragStart,
    super.onDrag,
    super.onDragEnd,
  });

  @override
  List<Object> get props => [isEnabled];
}

/// {@template PieInteractionResult}
/// [PieInteractionResult] represents the result of an interaction with the [PieChart].
///
/// See also:
/// * [TouchInteractionType]
/// {@endtemplate}
class PieInteractionResult extends TouchInteractionResult with EquatableMixin {
  /// The [SliceData] matching the interaction.
  final SliceData slice;

  /// The index of [slice] in [PieSeries].
  final int sliceDataIndex;

  /// {@macro PieInteractionResult}
  PieInteractionResult({
    required this.slice,
    required this.sliceDataIndex,
    required super.localPosition,
    required super.interactionType,
  });

  PieInteractionResult copyWith({
    SliceData? slice,
    int? sliceDataIndex,
    Offset? localPosition,
    TouchInteractionType? interactionType,
  }) {
    return PieInteractionResult(
      slice: slice ?? this.slice,
      sliceDataIndex: sliceDataIndex ?? this.sliceDataIndex,
      localPosition: localPosition ?? this.localPosition,
      interactionType: interactionType ?? this.interactionType,
    );
  }

  @override
  List<Object?> get props =>
      [slice, sliceDataIndex, localPosition, interactionType];
}
