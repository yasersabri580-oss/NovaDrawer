// Copyright (c) 2026 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../models/footer_config.dart';
import 'footer_utils.dart';

/// Minimal footer displaying the app version and optional legal / links row.
///
/// Layout:
/// ```
/// ┌──────────────────────────────────┐
/// │  v1.2.0    Privacy · Terms       │
/// │  © 2026 My App                   │
/// └──────────────────────────────────┘
/// ```
class NovaFooterMinimal extends StatelessWidget {
  /// Creates a [NovaFooterMinimal].
  const NovaFooterMinimal({super.key, required this.config, this.theme});

  /// Footer configuration.
  final NovaFooterConfig config;

  /// Optional theme override.
  final ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    final t = theme ?? Theme.of(context);
    final height = config.height ?? NovaFooterWidgetUtils.kDefaultHeight;
    final labelColor = t.colorScheme.onSurfaceVariant;
    final smallStyle = t.textTheme.labelSmall?.copyWith(color: labelColor);

    return Container(
      height: height,
      color: t.colorScheme.surface,
      padding: config.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Version + links row
          Row(
            children: [
              if (config.appVersion != null)
                Text('v${config.appVersion}', style: smallStyle),
              if (config.links.isNotEmpty) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    children: [
                      for (final link in config.links)
                        GestureDetector(
                          onTap: link.onTap,
                          child: Text(
                            link.label,
                            style: smallStyle?.copyWith(
                              decoration: TextDecoration.underline,
                              color: t.colorScheme.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          if (config.legalText != null) ...[
            const SizedBox(height: 2),
            Text(config.legalText!, style: smallStyle),
          ],
        ],
      ),
    );
  }
}
