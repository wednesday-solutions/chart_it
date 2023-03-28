import 'dart:ui';

import 'package:chart_it/src/charts/data/core/radial/radial_data.dart';
import 'package:chart_it/src/charts/data/core/shared/chart_text_style.dart';
import 'package:chart_it/src/charts/data/pie/slice_data.dart';
import 'package:chart_it/src/charts/data/pie/slice_data_style.dart';
import 'package:chart_it/src/charts/widgets/pie_chart.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Callback for Label in the Donut Area
typedef DonutLabel = String Function();

/// This class defines the Data Set to be provided to the PieChart
/// and the Global Styling options
///
/// The PieSeries is **mandatory** to be provided to the [PieChart] widget.
///
/// See Also: [RadialSeries]
class PieSeries extends RadialSeries with EquatableMixin {
  /// The size of the Donut Circle. Defaults to zero.
  final double? donutRadius;

  /// Color of the Donut Circle. Defaults to [Colors.transparent]
  final Color? donutSpaceColor;

  /// Callback for Label in the Donut Area
  final DonutLabel? donutLabel;

  /// Sets styling for the Donut Label in this [PieSeries].
  final ChartTextStyle? donutLabelStyle;

  /// Sets uniform styling for All the Slice Labels in this [PieSeries].
  ///
  /// This styling can be overridden by:
  /// * labelStyle in any [SliceData]
  final ChartTextStyle? labelStyle;

  /// Sets uniform styling for All the Pie Slices in this [PieSeries].
  ///
  /// {@macro slice_styling_order}
  final SliceDataStyle? seriesStyle;

  /// The DataSet for our Pie/Donut Chart. It is Structured as a [SliceData]
  /// and every slice can be set to have it's own radius and styling
  final List<SliceData> slices;

  PieSeries({
    this.donutRadius = 0.0,
    this.donutSpaceColor = Colors.transparent,
    this.donutLabel,
    this.donutLabelStyle = const ChartTextStyle(),
    this.labelStyle = const ChartTextStyle(),
    this.seriesStyle,
    required this.slices,
  });

  factory PieSeries.zero() => PieSeries(slices: List.empty());

  @override
  List<Object?> get props => [
        donutRadius,
        donutSpaceColor,
        donutLabel,
        donutLabelStyle,
        seriesStyle,
        slices,
      ];

  static PieSeries lerp(
    RadialSeries? current,
    RadialSeries target,
    double t,
  ) {
    if ((current is PieSeries?) && target is PieSeries) {
      return PieSeries(
        donutRadius: lerpDouble(
          current?.donutRadius,
          target.donutRadius,
          t,
        ),
        donutSpaceColor: Color.lerp(
          current?.donutSpaceColor,
          target.donutSpaceColor,
          t,
        ),
        donutLabel: target.donutLabel,
        donutLabelStyle: ChartTextStyle.lerp(
          current?.donutLabelStyle,
          target.donutLabelStyle,
          t,
        ),
        labelStyle: ChartTextStyle.lerp(
          current?.labelStyle,
          target.labelStyle,
          t,
        ),
        seriesStyle: SliceDataStyle.lerp(
          current?.seriesStyle,
          target.seriesStyle,
          t,
        ),
        slices: SliceData.lerpSliceDataList(current?.slices, target.slices, t),
      );
    } else {
      throw Exception('Both current & target data should be of same series!');
    }
  }
}

class PieSeriesConfig extends RadialConfig {
  var minValue = 0.0;
  var maxValue = double.infinity;

  void updateEdges(
    SliceData slice,
    Function(double value) onUpdate,
  ) =>
      onUpdate(slice.value.toDouble());
}

class PieSeriesTween extends Tween<PieSeries> {
  PieSeriesTween({
    required PieSeries? begin,
    required PieSeries end,
  }) : super(begin: begin, end: end);

  @override
  PieSeries lerp(double t) => PieSeries.lerp(begin, end!, t);
}
