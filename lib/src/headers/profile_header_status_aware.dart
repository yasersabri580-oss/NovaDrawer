// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../models/header_config.dart';
import 'header_utils.dart';

/// Status-aware header that prominently displays the user's presence state.
///
/// A large coloured status indicator and label sit beside the avatar. When the
/// status is [UserStatus.online] a breathing (pulsing) animation draws
/// attention. The status colour subtly tints the header background.
///
/// ```dart
/// ProfileHeaderStatusAware(
///   config: NovaHeaderConfig(
///     variant: HeaderVariant.statusAware,
///     profile: HeaderUserProfile(
///       name: 'Jane',
///       status: UserStatus.online,
///     ),
///     showStatusIndicator: true,
///   ),
/// )
/// ```
class ProfileHeaderStatusAware extends StatefulWidget {
  /// Creates a status-aware profile header.
  const ProfileHeaderStatusAware({
    super.key,
    required this.config,
    this.theme,
  });

  /// Header configuration.
  final NovaHeaderConfig config;

  /// Optional theme override. Falls back to [Theme.of].
  final ThemeData? theme;

  @override
  State<ProfileHeaderStatusAware> createState() =>
      _ProfileHeaderStatusAwareState();
}

class _ProfileHeaderStatusAwareState extends State<ProfileHeaderStatusAware>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  NovaHeaderConfig get _c => widget.config;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _syncPulse();
  }

  @override
  void didUpdateWidget(covariant ProfileHeaderStatusAware old) {
    super.didUpdateWidget(old);
    if (old.config.profile?.status != _c.profile?.status) _syncPulse();
  }

  void _syncPulse() {
    if (_c.profile?.status == UserStatus.online) {
      _pulseCtrl.repeat(reverse: true);
    } else {
      _pulseCtrl.stop();
      _pulseCtrl.value = 1.0;
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
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

    final status = _c.profile?.status ?? UserStatus.unknown;
    final statusClr = HeaderWidgetUtils.statusColor(status);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            statusClr.withValues(alpha: 0.08),
            theme.colorScheme.surface,
          ],
        ),
      ),
      padding: _c.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              HeaderWidgetUtils.buildAvatar(
                profile: _c.profile,
                radius: _c.avatarRadius ??
                    HeaderWidgetUtils.kDefaultAvatarRadius,
                showStatus: false,
                theme: theme,
                onTap: _c.onProfileTap,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWidgetUtils.buildUserName(
                      name: _c.profile?.name,
                      theme: theme,
                    ),
                    HeaderWidgetUtils.buildSubtitle(
                      text: _c.profile?.effectiveSubtitle,
                      theme: theme,
                    ),
                  ],
                ),
              ),
              if (_c.showNotificationBadge &&
                  (_c.profile?.notificationCount ?? 0) > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: HeaderWidgetUtils.buildNotificationBadge(
                    count: _c.profile!.notificationCount,
                    theme: theme,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Prominent status row
          _buildStatusRow(theme, status, statusClr),
          if (_c.bottomWidget != null) ...[
            const SizedBox(height: 4),
            _c.bottomWidget!,
          ],
        ],
      ),
    );
  }

  /// Large status indicator dot with label and breathing animation.
  Widget _buildStatusRow(ThemeData theme, UserStatus status, Color color) {
    final label = _statusLabel(status);

    return Row(
      children: [
        FadeTransition(
          opacity: _pulseAnim,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Returns a human-readable label for [status].
  static String _statusLabel(UserStatus status) {
    switch (status) {
      case UserStatus.online:
        return 'Online';
      case UserStatus.offline:
        return 'Offline';
      case UserStatus.busy:
        return 'Busy';
      case UserStatus.away:
        return 'Away';
      case UserStatus.unknown:
        return 'Unknown';
    }
  }
}
