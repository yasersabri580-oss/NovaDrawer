// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

import 'package:flutter/widgets.dart';

/// A stat item displayed in a user stats card.
class DrawerStatItem {
  /// Creates a stat item.
  const DrawerStatItem({
    required this.label,
    required this.value,
    this.icon,
    this.onTap,
  });

  /// The label for this stat (e.g., "Projects").
  final String label;

  /// The value to display (e.g., "42").
  final String value;

  /// Optional icon for the stat.
  final IconData? icon;

  /// Callback when tapped.
  final VoidCallback? onTap;
}

/// A shortcut item for the shortcuts grid.
class DrawerShortcut {
  /// Creates a shortcut item.
  const DrawerShortcut({
    required this.id,
    required this.label,
    required this.icon,
    this.onTap,
    this.color,
    this.badge,
  });

  /// Unique identifier.
  final String id;

  /// Display label.
  final String label;

  /// Icon to show.
  final IconData icon;

  /// Callback when tapped.
  final VoidCallback? onTap;

  /// Optional accent color.
  final Color? color;

  /// Optional badge count.
  final int? badge;
}

/// A recent item entry.
class DrawerRecentItem {
  /// Creates a recent item.
  const DrawerRecentItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.icon,
    this.timestamp,
    this.onTap,
  });

  /// Unique identifier.
  final String id;

  /// Title text.
  final String title;

  /// Subtitle text.
  final String? subtitle;

  /// Icon for this item.
  final IconData? icon;

  /// When this item was last accessed.
  final DateTime? timestamp;

  /// Callback when tapped.
  final VoidCallback? onTap;
}

/// A filter chip for the drawer search/filter system.
class DrawerFilterChip {
  /// Creates a filter chip.
  const DrawerFilterChip({
    required this.id,
    required this.label,
    this.isSelected = false,
    this.onSelected,
    this.icon,
    this.color,
  });

  /// Unique identifier.
  final String id;

  /// Display label.
  final String label;

  /// Whether this chip is selected.
  final bool isSelected;

  /// Callback when selection changes.
  final ValueChanged<bool>? onSelected;

  /// Optional icon.
  final IconData? icon;

  /// Optional color.
  final Color? color;
}

/// App health / connection status for display in the drawer.
class DrawerAppStatus {
  /// Creates an app status indicator.
  const DrawerAppStatus({
    this.isOnline = true,
    this.statusMessage,
    this.version,
    this.buildNumber,
    this.customWidget,
  });

  /// Whether the app is online.
  final bool isOnline;

  /// Optional status message.
  final String? statusMessage;

  /// App version string.
  final String? version;

  /// App build number.
  final String? buildNumber;

  /// Custom widget for the status display.
  final Widget? customWidget;
}

/// A workspace or account for switching.
class DrawerWorkspace {
  /// Creates a workspace item.
  const DrawerWorkspace({
    required this.id,
    required this.name,
    this.icon,
    this.avatarUrl,
    this.isActive = false,
    this.onSelect,
  });

  /// Unique identifier.
  final String id;

  /// Display name.
  final String name;

  /// Optional icon.
  final IconData? icon;

  /// Optional avatar URL.
  final String? avatarUrl;

  /// Whether this workspace is currently active.
  final bool isActive;

  /// Callback when selected.
  final VoidCallback? onSelect;
}
