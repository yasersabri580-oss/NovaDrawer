// Copyright (c) 2026 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../models/footer_config.dart';
import 'footer_utils.dart';

/// Compact user-card footer showing the signed-in user's avatar, name,
/// email, and a settings icon button.
///
/// Layout:
/// ```
/// ┌─────────────────────────────────────┐
/// │  [AV]  Alice Johnson                │
/// │        alice@acme.com        [⚙]   │
/// └─────────────────────────────────────┘
/// ```
class NovaFooterUserCard extends StatelessWidget {
  /// Creates a [NovaFooterUserCard].
  const NovaFooterUserCard({super.key, required this.config, this.theme});

  /// Footer configuration.
  final NovaFooterConfig config;

  /// Optional theme override.
  final ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    final t = theme ?? Theme.of(context);
    final height = config.height ?? 72.0;
    final profile = config.profile;

    return Container(
      height: height,
      color: t.colorScheme.surfaceContainerLow,
      padding: config.padding ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Avatar
          NovaFooterWidgetUtils.buildAvatar(
            profile: profile,
            radius: 20,
            theme: t,
          ),
          const SizedBox(width: 12),
          // Name + email
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile?.name ?? '',
                  style: t.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: t.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (profile?.effectiveSubtitle != null)
                  Text(
                    profile!.effectiveSubtitle!,
                    style: t.textTheme.labelSmall?.copyWith(
                      color: t.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          // Settings + logout icons
          if (config.onSettingsTap != null)
            IconButton(
              icon: Icon(Icons.settings_outlined,
                  size: 20, color: t.colorScheme.onSurfaceVariant),
              onPressed: config.onSettingsTap,
              tooltip: 'Settings',
              padding: EdgeInsets.zero,
              constraints:
                  const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          if (config.onLogoutTap != null)
            IconButton(
              icon: Icon(Icons.logout,
                  size: 20, color: t.colorScheme.error),
              onPressed: config.onLogoutTap,
              tooltip: 'Sign out',
              padding: EdgeInsets.zero,
              constraints:
                  const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
        ],
      ),
    );
  }
}
