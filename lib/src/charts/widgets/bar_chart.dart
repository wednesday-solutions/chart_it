import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/data/bars.dart';
import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/renderers/cartesian_renderer.dart';
import 'package:chart_it/src/controllers/cartesian_controller.dart';
import 'package:flutter/material.dart';

/// Draws a BarChart for the Provided Data
class BarChart extends StatefulWidget {
  /// Title of the Chart
  final Text? title;

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

  /// Maximum Value along Y-Axis
  /// Draws the Highest Value point along Positive Y-Axis
  final double? maxYValue;

  /// Styling for the Chart. Includes options like
  /// Background, Alignment, Orientation, Grid & Axis Styling, etc.
  final CartesianChartStyle? chartStyle;

  /// The Data which will be Drawn as Bars
  final BarSeries data;

  final CartesianRangeContext? rangeContext;

  const BarChart({
    Key? key,
    this.title,
    this.width,
    this.height,
    this.animateOnLoad = true,
    this.animateOnUpdate = true,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animation,
    this.maxYValue,
    this.chartStyle,
    this.rangeContext,
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

    var gridStyle =
        (widget.chartStyle?.gridStyle ?? defaultBarChartStyle.gridStyle)!;
    // Now we can provide the chart details to the observer
    _controller = CartesianController(
      targetData: [widget.data],
      animation: _provideAnimation(),
      animateOnLoad: widget.animateOnLoad,
      animateOnUpdate: widget.animateOnUpdate,
      rangeContext: widget.rangeContext,
      calculateRange: (context) {
        var maxXRange = widget.data.barData.length.toDouble();
        var maxYRange = widget.maxYValue ?? context.maxY;
        return CartesianRangeResult(
          xUnitValue: gridStyle.xUnitValue?.toDouble() ?? maxXRange,
          yUnitValue: gridStyle.yUnitValue?.toDouble() ?? maxYRange,
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
      targetData: [widget.data],
      animation: _provideAnimation(),
      animateOnLoad: widget.animateOnLoad,
      animateOnUpdate: widget.animateOnUpdate,
      rangeContext: widget.rangeContext,
    );
  }

  @override
  Widget build(BuildContext context) {
    var validStyle = widget.chartStyle ?? defaultBarChartStyle;
    var style = validStyle.copyWith(
      gridStyle: validStyle.gridStyle!.copyWith(
        // Unless the user is trying to play around with the xUnitValue,
        // we will default it to the length of bar groups
        xUnitValue: validStyle.gridStyle?.xUnitValue ?? _controller.maxXRange,
      ),
    );
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CartesianRenderer(
          width: widget.width,
          height: widget.height,
          style: style,
          currentData: _controller.currentData,
          targetData: _controller.targetData,
          painters: _controller.painters,
          configs: _controller.cachedConfigs,
          cartesianRangeData: _controller,
          interactionDispatcher: _controller,
        );
      },
    );
  }

  AnimationController _provideAnimation() =>
      widget.animation ?? _defaultAnimation
        ..duration = widget.animationDuration;
}
