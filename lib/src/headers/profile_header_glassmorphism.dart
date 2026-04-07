// Copyright (c) 2024 NovaDrawer Contributors. MIT License.

import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/header_config.dart';
import 'header_utils.dart';

/// Glassmorphism-style profile header with a frosted-glass effect.
///
/// Uses [BackdropFilter] with [ImageFilter.blur] for a translucent, frosted
/// panel. Avatar and user info float on the glass surface.
class NovaProfileHeaderGlassmorphism extends StatefulWidget {
  /// Creates a glassmorphism profile header.
  const NovaProfileHeaderGlassmorphism({super.key, required this.config, this.theme});

  /// Header configuration.
  final NovaHeaderConfig config;

  /// Optional theme override. Falls back to [Theme.of].
  final ThemeData? theme;

  @override
  State<NovaProfileHeaderGlassmorphism> createState() =>
      _NovaProfileHeaderGlassmorphismState();
}

class _NovaProfileHeaderGlassmorphismState
    extends State<NovaProfileHeaderGlassmorphism> {
  static const _animDuration = Duration(milliseconds: 300);
  static const _blurSigma = 12.0;

  NovaHeaderConfig get _config => widget.config;

  double get _effectiveHeight {
    if (_config.isCollapsed) {
      return _config.collapsedHeaderHeight ??
          NovaHeaderWidgetUtils.kDefaultCollapsedHeight;
    }
    return _config.headerHeight ?? NovaHeaderWidgetUtils.kDefaultHeaderHeight;
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? Theme.of(context);

    if (_config.isLoading) {
      return NovaHeaderWidgetUtils.buildLoadingSkeleton(
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
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background layer
          if (_config.backgroundWidget != null)
            _config.backgroundWidget!
          else
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _config.gradientColors ??
                      [
                        theme.colorScheme.primary.withAlpha(100),
                        theme.colorScheme.secondary.withAlpha(80),
                      ],
                ),
              ),
            ),

          // Frosted glass panel
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _blurSigma,
                sigmaY: _blurSigma,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withAlpha(50),
                  border: Border.all(
                    color: theme.colorScheme.outline.withAlpha(40),
                  ),
                ),
              ),
            ),
          ),

          // Content
          _config.isCollapsed
              ? _buildCollapsed(theme)
              : _buildExpanded(theme),
        ],
      ),
    );
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
        ],
      ),
    );
  }

  Widget _buildExpanded(ThemeData theme) {
    final profile = _config.profile;
    final avatarRadius =
        _config.avatarRadius ?? NovaHeaderWidgetUtils.kDefaultAvatarRadius;

    return Padding(
      padding: _config.padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Action bar
          NovaHeaderWidgetUtils.buildActionBar(
            context: context,
            config: _config,
            theme: theme,
          ),
          const Spacer(),
          // Avatar + info
          Row(
            children: [
              NovaHeaderWidgetUtils.buildAvatar(
                profile: profile,
                radius: avatarRadius,
                showStatus: _config.showStatusIndicator,
                theme: theme,
                onTap: _config.onProfileTap,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 8),
            _config.bottomWidget!,
          ],
        ],
      ),
    );
  }
}
