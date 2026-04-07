// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

/// Workspace / account switcher widget for the drawer.
///
/// Displays the active workspace with a dropdown to switch between
/// available workspaces. Each workspace shows an icon or avatar
/// alongside its name, with a checkmark for the active entry.
library;

import 'package:flutter/material.dart';

import '../models/content_config.dart';

/// A workspace switcher that shows the active [DrawerWorkspace]
/// and allows switching between a list of workspaces.
///
/// Example:
/// ```dart
/// DrawerWorkspaceSwitcher(
///   workspaces: [
///     DrawerWorkspace(id: 'w1', name: 'Personal', isActive: true),
///     DrawerWorkspace(id: 'w2', name: 'Work', icon: Icons.business),
///   ],
/// )
/// ```
class DrawerWorkspaceSwitcher extends StatefulWidget {
  /// Creates a [DrawerWorkspaceSwitcher].
  const DrawerWorkspaceSwitcher({
    super.key,
    required this.workspaces,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  });

  /// Available workspaces.
  final List<DrawerWorkspace> workspaces;

  /// Outer padding around the widget.
  final EdgeInsetsGeometry padding;

  @override
  State<DrawerWorkspaceSwitcher> createState() =>
      _DrawerWorkspaceSwitcherState();
}

class _DrawerWorkspaceSwitcherState extends State<DrawerWorkspaceSwitcher> {
  bool _expanded = false;

  DrawerWorkspace? get _active {
    final matches = widget.workspaces.where((w) => w.isActive);
    return matches.isNotEmpty ? matches.first : widget.workspaces.firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    final active = _active;
    if (active == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: widget.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Active workspace header
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withAlpha(80),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: colorScheme.outline.withAlpha(40),
                ),
              ),
              child: Row(
                children: [
                  _buildAvatar(active, colorScheme),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      active.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more,
                      size: 20.0,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Dropdown list
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildDropdown(context),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final workspace in widget.workspaces)
            InkWell(
              onTap: () {
                workspace.onSelect?.call();
                setState(() => _expanded = false);
              },
              borderRadius: BorderRadius.circular(8.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    _buildAvatar(workspace, colorScheme),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Text(
                        workspace.name,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (workspace.isActive)
                      Icon(
                        Icons.check,
                        size: 18.0,
                        color: colorScheme.primary,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(DrawerWorkspace workspace, ColorScheme colorScheme) {
    if (workspace.avatarUrl != null) {
      return CircleAvatar(
        radius: 14.0,
        backgroundImage: NetworkImage(workspace.avatarUrl!),
      );
    }

    return CircleAvatar(
      radius: 14.0,
      backgroundColor: colorScheme.primaryContainer,
      child: workspace.icon != null
          ? Icon(workspace.icon, size: 14.0, color: colorScheme.onPrimaryContainer)
          : Text(
              workspace.name.isNotEmpty ? workspace.name[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
    );
  }
}
