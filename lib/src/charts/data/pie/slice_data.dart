import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/data/core/chart_text_style.dart';
import 'package:flutter_charts/src/charts/data/core/radial_data.dart';
import 'package:flutter_charts/src/charts/data/pie/slice_data_style.dart';

/// Defines the Data of a Pie Slice in the Pie/Donut chart
///
/// Holds the Numeric Value, label and styling for this Slice
class SliceData extends Equatable {
  /// Sets uniform styling for the Pie/Slice in this [SliceData].
  ///
  /// {@macro slice_styling_order}
  final SliceDataStyle? style;

  /// Text Styling for the [label].
  final ChartTextStyle? labelStyle;

  /// Callback for Label for the Style
  final SliceMapper? label;

  /// Numeric Value of this Slice.
  final num value;

  const SliceData({
    required this.value,
    this.labelStyle,
    this.label,
    this.style,
  });

  @override
  List<Object?> get props => [style, label, labelStyle, value];
}
