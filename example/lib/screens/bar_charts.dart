import 'dart:math';

import 'package:chart_it/chart_it.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

var rng = Random();

class TestBarCharts extends StatefulWidget {
  const TestBarCharts({Key? key}) : super(key: key);

  @override
  State<TestBarCharts> createState() => _TestBarChartsState();
}

class _TestBarChartsState extends State<TestBarCharts> {
  final LinearGradient titleGradient = const LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    stops: [
      0.1,
      0.4,
      0.95,
    ],
    colors: <Color>[
      Color(0xFFE39F56),
      Color(0xFFBDA2F4),
      Color(0xFFE39F56),
    ],
  );

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
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) => titleGradient.createShader(
                  Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height),
                ),
                child: Text(
                  'Bar Charts',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
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
                  xUnitValue: 1.0,
                  yUnitValue: 10.0,
                ),
              ),
              data: BarSeries(
                interactionEvents: BarInteractionEvents(
                  isEnabled: true,
                  snapToNearestBar: true,
                  onTap: (BarInteractionResult result) {
                    // print('Touched Bar ${result.barDataIndex} of '
                    //     'BarGroup: ${result.barGroup.label?.call(0)} and '
                    //     'of type ${result.barGroup.runtimeType.toString()}');
                  },
                ),
                seriesStyle: const BarDataStyle(
                  barWidth: 10.0,
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
            yValue: next(10, 100),
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
            yValue: next(10, 100),
          ),
        ],
      );
    }
  });

  return barSeries;
}