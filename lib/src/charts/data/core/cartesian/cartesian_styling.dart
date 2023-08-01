import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/renderers/cartesian_scaffold_renderer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents data that can influence the structuring of a chart.
class CartesianChartStructureData extends Equatable {
  /// The Orientation of the Chart. Defaults to Vertical.
  final CartesianChartOrientation orientation;

  /// Value of a Unit Distance along X-Axis
  final num xUnitValue;

  /// Value of a Unit Distance along Y-Axis
  final num yUnitValue;

  /// The maximum value on X axis.
  final num? maxXValue;

  /// The maximum value on Y axis.
  final num? maxYValue;

  /// Represents data that can influence the structuring of a chart.
  const CartesianChartStructureData({
    this.orientation = CartesianChartOrientation.vertical,
    this.xUnitValue = 1,
    this.yUnitValue = 10,
    this.maxXValue,
    this.maxYValue,
  });

  @override
  List<Object?> get props => [
        orientation,
        xUnitValue,
        yUnitValue,
        maxXValue,
        maxYValue,
      ];

  CartesianChartStructureData copyWith({
    CartesianChartOrientation? orientation,
    num? xUnitValue,
    num? yUnitValue,
    num? maxXValue,
    num? maxYValue,
  }) {
    return CartesianChartStructureData(
      orientation: orientation ?? this.orientation,
      xUnitValue: xUnitValue ?? this.xUnitValue,
      yUnitValue: yUnitValue ?? this.yUnitValue,
      maxXValue: maxXValue ?? this.maxXValue,
      maxYValue: maxYValue ?? this.maxYValue,
    );
  }
}

/// Represents data that alters the visual appearance of the chart.
///
/// See also:
/// * [CartesianGridStyle]
/// * [CartesianAxisStyle]
class CartesianChartStylingData extends Equatable {
  /// Styling for the Grid Lines.
  final CartesianGridStyle? gridStyle;

  /// Styling for the Axis Lines.
  final CartesianAxisStyle? axisStyle;

  /// The Background Color of the Chart.
  final Color? backgroundColor;

  /// Represents data that alters the visual appearance of the chart.
  ///
  /// See also:
  /// * [CartesianGridStyle]
  /// * [CartesianAxisStyle]
  const CartesianChartStylingData({
    this.gridStyle,
    this.axisStyle,
    this.backgroundColor,
  });

  @override
  List<Object?> get props => [gridStyle, axisStyle, backgroundColor];

