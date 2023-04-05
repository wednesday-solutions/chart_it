import 'package:example/showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

void main() {
  ///Call this first to make sure we can make other system level calls safely
  WidgetsFlutterBinding.ensureInitialized();
  FlutterDisplayMode.setHighRefreshRate();
  // runApp(const MyApp());
  runApp(const ShowcaseApp(testMode: true));
}
