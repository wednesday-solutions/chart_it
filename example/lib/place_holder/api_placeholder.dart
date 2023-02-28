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
    return Container(
      child: BarChart(
        title: const Text('Demo Chart'),
        chartWidth: 500,
        chartHeight: 500,
        chartStyle: const CartesianChartStyle(
          backgroundColor: Colors.blueGrey,
          alignment: CartesianChartAlignment.spaceEvenly,
          orientation: CartesianChartOrientation.vertical,
          axisStyle: CartesianAxisStyle(
            strokeWidth: 3.0,
            strokeColor: Colors.white,
          ),
          gridStyle: CartesianGridStyle(
            show: true,
            strokeWidth: 1.0,
            strokeColor: Colors.white,
            xUnitsCount: 10,
            xUnitValue: 10.0,
            yUnitsCount: 10,
            yUnitValue: 10.0,
          ),
        ),
        data: BarSeries(
          // mandatory
          seriesStyle: const BarDataStyle(
            barWidth: 10.0,
            barColor: Colors.blue,
            strokeWidth: 1.0,
            strokeColor: Colors.white,
            cornerRadius: Radius.circular(5.0),
          ),
          barData: <BarGroup>[
            // mandatory
            MultiBar(
              groupSpacing: 2.0,
              arrangement: BarGroupArrangement.series,
              // series (default), stack
              // overrides the series style and applies to all bars in the group
              groupStyle: const BarDataStyle(
                barWidth: 10.0,
                barColor: Colors.green,
                strokeWidth: 1.0,
                strokeColor: Colors.white,
                cornerRadius: Radius.circular(5.0),
              ),
              xValue: 1,
              // mandatory
              label: (xValue) => 'Sunday',
              yValues: <BarData>[
                // mandatory
                BarData(
                  yValue: 25, // mandatory
                  label: (yValue) => yValue.toString(),
                ),
                BarData(
                  yValue: 15, // mandatory
                  label: (yValue) => yValue.toString(),
                  // overrides the group style and applies to individual bar
                  barStyle: const BarDataStyle(
                    barWidth: 10.0,
                    barColor: Colors.red,
                    strokeWidth: 1.0,
                    strokeColor: Colors.white,
                    cornerRadius: Radius.circular(5.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
