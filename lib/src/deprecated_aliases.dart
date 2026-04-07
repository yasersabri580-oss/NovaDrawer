// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

/// Deprecated aliases for backward compatibility.
///
/// These typedefs map old class names to their new Nova-prefixed equivalents.
/// They are annotated with `@Deprecated` and will be removed in a future
/// major version. Migrate to the new names as soon as possible.
library;

import 'package:flutter/material.dart';

// Re-export all new names so the typedefs can resolve.
import 'models/drawer_item.dart';
import 'models/drawer_theme.dart';
import 'models/drawer_config.dart';
import 'models/header_config.dart';
import 'models/surface_config.dart';
import 'models/content_config.dart';
import 'controllers/drawer_controller.dart';
import 'widgets/advanced_app_drawer.dart';
import 'widgets/drawer_header.dart';
import 'widgets/drawer_item_widget.dart';
import 'widgets/drawer_section.dart';
import 'widgets/nested_menu_item.dart';
import 'widgets/mini_drawer.dart';
import 'widgets/drawer_scaffold.dart';
import 'widgets/drawer_stats_card.dart';
import 'widgets/drawer_shortcuts_grid.dart';
import 'widgets/drawer_recent_items.dart';
import 'widgets/drawer_filter_chips.dart';
import 'widgets/drawer_app_status.dart';
import 'widgets/drawer_workspace_switcher.dart';
import 'animations/animation_config.dart';
import 'animations/animation_wrapper.dart';
import 'builders/drawer_builders.dart';
import 'backgrounds/gradient_background.dart';
import 'backgrounds/particle_background.dart';
import 'utils/responsive_utils.dart';
import 'utils/accessibility_utils.dart';
import 'headers/header_utils.dart';

// ── Models ────────────────────────────────────────────────────────────────

/// Use [NovaDrawerItem] instead.
@Deprecated('Use NovaDrawerItem instead. Will be removed in v2.0.0.')
typedef DrawerItem = NovaDrawerItem;

/// Use [NovaDrawerItemBadge] instead.
@Deprecated('Use NovaDrawerItemBadge instead. Will be removed in v2.0.0.')
typedef DrawerItemBadge = NovaDrawerItemBadge;

/// Use [NovaDrawerSectionData] instead.
@Deprecated('Use NovaDrawerSectionData instead. Will be removed in v2.0.0.')
typedef DrawerSectionData = NovaDrawerSectionData;

/// Use [NovaDrawerTheme] instead.
@Deprecated('Use NovaDrawerTheme instead. Will be removed in v2.0.0.')
typedef AdvancedDrawerTheme = NovaDrawerTheme;

/// Use [NovaDrawerBadgeTheme] instead.
@Deprecated('Use NovaDrawerBadgeTheme instead. Will be removed in v2.0.0.')
typedef DrawerBadgeTheme = NovaDrawerBadgeTheme;

/// Use [NovaDrawerScrollbarTheme] instead.
@Deprecated('Use NovaDrawerScrollbarTheme instead. Will be removed in v2.0.0.')
typedef DrawerScrollbarTheme = NovaDrawerScrollbarTheme;

/// Use [NovaDrawerConfig] instead.
@Deprecated('Use NovaDrawerConfig instead. Will be removed in v2.0.0.')
typedef DrawerConfig = NovaDrawerConfig;

/// Use [NovaDrawerBreakpoints] instead.
@Deprecated('Use NovaDrawerBreakpoints instead. Will be removed in v2.0.0.')
typedef DrawerBreakpoints = NovaDrawerBreakpoints;

/// Use [NovaDrawerGestureConfig] instead.
@Deprecated('Use NovaDrawerGestureConfig instead. Will be removed in v2.0.0.')
typedef DrawerGestureConfig = NovaDrawerGestureConfig;

/// Use [NovaDrawerAccessibilityConfig] instead.
@Deprecated(
    'Use NovaDrawerAccessibilityConfig instead. Will be removed in v2.0.0.')
typedef DrawerAccessibilityConfig = NovaDrawerAccessibilityConfig;

