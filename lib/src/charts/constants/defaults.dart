import 'package:chart_it/src/charts/data/bars/bar_data_style.dart';
import 'package:chart_it/src/charts/data/candlestick/candle_style.dart';
import 'package:chart_it/src/charts/data/core/radial/radial_styling.dart';
import 'package:chart_it/src/charts/data/core/shared/chart_text_style.dart';
import 'package:chart_it/src/charts/data/pie/slice_data_style.dart';
import 'package:flutter/material.dart';

const defaultRadialChartStyle = RadialChartStyle();

const defaultBarSeriesStyle = BarDataStyle(
  barColor: Color(0xFFCBB6F7),
  strokeWidth: 2.0,
  strokeColor: Color(0xFF6A4FA3),
);

const defaultCandleSticksStyle = CandleStyle(
  roundedTips: true,
  wickWidth: 1.0,
  bodyWidth: 0.85,
  bullColor: Color(0xFF1CBC91),
  bearColor: Color(0xFFF05536),
  neutralColor: Color(0xFFE5E6E4),
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
