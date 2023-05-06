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

const defaultBarChartStyle = CartesianChartStyle(
  gridStyle: CartesianGridStyle(
    show: true,
    yUnitValue: 10.0,
  ),
  axisStyle: CartesianAxisStyle(),
);

const defaultRadialChartStyle = RadialChartStyle();

const defaultBarSeriesStyle = BarDataStyle(
  barColor: Color(0xFFCBB6F7),
  strokeWidth: 2.0,
  strokeColor: Color(0xFF6A4FA3),
);

const defaultPieSeriesStyle = SliceDataStyle(
  radius: 200.0,
  color: Color(0xFFCBB6F7),
  strokeWidth: 2.0,
  strokeColor: Color(0xFF6A4FA3),
);

const defaultChartTextStyle = ChartTextStyle(
  textStyle: TextStyle(color: Colors.black45),
);
