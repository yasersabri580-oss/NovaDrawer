// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

/// A stats card widget for the drawer.
///
/// Displays a horizontal row of stat items with values and labels,
/// separated by vertical dividers inside a card-like container.
library;

import 'package:flutter/material.dart';

import '../models/content_config.dart';

/// A card showing a row of [DrawerStatItem] values.
///
/// Example:
/// ```dart
/// DrawerStatsCard(
///   items: [
///     DrawerStatItem(label: 'Projects', value: '12'),
///     DrawerStatItem(label: 'Tasks', value: '48'),
///     DrawerStatItem(label: 'Stars', value: '2.3k'),
///   ],
/// )
/// ```
class DrawerStatsCard extends StatelessWidget {
  /// Creates a [DrawerStatsCard].
  const DrawerStatsCard({
    super.key,
    required this.items,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  });

  /// The stat items to display.
  final List<DrawerStatItem> items;

  /// Outer padding around the card.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withAlpha(80),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: colorScheme.outline.withAlpha(40),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: IntrinsicHeight(
          child: Row(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                if (i > 0)
                  VerticalDivider(
                    width: 1.0,
                    thickness: 1.0,
                    indent: 4.0,
                    endIndent: 4.0,
                    color: colorScheme.outline.withAlpha(50),
                  ),
                Expanded(child: _buildStatItem(context, items[i])),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, DrawerStatItem item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.icon != null) ...[
            Icon(item.icon, size: 16.0, color: colorScheme.primary),
            const SizedBox(height: 4.0),
          ],
          Text(
            item.value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            item.label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
