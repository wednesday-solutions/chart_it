import 'dart:math';

import 'package:chart_it/chart_it.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var rng = Random();

class TestBarCharts extends StatefulWidget {
  const TestBarCharts({Key? key}) : super(key: key);

  @override
  State<TestBarCharts> createState() => _TestBarChartsState();
}

class _TestBarChartsState extends State<TestBarCharts> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        child: const Icon(Icons.refresh_rounded),
        onPressed: () => setState(() {}),
      ),
      body: Column(
        children: [
          Expanded(
            child: BarChart(
              title: const Text('Demo Chart'),
              chartStyle: CartesianChartStyle(
                backgroundColor: theme.colorScheme.surface,
                alignment: CartesianChartAlignment.spaceEvenly,
                orientation: CartesianChartOrientation.vertical,
                axisStyle: CartesianAxisStyle(
                  axisWidth: 3.0,
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
                  yUnitValue: 10.0,
                ),
              ),
              data: BarSeries(
                seriesStyle: const BarDataStyle(
                  barWidth: 10.0,
                  barColor: Color(0xFF6D71EE),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF191FC8),
                      Color(0xFF4247E8),
                    ],
                  ),
                  strokeWidth: 3.0,
                  strokeColor: Color(0xFF6D71EE),
                  cornerRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0),
                  ),
                ),
                barData: makeGroupData(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<BarGroup> makeGroupData(BuildContext context) {
  var theme = Theme.of(context);
  double next(num min, num max) => rng.nextDouble() * (max - min) + min;

  List<BarGroup> barSeries = List.generate(5, (index) {
    if (rng.nextBool()) {
      return SimpleBar(
        xValue: index + 1,
        label: (value) => 'Group ${index + 1}',
        labelStyle: ChartTextStyle(
          textStyle: GoogleFonts.poppins(
            color: theme.colorScheme.inverseSurface,
          ),
        ),
        yValue: BarData(yValue: next(10, 100)),
      );
    } else {
      return MultiBar(
        xValue: index + 1,
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
                  Color(0xFF6D71EE),
                  Color(0xFF9295F2),
                ],
              ),
              strokeWidth: 3.0,
              strokeColor: Color(0xFF0D116D),
              cornerRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
            ),
            yValue: next(10, 100),
          ),
          BarData(
            barStyle: const BarDataStyle(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xFF4247E8),
                  Color(0xFF6D71EE),
                ],
              ),
              strokeWidth: 3.0,
              strokeColor: Color(0xFF191FC8),
              cornerRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
            ),
            yValue: next(10, 100),
          ),
        ],
      );
    }
  });

  return barSeries;
}
