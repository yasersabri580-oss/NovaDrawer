// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Drawer item widget for the NovaAppDrawer.
///
/// Renders individual menu items with icon, title, subtitle,
/// badge, and interactive states (hover, selected, disabled).
library;

import 'package:flutter/material.dart';

import '../models/drawer_item.dart';
import '../models/drawer_theme.dart';
import '../models/drawer_config.dart';
import '../controllers/drawer_controller.dart';
import '../utils/accessibility_utils.dart';

/// A widget that renders a single drawer menu item.
///
/// Displays the item's icon, title, optional subtitle, badge,
/// and trailing widget. Supports selected, hovered, and disabled states.
///
/// Example:
/// ```dart
/// NovaDrawerItemWidget(
///   item: NovaDrawerItem(id: 'home', title: 'Home', icon: Icons.home),
///   isSelected: true,
///   onTap: () => navigateTo('/home'),
/// )
/// ```
class NovaDrawerItemWidget extends StatefulWidget {
  /// Creates a [NovaDrawerItemWidget].
  const NovaDrawerItemWidget({
    super.key,
    required this.item,
    this.isSelected = false,
    this.depth = 0,
    this.onTap,
    this.onLongPress,
    this.theme,
    this.config,
    this.isMiniMode = false,
  });

  /// The drawer item data to render.
  final NovaDrawerItem item;

  /// Whether this item is currently selected/active.
  final bool isSelected;

  /// Nesting depth (0 = top level).
  final int depth;

  /// Callback when the item is tapped.
  final VoidCallback? onTap;

  /// Callback when the item is long-pressed.
  final VoidCallback? onLongPress;

  /// Theme overrides.
  final NovaDrawerTheme? theme;

  /// Configuration.
  final NovaDrawerConfig? config;

  /// Whether the drawer is in mini mode (icon only).
  final bool isMiniMode;

  @override
  State<NovaDrawerItemWidget> createState() => _NovaDrawerItemWidgetState();
}

