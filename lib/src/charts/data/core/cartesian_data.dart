import 'package:chart_it/chart_it.dart';
import 'package:chart_it/src/animations/lerps.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Callback to construct a CartesianPainter for provided CartesianSeries Type
typedef CartesianPaintConstructor = CartesianPainter Function(Type series);

/// Callback for Mapping a String Value to a Label
typedef LabelMapper = String Function(num value);

abstract class CartesianSeries with ZeroValueProvider<CartesianSeries> {
  T when<T>({
    required T Function() barSeries,
  }) {
    switch (runtimeType) {
      case BarSeries:
        return barSeries();
      default:
        throw TypeError();
    }
  }

  @override
  CartesianSeries get zeroValue;
}

/// Provides the Styling options for any Cartesian Chart.
///
/// Customization Options include BackgroundColor, Chart Alignment,
/// Orientation, Grid Styling and Axis Styling.
class CartesianChartStyle extends Equatable {
  /// The Background Color of the Chart.
  final Color backgroundColor;

  /// The Alignment for Cartesian Data Points.
  final CartesianChartAlignment alignment;

  /// The Orientation of the Chart. Defaults to Vertical.
  final CartesianChartOrientation orientation;

  /// Styling for the Grid Lines.
  final CartesianGridStyle? gridStyle;

  /// Styling for the Axis Lines.
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

/// Provides the Styling options for a Cartesian Grid.
///
/// Customization Options include Show/Hide, Line Color,
/// Line Width and Unit Values for a Graph Unit formed by Grid Intersections.
class CartesianGridStyle extends Equatable {
  /// Hides or Shows the Grid Lines. Visible by Default.
  final bool show;

  /// Value of a Unit Distance along X-Axis
  final num? xUnitValue;

  /// Value of a Unit Distance along Y-Axis
  final num? yUnitValue;

  /// The Width/Thickness of the Grid Lines
  final double gridLineWidth;

  /// The Color of the Grid Lines
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

/// Provides the Styling options for a Cartesian Axis.
///
/// Customization Options for Axis Lines, Ticks and Labels
class CartesianAxisStyle extends Equatable {
  final int? xBaseline;
  final int? yBaseline;

  /// Hides or Shows the Unit Labels along X-Axis.
  /// Visible by Default.
  final bool showXAxisLabels;

  /// Hides or Shows the Unit Labels along Y-Axis.
  /// Visible by Default.
  final bool showYAxisLabels;

  /// The Width of the Axis Lines
  final double axisWidth;

  /// The Color of the Axis Lines
  final Color axisColor;

  /// The Length of the Tick drawn along Axes
  final double tickLength;

  /// The Width/Thickness of the Tick drawn along Axes
  final double tickWidth;

  /// The Color of the Tick drawn along Axes
  final Color tickColor;

  /// Styling for the Tick Labels
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

/// Alignment of the Data Points for any Cartesian Charts
enum CartesianChartAlignment {
  start,
  end,
  center,
  spaceEvenly,
  spaceAround,
  spaceBetween,
}

/// Orientation of the Chart
enum CartesianChartOrientation { vertical, horizontal }
