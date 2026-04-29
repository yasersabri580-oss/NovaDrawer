// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Drawer section widget for the NovaAppDrawer.
///
/// Groups related drawer items under a collapsible/expandable
/// section header with smooth animation.
library;

import 'package:flutter/material.dart';

import '../models/drawer_item.dart';
import '../models/drawer_theme.dart';
import '../models/drawer_config.dart';
import '../controllers/drawer_controller.dart';
import '../utils/accessibility_utils.dart';
import '../utils/navigation_utils.dart';
import '../utils/responsive_utils.dart';
import 'drawer_item_widget.dart';
import 'nested_menu_item.dart';

/// A collapsible section within the drawer that groups related items.
///
/// Displays an optional section header that can be tapped to
/// expand or collapse the contained items with smooth animation.
///
/// Example:
/// ```dart
/// NovaDrawerSectionWidget(
///   section: NovaDrawerSectionData(
///     id: 'main',
///     title: 'Navigation',
///     items: [
///       NovaDrawerItem(id: 'home', title: 'Home', icon: Icons.home),
///       NovaDrawerItem(id: 'search', title: 'Search', icon: Icons.search),
///     ],
///   ),
/// )
/// ```
class NovaDrawerSectionWidget extends StatefulWidget {
  /// Creates a [NovaDrawerSectionWidget].
  const NovaDrawerSectionWidget({
    super.key,
    required this.section,
    this.onItemTap,
    this.onNavigate,
    this.theme,
    this.config,
    this.isMiniMode = false,
    this.itemAnimation,
    this.itemAnimationIndex = 0,
    this.totalAnimatedItems = 10,
  });

  /// The section data to render.
  final NovaDrawerSectionData section;

  /// Callback when any item in the section is tapped.
  final void Function(NovaDrawerItem item)? onItemTap;

  /// Router-agnostic navigation callback. See [NovaAppDrawer.onNavigate].
  final void Function(BuildContext context, String route)? onNavigate;

  /// Theme overrides.
  final NovaDrawerTheme? theme;

  /// Configuration.
  final NovaDrawerConfig? config;

  /// Whether the drawer is in mini mode.
  final bool isMiniMode;

  /// Optional animation for staggered item entrance.
  final Animation<double>? itemAnimation;

  /// Starting index for staggered animation.
  final int itemAnimationIndex;

  /// Total items for staggered timing calculation.
  final int totalAnimatedItems;

  @override
  State<NovaDrawerSectionWidget> createState() => _NovaDrawerSectionWidgetState();
}

class _NovaDrawerSectionWidgetState extends State<NovaDrawerSectionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: widget.config?.animationConfig.sectionAnimationDuration ??
          const Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOutCubic,
    );

    // Set initial state
    final controller = NovaDrawerControllerProvider.read(context);
    if (controller.isSectionExpanded(widget.section.id)) {
      _expandController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final drawerTheme = widget.theme?.resolve(themeData) ??
        const NovaDrawerTheme().resolve(themeData);
    final controller = NovaDrawerControllerProvider.of(context);
    final isExpanded = controller.isSectionExpanded(widget.section.id);

    // Sync animation with controller state
    if (isExpanded && !_expandController.isCompleted) {
      _expandController.forward();
    } else if (!isExpanded && !_expandController.isDismissed) {
      _expandController.reverse();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Divider above
        if (widget.section.dividerAbove)
          Divider(
            color: drawerTheme.dividerColor,
            height: 1.0,
          ),

        // Section padding
        Padding(
          padding: widget.section.padding ??
              drawerTheme.sectionPadding ??
              const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Section header
              if (widget.section.title != null && !widget.isMiniMode)
                _buildSectionHeader(drawerTheme, controller, isExpanded),

              // Custom header widget
              if (widget.section.headerWidget != null && !widget.isMiniMode)
                widget.section.headerWidget!,

              // Items
              if (widget.section.isCollapsible)
                SizeTransition(
                  sizeFactor: _expandAnimation,
                  axisAlignment: -1.0,
                  child: _buildItemsList(drawerTheme, controller),
                )
              else
                _buildItemsList(drawerTheme, controller),

              // Custom footer widget
              if (widget.section.footerWidget != null && !widget.isMiniMode)
                widget.section.footerWidget!,
            ],
          ),
        ),

        // Divider below
        if (widget.section.dividerBelow)
          Divider(
            color: drawerTheme.dividerColor,
            height: 1.0,
          ),
      ],
    );
  }

  Widget _buildSectionHeader(
    NovaDrawerTheme drawerTheme,
    NovaDrawerController controller,
    bool isExpanded,
  ) {
    final header = Semantics(
      label: NovaAccessibilityUtils.sectionHeaderLabel(
        widget.section.title!,
        isExpanded,
      ),
      button: widget.section.isCollapsible,
      child: InkWell(
        onTap: widget.section.isCollapsible
            ? () => controller.toggleSection(widget.section.id)
            : null,
        borderRadius: BorderRadius.circular(4.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Row(
            children: [
              if (widget.section.icon != null) ...[
                Icon(
                  widget.section.icon,
                  size: 16.0,
                  color: drawerTheme.sectionTitleStyle?.color,
                ),
                const SizedBox(width: 8.0),
              ],
              Expanded(
                child: Text(
                  widget.section.title!.toUpperCase(),
                  style: drawerTheme.sectionTitleStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.section.isCollapsible)
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.expand_more,
                    size: 18.0,
                    color: drawerTheme.sectionTitleStyle?.color,
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    return header;
  }

  Widget _buildItemsList(
    NovaDrawerTheme drawerTheme,
    NovaDrawerController controller,
  ) {
    final visibleItems = widget.section.items.where((item) {
      return item.isVisible && !controller.isItemHidden(item.id);
    }).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < visibleItems.length; i++)
          _buildItem(visibleItems[i], drawerTheme, controller, i),
      ],
    );
  }

  Widget _buildItem(
    NovaDrawerItem item,
    NovaDrawerTheme drawerTheme,
    NovaDrawerController controller,
    int index,
  ) {
    if (item.customWidget != null) {
      return item.customWidget!;
    }

    final isSelected = controller.isSelected(item.id);

    if (item.hasChildren) {
      return NovaNestedMenuItem(
        item: item,
        isSelected: isSelected,
        onItemTap: widget.onItemTap,
        onNavigate: widget.onNavigate,
        theme: widget.theme,
        config: widget.config,
        isMiniMode: widget.isMiniMode,
        depth: 0,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: NovaDrawerItemWidget(
        item: item,
        isSelected: isSelected,
        depth: 0,
        onTap: () => _handleItemTap(item, controller),
        theme: widget.theme,
        config: widget.config,
        isMiniMode: widget.isMiniMode,
      ),
    );
  }

  void _handleItemTap(NovaDrawerItem item, NovaDrawerController controller) {
    controller.selectItem(item.id);
    widget.onItemTap?.call(item);
    item.onTap?.call();
    novaNavigateForItem(context, item, widget.onNavigate);

    // Close drawer on mobile if configured
    final config = widget.config ?? const NovaDrawerConfig();
    if (config.closeOnItemTap && controller.deviceType == NovaDeviceType.mobile) {
      controller.close();
    }
  }
}
