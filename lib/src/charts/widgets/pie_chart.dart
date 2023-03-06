import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/constants/defaults.dart';
import 'package:flutter_charts/src/charts/data/core/radial_data.dart';
import 'package:flutter_charts/src/charts/data/pie/pie_series.dart';
import 'package:flutter_charts/src/charts/painters/radial/pie_painter.dart';
import 'package:flutter_charts/src/charts/painters/radial/radial_painter.dart';
import 'package:flutter_charts/src/charts/widgets/core/radial_charts.dart';
import 'package:flutter_charts/src/common/radial_observer.dart';

class PieChart extends StatefulWidget {
  final Text? title;
  final double? chartWidth;
  final double? chartHeight;
  final RadialChartStyle? chartStyle;
  final PieSeries data;

  const PieChart({
    Key? key,
    this.title,
    this.chartWidth,
    this.chartHeight,
    this.chartStyle,
    required this.data,
  }) : super(key: key);

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  late RadialObserver _observer;

  @override
  void initState() {
    super.initState();

    var minValue = 0.0;
    var maxValue = double.infinity;

    widget.data.slices.forEach((slice) {
      minValue = min(minValue, slice.value.toDouble());
      maxValue = max(maxValue, slice.value.toDouble());
    });

    if (minValue.isNegative) {
      throw ArgumentError("All data values must be positive!");
    }

    // Now we can provide the chart details to the observer
    _observer = RadialObserver(
      minValue: minValue,
      maxValue: maxValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.chartStyle ?? defaultRadialChartStyle;
    return RadialCharts(
      observer: _observer,
      width: widget.chartWidth,
      height: widget.chartHeight,
      style: style,
      painters: <RadialPainter>[
        PiePainter(
          data: widget.data,
        ),
      ],
    );
  }
}
