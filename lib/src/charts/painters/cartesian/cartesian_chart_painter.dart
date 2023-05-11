import 'dart:math';

import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data_internal.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/charts/painters/text/chart_text_painter.dart';
import 'package:chart_it/src/charts/state/bar_series_state.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';
import 'package:chart_it/src/extensions/data_conversions.dart';
import 'package:chart_it/src/extensions/primitives.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CartesianChartPainter {
  CartesianChartStylingData style;
  CartesianChartStructureData structure;
  List<PaintingState> states;
  GridUnitsData gridUnitsData;

  late Paint _bgPaint;
  late Paint _gridBorder;
  late Paint _gridTick;
  late Paint _axisPaint;

  CartesianChartPainter({
    required this.style,
    required this.states,
    required this.structure,
    required this.gridUnitsData,
  }) {
    _bgPaint = Paint();
    _gridBorder = Paint()..style = PaintingStyle.stroke;
    _gridTick = Paint()..style = PaintingStyle.stroke;
    _axisPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
  }

  void paint(Canvas canvas, Size size, CartesianPaintingGeometryData paintingGeometryData) {
    // we will construct a painter and handover
    // the canvas to them to draw the data sets into the required chart
    for (var i = 0; i < states.length; i++) {
      var state = states[i];
      if (state is BarSeriesState) {
        state.painter.paint(
          lerpSeries: state.data,
          canvas: canvas,
          chart: paintingGeometryData,
          config: state.config,
          style: style,
        );
      } else {
        throw ArgumentError('No State of this type exists!');
      }
    }
  }
}

