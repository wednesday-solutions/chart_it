import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/data/core/chart_text_style.dart';

typedef LabelMapper = String Function(num value);

abstract class CartesianSeries {}

class CartesianChartStyle extends Equatable {
  final Color backgroundColor;
  final CartesianChartAlignment alignment;
  final CartesianChartOrientation orientation;
  final CartesianGridStyle? gridStyle;
  final CartesianAxisStyle? axisStyle;

  const CartesianChartStyle({
    this.backgroundColor = const Color(0xFFFFECD9),
    this.alignment = CartesianChartAlignment.spaceEvenly,
    this.orientation = CartesianChartOrientation.vertical,
    this.gridStyle,
    this.axisStyle,
  });

  @override
  List<Object?> get props =>
      [backgroundColor, alignment, orientation, gridStyle, axisStyle];

  CartesianChartStyle copyWith({
    Color? backgroundColor,
    CartesianChartAlignment? alignment,
    CartesianChartOrientation? orientation,
    CartesianGridStyle? gridStyle,
    CartesianAxisStyle? axisStyle,
  }) {
    return CartesianChartStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      alignment: alignment ?? this.alignment,
      orientation: orientation ?? this.orientation,
      gridStyle: gridStyle ?? this.gridStyle,
      axisStyle: axisStyle ?? this.axisStyle,
    );
  }
}

class CartesianGridStyle extends Equatable {
  final bool show;
  final num? xUnitValue;
  final num? yUnitValue;
  final double gridLineWidth;
  final Color gridLineColor;

  const CartesianGridStyle({
    this.show = true,
    this.xUnitValue,
    this.yUnitValue,
    this.gridLineWidth = 0.5,
    this.gridLineColor = Colors.black45,
  });

  @override
  List<Object?> get props =>
      [show, xUnitValue, yUnitValue, gridLineWidth, gridLineColor];

  CartesianGridStyle copyWith({
    bool? show,
    num? xUnitValue,
    num? yUnitValue,
    double? gridLineWidth,
    Color? gridLineColor,
  }) {
    return CartesianGridStyle(
      show: show ?? this.show,
      xUnitValue: xUnitValue ?? this.xUnitValue,
      yUnitValue: yUnitValue ?? this.yUnitValue,
      gridLineWidth: gridLineWidth ?? this.gridLineWidth,
      gridLineColor: gridLineColor ?? this.gridLineColor,
    );
  }
}

class CartesianAxisStyle extends Equatable {
  final int? xBaseline;
  final int? yBaseline;
  final bool showXAxisLabels;
  final bool showYAxisLabels;
  final double axisWidth;
  final Color axisColor;
  final double tickLength;
  final double tickWidth;
  final Color tickColor;
  final ChartTextStyle? tickLabelStyle;

  const CartesianAxisStyle({
    this.xBaseline,
    this.yBaseline,
    this.showXAxisLabels = true,
    this.showYAxisLabels = true,
    this.axisWidth = 2.0,
    this.axisColor = Colors.black45,
    this.tickLength = 10.0,
    this.tickWidth = 1.0,
    this.tickColor = Colors.black45,
    this.tickLabelStyle,
  });

  @override
  List<Object?> get props => [
        xBaseline,
        yBaseline,
        showXAxisLabels,
        showYAxisLabels,
        axisWidth,
        axisColor,
        tickLength,
        tickWidth,
        tickColor,
        tickLabelStyle,
      ];

  CartesianAxisStyle copyWith({
    int? xBaseline,
    int? yBaseline,
    bool? showXAxisLabels,
    bool? showYAxisLabels,
    double? axisWidth,
    Color? axisColor,
    double? tickLength,
    double? tickWidth,
    Color? tickColor,
    ChartTextStyle? tickLabelStyle,
  }) {
    return CartesianAxisStyle(
      xBaseline: xBaseline ?? this.xBaseline,
      yBaseline: yBaseline ?? this.yBaseline,
      showXAxisLabels: showXAxisLabels ?? this.showXAxisLabels,
      showYAxisLabels: showYAxisLabels ?? this.showYAxisLabels,
      axisWidth: axisWidth ?? this.axisWidth,
      axisColor: axisColor ?? this.axisColor,
      tickLength: tickLength ?? this.tickLength,
      tickWidth: tickWidth ?? this.tickWidth,
      tickColor: tickColor ?? this.tickColor,
      tickLabelStyle: tickLabelStyle ?? this.tickLabelStyle,
    );
  }
}

enum CartesianChartAlignment {
  start,
  end,
  center,
  spaceEvenly,
  spaceAround,
  spaceBetween,
}

enum CartesianChartOrientation { vertical, horizontal }
