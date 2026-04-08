// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../models/header_config.dart';
import 'header_utils.dart';

/// Avatar stack header showing the primary user plus additional accounts.
///
/// The primary avatar is rendered large while smaller overlapping avatars for
/// each entry in [NovaHeaderConfig.accounts] appear in a horizontal stack.
/// A "+N" chip is shown when accounts exceed the visible limit.
/// Tapping the stack triggers [NovaHeaderConfig.onSwitchAccount].
///
/// ```dart
/// NovaProfileHeaderAvatarStack(
///   config: NovaHeaderConfig(
///     variant: NovaHeaderVariant.avatarStack,
///     profile: primaryProfile,
///     accounts: [account1, account2, account3],
///     onSwitchAccount: () => switchAccount(),
///   ),
/// )
/// ```
class NovaProfileHeaderAvatarStack extends StatefulWidget {
  /// Creates an avatar-stack profile header.
  const NovaProfileHeaderAvatarStack({
    super.key,
    required this.config,
    this.theme,
  });

  /// Header configuration.
  final NovaHeaderConfig config;

  /// Optional theme override. Falls back to [Theme.of].
  final ThemeData? theme;

  @override
  State<NovaProfileHeaderAvatarStack> createState() =>
      _NovaProfileHeaderAvatarStackState();
}

class _NovaProfileHeaderAvatarStackState extends State<NovaProfileHeaderAvatarStack>
    with SingleTickerProviderStateMixin {
  static const _kMaxVisible = 3;
  static const _kSmallRadius = 16.0;
  static const _kOverlap = 12.0;
  static const _animDuration = Duration(milliseconds: 300);

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  NovaHeaderConfig get _c => widget.config;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: _animDuration,
    )..forward();
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
    final height = _c.headerHeight ?? NovaHeaderWidgetUtils.kDefaultHeaderHeight;

    if (_c.isLoading) {
      return NovaHeaderWidgetUtils.buildLoadingSkeleton(
        theme: theme,
        height: height,
      );
    }
    if (_c.customHeaderBuilder != null) {
      return _c.customHeaderBuilder!(context, _c);
    }

    return AnimatedContainer(
      duration: _animDuration,
      curve: Curves.easeInOut,
      height: height,
      color: theme.colorScheme.surface,
      padding: _c.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Primary avatar
            NovaHeaderWidgetUtils.buildAvatar(
              profile: _c.profile,
              radius:
                  _c.avatarRadius ?? NovaHeaderWidgetUtils.kDefaultAvatarRadius,
              showStatus: _c.showStatusIndicator,
              theme: theme,
              onTap: _c.onProfileTap,
            ),
            const SizedBox(height: 8),
            NovaHeaderWidgetUtils.buildUserName(
              name: _c.profile?.name,
              theme: theme,
            ),
            NovaHeaderWidgetUtils.buildSubtitle(
              text: _c.profile?.effectiveSubtitle,
              theme: theme,
            ),
            if (_c.accounts.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildAvatarStack(theme),
            ],
            if (_c.showNotificationBadge &&
                (_c.profile?.notificationCount ?? 0) > 0) ...[
              const SizedBox(height: 6),
              NovaHeaderWidgetUtils.buildNotificationBadge(
                count: _c.profile!.notificationCount,
                theme: theme,
              ),
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

  /// Builds the overlapping row of secondary account avatars.
  Widget _buildAvatarStack(ThemeData theme) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final accounts = _c.accounts;
    final visible = accounts.take(_kMaxVisible).toList();
    final extra = accounts.length - _kMaxVisible;

    final stackWidth =
        (_kSmallRadius * 2) + (visible.length - 1) * (_kSmallRadius * 2 - _kOverlap)
        + (extra > 0 ? (_kSmallRadius * 2 - _kOverlap + _kSmallRadius * 2) : 0);

    return GestureDetector(
      onTap: _c.onSwitchAccount,
      child: SizedBox(
        height: _kSmallRadius * 2 + 4,
        width: stackWidth,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (var i = 0; i < visible.length; i++)
              Positioned(
                left: isRtl ? null : i * (_kSmallRadius * 2 - _kOverlap),
                right: isRtl ? i * (_kSmallRadius * 2 - _kOverlap) : null,
                top: 2,
                child: _buildSmallAvatar(visible[i], theme),
              ),
            if (extra > 0)
              Positioned(
                left: isRtl
                    ? null
                    : visible.length * (_kSmallRadius * 2 - _kOverlap),
                right: isRtl
                    ? visible.length * (_kSmallRadius * 2 - _kOverlap)
                    : null,
                top: 2,
                child: _buildOverflowChip(extra, theme),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallAvatar(NovaHeaderUserProfile acct, ThemeData theme) {
    return CircleAvatar(
      radius: _kSmallRadius,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      backgroundImage:
          acct.avatarUrl != null ? NetworkImage(acct.avatarUrl!) : null,
      child: acct.avatarUrl == null
          ? Text(
              (acct.name)[0].toUpperCase(),
              style: TextStyle(
                fontSize: _kSmallRadius * 0.8,
                color: theme.colorScheme.onSurface,
              ),
            )
          : null,
    );
  }

  Widget _buildOverflowChip(int count, ThemeData theme) {
    return CircleAvatar(
      radius: _kSmallRadius,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Text(
        '+$count',
        style: TextStyle(
          fontSize: _kSmallRadius * 0.75,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
