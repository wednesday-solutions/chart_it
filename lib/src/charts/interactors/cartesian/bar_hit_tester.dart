import 'package:chart_it/src/charts/data/bars.dart';
import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/extensions/interactions.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:flutter/painting.dart';

class BarHitTester {
  static BarInteractionResult? hitTest({
    required double graphUnitWidth,
    required Offset localPosition,
    required TouchInteractionType type,
    required List<BarGroupInteractionData> interactionData,
    required SnapToBarConfig snapToBarConfig,
    required Fuzziness fuzziness,
  }) {
    BarGroupInteractionData? previousGroup;

    for (var i = 0; i < interactionData.length; i++) {
      final isLastGroup = i == interactionData.length - 1;
      final currentGroup = interactionData[i];

      /// If pointer is within the bounds of the current group,
      /// it is most likely that hit point is on or top of some bar in this group.
      if (currentGroup.isInteractionWithinBounds(localPosition)) {
        return _getBarInteraction(
          group: currentGroup,
          groupType: currentGroup.type,
          localPosition: localPosition,
          snapToBarConfig: snapToBarConfig,
          fuzziness: fuzziness,
          type: type,
        );
      }

      /// If the pointer is after this group's boundaries, it is possible that
      /// pointer could be inside this group's section. This is where we need to
      /// determine snapping logic and find the closest group, & the bars it could
      /// interact with
      if (!currentGroup.isPointerAfterCurrentGroup(localPosition) ||
          isLastGroup) {
        return _snapAndGetBarInteraction(
          graphUnitWidth: graphUnitWidth,
          currentGroup: currentGroup,
          previousGroup: previousGroup,
          localPosition: localPosition,
          snapToBarConfig: snapToBarConfig,
          fuzziness: fuzziness,
          type: type,
        );
      }

      previousGroup = currentGroup;
    }
    return null;
  }

  static BarGroupInteractionData _findNearestGroupByDistance({
    required Offset localPosition,
    required BarGroupInteractionData? previousGroup,
    required BarGroupInteractionData currentGroup,
  }) {
    final distToPrev =
        (localPosition.dx - (previousGroup?.groupEnd ?? double.maxFinite))
            .abs();
    final distToNext = (currentGroup.groupStart - localPosition.dx).abs();

    if (distToPrev < distToNext && previousGroup != null) {
      return previousGroup;
    } else {
      return currentGroup;
    }
  }

  static BarGroupInteractionData _findNearestGroupBySection({
    required double graphUnitWidth,
    required Offset localPosition,
    required BarGroupInteractionData? previousGroup,
    required BarGroupInteractionData currentGroup,
  }) {
    final index = previousGroup?.groupIndex ?? currentGroup.groupIndex;
    final widthMultiplicationFactor = index + 1;
    final currentUnitWidthEndOffset =
        graphUnitWidth * widthMultiplicationFactor;

    final BarGroupInteractionData interactionGroup;
    if (localPosition.dx < currentUnitWidthEndOffset) {
      interactionGroup = previousGroup ?? currentGroup;
    } else {
      interactionGroup = currentGroup;
    }

    return interactionGroup;
  }

  static BarInteractionResult? _snapAndGetBarInteraction({
    required double graphUnitWidth,
    required BarGroupInteractionData? previousGroup,
    required BarGroupInteractionData currentGroup,
    required Offset localPosition,
    required SnapToBarConfig snapToBarConfig,
    required Fuzziness fuzziness,
    required TouchInteractionType type,
  }) {
    final BarGroupInteractionData interactionGroup;

    /// We first have to find the nearest group, before we could determine which
    /// bar is interactable with current pointer's position
    switch (snapToBarConfig.snapToBarBehaviour) {
      case SnapToBarBehaviour.snapToNearest:
        interactionGroup = _findNearestGroupByDistance(
          localPosition: localPosition,
          previousGroup: previousGroup,
          currentGroup: currentGroup,
        );
        break;
      case SnapToBarBehaviour.snapToSection:
        interactionGroup = _findNearestGroupBySection(
          graphUnitWidth: graphUnitWidth,
          localPosition: localPosition,
          previousGroup: previousGroup,
          currentGroup: currentGroup,
        );
        break;
    }

    return _getBarInteraction(
      group: interactionGroup,
      groupType: interactionGroup.type,
      localPosition: localPosition,
      snapToBarConfig: snapToBarConfig,
      fuzziness: fuzziness,
      type: type,
    );
  }

