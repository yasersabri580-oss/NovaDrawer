// Copyright (c) 2026 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../../models/footer_config.dart';
import 'footer_utils.dart';

/// Branding footer that shows a logo widget, app name, and version number.
///
/// Layout:
/// ```
/// ┌─────────────────────────────────────┐
/// │  [logo]  MyApp  ·  v1.2.0           │
/// └─────────────────────────────────────┘
/// ```
class NovaFooterBranding extends StatelessWidget {
  /// Creates a [NovaFooterBranding].
  const NovaFooterBranding({super.key, required this.config, this.theme});

  /// Footer configuration.
  final NovaFooterConfig config;

  /// Optional theme override.
  final ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    final t = theme ?? Theme.of(context);
    final height = config.height ?? NovaFooterWidgetUtils.kDefaultHeight;

    return Container(
      height: height,
      color: t.colorScheme.surface,
      padding: config.padding ??
          const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Logo
          if (config.logoWidget != null) ...[
            SizedBox(width: 32, height: 32, child: config.logoWidget!),
            const SizedBox(width: 10),
          ],
          // App name
          if (config.appName != null)
            Text(
              config.appName!,
              style: t.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: t.colorScheme.onSurface,
              ),
            ),
          // Separator + version
          if (config.appVersion != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '·',
                style: t.textTheme.bodySmall?.copyWith(
                  color: t.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Text(
              'v${config.appVersion}',
              style: t.textTheme.labelSmall?.copyWith(
                color: t.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const Spacer(),
          // Optional gradient accent line
          if (config.gradientColors != null && config.gradientColors!.length >= 2)
            Container(
              width: 24,
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: config.gradientColors!),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}
