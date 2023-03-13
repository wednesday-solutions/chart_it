import 'package:example/place_holder/test_pie_chart.dart';
import 'package:example/showcase.dart';
import 'package:flutter/material.dart';

void main() {
  ///Call this first to make sure we can make other system level calls safely
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(const MyApp());
  runApp(const ShowcaseApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Charts Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TestPieChart(),
    );
  }
}