  static BarInteractionResult? _getBarInteraction({
    required BarGroupInteractionData group,
    required InteractedGroupType groupType,
    required Offset localPosition,
    required SnapToBarConfig snapToBarConfig,
    required Fuzziness fuzziness,
    required TouchInteractionType type,
  }) {
    switch (groupType) {
      case InteractedGroupType.simpleBar:
        return _getSeriesBarInteraction(
          group: group,
          localPosition: localPosition,
          snapToBarConfig: snapToBarConfig,
          fuzziness: fuzziness,
          type: type,
        );
      case InteractedGroupType.multiBarSeries:
        return _getSeriesBarInteraction(
          group: group,
          localPosition: localPosition,
          snapToBarConfig: snapToBarConfig,
          fuzziness: fuzziness,
          type: type,
        );
      case InteractedGroupType.multiBarStack:
        return _getStackedBarInteractionResult(
          group: group,
          localPosition: localPosition,
          snapToBarConfig: snapToBarConfig,
          fuzziness: fuzziness,
          type: type,
        );
    }
  }

  static BarInteractionResult? _getSeriesBarInteraction({
    required BarGroupInteractionData group,
    required Offset localPosition,
    required SnapToBarConfig snapToBarConfig,
    required Fuzziness fuzziness,
    required TouchInteractionType type,
  }) {
    final bars = group.barInteractions;
    BarInteractionData? previousBar;
    for (var i = 0; i < bars.length; i++) {
      final bar = bars[i];
      final shouldSnapToHeight = snapToBarConfig.shouldSnapToHeight(type);

      if (bar.containsWithFuzziness(
        position: localPosition,
        fuzziness: fuzziness,
        snapToHeight: shouldSnapToHeight,
      )) {
        return bar.getInteractionResult(localPosition, type);
      }

      if (snapToBarConfig.shouldSnapToWidth(type)) {
        final isLastBar = i == bars.length - 1;
        final isPointerAfterBar = bar.isPointerAfterBar(localPosition);

        if (!isPointerAfterBar || isLastBar) {
          return _snapToNearestBar(
            localPosition: localPosition,
            previousBar: previousBar,
            currentBar: bar,
            groupType: group.type,
            isPointerAfterBar: isPointerAfterBar,
            shouldSnapToHeight: shouldSnapToHeight,
            isLastBar: isLastBar,
            fuzziness: fuzziness,
            type: type,
          );
        } else {
          previousBar = bar;
        }
      }
    }

    return null;
  }

  static BarInteractionResult? _getStackedBarInteractionResult({
    required BarGroupInteractionData group,
    required Offset localPosition,
    required SnapToBarConfig snapToBarConfig,
    required Fuzziness fuzziness,
    required TouchInteractionType type,
  }) {
    final bars = group.barInteractions;
    for (var i = 0; i < bars.length; i++) {
      final bar = bars[i];
      final isLastBar = i == bars.length - 1;
      final shouldSnapToHeight =
          snapToBarConfig.shouldSnapToHeight(type) && isLastBar;

      if (bar.containsWithFuzziness(
        position: localPosition,
        fuzziness: fuzziness,
        snapToHeight: shouldSnapToHeight,
      )) {
        return bar.getInteractionResult(localPosition, type);
      }

      if (snapToBarConfig.shouldSnapToWidth(type)) {
        final isWithinBarHeight = bar.rect.top <= localPosition.dy &&
            localPosition.dy <= bar.rect.bottom;
        if (isWithinBarHeight || (isLastBar && shouldSnapToHeight)) {
          return bar.getInteractionResult(localPosition, type);
        }
      }
    }

    return null;
  }

  static BarInteractionResult? _snapToNearestBar({
    required Offset localPosition,
    required BarInteractionData? previousBar,
    required BarInteractionData currentBar,
    required InteractedGroupType groupType,
    required bool isPointerAfterBar,
    required bool isLastBar,
    required bool shouldSnapToHeight,
    required Fuzziness fuzziness,
    required TouchInteractionType type,
  }) {
    final isFirstBar = previousBar == null;
    final isPointerAfterLastBar = isLastBar && isPointerAfterBar;

    if (isFirstBar || isPointerAfterLastBar) {
      if (_ignorePointerAboveBar(
        shouldSnapToHeight: shouldSnapToHeight,
        bar: currentBar,
        localPosition: localPosition,
        fuzziness: fuzziness,
      )) {
        return null;
      }

      return currentBar.getInteractionResult(localPosition, type);
    }

    final BarInteractionData nearestBar;

    switch (groupType) {
      case InteractedGroupType.simpleBar:
        nearestBar =
            _findNearestBarWithDx(localPosition, previousBar, currentBar);
        break;
      case InteractedGroupType.multiBarSeries:
        nearestBar =
            _findNearestBarWithDx(localPosition, previousBar, currentBar);
        break;
      case InteractedGroupType.multiBarStack:
        nearestBar =
            _findNearestBarWithDy(localPosition, previousBar, currentBar);
        break;
    }

    // If snap to height is disabled and pointer is above the nearest bar, return null
    if (_ignorePointerAboveBar(
      bar: nearestBar,
      localPosition: localPosition,
      shouldSnapToHeight: shouldSnapToHeight,
      fuzziness: fuzziness,
    )) {
      return null;
    }

    return nearestBar.getInteractionResult(localPosition, type);
  }

