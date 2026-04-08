// Copyright (c) 2026 NovaDrawer Contributors
// Licensed under the MIT License.

/// NovaDrawer – A modern, fully dynamic, and highly responsive
/// app drawer component for Flutter.
///
/// This library provides a comprehensive drawer navigation system with:
/// - Responsive layout (mobile, tablet, desktop)
/// - 16+ animation types (including floating, wave, parallax, and curtain)
/// - Advanced modular header system with 10 variants
/// - Drawer surface styles (glassmorphism, neumorphic, gradient, etc.)
/// - Content blocks (search powered by search_plus, stats, shortcuts, etc.)
/// - RTL support
/// - Nested/multi-level menus
/// - Dynamic data loading
/// - Accessibility support
/// - Theming and customization
/// - Mini-drawer mode
/// - Gesture controls
/// - Background effects
/// - Slot-based builder APIs for deep customization
library;

// ── Models ──────────────────────────────────────────────────────────────
export 'src/models/drawer_item.dart';
export 'src/models/drawer_theme.dart';
export 'src/models/drawer_config.dart';
export 'src/models/header_config.dart';
export 'src/models/surface_config.dart';
export 'src/models/content_config.dart';

// ── Controllers ─────────────────────────────────────────────────────────
export 'src/controllers/drawer_controller.dart';

// ── Widgets ─────────────────────────────────────────────────────────────
export 'src/widgets/advanced_app_drawer.dart';
export 'src/widgets/drawer_header.dart';
export 'src/widgets/drawer_item_widget.dart';
export 'src/widgets/drawer_section.dart';
export 'src/widgets/nested_menu_item.dart';
export 'src/widgets/mini_drawer.dart';
export 'src/widgets/drawer_scaffold.dart';

export 'src/widgets/drawer_stats_card.dart';
export 'src/widgets/drawer_shortcuts_grid.dart';
export 'src/widgets/drawer_recent_items.dart';
export 'src/widgets/drawer_filter_chips.dart';
export 'src/widgets/drawer_app_status.dart';
export 'src/widgets/drawer_workspace_switcher.dart';

// ── Headers ─────────────────────────────────────────────────────────────
export 'src/headers/header_utils.dart';
export 'src/headers/nova_drawer_header.dart';
export 'src/headers/profile_header_classic.dart';
export 'src/headers/profile_header_glassmorphism.dart';
export 'src/headers/profile_header_compact.dart';
export 'src/headers/profile_header_hero.dart';
export 'src/headers/profile_header_expanded.dart';
export 'src/headers/profile_header_animated_gradient.dart';
export 'src/headers/profile_header_avatar_stack.dart';
export 'src/headers/profile_header_multi_action.dart';
export 'src/headers/profile_header_status_aware.dart';
export 'src/headers/profile_header_collapsible.dart';

// ── Builders ────────────────────────────────────────────────────────────
export 'src/builders/drawer_builders.dart';

// ── Animations ──────────────────────────────────────────────────────────
export 'src/animations/animation_config.dart';
export 'src/animations/animation_wrapper.dart';
export 'src/animations/slide_animation.dart';
export 'src/animations/fade_animation.dart';
export 'src/animations/scale_animation.dart';
export 'src/animations/rotate_animation.dart';
export 'src/animations/morph_animation.dart';
export 'src/animations/elastic_animation.dart';
export 'src/animations/spring_animation.dart';
export 'src/animations/shimmer_animation.dart';
export 'src/animations/blur_animation.dart';
export 'src/animations/floating_animation.dart';
export 'src/animations/gradient_animation.dart';
export 'src/animations/wave_animation.dart';

// ── Utilities ───────────────────────────────────────────────────────────
export 'src/utils/responsive_utils.dart';
export 'src/utils/accessibility_utils.dart';

// ── Backgrounds ─────────────────────────────────────────────────────────
export 'src/backgrounds/gradient_background.dart';
export 'src/backgrounds/particle_background.dart';

// ── Deprecated Aliases (backward compatibility) ─────────────────────────
export 'src/deprecated_aliases.dart';

// ── Re-export search_plus for convenience ───────────────────────────────
export 'package:search_plus/search_plus.dart';
