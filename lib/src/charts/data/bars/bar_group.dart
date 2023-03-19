import 'package:chart_it/chart_it.dart';
import 'package:chart_it/src/animations/lerps.dart';

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

  T when<T>({
    required T Function() simpleBar,
    required T Function() multiBar,
  }) {
    switch (runtimeType) {
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

  static BarGroup lerp(BarGroup? current, BarGroup target, double t) {
    final currentValue = current == null || current.runtimeType != target.runtimeType ? null : current;
    return target.when(
      simpleBar: () => SimpleBar.lerp(currentValue, target, t),
      multiBar: () => MultiBar.lerp(currentValue, target, t),
    );
  }

  static List<BarGroup> lerpBarGroupList(
    List<BarGroup>? current,
    List<BarGroup> target,
    double t,
  ) =>
      lerpList(
        current,
        target,
        t,
        lerp: lerp,
      );
}
