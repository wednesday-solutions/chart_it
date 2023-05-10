import 'dart:ui';

import 'package:chart_it/src/charts/data/bars/bar_series.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_range.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Callback for Mapping a String Value to a Label
typedef LabelMapper = String Function(num value);

// /// Alignment of the Data Points for any Cartesian Charts
// enum CartesianChartAlignment {
//   start,
//   end,
//   center,
//   spaceEvenly,
//   spaceAround,
//   spaceBetween,
// }

class GridUnitsData extends Equatable {
  final double xUnitValue;
  final double xUnitsCount;
  final double yUnitValue;
  final double yUnitsCount;
  final double totalXRange;
  final double totalYRange;
  final double maxXRange;
  final double maxYRange;
  final double minXRange;
  final double minYRange;

  const GridUnitsData({
    required this.xUnitValue,
    required this.xUnitsCount,
    required this.yUnitValue,
    required this.yUnitsCount,
    required this.totalXRange,
    required this.totalYRange,
    required this.maxXRange,
    required this.maxYRange,
    required this.minXRange,
    required this.minYRange,
  });

  static GridUnitsData lerp(
      GridUnitsData? current, GridUnitsData target, double t) {
    // TODO: Check which values of current can be null.
    return GridUnitsData(
      xUnitValue: lerpDouble(
              current?.xUnitValue ?? target.xUnitValue, target.xUnitValue, t) ??
          1,
      xUnitsCount: lerpDouble(current?.xUnitsCount ?? target.xUnitsCount,
              target.xUnitsCount, t) ??
          0.0,
      yUnitValue: lerpDouble(
              current?.yUnitValue ?? target.yUnitValue, target.yUnitValue, t) ??
          1,
      yUnitsCount: lerpDouble(current?.yUnitsCount ?? target.yUnitsCount,
              target.yUnitsCount, t) ??
          0.0,
      totalXRange: lerpDouble(current?.totalXRange ?? target.totalXRange,
              target.totalXRange, t) ??
          0.0,
      totalYRange: lerpDouble(current?.totalYRange ?? target.totalYRange,
              target.totalYRange, t) ??
          0.0,
      maxXRange: lerpDouble(current?.maxXRange, target.maxXRange, t) ?? 0,
      maxYRange: lerpDouble(current?.maxYRange, target.maxYRange, t) ?? 0,
      minXRange: lerpDouble(current?.minXRange, target.minXRange, t) ?? 0,
      minYRange: lerpDouble(current?.minYRange, target.minYRange, t) ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        xUnitsCount,
        xUnitValue,
        yUnitsCount,
        yUnitValue,
        totalXRange,
        totalYRange
      ];
}

/// Orientation of the Chart
enum CartesianChartOrientation {
  vertical,
  // Horizontal not yet supported
  // horizontal,
}

class CartesianData with EquatableMixin {
  List<PaintingState> states;
  GridUnitsData gridUnitsData;

  CartesianData({
    required this.states,
    required this.gridUnitsData,
  });

  factory CartesianData.zero({
    required GridUnitsData gridUnitsData,
  }) {
    return CartesianData(
      states: List.empty(),
      gridUnitsData: gridUnitsData,
    );
  }

  static CartesianData lerp(
    CartesianData? current,
    CartesianData target,
    double t,
  ) {
    return CartesianData(
      states: PaintingState.lerpStateList(current?.states, target.states, t),
      gridUnitsData:
          GridUnitsData.lerp(current?.gridUnitsData, target.gridUnitsData, t),
    );
  }

  @override
  List<Object> get props => [states, gridUnitsData];
}

class CartesianDataTween extends Tween<CartesianData> {
  /// A Tween to interpolate between two [CartesianData]
  ///
  /// [end] object must not be null.
  CartesianDataTween({
    required CartesianData? begin,
    required CartesianData end,
  }) : super(begin: begin, end: end);

  @override
  CartesianData lerp(double t) => CartesianData.lerp(begin, end!, t);
}

/// Base Series for any type of Data which can be plotted
/// on a Cartesian Chart.
abstract class CartesianSeries<E extends TouchInteractionEvents>
    with EquatableMixin {
  final E interactionEvents;

  CartesianSeries({required this.interactionEvents});

  /// Checks the Subclass Type and returns the casted instance
  /// to the matched callback. All callbacks must be provided.
  T when<T>({
    required T Function(BarSeries series) onBarSeries,
  }) {
    switch (runtimeType) {
      case BarSeries:
        return onBarSeries(this as BarSeries);
      default:
        throw TypeError();
    }
  }

  /// Checks the Subclass Type and returns the casted instance
  /// to the matched callback.
  ///
  /// [orElse] is triggered if the callback for the matched type is not provided.
  T maybeWhen<T>({
    T Function(BarSeries series)? onBarSeries,
    required T Function() orElse,
  }) {
    switch (runtimeType) {
      case BarSeries:
        return onBarSeries?.call(this as BarSeries) ?? orElse();
      default:
        throw TypeError();
    }
  }

  /// Static method to Check the Subclass Type when we do not have
  /// an instance for an object extending this class.
  ///
  /// Does the same operation as [maybeWhen].
  static T whenType<T>(
    Type type, {
    T Function()? onBarSeries,
    required T Function() orElse,
  }) {
    switch (type) {
      case BarSeries:
        return onBarSeries?.call() ?? orElse();
      default:
        throw TypeError();
    }
  }
}

abstract class CartesianConfig with EquatableMixin {}
