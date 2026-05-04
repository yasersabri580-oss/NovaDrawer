// Copyright (c) 2026 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/material.dart';

import '../models/header_config.dart';

/// Shared utility helpers used by all footer variant widgets.
class NovaFooterWidgetUtils {
  NovaFooterWidgetUtils._();

  /// Default footer height.
  static const double kDefaultHeight = 64.0;

  /// Builds a compact circular avatar for footer user cards.
  static Widget buildAvatar({
    required NovaHeaderUserProfile? profile,
    required double radius,
    required ThemeData theme,
  }) {
    if (profile?.avatarWidget != null) {
      return SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: ClipOval(child: profile!.avatarWidget!),
      );
    }
    final initials = _initials(profile?.name);
    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.primaryContainer,
      foregroundColor: theme.colorScheme.onPrimaryContainer,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: radius * 0.75,
          fontWeight: FontWeight.w600,
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

  /// Default gradient used by the upgrade footer when none is provided.
  static const List<Color> kDefaultUpgradeGradient = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
  ];
}
