// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../models/header_config.dart';
import 'header_utils.dart';

/// Collapsible header with two distinct animated states.
///
/// **Expanded** – full cover area, large avatar, user info, and action bar.
/// **Collapsed** – a compact single-row layout.
///
/// The transition is driven by [AnimatedContainer] and [AnimatedCrossFade]
/// with a [SingleTickerProviderStateMixin] for smooth collapse animation.
/// A toggle button appears when [NovaHeaderConfig.enableCollapseExpand] is
/// `true`.
///
/// ```dart
/// NovaProfileHeaderCollapsible(
///   config: NovaHeaderConfig(
///     variant: NovaHeaderVariant.collapsible,
///     profile: myProfile,
///     enableCollapseExpand: true,
///   ),
/// )
/// ```
class NovaProfileHeaderCollapsible extends StatefulWidget {
  /// Creates a collapsible profile header.
  const NovaProfileHeaderCollapsible({
    super.key,
    required this.config,
    this.theme,
  });

  /// Header configuration.
  final NovaHeaderConfig config;

  /// Optional theme override. Falls back to [Theme.of].
  final ThemeData? theme;

  @override
  State<NovaProfileHeaderCollapsible> createState() =>
      _NovaProfileHeaderCollapsibleState();
}

class _NovaProfileHeaderCollapsibleState extends State<NovaProfileHeaderCollapsible>
    with SingleTickerProviderStateMixin {
  static const _kDuration = Duration(milliseconds: 350);

  late final AnimationController _ctrl;
  late final Animation<double> _iconTurn;
  late bool _collapsed;

  NovaHeaderConfig get _c => widget.config;

  @override
  void initState() {
    super.initState();
    _collapsed = _c.isCollapsed;
    _ctrl = AnimationController(vsync: this, duration: _kDuration);
    _iconTurn = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    if (_collapsed) _ctrl.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant NovaProfileHeaderCollapsible old) {
    super.didUpdateWidget(old);
    if (old.config.isCollapsed != _c.isCollapsed) {
      _collapsed = _c.isCollapsed;
      _collapsed ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _collapsed = !_collapsed;
      _collapsed ? _ctrl.forward() : _ctrl.reverse();
    });
  }

  double get _expH => _c.headerHeight ?? NovaHeaderWidgetUtils.kDefaultHeaderHeight;
  double get _colH =>
      _c.collapsedHeaderHeight ?? NovaHeaderWidgetUtils.kDefaultCollapsedHeight;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? Theme.of(context);
    final height = _collapsed ? _colH : _expH;

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
      duration: _kDuration,
      curve: Curves.easeInOut,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: theme.colorScheme.surface),
      child: AnimatedCrossFade(
        duration: _kDuration,
        sizeCurve: Curves.easeInOut,
        crossFadeState:
            _collapsed ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        firstChild: _buildExpanded(theme),
        secondChild: _buildCollapsed(theme),
      ),
    );
  }

  // ── Expanded ──────────────────────────────────────────────────────

  Widget _buildExpanded(ThemeData theme) {
    final profile = _c.profile;
    final radius = _c.avatarRadius ?? NovaHeaderWidgetUtils.kDefaultAvatarRadius;
    final coverH = _c.coverHeight ?? _expH * 0.4;

    return SizedBox(
      height: _expH,
      child: Stack(
        children: [
          // Cover
          if (_c.backgroundWidget != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: coverH,
              child: _c.backgroundWidget!,
            )
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
              config: _c,
              theme: theme,
              iconColor: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          // Avatar + info
          Positioned(
            left: 0,
            right: 0,
            top: coverH - radius,
            bottom: 0,
            child: Padding(
              padding: _c.padding ??
                  const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      NovaHeaderWidgetUtils.buildAvatar(
                        profile: profile,
                        radius: radius,
                        showStatus: _c.showStatusIndicator,
                        theme: theme,
                        onTap: _c.onProfileTap,
                      ),
                      const Spacer(),
                      if (_c.enableCollapseExpand) _buildToggle(theme),
                    ],
                  ),
                  const SizedBox(height: 4),
                  NovaHeaderWidgetUtils.buildUserName(
                      name: profile?.name, theme: theme),
                  NovaHeaderWidgetUtils.buildSubtitle(
                      text: profile?.effectiveSubtitle, theme: theme),
                  if (_c.bottomWidget != null) ...[
                    const SizedBox(height: 4),
                    _c.bottomWidget!,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Collapsed ─────────────────────────────────────────────────────

  Widget _buildCollapsed(ThemeData theme) {
    final profile = _c.profile;
    final radius = _c.collapsedAvatarRadius ??
        NovaHeaderWidgetUtils.kDefaultCollapsedAvatarRadius;

    return SizedBox(
      height: _colH,
      child: Padding(
        padding:
            _c.padding ?? const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            NovaHeaderWidgetUtils.buildAvatar(
              profile: profile,
              radius: radius,
              showStatus: _c.showStatusIndicator,
              theme: theme,
              onTap: _c.onProfileTap,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: NovaHeaderWidgetUtils.buildUserName(
                  name: profile?.name, theme: theme),
            ),
            if (_c.showNotificationBadge &&
                (profile?.notificationCount ?? 0) > 0)
              NovaHeaderWidgetUtils.buildNotificationBadge(
                count: profile!.notificationCount,
                theme: theme,
              ),
            if (_c.enableCollapseExpand) _buildToggle(theme),
          ],
        ),
      ),
    );
  }

  // ── Toggle button ─────────────────────────────────────────────────

  Widget _buildToggle(ThemeData theme) {
    return RotationTransition(
      turns: _iconTurn,
      child: IconButton(
        icon: const Icon(Icons.expand_more),
        iconSize: 22,
        tooltip: _collapsed ? 'Expand' : 'Collapse',
        color: theme.colorScheme.onSurface,
        onPressed: _toggle,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
