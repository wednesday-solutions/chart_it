import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';

const defaultChartStyle = CartesianChartStyle(
  gridStyle: CartesianGridStyle(show: true),
  axisStyle: CartesianAxisStyle(),
);

const defaultSeriesStyle = BarDataStyle(
  barWidth: 1.0,
  barColor: Colors.amber,
  strokeWidth: 0.0,
  strokeColor: Colors.pink,
  cornerRadius: BorderRadius.only(
    topLeft: Radius.circular(5.0),
    topRight: Radius.circular(5.0),
  ),
);
