// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Responsive layout utilities for the NovaAppDrawer.
///
/// Provides helper methods and classes for determining device type,
/// calculating drawer dimensions, and adapting layouts across
/// mobile, tablet, and desktop form factors.
library;

import 'package:flutter/material.dart';

import '../models/drawer_config.dart';
import '../models/drawer_theme.dart';

/// Enumeration of device form factor categories.
enum NovaDeviceType {
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
class NovaResponsiveUtils {
  /// Private constructor – all members are static.
  const NovaResponsiveUtils._();

  /// Determines the [NovaDeviceType] based on the given screen [width]
  /// and [breakpoints].
  static NovaDeviceType getDeviceType(
    double width, [
    NovaDrawerBreakpoints breakpoints = const NovaDrawerBreakpoints(),
  ]) {
    if (width < breakpoints.mobile) return NovaDeviceType.mobile;
    if (width < breakpoints.tablet) return NovaDeviceType.tablet;
    return NovaDeviceType.desktop;
  }

  /// Returns the appropriate drawer width for the given [deviceType]
  /// and [theme].
  static double getDrawerWidth(
    NovaDeviceType deviceType,
    NovaDrawerTheme theme,
  ) {
    switch (deviceType) {
      case NovaDeviceType.mobile:
        return theme.expandedDrawerWidth ??
            NovaDrawerTheme.defaultExpandedDrawerWidth;
      case NovaDeviceType.tablet:
        return theme.tabletDrawerWidth ??
            NovaDrawerTheme.defaultTabletDrawerWidth;
      case NovaDeviceType.desktop:
        return theme.desktopDrawerWidth ??
            NovaDrawerTheme.defaultDesktopDrawerWidth;
    }
  }

  /// Returns the mini drawer width from the [theme].
  static double getMiniDrawerWidth(NovaDrawerTheme theme) {
    return theme.miniDrawerWidth ?? NovaDrawerTheme.defaultMiniDrawerWidth;
  }

  /// Determines whether the drawer should be shown as an overlay
  /// for the given [deviceType] and [displayMode].
  static bool shouldShowOverlay(
    NovaDeviceType deviceType,
    NovaDrawerDisplayMode displayMode,
  ) {
    if (displayMode == NovaDrawerDisplayMode.overlay) return true;
    if (displayMode == NovaDrawerDisplayMode.side) return false;
    if (displayMode == NovaDrawerDisplayMode.auto) {
      return deviceType == NovaDeviceType.mobile;
    }
    return deviceType == NovaDeviceType.mobile;
  }

  /// Determines whether the drawer can be pinned for the given
  /// [deviceType].
  static bool canPin(NovaDeviceType deviceType) {
    return deviceType != NovaDeviceType.mobile;
  }

  /// Determines the effective [NovaDrawerDisplayMode] based on the
  /// configured mode and current [deviceType].
  static NovaDrawerDisplayMode resolveDisplayMode(
    NovaDrawerDisplayMode configuredMode,
    NovaDeviceType deviceType,
  ) {
    if (configuredMode != NovaDrawerDisplayMode.auto) return configuredMode;

    switch (deviceType) {
      case NovaDeviceType.mobile:
        return NovaDrawerDisplayMode.overlay;
      case NovaDeviceType.tablet:
        return NovaDrawerDisplayMode.push;
      case NovaDeviceType.desktop:
        return NovaDrawerDisplayMode.side;
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
class NovaResponsiveDrawerData extends InheritedWidget {
  /// Creates a [NovaResponsiveDrawerData].
  const NovaResponsiveDrawerData({
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
  final NovaDeviceType deviceType;

  /// The current drawer width.
  final double drawerWidth;

  /// The mini drawer width.
  final double miniDrawerWidth;

  /// Whether the drawer is currently open.
  final bool isDrawerOpen;

  /// Whether the drawer is pinned.
  final bool isPinned;

  /// The resolved display mode.
  final NovaDrawerDisplayMode displayMode;

  /// Retrieves the nearest [NovaResponsiveDrawerData] from the widget tree.
  static NovaResponsiveDrawerData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NovaResponsiveDrawerData>();
  }

  @override
  bool updateShouldNotify(NovaResponsiveDrawerData oldWidget) {
    return deviceType != oldWidget.deviceType ||
        drawerWidth != oldWidget.drawerWidth ||
        miniDrawerWidth != oldWidget.miniDrawerWidth ||
        isDrawerOpen != oldWidget.isDrawerOpen ||
        isPinned != oldWidget.isPinned ||
        displayMode != oldWidget.displayMode;
  }
}
