// Copyright (c) 2024 AdvancedAppDrawer Contributors
// Licensed under the MIT License.

/// Theme configuration for the AdvancedAppDrawer.
///
/// Provides comprehensive styling options including colors, text styles,
/// shadows, borders, and animation properties for all drawer components.
library;

import 'package:flutter/material.dart';

/// Defines the visual theme for the entire drawer.
///
/// All properties are optional and fall back to sensible defaults
/// derived from the current [ThemeData].
///
/// Example:
/// ```dart
/// AdvancedDrawerTheme(
///   backgroundColor: Colors.white,
///   selectedItemColor: Colors.blue,
///   itemTextStyle: TextStyle(fontSize: 14),
///   elevation: 8.0,
///   borderRadius: BorderRadius.circular(16),
/// )
/// ```
class AdvancedDrawerTheme {
  /// Creates an [AdvancedDrawerTheme].
  const AdvancedDrawerTheme({
    this.backgroundColor,
    this.surfaceColor,
    this.selectedItemColor,
    this.selectedItemBackgroundColor,
    this.unselectedItemColor,
    this.hoverColor,
    this.splashColor,
    this.dividerColor,
    this.shadowColor,
    this.headerBackgroundColor,
    this.headerTextColor,
    this.itemTextStyle,
    this.selectedItemTextStyle,
    this.sectionTitleStyle,
    this.subtitleTextStyle,
    this.headerTitleStyle,
    this.headerSubtitleStyle,
    this.elevation,
    this.borderRadius,
    this.itemBorderRadius,
    this.itemPadding,
    this.sectionPadding,
    this.contentPadding,
    this.iconSize,
    this.selectedIconSize,
    this.itemHeight,
    this.miniDrawerWidth,
    this.expandedDrawerWidth,
    this.tabletDrawerWidth,
    this.desktopDrawerWidth,
    this.headerHeight,
    this.badgeTheme,
    this.scrollbarTheme,
    this.border,
    this.gradient,
    this.backgroundImage,
    this.backgroundBlur,
    this.drawerShape,
  });

  // ── Colors ──────────────────────────────────────────────────────────

  /// Background color of the drawer.
  final Color? backgroundColor;

  /// Surface color for elevated elements within the drawer.
  final Color? surfaceColor;

  /// Color of selected/active item text and icon.
  final Color? selectedItemColor;

  /// Background color behind the selected item.
  final Color? selectedItemBackgroundColor;

  /// Color of unselected item text and icon.
  final Color? unselectedItemColor;

  /// Hover highlight color for items.
  final Color? hoverColor;

  /// Splash/ripple color for item interactions.
  final Color? splashColor;

  /// Divider color between sections.
  final Color? dividerColor;

  /// Shadow color for elevation effects.
  final Color? shadowColor;

  /// Background color of the drawer header area.
  final Color? headerBackgroundColor;

  /// Text color in the header area.
  final Color? headerTextColor;

  // ── Text Styles ─────────────────────────────────────────────────────

  /// Default text style for drawer items.
  final TextStyle? itemTextStyle;

  /// Text style for selected/active drawer items.
  final TextStyle? selectedItemTextStyle;

  /// Text style for section titles.
  final TextStyle? sectionTitleStyle;

  /// Text style for item subtitles.
  final TextStyle? subtitleTextStyle;

  /// Text style for the header title.
  final TextStyle? headerTitleStyle;

  /// Text style for the header subtitle.
  final TextStyle? headerSubtitleStyle;

  // ── Dimensions ──────────────────────────────────────────────────────

  /// Elevation shadow depth of the drawer.
  final double? elevation;

  /// Border radius of the drawer container.
  final BorderRadiusGeometry? borderRadius;

  /// Border radius for individual items.
  final BorderRadiusGeometry? itemBorderRadius;

  /// Padding around each item.
  final EdgeInsetsGeometry? itemPadding;

  /// Padding around each section.
  final EdgeInsetsGeometry? sectionPadding;

