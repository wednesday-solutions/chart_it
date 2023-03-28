import 'package:chart_it/src/charts/data/core/radial/radial_styling.dart';
import 'package:chart_it/src/controllers/radial_controller.dart';
import 'package:chart_it/src/extensions/primitives.dart';
import 'package:flutter/material.dart';

class RadialChartPainter extends CustomPainter {
  late double graphWidth;
  late double graphHeight;
  late Offset graphOrigin;
  late Rect graphConstraints;

  late double maxRadius;

  late double unitStep;

  final RadialChartStyle style;
  final RadialController controller;

  RadialChartPainter({
    required this.style,
    required this.controller,
  }) : super(repaint: controller);

  @override
  bool shouldRepaint(RadialChartPainter oldDelegate) =>
      controller.shouldRepaint(oldDelegate.controller);

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate constraints for the graph
    _calculateGraphConstraints(size);
    // TODO: Construct a radial grid for polar or radar charts if required
    // Paint the background
    var bg = Paint()..color = style.backgroundColor;
    canvas.drawPaint(bg);

    // Finally for every data series, we will construct a painter and handover
    // the canvas to them to draw the data sets into the required chart
    controller.targetData.forEachIndexed((index, series) {
      // get the painter for this data
      var painter = controller.painters[series.runtimeType];
      if (painter != null) {
        // and paint the chart for given series
        painter.paint(controller.currentData[index], series, canvas, this);
      } else {
        throw ArgumentError(
          'Illegal State: No painter found for series type: ${series.runtimeType}',
        );
      }
    });
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
    var shortestSide = graphConstraints.shortestSide;
    // Our Largest Radius cannot escape this length
    maxRadius = shortestSide * 0.5;

    // TODO: Calculate Unit Step by bounding the max value's Circle within graph
  }
}
