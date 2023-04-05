import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/data/bars/bar_series.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_range.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_styling.dart';
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

  // final CartesianRangeContext? rangeContext;

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
    // this.rangeContext,
    required this.data,
  }) : super(key: key);

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> with TickerProviderStateMixin {
  late CartesianController _controller;

  @override
  void initState() {
    super.initState();
    // Now we can provide the chart details to the observer
    _controller = CartesianController(
      targetData: [widget.data],
      animateOnLoad: widget.animateOnLoad,
      animateOnUpdate: widget.animateOnUpdate,
      animation: widget.animation ??
          AnimationController(
            duration: widget.animationDuration,
            vsync: this,
          ),
      calculateRange: (context) {
        var gridStyle = (widget.chartStyle?.gridStyle ??
            defaultCartesianChartStyle.gridStyle)!;
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
      animateOnLoad: widget.animateOnLoad,
      animateOnUpdate: widget.animateOnUpdate,
      animation: widget.animation ??
          AnimationController(
            duration: widget.animationDuration,
            vsync: this,
          ),
      // rangeContext: widget.rangeContext,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        var style = widget.chartStyle ?? defaultCartesianChartStyle;
        return CartesianRenderer(
          width: widget.width,
          height: widget.height,
          style: style.copyWith(
            gridStyle: style.gridStyle!.copyWith(
              // Unless the user is trying to play around with the xUnitValue,
              // we will default it to the length of bar groups
              xUnitValue: style.gridStyle?.xUnitValue ?? _controller.maxXRange,
            ),
          ),
          currentData: _controller.currentData,
          targetData: _controller.targetData,
          painters: _controller.painters,
          configs: _controller.cachedConfigs,
          cartesianRangeData: _controller,
        );
      },
    );
  }
}
