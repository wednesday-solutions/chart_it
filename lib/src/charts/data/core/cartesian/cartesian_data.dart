import 'package:chart_it/chart_it.dart';
import 'package:chart_it/src/animations/tweens.dart';
import 'package:chart_it/src/extensions/primitives.dart';
import 'package:flutter/material.dart';

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

  static T whenSeries<T>(
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

abstract class CartesianConfig {}

List<Tween<CartesianSeries>>? toCartesianTweens(
  List<CartesianSeries>? current,
  List<CartesianSeries> target,
) {
  return buildTweens(current, target, builder: (current, target) {
    final currentValue =
        current == null || current.runtimeType != target.runtimeType
            ? null
            : current;
    return target.when(
      onBarSeries: (series) {
        return BarSeriesTween(
          begin: currentValue.ifNullThen(BarSeries.zero()),
          end: series,
        );
      },
    );
  });
}
