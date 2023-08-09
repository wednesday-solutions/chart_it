import 'package:chart_it/src/charts/data/core/cartesian/cartesian_grid_units.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class CartesianData with EquatableMixin {
  List<PaintingState> states;
  CartesianGridUnitsData gridUnitsData;

  CartesianData({
    required this.states,
    required this.gridUnitsData,
  });

  factory CartesianData.zero({
    required CartesianGridUnitsData gridUnitsData,
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
      gridUnitsData: CartesianGridUnitsData.lerp(
          current?.gridUnitsData, target.gridUnitsData, t),
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

abstract class CartesianConfig with EquatableMixin {}

class CartesianPaintingGeometryData extends Equatable {
  final Rect graphPolygon;
  final Offset axisOrigin;

  final double graphUnitWidth;
  final double graphUnitHeight;

  final double valueUnitWidth;
  final double valueUnitHeight;

  final CartesianGridUnitsData unitData;

  final double xUnitValue;

  const CartesianPaintingGeometryData({
    required this.graphPolygon,
    required this.axisOrigin,
    required this.graphUnitWidth,
    required this.graphUnitHeight,
    required this.valueUnitWidth,
    required this.valueUnitHeight,
    required this.unitData,
    required this.xUnitValue,
  });

  static const zero = CartesianPaintingGeometryData(
    graphPolygon: Rect.zero,
    axisOrigin: Offset.zero,
    graphUnitWidth: 1,
    graphUnitHeight: 1,
    valueUnitWidth: 1,
    valueUnitHeight: 1,
    unitData: CartesianGridUnitsData.zero,
    xUnitValue: 1,
  );

  @override
  List<Object?> get props => [
        graphPolygon,
        axisOrigin,
        graphUnitWidth,
        graphUnitHeight,
        valueUnitWidth,
        valueUnitHeight,
        unitData,
        xUnitValue
      ];

  CartesianPaintingGeometryData copyWith({
    Rect? graphPolygon,
    Offset? axisOrigin,
    double? graphUnitWidth,
    double? graphUnitHeight,
    double? valueUnitWidth,
    double? valueUnitHeight,
    CartesianGridUnitsData? unitData,
    EdgeInsets? graphEdgeInsets,
    double? xUnitValue,
  }) {
    return CartesianPaintingGeometryData(
      graphPolygon: graphPolygon ?? this.graphPolygon,
      axisOrigin: axisOrigin ?? this.axisOrigin,
      graphUnitWidth: graphUnitWidth ?? this.graphUnitWidth,
      graphUnitHeight: graphUnitHeight ?? this.graphUnitHeight,
      valueUnitWidth: valueUnitWidth ?? this.valueUnitWidth,
      valueUnitHeight: valueUnitHeight ?? this.valueUnitHeight,
      unitData: unitData ?? this.unitData,
      xUnitValue: xUnitValue ?? this.xUnitValue,
    );
  }

  CartesianPaintingGeometryData atOffset(Offset offset) {
    return copyWith(
      graphPolygon: graphPolygon.translate(offset.dx, offset.dy),
      axisOrigin: axisOrigin + offset,
    );
  }

  @override
  String toString() {
    return '''
    CartesianPaintingGeometryData{
      graphPolygon: $graphPolygon, 
      axisOrigin: $axisOrigin, 
      graphUnitWidth: $graphUnitWidth, 
      graphUnitHeight: $graphUnitHeight, 
      valueUnitWidth: $valueUnitWidth, 
      valueUnitHeight: $valueUnitHeight, 
      unitData: $unitData, 
      xUnitValue: $xUnitValue,
    }''';
  }
}
