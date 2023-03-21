import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_styling.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/controllers/cartesian_controller.dart';
import 'package:flutter/material.dart';

class CartesianCharts extends StatefulWidget {
  final double? width;
  final double? height;
  final CartesianChartStyle style;

  // Mandatory Fields
  final CartesianPaintConstructor constructPainters;

  // final List<CartesianPainter> painters;
  final CartesianController controller;

  const CartesianCharts({
    Key? key,
    this.width,
    this.height,
    required this.style,
    required this.controller,
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
              controller: widget.controller,
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
