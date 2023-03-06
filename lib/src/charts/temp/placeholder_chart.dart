import 'package:flutter/widgets.dart';
import 'package:flutter_charts/src/charts/constants/defaults.dart';
import 'package:flutter_charts/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:flutter_charts/src/charts/painters/demo_painter.dart';
import 'package:flutter_charts/src/common/cartesian_observer.dart';

class PlaceHolderChart extends StatefulWidget {
  const PlaceHolderChart({Key? key}) : super(key: key);

  @override
  State<PlaceHolderChart> createState() => _PlaceHolderChartState();
}

class _PlaceHolderChartState extends State<PlaceHolderChart> {
  late CartesianObserver observer;

  // We are going to assume that this placeholder widget is let's say a widget
  // BarChart. Then it's last widget in the tree will be a CustomPaint
  // that will take a painter that deals with drawing only & only Bar Charts
  @override
  void initState() {
    super.initState();

    observer = CartesianObserver(
      minValue: 0,
      maxValue: 150,
      maxXRange: 25,
      maxYRange: 150,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // We will use a Gesture Detector widget to capture interactions on our charts
      return GestureDetector(
        child: CustomPaint(
          painter: CartesianChartPainter(
            style: defaultCartesianChartStyle,
            observer: observer,
            painters: [
              DemoPainter(),
            ],
          ),
          isComplex: true, // can be used for improving performance with caching
          child: Container(),
        ),
      );
    });
  }
}
