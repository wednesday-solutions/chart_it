import 'package:chart_it/src/charts/data/candle_sticks.dart';
import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:flutter/painting.dart';

class CandleStickHitTester {
  static CandleInteractionResult? hitTest({
    required double graphUnitWidth,
    required Offset localPosition,
    required TouchInteractionType type,
    required List<CandleStickInteractionData> interactionData,
    required Fuzziness fuzziness,
  }) {
    for (var i = 0; i < interactionData.length; i++) {
      final candle = interactionData[i];
      // final shouldSnapToHeight = snapToCandleConfig.shouldSnapToHeight(type);
      if (candle.containsWithFuzziness(
        position: localPosition,
        fuzziness: fuzziness,
        // snapToHeight: shouldSnapToHeight,
      )) {
        return candle.getInteractionResult(localPosition, type);
      }
    }
    return null;
  }
}

class CandleStickInteractionData {
  final Rect rect;
  final Candle candle;

  const CandleStickInteractionData({
    required this.rect,
    required this.candle,
  });

  bool containsWithFuzziness({
    required Offset position,
    required Fuzziness fuzziness,
    // required bool snapToHeight,
  }) {
    final left = rect.left - fuzziness.left;
    final right = rect.right + fuzziness.right;

    // if (snapToHeight) {
    //   // If snapToHeight is true, any value of dy should return true. So we just check for dx constraints.
    //   return position.dx >= left && position.dx < right;
    // }

    final top = rect.top - fuzziness.top;
    final bottom = rect.bottom + fuzziness.bottom;
    return position.dx >= left &&
        position.dx < right &&
        position.dy >= top &&
        position.dy < bottom;
  }

  CandleInteractionResult getInteractionResult(
    Offset localPosition,
    TouchInteractionType type,
  ) {
    return CandleInteractionResult(
      candle: candle,
      localPosition: localPosition,
      interactionType: type,
    );
  }
}
