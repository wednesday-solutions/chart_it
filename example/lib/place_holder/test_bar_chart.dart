import 'dart:math';

import 'package:chart_it/chart_it.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var rng = Random();

class TestBarChart extends StatefulWidget {
  const TestBarChart({Key? key}) : super(key: key);

  @override
  State<TestBarChart> createState() => _TestBarChartState();
}

class _TestBarChartState extends State<TestBarChart> {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: FpsTickerProvider(
          fps: 30,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          height: 400,
          child: BarChart(
            maxYValue: 100,
            // animation: _animationController,
            title: const Text('Demo Chart'),
            chartStyle: CartesianChartStyle(
              backgroundColor: theme.canvasColor,
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
                xUnitValue: 1
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
        Center(
          child: SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              child: const Text('Randomize Data'),
              onPressed: () => setState(() {}),
            ),
          ),
        )
      ],
    );
  }
}

List<BarGroup> makeGroupData(BuildContext context) {
  var theme = Theme.of(context);
  double next(num min, num max) => rng.nextDouble() * (max - min) + min;

  List<BarGroup> barSeries = List.generate(10.toInt(), (index) {
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
