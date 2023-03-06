import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:flutter_charts/src/charts/data/pie/slice_data_style.dart';

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

const defaultPieSeriesStyle = SliceDataStyle(radius: 10.0);
