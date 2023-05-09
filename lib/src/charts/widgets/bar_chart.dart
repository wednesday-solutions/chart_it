import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/data/bars.dart';
import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/renderers/cartesian_renderer.dart';
import 'package:chart_it/src/controllers/cartesian_controller.dart';
import 'package:flutter/material.dart';

class CartesianChart extends StatefulWidget {
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

  @override
  State<CartesianChart> createState() => _CartesianChartState();
}

class _CartesianChartState extends State<CartesianChart> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

/// Draws a BarChart for the Provided Data
class BarChart extends CartesianChart {
  /// Title of the Chart
  final Text? title;

  /// The Data which will be Drawn as Bars
  final BarSeries data;

  const BarChart({
    Key? key,
    this.title,
    super.width,
    super.height,
    super.animateOnLoad = true,
    super.animateOnUpdate = true,
    super.animationDuration = const Duration(milliseconds: 500),
    super.animation,
    super.chartStructureData,
    super.chartStylingData,
    required this.data,
  }) : super(key: key);

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart>
    with SingleTickerProviderStateMixin {
  late CartesianController _controller;
  late AnimationController _defaultAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize default animation controller
    _defaultAnimation = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    var structure = widget.chartStructureData;
    // Now we can provide the chart details to the observer
    _controller = CartesianController(
      data: [widget.data],
      animation: _provideAnimation(),
      animateOnLoad: widget.animateOnLoad,
      animateOnUpdate: widget.animateOnUpdate,
      structureData: widget.chartStructureData,
      calculateRange: (context) {
        var maxXRange = widget.data.barData.length.toDouble();
        var maxYRange = widget.chartStructureData.maxYValue?.toDouble() ?? context.maxY;
        return CartesianRangeResult(
          xUnitValue: structure.xUnitValue.toDouble() ?? maxXRange,
          yUnitValue: structure.yUnitValue.toDouble() ?? maxYRange,
          // For Bar charts, we don't consider x values, be it +ve or -ve
          minXRange: 0,
          maxXRange: maxXRange,
          minYRange: context.minY,
          maxYRange: maxYRange,
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant BarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // We will update our Chart when new data is provided
    _controller.update(
        data: [widget.data],
        animation: _provideAnimation(),
        animateOnLoad: widget.animateOnLoad,
        animateOnUpdate: widget.animateOnUpdate,
        structureData: widget.chartStructureData);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CartesianRenderer(
          width: widget.width,
          height: widget.height,
          style: widget.chartStylingData.copyWith(
            backgroundColor: widget.chartStylingData.backgroundColor ??
                Theme.of(context).colorScheme.background,
          ),
          structure: widget.chartStructureData,
          states: _controller.currentData.states,
          rangeData: _controller.currentData.range,
          gridUnitsData: _controller.currentData.gridUnitsData,
          interactionDispatcher: _controller,
        );
      },
    );
  }

  AnimationController _provideAnimation() =>
      widget.animation ?? _defaultAnimation
        ..duration = widget.animationDuration;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
