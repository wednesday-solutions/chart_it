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
    var pointRadians = 0.0;
    for (var data in pieSeries.pieData) {
      total += data.value;
    }
    for (var data in pieSeries.pieData) {
      pointRadians = (data.value * 2 * pi) / total;
      circlePaint.strokeWidth =
          (data.pieStyle?.width ?? chartStyle.pieSeriesStyle.width);
      circlePaint.color =
          (data.pieStyle?.pieceColor ?? (chartStyle.pieSeriesStyle.pieceColor));
      canvas.drawArc(
          Rect.fromCircle(
              center: Offset((size.width / 2), (size.height / 2)),
              radius: data.pieStyle?.radius ?? chartStyle.pieSeriesStyle.radius),
          startPoint,
          pointRadians,
          false,
          circlePaint);
      startPoint += pointRadians;
    }
  }
}
