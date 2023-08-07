import 'dart:ui';

import 'package:equatable/equatable.dart';

/// The core class encapsulating the parameters for
/// Grid Lines and Label Data Placements during rendering phase.
class CartesianGridUnitsData extends Equatable {
  /// Defines if the grid data for the current instance
  /// was initialized for the Initial Rendering Phase. This is important,
  /// to correctly layout the grid and label positions on widget tree rebuild,
  /// for scenarios were parent data is lost. For e.g. navigating back to widget screen.
  final bool isInitState;

  /// Defines the divisor value across the X-Axis data range.
  final double xUnitValue;

  /// Defines how many pieces the X-Axis has been split into for the given range
  /// of the data along X Axis.
  final double xUnitsCount;

  /// Defines the divisor value across the Y-Axis data range.
  final double yUnitValue;

  /// Defines how many pieces the Y-Axis has been split into for the given range
  /// of the data along Y Axis.
  final double yUnitsCount;

  /// Defines the total range between the two ends of the minima and maxima of the data
  /// along the X Axis.
  final double totalXRange;

  /// Defines the total range between the two ends of the minima and maxima of the data
  /// along the Y Axis.
  final double totalYRange;

  /// Maximum value along X Axis
  final double maxXRange;

  /// Maximum value along Y Axis
  final double maxYRange;

  /// Minimum value along X Axis
  final double minXRange;

  /// Minimum value along Y Axis
  final double minYRange;

  /// The core class encapsulating the parameters for
  /// Grid Lines and Label Data Placements during rendering phase.
  const CartesianGridUnitsData({
    this.isInitState = false,
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

  static const zero = CartesianGridUnitsData(
    xUnitValue: 1,
    xUnitsCount: 1,
    yUnitValue: 1,
    yUnitsCount: 1,
    totalXRange: 0,
    totalYRange: 0,
    maxXRange: 0,
    maxYRange: 0,
    minXRange: 0,
    minYRange: 0,
  );

  /// Lerps between two [CartesianGridUnitsData] for a factor [t]
  static CartesianGridUnitsData lerp(
    CartesianGridUnitsData? current,
    CartesianGridUnitsData target,
    double t,
  ) {
    return CartesianGridUnitsData(
      isInitState: target.isInitState,
      xUnitValue: lerpDouble(
              current?.xUnitValue ?? target.xUnitValue, target.xUnitValue, t) ??
          1,
      xUnitsCount: lerpDouble(
            current?.xUnitsCount ?? target.xUnitsCount,
            target.xUnitsCount,
            t,
          ) ??
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

  CartesianGridUnitsData copyWith({
    bool? isInitState,
    double? xUnitValue,
    double? xUnitsCount,
    double? yUnitValue,
    double? yUnitsCount,
    double? totalXRange,
    double? totalYRange,
    double? maxXRange,
    double? maxYRange,
    double? minXRange,
    double? minYRange,
  }) {
    return CartesianGridUnitsData(
      isInitState: isInitState ?? this.isInitState,
      xUnitValue: xUnitValue ?? this.xUnitValue,
      xUnitsCount: xUnitsCount ?? this.xUnitsCount,
      yUnitValue: yUnitValue ?? this.yUnitValue,
      yUnitsCount: yUnitsCount ?? this.yUnitsCount,
      totalXRange: totalXRange ?? this.totalXRange,
      totalYRange: totalYRange ?? this.totalYRange,
      maxXRange: maxXRange ?? this.maxXRange,
      maxYRange: maxYRange ?? this.maxYRange,
      minXRange: minXRange ?? this.minXRange,
      minYRange: minYRange ?? this.minYRange,
    );
  }

  @override
  List<Object> get props => [
        isInitState,
        xUnitsCount,
        xUnitValue,
        yUnitsCount,
        yUnitValue,
        totalXRange,
        totalYRange,
        maxXRange,
        maxYRange,
        minXRange,
        minYRange
      ];

  @override
  String toString() {
    return '''
    CartesianGridUnitsData{
      isInitState: $isInitState, 
      xUnitValue: $xUnitValue, 
      xUnitsCount: $xUnitsCount, 
      yUnitValue: $yUnitValue, 
      yUnitsCount: $yUnitsCount, 
      totalXRange: $totalXRange, 
      totalYRange: $totalYRange, 
      maxXRange: $maxXRange, 
      maxYRange: $maxYRange, 
      minXRange: $minXRange, 
      minYRange: $minYRange,
    }''';
  }
}
