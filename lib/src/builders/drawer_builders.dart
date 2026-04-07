// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../models/drawer_item.dart';
import '../models/drawer_config.dart';
import '../models/drawer_theme.dart';
import '../models/header_config.dart';
import '../models/content_config.dart';

/// A set of builder callbacks for customizing every aspect of the drawer.
///
/// Developers can override specific parts of the drawer rendering
/// by providing builder callbacks. If a builder is null, the default
/// rendering is used.
///
/// ## Usage:
/// ```dart
/// DrawerBuilders(
///   headerBuilder: (context, config) => MyCustomHeader(config: config),
///   itemBuilder: (context, item, isSelected) => MyCustomItem(item: item),
///   footerBuilder: (context) => MyCustomFooter(),
/// )
/// ```
class DrawerBuilders {
  /// Creates a set of drawer builders.
  const DrawerBuilders({
    this.headerBuilder,
    this.itemBuilder,
    this.sectionBuilder,
    this.backgroundBuilder,
    this.footerBuilder,
    this.emptyStateBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.searchBarBuilder,
    this.filterChipBuilder,
    this.statsCardBuilder,
    this.shortcutGridBuilder,
    this.recentItemBuilder,
    this.workspaceSwitcherBuilder,
    this.appStatusBuilder,
    this.separatorBuilder,
    this.accessibilityLabelBuilder,
  });

  /// Custom header builder.
  final Widget Function(BuildContext context, NovaHeaderConfig config)?
      headerBuilder;

  /// Custom item builder.
  final Widget Function(
      BuildContext context, DrawerItem item, bool isSelected)?
      itemBuilder;

  /// Custom section builder.
  final Widget Function(
      BuildContext context, DrawerSectionData section)?
      sectionBuilder;

  /// Custom background builder.
  final Widget Function(BuildContext context, Widget child)?
      backgroundBuilder;

  /// Custom footer builder.
  final Widget Function(BuildContext context)? footerBuilder;

  /// Custom empty state builder (when no items are available).
  final Widget Function(BuildContext context)? emptyStateBuilder;

  /// Custom loading state builder.
  final Widget Function(BuildContext context)? loadingBuilder;

  /// Custom error state builder.
  final Widget Function(BuildContext context, String? message,
      VoidCallback? onRetry)? errorBuilder;

  /// Custom search bar builder.
  final Widget Function(BuildContext context, TextEditingController controller,
      ValueChanged<String> onChanged)? searchBarBuilder;

  /// Custom filter chip builder.
  final Widget Function(BuildContext context, DrawerFilterChip chip)?
      filterChipBuilder;

  /// Custom stats card builder.
  final Widget Function(BuildContext context, List<DrawerStatItem> stats)?
      statsCardBuilder;

  /// Custom shortcut grid builder.
  final Widget Function(
      BuildContext context, List<DrawerShortcut> shortcuts)?
      shortcutGridBuilder;

  /// Custom recent item builder.
  final Widget Function(
      BuildContext context, DrawerRecentItem item)?
      recentItemBuilder;

  /// Custom workspace switcher builder.
  final Widget Function(
      BuildContext context, List<DrawerWorkspace> workspaces)?
      workspaceSwitcherBuilder;

  /// Custom app status builder.
  final Widget Function(BuildContext context, DrawerAppStatus status)?
      appStatusBuilder;

  /// Custom separator/divider builder.
  final Widget Function(BuildContext context)? separatorBuilder;

  /// Custom accessibility label builder for items.
  final String Function(DrawerItem item, bool isSelected)?
      accessibilityLabelBuilder;

  /// Creates a copy with the given fields replaced.
  DrawerBuilders copyWith({
    Widget Function(BuildContext, NovaHeaderConfig)? headerBuilder,
    Widget Function(BuildContext, DrawerItem, bool)? itemBuilder,
    Widget Function(BuildContext, DrawerSectionData)? sectionBuilder,
    Widget Function(BuildContext, Widget)? backgroundBuilder,
    Widget Function(BuildContext)? footerBuilder,
    Widget Function(BuildContext)? emptyStateBuilder,
    Widget Function(BuildContext)? loadingBuilder,
    Widget Function(BuildContext, String?, VoidCallback?)? errorBuilder,
    Widget Function(BuildContext, TextEditingController,
            ValueChanged<String>)?
        searchBarBuilder,
    Widget Function(BuildContext, DrawerFilterChip)? filterChipBuilder,
    Widget Function(BuildContext, List<DrawerStatItem>)? statsCardBuilder,
    Widget Function(BuildContext, List<DrawerShortcut>)? shortcutGridBuilder,
    Widget Function(BuildContext, DrawerRecentItem)? recentItemBuilder,
    Widget Function(BuildContext, List<DrawerWorkspace>)?
        workspaceSwitcherBuilder,
    Widget Function(BuildContext, DrawerAppStatus)? appStatusBuilder,
    Widget Function(BuildContext)? separatorBuilder,
    String Function(DrawerItem, bool)? accessibilityLabelBuilder,
  }) {
    return DrawerBuilders(
      headerBuilder: headerBuilder ?? this.headerBuilder,
      itemBuilder: itemBuilder ?? this.itemBuilder,
      sectionBuilder: sectionBuilder ?? this.sectionBuilder,
      backgroundBuilder: backgroundBuilder ?? this.backgroundBuilder,
      footerBuilder: footerBuilder ?? this.footerBuilder,
      emptyStateBuilder: emptyStateBuilder ?? this.emptyStateBuilder,
      loadingBuilder: loadingBuilder ?? this.loadingBuilder,
      errorBuilder: errorBuilder ?? this.errorBuilder,
      searchBarBuilder: searchBarBuilder ?? this.searchBarBuilder,
      filterChipBuilder: filterChipBuilder ?? this.filterChipBuilder,
      statsCardBuilder: statsCardBuilder ?? this.statsCardBuilder,
      shortcutGridBuilder: shortcutGridBuilder ?? this.shortcutGridBuilder,
      recentItemBuilder: recentItemBuilder ?? this.recentItemBuilder,
      workspaceSwitcherBuilder:
          workspaceSwitcherBuilder ?? this.workspaceSwitcherBuilder,
      appStatusBuilder: appStatusBuilder ?? this.appStatusBuilder,
      separatorBuilder: separatorBuilder ?? this.separatorBuilder,
      accessibilityLabelBuilder:
          accessibilityLabelBuilder ?? this.accessibilityLabelBuilder,
    );
  }
}
