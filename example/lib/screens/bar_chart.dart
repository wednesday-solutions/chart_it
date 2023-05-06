import 'package:example/screens/bar_chart_animation.dart';
import 'package:example/screens/bar_charts_interaction.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TestBarChart extends StatelessWidget {
  const TestBarChart({Key? key}) : super(key: key);

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
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) => titleGradient.createShader(
                  Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height),
                ),
                child: Text(
                  'Bar Charts',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Bar Chart State Changes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        color: Theme.of(context).colorScheme.onBackground)),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TestBarChartsAnimation(),
              ),
              Text("Tap the chart to change data.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onBackground)),
              const Divider(
                height: 100,
                thickness: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Bar Chart Interactions",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        color: Theme.of(context).colorScheme.onBackground)),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TestBarChartsInteraction(),
              ),
              Text("Tap or drag to interact with the chart.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onBackground)),
              const SizedBox(
                height: 50,
              )
            ],
          )),
        ],
      ),
    );
  }
}
