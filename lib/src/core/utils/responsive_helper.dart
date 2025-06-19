// lib/src/core/utils/responsive_helper.dart

import 'package:flutter/material.dart';

/// Device types based on screen width
enum DeviceType { mobile, tablet, desktop }

/// Screen size categories
enum ScreenSize {
  small, // < 600px
  medium, // 600px - 1024px
  large, // > 1024px
}

/// Orientation-based layouts
enum LayoutType { portrait, landscape }

class ResponsiveHelper {
  /// Breakpoints for different screen sizes
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

  /// Get device type based on screen width
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (width < tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Get screen size category
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < mobileBreakpoint) {
      return ScreenSize.small;
    } else if (width < tabletBreakpoint) {
      return ScreenSize.medium;
    } else {
      return ScreenSize.large;
    }
  }

  /// Get layout type based on orientation
  static LayoutType getLayoutType(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.portrait
        ? LayoutType.portrait
        : LayoutType.landscape;
  }

  /// Check if device is mobile
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  /// Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }

  /// Check if screen is small
  static bool isSmallScreen(BuildContext context) {
    return getScreenSize(context) == ScreenSize.small;
  }

  /// Check if screen is medium
  static bool isMediumScreen(BuildContext context) {
    return getScreenSize(context) == ScreenSize.medium;
  }

  /// Check if screen is large
  static bool isLargeScreen(BuildContext context) {
    return getScreenSize(context) == ScreenSize.large;
  }

  /// Check if device is in portrait mode
  static bool isPortrait(BuildContext context) {
    return getLayoutType(context) == LayoutType.portrait;
  }

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return getLayoutType(context) == LayoutType.landscape;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenSize = getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.small:
        return const EdgeInsets.all(16.0);
      case ScreenSize.medium:
        return const EdgeInsets.all(24.0);
      case ScreenSize.large:
        return const EdgeInsets.all(32.0);
    }
  }

  /// Get responsive margin based on screen size
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    final screenSize = getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.small:
        return const EdgeInsets.all(8.0);
      case ScreenSize.medium:
        return const EdgeInsets.all(16.0);
      case ScreenSize.large:
        return const EdgeInsets.all(24.0);
    }
  }

  /// Get responsive font size multiplier
  static double getFontSizeMultiplier(BuildContext context) {
    final screenSize = getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.small:
        return 1.0;
      case ScreenSize.medium:
        return 1.1;
      case ScreenSize.large:
        return 1.2;
    }
  }

  /// Get responsive icon size
  static double getResponsiveIconSize(
    BuildContext context, {
    double baseSize = 24.0,
  }) {
    final multiplier = getFontSizeMultiplier(context);
    return baseSize * multiplier;
  }

  /// Get number of columns for grid based on screen size
  static int getGridColumns(
    BuildContext context, {
    int mobileColumns = 1,
    int tabletColumns = 2,
    int desktopColumns = 3,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobileColumns;
      case DeviceType.tablet:
        return tabletColumns;
      case DeviceType.desktop:
        return desktopColumns;
    }
  }

  /// Get maximum content width to prevent overly wide layouts
  static double getMaxContentWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return screenWidth;
      case DeviceType.tablet:
        return screenWidth * 0.8;
      case DeviceType.desktop:
        return 1200.0; // Fixed max width for desktop
    }
  }

  /// Get responsive card width
  static double getCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return screenWidth - 32.0; // Full width with padding
      case DeviceType.tablet:
        return (screenWidth - 64.0) / 2; // Two cards per row
      case DeviceType.desktop:
        return (screenWidth - 96.0) / 3; // Three cards per row
    }
  }

  /// Get responsive button width
  static double getButtonWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return screenWidth - 32.0; // Full width with padding
      case DeviceType.tablet:
        return 300.0; // Fixed width for tablet
      case DeviceType.desktop:
        return 320.0; // Fixed width for desktop
    }
  }

  /// Get responsive navigation type
  static NavigationType getNavigationType(BuildContext context) {
    final deviceType = getDeviceType(context);
    final orientation = getLayoutType(context);

    if (deviceType == DeviceType.mobile && orientation == LayoutType.portrait) {
      return NavigationType.bottomNavigation;
    } else if (deviceType == DeviceType.mobile &&
        orientation == LayoutType.landscape) {
      return NavigationType.drawer;
    } else {
      return NavigationType.rail;
    }
  }

  /// Get responsive app bar height
  static double getAppBarHeight(BuildContext context) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return kToolbarHeight;
      case DeviceType.tablet:
        return kToolbarHeight + 8.0;
      case DeviceType.desktop:
        return kToolbarHeight + 16.0;
    }
  }

  /// Get safe area for content
  static EdgeInsets getSafeArea(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceType = getDeviceType(context);

    EdgeInsets safePadding = mediaQuery.padding;

    // Add extra padding for different device types
    switch (deviceType) {
      case DeviceType.mobile:
        break; // Use default safe area
      case DeviceType.tablet:
        safePadding = safePadding.copyWith(
          left: safePadding.left + 16.0,
          right: safePadding.right + 16.0,
        );
        break;
      case DeviceType.desktop:
        safePadding = safePadding.copyWith(
          left: safePadding.left + 32.0,
          right: safePadding.right + 32.0,
        );
        break;
    }

    return safePadding;
  }

  /// Calculate responsive size based on screen width percentage
  static double responsiveSize(BuildContext context, double percentage) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (percentage / 100);
  }

  /// Get text scale factor for accessibility
  static double getTextScaleFactor(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // Clamp text scale factor to reasonable bounds
    return textScaleFactor.clamp(0.8, 1.4);
  }

  /// Check if device supports hover (desktop/web)
  static bool supportsHover(BuildContext context) {
    return isDesktop(context);
  }

  /// Get responsive border radius
  static BorderRadius getResponsiveBorderRadius(BuildContext context) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return BorderRadius.circular(12.0);
      case DeviceType.tablet:
        return BorderRadius.circular(16.0);
      case DeviceType.desktop:
        return BorderRadius.circular(20.0);
    }
  }
}

/// Navigation types for different layouts
enum NavigationType { bottomNavigation, drawer, rail }

/// Responsive layout builder widget
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}

/// Responsive value builder
class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;

  const ResponsiveValue({required this.mobile, this.tablet, this.desktop});

  T getValue(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}

/// Extension for responsive values on BuildContext
extension ResponsiveContext on BuildContext {
  T responsive<T>(ResponsiveValue<T> value) {
    return value.getValue(this);
  }

  bool get isMobile => ResponsiveHelper.isMobile(this);
  bool get isTablet => ResponsiveHelper.isTablet(this);
  bool get isDesktop => ResponsiveHelper.isDesktop(this);
  bool get isPortrait => ResponsiveHelper.isPortrait(this);
  bool get isLandscape => ResponsiveHelper.isLandscape(this);

  EdgeInsets get responsivePadding =>
      ResponsiveHelper.getResponsivePadding(this);
  EdgeInsets get responsiveMargin => ResponsiveHelper.getResponsiveMargin(this);
  double get maxContentWidth => ResponsiveHelper.getMaxContentWidth(this);
}
