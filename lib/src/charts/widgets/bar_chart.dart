import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:flutter_charts/src/charts/constants/defaults.dart';
import 'package:flutter_charts/src/charts/painters/bar_painter.dart';
import 'package:flutter_charts/src/charts/painters/cartesian_painter.dart';
import 'package:flutter_charts/src/charts/widgets/core/cartesian_charts.dart';
import 'package:flutter_charts/src/common/cartesian_observer.dart';
import 'package:flutter_charts/src/extensions/data_conversions.dart';

class BarChart extends StatefulWidget {
  final Text? title;
  final double? chartWidth;
  final double? chartHeight;
  final double? minYValue;
  final double? maxYValue;
  final double yUnitValue;
  final CartesianChartStyle? chartStyle;
  final BarSeries data;

  const BarChart({
    Key? key,
    this.title,
    this.chartWidth,
    this.chartHeight,
    this.minYValue,
    this.maxYValue,
    this.yUnitValue = 10.0,
    this.chartStyle,
    required this.data,
  }) : super(key: key);

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  late CartesianObserver _observer;
  var _maxBarsInGroup = 0;

  @override
  void initState() {
    super.initState();
    // For Bar charts, we normally don't consider x values, be it +ve or -ve
    var cMinXValue = 0.0;
    var cMaxXValue = widget.data.barData.length.toDouble();

    var cMinYValue = double.infinity;
    var cMaxYValue = 0.0;
    // We need to find the min & max y value across every bar series
    // In case, the user hasn't provided these values, we need to calculate them
    widget.data.barData.forEach((group) {
      var yValue = group.yValues();

      var minV = double.infinity;
      var maxV = 0.0;

      if (group is MultiBar && group.arrangement == BarGroupArrangement.stack) {
        minV = min(minV, 0);
        // For a stack, the y value of the bar is the total of all bars
        maxV = max(maxV, yValue.fold(0, (a, b) => a + b.yValue));
      } else {
        yValue.forEach((data) {
          minV = min(minV, data.yValue.toDouble());
          maxV = max(maxV, data.yValue.toDouble());
        });
      }

      cMinYValue = min(cMinYValue, minV);
      cMaxYValue = max(cMaxYValue, maxV);
      _maxBarsInGroup = max(_maxBarsInGroup, yValue.length);
    });

    // Finally we will collect our user provided min/max values
    // and the ones that we have calculated
    var minYValue = widget.minYValue ?? cMinYValue;
    var maxYValue = widget.maxYValue ?? cMaxXValue;

    var moderator = widget.yUnitValue;
    var maxYRange = maxYValue;
    while (maxYRange % moderator != 0) {
      maxYRange++;
    }

    // We need to check for negative y values
    var minYRange = minYValue;
    if (minYValue.isNegative) {
      while (minYRange % moderator != 0) {
        minYRange--;
      }
    } else {
      // No negative y values, so min will be zero
      minYRange = 0.0;
    }

    // Now we can provide the chart details to the observer
    _observer = CartesianObserver(
      minValue: minYValue,
      maxValue: maxYValue,
      xUnitValue: cMaxXValue,
      yUnitValue: widget.yUnitValue,
      maxXRange: cMaxXValue,
      minXRange: cMinXValue,
      maxYRange: maxYRange,
      minYRange: minYRange,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CartesianCharts(
      observer: _observer,
      width: widget.chartWidth,
      height: widget.chartHeight,
      style: widget.chartStyle ?? defaultChartStyle,
      painters: <CartesianPainter>[
        BarPainter(
          data: widget.data,
          maxBarsInGroup: _maxBarsInGroup,
        ),
      ],
    );
  }
}
