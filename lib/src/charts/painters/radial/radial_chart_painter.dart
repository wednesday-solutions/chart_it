import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';
import 'package:chart_it/src/charts/state/pie_series_state.dart';
import 'package:flutter/material.dart';

class RadialChartPainter {
  late double graphWidth;
  late double graphHeight;
  late Offset graphOrigin;
  late Rect graphConstraints;

  late double maxRadius;

  late double unitStep;

  RadialChartStyle style;
  List<PaintingState> states;

  late Paint _bgPaint;

  RadialChartPainter({
    required this.style,
    required this.states,
  }) {
    _bgPaint = Paint();
  }

  void paint(Canvas canvas, Size size) {
    // Calculate constraints for the graph
    _calculateGraphConstraints(size);
    // TODO: Construct a radial grid for polar or radar charts if required
    // Paint the background
    canvas.clipRect(Offset.zero & size);
    canvas.drawPaint(_bgPaint..color = style.backgroundColor);

    // Finally for every data series, we will construct a painter and handover
    // the canvas to them to draw the data sets into the required chart
    for (var i = 0; i < states.length; i++) {
      var state = states[i];
      if (state is PieSeriesState) {
        state.painter.paint(state.data, canvas, this, state.config);
      } else {
        throw ArgumentError('No State of this type exists!');
      }
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
    var shortestSide = graphConstraints.shortestSide;
    // Our Largest Radius cannot escape this length
    maxRadius = shortestSide * 0.5;

    // TODO: Calculate Unit Step by bounding the max value's Circle within graph
  }
}