  static BarInteractionData _findNearestBarWithDx(
    Offset position,
    BarInteractionData previous,
    BarInteractionData current,
  ) {
    final distToPrev = position.dx - previous.rect.right;
    final distToCurrent = current.rect.left - position.dx;
    return distToPrev >= distToCurrent ? current : previous;
  }

  static BarInteractionData _findNearestBarWithDy(
    Offset position,
    BarInteractionData previous,
    BarInteractionData current,
  ) {
    // We have two scenarios over here
    // 1.  The pointer is alongside the bar.
    // 2. The pointer is over the top most bar.
    final previousHeightBounds = _isWithinHeightBounds(position, previous);
    final currentHeightBounds = _isWithinHeightBounds(position, current);

    if (previousHeightBounds || currentHeightBounds) {
      // Pointer is alongside the bar
      return currentHeightBounds ? current : previous;
    } else {
      // Pointer is above the top most bar
      // in this case, we need to find the closest bar by the nearest top side of the bar
      final distToPrev = position.dy - previous.rect.top;
      final distToCurrent = position.dy - current.rect.top;
      return distToPrev >= distToCurrent ? current : previous;
    }
  }

  static bool _ignorePointerAboveBar({
    required Offset localPosition,
    required BarInteractionData bar,
    required bool shouldSnapToHeight,
    required Fuzziness fuzziness,
  }) {
    return !shouldSnapToHeight &&
        bar.isPointerAboveBar(position: localPosition, fuzziness: fuzziness);
  }

  static bool _isWithinHeightBounds(Offset position, BarInteractionData bar) {
    return bar.rect.top <= position.dy && bar.rect.bottom >= position.dy;
  }
}

class BarGroupInteractionData {
  final double groupStart;
  final double groupEnd;
  final InteractedGroupType type;
  final int groupIndex;
  final List<BarInteractionData> barInteractions;

  BarGroupInteractionData({
    required this.groupStart,
    required this.groupEnd,
    required this.type,
    required this.groupIndex,
    required this.barInteractions,
  });

  bool isPointerAfterCurrentGroup(Offset position) => position.dx > groupEnd;

  bool isInteractionWithinBounds(Offset localPosition) {
    return groupStart <= localPosition.dx && groupEnd >= localPosition.dx;
  }
}

enum InteractedGroupType { simpleBar, multiBarSeries, multiBarStack }

class BarInteractionData {
  final RRect rect;
  final BarGroup barGroup;
  final int barGroupIndex;
  final BarData barData;
  final int barDataIndex;

  BarInteractionData({
    required this.rect,
    required this.barGroup,
    required this.barGroupIndex,
    required this.barData,
    required this.barDataIndex,
  });

  bool containsWithFuzziness({
    required Offset position,
    required Fuzziness fuzziness,
    required bool snapToHeight,
  }) {
    final left = rect.left - fuzziness.left;
    final right = rect.right + fuzziness.right;

    if (snapToHeight) {
      // If snapToHeight is true, any value of dy should return true. So we just check for dx constraints.
      return position.dx >= left && position.dx < right;
    }

    final top = rect.top - fuzziness.top;
    final bottom = rect.bottom + fuzziness.bottom;
    return position.dx >= left &&
        position.dx < right &&
        position.dy >= top &&
        position.dy < bottom;
  }

  bool isPointerAfterBar(Offset position) => position.dx > rect.right;

  bool isPointerAboveBar({
    required Offset position,
    required Fuzziness fuzziness,
  }) {
    final top = rect.top - fuzziness.top;
    final bottom = rect.bottom + fuzziness.bottom;

    return position.dy < top || position.dy > bottom;
  }

  BarInteractionResult getInteractionResult(
    Offset localPosition,
    TouchInteractionType type,
  ) {
    return BarInteractionResult(
      barGroup: barGroup,
      barGroupIndex: barGroupIndex,
      barData: barData,
      barDataIndex: barDataIndex,
      localPosition: localPosition,
      interactionType: type,
    );
  }
}
