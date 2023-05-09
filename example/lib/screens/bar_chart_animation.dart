import 'dart:math';

import 'package:chart_it/chart_it.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        title: const Text('Demo Chart'),
        chartStructureData: CartesianChartStructureData(
          xUnitValue: 2
        ),
        chartStylingData: CartesianChartStylingData(
          backgroundColor: theme.colorScheme.surface,
          axisStyle: CartesianAxisStyle(
            axisWidth: 4.0,
            showXAxisLabels: false,
            axisColor: theme.colorScheme.onBackground,
            tickColor: theme.colorScheme.onBackground,
            tickLabelStyle: ChartTextStyle(
              textStyle: GoogleFonts.poppins(
                color: theme.colorScheme.inverseSurface,
              ),
            ),
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
  var theme = Theme.of(context);
  double next(num min, num max) => rng.nextDouble() * (max - min) + min;

  List<BarGroup> barSeries = List.generate(next(3, 5).toInt(), (index) {
    if (rng.nextBool()) {
      return SimpleBar(
        xValue: index + 1,
        label: (value) => 'Group ${index + 1}',
        labelStyle: ChartTextStyle(
          textStyle: GoogleFonts.poppins(
            color: theme.colorScheme.inverseSurface,
          ),
        ),
        yValue: BarData(yValue: next(10, 90)),
      );
    } else {
      return MultiBar(
        xValue: index + 1,
        groupSpacing: 10.0,
        label: (value) => 'Group ${index + 1}',
        labelStyle: ChartTextStyle(
          textStyle: GoogleFonts.poppins(
            color: theme.colorScheme.inverseSurface,
          ),
        ),
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
            yValue: next(10, 90),
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
            yValue: next(10, 90),
          ),
        ],
      );
    }
  });

  return barSeries;
}
