import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:flutter_charts/src/charts/data/core/raw_data.dart';
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
  late List<RawSeries> _strippedData;
  late CartesianObserver _observer;

  @override
  void initState() {
    super.initState();
    // First we will get all of our data in raw
    _strippedData = widget.data.barData.rawData();
    // We need to find the min & max y value across every bar series
    var yValues = _strippedData.map((v) => v.yValues).toList();
    var minYValue = yValues.map((e) => e.fold(0, min)).reduce(min).toDouble();
    var maxYValue = yValues.map((e) => e.fold(0, max)).reduce(max).toDouble();

    var maxYRange = maxYValue;
    while (maxYRange % 10 != 0) {
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
      painters: <CartesianPainter>[
        BarPainter(),
      ],
    );
  }
}
