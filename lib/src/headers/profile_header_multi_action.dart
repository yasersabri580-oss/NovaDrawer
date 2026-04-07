// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../models/header_config.dart';
import 'header_utils.dart';

/// Multi-action header with a prominent row of labelled icon buttons.
///
/// User info is displayed in a clean card-style layout with each action from
/// [NovaHeaderConfig.actions] rendered as a labelled icon button inside a
/// [Wrap]. Actions may carry badge counts.
///
/// ```dart
/// ProfileHeaderMultiAction(
///   config: NovaHeaderConfig(
///     variant: HeaderVariant.multiAction,
///     profile: myProfile,
///     actions: [
///       HeaderAction(id: 'settings', icon: Icons.settings, label: 'Settings'),
///       HeaderAction(id: 'share', icon: Icons.share, label: 'Share'),
///     ],
///   ),
/// )
/// ```
class ProfileHeaderMultiAction extends StatefulWidget {
  /// Creates a multi-action profile header.
  const ProfileHeaderMultiAction({
    super.key,
    required this.config,
    this.theme,
  });

  /// Header configuration.
  final NovaHeaderConfig config;

  /// Optional theme override. Falls back to [Theme.of].
  final ThemeData? theme;

  @override
  State<ProfileHeaderMultiAction> createState() =>
      _ProfileHeaderMultiActionState();
}

class _ProfileHeaderMultiActionState extends State<ProfileHeaderMultiAction>
    with SingleTickerProviderStateMixin {
  static const _kDuration = Duration(milliseconds: 300);

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  NovaHeaderConfig get _c => widget.config;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: _kDuration)
      ..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
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

    final profile = _c.profile;
    final radius = _c.avatarRadius ?? HeaderWidgetUtils.kDefaultAvatarRadius;

    return AnimatedContainer(
      duration: _kDuration,
      curve: Curves.easeInOut,
      height: height,
      decoration: BoxDecoration(color: theme.colorScheme.surface),
      padding: _c.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // User info row
            Row(
              children: [
                HeaderWidgetUtils.buildAvatar(
                  profile: profile,
                  radius: radius,
                  showStatus: _c.showStatusIndicator,
                  theme: theme,
                  onTap: _c.onProfileTap,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
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
                if (_c.showNotificationBadge &&
                    (profile?.notificationCount ?? 0) > 0)
                  HeaderWidgetUtils.buildNotificationBadge(
                    count: profile!.notificationCount,
                    theme: theme,
                  ),
              ],
            ),
            if (_c.actions.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildActionGrid(theme),
            ],
            if (_c.bottomWidget != null) ...[
              const SizedBox(height: 4),
              _c.bottomWidget!,
            ],
          ],
        ),
      ),
    );
  }

  /// Renders each [HeaderAction] as a labelled icon button in a [Wrap].
  Widget _buildActionGrid(ThemeData theme) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: _c.actions.map((action) {
        final enabled = action.isEnabled;
        final color = action.isDestructive
            ? theme.colorScheme.error
            : enabled
                ? theme.colorScheme.onSurface
                : theme.disabledColor;

        return Tooltip(
          message: action.tooltip ?? action.label ?? '',
          child: InkWell(
            onTap: enabled ? action.onTap : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionIcon(action, color, theme),
                  if (action.label != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      action.label!,
                      style: theme.textTheme.labelSmall?.copyWith(color: color),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Builds an action icon with an optional badge overlay.
  Widget _buildActionIcon(
    HeaderAction action,
    Color color,
    ThemeData theme,
  ) {
    final icon = Icon(action.icon, size: 18, color: color);

    if (action.badge == null || action.badge == 0) return icon;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,
        Positioned(
          top: -4,
          right: -6,
          child: HeaderWidgetUtils.buildNotificationBadge(
            count: action.badge!,
            theme: theme,
            size: 14,
          ),
        ),
      ],
    );
  }
}
