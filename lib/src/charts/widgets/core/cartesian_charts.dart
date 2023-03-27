import 'package:chart_it/src/charts/data/core/cartesian/cartesian_styling.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/charts/widgets/core/chart_gesture_detector.dart';
import 'package:chart_it/src/controllers/cartesian_controller.dart';
import 'package:chart_it/src/interactions/data/chart_interaction_type.dart';
import 'package:chart_it/src/interactions/hit_test/interaction_dispatcher.dart';
import 'package:flutter/material.dart';

class NewW extends MultiChildRenderObjectWidget {
  NewW({super.key});

  @override
  RenderObject createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    throw UnimplementedError();
  }

}

class NewRObj extends RenderBox {
    @override
  void paint(PaintingContext context, Offset offset) {

    super.paint(context, offset);
  }


}


class CartesianCharts extends StatefulWidget {
  final double? width;
  final double? height;

  final double? uMinXValue;
  final double? uMaxXValue;
  final double? uMinYValue;
  final double? uMaxYValue;

  // Mandatory Fields
  final CartesianChartStyle style;
  final CartesianController controller;

  const CartesianCharts({
    Key? key,
    this.width,
    this.height,
    this.uMinXValue,
    this.uMaxXValue,
    this.uMinYValue,
    this.uMaxYValue,
    required this.style,
    required this.controller,
  }) : super(key: key);

  @override
  State<CartesianCharts> createState() => _CartesianChartsState();
}


class _CartesianChartsState extends State<CartesianCharts> {
  @override
  Widget build(BuildContext context) {
    return ChartGestureDetector(
      interactionController: widget.controller,
      child: CustomPaint(
        isComplex: true,
        painter: CartesianChartPainter(
          uMinXValue: widget.uMinXValue,
          uMaxXValue: widget.uMaxXValue,
          uMinYValue: widget.uMinYValue,
          uMaxYValue: widget.uMaxYValue,
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
  }
}
