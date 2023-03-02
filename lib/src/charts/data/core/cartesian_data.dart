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
  final double strokeWidth;
  final Color strokeColor;

  const CartesianGridStyle({
    this.show = true,
    this.xUnitValue,
    this.yUnitValue,
    this.strokeWidth = 0.5,
    this.strokeColor = Colors.black45,
  });

  @override
  List<Object?> get props =>
      [show, xUnitValue, yUnitValue, strokeWidth, strokeColor];

  CartesianGridStyle copyWith({
    bool? show,
    num? xUnitValue,
    num? yUnitValue,
    double? strokeWidth,
    Color? strokeColor,
  }) {
    return CartesianGridStyle(
      show: show ?? this.show,
      xUnitValue: xUnitValue ?? this.xUnitValue,
      yUnitValue: yUnitValue ?? this.yUnitValue,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeColor: strokeColor ?? this.strokeColor,
    );
  }
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

  CartesianAxisStyle copyWith({
    int? xBaseline,
    int? yBaseline,
    double? strokeWidth,
    Color? strokeColor,
  }) {
    return CartesianAxisStyle(
      xBaseline: xBaseline ?? this.xBaseline,
      yBaseline: yBaseline ?? this.yBaseline,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeColor: strokeColor ?? this.strokeColor,
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
