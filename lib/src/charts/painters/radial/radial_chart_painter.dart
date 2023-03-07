import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/data/core/radial_data.dart';
import 'package:flutter_charts/src/charts/painters/radial/radial_painter.dart';
import 'package:flutter_charts/src/common/radial_observer.dart';

class RadialChartPainter extends CustomPainter {
  late double graphWidth;
  late double graphHeight;
  late Offset graphOrigin;
  late Rect graphConstraints;

  late double maxRadius;

  late double unitStep;

  final RadialChartStyle style;
  final RadialObserver observer;
  final List<RadialPainter> painters;

  RadialChartPainter({
    required this.style,
    required this.observer,
    required this.painters,
  }) : super(repaint: observer);

  @override
  bool shouldRepaint(RadialChartPainter oldDelegate) =>
      observer.shouldRepaint(oldDelegate.observer);

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate constraints for the graph
    _calculateGraphConstraints(size);
    // TODO: Construct a radial grid for polar or radar charts if required
    // Paint the background
    var bg = Paint()..color = style.backgroundColor;
    canvas.drawPaint(bg);

    // Finally we will handover canvas to the implementing painter
    // to draw plot and draw the chart data
    for (final painter in painters) {
      painter.paint(canvas, size, this);
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

    // Get the shortest side with 20% margin
    var shortestSide = graphConstraints.shortestSide * 0.8;
    // Our Largest Radius cannot escape this length
    maxRadius = shortestSide * 0.5;

    // TODO: Calculate Unit Step by bounding the max value's Circle within graph
  }
}