/// Use [NovaDrawerAutoHideConfig] instead.
@Deprecated(
    'Use NovaDrawerAutoHideConfig instead. Will be removed in v2.0.0.')
typedef DrawerAutoHideConfig = NovaDrawerAutoHideConfig;

/// Use [NovaHeaderUserProfile] instead.
@Deprecated('Use NovaHeaderUserProfile instead. Will be removed in v2.0.0.')
typedef HeaderUserProfile = NovaHeaderUserProfile;

/// Use [NovaHeaderAction] instead.
@Deprecated('Use NovaHeaderAction instead. Will be removed in v2.0.0.')
typedef HeaderAction = NovaHeaderAction;

/// Use [NovaDrawerSurfaceConfig] instead.
@Deprecated(
    'Use NovaDrawerSurfaceConfig instead. Will be removed in v2.0.0.')
typedef DrawerSurfaceConfig = NovaDrawerSurfaceConfig;

/// Use [NovaDrawerSurface] instead.
@Deprecated('Use NovaDrawerSurface instead. Will be removed in v2.0.0.')
typedef DrawerSurface = NovaDrawerSurface;

/// Use [NovaDrawerStatItem] instead.
@Deprecated('Use NovaDrawerStatItem instead. Will be removed in v2.0.0.')
typedef DrawerStatItem = NovaDrawerStatItem;

/// Use [NovaDrawerShortcut] instead.
@Deprecated('Use NovaDrawerShortcut instead. Will be removed in v2.0.0.')
typedef DrawerShortcut = NovaDrawerShortcut;

/// Use [NovaDrawerRecentItem] instead.
@Deprecated('Use NovaDrawerRecentItem instead. Will be removed in v2.0.0.')
typedef DrawerRecentItem = NovaDrawerRecentItem;

/// Use [NovaDrawerFilterChip] instead.
@Deprecated('Use NovaDrawerFilterChip instead. Will be removed in v2.0.0.')
typedef DrawerFilterChip = NovaDrawerFilterChip;

/// Use [NovaDrawerAppStatus] instead.
@Deprecated('Use NovaDrawerAppStatus instead. Will be removed in v2.0.0.')
typedef DrawerAppStatus = NovaDrawerAppStatus;

/// Use [NovaDrawerWorkspace] instead.
@Deprecated('Use NovaDrawerWorkspace instead. Will be removed in v2.0.0.')
typedef DrawerWorkspace = NovaDrawerWorkspace;

// ── Controllers ───────────────────────────────────────────────────────────

/// Use [NovaDrawerController] instead.
@Deprecated('Use NovaDrawerController instead. Will be removed in v2.0.0.')
typedef AdvancedDrawerController = NovaDrawerController;

/// Use [NovaDrawerControllerProvider] instead.
@Deprecated(
    'Use NovaDrawerControllerProvider instead. Will be removed in v2.0.0.')
typedef DrawerControllerProvider = NovaDrawerControllerProvider;

// ── Widgets ───────────────────────────────────────────────────────────────

/// Use [NovaAppDrawer] instead.
@Deprecated('Use NovaAppDrawer instead. Will be removed in v2.0.0.')
typedef AdvancedAppDrawer = NovaAppDrawer;

/// Use [NovaDrawerHeaderWidget] instead.
@Deprecated(
    'Use NovaDrawerHeaderWidget instead. Will be removed in v2.0.0.')
typedef DrawerHeaderWidget = NovaDrawerHeaderWidget;

/// Use [NovaDrawerItemWidget] instead.
@Deprecated('Use NovaDrawerItemWidget instead. Will be removed in v2.0.0.')
typedef DrawerItemWidget = NovaDrawerItemWidget;

/// Use [NovaDrawerSectionWidget] instead.
@Deprecated(
    'Use NovaDrawerSectionWidget instead. Will be removed in v2.0.0.')
typedef DrawerSectionWidget = NovaDrawerSectionWidget;

/// Use [NovaNestedMenuItem] instead.
@Deprecated('Use NovaNestedMenuItem instead. Will be removed in v2.0.0.')
typedef NestedMenuItem = NovaNestedMenuItem;

