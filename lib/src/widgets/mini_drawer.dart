// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Mini drawer widget for the NovaAppDrawer.
///
/// Provides a collapsed icon-only view of the drawer suitable
/// for tablet and desktop layouts, with expand-on-hover support.
library;

import 'package:flutter/material.dart';

import '../models/drawer_item.dart';
import '../models/drawer_theme.dart';
import '../models/drawer_config.dart';
import '../controllers/drawer_controller.dart';
import '../utils/navigation_utils.dart';
import 'drawer_item_widget.dart';
import 'nested_menu_item.dart';

/// A narrow, icon-only version of the drawer.
///
/// Shows only item icons with tooltips. Can expand on hover
/// or when explicitly triggered. Suitable for persistent display
/// on tablet/desktop layouts.
///
/// Example:
/// ```dart
/// NovaMiniDrawer(
///   items: drawerItems,
///   onItemTap: (item) => navigateTo(item.route),
/// )
/// ```
class NovaMiniDrawer extends StatefulWidget {
  /// Creates a [NovaMiniDrawer].
  const NovaMiniDrawer({
    super.key,
    required this.items,
    this.sections,
    this.header,
    this.footer,
    this.onItemTap,
    this.onNavigate,
    this.onExpandRequest,
    this.theme,
    this.config,
    this.width,
    this.animation,
  });

  /// Flat list of drawer items to display.
  final List<NovaDrawerItem> items;

  /// Sections to display (takes precedence over [items] if provided).
  final List<NovaDrawerSectionData>? sections;

  /// Custom header widget (e.g., app logo).
  final Widget? header;

  /// Custom footer widget.
  final Widget? footer;

  /// Callback when an item is tapped.
  final void Function(NovaDrawerItem item)? onItemTap;

  /// Router-agnostic navigation callback. See [NovaAppDrawer.onNavigate].
  final void Function(BuildContext context, String route)? onNavigate;

  /// Callback when the user requests expansion (e.g., hover).
  final VoidCallback? onExpandRequest;

  /// Theme overrides.
  final NovaDrawerTheme? theme;

  /// Configuration.
  final NovaDrawerConfig? config;

  /// Override width. Defaults to theme mini width.
  final double? width;

  /// Optional animation for entrance effects.
  final Animation<double>? animation;

  @override
  State<NovaMiniDrawer> createState() => _NovaMiniDrawerState();
}

class _NovaMiniDrawerState extends State<NovaMiniDrawer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final drawerTheme = widget.theme?.resolve(themeData) ??
        const NovaDrawerTheme().resolve(themeData);
    final effectiveWidth =
        widget.width ?? drawerTheme.miniDrawerWidth ?? 72.0;
    final config = widget.config ?? const NovaDrawerConfig();

    return MouseRegion(
      onEnter: config.enableHoverExpand ? (_) => _onHover(true) : null,
      onExit: config.enableHoverExpand ? (_) => _onHover(false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: effectiveWidth,
        decoration: BoxDecoration(
          color: drawerTheme.backgroundColor,
          border: BorderDirectional(
            end: BorderSide(
              color: drawerTheme.dividerColor ?? Colors.grey.shade300,
              width: 1.0,
            ),
          ),
          boxShadow: [
            if (drawerTheme.elevation != null && drawerTheme.elevation! > 0)
              BoxShadow(
                color: (drawerTheme.shadowColor ?? Colors.black)
                    .withAlpha(25),
                blurRadius: drawerTheme.elevation! * 2,
              ),
          ],
        ),
        child: Column(
          children: [
            // Header
            if (widget.header != null)
              SizedBox(
                height: 64.0,
                child: Center(child: widget.header),
              )
            else
              const SizedBox(height: 8.0),

            // Expand/Collapse toggle
            _buildToggleButton(drawerTheme),
            const SizedBox(height: 8.0),

            // Items
            Expanded(
              child: _buildItemsList(drawerTheme),
            ),

            // Footer
            if (widget.footer != null) ...[
              Divider(
                color: drawerTheme.dividerColor,
                height: 1.0,
              ),
              SizedBox(
                height: 56.0,
                child: Center(child: widget.footer),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(NovaDrawerTheme drawerTheme) {
    return Tooltip(
      message: 'Expand drawer',
      child: InkWell(
        onTap: widget.onExpandRequest ?? () {
          final controller = NovaDrawerControllerProvider.of(context);
          controller.fromMini();
        },
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          width: 40.0,
          height: 40.0,
          alignment: Alignment.center,
          child: Icon(
            Icons.menu,
            color: drawerTheme.unselectedItemColor,
            size: 22.0,
          ),
        ),
      ),
    );
  }

  Widget _buildItemsList(NovaDrawerTheme drawerTheme) {
    final controller = NovaDrawerControllerProvider.of(context);

    // Use sections if available, otherwise flat items
    final allItems = <NovaDrawerItem>[];
    if (widget.sections != null && widget.sections!.isNotEmpty) {
      for (final section in widget.sections!) {
        allItems.addAll(section.items.where((item) =>
            item.isVisible && !controller.isItemHidden(item.id)));
      }
    } else {
      allItems.addAll(widget.items.where((item) =>
          item.isVisible && !controller.isItemHidden(item.id)));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        final item = allItems[index];
        final isSelected = controller.isSelected(item.id);

        if (item.hasChildren) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: NovaNestedMenuItem(
              item: item,
              isSelected: isSelected,
              onItemTap: widget.onItemTap,
              onNavigate: widget.onNavigate,
              theme: widget.theme,
              config: widget.config,
              isMiniMode: true,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: NovaDrawerItemWidget(
            item: item,
            isSelected: isSelected,
            isMiniMode: true,
            onTap: () => _handleItemTap(item, controller),
            theme: widget.theme,
            config: widget.config,
          ),
        );
      },
    );
  }

  void _handleItemTap(NovaDrawerItem item, NovaDrawerController controller) {
    controller.selectItem(item.id);
    widget.onItemTap?.call(item);
    item.onTap?.call();
    novaNavigateForItem(context, item, widget.onNavigate);
  }

  void _onHover(bool isHovered) {
    if (_isHovered != isHovered) {
      _isHovered = isHovered;
      if (isHovered) {
        Future.delayed(
          widget.config?.hoverExpandDelay ?? const Duration(milliseconds: 500),
          () {
            if (_isHovered && mounted) {
              widget.onExpandRequest?.call();
            }
          },
        );
      }
    }
  }
}
