import 'package:chart_it/src/animations/lerps.dart';
import 'package:chart_it/src/charts/data/bars/bar_data_style.dart';
import 'package:chart_it/src/charts/data/bars/bar_group.dart';
import 'package:chart_it/src/charts/data/core/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/chart_text_style.dart';
import 'package:chart_it/src/charts/widgets/bar_chart.dart';
import 'package:equatable/equatable.dart';

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
  final ChartTextStyle labelStyle;

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

  static BarSeries lerp(CartesianSeries? a, CartesianSeries b, double t) {
    if ((a is BarSeries?) && b is BarSeries) {
      return BarSeries(
        labelStyle: ChartTextStyle.lerp(a?.labelStyle, b.labelStyle, t),
        seriesStyle: BarDataStyle.lerp(a?.seriesStyle, b.seriesStyle, t),
        barData: lerpBarGroupList(a?.barData, b.barData, t),
      );
    } else {
      throw Exception('Both current & target data should be of same series!');
    }
  }

  @override
  CartesianSeries get zeroValue => BarSeries.zero();
}
