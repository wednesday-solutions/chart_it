import 'package:chart_it/src/charts/constants/defaults.dart';
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
  final double donutRadius;

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

  /// This class defines the Data Set to be provided to the PieChart
  /// and the Global Styling options
  ///
  /// The PieSeries is **mandatory** to be provided to the [PieChart] widget.
  ///
  /// See Also: [RadialSeries]
  PieSeries({
    this.donutRadius = 0.0,
    this.donutSpaceColor = Colors.transparent,
    this.donutLabel,
    this.donutLabelStyle = defaultChartTextStyle,
    this.labelStyle = defaultChartTextStyle,
    this.seriesStyle,
    required this.slices,
  })  : assert(donutRadius >= 0.0, 'Donut Radius cannot be Negative!'),
        assert(
          donutLabel != null ? donutRadius > 0.0 : true,
          'To display a Donut Label, Donut Radius must be greater than Zero!',
        );

  /// Constructs a Factory Instance of [PieSeries] without any Data.
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

  /// Lerps between two [PieSeries] for a factor [t]
  static PieSeries lerp(
    PieSeries? current,
    PieSeries target,
    double t,
  ) {
    return PieSeries(
      donutRadius: target.donutRadius,
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
        target.donutRadius,
        t,
      ),
      slices: SliceData.lerpSliceDataList(
        current?.slices,
        target.slices,
        target.donutRadius,
        t,
      ),
    );
  }
}

/// Defines [PieSeries] specific data variables, which are utilized
/// when drawing a [PieChart].
///
/// Returns the value for a [SliceData].
class PieSeriesConfig extends RadialConfig {
  /// Returns the value of this [SliceData] in [onUpdate].
  void calcSliceRange(
    List<SliceData> slices,
    Function(double value) onUpdate,
  ) {
    for (var i = 0; i < slices.length; i++) {
      final slice = slices[i];
      onUpdate(slice.value.toDouble());
    }
  }
}

/// A Tween to interpolate between two [PieSeries]
///
/// [end] object must not be null.
class PieSeriesTween extends Tween<PieSeries> {
  PieSeriesTween({
    required PieSeries? begin,
    required PieSeries end,
  }) : super(begin: begin, end: end);

  @override
  PieSeries lerp(double t) => PieSeries.lerp(begin, end!, t);
}
