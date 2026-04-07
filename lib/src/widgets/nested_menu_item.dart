// Copyright (c) 2024 AdvancedAppDrawer Contributors
// Licensed under the MIT License.

/// Nested menu item widget for the AdvancedAppDrawer.
///
/// Renders multi-level expandable menu items with animated
/// expansion/collapse and proper indentation.
library;

import 'package:flutter/material.dart';

import '../models/drawer_item.dart';
import '../models/drawer_theme.dart';
import '../models/drawer_config.dart';
import '../controllers/drawer_controller.dart';
import '../utils/responsive_utils.dart';
import 'drawer_item_widget.dart';

/// A nested/expandable drawer menu item.
///
/// When tapped, expands to reveal child items with a smooth
/// animation. Supports arbitrary nesting depth.
///
/// Example:
/// ```dart
/// NestedMenuItem(
///   item: DrawerItem(
///     id: 'settings',
///     title: 'Settings',
///     icon: Icons.settings,
///     children: [
///       DrawerItem(id: 'account', title: 'Account'),
///       DrawerItem(id: 'privacy', title: 'Privacy'),
///     ],
///   ),
/// )
/// ```
class NestedMenuItem extends StatefulWidget {
  /// Creates a [NestedMenuItem].
  const NestedMenuItem({
    super.key,
    required this.item,
    this.isSelected = false,
    this.depth = 0,
    this.onItemTap,
    this.theme,
    this.config,
    this.isMiniMode = false,
  });

  /// The drawer item data (must have children).
  final DrawerItem item;

  /// Whether this item is selected.
  final bool isSelected;

  /// Nesting depth.
  final int depth;

  /// Callback when a child item is tapped.
  final void Function(DrawerItem item)? onItemTap;

  /// Theme overrides.
  final AdvancedDrawerTheme? theme;

  /// Configuration.
  final DrawerConfig? config;

  /// Whether the drawer is in mini mode.
  final bool isMiniMode;

  @override
  State<NestedMenuItem> createState() => _NestedMenuItemState();
}

class _NestedMenuItemState extends State<NestedMenuItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: widget.config?.animationConfig.nestedExpandDuration ??
          const Duration(milliseconds: 200),
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOutCubic,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _expandController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    );

    // Set initial expansion state
    final controller = DrawerControllerProvider.read(context);
    if (controller.isItemExpanded(widget.item.id) ||
        widget.item.initiallyExpanded) {
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
        const AdvancedDrawerTheme().resolve(themeData);
    final controller = DrawerControllerProvider.of(context);
    final isExpanded = controller.isItemExpanded(widget.item.id);

    // Sync animation with controller state
    if (isExpanded && !_expandController.isCompleted) {
      _expandController.forward();
    } else if (!isExpanded && !_expandController.isDismissed) {
      _expandController.reverse();
    }

    // In mini mode, show only the icon with a popup for children
    if (widget.isMiniMode) {
      return _buildMiniNestedItem(drawerTheme, controller);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Parent item
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: DrawerItemWidget(
            item: widget.item,
            isSelected: widget.isSelected,
            depth: widget.depth,
            onTap: () => _handleParentTap(controller),
            theme: widget.theme,
            config: widget.config,
          ),
        ),

        // Animated children container
        SizeTransition(
          sizeFactor: _expandAnimation,
          axisAlignment: -1.0,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildChildren(drawerTheme, controller),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniNestedItem(
    AdvancedDrawerTheme drawerTheme,
    AdvancedDrawerController controller,
  ) {
    return PopupMenuButton<String>(
      tooltip: widget.item.title,
      offset: const Offset(56, 0),
      onSelected: (itemId) {
        final selectedItem = _findItem(itemId, widget.item.children);
        if (selectedItem != null) {
          controller.selectItem(selectedItem.id);
          widget.onItemTap?.call(selectedItem);
          selectedItem.onTap?.call();
        }
      },
      itemBuilder: (context) => _buildPopupItems(widget.item.children, 0),
      child: DrawerItemWidget(
        item: widget.item,
        isSelected: widget.isSelected,
        isMiniMode: true,
        theme: widget.theme,
        config: widget.config,
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildPopupItems(
    List<DrawerItem> items,
    int depth,
  ) {
    final entries = <PopupMenuEntry<String>>[];
    for (final item in items) {
      if (!item.isVisible) continue;

      entries.add(PopupMenuItem<String>(
        value: item.id,
        enabled: item.isEnabled,
        child: Padding(
          padding: EdgeInsets.only(left: depth * 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null) ...[
                Icon(item.icon, size: 20.0),
                const SizedBox(width: 12.0),
              ],
              Text(item.title),
            ],
          ),
        ),
      ));

      if (item.hasChildren) {
        entries.addAll(_buildPopupItems(item.children, depth + 1));
      }
    }
    return entries;
  }

  Widget _buildChildren(
    AdvancedDrawerTheme drawerTheme,
    AdvancedDrawerController controller,
  ) {
    final childDepth = widget.depth + 1;
    final visibleChildren = widget.item.children.where((item) {
      return item.isVisible && !controller.isItemHidden(item.id);
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final child in visibleChildren)
            _buildChildItem(child, childDepth, controller),
        ],
      ),
    );
  }

  Widget _buildChildItem(
    DrawerItem item,
    int depth,
    AdvancedDrawerController controller,
  ) {
    final isSelected = controller.isSelected(item.id);

    if (item.hasChildren) {
      return NestedMenuItem(
        item: item,
        isSelected: isSelected,
        depth: depth,
        onItemTap: widget.onItemTap,
        theme: widget.theme,
        config: widget.config,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: DrawerItemWidget(
        item: item,
        isSelected: isSelected,
        depth: depth,
        onTap: () {
          controller.selectItem(item.id);
          widget.onItemTap?.call(item);
          item.onTap?.call();

          // Close drawer on mobile
          final config = widget.config ?? const DrawerConfig();
          if (config.closeOnItemTap &&
              controller.deviceType == DeviceType.mobile) {
            controller.close();
          }
        },
        theme: widget.theme,
        config: widget.config,
      ),
    );
  }

  void _handleParentTap(AdvancedDrawerController controller) {
    controller.toggleItem(widget.item.id);
    // Also fire the item's onTap if it has one
    widget.item.onTap?.call();
  }

  DrawerItem? _findItem(String id, List<DrawerItem> items) {
    for (final item in items) {
      if (item.id == id) return item;
      if (item.hasChildren) {
        final found = _findItem(id, item.children);
        if (found != null) return found;
      }
    }
    return null;
  }
}
