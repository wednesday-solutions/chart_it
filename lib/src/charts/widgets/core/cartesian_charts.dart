import 'package:chart_it/src/charts/data/core/cartesian_data.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/common/cartesian_observer.dart';
import 'package:flutter/material.dart';

class CartesianCharts extends StatefulWidget {
  final double? width;
  final double? height;
  final CartesianChartStyle style;

  // Mandatory Fields
  final CartesianPaintConstructor constructPainters;

  // final List<CartesianPainter> painters;
  final CartesianObserver observer;

  const CartesianCharts({
    Key? key,
    this.width,
    this.height,
    required this.style,
    required this.observer,
    required this.constructPainters,
    // required this.painters,
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
              // painters: widget.painters,
              paintBuilder: widget.constructPainters,
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
