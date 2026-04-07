// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../models/header_config.dart';
import 'header_utils.dart';

/// Compact, single-row profile header for space-constrained layouts.
///
/// Renders the avatar on the leading side, name and subtitle in the centre,
/// and action buttons on the trailing side. No cover image is shown.
///
/// The layout automatically respects RTL via [Directionality.of].
///
/// ```dart
/// ProfileHeaderCompact(
///   config: NovaHeaderConfig(
///     variant: HeaderVariant.compact,
///     profile: myProfile,
///   ),
/// )
/// ```
class ProfileHeaderCompact extends StatefulWidget {
  /// Creates a compact profile header.
  const ProfileHeaderCompact({
    super.key,
    required this.config,
    this.theme,
  });

  /// Header configuration.
  final NovaHeaderConfig config;

  /// Optional theme override. Falls back to [Theme.of].
  final ThemeData? theme;

  @override
  State<ProfileHeaderCompact> createState() => _ProfileHeaderCompactState();
}

class _ProfileHeaderCompactState extends State<ProfileHeaderCompact>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  NovaHeaderConfig get _config => widget.config;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
  }

  @override
  void didUpdateWidget(covariant ProfileHeaderCompact old) {
    super.didUpdateWidget(old);
    if (old.config.profile?.name != _config.profile?.name) {
      _fadeCtrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? Theme.of(context);
    final height = _config.collapsedHeaderHeight ??
        HeaderWidgetUtils.kDefaultCollapsedHeight;

    if (_config.isLoading) {
      return HeaderWidgetUtils.buildLoadingSkeleton(
        theme: theme,
        height: height,
      );
    }

    if (_config.customHeaderBuilder != null) {
      return _config.customHeaderBuilder!(context, _config);
    }

    final profile = _config.profile;
    final radius = _config.avatarRadius ??
        HeaderWidgetUtils.kDefaultCollapsedAvatarRadius;

    return Container(
      height: height,
      color: theme.colorScheme.surface,
      padding: _config.padding ??
          const EdgeInsets.symmetric(horizontal: 12),
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Row(
          children: [
            // Leading widget or avatar
            _config.leadingWidget ??
                HeaderWidgetUtils.buildAvatar(
                  profile: profile,
                  radius: radius,
                  showStatus: _config.showStatusIndicator,
                  theme: theme,
                  onTap: _config.onProfileTap,
                ),
            const SizedBox(width: 12),
            // Name & subtitle
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidgetUtils.buildUserName(
                    name: profile?.name,
                    theme: theme,
                  ),
                  HeaderWidgetUtils.buildSubtitle(
                    text: profile?.effectiveSubtitle,
                    theme: theme,
                  ),
                ],
              ),
            ),
            // Notification badge
            if (_config.showNotificationBadge &&
                (profile?.notificationCount ?? 0) > 0) ...[
              HeaderWidgetUtils.buildNotificationBadge(
                count: profile!.notificationCount,
                theme: theme,
              ),
              const SizedBox(width: 4),
            ],
            // Trailing widget or action bar
            _config.trailingWidget ??
                _buildCompactActions(theme),
          ],
        ),
      ),
    );
  }

  /// Builds a minimal set of trailing action icons.
  Widget _buildCompactActions(ThemeData theme) {
    return HeaderWidgetUtils.buildActionBar(
      context: context,
      config: _config,
      theme: theme,
    );
  }
}
