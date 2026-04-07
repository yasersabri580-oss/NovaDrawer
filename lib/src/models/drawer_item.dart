// Copyright (c) 2024 AdvancedAppDrawer Contributors
// Licensed under the MIT License.

/// Data models for drawer menu items.
///
/// Provides [DrawerItem] for representing individual menu entries,
/// [DrawerSection] for grouping related items, and [DrawerItemBadge]
/// for notification badges.
library;

import 'package:flutter/material.dart';

/// Represents a badge displayed on a drawer item.
///
/// Badges can show counts, labels, or custom widgets to indicate
/// notifications, updates, or status.
class DrawerItemBadge {
  /// Creates a [DrawerItemBadge].
  ///
  /// At least one of [count], [label], or [customWidget] should be provided.
  const DrawerItemBadge({
    this.count,
    this.label,
    this.backgroundColor,
    this.textColor,
    this.customWidget,
  });

  /// Numeric count displayed in the badge (e.g., unread messages).
  final int? count;

  /// Text label displayed in the badge (e.g., "NEW").
  final String? label;

  /// Background color of the badge. Defaults to theme primary color.
  final Color? backgroundColor;

  /// Text color of the badge content.
  final Color? textColor;

  /// Custom widget to display instead of count/label.
  final Widget? customWidget;

  /// Maximum badge count before showing "+".
  static const int maxDisplayCount = 99;

  /// Returns the display text for this badge.
  String get displayText {
    if (label != null) return label!;
    if (count != null) {
      return count! > maxDisplayCount ? '$maxDisplayCount+' : count.toString();
    }
    return '';
  }

  /// Creates a copy of this badge with the given fields replaced.
  DrawerItemBadge copyWith({
    int? count,
    String? label,
    Color? backgroundColor,
    Color? textColor,
    Widget? customWidget,
  }) {
    return DrawerItemBadge(
      count: count ?? this.count,
      label: label ?? this.label,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      customWidget: customWidget ?? this.customWidget,
    );
  }
}

/// Represents a single item in the drawer navigation menu.
///
/// Drawer items can be nested to create multi-level navigation structures.
/// Each item supports icons, badges, custom widgets, and callback actions.
///
/// Example:
/// ```dart
/// DrawerItem(
///   id: 'home',
///   title: 'Home',
///   icon: Icons.home,
///   onTap: () => navigateTo('/home'),
///   children: [
///     DrawerItem(id: 'dashboard', title: 'Dashboard', icon: Icons.dashboard),
///     DrawerItem(id: 'analytics', title: 'Analytics', icon: Icons.analytics),
///   ],
/// )
/// ```
class DrawerItem {
  /// Creates a [DrawerItem].
  ///
  /// The [id] and [title] parameters are required. Use [children] for nested menus.
  const DrawerItem({
    required this.id,
    required this.title,
    this.icon,
    this.selectedIcon,
    this.children = const [],
    this.onTap,
    this.badge,
    this.isEnabled = true,
    this.isVisible = true,
    this.route,
    this.trailing,
    this.leading,
    this.subtitle,
    this.tooltip,
    this.semanticLabel,
    this.initiallyExpanded = false,
    this.customWidget,
    this.metadata,
  });

  /// Unique identifier for this drawer item.
  final String id;

  /// Display title of the menu item.
  final String title;

  /// Icon displayed before the title in normal state.
  final IconData? icon;

  /// Icon displayed when this item is selected/active.
  final IconData? selectedIcon;

  /// Child items for nested navigation.
  final List<DrawerItem> children;

  /// Callback invoked when the item is tapped.
  final VoidCallback? onTap;

  /// Optional badge to display on this item.
  final DrawerItemBadge? badge;

  /// Whether this item is enabled and interactive.
  final bool isEnabled;

  /// Whether this item is visible in the drawer.
  final bool isVisible;

  /// Route path associated with this item for active-route highlighting.
  final String? route;

  /// Widget displayed at the trailing edge of the item.
  final Widget? trailing;

  /// Widget displayed at the leading edge (overrides [icon]).
  final Widget? leading;

