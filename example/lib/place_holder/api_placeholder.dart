import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';

class ApiPlaceHolder extends StatefulWidget {
  const ApiPlaceHolder({Key? key}) : super(key: key);

  @override
  State<ApiPlaceHolder> createState() => _ApiPlaceHolderState();
}

class _ApiPlaceHolderState extends State<ApiPlaceHolder> {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      title: const Text('Demo Chart'),
      chartWidth: 500,
      chartHeight: 500,
      chartStyle: const CartesianChartStyle(
        backgroundColor: Colors.blueGrey,
        alignment: CartesianChartAlignment.spaceEvenly,
        orientation: CartesianChartOrientation.vertical,
        axisStyle: CartesianAxisStyle(
          axisWidth: 3.0,
          showXAxisLabels: false,
          axisColor: Colors.white,
          tickColor: Colors.white,
        ),
        gridStyle: CartesianGridStyle(
          show: true,
          gridLineWidth: 1.0,
          gridLineColor: Colors.white,
          yUnitValue: 10.0,
        ),
      ),
      data: BarSeries(
        seriesStyle: const BarDataStyle(
          barWidth: 10.0,
          barColor: Colors.amber,
          strokeWidth: 3.0,
          strokeColor: Colors.cyan,
          cornerRadius: BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
          ),
        ),
        barData: <BarGroup>[
          SimpleBar(
            xValue: 1,
            label: (value) => 'Sunday',
            yValue: const BarData(
              yValue: 45,
            ),
          ),
          SimpleBar(
            xValue: 2,
            label: (value) => 'Monday',
            yValue: const BarData(
              yValue: -22,
            ),
          ),
          MultiBar(
            xValue: 3,
            label: (value) => 'Tuesday',
            yValues: [
              const BarData(yValue: 57),
              const BarData(yValue: 38),
            ],
          ),
          SimpleBar(
            xValue: 4,
            label: (value) => 'Wednesday',
            yValue: const BarData(
              yValue: 49,
            ),
          ),
          MultiBar(
            xValue: 5,
            label: (value) => 'Thursday',
            yValues: [
              const BarData(yValue: 8),
              const BarData(yValue: 38),
            ],
          ),
          MultiBar(
            xValue: 5,
            label: (value) => 'Friday',
            yValues: [
              const BarData(yValue: 26),
              const BarData(yValue: -12),
              const BarData(yValue: 39),
            ],
          ),
          SimpleBar(
            xValue: 4,
            label: (value) => 'Saturday',
            yValue: const BarData(
              yValue: 36,
            ),
          ),
        ],
      ),
    );
  }
}
