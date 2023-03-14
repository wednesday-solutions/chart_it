import 'package:example/showcase.dart';
import 'package:flutter/material.dart';

void main() {
  ///Call this first to make sure we can make other system level calls safely
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(const MyApp());
  runApp(const ShowcaseApp());
}
