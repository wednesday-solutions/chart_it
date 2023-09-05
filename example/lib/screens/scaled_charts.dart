import 'dart:math';

import 'package:chart_it/chart_it.dart';
import 'package:flutter/material.dart';

var rng = Random();

class CandleStickCharts extends StatefulWidget {
  const CandleStickCharts({super.key});

  @override
  State<CandleStickCharts> createState() => _CandleStickChartsState();
}

class _CandleStickChartsState extends State<CandleStickCharts> {
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
              builder: (_, value) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          chartStructureData: const CartesianChartStructureData(
            xUnitValue: 1,
            yUnitValue: 500,
          ),
          chartStylingData: CartesianChartStylingData(
            backgroundColor: theme.colorScheme.surface,
            axisStyle: CartesianAxisStyle(
              axisWidth: 2.0,
              axisColor: theme.colorScheme.onBackground,
              tickConfig: AxisTickConfig.forAllAxis(
                tickColor: theme.colorScheme.inverseSurface,
              ),
            ),
            gridStyle: CartesianGridStyle(
              show: true,
              gridLineWidth: 0.15,
              gridLineColor: theme.colorScheme.onBackground,
            ),
          ),
          data: CandleStickSeries(candles: _sampleCandleData()),
        ),
      ),
    );
  }

  List<Candle> _sampleCandleData() {
    var listLength = 50;
    double next(num min, num max) => rng.nextDouble() * (max - min) + min;

    return List.generate(listLength, (index) {
      /// TODO Things to take care of here!!!
      /// 1. Opening cannot exceed high
      /// 2. Closing cannot exceed low
      final high = next(1500, 5000);
      final low = next(1000, 4000);

      final open = next(high, low);
      final close = rng.nextBool() ? next(open, high) : next(low, open);

      return Candle(
        // date: DateTime.now().subtract(
        //   Duration(days: listLength - (index + 1)),
        // ),
        open: open,
        high: high,
        low: low,
        close: close,
        volume: 0,
      );
    });
  }
}
