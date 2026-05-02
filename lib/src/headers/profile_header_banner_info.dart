// Copyright (c) 2026 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../models/header_config.dart';
import 'header_utils.dart';

/// Information banner header that displays the user's avatar and name in a
/// compact row, with a strip of coloured stat chips below.
///
/// The chips are built from [NovaHeaderConfig.metadata] entries whose keys
/// start with `'stat_'`. Each value is displayed as `key: value` inside a
/// tinted container. This gives product teams a zero-code way to surface
/// KPIs (posts, followers, streak, etc.) directly in the drawer header.
///
/// ```dart
/// NovaProfileHeaderBannerInfo(
///   config: NovaHeaderConfig(
///     variant: NovaHeaderVariant.bannerInfo,
///     profile: NovaHeaderUserProfile(
///       name: 'Alice',
///       email: 'alice@acme.com',
///       metadata: {
///         'stat_Posts': '142',
///         'stat_Followers': '3.2 K',
///         'stat_Streak': '🔥 7',
///       },
///     ),
///   ),
/// )
/// ```
class NovaProfileHeaderBannerInfo extends StatelessWidget {
  /// Creates a banner-info profile header.
  const NovaProfileHeaderBannerInfo({
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
    final avatarRadius = config.avatarRadius ?? NovaHeaderWidgetUtils.kDefaultCollapsedAvatarRadius;
    final profile = config.profile;

    if (config.isLoading) {
      return NovaHeaderWidgetUtils.buildLoadingSkeleton(theme: t, height: height);
    }
    if (config.customHeaderBuilder != null) {
      return config.customHeaderBuilder!(context, config);
    }

    // Extract stat entries from metadata (keys starting with 'stat_').
    final stats = <MapEntry<String, String>>[];
    if (profile?.metadata != null) {
      for (final e in profile!.metadata.entries) {
        if (e.key.startsWith('stat_')) {
          stats.add(MapEntry(e.key.replaceFirst('stat_', ''), e.value.toString()));
        }
      }
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: config.gradientColors ??
              [
                t.colorScheme.primaryContainer,
                t.colorScheme.secondaryContainer,
              ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: config.padding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Action bar
            NovaHeaderWidgetUtils.buildActionBar(
              context: context,
              config: config,
              theme: t,
              iconColor: t.colorScheme.onPrimaryContainer,
            ),
            const Spacer(),
            // Avatar + info row
            Row(
              children: [
                NovaHeaderWidgetUtils.buildAvatar(
                  profile: profile,
                  radius: avatarRadius,
                  showStatus: config.showStatusIndicator,
                  theme: t,
                  onTap: config.onProfileTap,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NovaHeaderWidgetUtils.buildUserName(
                        name: profile?.name,
                        theme: t,
                        style: t.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: t.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      NovaHeaderWidgetUtils.buildSubtitle(
                        text: profile?.effectiveSubtitle,
                        theme: t,
                        style: t.textTheme.bodySmall?.copyWith(
                          color: t.colorScheme.onPrimaryContainer.withAlpha(180),
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
            // Stat chips row
            if (stats.isNotEmpty) ...[
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < stats.length; i++) ...[
                      if (i > 0) const SizedBox(width: 6),
                      _StatChip(
                        label: stats[i].key,
                        value: stats[i].value,
                        theme: t,
                      ),
                    ],
                  ],
                ),
              ),
            ],
            if (config.bottomWidget != null) ...[
              const SizedBox(height: 6),
              config.bottomWidget!,
            ],
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.theme,
  });

  final String label;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.onPrimaryContainer.withAlpha(50),
          width: 0.5,
        ),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: value,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: '  $label',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withAlpha(180),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
