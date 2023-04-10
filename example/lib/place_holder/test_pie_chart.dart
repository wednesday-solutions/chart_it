import 'dart:math';

import 'package:chart_it/chart_it.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var rng = Random();

class TestPieChart extends StatefulWidget {
  const TestPieChart({Key? key}) : super(key: key);

  @override
  State<TestPieChart> createState() => _TestPieChartState();
}

class _TestPieChartState extends State<TestPieChart> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
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
        Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                child: const Text('Randomize Data'),
                onPressed: () => setState(() {}),
              ),
            ),
          ),
        ),
      ],
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
