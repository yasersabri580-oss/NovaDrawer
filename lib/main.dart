// Copyright (c) 2024 AdvancedAppDrawer Contributors
// Licensed under the MIT License.

/// AdvancedAppDrawer - A modern, fully dynamic, and highly responsive
/// app drawer component for Flutter.
///
/// This library provides a comprehensive drawer navigation system with:
/// - Responsive layout (mobile, tablet, desktop)
/// - 10+ animation types
/// - RTL support
/// - Nested/multi-level menus
/// - Dynamic data loading
/// - Accessibility support
/// - Theming and customization
/// - Mini-drawer mode
/// - Gesture controls
/// - Background effects
library advanced_app_drawer;

// ── Models ──────────────────────────────────────────────────────────────
export 'src/models/drawer_item.dart';
export 'src/models/drawer_theme.dart';
export 'src/models/drawer_config.dart';

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
export 'src/animations/gradient_animation.dart';

// ── Utilities ───────────────────────────────────────────────────────────
export 'src/utils/responsive_utils.dart';
export 'src/utils/accessibility_utils.dart';

// ── Backgrounds ─────────────────────────────────────────────────────────
export 'src/backgrounds/gradient_background.dart';
export 'src/backgrounds/particle_background.dart';