  CartesianChartStylingData copyWith({
    CartesianGridStyle? gridStyle,
    CartesianAxisStyle? axisStyle,
    Color? backgroundColor,
  }) {
    return CartesianChartStylingData(
      gridStyle: gridStyle ?? this.gridStyle,
      axisStyle: axisStyle ?? this.axisStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
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

  /// The Width/Thickness of the Grid Lines
  final double gridLineWidth;

  /// The Color of the Grid Lines
  final Color gridLineColor;

  /// Provides the Styling options for a Cartesian Grid.
  ///
  /// Customization Options include Show/Hide, Line Color,
  /// Line Width and Unit Values for a Graph Unit formed by Grid Intersections.
  const CartesianGridStyle({
    this.show = true,
    this.gridLineWidth = 0.5,
    this.gridLineColor = Colors.black45,
  });

  @override
  List<Object?> get props => [show, gridLineWidth, gridLineColor];

  CartesianGridStyle copyWith({
    bool? show,
    num? xUnitValue,
    num? yUnitValue,
    double? gridLineWidth,
    Color? gridLineColor,
  }) {
    return CartesianGridStyle(
      show: show ?? this.show,
      gridLineWidth: gridLineWidth ?? this.gridLineWidth,
      gridLineColor: gridLineColor ?? this.gridLineColor,
    );
  }
}

/// Represents data that affects the painting of ticks for all axis.
class AxisTickConfig extends Equatable {
  /// The Length of the Tick drawn along Axes
  /// Defaults to 15.
  final double tickLength;

  /// The Width/Thickness of the Tick drawn along Axes
  /// Defaults to 1.
  final double tickWidth;

  /// The Color of the Tick drawn along Axes
  final Color tickColor;

  /// Show or hide the ticks along left Y axis.
  final bool showTickOnLeftAxis;

  /// Show or hide the ticks along top X axis.
  final bool showTickOnTopAxis;

  /// Show or hide the ticks along bottom X axis.
  final bool showTickOnBottomAxis;

  /// Show or hide the ticks along right Y axis.
  final bool showTickOnRightAxis;

  /// Represents data that affects the painting of ticks for all axis.
  ///
  /// Gives individual control for each axis.
  const AxisTickConfig({
    this.tickLength = 15.0,
    this.tickWidth = 1.0,
    this.tickColor = Colors.black45,
    this.showTickOnLeftAxis = false,
    this.showTickOnTopAxis = false,
    this.showTickOnBottomAxis = false,
    this.showTickOnRightAxis = false,
  });

  /// Represents data that affects the painting of ticks for all axis.
  ///
  /// A convenient constructor to show and hide ticks for all axis together.
  const AxisTickConfig.forAllAxis({
    this.tickLength = 15.0,
    this.tickWidth = 1.0,
    this.tickColor = Colors.black45,
    bool showTicks = false,
  })  : showTickOnTopAxis = showTicks,
        showTickOnRightAxis = showTicks,
        showTickOnBottomAxis = showTicks,
        showTickOnLeftAxis = showTicks;

  @override
  List<Object?> get props => [
        tickLength,
        tickWidth,
        tickColor,
        showTickOnLeftAxis,
        showTickOnTopAxis,
        showTickOnBottomAxis,
        showTickOnRightAxis,
      ];
}

/// Provides the Styling options for a Cartesian Axis.
///
/// Customization Options for Axis Lines, Ticks and Labels
class CartesianAxisStyle extends Equatable {
  /// The Width of the Axis Lines
  final double axisWidth;

  /// The Color of the Axis Lines
  final Color axisColor;

  /// Configuration data for painting ticks on all axis.
  final AxisTickConfig tickConfig;

  /// Provides the Styling options for a Cartesian Axis.
  ///
  /// Customization Options for Axis Lines, Ticks and Labels
  const CartesianAxisStyle({
    this.axisWidth = 2.0,
    this.axisColor = Colors.black45,
    this.tickConfig = const AxisTickConfig(),
  });

  @override
  List<Object?> get props => [
        axisWidth,
        axisColor,
        tickConfig,
      ];

  CartesianAxisStyle copyWith({
    int? xBaseline,
    int? yBaseline,
    bool? showXAxisLabels,
    bool? showYAxisLabels,
    double? axisWidth,
    Color? axisColor,
    AxisTickConfig? tickConfig,
  }) {
    return CartesianAxisStyle(
      axisWidth: axisWidth ?? this.axisWidth,
      axisColor: axisColor ?? this.axisColor,
      tickConfig: tickConfig ?? this.tickConfig,
    );
  }
}

class AxisLabelConfig extends Equatable {
  final LabelBuilder builder;
  final bool constraintEdgeLabels;
  final bool centerLabels;

  const AxisLabelConfig({
    required this.builder,
    this.constraintEdgeLabels = false,
    this.centerLabels = false,
  }) : assert(
          !(constraintEdgeLabels && centerLabels),
          "Both centerLabels and constraintEdgeLabels cannot be true at the same time.",
        );

  @override
  List<Object?> get props => [constraintEdgeLabels, centerLabels];
}

class AxisLabels {
  final AxisLabelConfig? left;
  final AxisLabelConfig? top;
  final AxisLabelConfig? right;
  final AxisLabelConfig? bottom;

  const AxisLabels({
    this.left,
    this.top,
    this.right,
    this.bottom,
  });
}
