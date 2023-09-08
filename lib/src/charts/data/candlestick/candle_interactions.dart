import 'package:chart_it/src/charts/data/candle_sticks.dart';
import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/widgets/candle_stick_chart.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';

/// {@template CandleInteractionEvents}
///
/// [CandleInteractionEvents] the interaction behaviour and callbacks for [CandleStickChart]
///
/// See also:
/// * [Fuzziness]
///
/// {@endtemplate}
class CandleInteractionEvents
    extends TouchInteractionEvents<CandleInteractionResult> {
  /// [Fuzziness] increases the area of hit detection for a bar.
  ///
  /// Setting a high value for [Fuzziness] will lead to incorrect hit detection due to overlapping
  /// hit targets.
  final Fuzziness fuzziness;

  const CandleInteractionEvents({
    required super.isEnabled,
    this.fuzziness = const Fuzziness.zero(),
    super.onTap,
    super.onDoubleTap,
    super.onDragStart,
    super.onDrag,
    super.onDragEnd,
    super.onRawInteraction,
  });

  @override
  List<Object?> get props => [isEnabled, fuzziness];
}

/// {@template CandleInteractionResult}
/// [CandleInteractionResult] represents the result of an interaction with the [BarChart].
///
/// See also:
/// * [TouchInteractionType]
/// {@endtemplate}
class CandleInteractionResult extends TouchInteractionResult with EquatableMixin {
  /// The [BarGroup] matching the interaction.
  final Candle candle;

  /// {@macro CandleInteractionResult}
  CandleInteractionResult({
    required this.candle,
    required super.localPosition,
    required super.interactionType,
  });

  CandleInteractionResult copyWith({
    Candle? candle,
    Offset? localPosition,
    TouchInteractionType? interactionType,
  }) {
    return CandleInteractionResult(
      candle: candle ?? this.candle,
      localPosition: localPosition ?? this.localPosition,
      interactionType: interactionType ?? this.interactionType,
    );
  }

  @override
  List<Object?> get props => [candle, localPosition, interactionType];
}