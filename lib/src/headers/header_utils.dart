// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../controllers/drawer_controller.dart';
import '../models/header_config.dart';

/// Shared utility widgets and helpers used across all header variants.
///
/// Provides common building blocks: avatar, status indicator, action bar,
/// notification badge, loading skeleton, and user info text.
class NovaHeaderWidgetUtils {
  NovaHeaderWidgetUtils._();

  /// Default expanded header height.
  static const double kDefaultHeaderHeight = 200.0;

  /// Default collapsed header height.
  static const double kDefaultCollapsedHeight = 72.0;

  /// Default avatar radius.
  static const double kDefaultAvatarRadius = 32.0;

  /// Default collapsed avatar radius.
  static const double kDefaultCollapsedAvatarRadius = 20.0;

  /// Returns the color for a [NovaUserStatus].
  static Color statusColor(NovaUserStatus status) {
    switch (status) {
      case NovaUserStatus.online:
        return const Color(0xFF22C55E);
      case NovaUserStatus.offline:
        return const Color(0xFF9CA3AF);
      case NovaUserStatus.busy:
        return const Color(0xFFEF4444);
      case NovaUserStatus.away:
        return const Color(0xFFF59E0B);
      case NovaUserStatus.unknown:
        return const Color(0xFF6B7280);
    }
  }

  /// Builds the avatar widget with optional status indicator.
  static Widget buildAvatar({
    required NovaHeaderUserProfile? profile,
    required double radius,
    required bool showStatus,
    required ThemeData theme,
    VoidCallback? onTap,
  }) {
    Widget avatar;
    if (profile?.avatarWidget != null) {
      avatar = SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: ClipOval(child: profile!.avatarWidget!),
      );
    } else {
      avatar = CircleAvatar(
        radius: radius,
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        child: Text(
          _initials(profile?.name),
          style: TextStyle(
            fontSize: radius * 0.7,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    Widget result = avatar;

    if (showStatus && profile != null && profile.status != NovaUserStatus.unknown) {
      result = Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: _StatusDot(status: profile.status, size: radius * 0.4),
          ),
        ],
      );
    }

    if (onTap != null) {
      result = GestureDetector(onTap: onTap, child: result);
    }

    return result;
  }

  /// Builds the action bar with close, pin, and custom action buttons.
  static Widget buildActionBar({
    required BuildContext context,
    required NovaHeaderConfig config,
    required ThemeData theme,
    Color? iconColor,
  }) {
    final color = iconColor ?? theme.colorScheme.onSurface;
    final List<Widget> leading = [];
    final List<Widget> trailing = [];

    if (config.showCloseButton) {
      leading.add(_HeaderCloseButton(color: color));
    }

    if (config.showPinButton) {
      trailing.add(_HeaderPinButton(color: color));
    }

    for (final action in config.actions) {
      if (!action.isEnabled) continue;
      trailing.add(
        action.customWidget ??
            _ActionIconButton(
              icon: action.icon,
              tooltip: action.tooltip ?? action.label,
              color:
                  action.isDestructive ? const Color(0xFFEF4444) : color,
              badge: action.badge,
              onTap: action.onTap,
            ),
      );
    }

    if (leading.isEmpty && trailing.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          ...leading,
          const Spacer(),
          ...trailing,
        ],
      ),
    );
  }

  /// Builds user name text.
  static Widget buildUserName({
    required String? name,
    required ThemeData theme,
    TextStyle? style,
    int maxLines = 1,
  }) {
    if (name == null || name.isEmpty) return const SizedBox.shrink();
    return Text(
      name,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: style ??
          theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  /// Builds subtitle/email/role text.
  static Widget buildSubtitle({
    required String? text,
    required ThemeData theme,
    TextStyle? style,
    int maxLines = 1,
  }) {
    if (text == null || text.isEmpty) return const SizedBox.shrink();
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: style ??
          theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
    );
  }

  /// Builds a notification badge.
  static Widget buildNotificationBadge({
    required int count,
    required ThemeData theme,
    double size = 20.0,
  }) {
    if (count <= 0) return const SizedBox.shrink();
    final display = count > 99 ? '99+' : count.toString();
    return Container(
      constraints: BoxConstraints(minWidth: size, minHeight: size),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.error,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      alignment: Alignment.center,
      child: Text(
        display,
        style: TextStyle(
          color: theme.colorScheme.onError,
          fontSize: size * 0.55,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Builds a loading skeleton placeholder.
  static Widget buildLoadingSkeleton({
    required ThemeData theme,
    double height = 200.0,
  }) {
    final baseColor = theme.colorScheme.surfaceContainerHighest;
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: baseColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 120,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: 80,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _initials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }
}

// ── Header Close Button ──────────────────────────────────────────────────────

/// Close button for the header action bar.
///
/// Reads the [NovaDrawerControllerProvider] from context and calls
/// [NovaDrawerController.close] when tapped.
class _HeaderCloseButton extends StatelessWidget {
  const _HeaderCloseButton({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    // Use getInheritedWidgetOfExactType (no dependency) because the close
    // button appearance never changes — only its onTap callback needs the
    // controller reference, which is looked up at tap time.
    final provider = context
        .getInheritedWidgetOfExactType<NovaDrawerControllerProvider>();
    final controller = provider?.notifier;

    return _ActionIconButton(
      icon: Icons.close,
      tooltip: 'Close drawer',
      color: color,
      onTap: () {
        if (controller != null) {
          controller.close();
        } else {
          Navigator.of(context).maybePop();
        }
      },
    );
  }
}

// ── Header Pin Button ────────────────────────────────────────────────────────

/// Pin/unpin button for the header action bar.
///
/// Reads the [NovaDrawerControllerProvider] from context so it rebuilds
/// automatically when the pin state changes.
class _HeaderPinButton extends StatelessWidget {
  const _HeaderPinButton({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<NovaDrawerControllerProvider>();
    final controller = provider?.notifier;
    final isPinned = controller?.isPinned ?? false;

    return _ActionIconButton(
      icon: isPinned ? Icons.push_pin : Icons.push_pin_outlined,
      tooltip: isPinned ? 'Unpin drawer' : 'Pin drawer',
      color: color,
      onTap: controller != null ? () => controller.togglePin() : null,
    );
  }
}

/// A small action icon button used in header action bars.
class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.icon,
    this.tooltip,
    this.color,
    this.badge,
    this.onTap,
  });

  final IconData icon;
  final String? tooltip;
  final Color? color;
  final int? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget button = IconButton(
      icon: Icon(icon, color: color, size: 20),
      tooltip: tooltip,
      onPressed: onTap,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      padding: const EdgeInsets.all(6),
      visualDensity: VisualDensity.compact,
    );

    if (badge != null && badge! > 0) {
      button = Stack(
        clipBehavior: Clip.none,
        children: [
          button,
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                badge! > 9 ? '9+' : badge.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onError,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return button;
  }
}

/// Animated status indicator dot.
class _StatusDot extends StatefulWidget {
  const _StatusDot({required this.status, this.size = 12.0});

  final NovaUserStatus status;
  final double size;

  @override
  State<_StatusDot> createState() => _StatusDotState();
}

class _StatusDotState extends State<_StatusDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.status == NovaUserStatus.online) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_StatusDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status == NovaUserStatus.online) {
      if (!_controller.isAnimating) _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: NovaHeaderWidgetUtils.statusColor(widget.status),
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.surface,
            width: 2,
          ),
        ),
      ),
    );
  }
}
