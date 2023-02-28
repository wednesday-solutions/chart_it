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
              yValue: const BarData(
                yValue: 45,
              ),
            ),
            SimpleBar(
              xValue: 2,
              yValue: const BarData(
                yValue: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
