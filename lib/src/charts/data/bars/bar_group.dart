import 'package:chart_it/src/animations/lerps.dart';
import 'package:chart_it/src/charts/data/bars/bar_data_style.dart';
import 'package:chart_it/src/charts/data/bars/multi_bar.dart';
import 'package:chart_it/src/charts/data/bars/simple_bar.dart';
import 'package:chart_it/src/charts/data/core/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/chart_text_style.dart';

/// Sets the Arrangement for all the bars in a [BarGroup].
///
/// * Use [series] to have all the bars arranged alongside each other.
/// * Use [stack] to create a stack of all the bars in a group.
enum BarGroupArrangement { series, stack }

/// {@template bar_group}
/// Defines the structure of a Group of Bars
///
/// Holds the X-Value, Labels and Styling.
/// {@endtemplate}
abstract class BarGroup with ZeroValueProvider<BarGroup> {
  /// The Value along X-Axis for this [BarGroup].
  ///
  /// This value is not used for plotting on X-Axis.
  /// The plotting is done based on the index of this item in the list.
  final num xValue;

  /// Callback for the label underneath a [BarGroup].
  /// The X-Value is provided as a param, and a string is to be returned
  final LabelMapper? label;

  /// Text Styling for the [label].
  final ChartTextStyle? labelStyle;

  /// Styling for the Bars in this [BarGroup].
  ///
  /// {@macro bar_styling_order}
  final BarDataStyle? groupStyle;

  BarGroup({
    required this.xValue,
    this.label,
    this.labelStyle,
    this.groupStyle,
  });

  factory BarGroup.zero(Type type) {
    if (type == SimpleBar) {
      return SimpleBar.zero();
    }

    if (type == MultiBar) {
      return MultiBar.zero();
    }

    throw TypeError();
  }

  static T when<T>({
    required BarGroup value,
    required T Function() simpleBar,
    required T Function() multiBar,
  }) {
    switch (value.runtimeType) {
      case SimpleBar:
        return simpleBar();
      case MultiBar:
        return multiBar();
      default:
        throw TypeError();
    }
  }

  @override
  BarGroup get zeroValue;

  static BarGroup lerp(BarGroup? a, BarGroup b, double t) {
    final aValue = a == null || a.runtimeType != b.runtimeType ? null : a;
    return BarGroup.when(
      value: b,
      simpleBar: () => SimpleBar.lerp(aValue, b, t),
      multiBar: () => MultiBar.lerp(aValue, b, t),
    );
  }
}
