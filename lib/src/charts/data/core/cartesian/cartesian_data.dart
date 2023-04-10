import 'package:chart_it/src/animations/tweens.dart';
import 'package:chart_it/src/charts/data/bars/bar_series.dart';
import 'package:chart_it/src/extensions/primitives.dart';
import 'package:chart_it/src/interactions/data/chart_interactions.dart';
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

/// Base Series for any type of Data which can be plotted
/// on a Cartesian Chart.
abstract class CartesianSeries<I extends ChartInteractionResult> {
  final ChartInteractionConfig<I> interactionConfig;

  CartesianSeries({required this.interactionConfig});

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

abstract class CartesianConfig {}

/// Converts [current] and [target] list of [CartesianSeries] to
/// a list of [Tween] of type [CartesianSeries]
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
          begin: currentValue.asOrDefault(BarSeries.zero()),
          end: series,
        );
      },
    );
  });
}
