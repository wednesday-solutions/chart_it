import 'package:example/screens/navigation/multi_platform_content.dart';
import 'package:example/themes/dark_theme.dart';
import 'package:example/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ShowcaseApp extends StatefulWidget {
  const ShowcaseApp({
    Key? key,
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
          themeMode: ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightTheme,
            // textTheme: GoogleFonts.poppinsTextTheme(
            //   Theme.of(context).textTheme,
            // ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkTheme,
            // textTheme: GoogleFonts.poppinsTextTheme(
            //   Theme.of(context).textTheme,
            // ),
          ),
          home: const MultiPlatformContent(),
        );
      },
    );
  }
}
