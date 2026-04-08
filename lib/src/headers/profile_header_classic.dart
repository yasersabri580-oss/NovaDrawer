// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../models/header_config.dart';
import 'header_utils.dart';

/// Classic profile header with cover area, overlapping avatar, and user info.
///
/// Cover image at top, avatar at cover/content boundary, action bar on top.
/// Height animates smoothly between expanded and collapsed via [AnimatedContainer].
class NovaProfileHeaderClassic extends StatefulWidget {
  /// Creates a classic profile header.
  const NovaProfileHeaderClassic({super.key, required this.config, this.theme});

  /// Header configuration.
  final NovaHeaderConfig config;

  /// Optional theme override. Falls back to [Theme.of].
  final ThemeData? theme;

  @override
  State<NovaProfileHeaderClassic> createState() => _NovaProfileHeaderClassicState();
}

class _NovaProfileHeaderClassicState extends State<NovaProfileHeaderClassic> {
  static const _animDuration = Duration(milliseconds: 300);

  NovaHeaderConfig get _config => widget.config;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? Theme.of(context);

    // Loading state
    if (_config.isLoading) {
      return NovaHeaderWidgetUtils.buildLoadingSkeleton(
        theme: theme,
        height: _effectiveHeight,
      );
    }

    // Custom builder override
    if (_config.customHeaderBuilder != null) {
      return _config.customHeaderBuilder!(context, _config);
    }

    final collapsed = _config.isCollapsed;

    return AnimatedContainer(
      duration: _animDuration,
      curve: Curves.easeInOut,
      height: _effectiveHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      child: collapsed ? _buildCollapsed(theme) : _buildExpanded(theme),
    );
  }

  double get _effectiveHeight {
    if (_config.isCollapsed) {
      return _config.collapsedHeaderHeight ??
          NovaHeaderWidgetUtils.kDefaultCollapsedHeight;
    }
    return _config.headerHeight ?? NovaHeaderWidgetUtils.kDefaultHeaderHeight;
  }

  Widget _buildCollapsed(ThemeData theme) {
    final profile = _config.profile;
    final radius = _config.collapsedAvatarRadius ??
        NovaHeaderWidgetUtils.kDefaultCollapsedAvatarRadius;

    return Padding(
      padding: _config.padding ??
          const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          NovaHeaderWidgetUtils.buildAvatar(
            profile: profile,
            radius: radius,
            showStatus: _config.showStatusIndicator,
            theme: theme,
            onTap: _config.onProfileTap,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: NovaHeaderWidgetUtils.buildUserName(
              name: profile?.name,
              theme: theme,
            ),
          ),
          if (_config.showNotificationBadge &&
              (profile?.notificationCount ?? 0) > 0)
            NovaHeaderWidgetUtils.buildNotificationBadge(
              count: profile!.notificationCount,
              theme: theme,
            ),
        ],
      ),
    );
  }

  Widget _buildExpanded(ThemeData theme) {
    final profile = _config.profile;
    final avatarRadius =
        _config.avatarRadius ?? NovaHeaderWidgetUtils.kDefaultAvatarRadius;
    final coverH = _config.coverHeight ?? _effectiveHeight * 0.45;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cover area
        if (_config.backgroundWidget != null)
          Positioned.fill(child: _config.backgroundWidget!)
        else
          Container(
            height: coverH,
            width: double.infinity,
            color: theme.colorScheme.primaryContainer,
            child: profile?.coverWidget,
          ),

        // Action bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: NovaHeaderWidgetUtils.buildActionBar(
            context: context,
            config: _config,
            theme: theme,
            iconColor: theme.colorScheme.onPrimaryContainer,
          ),
        ),

        // Avatar + info
        Positioned(
          left: 0,
          right: 0,
          top: coverH - avatarRadius,
          bottom: 0,
          child: Padding(
            padding: _config.padding ??
                const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _config.onProfileTap,
                  child: NovaHeaderWidgetUtils.buildAvatar(
                    profile: profile,
                    radius: avatarRadius,
                    showStatus: _config.showStatusIndicator,
                    theme: theme,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NovaHeaderWidgetUtils.buildUserName(
                            name: profile?.name,
                            theme: theme,
                          ),
                          NovaHeaderWidgetUtils.buildSubtitle(
                            text: profile?.effectiveSubtitle,
                            theme: theme,
                          ),
                        ],
                      ),
                    ),
                    if (_config.showNotificationBadge &&
                        (profile?.notificationCount ?? 0) > 0)
                      NovaHeaderWidgetUtils.buildNotificationBadge(
                        count: profile!.notificationCount,
                        theme: theme,
                      ),
                  ],
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
}
