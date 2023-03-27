import 'dart:ui';

import 'package:chart_it/src/interactions/data/chart_interaction_result.dart';
import 'package:chart_it/src/interactions/data/chart_interaction_type.dart';
import 'package:flutter/foundation.dart';

mixin HitTestExecutorMixin<T extends ChartInteractionResult> {
  bool get shouldHitTest;

  @protected
  T? hitTestInternal(ChartInteractionType interactionType, Offset localPosition);

  @nonVirtual
  T? hitTest(ChartInteractionType interactionType, Offset localPosition) {
    if (shouldHitTest) {
      return hitTestInternal(interactionType, localPosition);
    }
    return null;
  }
}