import 'dart:math';

import 'package:chart_it/chart_it.dart';
import 'package:example/themes/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

var rng = Random();

class TestPieCharts extends StatefulWidget {
  const TestPieCharts({Key? key}) : super(key: key);

  @override
  State<TestPieCharts> createState() => _TestPieChartsState();
}

class _TestPieChartsState extends State<TestPieCharts> {
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
              child: Text(
                'Pie & Donut Charts',
                style: TextStyle(
                  color: darkTheme.tertiary,
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: PieChart(
              title: const Text('Demo Chart'),
              chartStyle: RadialChartStyle(
                backgroundColor: theme.canvasColor,
              ),
              data: PieSeries(
                donutRadius: 50.0,
                donutSpaceColor: Colors.transparent,
                donutLabelStyle: ChartTextStyle(
                  textStyle: GoogleFonts.poppins(
                    color: theme.colorScheme.inverseSurface,
                  ),
                ),
                donutLabel: () => 'Crypto',
                slices: makeSliceData(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<SliceData> makeSliceData(BuildContext context) {
  var theme = Theme.of(context);
  double next(num min, num max) => rng.nextDouble() * (max - min) + min;

  List<SliceData> barSeries = List.generate(5, (index) {
    return SliceData(
      value: rng.nextInt(100),
      label: (percent, value) => getCryptoName(index),
      labelStyle: ChartTextStyle(
        textStyle: GoogleFonts.poppins(
          color: theme.colorScheme.inverseSurface,
        ),
      ),
      style: SliceDataStyle(
        radius: next(70.0, 150.0),
        color: getColorForPiece(index),
        strokeWidth: 0.0,
        strokeColor: const Color(0xFF0D116D),
      ),
    );
  });

  return barSeries;
}

String getCryptoName(int index) {
  switch (index) {
    case 0:
      return 'Bitcoin';
    case 1:
      return 'Ethereum';
    case 2:
      return 'Binance';
    case 3:
      return 'Tether';
    case 4:
      return 'DOGE';
    default:
      return '';
  }
}

Color getColorForPiece(int index) {
  switch (index) {
    case 0:
      return const Color(0xFF6D71EE);
    case 1:
      return const Color(0xFF9295F2);
    case 2:
      return const Color(0xFF0D116D);
    case 3:
      return const Color(0xFF191FC8);
    case 4:
      return Colors.deepPurple;
    default:
      return Colors.transparent;
  }
}
