// Copyright (c) 2026 NovaDrawer Contributors
// Licensed under the MIT License.

/// The NovaDrawer footer system.
///
/// Provides a modular, pluggable footer framework with 5 built-in variants
/// and support for fully custom footers via [NovaFooterConfig.customFooterBuilder].
///
/// ## Built-in footer variants:
/// - [NovaFooterMinimal] — version text + optional links
/// - [NovaFooterBranding] — logo + app name + version
/// - [NovaFooterActions] — row of icon/label action buttons
/// - [NovaFooterUserCard] — compact user avatar + name + settings/logout
/// - [NovaFooterUpgrade] — animated gradient upgrade CTA banner
///
/// ## Usage:
/// ```dart
/// NovaDrawerFooter(
///   config: NovaFooterConfig(
///     variant: NovaFooterVariant.userCard,
///     profile: NovaHeaderUserProfile(name: 'Alice', email: 'alice@acme.com'),
///     onSettingsTap: () => Navigator.pushNamed(context, '/settings'),
///     onLogoutTap: () => authService.logout(),
///   ),
/// )
/// ```
library;

import 'package:flutter/material.dart';

import '../models/footer_config.dart';
import 'footer_minimal.dart';
import 'footer_branding.dart';
import 'footer_actions.dart';
import 'footer_user_card.dart';
import 'footer_upgrade.dart';

/// A pluggable drawer footer that routes to the appropriate variant based on
/// [NovaFooterConfig.variant].
///
/// This is the primary entry point for the footer system. Developers can:
/// 1. Use a built-in variant by setting [config.variant].
/// 2. Provide a [config.customFooterBuilder] to fully replace the footer.
/// 3. Use individual variant widgets directly (e.g., [NovaFooterUpgrade]).
class NovaDrawerFooter extends StatelessWidget {
  /// Creates a [NovaDrawerFooter] that renders the appropriate variant.
  const NovaDrawerFooter({
    super.key,
    required this.config,
    this.theme,
  });

  /// Configuration for the footer content and behaviour.
  final NovaFooterConfig config;

  /// Optional theme override. If null, uses [Theme.of(context)].
  final ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    // Custom builder takes full precedence.
    if (config.customFooterBuilder != null) {
      return config.customFooterBuilder!(context, config);
    }

    switch (config.variant) {
      case NovaFooterVariant.minimal:
        return NovaFooterMinimal(config: config, theme: theme);
      case NovaFooterVariant.branding:
        return NovaFooterBranding(config: config, theme: theme);
      case NovaFooterVariant.actions:
        return NovaFooterActions(config: config, theme: theme);
      case NovaFooterVariant.userCard:
        return NovaFooterUserCard(config: config, theme: theme);
      case NovaFooterVariant.upgrade:
        return NovaFooterUpgrade(config: config, theme: theme);
    }
  }
}
