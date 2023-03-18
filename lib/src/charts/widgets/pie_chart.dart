import 'dart:math';

import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/data/core/radial_data.dart';
import 'package:chart_it/src/charts/data/pie/pie_series.dart';
import 'package:chart_it/src/charts/painters/radial/pie_painter.dart';
import 'package:chart_it/src/charts/painters/radial/radial_painter.dart';
import 'package:chart_it/src/charts/widgets/core/radial_charts.dart';
import 'package:chart_it/src/controllers/radial_controller.dart';
import 'package:flutter/material.dart';

/// Draws a PieChart or Donut Chart for the Provided Data
class PieChart extends StatefulWidget {
  /// Title of the Chart
  final Text? title;

  /// Width of the Chart
  final double? chartWidth;

  /// Height of the Chart
  final double? chartHeight;

  /// Styling for the Chart. Includes options like
  /// Background, StartAngle, etc.
  final RadialChartStyle? chartStyle;

  /// The Data which will be Drawn as Pieces of Pie
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
  late RadialController _observer;

  @override
  void initState() {
    super.initState();

    var minValue = 0.0;
    var maxValue = double.infinity;

    for (var slice in widget.data.slices) {
      minValue = min(minValue, slice.value.toDouble());
      maxValue = max(maxValue, slice.value.toDouble());
    }

    if (minValue.isNegative) {
      throw ArgumentError("All data values must be positive!");
    }

    // Now we can provide the chart details to the observer
    _observer = RadialController(
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
