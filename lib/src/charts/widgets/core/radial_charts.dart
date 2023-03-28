import 'package:chart_it/src/charts/data/core/radial/radial_styling.dart';
import 'package:chart_it/src/charts/painters/radial/radial_chart_painter.dart';
import 'package:chart_it/src/controllers/radial_controller.dart';
import 'package:flutter/material.dart';

class RadialCharts extends StatefulWidget {
  final double? width;
  final double? height;
  final RadialChartStyle style;

  // Mandatory Fields
  final RadialController controller;

  const RadialCharts({
    Key? key,
    this.width,
    this.height,
    required this.style,
    required this.controller,
  }) : super(key: key);

  @override
  State<RadialCharts> createState() => _RadialChartsState();
}

class _RadialChartsState extends State<RadialCharts> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          // Handle tap gestures
          onTapDown: (details) {},
          onTapUp: (details) {},
          onScaleStart: (details) {},
          onScaleUpdate: (details) {},
          onScaleEnd: (details) {},
          child: CustomPaint(
            isComplex: true,
            painter: RadialChartPainter(
              style: widget.style,
              controller: widget.controller,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(
                width: widget.width,
                height: widget.height,
              ),
            ),
          ),
        );
      },
    );
  }
}
