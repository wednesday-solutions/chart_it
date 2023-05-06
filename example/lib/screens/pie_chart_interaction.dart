
import 'package:chart_it/chart_it.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestPieChartsInteraction extends StatefulWidget {
  const TestPieChartsInteraction({Key? key}) : super(key: key);

  @override
  State<TestPieChartsInteraction> createState() =>
      _TestPieChartsInteractionState();
}

class _TestPieChartsInteractionState extends State<TestPieChartsInteraction> {
  int interactionIndex = -1;

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
    return PieChart(
      height: 400,
      animationDuration: const Duration(milliseconds: 300),
      title: const Text('Demo Chart'),
      chartStyle: RadialChartStyle(
        backgroundColor: theme.canvasColor,
      ),
      data: PieSeries(
        donutRadius: 40.0,
        donutSpaceColor: Colors.transparent,
        donutLabelStyle: ChartTextStyle(
          textStyle: GoogleFonts.poppins(
            color: theme.colorScheme.inverseSurface,
          ),
        ),
        donutLabel: () => 'Crypto',
        interactionEvents: PieInteractionEvents(
          isEnabled: true,
          onTap: (PieInteractionResult result) {
            setState(() {
              interactionIndex = result.sliceDataIndex;
            });
          },
        ),
        slices: makeSliceData(context),
      ),
    );
  }

  List<SliceData> makeSliceData(BuildContext context) {
    var theme = Theme.of(context);

    List<SliceData> barSeries = List.generate(5, (index) {
      return SliceData(
        value: 50 * index / 2,
        label: (percent, value) => getCryptoName(index),
        labelStyle: ChartTextStyle(
          textStyle: GoogleFonts.poppins(
            color: theme.colorScheme.inverseSurface,
          ),
        ),
        style: SliceDataStyle(
          radius: index == interactionIndex ? 120 : 110,
          color: getColorForPiece(index),
          strokeWidth: 0.0,
          strokeColor: const Color(0xFF0D116D),
        ),
      );
    });

    return barSeries;
  }
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
