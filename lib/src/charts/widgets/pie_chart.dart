import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/data/pie.dart';
import 'package:chart_it/src/charts/renderers/radial_renderer.dart';
import 'package:chart_it/src/controllers/radial_controller.dart';
import 'package:flutter/material.dart';

/// Draws a PieChart or Donut Chart for the Provided Data
class PieChart extends StatefulWidget {
  /// Title of the Chart
  final Text? title;

  /// Width of the Chart
  final double? width;

  /// Height of the Chart
  final double? height;

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
    this.width,
    this.height,
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
  late AnimationController _defaultAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize default animation controller
    _defaultAnimation = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    // provide the chart details to the controller
    _controller = RadialController(
      data: [widget.data],
      animation: _provideAnimation(),
      animateOnLoad: widget.animateOnLoad,
      animateOnUpdate: widget.animateOnUpdate,
    );
  }

  @override
  void didUpdateWidget(covariant PieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // We will update our Chart when new data is provided
    _controller.update(
      data: [widget.data],
      animation: _provideAnimation(),
      animateOnLoad: widget.animateOnLoad,
      animateOnUpdate: widget.animateOnUpdate,
    );
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.chartStyle ?? defaultRadialChartStyle;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return RadialRenderer(
          width: widget.width,
          height: widget.height,
          style: style,
          states: _controller.currentData.states,
          interactionDispatcher: _controller,
        );
      },
    );
  }

  AnimationController _provideAnimation() =>
      widget.animation ?? _defaultAnimation
        ..duration = widget.animationDuration;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
