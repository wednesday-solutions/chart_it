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

  late double unitWidth;
  late double unitHeight;

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
      ..color = style.gridStyle!.strokeColor
      ..strokeWidth = style.gridStyle!.strokeWidth
      ..style = PaintingStyle.stroke;

    var x = graphPolygon.left;
    // create vertical lines
    for (var i = 0; i <= _xUnitsCount; i++) {
      var p1 = Offset(x, graphPolygon.bottom);
      var p2 = Offset(x, graphPolygon.top);
      canvas.drawLine(p1, p2, border);

      x += unitWidth;
    }

    // create horizontal lines
    for (var i = 0; i <= _yUnitsCount; i++) {
      var y = graphPolygon.bottom - unitHeight * i;

      var p1 = Offset(graphPolygon.left, y);
      var p2 = Offset(graphPolygon.right, y);
      canvas.drawLine(p1, p2, border);
    }
  }

  void _drawAxis(Canvas canvas, Size size) {
    var axisPaint = Paint()
      ..color = style.axisStyle!.strokeColor
      ..strokeWidth = style.axisStyle!.strokeWidth
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

    canvas.drawPath(axis, axisPaint);

    var x = graphPolygon.left;
    var maxIterations = max(_xUnitsCount, _yUnitsCount);

    for (var i = 0; i <= maxIterations; i++) {
      // We will plot texts and point along both X & Y axis
      if (i <= _xUnitsCount) {
        canvas.drawText(
          Offset(x, graphPolygon.bottom + 15),
          text: TextSpan(text: i.toString()),
        );

        // increment by unitWidth every iteration along x
        x += unitWidth;
      }

      if (i <= _yUnitsCount) {
        canvas.drawText(
          Offset(graphPolygon.left - 15, graphPolygon.bottom - unitHeight * i),
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

    xUnitValue = style.gridStyle!.xUnitValue.toDouble();
    yUnitValue = style.gridStyle!.yUnitValue.toDouble();

    // TODO: Consider for Negative Values along X-Axis
    totalXRange = observer.maxXRange;
    if ((totalXRange / xUnitValue) >= 1.0) {
      // We need to ensure that our unitCount is atleast 1 or greater otherwise
      // otherwise our unitWidth & unitHeight are not calculated properly
      _xUnitsCount = totalXRange / xUnitValue;
    } else {
      _xUnitsCount = xUnitValue;
    }

    totalYRange = observer.maxYRange + observer.minYRange.abs();
    if ((totalYRange / yUnitValue) >= 1.0) {
      // We need to ensure that our unitCount is atleast 1 or greater otherwise
      // otherwise our unitWidth & unitHeight are not calculated properly
      _yUnitsCount = totalYRange / yUnitValue;
    } else {
      _yUnitsCount = yUnitValue;
    }

    // We will get unitWidth & unitHeight by dividing the
    // graphWidth & graphHeight into X parts
    unitWidth = graphWidth / _xUnitsCount;
    unitHeight = graphHeight / _yUnitsCount;

    // TODO: Consider Negative X Range and Offset
    var negativeYRange = (observer.minYRange.abs() / yUnitValue) * unitHeight;
    var yOffset = graphPolygon.bottom - negativeYRange;
    axisOrigin = Offset(graphPolygon.left, yOffset);
  }
}
