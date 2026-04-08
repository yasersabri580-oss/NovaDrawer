// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Drawer header widget for the NovaAppDrawer.
///
/// Displays user information, branding, or custom content at
/// the top of the drawer with configurable layout and theming.
library;

import 'package:flutter/material.dart';

import '../models/drawer_theme.dart';
import '../controllers/drawer_controller.dart';

/// A customizable header displayed at the top of the drawer.
///
/// Supports user avatar, title, subtitle, and action buttons.
/// Can also display a fully custom widget via [customWidget].
///
/// Example:
/// ```dart
/// NovaDrawerHeaderWidget(
///   title: 'John Doe',
///   subtitle: 'john@example.com',
///   avatar: CircleAvatar(child: Text('JD')),
///   onTap: () => navigateToProfile(),
/// )
/// ```
class NovaDrawerHeaderWidget extends StatelessWidget {
  /// Creates a [NovaDrawerHeaderWidget].
  const NovaDrawerHeaderWidget({
    super.key,
    this.title,
    this.subtitle,
    this.avatar,
    this.backgroundWidget,
    this.trailing,
    this.onTap,
    this.customWidget,
    this.showCloseButton = false,
    this.showPinButton = false,
    this.theme,
    this.padding,
    this.height,
    this.decoration,
  });

  /// Title text (e.g., user name or app name).
  final String? title;

  /// Subtitle text (e.g., email or tagline).
  final String? subtitle;

  /// Avatar or logo widget.
  final Widget? avatar;

  /// Widget displayed behind the header content.
  final Widget? backgroundWidget;

  /// Trailing action widget (e.g., settings icon).
  final Widget? trailing;

  /// Callback when the header is tapped.
  final VoidCallback? onTap;

  /// Fully custom widget replacing the default header layout.
  final Widget? customWidget;

  /// Whether to show a close button.
  final bool showCloseButton;

  /// Whether to show a pin/unpin button.
  final bool showPinButton;

  /// Theme overrides.
  final NovaDrawerTheme? theme;

  /// Custom padding.
  final EdgeInsetsGeometry? padding;

  /// Custom height.
  final double? height;

  /// Custom decoration.
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final drawerTheme = theme?.resolve(Theme.of(context)) ??
        const NovaDrawerTheme().resolve(Theme.of(context));
    final effectiveHeight = height ?? drawerTheme.headerHeight ?? 180.0;
    final effectivePadding = padding ??
        const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0);

    if (customWidget != null) {
      return SizedBox(
        height: effectiveHeight,
        child: customWidget,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: effectiveHeight,
        decoration: decoration ??
            BoxDecoration(
              color: drawerTheme.headerBackgroundColor,
            ),
        child: Stack(
          children: [
            // Background
            if (backgroundWidget != null)
              Positioned.fill(child: backgroundWidget!),

            // Content
            Padding(
              padding: effectivePadding,
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row with close/pin buttons
                    if (showCloseButton || showPinButton)
                      _buildActionBar(context, drawerTheme),

                    const Spacer(),

                    // Avatar
                    if (avatar != null) ...[
                      avatar!,
                      const SizedBox(height: 12.0),
                    ],

                    // Title
                    if (title != null)
                      Text(
                        title!,
                        style: drawerTheme.headerTitleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                    // Subtitle
                    if (subtitle != null) ...[
                      const SizedBox(height: 2.0),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              subtitle!,
                              style: drawerTheme.headerSubtitleStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ?trailing,
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBar(BuildContext context, NovaDrawerTheme drawerTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showPinButton)
          _PinButton(theme: drawerTheme),
        if (showCloseButton)
          IconButton(
            icon: Icon(
              Icons.close,
              color: drawerTheme.headerTextColor,
              size: 20.0,
            ),
            onPressed: () {
              NovaDrawerControllerProvider.of(context).close();
            },
            tooltip: 'Close drawer',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 36.0,
              minHeight: 36.0,
            ),
          ),
      ],
    );
  }
}

class _PinButton extends StatelessWidget {
  const _PinButton({required this.theme});

  final NovaDrawerTheme theme;

  @override
  Widget build(BuildContext context) {
    final controller = NovaDrawerControllerProvider.of(context);
    final isPinned = controller.isPinned;

    return IconButton(
      icon: Icon(
        isPinned ? Icons.push_pin : Icons.push_pin_outlined,
        color: theme.headerTextColor,
        size: 20.0,
      ),
      onPressed: () => controller.togglePin(),
      tooltip: isPinned ? 'Unpin drawer' : 'Pin drawer',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 36.0,
        minHeight: 36.0,
      ),
    );
  }
}