  /// Padding for the entire drawer content area.
  final EdgeInsetsGeometry? contentPadding;

  /// Size of item icons in normal state.
  final double? iconSize;

  /// Size of item icons in selected state.
  final double? selectedIconSize;

  /// Height of each menu item row.
  final double? itemHeight;

  /// Width of the mini/collapsed drawer.
  final double? miniDrawerWidth;

  /// Width of the fully expanded drawer on mobile.
  final double? expandedDrawerWidth;

  /// Width of the drawer on tablet devices.
  final double? tabletDrawerWidth;

  /// Width of the drawer on desktop devices.
  final double? desktopDrawerWidth;

  /// Height of the drawer header area.
  final double? headerHeight;

  // ── Component Themes ────────────────────────────────────────────────

  /// Theme configuration for item badges.
  final DrawerBadgeTheme? badgeTheme;

  /// Theme for the drawer scrollbar.
  final DrawerScrollbarTheme? scrollbarTheme;

  // ── Decoration ──────────────────────────────────────────────────────

  /// Border decoration for the drawer.
  final BoxBorder? border;

  /// Background gradient (overrides [backgroundColor] if set).
  final Gradient? gradient;

  /// Background image decoration.
  final DecorationImage? backgroundImage;

  /// Blur amount for the background.
  final double? backgroundBlur;

  /// Custom shape for the drawer container.
  final ShapeBorder? drawerShape;

  // ── Defaults ────────────────────────────────────────────────────────

  /// Default icon size.
  static const double defaultIconSize = 24.0;

  /// Default selected icon size.
  static const double defaultSelectedIconSize = 24.0;

  /// Default item height.
  static const double defaultItemHeight = 48.0;

  /// Default mini drawer width.
  static const double defaultMiniDrawerWidth = 72.0;

  /// Default expanded drawer width on mobile.
  static const double defaultExpandedDrawerWidth = 280.0;

  /// Default drawer width on tablet.
  static const double defaultTabletDrawerWidth = 280.0;

  /// Default drawer width on desktop.
  static const double defaultDesktopDrawerWidth = 300.0;

  /// Default header height.
  static const double defaultHeaderHeight = 180.0;

