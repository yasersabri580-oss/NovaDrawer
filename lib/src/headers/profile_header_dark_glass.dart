// Copyright (c) 2026 NovaDrawer Contributors
// Licensed under the MIT License.

import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/header_config.dart';
import 'header_utils.dart';

/// Dark glassmorphism profile header with deep blur, a dark translucent
/// surface, and a neon/vivid accent glow around the avatar.
///
/// Works best on drawers with a dark or image-based background. The header
/// itself renders a blurred dark panel so it looks great over any content.
///
/// ```dart
/// NovaProfileHeaderDarkGlass(
///   config: NovaHeaderConfig(
///     variant: NovaHeaderVariant.darkGlass,
///     profile: myProfile,
///     gradientColors: [Color(0xFF6366F1), Color(0xFF06B6D4)], // glow colour
///   ),
/// )
/// ```
class NovaProfileHeaderDarkGlass extends StatelessWidget {
  /// Creates a dark-glass profile header.
  const NovaProfileHeaderDarkGlass({
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
    final height = config.headerHeight ?? NovaHeaderWidgetUtils.kDefaultHeaderHeight;
    final avatarRadius = config.avatarRadius ?? NovaHeaderWidgetUtils.kDefaultAvatarRadius;
    final profile = config.profile;

    if (config.isLoading) {
      return NovaHeaderWidgetUtils.buildLoadingSkeleton(theme: t, height: height);
    }
    if (config.customHeaderBuilder != null) {
      return config.customHeaderBuilder!(context, config);
    }

    final glowColors = config.gradientColors ??
        [const Color(0xFF6366F1), const Color(0xFF06B6D4)];

    return SizedBox(
      height: height,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(180),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withAlpha(25),
                  width: 0.5,
                ),
              ),
            ),
            child: Padding(
              padding: config.padding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Action bar (light icons on dark bg)
                  NovaHeaderWidgetUtils.buildActionBar(
                    context: context,
                    config: config,
                    theme: t,
                    iconColor: Colors.white.withAlpha(200),
                  ),
                  const Spacer(),
                  // Avatar with glow ring
                  Row(
                    children: [
                      _GlowAvatar(
                        profile: profile,
                        radius: avatarRadius,
                        glowColors: glowColors,
                        theme: t,
                        showStatus: config.showStatusIndicator,
                        onTap: config.onProfileTap,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NovaHeaderWidgetUtils.buildUserName(
                              name: profile?.name,
                              theme: t,
                              style: t.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                            NovaHeaderWidgetUtils.buildSubtitle(
                              text: profile?.effectiveSubtitle,
                              theme: t,
                              style: t.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withAlpha(160),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (config.showNotificationBadge &&
                          (profile?.notificationCount ?? 0) > 0)
                        NovaHeaderWidgetUtils.buildNotificationBadge(
                          count: profile!.notificationCount,
                          theme: t,
                        ),
                    ],
                  ),
                  if (config.bottomWidget != null) ...[
                    const SizedBox(height: 8),
                    config.bottomWidget!,
                  ],
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Avatar with a vivid gradient glow ring.
class _GlowAvatar extends StatelessWidget {
  const _GlowAvatar({
    required this.profile,
    required this.radius,
    required this.glowColors,
    required this.theme,
    required this.showStatus,
    this.onTap,
  });

  final NovaHeaderUserProfile? profile;
  final double radius;
  final List<Color> glowColors;
  final ThemeData theme;
  final bool showStatus;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const padding = 3.0;
    final totalRadius = radius + padding + 2;

    return Container(
      width: totalRadius * 2,
      height: totalRadius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(colors: [...glowColors, glowColors.first]),
        boxShadow: [
          BoxShadow(
            color: glowColors.first.withAlpha(120),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(padding),
      child: NovaHeaderWidgetUtils.buildAvatar(
        profile: profile,
        radius: radius,
        showStatus: showStatus,
        theme: theme,
        onTap: onTap,
      ),
    );
  }
}
