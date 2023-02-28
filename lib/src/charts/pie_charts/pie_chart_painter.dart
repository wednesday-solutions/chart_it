import 'dart:math';
import 'dart:ui';

import '../painters/radial_painter.dart';
import 'data_class/pie_chart_style.dart';
import 'data_class/pie_series.dart';

class PieChartPainter extends RadialPainter {
  final PieSeries pieSeries;
  final PieChartStyle chartStyle;

  PieChartPainter({required this.pieSeries, required this.chartStyle});

  @override
  void paint(Canvas canvas, Size size) {
    var circlePaint = Paint()..style = PaintingStyle.stroke;

    var total = 0.0;
    var startPoint = 0.0;
    var pointRadians = [];
    for (var data in pieSeries.pieData) {
      total += data.value;
    }
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
              radius: pieSeries.pieData[i].pieStyle?.radius ??
                  chartStyle.pieStyle.radius),
          startPoint,
          pointRadians[i],
          false,
          circlePaint);
      startPoint += pointRadians[i];
    }
  }
}
