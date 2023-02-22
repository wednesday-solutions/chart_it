import 'package:flutter/widgets.dart';
import 'package:flutter_charts/src/charts/base/demo_painter.dart';

class PlaceHolderChart extends StatefulWidget {
  const PlaceHolderChart({Key? key}) : super(key: key);

  @override
  State<PlaceHolderChart> createState() => _PlaceHolderChartState();
}

class _PlaceHolderChartState extends State<PlaceHolderChart> {
  // We are going to assume that this placeholder widget is let's say a widget
  // BarChart. Then it's last widget in the tree will be a CustomPaint
  // that will take a painter that deals with drawing only & only Bar Charts
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // We will use a Gesture Detector widget to capture interactions on our charts
      return GestureDetector(
        child: CustomPaint(
          painter: DemoPainter(),
          isComplex: true, // can be used for improving performance with caching
          child: Container(),
        ),
      );
    });
  }
}
