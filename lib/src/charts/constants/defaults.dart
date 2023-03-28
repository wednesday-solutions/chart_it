import 'package:chart_it/src/charts/data/bars/bar_data_style.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_styling.dart';
import 'package:chart_it/src/charts/data/core/radial/radial_styling.dart';
import 'package:chart_it/src/charts/data/core/shared/chart_text_style.dart';
import 'package:chart_it/src/charts/data/pie/slice_data_style.dart';
import 'package:flutter/material.dart';

const defaultCartesianChartStyle = CartesianChartStyle(
  gridStyle: CartesianGridStyle(
    show: true,
    xUnitValue: 10.0,
    yUnitValue: 10.0,
  ),
  axisStyle: CartesianAxisStyle(),
);

const defaultRadialChartStyle = RadialChartStyle();

const defaultBarSeriesStyle = BarDataStyle(
  barWidth: 1.0,
  barColor: Colors.amber,
  strokeWidth: 0.0,
  strokeColor: Colors.pink,
  cornerRadius: BorderRadius.only(
    topLeft: Radius.circular(5.0),
    topRight: Radius.circular(5.0),
  ),
);

const defaultPieSeriesStyle = SliceDataStyle(
  radius: 200.0,
  color: Color(0xFF4247E8),
  strokeColor: Color(0xFF9295F2),
  strokeWidth: 0.0,
);

const defaultChartTextStyle = ChartTextStyle();
