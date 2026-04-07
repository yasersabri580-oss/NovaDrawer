// Copyright (c) 2024 AdvancedAppDrawer Contributors
// Licensed under the MIT License.

/// Responsive layout utilities for the AdvancedAppDrawer.
///
/// Provides helper methods and classes for determining device type,
/// calculating drawer dimensions, and adapting layouts across
/// mobile, tablet, and desktop form factors.
library;

import 'package:flutter/material.dart';

import '../models/drawer_config.dart';
import '../models/drawer_theme.dart';

/// Enumeration of device form factor categories.
enum DeviceType {
  /// Phone-sized device (< mobile breakpoint).
  mobile,

  /// Tablet-sized device (between mobile and tablet breakpoints).
  tablet,

  /// Desktop-sized device (> tablet breakpoint).
  desktop,
}

/// Utility class for responsive layout calculations.
///
/// Determines the current device type and provides appropriate
/// dimensions and layout parameters for the drawer.
class ResponsiveUtils {
  /// Private constructor – all members are static.
  const ResponsiveUtils._();

  /// Determines the [DeviceType] based on the given screen [width]
  /// and [breakpoints].
  static DeviceType getDeviceType(
    double width, [
    DrawerBreakpoints breakpoints = const DrawerBreakpoints(),
  ]) {
    if (width < breakpoints.mobile) return DeviceType.mobile;
    if (width < breakpoints.tablet) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  /// Returns the appropriate drawer width for the given [deviceType]
  /// and [theme].
  static double getDrawerWidth(
    DeviceType deviceType,
    AdvancedDrawerTheme theme,
  ) {
    switch (deviceType) {
      case DeviceType.mobile:
        return theme.expandedDrawerWidth ??
            AdvancedDrawerTheme.defaultExpandedDrawerWidth;
      case DeviceType.tablet:
        return theme.tabletDrawerWidth ??
            AdvancedDrawerTheme.defaultTabletDrawerWidth;
      case DeviceType.desktop:
        return theme.desktopDrawerWidth ??
            AdvancedDrawerTheme.defaultDesktopDrawerWidth;
    }
  }

  /// Returns the mini drawer width from the [theme].
  static double getMiniDrawerWidth(AdvancedDrawerTheme theme) {
    return theme.miniDrawerWidth ?? AdvancedDrawerTheme.defaultMiniDrawerWidth;
  }

  /// Determines whether the drawer should be shown as an overlay
  /// for the given [deviceType] and [displayMode].
  static bool shouldShowOverlay(
    DeviceType deviceType,
    DrawerDisplayMode displayMode,
  ) {
    if (displayMode == DrawerDisplayMode.overlay) return true;
    if (displayMode == DrawerDisplayMode.side) return false;
    if (displayMode == DrawerDisplayMode.auto) {
      return deviceType == DeviceType.mobile;
    }
    return deviceType == DeviceType.mobile;
  }

  /// Determines whether the drawer can be pinned for the given
  /// [deviceType].
  static bool canPin(DeviceType deviceType) {
    return deviceType != DeviceType.mobile;
  }

  /// Determines the effective [DrawerDisplayMode] based on the
  /// configured mode and current [deviceType].
  static DrawerDisplayMode resolveDisplayMode(
    DrawerDisplayMode configuredMode,
    DeviceType deviceType,
  ) {
    if (configuredMode != DrawerDisplayMode.auto) return configuredMode;

    switch (deviceType) {
      case DeviceType.mobile:
        return DrawerDisplayMode.overlay;
      case DeviceType.tablet:
        return DrawerDisplayMode.push;
      case DeviceType.desktop:
        return DrawerDisplayMode.side;
    }
  }

  /// Returns the maximum nesting depth for menu items based on
  /// available width.
  static int getMaxNestingDepth(double availableWidth) {
    if (availableWidth < 200) return 1;
    if (availableWidth < 280) return 2;
    if (availableWidth < 360) return 3;
    return 4;
  }

  /// Calculates the indentation for a nested item at the given [depth].
  static double getNestedIndentation(int depth, {double baseIndent = 16.0}) {
    return baseIndent * depth;
  }
}

/// An [InheritedWidget] that provides responsive layout information
/// to descendant widgets.
///
/// Wrap your drawer subtree with this to make device type and
/// drawer dimensions accessible anywhere below.
class ResponsiveDrawerData extends InheritedWidget {
  /// Creates a [ResponsiveDrawerData].
  const ResponsiveDrawerData({
    super.key,
    required super.child,
    required this.deviceType,
    required this.drawerWidth,
    required this.miniDrawerWidth,
    required this.isDrawerOpen,
    required this.isPinned,
    required this.displayMode,
  });

  /// The current device form factor.
  final DeviceType deviceType;

  /// The current drawer width.
  final double drawerWidth;

  /// The mini drawer width.
  final double miniDrawerWidth;

  /// Whether the drawer is currently open.
  final bool isDrawerOpen;

  /// Whether the drawer is pinned.
  final bool isPinned;

  /// The resolved display mode.
  final DrawerDisplayMode displayMode;

  /// Retrieves the nearest [ResponsiveDrawerData] from the widget tree.
  static ResponsiveDrawerData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ResponsiveDrawerData>();
  }

  @override
  bool updateShouldNotify(ResponsiveDrawerData oldWidget) {
    return deviceType != oldWidget.deviceType ||
        drawerWidth != oldWidget.drawerWidth ||
        miniDrawerWidth != oldWidget.miniDrawerWidth ||
        isDrawerOpen != oldWidget.isDrawerOpen ||
        isPinned != oldWidget.isPinned ||
        displayMode != oldWidget.displayMode;
  }
}
