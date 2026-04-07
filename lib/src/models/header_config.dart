// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/widgets.dart';

/// Enum representing the online/offline/busy status of a user.
enum UserStatus {
  /// User is currently online.
  online,

  /// User is currently offline.
  offline,

  /// User is busy / do not disturb.
  busy,

  /// User is away / idle.
  away,

  /// Status is unknown or not set.
  unknown,
}

/// Enum representing the visual variant of a drawer header.
enum HeaderVariant {
  /// Classic profile header with avatar, name, and subtitle.
  classic,

  /// Glassmorphism-style header with blur and transparency.
  glassmorphism,

  /// Compact header for space-constrained layouts.
  compact,

  /// Hero-style header with large cover and prominent avatar.
  hero,

  /// Expanded header with additional details and actions.
  expanded,

  /// Animated gradient background header.
  animatedGradient,

  /// Header showing a stack of multiple user avatars.
  avatarStack,

  /// Header with multiple action buttons.
  multiAction,

  /// Header that shows user status prominently.
  statusAware,

  /// Header that can collapse/expand with animation.
  collapsible,
}

/// Configuration for a header action button.
class HeaderAction {
  /// Creates a header action.
  const HeaderAction({
    required this.id,
    required this.icon,
    this.label,
    this.onTap,
    this.tooltip,
    this.badge,
    this.isDestructive = false,
    this.isEnabled = true,
    this.customWidget,
  });

  /// Unique identifier for this action.
  final String id;

  /// Icon to display.
  final IconData icon;

  /// Optional text label.
  final String? label;

  /// Callback when tapped.
  final VoidCallback? onTap;

  /// Tooltip text for accessibility.
  final String? tooltip;

  /// Optional badge count.
  final int? badge;

  /// Whether this is a destructive action (e.g., logout).
  final bool isDestructive;

  /// Whether this action is enabled.
  final bool isEnabled;

  /// Custom widget to replace default rendering.
  final Widget? customWidget;

  /// Creates a copy with the given fields replaced.
  HeaderAction copyWith({
    String? id,
    IconData? icon,
    String? label,
    VoidCallback? onTap,
    String? tooltip,
    int? badge,
    bool? isDestructive,
    bool? isEnabled,
    Widget? customWidget,
  }) {
    return HeaderAction(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      label: label ?? this.label,
      onTap: onTap ?? this.onTap,
      tooltip: tooltip ?? this.tooltip,
      badge: badge ?? this.badge,
      isDestructive: isDestructive ?? this.isDestructive,
      isEnabled: isEnabled ?? this.isEnabled,
      customWidget: customWidget ?? this.customWidget,
    );
  }
}

/// User account data for the header.
class HeaderUserProfile {
  /// Creates a user profile for the header.
  const HeaderUserProfile({
    required this.name,
    this.email,
    this.role,
    this.subtitle,
    this.phone,
    this.avatarUrl,
    this.avatarWidget,
    this.coverUrl,
    this.coverWidget,
    this.status = UserStatus.unknown,
    this.notificationCount = 0,
    this.metadata = const {},
  });

  /// User display name.
  final String name;

  /// User email address.
  final String? email;

  /// User role or job title.
  final String? role;

  /// Subtitle text (can be any extra info).
  final String? subtitle;

  /// User phone number.
  final String? phone;

  /// URL for the user's avatar image.
  final String? avatarUrl;

  /// Custom widget for the avatar.
  final Widget? avatarWidget;

  /// URL for the cover/banner image.
  final String? coverUrl;

  /// Custom widget for the cover/banner.
  final Widget? coverWidget;

  /// Current user status.
  final UserStatus status;

  /// Number of unread notifications.
  final int notificationCount;

  /// Arbitrary metadata for custom use.
  final Map<String, dynamic> metadata;

  /// The effective subtitle, falling back to email or phone.
  String? get effectiveSubtitle => subtitle ?? email ?? phone;

