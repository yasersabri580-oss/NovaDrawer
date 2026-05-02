// Copyright (c) 2026 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../models/header_config.dart';
import 'header_utils.dart';

/// Clean, card-style profile header with rounded corners, a subtle surface
/// elevation, and a minimal information layout.
///
/// The entire header is rendered inside a [Material] card container, giving
/// it a clearly defined boundary against the drawer background.
///
/// ```dart
/// NovaProfileHeaderMinimalCard(
///   config: NovaHeaderConfig(
///     variant: NovaHeaderVariant.minimalCard,
///     profile: NovaHeaderUserProfile(name: 'Alice', email: 'alice@acme.com'),
///   ),
/// )
/// ```
class NovaProfileHeaderMinimalCard extends StatelessWidget {
  /// Creates a minimal-card profile header.
  const NovaProfileHeaderMinimalCard({
    super.key,
    required this.config,
    this.theme,
  });

  /// Header configuration.
  final NovaHeaderConfig config;

  /// Optional theme override. Falls back to [Theme.of].
  final ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    final t = theme ?? Theme.of(context);
    final height = config.headerHeight ?? 100.0;
    final avatarRadius = config.avatarRadius ?? NovaHeaderWidgetUtils.kDefaultCollapsedAvatarRadius;
    final profile = config.profile;

    if (config.isLoading) {
      return NovaHeaderWidgetUtils.buildLoadingSkeleton(theme: t, height: height);
    }
    if (config.customHeaderBuilder != null) {
      return config.customHeaderBuilder!(context, config);
    }

    return Padding(
      padding: config.padding ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Material(
        elevation: 2,
        shadowColor: t.colorScheme.shadow.withAlpha(60),
        borderRadius: BorderRadius.circular(16),
        color: t.colorScheme.surfaceContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              // Avatar
              NovaHeaderWidgetUtils.buildAvatar(
                profile: profile,
                radius: avatarRadius,
                showStatus: config.showStatusIndicator,
                theme: t,
                onTap: config.onProfileTap,
              ),
              const SizedBox(width: 12),
              // Name + subtitle
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NovaHeaderWidgetUtils.buildUserName(
                      name: profile?.name,
                      theme: t,
                    ),
                    NovaHeaderWidgetUtils.buildSubtitle(
                      text: profile?.effectiveSubtitle,
                      theme: t,
                    ),
                    if (config.bottomWidget != null) ...[
                      const SizedBox(height: 4),
                      config.bottomWidget!,
                    ],
                  ],
                ),
              ),
              // Trailing actions
              NovaHeaderWidgetUtils.buildActionBar(
                context: context,
                config: config.copyWith(showCloseButton: false),
                theme: t,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
