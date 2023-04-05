import 'package:example/screens/navigation/multi_platform_content.dart';
import 'package:example/themes/dark_theme.dart';
import 'package:example/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ShowcaseApp extends StatefulWidget {
  final bool testMode;

  const ShowcaseApp({
    Key? key,
    this.testMode = false,
  }) : super(key: key);

  @override
  State<ShowcaseApp> createState() => _ShowcaseAppState();
}

class _ShowcaseAppState extends State<ShowcaseApp> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Flutter Charts',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          darkTheme: darkTheme,
          theme: lightTheme,
          home: MultiPlatformContent(isTestMode: widget.testMode),
        );
      },
    );
  }
}
