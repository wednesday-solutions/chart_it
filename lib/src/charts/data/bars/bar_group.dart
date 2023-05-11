import 'package:chart_it/src/animations/lerps.dart';
import 'package:chart_it/src/charts/data/bars/bar_data_style.dart';
import 'package:chart_it/src/charts/data/bars/multi_bar.dart';
import 'package:chart_it/src/charts/data/bars/simple_bar.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/shared/chart_text_style.dart';
import 'package:equatable/equatable.dart';

/// Sets the Arrangement for all the bars in a [BarGroup].
///
/// * Use [series] to have all the bars arranged alongside each other.
/// * Use [stack] to create a stack of all the bars in a group.
enum BarGroupArrangement { series, stack }

/// {@template bar_group}
/// Defines the structure of a Group of Bars.
///
/// Holds the X-Value, Labels and Styling.
/// {@endtemplate}
abstract class BarGroup with EquatableMixin {
  /// The Value along X-Axis for this [BarGroup].
  ///
  /// This value is not used for plotting on X-Axis.
  /// The plotting is done based on the index of this item in the list.
  final num xValue;

  /// Styling for the Bars in this [BarGroup].
  ///
  /// {@macro bar_styling_order}
  final BarDataStyle? groupStyle;

  /// {@macro bar_group}
  BarGroup({
    required this.xValue,
    this.groupStyle,
  });

  /// Lerps between two [BarGroup] objects for a factor [t].
  ///
  /// If subtypes of the two objects are not identical, then it lerps
  /// from null to [target] object's type.
  static BarGroup lerp(BarGroup? current, BarGroup target, double t) {
    final currentValue =
        current == null || current.runtimeType != target.runtimeType
            ? null
            : current;
    return target._when(
      simpleBar: () => SimpleBar.lerp(currentValue, target, t),
      multiBar: () => MultiBar.lerp(currentValue, target, t),
    );
  }

  /// Lerps between two Lists of [BarGroup] for a factor [t].
  static List<BarGroup> lerpBarGroupList(
    List<BarGroup>? current,
    List<BarGroup> target,
    double t,
  ) =>
      lerpList(current, target, t, lerp: lerp);

  /// Helper method to capture [runtimeType] checks for the subtype of
  /// [BarGroup] object, and provides callback method for the matching type.
  T _when<T>({
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
}
