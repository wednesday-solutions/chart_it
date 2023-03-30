import 'package:chart_it/chart_it.dart';
import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_range.dart';
import 'package:chart_it/src/charts/widgets/core/cartesian_charts.dart';
import 'package:chart_it/src/controllers/cartesian_controller.dart';
import 'package:flutter/material.dart';

/// Draws a BarChart for the Provided Data
class BarChart extends StatefulWidget {
  /// Title of the Chart
  final Text? title;

  /// Width of the Chart
  final double? chartWidth;

  /// Height of the Chart
  final double? chartHeight;

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

  const BarChart({
    Key? key,
    this.title,
    this.chartWidth,
    this.chartHeight,
    this.animateOnLoad = true,
    this.animateOnUpdate = true,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animation,
    this.maxYValue,
    this.chartStyle,
    required this.data,
  }) : super(key: key);

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart>
    with SingleTickerProviderStateMixin {
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
    _controller.updateDataSeries([widget.data]);
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.chartStyle ?? defaultCartesianChartStyle;
    return CartesianCharts(
      controller: _controller,
      width: widget.chartWidth,
      height: widget.chartHeight,
      uMaxYValue: widget.maxYValue,
      style: style.copyWith(
        gridStyle: style.gridStyle!.copyWith(
          // Unless the user is trying to play around with the xUnitValue,
          // we will default it to the length of bar groups
          xUnitValue: style.gridStyle?.xUnitValue ?? _controller.maxXRange,
        ),
      ),
    );
  }
}