  /// Subtitle text displayed below the title.
  final String? subtitle;

  /// Tooltip text shown on hover.
  final String? tooltip;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  /// Whether nested children are initially expanded.
  final bool initiallyExpanded;

  /// Custom widget to render instead of the default item layout.
  final Widget? customWidget;

  /// Arbitrary metadata attached to this item.
  final Map<String, dynamic>? metadata;

  /// Whether this item has child items.
  bool get hasChildren => children.isNotEmpty;

  /// The effective icon for the selected state.
  IconData? get effectiveSelectedIcon => selectedIcon ?? icon;

  /// Creates a copy of this item with the given fields replaced.
  DrawerItem copyWith({
    String? id,
    String? title,
    IconData? icon,
    IconData? selectedIcon,
    List<DrawerItem>? children,
    VoidCallback? onTap,
    DrawerItemBadge? badge,
    bool? isEnabled,
    bool? isVisible,
    String? route,
    Widget? trailing,
    Widget? leading,
    String? subtitle,
    String? tooltip,
    String? semanticLabel,
    bool? initiallyExpanded,
    Widget? customWidget,
    Map<String, dynamic>? metadata,
  }) {
    return DrawerItem(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      children: children ?? this.children,
      onTap: onTap ?? this.onTap,
      badge: badge ?? this.badge,
      isEnabled: isEnabled ?? this.isEnabled,
      isVisible: isVisible ?? this.isVisible,
      route: route ?? this.route,
      trailing: trailing ?? this.trailing,
      leading: leading ?? this.leading,
      subtitle: subtitle ?? this.subtitle,
      tooltip: tooltip ?? this.tooltip,
      semanticLabel: semanticLabel ?? this.semanticLabel,
      initiallyExpanded: initiallyExpanded ?? this.initiallyExpanded,
      customWidget: customWidget ?? this.customWidget,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrawerItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Represents a group of related drawer items.
///
/// Sections provide visual separation and optional headers/footers
/// for organizing menu items into logical groups.
class DrawerSectionData {
  /// Creates a [DrawerSectionData].
  const DrawerSectionData({
    required this.id,
    required this.items,
    this.title,
    this.icon,
    this.isCollapsible = true,
    this.initiallyExpanded = true,
    this.headerWidget,
    this.footerWidget,
    this.dividerAbove = false,
    this.dividerBelow = true,
    this.padding,
  });

  /// Unique identifier for this section.
  final String id;

  /// Items contained in this section.
  final List<DrawerItem> items;

  /// Optional title displayed as section header.
  final String? title;

  /// Optional icon displayed alongside the section title.
  final IconData? icon;

  /// Whether this section can be collapsed/expanded.
  final bool isCollapsible;

  /// Whether this section starts in expanded state.
  final bool initiallyExpanded;

  /// Custom widget for the section header.
  final Widget? headerWidget;

  /// Custom widget for the section footer.
  final Widget? footerWidget;

  /// Whether to show a divider above this section.
  final bool dividerAbove;

  /// Whether to show a divider below this section.
  final bool dividerBelow;

  /// Custom padding for this section.
  final EdgeInsetsGeometry? padding;

  /// Creates a copy of this section with the given fields replaced.
  DrawerSectionData copyWith({
    String? id,
    List<DrawerItem>? items,
    String? title,
    IconData? icon,
    bool? isCollapsible,
    bool? initiallyExpanded,
    Widget? headerWidget,
    Widget? footerWidget,
    bool? dividerAbove,
    bool? dividerBelow,
    EdgeInsetsGeometry? padding,
  }) {
    return DrawerSectionData(
      id: id ?? this.id,
      items: items ?? this.items,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      isCollapsible: isCollapsible ?? this.isCollapsible,
      initiallyExpanded: initiallyExpanded ?? this.initiallyExpanded,
      headerWidget: headerWidget ?? this.headerWidget,
      footerWidget: footerWidget ?? this.footerWidget,
      dividerAbove: dividerAbove ?? this.dividerAbove,
      dividerBelow: dividerBelow ?? this.dividerBelow,
      padding: padding ?? this.padding,
    );
  }
}
