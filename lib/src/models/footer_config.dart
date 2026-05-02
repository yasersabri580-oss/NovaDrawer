// Copyright (c) 2026 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/widgets.dart';

import 'header_config.dart';

/// Enum representing the visual variant of a drawer footer.
enum NovaFooterVariant {
  /// Minimal footer with version text and optional links.
  minimal,

  /// Branding footer with logo, app name, and version.
  branding,

  /// Action buttons footer — a row of icon buttons (settings, logout, etc.).
  actions,

  /// Compact user card with avatar, name, and a settings shortcut.
  userCard,

  /// Upgrade / premium CTA banner with gradient background.
  upgrade,
}

/// Configuration for a single footer action button.
class NovaFooterAction {
  /// Creates a [NovaFooterAction].
  const NovaFooterAction({
    required this.id,
    required this.icon,
    this.label,
    this.tooltip,
    this.onTap,
    this.isDestructive = false,
    this.badge,
  });

  /// Unique identifier.
  final String id;

  /// Icon to display.
  final IconData icon;

  /// Optional text label shown below the icon (actions variant).
  final String? label;

  /// Tooltip for accessibility.
  final String? tooltip;

  /// Callback when tapped.
  final VoidCallback? onTap;

  /// Whether this is a destructive action (e.g., logout).
  final bool isDestructive;

  /// Optional badge count.
  final int? badge;
}

/// Master configuration for the NovaDrawer footer system.
///
/// Pass this to [NovaDrawerFooter] or use individual footer variant widgets
/// directly. All fields are optional; each variant uses only the fields
/// relevant to it.
///
/// ### Quick examples
///
/// **Minimal footer** – version text only:
/// ```dart
/// NovaDrawerFooter(
///   config: NovaFooterConfig(
///     variant: NovaFooterVariant.minimal,
///     appVersion: '2.4.1',
///   ),
/// )
/// ```
///
/// **User card footer** – shows the signed-in user with a settings tap:
/// ```dart
/// NovaDrawerFooter(
///   config: NovaFooterConfig(
///     variant: NovaFooterVariant.userCard,
///     profile: NovaHeaderUserProfile(name: 'Alice', email: 'alice@acme.com'),
///     onSettingsTap: () => Navigator.pushNamed(context, '/settings'),
///   ),
/// )
/// ```
class NovaFooterConfig {
  /// Creates a [NovaFooterConfig].
  const NovaFooterConfig({
    this.variant = NovaFooterVariant.minimal,
    this.appName,
    this.appVersion,
    this.logoWidget,
    this.profile,
    this.actions = const [],
    this.onSettingsTap,
    this.onLogoutTap,
    this.upgradeTitle,
    this.upgradeSubtitle,
    this.upgradeCTALabel,
    this.onUpgradeTap,
    this.gradientColors,
    this.padding,
    this.height,
    this.customFooterBuilder,
    this.legalText,
    this.links = const [],
  });

  /// The visual variant to render.
  final NovaFooterVariant variant;

  /// App name (used in branding and minimal variants).
  final String? appName;

  /// App version string, e.g. `'1.2.0'`.
  final String? appVersion;

  /// Custom logo / icon widget (branding variant).
  final Widget? logoWidget;

  /// Signed-in user profile (userCard variant).
  final NovaHeaderUserProfile? profile;

  /// Action buttons (actions variant).
  final List<NovaFooterAction> actions;

  /// Callback for settings shortcut (userCard variant).
  final VoidCallback? onSettingsTap;

  /// Callback for logout shortcut (userCard / actions variant).
  final VoidCallback? onLogoutTap;

  /// Title shown in the upgrade banner.
  final String? upgradeTitle;

  /// Subtitle / description in the upgrade banner.
  final String? upgradeSubtitle;

  /// Label on the upgrade CTA button.
  final String? upgradeCTALabel;

  /// Callback when the upgrade CTA is tapped.
  final VoidCallback? onUpgradeTap;

  /// Gradient colors for the upgrade banner background (or branding accent).
  final List<Color>? gradientColors;

  /// Content padding override.
  final EdgeInsetsGeometry? padding;

  /// Height override for the footer container.
  final double? height;

  /// Legal / copyright text (minimal variant).
  final String? legalText;

  /// Quick links shown in the minimal footer.
  final List<NovaFooterLink> links;

  /// A custom builder that fully replaces the footer content.
  final Widget Function(BuildContext context, NovaFooterConfig config)?
      customFooterBuilder;

  /// Creates a copy with the given fields replaced.
  NovaFooterConfig copyWith({
    NovaFooterVariant? variant,
    String? appName,
    String? appVersion,
    Widget? logoWidget,
    NovaHeaderUserProfile? profile,
    List<NovaFooterAction>? actions,
    VoidCallback? onSettingsTap,
    VoidCallback? onLogoutTap,
    String? upgradeTitle,
    String? upgradeSubtitle,
    String? upgradeCTALabel,
    VoidCallback? onUpgradeTap,
    List<Color>? gradientColors,
    EdgeInsetsGeometry? padding,
    double? height,
    Widget Function(BuildContext, NovaFooterConfig)? customFooterBuilder,
    String? legalText,
    List<NovaFooterLink>? links,
  }) {
    return NovaFooterConfig(
      variant: variant ?? this.variant,
      appName: appName ?? this.appName,
      appVersion: appVersion ?? this.appVersion,
      logoWidget: logoWidget ?? this.logoWidget,
      profile: profile ?? this.profile,
      actions: actions ?? this.actions,
      onSettingsTap: onSettingsTap ?? this.onSettingsTap,
      onLogoutTap: onLogoutTap ?? this.onLogoutTap,
      upgradeTitle: upgradeTitle ?? this.upgradeTitle,
      upgradeSubtitle: upgradeSubtitle ?? this.upgradeSubtitle,
      upgradeCTALabel: upgradeCTALabel ?? this.upgradeCTALabel,
      onUpgradeTap: onUpgradeTap ?? this.onUpgradeTap,
      gradientColors: gradientColors ?? this.gradientColors,
      padding: padding ?? this.padding,
      height: height ?? this.height,
      customFooterBuilder: customFooterBuilder ?? this.customFooterBuilder,
      legalText: legalText ?? this.legalText,
      links: links ?? this.links,
    );
  }
}

/// A simple hyperlink-style entry for the minimal footer.
class NovaFooterLink {
  /// Creates a [NovaFooterLink].
  const NovaFooterLink({
    required this.label,
    this.onTap,
  });

  /// Display text.
  final String label;

  /// Tap callback.
  final VoidCallback? onTap;
}
