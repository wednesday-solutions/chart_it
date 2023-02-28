import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/data/core/cartesian_data.dart';
import 'package:flutter_charts/src/charts/painters/cartesian_chart_painter.dart';
import 'package:flutter_charts/src/charts/painters/cartesian_painter.dart';
import 'package:flutter_charts/src/common/cartesian_observer.dart';

class CartesianCharts extends StatefulWidget {
  final double? width;
  final double? height;
  final CartesianChartStyle style;

  // Mandatory Fields
  final List<CartesianPainter> painters;
  final CartesianObserver observer;

  const CartesianCharts({
    Key? key,
    this.width,
    this.height,
    required this.style,
    required this.painters,
    required this.observer,
  }) : super(key: key);

  @override
  State<CartesianCharts> createState() => _CartesianChartsState();
}

class _CartesianChartsState extends State<CartesianCharts> {
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
            painter: CartesianChartPainter(
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
