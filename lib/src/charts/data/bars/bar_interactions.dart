import 'package:chart_it/src/charts/data/bars/bar_data.dart';
import 'package:chart_it/src/charts/data/bars/bar_group.dart';
import 'package:chart_it/src/charts/data/core/shared/fuzziness.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';

class BarInteractionEvents extends TouchInteractionEvents<BarInteractionResult> {
  final SnapToNearestBarConfig snapToNearestBarConfig;
  final Fuzziness fuzziness;

  const BarInteractionEvents({
    required super.isEnabled,
    this.snapToNearestBarConfig = const SnapToNearestBarConfig(),
    this.fuzziness = const Fuzziness.zero(),
    super.onTap,
    super.onDoubleTap,
    super.onDragStart,
    super.onDrag,
    super.onDragEnd,
    super.onRawInteraction,
  });

  @override
  List<Object?> get props => [isEnabled, snapToNearestBarConfig, fuzziness];
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
  List<Object?> get props => [
        barGroup,
        barGroupIndex,
        barData,
        barDataIndex,
        localPosition,
        interactionType,
      ];
}

class SnapToNearestBarConfig extends Equatable {
  final bool snapToWidthOnDrag;
  final bool snapToHeightOnDrag;
  final bool snapToWidthOnTap;
  final bool snapToHeightOnTap;
  final bool snapToWidthOnDoubleTap;
  final bool snapToHeightOnDoubleTap;

  const SnapToNearestBarConfig({
    this.snapToWidthOnDrag = true,
    this.snapToHeightOnDrag = false,
    this.snapToWidthOnTap = true,
    this.snapToHeightOnTap = false,
    this.snapToWidthOnDoubleTap = true,
    this.snapToHeightOnDoubleTap = false,
  });

  const SnapToNearestBarConfig.forAll({required bool snapToWidth, required bool snapToHeight})
      : snapToWidthOnDrag = snapToWidth,
        snapToWidthOnTap = snapToWidth,
        snapToWidthOnDoubleTap = snapToWidth,
        snapToHeightOnDrag = snapToHeight,
        snapToHeightOnTap = snapToHeight,
        snapToHeightOnDoubleTap = snapToHeight;

  @override
  List<Object?> get props => [
        snapToWidthOnDrag,
        snapToHeightOnDrag,
        snapToWidthOnTap,
        snapToHeightOnTap,
        snapToWidthOnDoubleTap,
        snapToHeightOnDoubleTap
      ];
}
