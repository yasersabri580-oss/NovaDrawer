// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../models/header_config.dart';
import 'header_utils.dart';

/// Hero-style profile header with a dramatic, magazine-like layout.
///
/// Large cover (~60% of height), avatar overlapping the cover bottom edge,
/// and bold name text. Uses [AnimatedContainer] for smooth transitions.
class ProfileHeaderHero extends StatefulWidget {
  /// Creates a hero profile header.
  const ProfileHeaderHero({
    super.key,
    required this.config,
    this.theme,
  });

  /// Header configuration.
  final NovaHeaderConfig config;

  /// Optional theme override. Falls back to [Theme.of].
  final ThemeData? theme;

  @override
  State<ProfileHeaderHero> createState() => _ProfileHeaderHeroState();
}

class _ProfileHeaderHeroState extends State<ProfileHeaderHero> {
  static const _animDuration = Duration(milliseconds: 350);
  static const _defaultExpandedHeight = 260.0;

  NovaHeaderConfig get _config => widget.config;

  double get _effectiveHeight {
    if (_config.isCollapsed) {
      return _config.collapsedHeaderHeight ??
          HeaderWidgetUtils.kDefaultCollapsedHeight;
    }
    return _config.headerHeight ?? _defaultExpandedHeight;
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? Theme.of(context);

    if (_config.isLoading) {
      return HeaderWidgetUtils.buildLoadingSkeleton(
        theme: theme,
        height: _effectiveHeight,
      );
    }

    if (_config.customHeaderBuilder != null) {
      return _config.customHeaderBuilder!(context, _config);
    }

    return AnimatedContainer(
      duration: _animDuration,
      curve: Curves.easeInOut,
      height: _effectiveHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: theme.colorScheme.surface),
      child:
          _config.isCollapsed ? _buildCollapsed(theme) : _buildExpanded(theme),
    );
  }

  Widget _buildCollapsed(ThemeData theme) {
    final profile = _config.profile;
    final radius = _config.collapsedAvatarRadius ??
        HeaderWidgetUtils.kDefaultCollapsedAvatarRadius;

    return Padding(
      padding:
          _config.padding ?? const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          HeaderWidgetUtils.buildAvatar(
            profile: profile,
            radius: radius,
            showStatus: _config.showStatusIndicator,
            theme: theme,
            onTap: _config.onProfileTap,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: HeaderWidgetUtils.buildUserName(
              name: profile?.name,
              theme: theme,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpanded(ThemeData theme) {
    final profile = _config.profile;
    final avatarRadius =
        _config.avatarRadius ?? HeaderWidgetUtils.kDefaultAvatarRadius;
    // Cover takes ~60% of total height.
    final coverH = _config.coverHeight ?? _effectiveHeight * 0.6;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cover image
        _buildCover(theme, coverH),

        // Action bar at the top
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: HeaderWidgetUtils.buildActionBar(
            context: context,
            config: _config,
            theme: theme,
            iconColor: theme.colorScheme.onPrimaryContainer,
          ),
        ),

        // Avatar overlapping bottom edge of cover
        Positioned(
          top: coverH - avatarRadius,
          left: (_config.padding as EdgeInsets?)?.left ?? 16,
          child: HeaderWidgetUtils.buildAvatar(
            profile: profile,
            radius: avatarRadius,
            showStatus: _config.showStatusIndicator,
            theme: theme,
            onTap: _config.onProfileTap,
          ),
        ),

        // Name + subtitle below cover
        Positioned(
          left: 0,
          right: 0,
          top: coverH + avatarRadius + 4,
          bottom: 0,
          child: Padding(
            padding: _config.padding ??
                const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidgetUtils.buildUserName(
                  name: profile?.name,
                  theme: theme,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                HeaderWidgetUtils.buildSubtitle(
                  text: profile?.effectiveSubtitle,
                  theme: theme,
                ),
                if (_config.bottomWidget != null) ...[
                  const SizedBox(height: 4),
                  _config.bottomWidget!,
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCover(ThemeData theme, double coverH) {
    if (_config.backgroundWidget != null) {
      return SizedBox(
        height: coverH,
        width: double.infinity,
        child: _config.backgroundWidget,
      );
    }

    final coverWidget = _config.profile?.coverWidget;

    return Container(
      height: coverH,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        gradient: _config.gradientColors != null
            ? LinearGradient(colors: _config.gradientColors!)
            : null,
      ),
      child: coverWidget != null
          ? FittedBox(fit: BoxFit.cover, child: coverWidget)
          : null,
    );
  }
}
