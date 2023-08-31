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
        child: CandleStickChart(
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
          chartStructureData: const CartesianChartStructureData(
            xUnitValue: 1,
            yUnitValue: 200,
          ),
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
          data: CandleStickSeries(
            candles: [
              Candle(
                date: DateTime.now().subtract(const Duration(days: 4)),
                open: 1780.36,
                high: 1873.93,
                low: 1755.34,
                close: 1848.56,
                volume: 0,
              ),
              Candle(
                date: DateTime.now().subtract(const Duration(days: 3)),
                open: 1780.36,
                high: 1873.93,
                low: 1755.34,
                close: 1848.56,
                volume: 0,
              ),
              Candle(
                date: DateTime.now().subtract(const Duration(days: 2)),
                open: 1780.36,
                high: 1873.93,
                low: 1755.34,
                close: 1848.56,
                volume: 0,
              ),
              Candle(
                date: DateTime.now().subtract(const Duration(days: 1)),
                open: 1780.36,
                high: 1873.93,
                low: 1755.34,
                close: 1848.56,
                volume: 0,
              ),
              Candle(
                date: DateTime.now(),
                open: 1780.36,
                high: 1873.93,
                low: 1755.34,
                close: 1848.56,
                volume: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
