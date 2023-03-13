import 'package:flutter/material.dart';
import 'package:chart_it/chart_it.dart';
import 'package:google_fonts/google_fonts.dart';

class TestPieChart extends StatefulWidget {
  const TestPieChart({Key? key}) : super(key: key);

  @override
  State<TestPieChart> createState() => _TestPieChartState();
}

class _TestPieChartState extends State<TestPieChart> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return PieChart(
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
        slices: <SliceData>[
          SliceData(
            value: 5,
            label: (percent, value) => 'Doge',
            labelStyle: ChartTextStyle(
              textStyle: GoogleFonts.poppins(
                color: theme.colorScheme.inverseSurface,
              ),
            ),
            style: const SliceDataStyle(
              radius: 90,
              color: Color(0xFF6D71EE),
            ),
          ),
          SliceData(
            value: 15,
            label: (percent, value) => 'Tether',
            labelStyle: ChartTextStyle(
              textStyle: GoogleFonts.poppins(
                color: theme.colorScheme.inverseSurface,
              ),
            ),
            style: const SliceDataStyle(
              radius: 105,
              color: Color(0xFF9295F2),
            ),
          ),
          SliceData(
            value: 25,
            label: (percent, value) => 'Etherium',
            labelStyle: ChartTextStyle(
              textStyle: GoogleFonts.poppins(
                color: theme.colorScheme.inverseSurface,
              ),
            ),
            style: const SliceDataStyle(
              radius: 100,
              color: Color(0xFF0D116D),
              strokeWidth: 0.0,
              strokeColor: Colors.deepOrange,
            ),
          ),
          SliceData(
            value: 30,
            label: (percent, value) => 'Bitcoin',
            labelStyle: ChartTextStyle(
              textStyle: GoogleFonts.poppins(
                color: theme.colorScheme.inverseSurface,
              ),
            ),
            style: const SliceDataStyle(
              radius: 120,
              color: Color(0xFF191FC8),
              strokeWidth: 0.0,
              strokeColor: Color(0xFF0D116D),
            ),
          ),
        ],
      ),
    );
  }
}
