import 'package:chart_it/src/charts/data/bars/bar_data.dart';
import 'package:chart_it/src/charts/data/bars/bar_group.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';

class BarInteractionEvents extends TouchInteractionEvents<BarInteractionResult>
    with EquatableMixin {
  const BarInteractionEvents({
    required super.isEnabled,
    super.onTap,
    super.onDoubleTap,
    super.onDragStart,
    super.onDrag,
    super.onDragEnd,
  });

  @override
  List<Object?> get props => [
        super.isEnabled,
        super.onTap,
        super.onDoubleTap,
        super.onDragStart,
        super.onDrag,
        super.onDragEnd,
      ];
}

class BarInteractionResult extends TouchInteractionResult with EquatableMixin {
  final BarGroup barGroup;
  final int barGroupIndex;
  final BarData barData;
  final int barDataIndex;

  BarInteractionResult({
    required this.barGroup,
    required this.barGroupIndex,
    required this.barData,
    required this.barDataIndex,
    required super.localPosition,
    required super.interactionType,
  });

  BarInteractionResult copyWith({
    BarGroup? barGroup,
    int? barGroupIndex,
    BarData? barData,
    int? barDataIndex,
    Offset? localPosition,
    TouchInteractionType? interactionType,
  }) {
    return BarInteractionResult(
      barGroup: barGroup ?? this.barGroup,
      barGroupIndex: barGroupIndex ?? this.barGroupIndex,
      barData: barData ?? this.barData,
      barDataIndex: barDataIndex ?? this.barDataIndex,
      localPosition: localPosition ?? this.localPosition,
      interactionType: interactionType ?? this.interactionType,
    );
  }

  @override
  List<Object?> get props => [barGroup, barGroupIndex, barData, barDataIndex];
}