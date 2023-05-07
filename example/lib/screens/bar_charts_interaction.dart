import 'package:chart_it/chart_it.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestBarChartsInteraction extends StatefulWidget {
  const TestBarChartsInteraction({Key? key}) : super(key: key);

  @override
  State<TestBarChartsInteraction> createState() =>
      _TestBarChartsInteractionState();
}

class _TestBarChartsInteractionState extends State<TestBarChartsInteraction> {
  getSeries() {
    return BarSeries(
      interactionEvents: BarInteractionEvents(
          isEnabled: true,
          snapToBarConfig: const SnapToBarConfig.forAll(
              snapToWidth: true,
              snapToHeight: true,
              snapToBarBehaviour: SnapToBarBehaviour.snapToSection),
          onTap: (result) {
            setState(() {
              _interactionIndex = result.barGroupIndex;
              _barIndex = result.barDataIndex;
            });
          },
          onDrag: (result) {
            setState(() {
              _interactionIndex = result.barGroupIndex;
              _barIndex = result.barDataIndex;
            });
          }),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return BarChart(
      height: 400,
      animationDuration: const Duration(milliseconds: 200),
      animateOnLoad: true,
      animateOnUpdate: true,
      maxYValue: 15,
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
          yUnitValue: 5.0,
        ),
      ),
      data: getSeries(),
    );
  }
}

int _interactionIndex = -1;
int _barIndex = -1;

List<BarGroup> makeGroupData(BuildContext context) {
  var theme = Theme.of(context);

  List<BarGroup> barSeries = List.generate(4, (index) {
    if (index % 2 == 0) {
      return SimpleBar(
        xValue: index + 1,
        label: (value) => 'Group ${index + 1}',
        labelStyle: ChartTextStyle(
          textStyle: GoogleFonts.poppins(
            color: theme.colorScheme.inverseSurface,
          ),
        ),
        yValue: BarData(
            yValue: _interactionIndex == index
                ? 9 + index / 2 * 0.5
                : 8 + index / 2 * 0.5),
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
            yValue: _interactionIndex == index
                ? _barIndex == 0
                    ? 10.5 + index * 0.5
                    : 10 + index * 0.5
                : 10 + index * 0.5,
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
            yValue: _interactionIndex == index
                ? _barIndex == 1
                    ? 4.5 + index * 0.5
                    : 4 + index * 0.5
                : 4 + index * 0.5,
          ),
        ],
      );
    }
  });

  return barSeries;
}