  /// Resolves this theme against the given [ThemeData], filling in
  /// any null properties with sensible defaults.
  AdvancedDrawerTheme resolve(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return AdvancedDrawerTheme(
      backgroundColor: backgroundColor ?? colorScheme.surface,
      surfaceColor: surfaceColor ?? colorScheme.surfaceContainerHighest,
      selectedItemColor: selectedItemColor ?? colorScheme.primary,
      selectedItemBackgroundColor: selectedItemBackgroundColor ??
          colorScheme.primary.withAlpha(25),
      unselectedItemColor:
          unselectedItemColor ?? colorScheme.onSurfaceVariant,
      hoverColor: hoverColor ?? colorScheme.onSurface.withAlpha(20),
      splashColor: splashColor ?? colorScheme.primary.withAlpha(30),
      dividerColor: dividerColor ?? colorScheme.outlineVariant,
      shadowColor: shadowColor ?? colorScheme.shadow,
      headerBackgroundColor: headerBackgroundColor ?? colorScheme.primaryContainer,
      headerTextColor: headerTextColor ?? colorScheme.onPrimaryContainer,
      itemTextStyle: itemTextStyle ?? theme.textTheme.bodyMedium,
      selectedItemTextStyle: selectedItemTextStyle ??
          theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
      sectionTitleStyle: sectionTitleStyle ??
          theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
      subtitleTextStyle: subtitleTextStyle ??
          theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
      headerTitleStyle: headerTitleStyle ??
          theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
      headerSubtitleStyle: headerSubtitleStyle ??
          theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onPrimaryContainer.withAlpha(179),
          ),
      elevation: elevation ?? 1.0,
      borderRadius: borderRadius,
      itemBorderRadius:
          itemBorderRadius ?? BorderRadius.circular(8.0),
      itemPadding: itemPadding ??
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      sectionPadding: sectionPadding ??
          const EdgeInsets.symmetric(vertical: 8.0),
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      iconSize: iconSize ?? defaultIconSize,
      selectedIconSize: selectedIconSize ?? defaultSelectedIconSize,
      itemHeight: itemHeight ?? defaultItemHeight,
      miniDrawerWidth: miniDrawerWidth ?? defaultMiniDrawerWidth,
      expandedDrawerWidth: expandedDrawerWidth ?? defaultExpandedDrawerWidth,
      tabletDrawerWidth: tabletDrawerWidth ?? defaultTabletDrawerWidth,
      desktopDrawerWidth: desktopDrawerWidth ?? defaultDesktopDrawerWidth,
      headerHeight: headerHeight ?? defaultHeaderHeight,
      badgeTheme: badgeTheme ?? const DrawerBadgeTheme(),
      scrollbarTheme: scrollbarTheme ?? const DrawerScrollbarTheme(),
      border: border,
      gradient: gradient,
      backgroundImage: backgroundImage,
      backgroundBlur: backgroundBlur,
      drawerShape: drawerShape,
    );
  }

  /// Creates a copy of this theme with the given fields replaced.
  AdvancedDrawerTheme copyWith({
    Color? backgroundColor,
    Color? surfaceColor,
    Color? selectedItemColor,
    Color? selectedItemBackgroundColor,
    Color? unselectedItemColor,
    Color? hoverColor,
    Color? splashColor,
    Color? dividerColor,
    Color? shadowColor,
    Color? headerBackgroundColor,
    Color? headerTextColor,
    TextStyle? itemTextStyle,
    TextStyle? selectedItemTextStyle,
    TextStyle? sectionTitleStyle,
    TextStyle? subtitleTextStyle,
    TextStyle? headerTitleStyle,
    TextStyle? headerSubtitleStyle,
    double? elevation,
    BorderRadiusGeometry? borderRadius,
    BorderRadiusGeometry? itemBorderRadius,
    EdgeInsetsGeometry? itemPadding,
    EdgeInsetsGeometry? sectionPadding,
    EdgeInsetsGeometry? contentPadding,
    double? iconSize,
    double? selectedIconSize,
    double? itemHeight,
    double? miniDrawerWidth,
    double? expandedDrawerWidth,
    double? tabletDrawerWidth,
    double? desktopDrawerWidth,
    double? headerHeight,
    DrawerBadgeTheme? badgeTheme,
    DrawerScrollbarTheme? scrollbarTheme,
    BoxBorder? border,
    Gradient? gradient,
    DecorationImage? backgroundImage,
    double? backgroundBlur,
    ShapeBorder? drawerShape,
  }) {
    return AdvancedDrawerTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      selectedItemBackgroundColor:
          selectedItemBackgroundColor ?? this.selectedItemBackgroundColor,
      unselectedItemColor: unselectedItemColor ?? this.unselectedItemColor,
      hoverColor: hoverColor ?? this.hoverColor,
      splashColor: splashColor ?? this.splashColor,
      dividerColor: dividerColor ?? this.dividerColor,
      shadowColor: shadowColor ?? this.shadowColor,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      itemTextStyle: itemTextStyle ?? this.itemTextStyle,
      selectedItemTextStyle:
          selectedItemTextStyle ?? this.selectedItemTextStyle,
      sectionTitleStyle: sectionTitleStyle ?? this.sectionTitleStyle,
      subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
      headerTitleStyle: headerTitleStyle ?? this.headerTitleStyle,
      headerSubtitleStyle: headerSubtitleStyle ?? this.headerSubtitleStyle,
      elevation: elevation ?? this.elevation,
      borderRadius: borderRadius ?? this.borderRadius,
      itemBorderRadius: itemBorderRadius ?? this.itemBorderRadius,
      itemPadding: itemPadding ?? this.itemPadding,
      sectionPadding: sectionPadding ?? this.sectionPadding,
      contentPadding: contentPadding ?? this.contentPadding,
      iconSize: iconSize ?? this.iconSize,
      selectedIconSize: selectedIconSize ?? this.selectedIconSize,
      itemHeight: itemHeight ?? this.itemHeight,
      miniDrawerWidth: miniDrawerWidth ?? this.miniDrawerWidth,
      expandedDrawerWidth: expandedDrawerWidth ?? this.expandedDrawerWidth,
      tabletDrawerWidth: tabletDrawerWidth ?? this.tabletDrawerWidth,
      desktopDrawerWidth: desktopDrawerWidth ?? this.desktopDrawerWidth,
      headerHeight: headerHeight ?? this.headerHeight,
      badgeTheme: badgeTheme ?? this.badgeTheme,
      scrollbarTheme: scrollbarTheme ?? this.scrollbarTheme,
      border: border ?? this.border,
      gradient: gradient ?? this.gradient,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      backgroundBlur: backgroundBlur ?? this.backgroundBlur,
      drawerShape: drawerShape ?? this.drawerShape,
    );
  }

  /// Creates a dark theme variant.
  factory AdvancedDrawerTheme.dark() {
    return const AdvancedDrawerTheme(
      backgroundColor: Color(0xFF1E1E2E),
      surfaceColor: Color(0xFF2A2A3E),
      selectedItemColor: Color(0xFF89B4FA),
      selectedItemBackgroundColor: Color(0x1A89B4FA),
      unselectedItemColor: Color(0xFFBAC2DE),
      hoverColor: Color(0x14FFFFFF),
      splashColor: Color(0x1E89B4FA),
      dividerColor: Color(0xFF45475A),
      shadowColor: Color(0xFF000000),
      headerBackgroundColor: Color(0xFF313244),
      headerTextColor: Color(0xFFCDD6F4),
    );
  }

  /// Creates a light theme variant.
  factory AdvancedDrawerTheme.light() {
    return const AdvancedDrawerTheme(
      backgroundColor: Color(0xFFFFFFFF),
      surfaceColor: Color(0xFFF5F5F5),
      selectedItemColor: Color(0xFF1976D2),
      selectedItemBackgroundColor: Color(0x1A1976D2),
      unselectedItemColor: Color(0xFF616161),
      hoverColor: Color(0x0A000000),
      splashColor: Color(0x1E1976D2),
      dividerColor: Color(0xFFE0E0E0),
      shadowColor: Color(0x40000000),
      headerBackgroundColor: Color(0xFF1976D2),
      headerTextColor: Color(0xFFFFFFFF),
    );
  }
}

