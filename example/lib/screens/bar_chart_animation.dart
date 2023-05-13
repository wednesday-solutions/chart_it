import 'dart:math';

import 'package:chart_it/chart_it.dart';
import 'package:flutter/material.dart';

var rng = Random();

class TestBarChartsAnimation extends StatefulWidget {
  const TestBarChartsAnimation({Key? key}) : super(key: key);

  @override
  State<TestBarChartsAnimation> createState() => _TestBarChartsAnimationState();
}

class _TestBarChartsAnimationState extends State<TestBarChartsAnimation> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        setState(() {});
      },
      child: BarChart(
        height: 400,
        chartStructureData: const CartesianChartStructureData(xUnitValue: 1),
        chartStylingData: CartesianChartStylingData(
          backgroundColor: theme.colorScheme.surface,
          axisStyle: CartesianAxisStyle(
            axisWidth: 4.0,
            axisColor: theme.colorScheme.onBackground,
            tickConfig: AxisTickConfig.forAllAxis(
                tickColor: theme.colorScheme.inverseSurface),
          ),
          gridStyle: CartesianGridStyle(
            show: true,
            gridLineWidth: 1.0,
            gridLineColor: theme.colorScheme.onBackground,
          ),
        ),
        data: BarSeries(
          seriesStyle: const BarDataStyle(
            barColor: Color(0xFFBDA2F4),
            strokeWidth: 3.0,
            strokeColor: Color(0xFF7136E7),
            cornerRadius: BorderRadius.only(
              topLeft: Radius.circular(5.0),
              topRight: Radius.circular(5.0),
            ),
          ),
          barData: makeGroupData(context),
        ),
      ),
    );
  }
}

List<BarGroup> makeGroupData(BuildContext context) {
  double next(num min, num max) => rng.nextDouble() * (max - min) + min;

  List<BarGroup> barSeries = List.generate(next(3, 5).toInt(), (index) {
    if (rng.nextBool()) {
      return SimpleBar(
        xValue: index + 1,
        yValue: BarData(yValue: next(-15, 90)),
      );
    } else {
      return MultiBar(
        xValue: index + 1,
        yValues: [
          BarData(
            barStyle: const BarDataStyle(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xFFBDA2F4),
                  Color(0xFF7136E7),
                ],
              ),
              strokeWidth: 3.0,
              strokeColor: Color(0xFFBDA2F4),
              cornerRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
            ),
            yValue: next(-10, 90),
          ),
          BarData(
            barStyle: const BarDataStyle(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xFFE39F56),
                  Color(0xFFBDA2F4),
                ],
              ),
              strokeWidth: 3.0,
              strokeColor: Color(0xFFE39F56),
              cornerRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
            ),
            yValue: next(-20, 90),
          ),
        ],
      );
    }
  });

  return barSeries;
}
