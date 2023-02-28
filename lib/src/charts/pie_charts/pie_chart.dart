import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/common/radial_observer.dart';
import 'package:flutter_charts/src/charts/painters/radial_painter.dart';
import 'package:flutter_charts/src/charts/pie_charts/data_class/chart_style.dart';
import 'package:flutter_charts/src/charts/pie_charts/data_class/pie_chart_style.dart';
import 'package:flutter_charts/src/charts/pie_charts/data_class/pie_series.dart';
import '../painters/radial_chart_painter.dart';

class PieChart extends StatelessWidget {
  final double minValue;
  final double maxValue;
  final PieSeries pieSeries;
  final PieChartStyle chartStyle;

  const PieChart(
      {super.key,
      required this.minValue,
      required this.maxValue,
      required this.pieSeries,
      required this.chartStyle});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RadialChartPainter(
          observer: PieChartListener(minValue, maxValue),
          painters: [
            PieChartPainter(pieSeries: pieSeries, chartStyle: chartStyle)
          ]),
    );
  }
}

class PieChartListener extends RadialObserver {
  PieChartListener(double minValue, double maxValue)
      : super(minValue: minValue, maxValue: maxValue);
}

class PieChartPainter extends RadialPainter {
  final PieSeries pieSeries;
  final PieChartStyle chartStyle;

  PieChartPainter({required this.pieSeries, required this.chartStyle});

  @override
  void paint(Canvas canvas, Size size) {
    var circlePaint = Paint()..style = PaintingStyle.stroke;

    var total = 0.0;
    for (var data in pieSeries.pieData) {
      total += data.value;
    }
    var startPoint = 0.0;
    var pointRadians = [];
    for (var data in pieSeries.pieData) {
      pointRadians.add(data.value * 2 * pi / total);
    }
    for (var i = 0; i < pointRadians.length; i++) {
      circlePaint.strokeWidth =
          (pieSeries.pieData[i].pieStyle?.width ?? chartStyle.pieStyle.width);
      circlePaint.color = (pieSeries.pieData[i].pieStyle?.pieceColor ??
          (chartStyle.pieStyle.pieceColor));
      canvas.drawArc(
          Rect.fromCircle(
              center: Offset((size.width / 2), (size.height / 2)),
              radius: pieSeries.pieData[i].pieStyle?.radius ?? chartStyle.pieStyle.radius),
          startPoint,
          pointRadians[i],
          false,
          circlePaint);
      startPoint += pointRadians[i];
    }
  }
}
