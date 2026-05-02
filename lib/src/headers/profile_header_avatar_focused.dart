// Copyright (c) 2026 NovaDrawer Contributors
// Licensed under the MIT License.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/header_config.dart';
import 'header_utils.dart';

/// Avatar-focused profile header with a large centred avatar surrounded by an
/// animated gradient ring, and the user's name and subtitle below.
///
/// The gradient ring continuously rotates, drawing the eye to the avatar.
/// This variant is ideal when the user's identity is the most important element
/// of the drawer (e.g., a personal journaling or social app).
///
/// ```dart
/// NovaProfileHeaderAvatarFocused(
///   config: NovaHeaderConfig(
///     variant: NovaHeaderVariant.avatarFocused,
///     profile: myProfile,
///     gradientColors: [Color(0xFFF59E0B), Color(0xFFEF4444), Color(0xFF8B5CF6)],
///   ),
/// )
/// ```
class NovaProfileHeaderAvatarFocused extends StatefulWidget {
  /// Creates an avatar-focused profile header.
  const NovaProfileHeaderAvatarFocused({
    super.key,
    required this.config,
    this.theme,
  });

  /// Header configuration.
  final NovaHeaderConfig config;

  /// Optional theme override. Falls back to [Theme.of].
  final ThemeData? theme;

  @override
  State<NovaProfileHeaderAvatarFocused> createState() =>
      _NovaProfileHeaderAvatarFocusedState();
}

class _NovaProfileHeaderAvatarFocusedState
    extends State<NovaProfileHeaderAvatarFocused>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotCtrl;

  @override
  void initState() {
    super.initState();
    _rotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _rotCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme ?? Theme.of(context);
    final config = widget.config;
    final height = config.headerHeight ?? NovaHeaderWidgetUtils.kDefaultHeaderHeight;
    final avatarRadius = config.avatarRadius ?? NovaHeaderWidgetUtils.kDefaultAvatarRadius;

    if (config.isLoading) {
      return NovaHeaderWidgetUtils.buildLoadingSkeleton(theme: t, height: height);
    }
    if (config.customHeaderBuilder != null) {
      return config.customHeaderBuilder!(context, config);
    }

    final profile = config.profile;
    final colors = config.gradientColors ??
        [
          t.colorScheme.primary,
          t.colorScheme.tertiary,
          t.colorScheme.secondary,
        ];

    return Container(
      height: height,
      color: t.colorScheme.surface,
      child: Padding(
        padding: config.padding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // Action bar
            NovaHeaderWidgetUtils.buildActionBar(
              context: context,
              config: config,
              theme: t,
            ),
            const Spacer(),
            // Rotating gradient ring + avatar
            GestureDetector(
              onTap: config.onProfileTap,
              child: AnimatedBuilder(
                animation: _rotCtrl,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotCtrl.value * 2 * math.pi,
                    child: child,
                  );
                },
                child: _GradientRing(
                  radius: avatarRadius,
                  colors: colors,
                  // Inner avatar is counter-rotated to stay upright.
                  child: AnimatedBuilder(
                    animation: _rotCtrl,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: -_rotCtrl.value * 2 * math.pi,
                        child: child,
                      );
                    },
                    child: NovaHeaderWidgetUtils.buildAvatar(
                      profile: profile,
                      radius: avatarRadius,
                      showStatus: config.showStatusIndicator,
                      theme: t,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Name
            NovaHeaderWidgetUtils.buildUserName(
              name: profile?.name,
              theme: t,
              style: t.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            NovaHeaderWidgetUtils.buildSubtitle(
              text: profile?.effectiveSubtitle,
              theme: t,
            ),
            if (config.showNotificationBadge &&
                (profile?.notificationCount ?? 0) > 0) ...[
              const SizedBox(height: 4),
              NovaHeaderWidgetUtils.buildNotificationBadge(
                count: profile!.notificationCount,
                theme: t,
              ),
            ],
            if (config.bottomWidget != null) ...[
              const SizedBox(height: 6),
              config.bottomWidget!,
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// A circular gradient ring that wraps a child.
class _GradientRing extends StatelessWidget {
  const _GradientRing({
    required this.radius,
    required this.colors,
    required this.child,
  });

  final double radius;
  final List<Color> colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const ringWidth = 3.5;
    final outerRadius = radius + ringWidth + 2;

    return Container(
      width: outerRadius * 2,
      height: outerRadius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(colors: [...colors, colors.first]),
      ),
      padding: const EdgeInsets.all(ringWidth),
      child: ClipOval(child: child),
    );
  }
}
