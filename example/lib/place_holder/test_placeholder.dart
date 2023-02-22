import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';

class TestPlaceHolder extends StatelessWidget {
  const TestPlaceHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Charts Demo'),
      ),
      body: const PlaceHolderChart(),
    );
  }
}
