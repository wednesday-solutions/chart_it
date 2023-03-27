import 'package:chart_it/chart_it.dart';
import 'package:chart_it/src/charts/constants/defaults.dart';
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
  final bool autoAnimate;

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
    this.autoAnimate = true,
    this.maxYValue,
    this.chartStyle,
    required this.data,
  }) : super(key: key);

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> with TickerProviderStateMixin {
  late CartesianController _controller;

  // var _maxBarsInGroup = 0;

  @override
  void initState() {
    super.initState();
    // Now we can provide the chart details to the observer
    _controller = CartesianController(
      targetData: [widget.data],
      animateOnLoad: widget.animateOnLoad,
      autoAnimate: widget.autoAnimate,
      animation: AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      ),
      rangeConstraints: (c) {
        // For Bar charts, we normally don't consider x values, be it +ve or -ve
        c.maxXValue = widget.data.barData.length.toDouble();
        // Finally we will collect our user provided min/max values
        // and the ones that we have calculated
        c.maxXRange = c.maxXValue;
        c.minXRange = c.minXValue;
        var minYValue = c.minYValue;

        var yUnit = (widget.chartStyle?.gridStyle ??
                defaultCartesianChartStyle.gridStyle)!
            .yUnitValue!;

        var maxYRange = widget.maxYValue ?? c.maxYValue;
        while (maxYRange % yUnit != 0) {
          maxYRange++;
        }
        c.maxYRange = maxYRange;

        // We need to check for negative y values
        var minYRange = minYValue;
        if (minYValue.isNegative) {
          while (minYRange % yUnit != 0) {
            minYRange--;
          }
        } else {
          // No negative y values, so min will be zero
          minYRange = 0.0;
        }
        c.minYRange = minYRange;
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
