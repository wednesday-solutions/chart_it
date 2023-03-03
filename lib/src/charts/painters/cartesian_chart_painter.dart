import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:flutter_charts/src/charts/painters/cartesian_painter.dart';
import 'package:flutter_charts/src/common/cartesian_observer.dart';
import 'package:flutter_charts/src/extensions/paint_text.dart';

class CartesianChartPainter extends CustomPainter {
  late Rect graphPolygon;
  late double graphHeight;
  late double graphWidth;
  late Offset graphOrigin;
  late Offset axisOrigin;

  late double graphUnitWidth;
  late double graphUnitHeight;

  late double valueUnitWidth;
  late double valueUnitHeight;

  late double xUnitValue;
  late double _xUnitsCount;
  late double totalXRange;

  late double yUnitValue;
  late double _yUnitsCount;
  late double totalYRange;

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

    // We will draw axis on top of the painted chart data.
    _drawAxis(canvas, size);
  }

  void _drawGridLines(Canvas canvas, Size size) {
    var border = Paint()
      ..color = style.gridStyle!.gridLineColor
      ..strokeWidth = style.gridStyle!.gridLineWidth
      ..style = PaintingStyle.stroke;

    var tickPaint = Paint()
      ..color = style.axisStyle!.tickColor
      ..strokeWidth = style.axisStyle!.tickWidth
      ..style = PaintingStyle.stroke;

    var x = graphPolygon.left;
    // create vertical lines
    for (var i = 0; i <= _xUnitsCount; i++) {
      var p1 = Offset(x, graphPolygon.bottom);
      var p2 = Offset(x, graphPolygon.top);
      canvas.drawLine(p1, p2, border);

      // Draw ticks along x-axis
      canvas.drawLine(
        p1,
        Offset(p1.dx, p1.dy + style.axisStyle!.tickLength),
        tickPaint,
      );

      x += graphUnitWidth;
    }

    // create horizontal lines
    for (var i = 0; i <= _yUnitsCount; i++) {
      var y = graphPolygon.bottom - graphUnitHeight * i;

      var p1 = Offset(graphPolygon.left, y);
      var p2 = Offset(graphPolygon.right, y);
      canvas.drawLine(p1, p2, border);

      // Draw ticks along y-axis
      canvas.drawLine(
        p1,
        Offset(p1.dx - style.axisStyle!.tickLength, p1.dy),
        tickPaint,
      );
    }
  }

  void _drawAxis(Canvas canvas, Size size) {
    var axisPaint = Paint()
      ..color = style.axisStyle!.axisColor
      ..strokeWidth = style.axisStyle!.axisWidth
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // We will use a L shaped path for the Axes
    var axis = Path();
    axis.moveTo(graphPolygon.topLeft.dx, graphPolygon.topLeft.dy);
    axis.lineTo(axisOrigin.dx, axisOrigin.dy); // +ve y axis
    axis.lineTo(graphPolygon.right, axisOrigin.dy); // +ve x axis

    if (observer.minYRange.isNegative) {
      // Paint negative Y-axis if we have negative values
      axis.moveTo(graphPolygon.bottomLeft.dx, graphPolygon.bottomLeft.dy);
      axis.lineTo(axisOrigin.dx, axisOrigin.dy); // -ve y axis
    }

    if (observer.minXRange.isNegative) {
      // Paint negative X-axis if we have Negative values
      axis.lineTo(graphPolygon.left, axisOrigin.dy); // -ve x axis
    }

    canvas.drawPath(axis, axisPaint);
    drawLabels(canvas);
  }

  void drawLabels(Canvas canvas) {
    var x = graphPolygon.left;
    var maxIterations = max(_xUnitsCount, _yUnitsCount);
    var showXLabels = style.axisStyle?.showXAxisLabels ?? true;
    var showYLabels = style.axisStyle?.showYAxisLabels ?? true;

    for (var i = 0; i <= maxIterations; i++) {
      // We will plot texts and point along both X & Y axis
      if (showXLabels && i <= _xUnitsCount) {
        canvas.drawText(
          Offset(x, graphPolygon.bottom + style.axisStyle!.tickLength + 15),
          text: TextSpan(text: i.toString()),
        );

        // increment by unitWidth every iteration along x
        x += graphUnitWidth;
      }

      if (showYLabels && i <= _yUnitsCount) {
        canvas.drawText(
          Offset(
            graphPolygon.left - style.axisStyle!.tickLength - 15,
            graphPolygon.bottom - graphUnitHeight * i,
          ),
          text: TextSpan(
              text: (observer.minYRange + (yUnitValue * i)).toString()),
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

    xUnitValue = style.gridStyle!.xUnitValue!.toDouble();
    yUnitValue = style.gridStyle!.yUnitValue!.toDouble();

    totalXRange = observer.maxXRange.abs() + observer.minXRange.abs();
    _xUnitsCount = totalXRange / xUnitValue;

    totalYRange = observer.maxYRange.abs() + observer.minYRange.abs();
    _yUnitsCount = totalYRange / yUnitValue;

    // We will get unitWidth & unitHeight by dividing the
    // graphWidth & graphHeight into X parts
    graphUnitWidth = graphWidth / _xUnitsCount;
    graphUnitHeight = graphHeight / _yUnitsCount;

    // Get the unitValue if the data range was within the graph's constraints
    valueUnitWidth = graphWidth / totalXRange;
    valueUnitHeight = graphHeight / totalYRange;

    // Calculate the Offset for Axis Origin
    var negativeXRange =
        (observer.minXRange.abs() / xUnitValue) * graphUnitWidth;
    var negativeYRange =
        (observer.minYRange.abs() / yUnitValue) * graphUnitHeight;
    var xOffset = graphPolygon.left + negativeXRange;
    var yOffset = graphPolygon.bottom - negativeYRange;
    axisOrigin = Offset(xOffset, yOffset);
  }
}
