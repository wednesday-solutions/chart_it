import 'package:chart_it/src/interactions/interactions.dart';
import 'package:chart_it/chart_it.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';

/// {@template BarInteractionEvents}
///
/// [BarInteractionEvents] the interaction behaviour and callbacks for [BarChart]
///
/// See also:
/// * [Fuzziness]
/// * [SnapToBarConfig]
///
/// {@endtemplate}
class BarInteractionEvents
    extends TouchInteractionEvents<BarInteractionResult> {
  /// [SnapToBarConfig] determines the way interactions outside the boundary of the bar are handled by
  /// dictating how the interactions are interpreted.
  final SnapToBarConfig snapToBarConfig;

  /// [Fuzziness] increases the area of hit detection for a bar.
  /// Should ideally be used only if [SnapToBarConfig] is disabled.
  ///
  /// Setting a high value for [Fuzziness] will lead to incorrect hit detection due to overlapping
  /// hit targets.
  final Fuzziness fuzziness;

  const BarInteractionEvents({
    required super.isEnabled,
    this.snapToBarConfig = const SnapToBarConfig(),
    this.fuzziness = const Fuzziness.zero(),
    super.onTap,
    super.onDoubleTap,
    super.onDragStart,
    super.onDrag,
    super.onDragEnd,
    super.onRawInteraction,
  });

  @override
  List<Object?> get props => [isEnabled, snapToBarConfig, fuzziness];
}

/// {@template BarInteractionResult}
/// [BarInteractionResult] represents the result of an interaction with the [BarChart].
///
/// See also:
/// * [TouchInteractionType]
/// {@endtemplate}
class BarInteractionResult extends TouchInteractionResult with EquatableMixin {
  /// The [BarGroup] matching the interaction.
  final BarGroup barGroup;

  /// The index of [barGroup] in [BarSeries].
  final int barGroupIndex;

  /// The relevant [BarData] within [barGroup] matching the current interaction.
  final BarData barData;

  /// The index of [barData] in [BarGroup].
  final int barDataIndex;

  /// {@macro BarInteractionResult}
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

/// {@template SnapToBarConfig}
///[SnapToBarConfig] determines the way interactions outside the boundary of the bar are handled by
/// dictating how the interactions are interpreted.
///
/// See also:
/// * [SnapToBarBehaviour]
/// {@endtemplate}
class SnapToBarConfig extends Equatable {
  final bool snapToWidthOnDrag;
  final bool snapToHeightOnDrag;
  final bool snapToWidthOnTap;
  final bool snapToHeightOnTap;
  final bool snapToWidthOnDoubleTap;
  final bool snapToHeightOnDoubleTap;
  final SnapToBarBehaviour snapToBarBehaviour;

  /// {@macro SnapToBarConfig}
  const SnapToBarConfig({
    this.snapToWidthOnDrag = true,
    this.snapToHeightOnDrag = false,
    this.snapToWidthOnTap = true,
    this.snapToHeightOnTap = false,
    this.snapToWidthOnDoubleTap = true,
    this.snapToHeightOnDoubleTap = false,
    this.snapToBarBehaviour = SnapToBarBehaviour.snapToSection,
  });

  /// {@macro SnapToBarConfig}
  ///
  /// This is a shorthand syntax for setting values for all interaction types.
  const SnapToBarConfig.forAll({
    required bool snapToWidth,
    required bool snapToHeight,
    this.snapToBarBehaviour = SnapToBarBehaviour.snapToSection,
  })  : snapToWidthOnDrag = snapToWidth,
        snapToWidthOnTap = snapToWidth,
        snapToWidthOnDoubleTap = snapToWidth,
        snapToHeightOnDrag = snapToHeight,
        snapToHeightOnTap = snapToHeight,
        snapToHeightOnDoubleTap = snapToHeight;

  /// {@macro SnapToBarConfig}
  ///
  /// This is a shorthand syntax for disabling all snapping behaviour.
  /// As a result any interaction outside the boundaries of a bar will not be processed.
  const SnapToBarConfig.disabled()
      : snapToWidthOnDrag = false,
        snapToWidthOnTap = false,
        snapToWidthOnDoubleTap = false,
        snapToHeightOnDrag = false,
        snapToHeightOnTap = false,
        snapToHeightOnDoubleTap = false,
        snapToBarBehaviour = SnapToBarBehaviour.snapToSection;

  @override
  List<Object?> get props => [
        snapToWidthOnDrag,
        snapToHeightOnDrag,
        snapToWidthOnTap,
        snapToHeightOnTap,
        snapToWidthOnDoubleTap,
        snapToHeightOnDoubleTap,
        snapToBarBehaviour,
      ];
}

/// [SnapToBarBehaviour] influences the behaviour of snapping interactions outside of the boundaries of a
/// bar to a particular bar.
enum SnapToBarBehaviour {
  /// [snapToNearest] will snap the interaction point to the closed bar by distance.
  snapToNearest,

  /// [snapToSection] will snap to the
  snapToSection;
}
