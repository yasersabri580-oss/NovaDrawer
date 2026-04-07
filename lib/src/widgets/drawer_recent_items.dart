// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

/// A recent-items list widget for the drawer.
///
/// Displays a list of recently accessed items with icon, title,
/// subtitle, and a relative timestamp.
library;

import 'package:flutter/material.dart';

import '../models/content_config.dart';

/// A list of [DrawerRecentItem] entries with a "Recent" header.
///
/// Example:
/// ```dart
/// DrawerRecentItems(
///   items: [
///     DrawerRecentItem(
///       id: '1',
///       title: 'Design System',
///       subtitle: 'Updated colors',
///       icon: Icons.palette,
///       timestamp: DateTime.now().subtract(Duration(minutes: 5)),
///     ),
///   ],
/// )
/// ```
class DrawerRecentItems extends StatelessWidget {
  /// Creates a [DrawerRecentItems] widget.
  const DrawerRecentItems({
    super.key,
    required this.items,
    this.headerText = 'Recent',
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  });

  /// The recent items to display.
  final List<DrawerRecentItem> items;

  /// Header text displayed above the list.
  final String headerText;

  /// Outer padding around the widget.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            headerText.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8.0),
          for (final item in items) _buildItem(context, item),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, DrawerRecentItem item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Icon(
              item.icon ?? Icons.history,
              size: 20.0,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.subtitle != null)
                    Text(
                      item.subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (item.timestamp != null)
              Text(
                _formatRelativeTime(item.timestamp!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withAlpha(180),
                  fontSize: 11.0,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Formats a [DateTime] as a human-readable relative string.
  static String _formatRelativeTime(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }
}
