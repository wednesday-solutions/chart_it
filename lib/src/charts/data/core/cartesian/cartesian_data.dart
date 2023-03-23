import 'package:chart_it/chart_it.dart';
import 'package:chart_it/src/animations/tweens.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/extensions/validators.dart';
import 'package:flutter/material.dart';

/// Callback to construct a CartesianPainter for provided CartesianSeries Type
typedef CartesianPaintConstructor = CartesianPainter Function(Type series);

/// Callback for Mapping a String Value to a Label
typedef LabelMapper = String Function(num value);

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

abstract class CartesianSeries {
  // T when<T>({required T Function() barSeries}) {
  //   switch (runtimeType) {
  //     case BarSeries:
  //       return barSeries();
  //     default:
  //       throw TypeError();
  //   }
  // }
}

List<Tween<CartesianSeries>>? toCartesianTweens(
  List<CartesianSeries>? current,
  List<CartesianSeries> target,
) {
  return buildTweens(current, target, builder: (current, target) {
    final currentValue =
        current == null || current.runtimeType != target.runtimeType
            ? null
            : current;
    return whereSeries(
      target.runtimeType,
      onBarSeries: () {
        return BarSeriesTween(
          begin: currentValue.asOrNull<BarSeries>(),
          end: target as BarSeries,
        );
      },
    );
  });
}
