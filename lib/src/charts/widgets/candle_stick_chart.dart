import 'package:chart_it/src/charts/data/candlestick/candle_stick_series.dart';
import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/renderers/cartesian_renderer.dart';
import 'package:chart_it/src/charts/renderers/cartesian_scaffold_renderer.dart';
import 'package:chart_it/src/charts/widgets/cartesian_chart.dart';
import 'package:chart_it/src/controllers/cartesian_controller.dart';
import 'package:flutter/material.dart';

/// Draws a CandleStickChart for the Provided Data
class CandleStickChart extends CartesianChart {
  /// The Data which will be Drawn as Bars
  final CandleStickSeries data;

  const CandleStickChart({
    super.key,
    super.width,
    super.height,
    super.animateOnLoad = true,
    super.animateOnUpdate = true,
    super.animationDuration = const Duration(milliseconds: 500),
    super.animation,
    super.chartStructureData,
    super.chartStylingData,
    super.axisLabels,
    required this.data,
  });

  @override
  State<CandleStickChart> createState() => _CandleStickChartState();
}

class _CandleStickChartState extends State<CandleStickChart>
    with SingleTickerProviderStateMixin {
  late CartesianController _controller;
  late AnimationController _defaultAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize default animation controller
    _defaultAnimation = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Now we can provide the chart details to the observer
    _controller = CartesianController(
      data: [widget.data],
      animation: _provideAnimation(),
      animateOnLoad: widget.animateOnLoad,
      animateOnUpdate: widget.animateOnUpdate,
      structureData: widget.chartStructureData,
      stylingData: widget.chartStylingData,
      enforceOriginsWithZero: false,
      calculateRange: (context) {
        final structure = widget.chartStructureData;
        var minXRange = context.minX;
        var maxXRange = structure.maxXValue?.toDouble() ?? context.maxX;
        var maxYRange = structure.maxYValue?.toDouble() ?? context.maxY;
        return CartesianRangeResult(
          xUnitValue: 86400, // 1 Day of difference
          yUnitValue: structure.yUnitValue.toDouble(),
          // For Bar charts, we don't consider x values, be it +ve or -ve
          minXRange: minXRange,
          maxXRange: maxXRange,
          minYRange: context.minY,
          maxYRange: maxYRange,
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant CandleStickChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // We will update our Chart when new data is provided
    _controller.update(
      data: [widget.data],
      animation: _provideAnimation(),
      animateOnLoad: widget.animateOnLoad,
      animateOnUpdate: widget.animateOnUpdate,
      structureData: widget.chartStructureData,
      stylingData: widget.chartStylingData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final stylingData = widget.chartStylingData.copyWith(
          backgroundColor: widget.chartStylingData.backgroundColor ??
              Theme.of(context).colorScheme.background,
        );
        return CartesianScaffold(
          gridUnitsData: _controller.currentData.gridUnitsData,
          structure: widget.chartStructureData,
          stylingData: stylingData,
          width: widget.width,
          height: widget.height,
          leftLabel: widget.axisLabels.left,
          rightLabel: widget.axisLabels.right,
          bottomLabel: widget.axisLabels.bottom,
          topLabel: widget.axisLabels.top,
          chart: CartesianChartContainer(
            style: stylingData,
            structure: widget.chartStructureData,
            states: _controller.currentData.states,
            gridUnitsData: _controller.currentData.gridUnitsData,
            interactionDispatcher: _controller,
          ),
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
