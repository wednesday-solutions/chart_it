import 'package:chart_it/chart_it.dart';
import 'package:flutter/material.dart';

class ScaledCharts extends StatefulWidget {
  const ScaledCharts({super.key});

  @override
  State<ScaledCharts> createState() => _ScaledChartsState();
}

class _ScaledChartsState extends State<ScaledCharts> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: BarChart(
          height: 600,
          axisLabels: AxisLabels(
            left: AxisLabelConfig(
              constraintEdgeLabels: false,
              builder: (index, _) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  '$index',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            bottom: AxisLabelConfig(
              centerLabels: true,
              builder: (index, _) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '$index',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          chartStructureData: const CartesianChartStructureData(xUnitValue: 1),
          chartStylingData: CartesianChartStylingData(
            backgroundColor: theme.colorScheme.surface,
            axisStyle: CartesianAxisStyle(
              axisWidth: 4.0,
              axisColor: theme.colorScheme.onBackground,
              tickConfig: AxisTickConfig.forAllAxis(
                tickColor: theme.colorScheme.inverseSurface,
              ),
            ),
            gridStyle: CartesianGridStyle(
              show: true,
              gridLineWidth: 0.5,
              gridLineColor: theme.colorScheme.onBackground,
            ),
          ),
          data: BarSeries(
            seriesStyle: const BarDataStyle(
              barColor: Color(0xFFBDA2F4),
              strokeWidth: 3.0,
              strokeColor: Color(0xFF7136E7),
              cornerRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
            ),
            barData: <BarGroup>[
              SimpleBar(
                xValue: 1,
                yValue: const BarData(yValue: 10.0),
              ),
              SimpleBar(
                xValue: 2,
                yValue: const BarData(yValue: 40.0),
              ),
              SimpleBar(
                xValue: 3,
                yValue: const BarData(yValue: 90.0),
              ),
              SimpleBar(
                xValue: 4,
                yValue: const BarData(yValue: 70.0),
              ),
              SimpleBar(
                xValue: 5,
                yValue: const BarData(yValue: 20.0),
              ),
              SimpleBar(
                xValue: 6,
                yValue: const BarData(yValue: 60.0),
              ),
              SimpleBar(
                xValue: 7,
                yValue: const BarData(yValue: 80.0),
              ),
              SimpleBar(
                xValue: 8,
                yValue: const BarData(yValue: 0.0),
              ),
              SimpleBar(
                xValue: 9,
                yValue: const BarData(yValue: 100.0),
              ),
              SimpleBar(
                xValue: 10,
                yValue: const BarData(yValue: 50.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
