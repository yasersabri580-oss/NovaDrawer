// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

/// A grid of shortcut buttons for the drawer.
///
/// Renders tappable shortcut items in a wrapped grid layout with
/// optional badges and accent colors.
library;

import 'package:flutter/material.dart';

import '../models/content_config.dart';

/// A grid of [DrawerShortcut] buttons displayed in the drawer.
///
/// Example:
/// ```dart
/// DrawerShortcutsGrid(
///   shortcuts: [
///     DrawerShortcut(id: 'files', label: 'Files', icon: Icons.folder),
///     DrawerShortcut(id: 'photos', label: 'Photos', icon: Icons.photo),
///     DrawerShortcut(id: 'music', label: 'Music', icon: Icons.music_note),
///   ],
/// )
/// ```
class DrawerShortcutsGrid extends StatelessWidget {
  /// Creates a [DrawerShortcutsGrid].
  const DrawerShortcutsGrid({
    super.key,
    required this.shortcuts,
    this.crossAxisCount = 4,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  });

  /// The shortcuts to display.
  final List<DrawerShortcut> shortcuts;

  /// Number of columns in the grid.
  final int crossAxisCount;

  /// Outer padding around the grid.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Wrap(
        spacing: 12.0,
        runSpacing: 12.0,
        children: [
          for (final shortcut in shortcuts)
            SizedBox(
              width: _itemWidth(context),
              child: _ShortcutTile(shortcut: shortcut),
            ),
        ],
      ),
    );
  }

  double _itemWidth(BuildContext context) {
    final resolved = padding.resolve(TextDirection.ltr);
    final available =
        MediaQuery.of(context).size.width - resolved.left - resolved.right;
    final totalSpacing = 12.0 * (crossAxisCount - 1);
    return (available - totalSpacing) / crossAxisCount;
  }
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({required this.shortcut});

  final DrawerShortcut shortcut;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = shortcut.color ?? colorScheme.primary;

    return InkWell(
      onTap: shortcut.onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: accentColor.withAlpha(20),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(accentColor, colorScheme),
            const SizedBox(height: 6.0),
            Text(
              shortcut.label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(Color accentColor, ColorScheme colorScheme) {
    final icon = Icon(shortcut.icon, size: 24.0, color: accentColor);

    if (shortcut.badge == null || shortcut.badge! <= 0) return icon;

    return Badge(
      label: Text(
        shortcut.badge! > 99 ? '99+' : shortcut.badge.toString(),
        style: const TextStyle(fontSize: 9.0),
      ),
      backgroundColor: colorScheme.error,
      child: icon,
    );
  }
}
