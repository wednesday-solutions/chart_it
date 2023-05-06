import 'package:example/screens/bar_chart.dart';
import 'package:example/screens/bar_chart_animation.dart';
import 'package:example/screens/bar_charts_interaction.dart';
import 'package:example/screens/pie_charts.dart';
import 'package:example/tools/current_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sidebarx/sidebarx.dart';

class MultiPlatformContent extends StatefulWidget {
  const MultiPlatformContent({
    Key? key,
  }) : super(key: key);

  @override
  State<MultiPlatformContent> createState() => _MultiPlatformContentState();
}

class _MultiPlatformContentState extends State<MultiPlatformContent> {
  final _key = GlobalKey<ScaffoldState>();
  final _controller = SidebarXController(
    extended: CurrentDevice.isMobile ? true : false,
    selectedIndex: 0,
  );

  late List<SidebarXItem> _sidebarItems;

  @override
  void initState() {
    super.initState();
    _sidebarItems = [
      SidebarXItem(
        icon: Icons.bar_chart_rounded,
        label: 'Bar Chart',
        onTap: () => _controller.selectIndex(0),
      ),
      SidebarXItem(
        icon: Icons.pie_chart_outline,
        label: 'Pie Chart',
        onTap: () => _controller.selectIndex(1),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      key: _key,
      appBar: CurrentDevice.isMobile
          ? AppBar(
              title: Padding(
                padding: EdgeInsets.only(top: 10.px),
                child: Text(
                  'Chart_It',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontFamily: 'Zangezi',
                    fontSize: 24.sp,
                  ),
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.menu_rounded,
                  color: colorScheme.onPrimaryContainer,
                ),
                onPressed: () => _key.currentState?.openDrawer(),
              ),
            )
          : null,
      // For mobile devices, we can directly have a navigation drawer
      drawer: CurrentDevice.isMobile ? _multiPlatformSidebar(context) : null,
      body: Row(
        children: [
          if (CurrentDevice.isTablet ||
              CurrentDevice.isDesktop ||
              CurrentDevice.isWeb)
            _multiPlatformSidebar(context),
          Expanded(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                switch (_controller.selectedIndex) {
                  case 0:
                    return const TestBarChart();
                  case 1:
                    return const TestPieCharts();
                  default:
                    return const Text('No Page Found');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _multiPlatformSidebar(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    return SidebarX(
      controller: _controller,
      showToggleButton: !CurrentDevice.isMobile,
      theme: _collapsedBarTheme(context),
      extendedTheme: _drawerBarTheme(context),
      headerBuilder: (context, isExtended) {
        var logo = 'graphics/main_logo.svg';
        var shortHand = 'graphics/main_logo_shorthand.svg';
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.px, horizontal: 10.px),
          child: SvgPicture.asset(
            isExtended ? logo : shortHand,
            height: 50.px,
            colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
          ),
        );
      },
      footerDivider: Divider(
        color: colors.onPrimaryContainer,
        height: 1,
      ),
      extendIcon: Icons.arrow_forward_ios_rounded,
      collapseIcon: Icons.arrow_back_ios_rounded,
      items: _sidebarItems,
    );
  }

  SidebarXTheme _drawerBarTheme(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    return SidebarXTheme(
      width: 250.px,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(0),
      ),
      // Not Selected Item Styling
      itemMargin: EdgeInsets.only(top: 10.px),
      itemPadding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 10.px),
      textStyle: TextStyle(color: colors.onPrimaryContainer),
      itemTextPadding: EdgeInsets.symmetric(horizontal: 20.px),
      iconTheme: IconThemeData(
        color: colors.onPrimaryContainer,
        size: 20.px,
      ),
      // Selected Item Styling
      selectedItemMargin: EdgeInsets.symmetric(
        horizontal: 10.px,
        vertical: 10.px,
      ),
      selectedTextStyle: TextStyle(
        color: colors.onTertiaryContainer,
        fontWeight: FontWeight.bold,
      ),
      selectedItemTextPadding: EdgeInsets.symmetric(horizontal: 20.px),
      selectedIconTheme: IconThemeData(
        color: colors.onTertiaryContainer,
        size: 20.px,
      ),
    );
  }

  SidebarXTheme _collapsedBarTheme(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    return SidebarXTheme(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        border: Border.all(color: colors.primary, width: 2.0),
        borderRadius: BorderRadius.circular(20),
      ),
      // Not Selected Item Styling
      itemMargin: EdgeInsets.only(top: 10.px, left: 5.px, right: 5.px),
      textStyle: TextStyle(color: colors.onPrimaryContainer),
      iconTheme: IconThemeData(
        color: colors.onPrimaryContainer,
        size: 20.px,
      ),
      // Selected Item Styling
      selectedItemMargin: EdgeInsets.symmetric(
        vertical: 5.px,
        horizontal: 5.px,
      ),
      selectedTextStyle: TextStyle(color: colors.onTertiaryContainer),
      selectedItemDecoration: BoxDecoration(
        color: colors.tertiaryContainer,
        border: Border.all(color: colors.tertiary),
        borderRadius: BorderRadius.circular(20),
      ),
      selectedIconTheme: IconThemeData(
        color: colors.onTertiaryContainer,
        size: 20.px,
      ),
    );
  }
}