class _NovaDrawerItemWidgetState extends State<NovaDrawerItemWidget>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _hoverAnimation = CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final drawerTheme = widget.theme?.resolve(themeData) ??
        const NovaDrawerTheme().resolve(themeData);
    final accessibilityConfig = widget.config?.accessibilityConfig ??
        const NovaDrawerAccessibilityConfig();
    final isEnabled = widget.item.isEnabled;
    final indentation = widget.depth * 16.0;

    Widget itemWidget;

    if (widget.isMiniMode) {
      itemWidget = _buildMiniItem(drawerTheme, isEnabled);
    } else {
      itemWidget = _buildFullItem(drawerTheme, isEnabled, indentation);
    }

    // Wrap with accessibility
    itemWidget = NovaAccessibilityUtils.wrapWithSemantics(
      child: itemWidget,
      item: widget.item,
      isSelected: widget.isSelected,
      config: accessibilityConfig,
    );

    return itemWidget;
  }

  Widget _buildMiniItem(NovaDrawerTheme drawerTheme, bool isEnabled) {
    final iconColor = widget.isSelected
        ? drawerTheme.selectedItemColor
        : drawerTheme.unselectedItemColor;

    return Tooltip(
      message: widget.item.title,
      child: InkWell(
        onTap: isEnabled ? (widget.onTap ?? widget.item.onTap) : null,
        borderRadius: (drawerTheme.itemBorderRadius as BorderRadius?) ??
            BorderRadius.circular(8.0),
        child: Container(
          width: double.infinity,
          height: drawerTheme.itemHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? drawerTheme.selectedItemBackgroundColor
                : null,
            borderRadius: drawerTheme.itemBorderRadius,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                widget.isSelected
                    ? widget.item.effectiveSelectedIcon
                    : widget.item.icon,
                color: isEnabled ? iconColor : iconColor?.withAlpha(97),
                size: drawerTheme.iconSize,
              ),
              if (widget.item.badge != null)
                Positioned(
                  top: -4,
                  right: -8,
                  child: _buildBadge(drawerTheme),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullItem(
    NovaDrawerTheme drawerTheme,
    bool isEnabled,
    double indentation,
  ) {
    final textColor = widget.isSelected
        ? drawerTheme.selectedItemColor
        : drawerTheme.unselectedItemColor;
    final iconColor = textColor;
    final textStyle = widget.isSelected
        ? drawerTheme.selectedItemTextStyle
        : drawerTheme.itemTextStyle;

    return AnimatedBuilder(
      animation: _hoverAnimation,
      builder: (context, child) {
        final hoverOpacity = _hoverAnimation.value * 0.08;

        return MouseRegion(
          onEnter: (_) => _onHoverChanged(true),
          onExit: (_) => _onHoverChanged(false),
          child: InkWell(
            onTap: isEnabled ? (widget.onTap ?? widget.item.onTap) : null,
            onLongPress: isEnabled ? widget.onLongPress : null,
            borderRadius: (drawerTheme.itemBorderRadius as BorderRadius?) ??
                BorderRadius.circular(8.0),
            splashColor: drawerTheme.splashColor,
            hoverColor: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsetsDirectional.only(
                start: (drawerTheme.itemPadding as EdgeInsets?)?.left ??
                    12.0 + indentation,
                end: (drawerTheme.itemPadding as EdgeInsets?)?.right ?? 12.0,
                top: (drawerTheme.itemPadding as EdgeInsets?)?.top ?? 4.0,
                bottom:
                    (drawerTheme.itemPadding as EdgeInsets?)?.bottom ?? 4.0,
              ),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? drawerTheme.selectedItemBackgroundColor
                    : _isHovered
                        ? (drawerTheme.hoverColor ?? Colors.black)
                            .withAlpha((hoverOpacity * 255).round())
                        : null,
                borderRadius: drawerTheme.itemBorderRadius,
              ),
              constraints: BoxConstraints(
                minHeight: drawerTheme.itemHeight ?? 48.0,
              ),
              child: Row(
                children: [
                  // Leading icon or custom widget
                  if (widget.item.leading != null)
                    widget.item.leading!
                  else if (widget.item.icon != null)
                    Icon(
                      widget.isSelected
                          ? widget.item.effectiveSelectedIcon
                          : widget.item.icon,
                      color: isEnabled
                          ? iconColor
                          : iconColor?.withAlpha(97),
                      size: widget.isSelected
                          ? drawerTheme.selectedIconSize
                          : drawerTheme.iconSize,
                    ),

                  if (widget.item.icon != null || widget.item.leading != null)
                    const SizedBox(width: 16.0),

                  // Title and subtitle
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.title,
                          style: textStyle?.copyWith(
                            color: isEnabled
                                ? textColor
                                : textColor?.withAlpha(97),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.item.subtitle != null) ...[
                          const SizedBox(height: 2.0),
                          Text(
                            widget.item.subtitle!,
                            style: drawerTheme.subtitleTextStyle?.copyWith(
                              color: isEnabled ? null : Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Badge
                  if (widget.item.badge != null) ...[
                    const SizedBox(width: 8.0),
                    _buildBadge(drawerTheme),
                  ],

                  // Trailing widget or expand icon
                  if (widget.item.trailing != null)
                    widget.item.trailing!
                  else if (widget.item.hasChildren)
                    _buildExpandIcon(drawerTheme),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadge(NovaDrawerTheme drawerTheme) {
    final badge = widget.item.badge!;
    final badgeTheme = drawerTheme.badgeTheme;

    if (badge.customWidget != null) return badge.customWidget!;

    final backgroundColor = badge.backgroundColor ??
        badgeTheme?.backgroundColor ??
        Theme.of(context).colorScheme.error;
    final textColor = badge.textColor ??
        badgeTheme?.textColor ??
        Theme.of(context).colorScheme.onError;

    return Container(
      padding: badgeTheme?.padding ??
          const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      constraints: const BoxConstraints(minWidth: 18.0, minHeight: 18.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: badgeTheme?.borderRadius ?? BorderRadius.circular(9.0),
      ),
      alignment: Alignment.center,
      child: Text(
        badge.displayText,
        style: badgeTheme?.textStyle ??
            TextStyle(
              color: textColor,
              fontSize: 10.0,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildExpandIcon(NovaDrawerTheme drawerTheme) {
    final controller = NovaDrawerControllerProvider.of(context);
    final isExpanded = controller.isItemExpanded(widget.item.id);

    return AnimatedRotation(
      turns: isExpanded ? 0.25 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Icon(
        Icons.chevron_right,
        color: drawerTheme.unselectedItemColor?.withAlpha(153),
        size: 20.0,
      ),
    );
  }

  void _onHoverChanged(bool isHovered) {
    if (_isHovered != isHovered) {
      setState(() => _isHovered = isHovered);
      if (isHovered) {
        _hoverController.forward();
      } else {
        _hoverController.reverse();
      }
    }
  }
}
