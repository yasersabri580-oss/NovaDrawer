// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

/// The NovaDrawer header system.
///
/// Provides a modular, pluggable header framework with 10 built-in variants
/// and support for fully custom headers via [NovaHeaderConfig.customHeaderBuilder].
///
/// ## Built-in header variants:
/// - [NovaProfileHeaderClassic] — Standard cover + avatar + info layout
/// - [NovaProfileHeaderGlassmorphism] — Frosted glass effect
/// - [NovaProfileHeaderCompact] — Minimal single-row layout
/// - [NovaProfileHeaderHero] — Large cover, magazine-style
/// - [NovaProfileHeaderExpanded] — Full detail with expand/collapse
/// - [NovaProfileHeaderAnimatedGradient] — Cycling gradient background
/// - [NovaProfileHeaderAvatarStack] — Multiple account avatars
/// - [NovaProfileHeaderMultiAction] — Prominent action buttons
/// - [NovaProfileHeaderStatusAware] — Status-focused with breathing animation
/// - [NovaProfileHeaderCollapsible] — Toggle between expanded/collapsed
///
/// ## Usage:
/// ```dart
/// NovaDrawerHeader(
///   config: NovaHeaderConfig(
///     variant: NovaHeaderVariant.classic,
///     profile: NovaHeaderUserProfile(name: 'John Doe', email: 'john@example.com'),
///   ),
/// )
/// ```
library nova_drawer_headers;

import 'package:flutter/material.dart';

import '../models/header_config.dart';
import 'header_utils.dart';
import 'profile_header_classic.dart';
import 'profile_header_glassmorphism.dart';
import 'profile_header_compact.dart';
import 'profile_header_hero.dart';
import 'profile_header_expanded.dart';
import 'profile_header_animated_gradient.dart';
import 'profile_header_avatar_stack.dart';
import 'profile_header_multi_action.dart';
import 'profile_header_status_aware.dart';
import 'profile_header_collapsible.dart';

/// A pluggable drawer header that routes to the appropriate variant
/// based on [NovaHeaderConfig.variant].
///
/// This is the primary entry point for the header system. Developers can:
/// 1. Use a built-in variant by setting [config.variant]
/// 2. Provide a [config.customHeaderBuilder] to fully replace the header
/// 3. Use individual variant widgets directly (e.g., [NovaProfileHeaderClassic])
///
/// The header automatically handles:
/// - Loading skeleton states
/// - Custom header builder delegation
/// - Theme resolution
/// - RTL support
/// - Smooth animated transitions
class NovaDrawerHeader extends StatelessWidget {
  /// Creates a [NovaDrawerHeader] that renders the appropriate variant.
  const NovaDrawerHeader({
    super.key,
    required this.config,
    this.theme,
  });

  /// Configuration for the header content and behavior.
  final NovaHeaderConfig config;

  /// Optional theme override. If null, uses [Theme.of(context)].
  final ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    // Custom builder takes full precedence.
    if (config.customHeaderBuilder != null) {
      return config.customHeaderBuilder!(context, config);
    }

    // Loading state.
    if (config.isLoading) {
      final t = theme ?? Theme.of(context);
      return NovaHeaderWidgetUtils.buildLoadingSkeleton(
        theme: t,
        height: config.headerHeight ?? NovaHeaderWidgetUtils.kDefaultHeaderHeight,
      );
    }

    // Route to the appropriate variant.
    switch (config.variant) {
      case NovaHeaderVariant.classic:
        return NovaProfileHeaderClassic(config: config, theme: theme);
      case NovaHeaderVariant.glassmorphism:
        return NovaProfileHeaderGlassmorphism(config: config, theme: theme);
      case NovaHeaderVariant.compact:
        return NovaProfileHeaderCompact(config: config, theme: theme);
      case NovaHeaderVariant.hero:
        return NovaProfileHeaderHero(config: config, theme: theme);
      case NovaHeaderVariant.expanded:
        return NovaProfileHeaderExpanded(config: config, theme: theme);
      case NovaHeaderVariant.animatedGradient:
        return NovaProfileHeaderAnimatedGradient(config: config, theme: theme);
      case NovaHeaderVariant.avatarStack:
        return NovaProfileHeaderAvatarStack(config: config, theme: theme);
      case NovaHeaderVariant.multiAction:
        return NovaProfileHeaderMultiAction(config: config, theme: theme);
      case NovaHeaderVariant.statusAware:
        return NovaProfileHeaderStatusAware(config: config, theme: theme);
      case NovaHeaderVariant.collapsible:
        return NovaProfileHeaderCollapsible(config: config, theme: theme);
    }
  }
}
