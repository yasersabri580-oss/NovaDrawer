// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../models/header_config.dart';
import 'header_utils.dart';

/// Animated gradient header that cycles background colors over time.
///
/// The gradient shifts its [LinearGradient] alignment using an
/// [AnimationController] with repeat, producing a smooth colour-cycling
/// backdrop. Avatar and user information overlay the gradient.
///
/// Supply custom colours via [NovaHeaderConfig.gradientColors] or fall back
/// to sensible Material defaults derived from the current theme.
///
/// ```dart
/// ProfileHeaderAnimatedGradient(
///   config: NovaHeaderConfig(
///     variant: HeaderVariant.animatedGradient,
///     profile: myProfile,
///     gradientColors: [Colors.indigo, Colors.cyan, Colors.teal],
///   ),
/// )
/// ```
class ProfileHeaderAnimatedGradient extends StatefulWidget {
  /// Creates an animated gradient profile header.
  const ProfileHeaderAnimatedGradient({
    super.key,
    required this.config,
    this.theme,
  });

  /// Header configuration.
  final NovaHeaderConfig config;

  /// Optional theme override. Falls back to [Theme.of].
  final ThemeData? theme;

  @override
  State<ProfileHeaderAnimatedGradient> createState() =>
      _ProfileHeaderAnimatedGradientState();
}

class _ProfileHeaderAnimatedGradientState
    extends State<ProfileHeaderAnimatedGradient>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  NovaHeaderConfig get _c => widget.config;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? Theme.of(context);
    final height = _c.headerHeight ?? HeaderWidgetUtils.kDefaultHeaderHeight;

    if (_c.isLoading) {
      return HeaderWidgetUtils.buildLoadingSkeleton(
        theme: theme,
        height: height,
      );
    }
    if (_c.customHeaderBuilder != null) {
      return _c.customHeaderBuilder!(context, _c);
    }

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final t = _ctrl.value;
        final colors = _c.gradientColors ??
            [
              theme.colorScheme.primary,
              theme.colorScheme.tertiary,
              theme.colorScheme.secondary,
            ];

        return Container(
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-(1 - t * 2), -1),
              end: Alignment(1, 1 - t * 2),
              colors: colors,
            ),
          ),
          child: child,
        );
      },
      child: _buildContent(theme, height),
    );
  }

  Widget _buildContent(ThemeData theme, double height) {
    final profile = _c.profile;
    final radius = _c.avatarRadius ?? HeaderWidgetUtils.kDefaultAvatarRadius;
    final textColor = Colors.white;

    return Stack(
      children: [
        // Action bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: HeaderWidgetUtils.buildActionBar(
            context: context,
            config: _c,
            theme: theme,
            iconColor: textColor,
          ),
        ),
        // Centred avatar + info
        Center(
          child: Padding(
            padding: _c.padding ??
                const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HeaderWidgetUtils.buildAvatar(
                  profile: profile,
                  radius: radius,
                  showStatus: _c.showStatusIndicator,
                  theme: theme,
                  onTap: _c.onProfileTap,
                ),
                const SizedBox(height: 10),
                HeaderWidgetUtils.buildUserName(
                  name: profile?.name,
                  theme: theme,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                HeaderWidgetUtils.buildSubtitle(
                  text: profile?.effectiveSubtitle,
                  theme: theme,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: textColor.withValues(alpha: 0.85),
                  ),
                ),
                if (_c.showNotificationBadge &&
                    (profile?.notificationCount ?? 0) > 0) ...[
                  const SizedBox(height: 6),
                  HeaderWidgetUtils.buildNotificationBadge(
                    count: profile!.notificationCount,
                    theme: theme,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (_c.bottomWidget != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 4,
            child: _c.bottomWidget!,
          ),
      ],
    );
  }
}
