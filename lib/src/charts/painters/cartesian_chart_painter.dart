import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:flutter_charts/src/charts/painters/cartesian_painter.dart';
import 'package:flutter_charts/src/common/cartesian_observer.dart';
import 'package:flutter_charts/src/extensions/paint_text.dart';

class CartesianChartPainter extends CustomPainter {
  late double graphWidth;
  late double graphHeight;
  late Offset graphOrigin;
  late Rect graphPolygon;

  late double unitWidth;
  late double unitHeight;

  late int xUnitsCount;
  late int yUnitsCount;

  final CartesianChartStyle style;
  final CartesianObserver observer;
  final List<CartesianPainter> painters;

  CartesianChartPainter({
    required this.style,
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

    // Paint the background
    var bg = Paint()..color = style.backgroundColor;
    canvas.drawPaint(bg);

    _drawGridLines(canvas, size);

    // Finally we will handover canvas to the implementing painter
    // to draw plot and draw the chart data
    painters.forEach((painter) {
      painter.paint(canvas, size, this);
    });
  }

  void _drawGridLines(Canvas canvas, Size size) {
    var border = Paint()
      ..color = style.gridStyle!.strokeColor
      ..strokeWidth = style.gridStyle!.strokeWidth
      ..style = PaintingStyle.stroke;

    var x = graphPolygon.left;
    // create vertical lines
    for (var i = 0; i <= xUnitsCount; i++) {
      var p1 = Offset(x, graphPolygon.bottom);
      var p2 = Offset(x, graphPolygon.top);
      canvas.drawLine(p1, p2, border);

      x += unitWidth;
    }

    // create horizontal lines
    for (var i = 0; i <= yUnitsCount; i++) {
      var y = graphPolygon.bottom - unitHeight * i;

      var p1 = Offset(graphPolygon.left, y);
      var p2 = Offset(graphPolygon.right, y);
      canvas.drawLine(p1, p2, border);
    }
  }

  void drawAxis(Canvas canvas, Size size) {
    var axisPaint = Paint()
      ..color = style.axisStyle!.strokeColor
      ..strokeWidth = style.axisStyle!.strokeWidth
      ..style = PaintingStyle.stroke;

    // We will use a L shaped path for the Axes
    var axis = Path();
    axis.moveTo(graphPolygon.topLeft.dx, graphPolygon.topLeft.dy);

    axis.lineTo(
        graphPolygon.bottomLeft.dx, graphPolygon.bottomLeft.dy); // y axis
    axis.lineTo(
        graphPolygon.bottomRight.dx, graphPolygon.bottomRight.dy); // x axis
    canvas.drawPath(axis, axisPaint);

    var x = graphPolygon.left;
    var halfWidth = unitWidth * 0.5;
    var maxIterations = max(xUnitsCount, yUnitsCount);

    for (var i = 0; i <= maxIterations; i++) {
      // We will plot texts and point along both X & Y axis
      if (i <= xUnitsCount) {
        canvas.drawText(
          Offset(i == 0 ? (x - 15) : x, graphPolygon.bottom + 15),
          text: TextSpan(text: i.toString()),
        );

        // increment by unitWidth every iteration along x
        x += unitWidth;
      }

      if (i > 0 && i <= yUnitsCount) {
        canvas.drawText(
          Offset(graphPolygon.left - 15, graphPolygon.bottom - unitHeight * i),
          text:
              TextSpan(text: ((observer.yRange / yUnitsCount) * i).toString()),
          align: TextAlign.end,
        );
      }
    }
  }

  _calculateGraphConstraints(Size widgetSize) {
    // TODO: Calculate the effective width & height of the graph
    graphOrigin = Offset(widgetSize.width * 0.5, widgetSize.height * 0.5);
    graphWidth = widgetSize.width * 0.8;
    graphHeight = widgetSize.height * 0.8;

    graphPolygon = Rect.fromCenter(
      center: graphOrigin,
      width: graphWidth,
      height: graphHeight,
    );

    xUnitsCount = style.gridStyle!.xUnitsCount;
    yUnitsCount = style.gridStyle!.yUnitsCount;

    // We will get unitWidth & unitHeight by dividing the
    // graphWidth & graphHeight into X parts
    unitWidth = graphWidth / xUnitsCount;
    unitHeight = graphHeight / yUnitsCount;
  }
}
