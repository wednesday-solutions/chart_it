import 'package:chart_it/chart_it.dart';
import 'package:chart_it/src/interactions/data/touch_interactions.dart';

extension BarSnapExtension on SnapToBarConfig {
  bool shouldSnapToHeight(TouchInteractionType type) {
    switch (type) {
      case TouchInteractionType.tap:
      case TouchInteractionType.tapUp:
      case TouchInteractionType.tapDown:
        return snapToHeightOnTap;
      case TouchInteractionType.doubleTap:
        return snapToHeightOnDoubleTap;
      case TouchInteractionType.dragStart:
      case TouchInteractionType.dragUpdate:
      case TouchInteractionType.dragEnd:
        return snapToHeightOnDrag;
    }
  }

  bool shouldSnapToWidth(TouchInteractionType type) {
    switch (type) {
      case TouchInteractionType.tap:
      case TouchInteractionType.tapUp:
      case TouchInteractionType.tapDown:
        return snapToWidthOnTap;
      case TouchInteractionType.doubleTap:
        return snapToWidthOnDoubleTap;
      case TouchInteractionType.dragStart:
      case TouchInteractionType.dragUpdate:
      case TouchInteractionType.dragEnd:
        return snapToWidthOnDrag;
    }
  }
}