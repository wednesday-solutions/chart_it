import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
}

class CartesianGridStyle extends Equatable {
  final bool show;
  final num xUnitValue;
  final num yUnitValue;
  final double strokeWidth;
  final Color strokeColor;

  const CartesianGridStyle({
    this.show = true,
    this.xUnitValue = 10.0,
    this.yUnitValue = 10.0,
    this.strokeWidth = 0.5,
    this.strokeColor = Colors.black45,
  });

  @override
  List<Object> get props =>
      [show, xUnitValue, yUnitValue, strokeWidth, strokeColor];
}

class CartesianAxisStyle extends Equatable {
  final int? xBaseline;
  final int? yBaseline;
  final double strokeWidth;
  final Color strokeColor;

  const CartesianAxisStyle({
    this.xBaseline,
    this.yBaseline,
    this.strokeWidth = 2.0,
    this.strokeColor = Colors.black45,
  });

  @override
  List<Object?> get props => [xBaseline, yBaseline, strokeWidth, strokeColor];
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
