import 'dart:math';

import 'package:chart_it/chart_it.dart';
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
                  'Pie & Donut Charts',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                  ),
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
      return const Color(0xFFBDA2F4);
    case 1:
      return const Color(0xFF7136E7);
    case 2:
      return const Color(0xFF693C00);
    case 3:
      return const Color(0xFF9295F2);
    case 4:
      return const Color(0xFFFFB86E);
    default:
      return Colors.transparent;
  }
}
