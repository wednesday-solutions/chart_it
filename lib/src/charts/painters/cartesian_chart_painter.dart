import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/painters/cartesian_painter.dart';
import 'package:flutter_charts/src/common/cartesian_observer.dart';

class CartesianChartPainter extends CustomPainter {
  late double graphWidth;
  late double graphHeight;
  late Offset graphOrigin;
  late Rect graphConstraints;

  late double unitWidth;
  late double unitHeight;

  final CartesianObserver observer;
  final List<CartesianPainter> painters;

  CartesianChartPainter({
    required this.observer,
    required this.painters,
  }) : super(repaint: observer);

  @override
  bool shouldRepaint(CartesianChartPainter oldDelegate) =>
      observer.shouldRepaint(oldDelegate.observer);

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate constraints for the graph
    _calculateGraphConstraints(size);

    // TODO: Create a function for this to handle background
    var bg = Paint()..color = Colors.cyan;
    canvas.drawPaint(bg);

    _drawGridLines(canvas, size);

    // Finally we will handover canvas to the implementing painter
    // to draw plot and draw the chart data
    painters.forEach((painter) {
      painter.paint(canvas, size);
    });
  }

  void _drawGridLines(Canvas canvas, Size size) {
    var border = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    var x = graphConstraints.left;
    // create vertical lines
    for (var i = 0; i <= 10; i++) {
      var p1 = Offset(x, graphConstraints.bottom);
      var p2 = Offset(x, graphConstraints.top);
      canvas.drawLine(p1, p2, border);

      x += unitWidth;
    }

    // create horizontal lines
    for (var i = 0; i <= 10; i++) {
      var y = graphConstraints.bottom - unitHeight * i;

      var p1 = Offset(graphConstraints.left, y);
      var p2 = Offset(graphConstraints.right, y);
      canvas.drawLine(p1, p2, border);
    }
  }

  _calculateGraphConstraints(Size widgetSize) {
    // TODO: Calculate the effective width & height of the graph
    graphOrigin = Offset(widgetSize.width * 0.5, widgetSize.height * 0.5);
    graphWidth = widgetSize.width * 0.8;
    graphHeight = widgetSize.height * 0.8;

    graphConstraints = Rect.fromCenter(
      center: graphOrigin,
      width: graphWidth,
      height: graphHeight,
    );

    // We will get unitWidth & unitHeight by dividing the
    // graphWidth & graphHeight into X parts
    unitWidth = graphWidth / 10;
    unitHeight = graphHeight / 10;
  }
}
