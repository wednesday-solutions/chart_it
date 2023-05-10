import 'package:chart_it/src/charts/data/core.dart';
import 'package:flutter/widgets.dart';

abstract class CartesianChart extends StatefulWidget {
  /// Width of the Chart
  final double? width;

  /// Height of the Chart
  final double? height;

  /// Animates the Charts from zero values to given Data when the
  /// Chart loads for the first time.
  ///
  /// Defaults to true.
  final bool animateOnLoad;

  /// Controls if the charts should auto animate any updates to the data
  ///
  /// Defaults to true.
  final bool animateOnUpdate;

  /// The Duration for which the chart should animate
  final Duration animationDuration;

  /// A custom Animation controller to drive the chart animations
  final AnimationController? animation;

  final CartesianChartStylingData chartStylingData;

  final CartesianChartStructureData chartStructureData;

  const CartesianChart({
    Key? key,
    this.width,
    this.height,
    required this.animateOnLoad,
    required this.animateOnUpdate,
    required this.animationDuration,
    this.animation,
    this.chartStylingData = const CartesianChartStylingData(),
    this.chartStructureData = const CartesianChartStructureData(),
  }) : super(key: key);
}