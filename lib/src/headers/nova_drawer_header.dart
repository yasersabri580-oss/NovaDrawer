// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

/// The NovaDrawer header system.
///
/// Provides a modular, pluggable header framework with 10 built-in variants
/// and support for fully custom headers via [NovaHeaderConfig.customHeaderBuilder].
///
/// ## Built-in header variants:
/// - [ProfileHeaderClassic] — Standard cover + avatar + info layout
/// - [ProfileHeaderGlassmorphism] — Frosted glass effect
/// - [ProfileHeaderCompact] — Minimal single-row layout
/// - [ProfileHeaderHero] — Large cover, magazine-style
/// - [ProfileHeaderExpanded] — Full detail with expand/collapse
/// - [ProfileHeaderAnimatedGradient] — Cycling gradient background
/// - [ProfileHeaderAvatarStack] — Multiple account avatars
/// - [ProfileHeaderMultiAction] — Prominent action buttons
/// - [ProfileHeaderStatusAware] — Status-focused with breathing animation
/// - [ProfileHeaderCollapsible] — Toggle between expanded/collapsed
///
/// ## Usage:
/// ```dart
/// NovaDrawerHeader(
///   config: NovaHeaderConfig(
///     variant: HeaderVariant.classic,
///     profile: HeaderUserProfile(name: 'John Doe', email: 'john@example.com'),
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
/// 3. Use individual variant widgets directly (e.g., [ProfileHeaderClassic])
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
      return HeaderWidgetUtils.buildLoadingSkeleton(
        theme: t,
        height: config.headerHeight ?? HeaderWidgetUtils.kDefaultHeaderHeight,
      );
    }

    // Route to the appropriate variant.
    switch (config.variant) {
      case HeaderVariant.classic:
        return ProfileHeaderClassic(config: config, theme: theme);
      case HeaderVariant.glassmorphism:
        return ProfileHeaderGlassmorphism(config: config, theme: theme);
      case HeaderVariant.compact:
        return ProfileHeaderCompact(config: config, theme: theme);
      case HeaderVariant.hero:
        return ProfileHeaderHero(config: config, theme: theme);
      case HeaderVariant.expanded:
        return ProfileHeaderExpanded(config: config, theme: theme);
      case HeaderVariant.animatedGradient:
        return ProfileHeaderAnimatedGradient(config: config, theme: theme);
      case HeaderVariant.avatarStack:
        return ProfileHeaderAvatarStack(config: config, theme: theme);
      case HeaderVariant.multiAction:
        return ProfileHeaderMultiAction(config: config, theme: theme);
      case HeaderVariant.statusAware:
        return ProfileHeaderStatusAware(config: config, theme: theme);
      case HeaderVariant.collapsible:
        return ProfileHeaderCollapsible(config: config, theme: theme);
    }
  }
}
