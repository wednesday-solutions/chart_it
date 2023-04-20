import 'package:chart_it/src/charts/data/pie.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';

class PieInteractionEvents extends TouchInteractionEvents<PieInteractionResult>
    with EquatableMixin {

  const PieInteractionEvents({
    required super.isEnabled,
    super.onTap,
    super.onDoubleTap,
    super.onDragStart,
    super.onDrag,
    super.onDragEnd,
  });

  @override
  List<Object?> get props => [];
}

class PieInteractionResult extends TouchInteractionResult with EquatableMixin {
  final SliceData slice;
  final int sliceDataIndex;

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
  List<Object?> get props => [
        slice,
        sliceDataIndex,
        super.localPosition,
        super.interactionType,
      ];
}
