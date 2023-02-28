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

  @override
  void initState() {
    super.initState();
    // We need to find the min & max y value across every bar series
    var minYValue = double.infinity;
    var maxYValue = 0.0;
    widget.data.barData.forEach((group) {
      var yValue = group.yValues();

      var minV = double.infinity;
      var maxV = 0.0;
      yValue.forEach((data) {
        // minimum y value in this iteration
        minV = min(minV, data.yValue.toDouble());
        // maximum y value in this iteration
        maxV = max(maxV, data.yValue.toDouble());
      });

      minYValue = min(minYValue, minV);
      maxYValue = max(maxYValue, maxV);
    });

    var moderator = widget.chartStyle?.gridStyle?.yUnitValue ??
        defaultChartStyle.gridStyle!.yUnitValue;

    var maxYRange = maxYValue;
    while (maxYRange % moderator != 0) {
      maxYRange++;
    }

    // Now we can provide the chart details to the observer
    _observer = CartesianObserver(
      minValue: minYValue,
      maxValue: maxYValue,
      xRange: widget.data.barData.length.toDouble(),
      yRange: maxYRange,
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
        BarPainter(data: widget.data),
      ],
    );
  }
}
