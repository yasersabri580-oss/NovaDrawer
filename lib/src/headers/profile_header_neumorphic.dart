// Copyright (c) 2026 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../models/header_config.dart';
import 'header_utils.dart';

/// Neumorphic (soft-UI) profile header with embossed shadows and a
/// raised avatar against a neutral surface.
///
/// The header applies two-tone drop shadows (light above-left, dark
/// below-right) to simulate a physically raised panel — the defining
/// trait of neumorphic design.
///
/// ```dart
/// NovaProfileHeaderNeumorphic(
///   config: NovaHeaderConfig(
///     variant: NovaHeaderVariant.neumorphic,
///     profile: NovaHeaderUserProfile(name: 'Alice', email: 'alice@acme.com'),
///   ),
/// )
/// ```
class NovaProfileHeaderNeumorphic extends StatelessWidget {
  /// Creates a neumorphic profile header.
  const NovaProfileHeaderNeumorphic({
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

    if (config.isLoading) {
      return NovaHeaderWidgetUtils.buildLoadingSkeleton(theme: t, height: height);
    }
    if (config.customHeaderBuilder != null) {
      return config.customHeaderBuilder!(context, config);
    }

    // Use a neutral base colour that works for both light and dark themes.
    final base = t.colorScheme.surfaceContainerHigh;
    final isDark = t.brightness == Brightness.dark;

    // Shadow colours for the embossed effect.
    final shadowLight = isDark
        ? Colors.white.withAlpha(20)
        : Colors.white.withAlpha(230);
    final shadowDark = isDark
        ? Colors.black.withAlpha(80)
        : Colors.black.withAlpha(40);

    final profile = config.profile;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: base,
        boxShadow: [
          BoxShadow(
            color: shadowLight,
            offset: const Offset(-4, -4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: shadowDark,
            offset: const Offset(4, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: config.padding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Action bar
            NovaHeaderWidgetUtils.buildActionBar(
              context: context,
              config: config,
              theme: t,
            ),
            const Spacer(),
            // Embossed avatar
            _NeumorphicAvatar(
              profile: profile,
              radius: avatarRadius,
              base: base,
              shadowLight: shadowLight,
              shadowDark: shadowDark,
              onTap: config.onProfileTap,
              showStatus: config.showStatusIndicator,
              theme: t,
            ),
            const SizedBox(height: 10),
            // Name
            NovaHeaderWidgetUtils.buildUserName(
              name: profile?.name,
              theme: t,
              style: t.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: t.colorScheme.onSurface,
                letterSpacing: 0.3,
              ),
            ),
            NovaHeaderWidgetUtils.buildSubtitle(
              text: profile?.effectiveSubtitle,
              theme: t,
            ),
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

/// A circular avatar wrapped in neumorphic embossed shadows.
class _NeumorphicAvatar extends StatelessWidget {
  const _NeumorphicAvatar({
    required this.profile,
    required this.radius,
    required this.base,
    required this.shadowLight,
    required this.shadowDark,
    required this.theme,
    required this.showStatus,
    this.onTap,
  });

  final NovaHeaderUserProfile? profile;
  final double radius;
  final Color base;
  final Color shadowLight;
  final Color shadowDark;
  final ThemeData theme;
  final bool showStatus;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final inner = Container(
      width: radius * 2 + 10,
      height: radius * 2 + 10,
      decoration: BoxDecoration(
        color: base,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: shadowLight,
            offset: const Offset(-3, -3),
            blurRadius: 8,
          ),
          BoxShadow(
            color: shadowDark,
            offset: const Offset(3, 3),
            blurRadius: 8,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: NovaHeaderWidgetUtils.buildAvatar(
        profile: profile,
        radius: radius,
        showStatus: showStatus,
        theme: theme,
        onTap: onTap,
      ),
    );
    return inner;
  }
}
