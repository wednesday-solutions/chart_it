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
  final CartesianChartStyle? chartStyle;
  final BarSeries data;

  const BarChart({
    Key? key,
    this.title,
    this.chartWidth,
    this.chartHeight,
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
    var minXValue = 0.0;
    var maxXValue = widget.data.barData.length.toDouble();

    var minYValue = double.infinity;
    var maxYValue = 0.0;
    // We need to find the min & max y value across every bar series
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

      minYValue = min(minYValue, minV);
      maxYValue = max(maxYValue, maxV);
      _maxBarsInGroup = max(_maxBarsInGroup, yValue.length);
    });

    var yMod = (widget.chartStyle ?? defaultChartStyle).gridStyle!.yUnitValue!;

    var maxXRange = maxXValue;
    var maxYRange = maxYValue;
    while (maxYRange % yMod != 0) {
      maxYRange++;
    }
    // we need to check for negative x values
    var minXRange = minXValue;
    // if (minXValue.isNegative) {
    //   while (minXRange % yMod != 0) {
    //     minXRange--;
    //   }
    // } else {
    //   // No negative x values, so min will be zero
    //   minXRange = 0.0;
    // }

    // We need to check for negative y values
    var minYRange = minYValue;
    if (minYValue.isNegative) {
      while (minYRange % yMod != 0) {
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
      maxXRange: maxXRange,
      minXRange: minXRange,
      maxYRange: maxYRange,
      minYRange: minYRange,
    );
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.chartStyle ?? defaultChartStyle;
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
      painters: <CartesianPainter>[
        BarPainter(
          data: widget.data,
          maxBarsInGroup: _maxBarsInGroup,
        ),
      ],
    );
  }
}
