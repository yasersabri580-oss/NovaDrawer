// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

/// App status / footer widget for the drawer.
///
/// Shows an online/offline indicator, optional status message,
/// and version information in a compact layout suitable for the
/// bottom of the drawer.
library;

import 'package:flutter/material.dart';

import '../models/content_config.dart';

/// A compact app-status indicator for the drawer footer.
///
/// Example:
/// ```dart
/// DrawerAppStatusWidget(
///   status: DrawerAppStatus(
///     isOnline: true,
///     statusMessage: 'Connected',
///     version: '1.2.0',
///     buildNumber: '42',
///   ),
/// )
/// ```
class DrawerAppStatusWidget extends StatelessWidget {
  /// Creates a [DrawerAppStatusWidget].
  const DrawerAppStatusWidget({
    super.key,
    required this.status,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  });

  /// The app status data to display.
  final DrawerAppStatus status;

  /// Outer padding around the widget.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (status.customWidget != null) return status.customWidget!;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dotColor = status.isOnline ? Colors.green : Colors.red;

    return Padding(
      padding: padding,
      child: Row(
        children: [
          // Connection dot
          Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8.0),

          // Status message
          Expanded(
            child: Text(
              status.statusMessage ??
                  (status.isOnline ? 'Online' : 'Offline'),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Version info
          if (status.version != null)
            Text(
              _versionLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withAlpha(160),
                fontSize: 11.0,
              ),
            ),
        ],
      ),
    );
  }

  String get _versionLabel {
    final buffer = StringBuffer('v${status.version}');
    if (status.buildNumber != null) {
      buffer.write(' (${status.buildNumber})');
    }
    return buffer.toString();
  }
}
