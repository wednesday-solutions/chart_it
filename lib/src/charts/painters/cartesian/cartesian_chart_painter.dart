import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data_internal.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_grid_units.dart';
import 'package:chart_it/src/charts/state/bar_series_state.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';
import 'package:flutter/material.dart';

class CartesianChartPainter {
  CartesianChartStylingData style;
  CartesianChartStructureData structure;
  List<PaintingState> states;
  CartesianGridUnitsData gridUnitsData;

  CartesianChartPainter({
    required this.style,
    required this.states,
    required this.structure,
    required this.gridUnitsData,
  });

  void paint(Canvas canvas, Size size,
      CartesianPaintingGeometryData paintingGeometryData) {
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
