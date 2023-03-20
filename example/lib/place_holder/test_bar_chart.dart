import 'package:chart_it/chart_it.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestBarChart extends StatefulWidget {
  const TestBarChart({Key? key}) : super(key: key);

  @override
  State<TestBarChart> createState() => _TestBarChartState();
}

class _TestBarChartState extends State<TestBarChart> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BarChart(
      // chartHeight: 500,
      // chartWidth: 500,
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
        ),
      ),
      maxYValue: 70.0,
      data: BarSeries(
        seriesStyle: const BarDataStyle(
          barWidth: 10.0,
          barColor: Color(0xFF6D71EE),
          // gradient: LinearGradient(
          //   begin: Alignment.bottomCenter,
          //   end: Alignment.topCenter,
          //   colors: [
          //     Color(0xFF191FC8),
          //     Color(0xFF4247E8),
          //   ],
          // ),
          strokeWidth: 3.0,
          strokeColor: Color(0xFF6D71EE),
          cornerRadius: BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
          ),
        ),
        barData: <BarGroup>[
          SimpleBar(
            xValue: 1,
            label: (value) => 'Group A',
            labelStyle: ChartTextStyle(
              textStyle: GoogleFonts.poppins(
                color: theme.colorScheme.inverseSurface,
              ),
            ),
            yValue: const BarData(
              yValue: 45,
              // barStyle: BarDataStyle(
              //   barWidth: 10.0,
              //   barColor: Color(0xFF6D71EE),
              //   gradient: LinearGradient(
              //     begin: Alignment.bottomCenter,
              //     end: Alignment.topCenter,
              //     colors: [
              //       Color(0xFF191FC8),
              //       Color(0xFF4247E8),
              //     ],
              //   ),
              //   strokeWidth: 3.0,
              //   strokeColor: Color(0xFF6D71EE),
              //   cornerRadius: BorderRadius.only(
              //     topLeft: Radius.circular(5.0),
              //     topRight: Radius.circular(5.0),
              //   ),
              // ),
            ),
          ),
          SimpleBar(
            xValue: 2,
            label: (value) => 'Group B',
            labelStyle: ChartTextStyle(
              textStyle: GoogleFonts.poppins(
                color: theme.colorScheme.inverseSurface,
              ),
            ),
            yValue: const BarData(
              yValue: -22,
            ),
          ),
          SimpleBar(
            xValue: 4,
            label: (value) => 'Group C',
            labelStyle: ChartTextStyle(
              textStyle: GoogleFonts.poppins(
                color: theme.colorScheme.inverseSurface,
              ),
            ),
            yValue: const BarData(
              yValue: 49,
            ),
          ),
        ],
      ),
    );
  }
}