/// Use [NovaMiniDrawer] instead.
@Deprecated('Use NovaMiniDrawer instead. Will be removed in v2.0.0.')
typedef MiniDrawerWidget = NovaMiniDrawer;

/// Use [NovaDrawerScaffold] instead.
@Deprecated('Use NovaDrawerScaffold instead. Will be removed in v2.0.0.')
typedef DrawerScaffoldWidget = NovaDrawerScaffold;

/// Use [NovaDrawerStatsCard] instead.
@Deprecated('Use NovaDrawerStatsCard instead. Will be removed in v2.0.0.')
typedef DrawerStatsCard = NovaDrawerStatsCard;

/// Use [NovaDrawerShortcutsGrid] instead.
@Deprecated(
    'Use NovaDrawerShortcutsGrid instead. Will be removed in v2.0.0.')
typedef DrawerShortcutsGrid = NovaDrawerShortcutsGrid;

/// Use [NovaDrawerRecentItems] instead.
@Deprecated('Use NovaDrawerRecentItems instead. Will be removed in v2.0.0.')
typedef DrawerRecentItems = NovaDrawerRecentItems;

/// Use [NovaDrawerFilterChipsWidget] instead.
@Deprecated(
    'Use NovaDrawerFilterChipsWidget instead. Will be removed in v2.0.0.')
typedef DrawerFilterChips = NovaDrawerFilterChipsWidget;

/// Use [NovaDrawerAppStatusWidget] instead.
@Deprecated(
    'Use NovaDrawerAppStatusWidget instead. Will be removed in v2.0.0.')
typedef DrawerAppStatusWidget = NovaDrawerAppStatusWidget;

/// Use [NovaDrawerWorkspaceSwitcher] instead.
@Deprecated(
    'Use NovaDrawerWorkspaceSwitcher instead. Will be removed in v2.0.0.')
typedef DrawerWorkspaceSwitcher = NovaDrawerWorkspaceSwitcher;

// ── Configs & Animations ──────────────────────────────────────────────────

/// Use [NovaDrawerAnimationConfig] instead.
@Deprecated(
    'Use NovaDrawerAnimationConfig instead. Will be removed in v2.0.0.')
typedef DrawerAnimationConfig = NovaDrawerAnimationConfig;

/// Use [NovaDrawerAnimationWrapper] instead.
@Deprecated(
    'Use NovaDrawerAnimationWrapper instead. Will be removed in v2.0.0.')
typedef DrawerAnimationWrapper = NovaDrawerAnimationWrapper;

/// Use [NovaDrawerBuilders] instead.
@Deprecated('Use NovaDrawerBuilders instead. Will be removed in v2.0.0.')
typedef DrawerBuilders = NovaDrawerBuilders;

// ── Backgrounds ───────────────────────────────────────────────────────────

/// Use [NovaGradientBackground] instead.
@Deprecated(
    'Use NovaGradientBackground instead. Will be removed in v2.0.0.')
typedef DrawerGradientBackground = NovaGradientBackground;

/// Use [NovaParticleBackground] instead.
@Deprecated(
    'Use NovaParticleBackground instead. Will be removed in v2.0.0.')
typedef DrawerParticleBackground = NovaParticleBackground;

// ── Utils ─────────────────────────────────────────────────────────────────

/// Use [NovaResponsiveUtils] instead.
@Deprecated('Use NovaResponsiveUtils instead. Will be removed in v2.0.0.')
typedef ResponsiveUtils = NovaResponsiveUtils;

/// Use [NovaAccessibilityUtils] instead.
@Deprecated(
    'Use NovaAccessibilityUtils instead. Will be removed in v2.0.0.')
typedef AccessibilityUtils = NovaAccessibilityUtils;

/// Use [NovaResponsiveDrawerData] instead.
@Deprecated(
    'Use NovaResponsiveDrawerData instead. Will be removed in v2.0.0.')
typedef ResponsiveDrawerData = NovaResponsiveDrawerData;

/// Use [NovaHeaderWidgetUtils] instead.
@Deprecated(
    'Use NovaHeaderWidgetUtils instead. Will be removed in v2.0.0.')
typedef HeaderWidgetUtils = NovaHeaderWidgetUtils;
