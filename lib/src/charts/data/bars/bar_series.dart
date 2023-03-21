import 'package:chart_it/src/charts/data/bars/bar_data_style.dart';
import 'package:chart_it/src/charts/data/bars/bar_group.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/shared/chart_text_style.dart';
import 'package:chart_it/src/charts/widgets/bar_chart.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';

/// This class defines the Data Set to be provided to the BarChart
/// and the Global Styling options
///
/// The BarSeries is **mandatory** to be provided to the [BarChart] widget.
///
/// See Also: [CartesianSeries]
class BarSeries extends CartesianSeries with EquatableMixin {
  /// Sets uniform styling for All the Bars in this [BarSeries].
  ///
  /// {@macro bar_styling_order}
  final BarDataStyle? seriesStyle;

  /// Sets uniform styling for All the Group Labels in this [BarSeries].
  ///
  /// This styling can be overridden by:
  /// * labelStyle in any [BarGroup]
  final ChartTextStyle? labelStyle;

  /// The DataSet for our BarChart. It is Structured as a [BarGroup]
  /// that provides the X-Value and can contain a
  /// single or multiple group of bars.
  final List<BarGroup> barData;

  BarSeries({
    this.labelStyle = const ChartTextStyle(),
    this.seriesStyle,
    required this.barData,
  });

  factory BarSeries.zero() {
    return BarSeries(
      barData: List.empty(),
    );
  }

  @override
  List<Object?> get props => [labelStyle, seriesStyle, barData];

  static BarSeries lerp(
    CartesianSeries? current,
    CartesianSeries target,
    double t,
  ) {
    if ((current is BarSeries?) && target is BarSeries) {
      return BarSeries(
        labelStyle: ChartTextStyle.lerp(
          current?.labelStyle,
          target.labelStyle,
          t,
        ),
        seriesStyle: BarDataStyle.lerp(
          current?.seriesStyle,
          target.seriesStyle,
          t,
        ),
        barData: BarGroup.lerpBarGroupList(current?.barData, target.barData, t),
      );
    } else {
      throw Exception('Both current & target data should be of same series!');
    }
  }

  @override
  CartesianSeries get zeroValue => BarSeries.zero();
}

class BarSeriesTween extends Tween<BarSeries> {
  BarSeriesTween({
    required BarSeries? begin,
    required BarSeries end,
  }) : super(begin: begin, end: end);

  @override
  BarSeries lerp(double t) => BarSeries.lerp(begin, end!, t);
}
