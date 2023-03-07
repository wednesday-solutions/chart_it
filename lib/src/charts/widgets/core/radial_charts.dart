import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/data/core/radial_data.dart';
import 'package:flutter_charts/src/charts/painters/radial/radial_chart_painter.dart';
import 'package:flutter_charts/src/charts/painters/radial/radial_painter.dart';
import 'package:flutter_charts/src/common/radial_observer.dart';

class RadialCharts extends StatefulWidget {
  final double? width;
  final double? height;
  final RadialChartStyle style;

  // Mandatory Fields
  final List<RadialPainter> painters;
  final RadialObserver observer;

  const RadialCharts({
    Key? key,
    this.width,
    this.height,
    required this.style,
    required this.painters,
    required this.observer,
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
              observer: widget.observer,
              painters: widget.painters,
            ),
            child: SizedBox(
              width: widget.width,
              height: widget.height,
            ),
          ),
        );
      },
    );
  }
}