  /// Creates a copy with the given fields replaced.
  HeaderUserProfile copyWith({
    String? name,
    String? email,
    String? role,
    String? subtitle,
    String? phone,
    String? avatarUrl,
    Widget? avatarWidget,
    String? coverUrl,
    Widget? coverWidget,
    UserStatus? status,
    int? notificationCount,
    Map<String, dynamic>? metadata,
  }) {
    return HeaderUserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      subtitle: subtitle ?? this.subtitle,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarWidget: avatarWidget ?? this.avatarWidget,
      coverUrl: coverUrl ?? this.coverUrl,
      coverWidget: coverWidget ?? this.coverWidget,
      status: status ?? this.status,
      notificationCount: notificationCount ?? this.notificationCount,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Master configuration for the NovaDrawer header system.
///
/// This object holds all the configuration needed to render any header variant.
/// Developers pass this to [NovaDrawerHeader] or individual header variant widgets.
class NovaHeaderConfig {
  /// Creates a header configuration.
  const NovaHeaderConfig({
    this.variant = HeaderVariant.classic,
    this.profile,
    this.actions = const [],
    this.showCloseButton = true,
    this.showPinButton = true,
    this.showEditProfileButton = false,
    this.showStatusIndicator = true,
    this.showNotificationBadge = true,
    this.isLoading = false,
    this.isCollapsed = false,
    this.enableCollapseExpand = false,
    this.onEditProfile,
    this.onSwitchAccount,
    this.onProfileTap,
    this.headerHeight,
    this.collapsedHeaderHeight,
    this.padding,
    this.customHeaderBuilder,
    this.leadingWidget,
    this.trailingWidget,
    this.bottomWidget,
    this.backgroundWidget,
    this.avatarRadius,
    this.collapsedAvatarRadius,
    this.gradientColors,
    this.coverHeight,
    this.accounts = const [],
  });

  /// The visual variant of the header.
  final HeaderVariant variant;

  /// The primary user profile to display.
  final HeaderUserProfile? profile;

  /// Action buttons to display in the header.
  final List<HeaderAction> actions;

  /// Whether to show the close drawer button.
  final bool showCloseButton;

  /// Whether to show the pin/unpin button.
  final bool showPinButton;

  /// Whether to show the edit profile shortcut.
  final bool showEditProfileButton;

  /// Whether to show the status indicator dot.
  final bool showStatusIndicator;

  /// Whether to show the notification badge.
  final bool showNotificationBadge;

  /// Whether the header is in a loading/skeleton state.
  final bool isLoading;

  /// Whether the header is in a collapsed state.
  final bool isCollapsed;

  /// Whether the header supports collapse/expand behavior.
  final bool enableCollapseExpand;

  /// Callback when "edit profile" is tapped.
  final VoidCallback? onEditProfile;

  /// Callback when "switch account" is tapped.
  final VoidCallback? onSwitchAccount;

  /// Callback when the profile area is tapped.
  final VoidCallback? onProfileTap;

  /// Height for the expanded header.
  final double? headerHeight;

  /// Height for the collapsed header.
  final double? collapsedHeaderHeight;

  /// Content padding.
  final EdgeInsetsGeometry? padding;

  /// A custom builder that completely replaces the header content.
  final Widget Function(BuildContext context, NovaHeaderConfig config)?
      customHeaderBuilder;

  /// Widget placed at the leading position.
  final Widget? leadingWidget;

  /// Widget placed at the trailing position.
  final Widget? trailingWidget;

  /// Widget placed at the bottom of the header.
  final Widget? bottomWidget;

  /// Custom background widget for the header.
  final Widget? backgroundWidget;

  /// Radius for the avatar circle.
  final double? avatarRadius;

  /// Radius for the avatar in collapsed state.
  final double? collapsedAvatarRadius;

  /// Colors for gradient-based headers.
  final List<Color>? gradientColors;

  /// Height of the cover/banner area.
  final double? coverHeight;

  /// Additional accounts for account switcher.
  final List<HeaderUserProfile> accounts;

  /// Creates a copy with the given fields replaced.
  NovaHeaderConfig copyWith({
    HeaderVariant? variant,
    HeaderUserProfile? profile,
    List<HeaderAction>? actions,
    bool? showCloseButton,
    bool? showPinButton,
    bool? showEditProfileButton,
    bool? showStatusIndicator,
    bool? showNotificationBadge,
    bool? isLoading,
    bool? isCollapsed,
    bool? enableCollapseExpand,
    VoidCallback? onEditProfile,
    VoidCallback? onSwitchAccount,
    VoidCallback? onProfileTap,
    double? headerHeight,
    double? collapsedHeaderHeight,
    EdgeInsetsGeometry? padding,
    Widget Function(BuildContext, NovaHeaderConfig)? customHeaderBuilder,
    Widget? leadingWidget,
    Widget? trailingWidget,
    Widget? bottomWidget,
    Widget? backgroundWidget,
    double? avatarRadius,
    double? collapsedAvatarRadius,
    List<Color>? gradientColors,
    double? coverHeight,
    List<HeaderUserProfile>? accounts,
  }) {
    return NovaHeaderConfig(
      variant: variant ?? this.variant,
      profile: profile ?? this.profile,
      actions: actions ?? this.actions,
      showCloseButton: showCloseButton ?? this.showCloseButton,
      showPinButton: showPinButton ?? this.showPinButton,
      showEditProfileButton:
          showEditProfileButton ?? this.showEditProfileButton,
      showStatusIndicator: showStatusIndicator ?? this.showStatusIndicator,
      showNotificationBadge:
          showNotificationBadge ?? this.showNotificationBadge,
      isLoading: isLoading ?? this.isLoading,
      isCollapsed: isCollapsed ?? this.isCollapsed,
      enableCollapseExpand:
          enableCollapseExpand ?? this.enableCollapseExpand,
      onEditProfile: onEditProfile ?? this.onEditProfile,
      onSwitchAccount: onSwitchAccount ?? this.onSwitchAccount,
      onProfileTap: onProfileTap ?? this.onProfileTap,
      headerHeight: headerHeight ?? this.headerHeight,
      collapsedHeaderHeight:
          collapsedHeaderHeight ?? this.collapsedHeaderHeight,
      padding: padding ?? this.padding,
      customHeaderBuilder: customHeaderBuilder ?? this.customHeaderBuilder,
      leadingWidget: leadingWidget ?? this.leadingWidget,
      trailingWidget: trailingWidget ?? this.trailingWidget,
      bottomWidget: bottomWidget ?? this.bottomWidget,
      backgroundWidget: backgroundWidget ?? this.backgroundWidget,
      avatarRadius: avatarRadius ?? this.avatarRadius,
      collapsedAvatarRadius:
          collapsedAvatarRadius ?? this.collapsedAvatarRadius,
      gradientColors: gradientColors ?? this.gradientColors,
      coverHeight: coverHeight ?? this.coverHeight,
      accounts: accounts ?? this.accounts,
    );
  }
}
