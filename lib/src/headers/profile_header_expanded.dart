// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../models/header_config.dart';
import 'header_utils.dart';

/// Expanded profile header showing maximum detail.
///
/// Expanded state renders cover, large avatar, name, role, subtitle, action
/// chips, and a bottom widget slot. Collapsed state shows a compact row.
/// Uses [AnimatedContainer] and [AnimatedCrossFade] for smooth transitions.
class NovaProfileHeaderExpanded extends StatefulWidget {
  /// Creates an expanded profile header.
  const NovaProfileHeaderExpanded({super.key, required this.config, this.theme});

  /// Header configuration.
  final NovaHeaderConfig config;

  /// Optional theme override. Falls back to [Theme.of].
  final ThemeData? theme;

  @override
  State<NovaProfileHeaderExpanded> createState() => _NovaProfileHeaderExpandedState();
}

class _NovaProfileHeaderExpandedState extends State<NovaProfileHeaderExpanded> {
  static const _kDuration = Duration(milliseconds: 350);
  static const _kExpandedH = 280.0;

  NovaHeaderConfig get _c => widget.config;
  double get _expH => _c.headerHeight ?? _kExpandedH;
  double get _colH =>
      _c.collapsedHeaderHeight ?? NovaHeaderWidgetUtils.kDefaultCollapsedHeight;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? Theme.of(context);
    final collapsed = _c.isCollapsed;
    final h = collapsed ? _colH : _expH;

    if (_c.isLoading) {
      return NovaHeaderWidgetUtils.buildLoadingSkeleton(theme: theme, height: h);
    }
    if (_c.customHeaderBuilder != null) {
      return _c.customHeaderBuilder!(context, _c);
    }

    return AnimatedContainer(
      duration: _kDuration,
      curve: Curves.easeInOut,
      height: h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: theme.colorScheme.surface),
      child: AnimatedCrossFade(
        duration: _kDuration,
        sizeCurve: Curves.easeInOut,
        crossFadeState:
            collapsed ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        firstChild: _buildExpanded(theme),
        secondChild: _buildCollapsed(theme),
      ),
    );
  }

  Widget _buildCollapsed(ThemeData theme) {
    final p = _c.profile;
    final r = _c.collapsedAvatarRadius ??
        NovaHeaderWidgetUtils.kDefaultCollapsedAvatarRadius;
    return SizedBox(
      height: _colH,
      child: Padding(
        padding: _c.padding ?? const EdgeInsets.symmetric(horizontal: 12),
        child: Row(children: [
          NovaHeaderWidgetUtils.buildAvatar(
              profile: p, radius: r, showStatus: _c.showStatusIndicator,
              theme: theme, onTap: _c.onProfileTap),
          const SizedBox(width: 12),
          Expanded(child: NovaHeaderWidgetUtils.buildUserName(
              name: p?.name, theme: theme)),
          if (_c.showNotificationBadge && (p?.notificationCount ?? 0) > 0)
            NovaHeaderWidgetUtils.buildNotificationBadge(
                count: p!.notificationCount, theme: theme),
        ]),
      ),
    );
  }

  Widget _buildExpanded(ThemeData theme) {
    final p = _c.profile;
    final avatarR = _c.avatarRadius ?? NovaHeaderWidgetUtils.kDefaultAvatarRadius;
    final coverH = _c.coverHeight ?? _expH * 0.35;
    return SizedBox(
      height: _expH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCover(theme, coverH),
          Expanded(
            child: Padding(
              padding: _c.padding ?? const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(children: [
                    NovaHeaderWidgetUtils.buildAvatar(
                        profile: p, radius: avatarR,
                        showStatus: _c.showStatusIndicator, theme: theme,
                        onTap: _c.onProfileTap),
                    const SizedBox(width: 14),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NovaHeaderWidgetUtils.buildUserName(name: p?.name,
                            theme: theme, style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        if (p?.role != null)
                          NovaHeaderWidgetUtils.buildSubtitle(
                              text: p!.role, theme: theme),
                        NovaHeaderWidgetUtils.buildSubtitle(
                            text: p?.effectiveSubtitle, theme: theme),
                      ],
                    )),
                    if (_c.showNotificationBadge &&
                        (p?.notificationCount ?? 0) > 0)
                      NovaHeaderWidgetUtils.buildNotificationBadge(
                          count: p!.notificationCount, theme: theme),
                  ]),
                  const SizedBox(height: 8),
                  _buildActionRow(theme),
                  if (_c.bottomWidget != null) ...[
                    const SizedBox(height: 4), _c.bottomWidget!,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCover(ThemeData theme, double h) {
    return SizedBox(
      height: h,
      child: Stack(fit: StackFit.expand, children: [
        if (_c.backgroundWidget != null) _c.backgroundWidget!
        else Container(color: theme.colorScheme.primaryContainer,
            child: _c.profile?.coverWidget),
        Positioned(top: 0, left: 0, right: 0,
          child: NovaHeaderWidgetUtils.buildActionBar(context: context,
              config: _c, theme: theme,
              iconColor: theme.colorScheme.onPrimaryContainer)),
      ]),
    );
  }

  Widget _buildActionRow(ThemeData theme) {
    final chips = <Widget>[
      if (_c.showEditProfileButton && _c.onEditProfile != null)
        ActionChip(avatar: const Icon(Icons.edit_outlined, size: 16),
            label: const Text('Edit', style: TextStyle(fontSize: 12)),
            onPressed: _c.onEditProfile,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
      if (_c.onSwitchAccount != null)
        ActionChip(avatar: const Icon(Icons.swap_horiz, size: 16),
            label: const Text('Switch', style: TextStyle(fontSize: 12)),
            onPressed: _c.onSwitchAccount,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
    ];
    if (chips.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 8, runSpacing: 4, children: chips);
  }
}
