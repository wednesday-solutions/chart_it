import 'dart:math';

import 'package:chart_it/chart_it.dart';
import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/painters/cartesian/bar_painter.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/charts/widgets/core/cartesian_charts.dart';
import 'package:chart_it/src/common/cartesian_observer.dart';
import 'package:chart_it/src/extensions/data_conversions.dart';
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
  final bool onLoadAnimate;

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
    this.onLoadAnimate = true,
    this.maxYValue,
    this.chartStyle,
    required this.data,
  }) : super(key: key);

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> with TickerProviderStateMixin {
  late CartesianObserver _observer;
  var _maxBarsInGroup = 0;

  @override
  void initState() {
    super.initState();
    // For Bar charts, we normally don't consider x values, be it +ve or -ve
    var calculatedMinXValue = 0.0;
    var calculatedMaxXValue = widget.data.barData.length.toDouble();

    var calculatedMinYValue = double.infinity;
    var calculatedMaxYValue = 0.0;
    // We need to find the min & max y value across every bar series
    // In case, the user hasn't provided these values, we need to calculate them
    for (final group in widget.data.barData) {
      var yValue = group.yValues();

      var minV = double.infinity;
      var maxV = 0.0;

      if (group is MultiBar && group.arrangement == BarGroupArrangement.stack) {
        minV = min(minV, 0);
        // For a stack, the y value of the bar is the total of all bars
        maxV = max(maxV, yValue.fold(0, (a, b) => a + b.yValue));
      } else {
        for (final data in yValue) {
          minV = min(minV, data.yValue.toDouble());
          maxV = max(maxV, data.yValue.toDouble());
        }
      }

      calculatedMinYValue = min(calculatedMinYValue, minV);
      calculatedMaxYValue = max(calculatedMaxYValue, maxV);
      _maxBarsInGroup = max(_maxBarsInGroup, yValue.length);
    }

    // Finally we will collect our user provided min/max values
    // and the ones that we have calculated
    var maxYValue = widget.maxYValue ?? calculatedMaxYValue;
    var minYValue = calculatedMinYValue;

    var unit = (widget.chartStyle ?? defaultCartesianChartStyle)
        .gridStyle!
        .yUnitValue!;
    var maxYRange = maxYValue;
    while (maxYRange % unit != 0) {
      maxYRange++;
    }

    // We need to check for negative y values
    var minYRange = minYValue;
    if (minYValue.isNegative) {
      while (minYRange % unit != 0) {
        minYRange--;
      }
    } else {
      // No negative y values, so min will be zero
      minYRange = 0.0;
    }

    // Now we can provide the chart details to the observer
    _observer = CartesianObserver(
      data: [widget.data],
      onLoadAnimate: widget.onLoadAnimate,
      animation: AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      ),
      minValue: minYValue,
      maxValue: maxYValue,
      maxXRange: calculatedMaxXValue,
      minXRange: calculatedMinXValue,
      maxYRange: maxYRange,
      minYRange: minYRange,
    );
  }

  @override
  void didUpdateWidget(covariant BarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // We will update our Chart when new data is provided
    _observer.updateDataSeries([widget.data]);
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.chartStyle ?? defaultCartesianChartStyle;
    return CartesianCharts(
      observer: _observer,
      width: widget.chartWidth,
      height: widget.chartHeight,
      style: style.copyWith(
        gridStyle: style.gridStyle!.copyWith(
          // Unless the user is trying to play around with the xUnitValue,
          // we will default it to the length of bar groups
          xUnitValue: style.gridStyle?.xUnitValue ?? _observer.maxXRange,
        ),
      ),
      constructPainters: (data) {
        // TODO: In BarChart Widget, we know we can only have Data Series of
        // BarChart, but in Multi-Chart we will have to type assert and
        // return the appropriate painter for the type of data series
        return BarPainter(
          data: series as BarSeries,
          useGraphUnits: false,
          maxBarsInGroup: _maxBarsInGroup,
        );
      },
      // painters: <CartesianPainter>[
      //   BarPainter(
      //     data: widget.data,
      //     useGraphUnits: false,
      //     maxBarsInGroup: _maxBarsInGroup,
      //   ),
      // ],
    );
  }
}
