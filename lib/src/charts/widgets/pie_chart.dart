import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/data/core/radial/radial_styling.dart';
import 'package:chart_it/src/charts/data/pie/pie_series.dart';
import 'package:chart_it/src/charts/widgets/core/radial_charts.dart';
import 'package:chart_it/src/controllers/radial_controller.dart';
import 'package:flutter/material.dart';

/// Draws a PieChart or Donut Chart for the Provided Data
class PieChart extends StatefulWidget {
  /// Title of the Chart
  final Text? title;

  /// Width of the Chart
  final double? chartWidth;

  /// Height of the Chart
  final double? chartHeight;

  /// Animates the Charts from zero values to given Data when the
  /// Chart loads for the first time.
  ///
  /// Defaults to true.
  final bool animateOnLoad;

  /// Controls if the charts should auto animate any updates to the data
  ///
  /// Defaults to true.
  final bool animateOnUpdate;

  /// The Duration for which the chart should animate
  final Duration animationDuration;

  /// A custom Animation controller to drive the chart animations
  final AnimationController? animation;

  /// Styling for the Chart. Includes options like
  /// Background, StartAngle, etc.
  final RadialChartStyle? chartStyle;

  /// The Data which will be Drawn as Pieces of Pie
  final PieSeries data;

  const PieChart({
    Key? key,
    this.title,
    this.chartWidth,
    this.chartHeight,
    this.animateOnLoad = true,
    this.animateOnUpdate = true,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animation,
    this.chartStyle,
    required this.data,
  }) : super(key: key);

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart>
    with SingleTickerProviderStateMixin {
  late RadialController _controller;

  @override
  void initState() {
    super.initState();
    // provide the chart details to the controller
    _controller = RadialController(
      targetData: [widget.data],
      animateOnLoad: widget.animateOnLoad,
      animateOnUpdate: widget.animateOnUpdate,
      animation: widget.animation ??
          AnimationController(
            duration: widget.animationDuration,
            vsync: this,
          ),
    );
  }

  @override
  void didUpdateWidget(covariant PieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // We will update our Chart when new data is provided
    _controller.updateDataSeries([widget.data]);
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.chartStyle ?? defaultRadialChartStyle;
    return RadialCharts(
      controller: _controller,
      width: widget.chartWidth,
      height: widget.chartHeight,
      style: style,
    );
  }
}
