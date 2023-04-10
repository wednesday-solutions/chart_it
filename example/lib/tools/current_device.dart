import 'package:responsive_sizer/responsive_sizer.dart' as rz;
import 'package:universal_platform/universal_platform.dart';

class CurrentDevice {
  static bool get isMobile =>
      _isMobileOS && rz.Device.screenType == rz.ScreenType.mobile;

  static bool get isTablet =>
      _isMobileOS && rz.Device.screenType == rz.ScreenType.tablet;

  static bool get isDesktop => UniversalPlatform.isDesktop;

  static bool get isWeb => UniversalPlatform.isWeb;

  static bool get isAndroid => UniversalPlatform.isAndroid;

  static bool get isIOS => UniversalPlatform.isIOS;

  static bool get isFuchsia => UniversalPlatform.isFuchsia;

  static bool get _isMobileOS => isAndroid || isIOS || isFuchsia;

  static bool get isWindows => UniversalPlatform.isWindows;

  static bool get isLinux => UniversalPlatform.isLinux;

  static bool get isMacOS => UniversalPlatform.isMacOS;
}
