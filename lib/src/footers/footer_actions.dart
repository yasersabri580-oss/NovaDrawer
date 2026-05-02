// Copyright (c) 2026 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../models/footer_config.dart';
import 'footer_utils.dart';

/// Action buttons footer — displays a centred row of labelled icon buttons.
///
/// Each [NovaFooterAction] in [NovaFooterConfig.actions] is rendered as a
/// column of `Icon + label`. Destructive actions are tinted with the error
/// colour.
///
/// Layout:
/// ```
/// ┌──────────────────────────────────────┐
/// │   🔔 Alerts  ⚙ Settings  ↩ Logout   │
/// └──────────────────────────────────────┘
/// ```
class NovaFooterActions extends StatelessWidget {
  /// Creates a [NovaFooterActions].
  const NovaFooterActions({super.key, required this.config, this.theme});

  /// Footer configuration.
  final NovaFooterConfig config;

  /// Optional theme override.
  final ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    final t = theme ?? Theme.of(context);
    final height = config.height ?? NovaFooterWidgetUtils.kDefaultHeight;
    final actions = config.actions;

    if (actions.isEmpty) return const SizedBox.shrink();

    return Container(
      height: height,
      color: t.colorScheme.surface,
      padding: config.padding ??
          const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final action in actions)
            Tooltip(
              message: action.tooltip ?? action.label ?? '',
              child: InkWell(
                onTap: action.onTap,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ActionIcon(action: action, theme: t),
                      if (action.label != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          action.label!,
                          style: t.textTheme.labelSmall?.copyWith(
                            color: action.isDestructive
                                ? t.colorScheme.error
                                : t.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.action, required this.theme});

  final NovaFooterAction action;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final color = action.isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.onSurfaceVariant;

    if (action.badge != null && action.badge! > 0) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(action.icon, color: color, size: 22),
          PositionedDirectional(
            end: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(2),
              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                borderRadius: BorderRadius.circular(7),
              ),
              alignment: Alignment.center,
              child: Text(
                action.badge! > 9 ? '9+' : action.badge.toString(),
                style: TextStyle(
                  color: theme.colorScheme.onError,
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Icon(action.icon, color: color, size: 22);
  }
}
