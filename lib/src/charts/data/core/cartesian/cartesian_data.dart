import 'dart:ui';

import 'package:chart_it/src/charts/data/bars/bar_series.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Callback for Mapping a String Value to a Label
typedef LabelMapper = String Function(num value);

/// Orientation of the Chart
enum CartesianChartOrientation {
  vertical,
  // Horizontal not yet supported
  // horizontal,
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