/// Theme configuration for drawer item badges.
class DrawerBadgeTheme {
  /// Creates a [DrawerBadgeTheme].
  const DrawerBadgeTheme({
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.size,
    this.borderRadius,
    this.padding,
  });

  /// Background color of badges.
  final Color? backgroundColor;

  /// Text color of badge content.
  final Color? textColor;

  /// Text style for badge content.
  final TextStyle? textStyle;

  /// Size of the badge circle.
  final double? size;

  /// Border radius of the badge.
  final BorderRadiusGeometry? borderRadius;

  /// Padding inside the badge.
  final EdgeInsetsGeometry? padding;
}

/// Theme configuration for the drawer scrollbar.
class DrawerScrollbarTheme {
  /// Creates a [DrawerScrollbarTheme].
  const DrawerScrollbarTheme({
    this.thumbColor,
    this.trackColor,
    this.thickness,
    this.radius,
    this.isAlwaysShown = false,
  });

  /// Color of the scrollbar thumb.
  final Color? thumbColor;

  /// Color of the scrollbar track.
  final Color? trackColor;

  /// Thickness of the scrollbar.
  final double? thickness;

  /// Corner radius of the scrollbar thumb.
  final Radius? radius;

  /// Whether the scrollbar is always visible.
  final bool isAlwaysShown;
}
