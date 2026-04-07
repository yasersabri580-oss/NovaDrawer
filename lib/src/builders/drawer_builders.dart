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
/// NovaDrawerBuilders(
///   headerBuilder: (context, config) => MyCustomHeader(config: config),
///   itemBuilder: (context, item, isSelected) => MyCustomItem(item: item),
///   footerBuilder: (context) => MyCustomFooter(),
/// )
/// ```
class NovaDrawerBuilders {
  /// Creates a set of drawer builders.
  const NovaDrawerBuilders({
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
      BuildContext context, NovaDrawerItem item, bool isSelected)?
      itemBuilder;

  /// Custom section builder.
  final Widget Function(
      BuildContext context, NovaDrawerSectionData section)?
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
  final Widget Function(BuildContext context, NovaDrawerFilterChip chip)?
      filterChipBuilder;

  /// Custom stats card builder.
  final Widget Function(BuildContext context, List<NovaDrawerStatItem> stats)?
      statsCardBuilder;

  /// Custom shortcut grid builder.
  final Widget Function(
      BuildContext context, List<NovaDrawerShortcut> shortcuts)?
      shortcutGridBuilder;

  /// Custom recent item builder.
  final Widget Function(
      BuildContext context, NovaDrawerRecentItem item)?
      recentItemBuilder;

  /// Custom workspace switcher builder.
  final Widget Function(
      BuildContext context, List<NovaDrawerWorkspace> workspaces)?
      workspaceSwitcherBuilder;

  /// Custom app status builder.
  final Widget Function(BuildContext context, NovaDrawerAppStatus status)?
      appStatusBuilder;

  /// Custom separator/divider builder.
  final Widget Function(BuildContext context)? separatorBuilder;

  /// Custom accessibility label builder for items.
  final String Function(NovaDrawerItem item, bool isSelected)?
      accessibilityLabelBuilder;

  /// Creates a copy with the given fields replaced.
  NovaDrawerBuilders copyWith({
    Widget Function(BuildContext, NovaHeaderConfig)? headerBuilder,
    Widget Function(BuildContext, NovaDrawerItem, bool)? itemBuilder,
    Widget Function(BuildContext, NovaDrawerSectionData)? sectionBuilder,
    Widget Function(BuildContext, Widget)? backgroundBuilder,
    Widget Function(BuildContext)? footerBuilder,
    Widget Function(BuildContext)? emptyStateBuilder,
    Widget Function(BuildContext)? loadingBuilder,
    Widget Function(BuildContext, String?, VoidCallback?)? errorBuilder,
    Widget Function(BuildContext, TextEditingController,
            ValueChanged<String>)?
        searchBarBuilder,
    Widget Function(BuildContext, NovaDrawerFilterChip)? filterChipBuilder,
    Widget Function(BuildContext, List<NovaDrawerStatItem>)? statsCardBuilder,
    Widget Function(BuildContext, List<NovaDrawerShortcut>)? shortcutGridBuilder,
    Widget Function(BuildContext, NovaDrawerRecentItem)? recentItemBuilder,
    Widget Function(BuildContext, List<NovaDrawerWorkspace>)?
        workspaceSwitcherBuilder,
    Widget Function(BuildContext, NovaDrawerAppStatus)? appStatusBuilder,
    Widget Function(BuildContext)? separatorBuilder,
    String Function(NovaDrawerItem, bool)? accessibilityLabelBuilder,
  }) {
    return NovaDrawerBuilders(
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
